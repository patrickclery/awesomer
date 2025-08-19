# CLAUDE.md

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
```

### Development Server
```bash
# Start Rails server
bin/rails server

# Start Rails console
bin/rails console

# Run background job worker
bin/jobs
```

### Database Commands
```bash
# Setup database
bin/rails db:create db:migrate

# Reset database
bin/rails db:drop db:create db:migrate

# Run migrations
bin/rails db:migrate

# Run test database migrations
bin/rails db:migrate RAILS_ENV=test
```

### Code Quality
```bash
# Run RuboCop linting
bundle exec rubocop

# Run RuboCop with auto-fix
bundle exec rubocop -a

# Run security scanner
bin/brakeman
```

## Architecture Overview

This is a Rails 8.0 application that processes and analyzes GitHub Awesome Lists repositories. It follows a modular architecture using dependency injection and the Result monad pattern.

### Core Patterns

**Dependency Injection Container**: Uses `dry-container` and `dry-auto_inject` for managing dependencies. All operations and services are registered in `lib/app/container.rb`.

**Result Monad Pattern**: Operations use `dry-monads` Result types (Success/Failure) for consistent error handling and flow control.

**State Machine**: The `AwesomeList` model uses AASM for tracking processing states (pending, in_progress, completed, failed).

### Key Components

**Operations** (`app/operations/`): Single-responsibility classes that perform specific tasks:
- `FetchReadmeOperation`: Fetches README content from GitHub
- `ParseMarkdownOperation`: Parses markdown to extract categories and items
- `SyncGitStatsOperation`: Fetches GitHub statistics for repository items
- `FindOrCreateAwesomeListOperation`: Manages AwesomeList records
- `ExtractAwesomeListsOperation`: Extracts awesome list references from markdown

**Services** (`app/services/`): Orchestrate operations to complete workflows:
- `ProcessAwesomeListService`: Main service that coordinates the full processing pipeline
- `ProcessCategoryService`: Processes individual categories and generates markdown
- `BootstrapAwesomeListsService`: Bootstraps multiple awesome lists for processing
- `GithubRateLimiterService`: Manages GitHub API rate limiting with Redis

**Models**:
- `AwesomeList`: Represents an awesome list repository with state tracking
- `Category`: Categories within an awesome list
- `CategoryItem`: Individual items within categories
- `RepoStat`: GitHub statistics for repositories
- `GithubApiRequest`: Tracks API request history for rate limiting

### Data Flow

1. **Fetch**: README content is fetched from a GitHub repository
2. **Parse**: Markdown is parsed to extract structured categories and items
3. **Sync**: GitHub stats are fetched for each repository item
4. **Process**: Categories are processed and markdown files are generated
5. **Persist**: Data is saved to PostgreSQL with state tracking

### Testing Strategy

- Uses RSpec for testing with FactoryBot for fixtures
- VCR for recording/replaying HTTP interactions
- WebMock for stubbing external requests
- Tests should use `example` blocks instead of `it` blocks (per .cursorrules)
- Always run associated spec file after code changes

### Important Configuration

- **Environment Variables**: Stored in `.env.development.local` (includes GitHub API key)
- **Repository Configuration**: Define repositories to track in `config/repos.yml`
- **Database**: PostgreSQL with separate databases for cache and queue (Solid Cache/Queue)
- **Background Jobs**: Uses Solid Queue for job processing

### Development Guidelines

From `.cursorrules` and `CLAUDE.local.md`:
- Run specs after making changes to code or specs
- Use `example` blocks in specs instead of `it` blocks
- Make changes file by file
- Use explicit, descriptive variable names
- Include assertions to validate assumptions
- Consider edge cases in implementations
- Follow existing code conventions and patterns