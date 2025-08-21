# frozen_string_literal: true

class ParserAdapterRegistry
  include Singleton

  def initialize
    @adapters = []
    register_default_adapters
  end

  # Register a new adapter
  def register(adapter_class)
    @adapters << adapter_class.new unless @adapters.any? { |a| a.class == adapter_class }
    @adapters.sort_by!(&:priority).reverse!
  end

  # Find the best adapter for the given content
  def find_adapter(content)
    # Try adapters in priority order
    @adapters.find { |adapter| adapter.matches?(content) }
  end

  # Get all registered adapters
  def all_adapters
    @adapters.dup
  end

  # Clear all adapters (mainly for testing)
  def clear!
    @adapters.clear
  end

  # Reset to default adapters
  def reset!
    clear!
    register_default_adapters
  end

  private

  def register_default_adapters
    # Register in reverse priority order (will be sorted)
    register(StandardAwesomeListAdapter)
    register(ClaudeCodeAdapter)
    register(H3AwesomeListAdapter)
    # Future adapters can be added here
  end

  class << self
    # Convenience methods
    def register(adapter_class)
      instance.register(adapter_class)
    end

    def find_adapter(content)
      instance.find_adapter(content)
    end

    def all_adapters
      instance.all_adapters
    end
  end
end
