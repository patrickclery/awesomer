# Github API Rate Limiting Implementation

This document describes the comprehensive rate limiting solution implemented for Github API requests using [solid_queue](https://github.com/rails/solid_queue) as the background job processor.

## Overview

The rate limiting system prevents the application from exceeding Github's API limits (5,000 requests per hour for authenticated users) by:

1. **Asynchronous Processing**: All Github API calls are processed in background jobs
2. **Rate Limiting**: Redis-based sliding window rate limiting (conservative 4,000 requests/hour)
3. **Caching**: 1-day caching of repository statistics to minimize API calls
4. **Retry Logic**: Intelligent retry mechanisms for rate limit and network errors
5. **Monitoring**: Database tracking of all API requests for monitoring and debugging

## Architecture

### Components

1. **`SyncGitStatsOperation`**: Entry point that queues background jobs instead of making direct API calls
2. **`ProcessMarkdownWithStatsJob`**: Orchestrates the processing by queueing individual repository stats jobs
3. **`FetchGithubStatsJob`**: Fetches stats for individual repositories with rate limiting and caching
4. **`GenerateMarkdownJob`**: Collects cached stats and generates the final markdown output
5. **`GithubRateLimiterService`**: Redis-based rate limiting service
6. **`GithubApiRequest`**: Database model for tracking API requests

### Flow

```
SyncGitStatsOperation
    ↓ (queues job)
ProcessMarkdownWithStatsJob
    ↓ (queues multiple jobs)
FetchGithubStatsJob (for each repo)
    ↓ (after delay)
GenerateMarkdownJob
    ↓
Final markdown output
```

## Configuration

### Redis Configuration

```ruby
# config/initializers/redis.rb
REDIS_RATE_LIMIT = Redis.new(
  url: ENV.fetch("REDIS_URL", "redis://localhost:6379/1"),
  timeout: 1
)
```

### Solid Queue Configuration

```yaml
# config/queue.yml
default: &default
  dispatchers:
    - polling_interval: 1
      batch_size: 500
  workers:
    - queues: "github_stats"
      threads: 2
      processes: 1
      polling_interval: 1
    - queues: "markdown_processing"
      threads: 1
      processes: 1
      polling_interval: 5
    - queues: "default"
      threads: 3
      processes: 1
      polling_interval: 0.1
```

## Rate Limiting Details

### Github API Limits

- **Authenticated requests**: 5,000 per hour
- **Conservative limit**: 4,000 per hour (implemented)
- **Window**: 1 hour sliding window
- **Implementation**: Redis sorted sets with timestamps

### Rate Limiter Service

```ruby
# Check if request can be made
rate_limiter.can_make_request? # => true/false

# Record a request
rate_limiter.record_request(success: true)

# Get remaining requests
rate_limiter.requests_remaining # => 3999

# Get time until reset
rate_limiter.time_until_reset # => 1800 (seconds)
```

### Fallback Behavior

- If Redis is unavailable, requests are allowed (fail-open)
- Errors are logged for monitoring
- Database tracking continues independently

## Caching Strategy

### Repository Stats Caching

- **Cache key**: `github_stats:owner:repo_name`
- **Expiration**: 1 day
- **Storage**: Rails cache (configurable backend)

### Category Item Updates

- **Cache key**: `category_item_update:item_id_or_url`
- **Expiration**: 1 hour
- **Purpose**: Temporary storage for job coordination

## Error Handling

### Github API Errors

1. **Rate Limiting (429)**: Retry with exponential backoff
2. **Not Found (404)**: Log warning, continue processing
3. **Network Errors**: Retry with exponential backoff
4. **Other API Errors**: Log error, retry with backoff

### Job Retry Logic

```ruby
# Exponential backoff for most errors
retry_on StandardError, wait: :exponentially_longer, attempts: 5

# Custom retry for rate limits
if rate_limited?
  retry_job(wait: retry_after.seconds)
end
```

## Monitoring

### Database Tracking

All API requests are tracked in the `github_api_requests` table:

```ruby
# Recent requests
GithubApiRequest.recent(1.hour)

# Success rate
GithubApiRequest.successful.count / GithubApiRequest.count.to_f

# Rate limit compliance
GithubApiRequest.within_rate_limit?
```

### Queue Monitoring

```ruby
# Pending jobs
SolidQueue::Job.pending.count

# Failed jobs
SolidQueue::Job.failed.count

# Job status by queue
SolidQueue::Job.group(:queue_name).count
```

## Usage

### Basic Usage

```ruby
# Process categories asynchronously
operation = SyncGitStatsOperation.new
result = operation.call(categories: categories)

# Returns immediately with original categories
# Stats are fetched in background jobs
```

### ProcessCategoryService Integration

```ruby
# Synchronous processing (original behavior)
ProcessCategoryService.new.call(categories: categories)

# Asynchronous processing (new behavior)
ProcessCategoryService.new.call(categories: categories, async: true)
```

### Manual Job Processing

```bash
# Start job workers
bin/jobs

# Demo the rate limiting system
bin/demo_rate_limiting
```

## Environment Variables

```bash
# Required for API access
GITHUB_API_KEY=your_github_personal_access_token

# Optional Redis configuration
REDIS_URL=redis://localhost:6379/1

# Optional job concurrency
JOB_CONCURRENCY=1
```

## Testing

### Rate Limiter Service

```bash
bundle exec rspec spec/services/github_rate_limiter_service_spec.rb
```

### Background Jobs

```bash
bundle exec rspec spec/jobs/fetch_github_stats_job_spec.rb
```

### Integration

```bash
bundle exec rspec spec/operations/sync_git_stats_operation_spec.rb
```

### VCR Cassettes

- Github API interactions are recorded using VCR
- Cassettes stored in `spec/cassettes/github/`
- Rate limiting tests use mocked Redis

## Performance Considerations

### Throughput

- **Conservative rate**: ~1.1 requests/second
- **Parallel processing**: 2 threads for GitHub stats jobs
- **Caching**: Reduces API calls by ~90% for repeated processing

### Scaling

- **Horizontal**: Add more worker processes
- **Vertical**: Increase thread count per worker
- **Redis**: Can be clustered for high availability

### Memory Usage

- **Job serialization**: Categories converted to hashes
- **Cache storage**: Configurable backend (Redis, Memcached, etc.)
- **Database**: Periodic cleanup of old API request records

## Troubleshooting

### Common Issues

1. **Redis connection errors**: Check Redis availability and configuration
2. **Rate limit exceeded**: Verify conservative limits and request patterns
3. **Job failures**: Check logs and failed job queue
4. **Cache misses**: Verify cache backend configuration

### Debugging

```ruby
# Check rate limiter status
rate_limiter = GithubRateLimiterService.new
puts "Can make request: #{rate_limiter.can_make_request?}"
puts "Remaining: #{rate_limiter.requests_remaining}"

# Check recent API requests
GithubApiRequest.recent.order(:requested_at).each do |req|
  puts "#{req.requested_at} - #{req.endpoint} (#{req.response_status})"
end

# Check job queue
puts "Pending: #{SolidQueue::Job.pending.count}"
puts "Failed: #{SolidQueue::Job.failed.count}"
```

## Migration from Synchronous Processing

The implementation maintains backward compatibility:

1. **`SyncGitStatsOperation`** now returns original categories immediately
2. **Background processing** is queued automatically
3. **Tests updated** to reflect asynchronous behavior
4. **ProcessCategoryService** supports both sync and async modes

This allows for gradual migration and testing of the new system while maintaining existing functionality. 