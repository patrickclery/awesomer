# frozen_string_literal: true

require 'thor'

module Awesomer
  module Commands
    class Bootstrap < Thor
      desc 'lists', 'Bootstrap all awesome lists from sindresorhus/awesome repository'
      method_option :dry_run, default: false, desc: 'Show what would be bootstrapped without actually creating records',
                              type: :boolean
      method_option :limit, desc: 'Limit the number of repositories to process (for testing)', type: :numeric
      method_option :verbose, default: false, desc: 'Enable verbose logging', type: :boolean
      method_option :fetch, default: false,
                            desc: 'Fetch fresh data from GitHub instead of using local bootstrap.md',
                            type: :boolean
      method_option :resurrect, default: false,
                                desc: 'Re-activate archived (deleted) awesome lists if they exist',
                                type: :boolean
      method_option :validate, default: true,
                               desc: 'Skip lists that fail validation (orphaned, empty, stale)',
                               type: :boolean
      def lists
        puts '🚀 Bootstrap Awesome Lists'
        puts '=' * 50

        unless ENV['GITHUB_API_KEY']
          say('ERROR: GITHUB_API_KEY environment variable is required for API access.', :red)
          say('Please set your GitHub Personal Access Token in .env.development.local', :yellow)
          exit 1
        end

        unless defined?(BootstrapAwesomeListsService)
          say('ERROR: BootstrapAwesomeListsService not loaded. Cannot proceed.', :red)
          exit 1
        end

        if options[:verbose]
          Rails.logger.level = Logger::DEBUG if defined?(Rails)
        end

        if options[:dry_run]
          puts '🧪 DRY RUN MODE - No records will be created'
          puts
        end

        source_info = if options[:fetch]
                        '📡 Fetching fresh data from sindresorhus/awesome repository...'
                      else
                        '📁 Using local bootstrap.md file...'
                      end
        puts source_info

        if options[:resurrect]
          puts '♻️  RESURRECT MODE - Will re-activate archived lists if found'
        else
          puts '🚫 Skipping archived (deleted) lists (use --resurrect to re-activate)'
        end

        puts '✓ VALIDATION MODE - Will skip orphaned, empty, and stale lists' if options[:validate]

        begin
          bootstrap_service = BootstrapAwesomeListsService.new(
            fetch_from_github: options[:fetch],
            limit: options[:limit],
            resurrect: options[:resurrect],
            validate: options[:validate]
          )

          if options[:dry_run]
            if options[:fetch]
              fetch_operation = FetchReadmeOperation.new
              awesome_readme = fetch_operation.call(repo_identifier: 'sindresorhus/awesome')
            else
              bootstrap_file_path = Rails.root.join('static', 'bootstrap.md')
              unless File.exist?(bootstrap_file_path)
                say('ERROR: Local bootstrap.md file not found. Use --fetch to download it.', :red)
                exit 1
              end
              content = File.read(bootstrap_file_path)
              awesome_readme = Dry::Monads::Success({content:})
            end

            if awesome_readme.success?
              extract_operation = ExtractAwesomeListsOperation.new
              repo_links = extract_operation.call(markdown_content: awesome_readme.value![:content])

              if repo_links.success?
                total_repos = repo_links.value!.size
                limited_repos = options[:limit] ? repo_links.value!.first(options[:limit]) : repo_links.value!

                limit_info = options[:limit] ? " (limited from #{total_repos})" : ''
                puts "📋 Would process #{limited_repos.size} repositories#{limit_info}:"
                puts

                limited_repos.each_with_index do |repo, index|
                  puts "#{format('%3d', index + 1)}. #{repo}"
                end

                puts
                puts '✅ Dry run completed. Use --no-dry-run to actually bootstrap the repositories.'
              else
                say("ERROR: Failed to extract repository links: #{repo_links.failure}", :red)
              end
            else
              say("ERROR: Failed to fetch sindresorhus/awesome: #{awesome_readme.failure}", :red)
            end
          else
            result = bootstrap_service.call

            if result.success?
              data = result.value!

              puts
              puts '✅ Bootstrap completed successfully!'
              puts '📊 Summary:'
              puts "   • Total repositories found: #{data[:total_processed]}"
              puts "   • Successfully created/updated: #{data[:successful_count]}"
              puts "   • Skipped (archived): #{data[:skipped_archived_count]}" if data[:skipped_archived_count] > 0
              puts "   • Resurrected: #{data[:resurrected_count]}" if data[:resurrected_count] > 0
              puts "   • Failed: #{data[:failed_count]}"

              if data[:skipped_archived_count] > 0 && !options[:resurrect]
                puts
                puts '⏭️  Skipped archived repositories (use --resurrect to re-activate):'
                data[:skipped_archived].first(5).each do |repo|
                  puts "   • #{repo}"
                end
                puts "   ... and #{data[:skipped_archived_count] - 5} more" if data[:skipped_archived_count] > 5
              end

              if data[:failed_count] > 0
                puts
                puts '❌ Failed repositories:'
                data[:failed_repos].each do |failed|
                  puts "   • #{failed[:repo]}: #{failed[:error]}"
                end
              end

              puts
              puts '🎉 All done! AwesomeList records are now available in the database.'
            else
              say("ERROR: Bootstrap failed: #{result.failure}", :red)
              exit 1
            end
          end
        rescue StandardError => e
          say("ERROR: An unexpected error occurred: #{e.message}", :red)
          puts e.backtrace.first(5).join("\n") if options[:verbose]
          exit 1
        end
      end
    end
  end
end
