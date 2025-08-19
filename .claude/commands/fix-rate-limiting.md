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

   **Important**: The bootstrap service only creates AwesomeList records but does NOT fetch GitHub stats. You must
   process each repository individually with sync mode to get stats.

2. **Process with Stats**: For each awesome list that needs GitHub stats, run with sync mode:
   ```bash
   # Process a specific repo with immediate GitHub stats fetching
   bundle exec rails runner "ProcessAwesomeListService.new(repo_identifier: 'hesreallyhim/awesome-claude-code', sync: true).call"
   
   # Process all pending repositories with stats (will take time due to rate limiting)
   bundle exec rails runner "
   AwesomeList.where(state: 'pending').find_each do |list|
     puts \"Processing #{list.github_repo}...\"
     service = ProcessAwesomeListService.new(repo_identifier: list.github_repo, sync: true)
     result = service.call
     puts result.success? ? '✅ Success' : '❌ Failed: ' + result.failure.to_s
   end
   "
   ```

3. **Monitor Output**: Watch for rate limiting errors such as:

- "API rate limit exceeded"
- "429 Too Many Requests"
- "Secondary rate limit"
- Faraday::TooManyRequestsError
- Octokit::TooManyRequests

4. **Identify Issues**: When rate limiting occurs, analyze:

- Which operation triggered the limit
- Current rate limiting implementation in `app/services/github_rate_limiter_service.rb`
- Retry logic in operations that make GitHub API calls
- Batch processing delays

5. **Fix Implementation**: Make improvements such as:

- Increase delays between API calls
- Implement exponential backoff
- Add better rate limit checking before requests
- Implement request queuing
- Add caching for frequently accessed data
- Batch requests more efficiently
- Use conditional requests with ETags where possible

6. **Test Fix**: After making changes:

- Run the specs to ensure nothing is broken:
  ```bash
  bundle exec rspec spec/services/github_rate_limiter_service_spec.rb
  bundle exec rspec spec/operations/sync_git_stats_operation_spec.rb
  ```

7. **Retry Process**: Run the bootstrap command again and monitor for issues

8. **Iterate**: Continue the loop until all awesome lists are successfully processed without rate limiting

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
- **No empty star counts**: Verify that repository statistics are actually populated by checking that items aren't full
  of empty/zero star counts (which would indicate the sync didn't actually update the data)
- **Generated markdown files show actual stats**: The files in `static/md/` must show real star counts and last commit
  dates, NOT "N/A" for all items. While some individual items might legitimately be N/A (deleted repos), it should be
  rare. If ALL items in a file show "N/A", the sync didn't work properly

## Monitoring Progress

Check progress with:

```ruby
AwesomeList.group(:state).count
AwesomeList.where(state: 'failed').pluck(:github_repo, :updated_at)

# Check for empty star counts in database to ensure updates actually worked
CategoryItem.where(stars: nil).count
CategoryItem.where(stars: 0).count

# Get a sample of star counts to verify they're populated
CategoryItem.where.not(stars: nil).pluck(:name, :stars).sample(10)

# Check generated markdown files for N/A values
Dir.glob("static/md/*.md").each do |file|
  content = File.read(file)
  na_count = content.scan(/\| N\/A\s+\|/).count
  total_rows = content.scan(/^\|[^-]/).count
  puts "#{File.basename(file)}: #{na_count}/#{total_rows} N/A values"
end
```

## Verification Loop

After each run, check that stats are actually being updated:

1. **Count empty stats**: If many items still have zero or null star counts, the sync may not be working properly
2. **Sample verification**: Check a random sample of repositories to ensure they have realistic star counts
3. **Check markdown files**: Open files in `static/md/` and verify they show actual star counts and dates (not all "
   N/A")
4. **Keep iterating**: Continue checking and fixing until:

- Repository items have proper statistics populated in the database
- Generated markdown files show real stats (stars and dates) instead of "N/A"
- The vast majority of items have legitimate data (while a few N/A entries for deleted repos are acceptable)