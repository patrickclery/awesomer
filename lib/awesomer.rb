# frozen_string_literal: true

require_relative "awesomer/version"

# Only load CLI if not in Rails environment (to avoid conflicts with rails eager loading)
unless defined?(Rails)
  require_relative "awesomer/cli"
end

module Awesomer
  class Error < StandardError; end
end
