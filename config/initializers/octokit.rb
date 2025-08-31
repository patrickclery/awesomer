# frozen_string_literal: true

require 'octokit'
require 'faraday'
require 'faraday/retry'

# Configure Octokit with timeouts and retry logic
Octokit.configure do |c|
  c.access_token = ENV.fetch('GITHUB_API_KEY', nil)
  c.auto_paginate = false # Handle pagination manually to avoid hanging

  # Set up connection with timeout and retry middleware
  c.middleware = Faraday::RackBuilder.new do |builder|
    # Retry on network failures and rate limits
    retry_options = {
      backoff_factor: 2,
      exceptions: [
        Faraday::ConnectionFailed,
        Faraday::TimeoutError,
        Faraday::ResourceNotFound,
        Octokit::TooManyRequests,
        Octokit::ServerError
      ],
      interval: 1,
      interval_randomness: 0.5,
      max: 3,
      retry_statuses: [429, 500, 502, 503, 504]
    }

    # Add retry block for handling rate limits
    retry_options[:retry_block] = proc do |env, _options, retries, exception|
      if exception.is_a?(Octokit::TooManyRequests)
        wait_time = (env[:response_headers] || {})['retry-after'].to_i
        wait_time = 60 if wait_time.zero?
        Rails.logger.warn "GitHub rate limit hit, waiting #{wait_time} seconds..." if defined?(Rails)
        sleep(wait_time)
      end
      Rails.logger.info "Retrying request (attempt #{retries + 1})..." if defined?(Rails)
    end

    builder.use Faraday::Retry::Middleware, retry_options

    # Set connection and request timeouts
    builder.use Faraday::Request::UrlEncoded
    builder.adapter Faraday.default_adapter
  end

  # Connection options with aggressive timeouts
  c.connection_options = {
    request: {
      open_timeout: 10,  # 10 seconds to open connection
      timeout: 30        # 30 seconds for the request
    }
  }
end

# Helper method to create client with timeout
module OctokitHelper
  def self.client_with_timeout(timeout: 30)
    Octokit::Client.new(
      access_token: ENV.fetch('GITHUB_API_KEY', nil),
      auto_paginate: false,
      connection_options: {
        request: {
          open_timeout: 10,
          timeout:
        }
      }
    )
  end
end
