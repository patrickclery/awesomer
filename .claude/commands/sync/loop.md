---
name: loop
description: Automated loop to sync all awesome lists with rate limiting fixes
---

# Fix Rate Limiting Command - Automated Loop

This command implements an automated feedback loop that:

1. Syncs all awesome lists and their GitHub statistics
2. Monitors progress with active countdown timers
3. Detects and handles rate limiting issues automatically
4. Runs pruning after sync completes
5. Generates markdown files after pruning
6. **Repeats until 100% completion with NO manual intervention**

## Main Feedback Loop

### Loop Configuration

- **Initial Wait**: 30 seconds for sync processes to start
- **Check Interval (Normal)**: 10 minutes (600 seconds)
- **Check Interval (Near Completion)**: 2 minutes (120 seconds) when >95% complete
- **Check Interval (Stalled)**: 1 minute (60 seconds) when no progress detected
- **Max Iterations**: 100 cycles (16.7 hours maximum)
- **Exit Conditions**:
  - 100% sync completion AND pruning complete AND markdown generated
  - User explicitly stops the loop with Ctrl+C
  - Maximum iterations reached

### Loop Process

#### Step 1: Check Sync Status

```bash
# Get current sync progress
items_with_stars=$(bundle exec rails runner "puts CategoryItem.where.not(stars: nil).count")
items_without_stars=$(bundle exec rails runner "puts CategoryItem.where(stars: nil).where.not(github_repo: [nil, '']).count")
total_items=$((items_with_stars + items_without_stars))

if [ $total_items -gt 0 ]; then
  percentage=$((items_with_stars * 100 / total_items))
  echo "📊 Sync Progress: $items_with_stars/$total_items ($percentage%)"
fi
```

#### Step 2: Handle Different States

##### A. Sync Complete (100%)

When sync reaches 100%, automatically:

1. Run pruning to remove invalid lists
2. Delete old markdown files
3. Generate fresh markdown files
4. Exit loop successfully

##### B. Sync Stalled

If no progress for 3 consecutive checks:

1. Kill existing sync process
2. Restart with smaller batch size
3. Reset stall counter

##### C. Rate Limit Detected

When rate limiting is detected:

1. Increase delay between requests
2. Reduce batch size
3. Implement exponential backoff

#### Step 3: Wait and Monitor (Key Implementation)

**IMPORTANT: Display an active countdown timer during all wait periods**

```bash
# Determine wait interval based on current state
if [ "$JUST_COMMITTED" = true ]; then
  WAIT_TIME=30  # 30 seconds after committing to check for new activity
elif [ "$ALL_TASKS_RESOLVED" = true ]; then
  WAIT_TIME=60  # 1 minute when just waiting for completion
else
  WAIT_TIME=600  # 10 minutes for normal sync monitoring
fi

# Display active countdown timer
echo "⏱️ Waiting $WAIT_TIME seconds before next check..."
for i in $(seq $WAIT_TIME -1 1); do
  printf "\r⏳ Time remaining: %02d seconds" $i
  sleep 1
done
printf "\r✅ Wait complete, checking status...\n"

# Then repeat from Step 1
```

**Timer Display Requirements:**

- Show exact seconds remaining
- Update every second in place (using \r)
- Clear indication when timer completes
- Different wait times based on state:
  - 30s after making changes (checking for issues)
  - 60s when tasks resolved (waiting for completion)
  - 600s (10min) during normal sync monitoring

## Status Reporting

Every iteration displays:

```
🔄 Rate Limit Fix Loop - Iteration X/100
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 Sync Progress: X/Y items (Z%)
⏱️  Time Elapsed: Xh Ym
🔮 Estimated Completion: Xh Ym
⚠️  Issues Detected:
  - [Any rate limiting or stalls]
⏳ Next check in: MM:SS
```

## Automated Sync Command

Instead of manual looping, use the new automated sync command:

```bash
# Runs complete sequence automatically with monitoring
bundle exec bin/awesomer sync

# Without countdown timers
bundle exec bin/awesomer sync --no-monitor

# With custom iteration limit
bundle exec bin/awesomer sync --max-iterations=50
```

This command handles:

- Starting and monitoring sync process
- Automatic restart on stalls
- Running pruning after sync completes
- Deleting old markdown files
- Generating fresh markdown files
- Active countdown timers between checks

## Exit Criteria

### Success Conditions

- ✅ 100% of CategoryItems have stars populated (where github_repo exists)
- ✅ No items showing stars = nil for valid repos
- ✅ All invalid lists pruned (stale, empty, orphaned)
- ✅ All markdown files regenerated with actual stats
- ✅ Less than 5% of items showing "N/A" in markdown files
- ✅ No rate limiting errors in last 3 iterations

**ABSOLUTE REQUIREMENT**: The loop MUST NOT stop until:

- Every single CategoryItem with a github_repo has been checked
- Pruning has removed all invalid lists
- Fresh markdown has been generated AFTER pruning

### Failure Conditions

- ❌ Maximum iterations reached (100)
- ❌ Sync stalled for >5 consecutive checks
- ❌ Persistent rate limiting that can't be resolved
- ❌ User intervention with Ctrl+C

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

## Complete Automation Script

```bash
#!/bin/bash

# Initialize variables
ITERATION=0
MAX_ITERATIONS=100
LAST_SYNCED_COUNT=0
STALL_COUNTER=0

echo "🚀 Starting Rate Limit Fix Loop"
echo "Sequence: Sync → Prune → Generate Markdown"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Ensure sync is running
if ! pgrep -f "sync:stars" > /dev/null; then
  echo "📊 Starting initial sync process..."
  bundle exec rake sync:stars &
  sleep 30
fi

# Main loop
while [ $ITERATION -lt $MAX_ITERATIONS ]; do
  ITERATION=$((ITERATION + 1))
  
  echo ""
  echo "🔄 Rate Limit Fix Loop - Iteration $ITERATION/$MAX_ITERATIONS"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  
  # Get current sync status
  items_with_stars=$(bundle exec rails runner "puts CategoryItem.where.not(stars: nil).count" 2>/dev/null)
  items_without_stars=$(bundle exec rails runner "puts CategoryItem.where(stars: nil).where.not(github_repo: [nil, '']).count" 2>/dev/null)
  total_items=$((items_with_stars + items_without_stars))
  
  if [ $total_items -gt 0 ]; then
    percentage=$((items_with_stars * 100 / total_items))
    echo "📊 Sync Progress: $items_with_stars/$total_items ($percentage%)"
    
    # Check if complete
    if [ $items_without_stars -eq 0 ]; then
      echo "✅ Sync complete! Running pruning and markdown generation..."
      
      # Run the proper sequence
      bundle exec ruby lib/monitoring/proper_sequence.rb
      
      echo "🎉 All tasks completed successfully!"
      exit 0
    fi
    
    # Check for stalls
    if [ "$items_with_stars" = "$LAST_SYNCED_COUNT" ]; then
      STALL_COUNTER=$((STALL_COUNTER + 1))
      if [ $STALL_COUNTER -ge 3 ]; then
        echo "⚠️  Sync stalled! Restarting..."
        pkill -f "sync:stars" 2>/dev/null
        bundle exec rake sync:stars LIMIT=50 &
        STALL_COUNTER=0
      fi
    else
      STALL_COUNTER=0
    fi
    
    LAST_SYNCED_COUNT=$items_with_stars
  fi
  
  # Determine wait time
  if [ $percentage -ge 95 ]; then
    WAIT_TIME=120
  elif [ $STALL_COUNTER -gt 0 ]; then
    WAIT_TIME=60
  else
    WAIT_TIME=600
  fi
  
  # Active countdown
  echo ""
  for i in $(seq $WAIT_TIME -1 1); do
    minutes=$((i / 60))
    seconds=$((i % 60))
    if [ $minutes -gt 0 ]; then
      printf "\r⏳ Next check in: %02d:%02d" $minutes $seconds
    else
      printf "\r⏳ Next check in: %02d seconds" $seconds
    fi
    sleep 1
  done
  printf "\r✅ Checking status...                    \n"
done

echo "❌ Maximum iterations reached"
exit 1
```

## Notes

- The loop automatically handles the complete sequence
- No manual intervention required after starting
- Active countdown timers show exact time remaining
- Automatic restart of stalled processes
- Proper sequence enforced: sync → prune → markdown