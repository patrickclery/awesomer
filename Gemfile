# frozen_string_literal: true

source 'https://rubygems.org'

# Load gem dependencies from gemspec (for CLI gem structure)
# Temporarily commented out to avoid conflicts with Rails
# gemspec

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 8.0.2'
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem 'propshaft'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Use the database-backed adapters for Rails.cache and Active Job
gem 'solid_cache'
gem 'solid_queue'

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem 'kamal', require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem 'thruster', require: false

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'

  # Load environment variables from .env files
  gem 'dotenv-rails'

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem 'brakeman', require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem 'rubocop-factory_bot'
  gem 'rubocop-obsession'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rails-omakase', require: false
  gem 'rubocop-rake'
  gem 'rubocop-rspec'
  gem 'sevencop'

  gem 'factory_bot_rails'
  gem 'rspec-rails'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'annotaterb', github: 'drwl/annotaterb'
  gem 'web-console'
end

gem 'dry-auto_inject'
gem 'dry-container'
gem 'dry-struct'

group :test do
  gem 'faker'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'super_diff'
  gem 'vcr'
  gem 'webmock'
end

gem 'octokit'
gem 'redis', '~> 5.0'

gem 'dry-monads', '~> 1.8'

gem 'neatjson'

gem 'to_bool'

gem 'faraday-retry'

gem 'terminal-table'

# State machine for status tracking
gem 'aasm'

# Background job processing

# Cron job scheduling
gem 'whenever', require: false
