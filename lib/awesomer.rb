# frozen_string_literal: true

require_relative 'awesomer/version'

# Only load CLI if not in Rails environment (to avoid conflicts with rails eager loading)
require_relative 'awesomer/cli' unless defined?(Rails)

module Awesomer
  class Error < StandardError; end
end
