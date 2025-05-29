# Bootstrap CLI for Awesome Lists

The Bootstrap CLI utility allows you to populate your database with all awesome lists from the [sindresorhus/awesome](https://github.com/sindresorhus/awesome) repository.

## Features

- **Single fetch**: Only requires one API call to fetch the main awesome list
- **Automatic extraction**: Parses the README to extract all GitHub repository links
- **Bulk processing**: Creates AwesomeList records for each discovered repository
- **Request caching**: All Octokit GitHub API requests are cached automatically
- **Error resilience**: Continues processing even if some repositories fail
- **Dry run mode**: Preview what would be processed without making changes

## Usage

### Bootstrap All Awesome Lists

```bash
# Full bootstrap (processes all ~687 repositories)
bundle exec ruby lib/cli/bootstrap.rb awesome_lists

# Dry run to see what would be processed
bundle exec ruby lib/cli/bootstrap.rb awesome_lists --dry-run

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

## Output Example

```
🚀 Bootstrap Awesome Lists
==================================================
📡 Fetching sindresorhus/awesome repository...

✅ Bootstrap completed successfully!
📊 Summary:
   • Total repositories found: 687
   • Successfully created/updated: 683
   • Failed: 4

❌ Failed repositories:
   • jorgebucaran/awsm: Repository not found
   • topics/awesome: Repository not found

🎉 All done! AwesomeList records are now available in the database.
```

## Prerequisites

- `GITHUB_API_KEY` environment variable must be set (for API rate limiting)
- Rails environment must be loaded
- Database must be migrated and accessible

## Implementation Details

The Bootstrap CLI:

1. **Fetches** the main sindresorhus/awesome README
2. **Extracts** all GitHub repository links using regex patterns
3. **Processes** each repository to fetch its metadata
4. **Creates** AwesomeList records in the database
5. **Caches** all API responses for efficiency
6. **Reports** detailed success/failure statistics

## Architecture

- `ExtractAwesomeListsOperation`: Parses markdown to extract repository links
- `BootstrapAwesomeListsService`: Orchestrates the entire bootstrap process  
- `FetchReadmeOperation`: Fetches repository data from GitHub API (reused)
- `FindOrCreateAwesomeListOperation`: Creates/updates database records (reused)

All operations follow the established service/operation pattern with `Dry::Monads` for error handling. 