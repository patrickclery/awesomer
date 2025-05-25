# frozen_string_literal: true

# Redis configuration for rate limiting
REDIS_RATE_LIMIT = Redis.new(
  timeout: 1,
  url: ENV.fetch("REDIS_URL", "redis://localhost:6379/1")
)
