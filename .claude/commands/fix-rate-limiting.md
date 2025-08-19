---
name: fix-rate-limiting
description: Run awesome list updates and automatically fix rate limiting issues
---

# Fix Rate Limiting Command

This command will:

1. Attempt to update all awesome lists and their items
2. Monitor for rate limiting issues
3. Automatically fix code to prevent rate limiting
4. Retry the process until successful

## Process

1. **Initial Run**: Start by running the bootstrap command to process all awesome lists
   ```bash
   bundle exec rails runner "BootstrapAwesomeListsService.new.call"
   ```

2. **Monitor Output**: Watch for rate limiting errors such as:
  - "API rate limit exceeded"
  - "429 Too Many Requests"
  - "Secondary rate limit"
  - Faraday::TooManyRequestsError
  - Octokit::TooManyRequests

3. **Identify Issues**: When rate limiting occurs, analyze:
  - Which operation triggered the limit
  - Current rate limiting implementation in `app/services/github_rate_limiter_service.rb`
  - Retry logic in operations that make GitHub API calls
  - Batch processing delays

4. **Fix Implementation**: Make improvements such as:
  - Increase delays between API calls
  - Implement exponential backoff
  - Add better rate limit checking before requests
  - Implement request queuing
  - Add caching for frequently accessed data
  - Batch requests more efficiently
  - Use conditional requests with ETags where possible

5. **Test Fix**: After making changes:
  - Run the specs to ensure nothing is broken:
    ```bash
    bundle exec rspec spec/services/github_rate_limiter_service_spec.rb
    bundle exec rspec spec/operations/sync_git_stats_operation_spec.rb
    ```

6. **Retry Process**: Run the bootstrap command again and monitor for issues

7. **Iterate**: Continue the loop until all awesome lists are successfully processed without rate limiting

## Key Files to Review/Modify

- `app/services/github_rate_limiter_service.rb` - Main rate limiting service
- `app/operations/sync_git_stats_operation.rb` - Fetches GitHub stats
- `app/operations/fetch_readme_operation.rb` - Fetches README content
- `app/services/process_awesome_list_service.rb` - Main processing orchestrator
- `config/initializers/redis.rb` - Redis configuration for rate limit tracking

## Success Criteria

The command is successful when:

- All awesome lists in `config/repos.yml` are processed
- No rate limiting errors occur
- All items have their GitHub stats synced
- The `awesome_lists` table shows all records in 'completed' state
- **No empty star counts**: Verify that repository statistics are actually populated by checking that items aren't full of empty/zero star counts (which would indicate the sync didn't actually update the data)

## Monitoring Progress

Check progress with:

```ruby
AwesomeList.group(:state).count
AwesomeList.where(state: 'failed').pluck(:github_repo, :updated_at)

# Check for empty star counts to ensure updates actually worked
CategoryItem.joins(:repo_stat).where(repo_stats: { stars_count: 0 }).count
CategoryItem.joins(:repo_stat).where(repo_stats: { stars_count: nil }).count
CategoryItem.left_joins(:repo_stat).where(repo_stats: { id: nil }).count

# Get a sample of star counts to verify they're populated
RepoStat.pluck(:stars_count).sample(20)
```

## Verification Loop

After each run, check that stats are actually being updated:

1. **Count empty stats**: If many items still have zero or null star counts, the sync may not be working properly
2. **Sample verification**: Check a random sample of repositories to ensure they have realistic star counts
3. **Keep iterating**: Continue checking and fixing until all repository items have proper statistics populated