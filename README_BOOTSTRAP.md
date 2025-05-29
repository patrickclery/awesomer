# Bootstrap CLI for Awesome Lists

The Bootstrap CLI utility allows you to populate your database with all awesome lists from the [sindresorhus/awesome](https://github.com/sindresorhus/awesome) repository.

## Features

- **Single fetch**: Only requires one API call to fetch the main awesome list
- **Automatic extraction**: Parses the README to extract all GitHub repository links
- **Bulk processing**: Creates AwesomeList records for each discovered repository
- **Request caching**: All Octokit GitHub API requests are cached automatically
- **Error resilience**: Continues processing even if some repositories fail
- **Dry run mode**: Preview what would be processed without making changes
- **Local file caching**: Uses cached `static/bootstrap.md` by default for faster processing
- **Fresh data option**: `--fetch` flag to get latest data from GitHub

## Usage

### Bootstrap All Awesome Lists

```bash
# Full bootstrap using local cached file (processes all ~687 repositories)
bundle exec ruby lib/cli/bootstrap.rb awesome_lists

# Fetch fresh data from GitHub and update local cache
bundle exec ruby lib/cli/bootstrap.rb awesome_lists --fetch

# Dry run to see what would be processed (uses local file)
bundle exec ruby lib/cli/bootstrap.rb awesome_lists --dry-run

# Dry run with fresh GitHub data
bundle exec ruby lib/cli/bootstrap.rb awesome_lists --dry-run --fetch

# Limit processing for testing (e.g., only first 10 repositories)
bundle exec ruby lib/cli/bootstrap.rb awesome_lists --limit 10

# Enable verbose logging
bundle exec ruby lib/cli/bootstrap.rb awesome_lists --verbose
```

### Check Status

```bash
# View current AwesomeList database status
bundle exec ruby lib/cli/bootstrap.rb status
```

## Local File Caching

The Bootstrap CLI uses a local cache file at `static/bootstrap.md` to avoid unnecessary GitHub API calls:

- **Default behavior**: Uses the local `static/bootstrap.md` file if it exists
- **--fetch flag**: Downloads fresh data from GitHub and updates the local file
- **Missing file**: If `static/bootstrap.md` doesn't exist, you must use `--fetch` to download it

This approach significantly speeds up repeated bootstrap operations and reduces GitHub API usage.

## Output Example

### Using Local File (Default)
```
🚀 Bootstrap Awesome Lists
==================================================
📁 Using local bootstrap.md file...

✅ Bootstrap completed successfully!
📊 Summary:
   • Total repositories found: 687
   • Successfully created/updated: 683
   • Failed: 4
```

### Using Fresh GitHub Data (--fetch)
```
🚀 Bootstrap Awesome Lists
==================================================
📡 Fetching fresh data from sindresorhus/awesome repository...

✅ Bootstrap completed successfully!
📊 Summary:
   • Total repositories found: 687
   • Successfully created/updated: 683
   • Failed: 4
```

## Prerequisites

- `GITHUB_API_KEY` environment variable must be set (for API rate limiting)
- Rails environment must be loaded
- Database must be migrated and accessible

## Implementation Details

The Bootstrap CLI:

1. **Chooses data source**: Uses local `static/bootstrap.md` or fetches from GitHub (with `--fetch`)
2. **Extracts** all GitHub repository links using regex patterns
3. **Processes** each repository to fetch its metadata
4. **Creates** AwesomeList records in the database
5. **Caches** all API responses for efficiency
6. **Reports** detailed success/failure statistics

## Architecture

- `ExtractAwesomeListsOperation`: Parses markdown to extract repository links
- `BootstrapAwesomeListsService`: Orchestrates the entire bootstrap process with local/remote data source selection
- `FetchReadmeOperation`: Fetches repository data from GitHub API (reused)
- `FindOrCreateAwesomeListOperation`: Creates/updates database records (reused)

All operations follow the established service/operation pattern with `Dry::Monads` for error handling. 