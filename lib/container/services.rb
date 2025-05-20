# frozen_string_literal: true

# Zeitwerk compatibility: Define the expected constant.
# The primary purpose of this file is to register components into App::Container.
module Container
  module Services
    # This module itself might not be used, but its definition satisfies Zeitwerk.
  end
end

# This file is expected to be loaded after App::Container is defined.
# It registers services into the main application container.

# Prevent multiple executions of this file's content in the same process
@services_container_file_loaded ||= false
unless @services_container_file_loaded
  if defined?(App::Container) && defined?(GithubStatsFetcherService)
    # Only register if the key isn't already present from another source (e.g. auto-registration)
    unless App::Container.key?('services.github_stats_fetcher')
      App::Container.register('services.github_stats_fetcher') { GithubStatsFetcherService.new }
    end
  else
    if !defined?(App::Container)
      puts "WARN: App::Container not defined. GithubStatsFetcherService cannot be registered."
    end
    if !defined?(GithubStatsFetcherService)
      puts "WARN: GithubStatsFetcherService class not defined. Cannot register services.github_stats_fetcher."
    end
  end
  @services_container_file_loaded = true
end 