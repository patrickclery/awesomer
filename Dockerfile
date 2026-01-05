# syntax=docker/dockerfile:1
# check=error=true

# Dockerfile for Awesomer Rails Application
# Designed for running CLI commands (bin/awesomer) in containers
#
# Build: docker build -t awesomer .
# Run:   docker run --rm awesomer bin/awesomer status

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.3.3
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /app

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libjemalloc2 \
    libvips \
    postgresql-client \
    git \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test"

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libpq-dev \
    libyaml-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Final stage for app image
FROM base

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /app /app

# Configure git for publish command (commits inside container)
RUN git config --global user.email "bot@awesomer.app" && \
    git config --global user.name "Awesomer Bot" && \
    git config --global --add safe.directory /app && \
    git config --global --add safe.directory /app/static/awesomer

# Create directories for output and data
RUN mkdir -p /app/output /app/tmp /app/log /app/db /app/storage

# Make bin scripts executable
RUN chmod +x bin/*

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails /app
USER 1000:1000

# Entrypoint prepares the database
ENTRYPOINT ["/app/bin/docker-entrypoint"]

# Default command shows status
CMD ["bin/awesomer", "status"]
