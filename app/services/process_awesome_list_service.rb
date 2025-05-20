# frozen_string_literal: true

require "fileutils" # For FileUtils.mkdir_p

class ProcessAwesomeListService
  include Dry::Monads[:result, :do]
  include App::Import[:parse_markdown_operation]

  def initialize(repo_shortname:, **options)
    @repo_shortname = repo_shortname
    @parse_markdown_operation = options[:parse_markdown_operation] # Removed assignment

    @repo_shortname_fs = @repo_shortname.tr("/", "_")
    @markdown_dir = Rails.root.join("tmp", "markdown")
    @json_dir = Rails.root.join("tmp", "json")
    @markdown_file_path = @markdown_dir.join("#{@repo_shortname_fs}.md")
    @json_file_path = @json_dir.join("#{@repo_shortname_fs}.json")
  end

  def call
    ensure_directories_exist
    markdown_content = read_markdown_file
    return Failure("Markdown file not found or empty: #{@markdown_file_path}") if markdown_content.blank?

    # Use the method provided by App::Import
    parsed_data_result = parse_markdown_operation.call(markdown_content:)
    return parsed_data_result if parsed_data_result.failure?

    data_to_save = parsed_data_result.value!

    save_json_file(data_to_save)

    Success(@json_file_path)
  rescue StandardError => e
    Failure("Error processing awesome list for #{@repo_shortname}: #{e.message}")
  end

  private

  def ensure_directories_exist
    FileUtils.mkdir_p(@markdown_dir)
    FileUtils.mkdir_p(@json_dir)
  end

  def read_markdown_file
    return nil unless File.exist?(@markdown_file_path)
    File.read(@markdown_file_path)
  end

  def save_json_file(data)
    File.open(@json_file_path, "w") do |file|
      file.write(JSON.pretty_generate(data))
    end
  end
end
