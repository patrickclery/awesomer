# frozen_string_literal: true

class GithubRateLimiterService
  include Dry::Monads[:result]

  # GitHub API limits: 5000 requests per hour for authenticated users
  # We'll be conservative and use 4000 requests per hour (1.1 requests per second)
  RATE_LIMIT_WINDOW = 3600 # 1 hour in seconds
  RATE_LIMIT_COUNT = 4000  # Max requests per hour
  REDIS_KEY_PREFIX = "github_rate_limit"
  MIN_DELAY_BETWEEN_REQUESTS = 0.9  # Minimum seconds between requests (1.1 req/sec max)

  def initialize(redis_client: REDIS_RATE_LIMIT)
    @redis = redis_client
  end

  def can_make_request?
    current_time = Time.current.to_i
    window_start = current_time - RATE_LIMIT_WINDOW

    # Clean up old entries
    @redis.zremrangebyscore(redis_key, 0, window_start)

    # Count current requests in the window
    current_count = @redis.zcard(redis_key)

    current_count < RATE_LIMIT_COUNT
  rescue Redis::BaseError => e
    # If Redis is down, we'll allow the request but log the error
    Rails.logger.error "Redis error in GithubRateLimiterService: #{e.message}"
    true # Allow the request if Redis is down
  end

  def record_request(success: true)
    current_time = Time.current.to_i

    # Add current request to the sorted set with timestamp as score
    @redis.zadd(redis_key, current_time, "#{current_time}_#{SecureRandom.hex(8)}")

    # Set expiration for the key (cleanup)
    @redis.expire(redis_key, RATE_LIMIT_WINDOW + 60)

    Success(true)
  rescue Redis::BaseError => e
    # If Redis is down, we'll allow the request but log the error
    Rails.logger.error "Redis error in GithubRateLimiterService: #{e.message}"
    Success(true)
  end

  def requests_remaining
    current_time = Time.current.to_i
    window_start = current_time - RATE_LIMIT_WINDOW

    # Clean up old entries
    @redis.zremrangebyscore(redis_key, 0, window_start)

    # Count current requests in the window
    current_count = @redis.zcard(redis_key)

    [ RATE_LIMIT_COUNT - current_count, 0 ].max
  rescue Redis::BaseError => e
    Rails.logger.error "Redis error in GithubRateLimiterService: #{e.message}"
    RATE_LIMIT_COUNT # If Redis is down, assume we have full capacity
  end

  def time_until_reset
    current_time = Time.current.to_i
    window_start = current_time - RATE_LIMIT_WINDOW

    # Get the oldest request in the current window
    oldest_request = @redis.zrange(redis_key, 0, 0, with_scores: true).first

    if oldest_request
      oldest_timestamp = oldest_request[1].to_i
      time_until_oldest_expires = (oldest_timestamp + RATE_LIMIT_WINDOW) - current_time
      [ time_until_oldest_expires, 0 ].max
    else
      0 # No requests in window, can make request immediately
    end
  rescue Redis::BaseError => e
    Rails.logger.error "Redis error in GithubRateLimiterService: #{e.message}"
    0 # If Redis is down, assume we can make request immediately
  end

  def wait_if_needed
    # Check if we should wait before making the next request
    unless can_make_request?
      wait_time = time_until_reset
      if wait_time > 0
        Rails.logger.info "Rate limit reached, waiting #{wait_time} seconds..."
        sleep(wait_time)
      end
    end
    
    # Always add a minimum delay to avoid bursting
    sleep(MIN_DELAY_BETWEEN_REQUESTS)
  end

  private

  def redis_key
    "#{REDIS_KEY_PREFIX}:requests"
  end
end
