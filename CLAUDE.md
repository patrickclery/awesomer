# CLAUDE.md

- @.claude/commands/fix-rate-limiting.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands

### Running Tests
```bash
# Run all tests
bundle exec rspec

# Run a specific test file
bundle exec rspec spec/path/to/spec_file.rb

# Run tests for a specific line number
bundle exec rspec spec/path/to/spec_file.rb:42

# Run tests with coverage
COVERAGE=1 bundle exec rspec

# Run tests for files matching a pattern
bundle exec rspec spec/**/*operation*_spec.rb
```

### Development Server
```bash
# Start Rails server
bin/rails server

# Start Rails console
bin/rails console

# Run background job worker (Solid Queue)
bin/jobs

# Run all services (server + jobs) in development
bin/dev
```

### Database Commands
```bash
# Setup database (initial setup)
bin/rails db:create db:migrate

# Reset database (drop and recreate)
bin/rails db:drop db:create db:migrate

# Run pending migrations
bin/rails db:migrate

# Rollback last migration
bin/rails db:rollback

# Run test database migrations
bin/rails db:migrate RAILS_ENV=test

# Check migration status
bin/rails db:migrate:status
```

### Code Quality
```bash
# Run RuboCop linting
bundle exec rubocop

# Run RuboCop with auto-fix
bundle exec rubocop -a

# Run RuboCop with unsafe auto-fix
bundle exec rubocop -A

# Run security scanner
bin/brakeman

# Check specific files with RuboCop
bundle exec rubocop app/services/
```

### Dependency Management
```bash
# Install gems
bundle install

# Update gems
bundle update

# Check outdated gems
bundle outdated
```

### Rails Generators
```bash
# Generate a new model
bin/rails generate model ModelName field:type

# Generate a new migration
bin/rails generate migration AddFieldToModel field:type

# Generate a new service
bin/rails generate service ServiceName

# Destroy generated files
bin/rails destroy model ModelName
```

## Architecture Overview

This is a Rails 8.0 application that processes and analyzes GitHub Awesome Lists repositories. It follows a modular architecture using dependency injection and the Result monad pattern for robust error handling.

### Core Patterns

**Dependency Injection Container**: Uses `dry-container` and `dry-auto_inject` for managing dependencies. All operations and services are registered in `lib/app/container.rb`. This enables easy testing and decoupling of components.

**Result Monad Pattern**: Operations use `dry-monads` Result types (Success/Failure) for consistent error handling and flow control. This eliminates nil checks and provides explicit error handling paths.

**State Machine**: The `AwesomeList` model uses AASM for tracking processing states (pending, in_progress, completed, failed) with automatic timestamp tracking.

### Key Components

**Operations** (`app/operations/`): Single-responsibility classes that perform specific tasks:
- `FetchReadmeOperation`: Fetches README content from GitHub API
- `ParseMarkdownOperation`: Parses markdown to extract structured categories and items
- `SyncGitStatsOperation`: Fetches GitHub statistics (stars, forks, issues) for repository items
- `FindOrCreateAwesomeListOperation`: Manages AwesomeList records with upsert logic
- `ExtractAwesomeListsOperation`: Extracts references to other awesome lists from markdown
- `PersistParsedCategoriesOperation`: Saves parsed data to database
- `FetchGithubStatsForCategoriesOperation`: Batch fetches GitHub stats with rate limiting

**Services** (`app/services/`): Orchestrate operations to complete workflows:
- `ProcessAwesomeListService`: Main service coordinating the full processing pipeline with state management
- `ProcessCategoryService`: Processes individual categories and generates markdown output files
- `BootstrapAwesomeListsService`: Bootstraps multiple awesome lists for batch processing
- `GithubRateLimiterService`: Manages GitHub API rate limiting using Redis for tracking

**Models**:
- `AwesomeList`: Repository record with AASM state machine (pending → in_progress → completed/failed)
- `Category`: Categories within an awesome list with position ordering
- `CategoryItem`: Individual items within categories with URL and description
- `RepoStat`: Cached GitHub statistics for repositories (stars, forks, issues, last commit)
- `GithubApiRequest`: Tracks API request history for rate limiting analysis

**Background Jobs** (`app/jobs/`):
- `ProcessMarkdownWithStatsJob`: Processes awesome list with GitHub stats
- `FetchGithubStatsJob`: Fetches GitHub statistics for repositories
- `GenerateMarkdownJob`: Generates markdown output files

### Data Flow

1. **Bootstrap**: `BootstrapAwesomeListsService` reads `config/repos.yml` and creates AwesomeList records
2. **Fetch**: `FetchReadmeOperation` retrieves README content from GitHub API
3. **Parse**: `ParseMarkdownOperation` extracts structured categories and items using regex patterns
4. **Sync**: `SyncGitStatsOperation` fetches GitHub stats for each repository item with rate limiting
5. **Process**: `ProcessCategoryService` generates enhanced markdown with stats
6. **Persist**: Data saved to PostgreSQL with state tracking via AASM transitions

### Testing Strategy

- RSpec for unit and integration tests with FactoryBot for test data
- VCR for recording/replaying HTTP interactions with GitHub API
- WebMock for stubbing external requests in isolated tests
- SimpleCov for code coverage reporting
- Tests use `example` blocks instead of `it` blocks (per .cursorrules)
- Run associated spec file after code changes to verify fixes

### Configuration

- **Environment Variables**: Create `.env.development.local` with `GITHUB_API_KEY`
- **Repository List**: Copy `config/repos.example.yml` to `config/repos.yml` and add repositories to track
- **Database**: PostgreSQL with separate databases for Solid Cache and Solid Queue
- **Redis**: Required for GitHub API rate limiting (configured in `config/redis.yml`)
- **Background Jobs**: Solid Queue for job processing (configuration in `config/solid_queue.yml`)

### Development Guidelines

From `.cursorrules` and `CLAUDE.local.md`:
- Always run specs after making changes to verify functionality
- Use `example` blocks in specs instead of `it` blocks
- Make changes file by file for easier review
- Use explicit, descriptive variable names for clarity
- Include assertions to validate assumptions and catch edge cases
- Follow existing patterns: dependency injection, Result monads, service objects
- Never commit API keys or sensitive data to the repository