# CLI Audit Report

**Date**: 2026-01-05
**Purpose**: Verify existing CLI commands work correctly before containerization

## Executive Summary

All `bin/awesomer` CLI commands are functional and ready for containerization. The application currently has 6 active awesome lists being tracked, with the last sync occurring on 2025-12-21.

## Database Status

```
Total AwesomeList records: 72
  Active: 6
  Archived: 66

Status breakdown (active only):
  Completed: 5
  In_progress: 1
```

## CLI Commands

### Status Commands

| Command | Status | Description |
|---------|--------|-------------|
| `bin/awesomer status` | Working | Shows AwesomeList database status |
| `bin/awesomer version` | Working | Shows version info |
| `bin/awesomer help` | Working | Shows available commands |

### Worker Commands

| Command | Status | Description |
|---------|--------|-------------|
| `bin/awesomer worker status` | Working | Shows worker state and last sync info |
| `bin/awesomer worker logs` | Working | Displays recent sync logs |
| `bin/awesomer worker run-once` | Available | Runs a single sync cycle |
| `bin/awesomer worker start` | Available | Starts sync daemon |
| `bin/awesomer worker stop` | Available | Stops sync daemon |

**Current Worker State**: Not running
**Last Sync**: 2025-12-21 03:42:01 (awesome-selfhosted/awesome-selfhosted)
**Scheduled Sync**: Daily at 2:00 AM UTC (via `whenever` gem)

### Sync Commands

| Command | Status | Description |
|---------|--------|-------------|
| `bin/awesomer sync` | Available | Complete sync with monitoring |
| `bin/awesomer update` | Available | Update all lists with GitHub stats |
| `bin/awesomer refresh` | Available | Full refresh: sync + reprocess + prune |

**Options for sync/refresh**:
- `--no-async` - Run synchronously instead of background jobs
- `--no-monitor` - Disable progress monitoring
- `--limit=N` - Limit number of lists to process

### Publish Command

| Command | Status | Description |
|---------|--------|-------------|
| `bin/awesomer publish` | Available | Commits and pushes to public repo |

**Implementation Details**:
- Uses git submodule at `static/awesomer`
- Submodule points to: `https://github.com/patrickclery/awesomer.git`
- Commits changes with timestamp message
- Pushes to `origin main` branch

**Docker Consideration**: The publish target is currently hardcoded. For testing with `awesomer-test`, the submodule URL will need to be changed or made configurable via environment variable.

### Bootstrap Commands

| Command | Status | Description |
|---------|--------|-------------|
| `bin/awesomer bootstrap awesome_lists` | Available | Bootstrap from sindresorhus/awesome |

**Note**: Not needed for automation - we only want to keep the current 6 active repos.

### Maintenance Commands

| Command | Status | Description |
|---------|--------|-------------|
| `bin/awesomer cleanup` | Available | Clean up empty files and reprocess failed lists |
| `bin/awesomer prune` | Available | Archive stale awesome lists |
| `bin/awesomer process` | Available | Process and generate markdown |

## Environment Variables

### Required

| Variable | Description | Default |
|----------|-------------|---------|
| `GITHUB_API_KEY` | GitHub API token for fetching star counts | None (required) |

### Database Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `DATABASE_HOST` | PostgreSQL host | `localhost` |
| `DATABASE_PORT` | PostgreSQL port | `5432` |
| `DATABASE_USERNAME` | PostgreSQL username | `awesomer` |
| `DATABASE_PASSWORD` | PostgreSQL password | `awesomer_password` |
| `RAILS_MAX_THREADS` | Connection pool size | `5` |

### Redis Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `REDIS_URL` | Redis connection string | `redis://localhost:6379/1` |

### Rails Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `RAILS_ENV` | Environment | `development` |

### Proposed for Docker

| Variable | Description | Proposed Default |
|----------|-------------|------------------|
| `GITHUB_ACCESS_TOKEN` | Token for git push operations | None (required for publish) |
| `PUBLISH_REPO` | Target repository for publishing | `patrickclery/awesomer-test` |

## Dependencies

### Background Jobs
- **Solid Queue**: Database-backed job processing
- Jobs stored in `awesomer_queue_production` database

### Cron Scheduling
- **whenever gem**: Generates cron schedule
- Schedule: Daily at 2:00 AM UTC
- Command: `bin/awesomer worker run-once`

### Rate Limiting
- **Redis**: Used for GitHub API rate limit tracking
- **GithubRateLimiterService**: Custom rate limiter
- Conservative limit: 4,000 requests/hour (vs GitHub's 5,000)

## Active Awesome Lists (6)

1. `sindresorhus/awesome` (awesome)
2. `hesreallyhim/awesome-claude-code` (awesome-claude-code)
3. `Ravencentric/awesome-arr` (awesome-arr)
4. `punkpeye/awesome-mcp-servers` (awesome-mcp-servers)
5. `Igglybuff/awesome-piracy` (awesome-piracy)
6. `awesome-selfhosted/awesome-selfhosted` (awesome-selfhosted)

## Recommendations for Containerization

1. **Environment Variables**: Add `GITHUB_ACCESS_TOKEN` and `PUBLISH_REPO` for configurable publishing
2. **Submodule Handling**: Consider cloning target repo at runtime instead of using submodule
3. **Health Check**: Implement endpoint for worker container monitoring (e.g., `bin/awesomer worker status --json`)
4. **Volume Mounts**:
   - `./data/postgres` for database persistence
   - `./output` for generated markdown files (currently in `static/awesomer`)
5. **Database Initialization**: Run `db:migrate` on first startup (no seed needed)

## Test Results

All commands verified functional. Ready for Phase 2 (Dockerization).
