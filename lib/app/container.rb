# frozen_string_literal: true

require "dry/container"
require "dry/auto_inject"

module App
  # Main DI container for the application
  class Container
    extend Dry::Container::Mixin

    register("parse_markdown_operation") { ParseMarkdownOperation.new }
  end
end
