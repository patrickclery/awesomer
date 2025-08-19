# frozen_string_literal: true

class ParseMarkdownOperation
  # noinspection RubyResolve
  include Dry::Monads[:result, :do]

  def call(markdown_content:, adapter: nil, skip_external_links: false)
    return Success([]) if markdown_content.blank?

    # Use provided adapter or find the best one for the content
    adapter ||= ParserAdapterRegistry.find_adapter(markdown_content)

    # Fall back to standard adapter if no adapter matches
    adapter ||= StandardAwesomeListAdapter.new

    Rails.logger.info "ParseMarkdownOperation: Using #{adapter.class.name} for parsing"

    # Delegate to the adapter
    adapter.parse(markdown_content, skip_external_links:)
  end
end
