# Awesomer

A powerful Rails application and CLI utility for processing, analyzing, and enhancing GitHub Awesome Lists with
real-time statistics.

## Features

- 🚀 **Bootstrap** hundreds of Awesome Lists from sindresorhus/awesome
- 📊 **Fetch GitHub Stats** - Stars, forks, last commit dates for all repositories
- ⏱️ **Timeout Protection** - Never stalls indefinitely, all operations have timeouts
- 🔄 **Smart Rate Limiting** - Handles GitHub API limits gracefully with automatic retries
- 📁 **Markdown Generation** - Creates enhanced markdown files with repository statistics
- 💎 **Gem-like CLI** - Use `awesomer` command from anywhere
- 🔧 **Background Processing** - Async job processing with Solid Queue
- 💾 **Intelligent Caching** - Reduces API calls with smart caching strategies

## Table of Contents

- [Installation](#installation)
- [Configuration](#configuration)
- [CLI Usage](#cli-usage)
  - [Bootstrap Awesome Lists](#bootstrap-awesome-lists)
  - [Process Repositories](#process-repositories)
  - [Status Commands](#status-commands)
- [Sync Scripts](#sync-scripts)
- [Architecture](#architecture)
- [Timeout Protection](#timeout-protection)
- [Development](#development)
- [Troubleshooting](#troubleshooting)

## Installation

### Prerequisites

- Ruby 3.1+
- PostgreSQL
- Redis (for rate limiting)
- GitHub Personal Access Token

### Setup

1. Clone the repository:

```bash
git clone [repository-url]
cd awesomer
```

2. Install dependencies:

```bash
bundle install
```

3. Set up environment variables:

```bash
cp .env.example .env.development.local
# Edit .env.development.local and add your GITHUB_API_KEY
```

4. Set up the database:

```bash
bin/rails db:create
bin/rails db:migrate
```

5. Make the CLI available:

```bash
# The awesomer command is available via bin/awesomer
./bin/awesomer --help
```

## Configuration

### GitHub API Key

Create a `.env.development.local` file with your GitHub Personal Access Token:

```bash
GITHUB_API_KEY=ghp_your_token_here
```

### Repository List (Optional)

For manual repository management, create `config/repos.yml`:

```bash
cp config/repos.example.yml config/repos.yml
```

## CLI Usage

The `awesomer` CLI provides comprehensive commands for managing Awesome Lists.

### Bootstrap Awesome Lists

Bootstrap fetches all Awesome Lists from the main sindresorhus/awesome repository (~680+ repositories).

```bash
# Bootstrap using cached local file (fastest)
awesomer bootstrap lists

# Fetch fresh data from GitHub
awesomer bootstrap lists --fetch

# Dry run to preview what would be processed
awesomer bootstrap lists --dry-run

# Limit processing for testing
awesomer bootstrap lists --limit 10

# Enable verbose logging
awesomer bootstrap lists --verbose
```

#### Bootstrap Features

- **Single API call** for main list (efficient)
- **Local caching** at `static/bootstrap.md`
- **Automatic extraction** of all GitHub repository links
- **Error resilience** - continues even if some repos fail
- **Progress reporting** with detailed statistics

### Process Repositories

Process repositories to fetch README content, parse categories/items, and fetch GitHub statistics.

#### Process All Repositories

```bash
# Process all pending repositories
awesomer process all

# Process with immediate GitHub stats (synchronous)
awesomer process all --sync

# Auto-retry on rate limits (will wait and continue)
awesomer process all --sync --wait-and-retry

# Process only incomplete repositories
awesomer process all --incomplete-only

# Reset and reprocess all
awesomer process all --reset-status --sync

# Limit processing
awesomer process all --limit 50 --sync
```

#### Process Single Repository

```bash
# Process a specific repository
awesomer process repo sindresorhus/awesome

# Process with immediate stats
awesomer process repo sindresorhus/awesome --sync

# Specify output directory
awesomer process repo sindresorhus/awesome --output-dir tmp/test
```

### Status Commands

```bash
# Show database status
awesomer status

# Show version
awesomer version
```

## Sync Scripts

For bulk processing, use the dedicated sync scripts:

### sync_all.rb - Comprehensive Sync with Timeout Protection

```bash
bundle exec ruby lib/sync_all.rb
```

Features:

- ⏱️ **60-second timeout** per repository
- 🔄 **Automatic recovery** from stuck items
- 📊 **Progress updates** every 10 repositories
- 🛑 **Smart stopping** after 10 consecutive failures
- 📈 **Detailed statistics** including timeout counts

### fast_sync.rb - Parallel Processing

```bash
bundle exec ruby lib/fast_sync.rb
```

Features:

- 🚀 **Concurrent processing** with thread pools
- 📦 **Batch processing** to avoid overwhelming
- ⚡ **3x faster** than sequential processing

## Architecture

### Core Components

**Services** (`app/services/`)

- `ProcessAwesomeListService` - Main orchestrator for processing repositories
- `ProcessCategoryService` - Generates enhanced markdown files
- `BootstrapAwesomeListsService` - Manages bulk repository import
- `GithubRateLimiterService` - Intelligent rate limit management

**Operations** (`app/operations/`)

- `FetchReadmeOperation` - Fetches README content with timeout protection
- `ParseMarkdownOperation` - Extracts structured data from markdown
- `SyncGitStatsOperation` - Fetches GitHub statistics
- `FetchGithubStatsForCategoriesOperation` - Batch stats fetching

**Models**

- `AwesomeList` - Repository records with AASM state machine
- `Category` - Categories within awesome lists
- `CategoryItem` - Individual items with GitHub stats
- `RepoStat` - Cached GitHub statistics

### State Machine

AwesomeList records track processing state:

- `pending` → `in_progress` → `completed` ✅
- `pending` → `in_progress` → `failed` ❌

## Timeout Protection

All operations are protected against indefinite hanging:

### Configuration (`config/initializers/octokit.rb`)

- **Connection timeout**: 10 seconds
- **Request timeout**: 30 seconds
- **Automatic retries**: 3 attempts with exponential backoff
- **Rate limit handling**: Automatic waiting

### Operation Timeouts

- **Repository processing**: 60 seconds max
- **Individual API calls**: 20-30 seconds
- **Batch operations**: Timeout per item

### Recovery Mechanisms

- Stuck "in_progress" items automatically reset to "pending"
- Failed items can be retried
- Timeouts tracked separately from failures

## Output

Processed files are saved to `static/md/` with enhanced formatting:

```markdown
## Category Name

| Name | Description | Stars | Last Commit |
|------|-------------|-------|-------------|
| [repo-name](url) | Description text | 1,234 | 2024-01-15 |
```

## Development

### Running Tests

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/services/process_awesome_list_service_spec.rb

# Run with coverage
COVERAGE=1 bundle exec rspec
```

### Code Quality

```bash
# Run RuboCop
bundle exec rubocop

# Auto-fix issues
bundle exec rubocop -a
```

### Background Jobs

```bash
# Start Solid Queue worker
bin/jobs

# Or run everything with
bin/dev
```

## Troubleshooting

### Rate Limiting Issues

If you encounter rate limiting:

1. **Use --wait-and-retry flag**: Automatically waits for rate limit reset

```bash
awesomer process all --sync --wait-and-retry
```

2. **Check rate limit status**:

```bash
bundle exec rails runner "
  client = Octokit::Client.new(access_token: ENV['GITHUB_API_KEY'])
  limit = client.rate_limit
  puts \"Remaining: #{limit.remaining}\"
  puts \"Resets at: #{Time.at(limit.resets_at)}\"
"
```

3. **Use caching**: Processed data is cached for 1 month

### Stuck Processing

If processing appears stuck:

1. **Check for stuck items**:

```bash
bundle exec rails runner "
  stuck = AwesomeList.in_progress
  puts \"Stuck items: #{stuck.count}\"
  stuck.each { |item| puts item.github_repo }
"
```

2. **Reset stuck items**:

```bash
bundle exec rails runner "
  AwesomeList.in_progress.update_all(state: 'pending')
  puts 'Reset complete'
"
```

3. **Use sync_all.rb**: Has built-in stuck item recovery

### Database Issues

```bash
# Reset database
bin/rails db:drop db:create db:migrate

# Check connection
bin/rails db
```

### Missing GitHub Stats

If files show "N/A" for stats:

1. Verify API key is set correctly
2. Check rate limit status
3. Reprocess with sync flag:

```bash
awesomer process repo REPO_NAME --sync
```

## Common Commands Reference

```bash
# Quick start - bootstrap and process everything
awesomer bootstrap lists --fetch
awesomer process all --sync --wait-and-retry

# Check progress
awesomer status

# Process specific repository
awesomer process repo sindresorhus/awesome --sync

# Batch process with safety
bundle exec ruby lib/sync_all.rb

# Fast parallel processing  
bundle exec ruby lib/fast_sync.rb
```

## License

This is a private project for internal use only.

## Acknowledgments

- [sindresorhus/awesome](https://github.com/sindresorhus/awesome) for the comprehensive list of Awesome Lists
- All maintainers of the individual Awesome Lists