# frozen_string_literal: true

require 'thor'
require 'dry/monads'

module Awesomer
  module Commands
    class Process < Thor
      include Dry::Monads[:result]

      no_commands do
        def get_github_rate_limit_info
          return nil unless defined?(Octokit)

          begin
            client = Octokit::Client.new(access_token: ENV.fetch('GITHUB_API_KEY', nil))
            rate_limit = client.rate_limit
            {
              remaining: rate_limit.remaining,
              resets_at: Time.at(rate_limit.resets_at),
              resets_in: rate_limit.resets_in
            }
          rescue StandardError => e
            Rails.logger.error "Failed to get GitHub rate limit info: #{e.message}" if defined?(Rails)
            nil
          end
        end

        def github_rate_limited?
          info = get_github_rate_limit_info
          info && info[:remaining] <= 0
        end
      end

      desc 'all', 'Process all awesome lists from the database'
      method_option :dry_run, default: false, desc: 'Show what would be processed without actually processing',
                              type: :boolean
      method_option :limit, desc: 'Limit the number of awesome lists to process', type: :numeric
      method_option :output_dir, default: 'tmp/batch_sync', desc: 'Base directory for all processed files',
                                 type: :string
      method_option :sync, default: false, desc: 'Run in synchronous mode to fetch GitHub stats immediately',
                           type: :boolean
      method_option :wait_and_retry, default: false,
                                     desc: 'Automatically wait for rate limit resets and continue processing',
                                     type: :boolean
      method_option :incomplete_only, default: false, desc: 'Only process lists that are not completed',
                                      type: :boolean
      method_option :reset_status, default: false, desc: 'Reset all lists to pending status before processing',
                                   type: :boolean
      def all
        unless defined?(AwesomeList)
          say('ERROR: AwesomeList model not loaded. Cannot proceed.', :red)
          exit 1
        end

        rate_limit_error = lambda do |error_message|
          error_message.downcase.include?('rate limit') ||
            error_message.downcase.include?('too many requests') ||
            (error_message.include?('403') && error_message.downcase.include?('api'))
        end

        if options[:reset_status]
          puts '🔄 Resetting all awesome list statuses to pending...'
          reset_count = AwesomeList.where.not(state: 'pending').count
          AwesomeList.where.not(state: 'pending').find_each(&:reset_for_reprocessing!)
          puts "✅ Reset #{reset_count} awesome lists to pending status"
          puts
        end

        awesome_lists = if options[:incomplete_only]
                          puts '🎯 Processing only incomplete awesome lists...'
                          AwesomeList.incomplete
                        else
                          puts '📋 Processing all awesome lists...'
                          AwesomeList.all
                        end

        awesome_lists = awesome_lists.limit(options[:limit]) if options[:limit]
        total_count = awesome_lists.count

        if options[:dry_run]
          puts "🔍 Dry run: Would process #{total_count} awesome lists"
          puts
          puts 'Status breakdown:'
          status_counts = awesome_lists.group(:state).count
          status_counts.each do |status, count|
            puts "  #{status.to_s.capitalize}: #{count}"
          end
          puts
          awesome_lists.each_with_index do |awesome_list, index|
            status_emoji = case awesome_list.state
                           when 'pending' then '⏳'
                           when 'in_progress' then '🔄'
                           when 'completed' then '✅'
                           when 'failed' then '❌'
                           else '❓'
                           end
            puts "[#{index + 1}/#{total_count}] #{status_emoji} #{awesome_list.github_repo} (#{awesome_list.state})"
          end
          return
        end

        sync_mode = options[:sync] ? 'synchronous' : 'asynchronous'
        puts "🔄 Processing #{total_count} awesome lists in #{sync_mode} mode"

        output_dir = options[:output_dir]
        FileUtils.mkdir_p(output_dir)

        successful_count = 0
        failed_count = 0
        failed_repos = []

        awesome_lists.each_with_index do |awesome_list, index|
          repo_identifier = awesome_list.github_repo
          progress = "[#{index + 1}/#{total_count}]"
          retry_count = 0

          loop do
            puts "#{progress} Processing #{repo_identifier}#{retry_count > 0 ? " (retry #{retry_count})" : ''}..."

            if github_rate_limited?
              github_info = get_github_rate_limit_info
              reset_time_utc = github_info[:resets_at]
              wait_time = github_info[:resets_in]

              puts '⚠️  GitHub API rate limit reached!'
              puts "   • Processed: #{index}/#{total_count} repositories"
              puts "   • Remaining: #{total_count - index} repositories"
              puts "   • Rate limit resets in: #{wait_time} seconds"
              puts "   • Will resume at: #{reset_time_utc.in_time_zone}" if reset_time_utc.respond_to?(:in_time_zone)
              puts

              if options[:wait_and_retry]
                puts '⏳ Waiting for rate limit to reset...'
                puts '   • Press Ctrl+C to stop and resume manually later'
                puts

                current_time_utc = Time.current
                if reset_time_utc > current_time_utc
                  sleep_duration = (reset_time_utc - current_time_utc) + 10
                  puts "   • Sleeping for #{sleep_duration.round} seconds..."
                  sleep(sleep_duration)
                end

                puts '🔄 Rate limit reset! Resuming processing...'
                puts
                next
              else
                puts '🛑 Stopping to respect rate limits.'
                puts '💡 To resume processing later:'
                puts "   1. Wait until #{reset_time_utc.in_time_zone}" if reset_time_utc.respond_to?(:in_time_zone)
                resume_limit = total_count - index
                sync_flag = options[:sync] ? '--sync' : ''
                puts "   2. Run: awesomer process all --limit #{resume_limit} #{sync_flag}".strip
                puts

                puts '⚠️  Stopped due to rate limiting!'
                puts '📊 Summary:'
                puts "   • Total to process: #{total_count}"
                puts "   • Successful: #{successful_count}"
                puts "   • Failed: #{failed_count}"
                puts "   • Skipped (rate limited): #{total_count - index}"
                puts
                puts "📁 Output directory: #{File.expand_path(output_dir)}"
                return
              end
            end

            begin
              # Add timeout to prevent indefinite hanging
              require 'timeout'
              Timeout.timeout(60) do
                result = ProcessAwesomeListService.new(repo_identifier:, sync: options[:sync]).call

                if result.success?
                  successful_count += 1
                  puts "✅ Successfully processed #{repo_identifier}"
                  break
                else
                  error_message = result.failure.to_s
                  if rate_limit_error.call(error_message)
                    puts '⚠️  Rate limit error detected'
                    if options[:wait_and_retry]
                      puts '⏳ Waiting for rate limit to reset...'
                      github_info = get_github_rate_limit_info
                      if github_info
                        reset_time_utc = github_info[:resets_at]
                        current_time_utc = Time.current
                        if reset_time_utc > current_time_utc
                          sleep_duration = (reset_time_utc - current_time_utc) + 10
                          puts "   • Sleeping for #{sleep_duration.round} seconds..."
                          sleep(sleep_duration)
                        end
                      else
                        puts '   • Using fallback wait time of 60 minutes...'
                        sleep(3600)
                      end
                      puts "🔄 Rate limit reset! Retrying #{repo_identifier}..."
                      retry_count += 1
                      next
                    else
                      begin
                        awesome_list.fail_processing!
                      rescue StandardError
                        nil
                      end
                      failed_count += 1
                      failed_repos << repo_identifier
                      puts "❌ Failed to process #{repo_identifier}: #{result.failure}"
                      break
                    end
                  else
                    begin
                      awesome_list.fail_processing!
                    rescue StandardError
                      nil
                    end
                    failed_count += 1
                    failed_repos << repo_identifier
                    puts "❌ Failed to process #{repo_identifier}: #{result.failure}"
                    break
                  end
                end
              end
            rescue Timeout::Error
              puts "⏱️  Timeout after 60s - skipping #{repo_identifier}"
              awesome_list.update(state: 'pending') if awesome_list.state == 'in_progress'
              failed_count += 1
              failed_repos << repo_identifier
              break
            rescue StandardError => e
              error_message = e.message
              if rate_limit_error.call(error_message)
                puts '⚠️  Rate limit error detected'
                if options[:wait_and_retry]
                  puts '⏳ Waiting for rate limit to reset...'
                  github_info = get_github_rate_limit_info
                  if github_info
                    reset_time_utc = github_info[:resets_at]
                    current_time_utc = Time.current
                    if reset_time_utc > current_time_utc
                      sleep_duration = (reset_time_utc - current_time_utc) + 10
                      puts "   • Sleeping for #{sleep_duration.round} seconds..."
                      sleep(sleep_duration)
                    end
                  else
                    puts '   • Using fallback wait time of 60 minutes...'
                    sleep(3600)
                  end
                  puts "🔄 Rate limit reset! Retrying #{repo_identifier}..."
                  retry_count += 1
                  next
                else
                  begin
                    awesome_list.fail_processing!
                  rescue StandardError
                    nil
                  end
                  failed_count += 1
                  failed_repos << repo_identifier
                  puts "❌ Error processing #{repo_identifier}: #{e.message}"
                  break
                end
              else
                begin
                  awesome_list.fail_processing!
                rescue StandardError
                  nil
                end
                failed_count += 1
                failed_repos << repo_identifier
                puts "❌ Error processing #{repo_identifier}: #{e.message}"
                break
              end
            end
          end

          sleep(0.5) if options[:sync]
        end

        puts
        puts '✅ Processing completed!'
        puts '📊 Final Summary:'
        puts "   • Total processed: #{total_count}"
        puts "   • Successful: #{successful_count}"
        puts "   • Failed: #{failed_count}"

        if failed_repos.any?
          puts '   • Failed repositories:'
          failed_repos.each { |repo| puts "     - #{repo}" }
        end

        puts
        puts "📁 Output directory: #{File.expand_path(output_dir)}"
      end

      desc 'repo REPO_IDENTIFIER', 'Process a single GitHub repository'
      method_option :output_dir, default: 'tmp/md', desc: 'Directory to save the markdown file', type: :string
      method_option :output_filename, default: 'processed.md',
                                      desc: 'Filename for the processed markdown output', type: :string
      method_option :sync, default: false, desc: 'Run in synchronous mode to fetch GitHub stats immediately',
                           type: :boolean
      def repo(repo_identifier)
        sync_mode = options[:sync]
        mode_text = sync_mode ? 'synchronous' : 'asynchronous'
        puts "Starting repository processing for '#{repo_identifier}' in #{mode_text} mode..."

        custom_output_dir = Rails.root.join(options[:output_dir])

        begin
          FileUtils.mkdir_p(custom_output_dir)
        rescue StandardError => e
          say("ERROR: Could not create custom output directory #{custom_output_dir}: #{e.message}", :red)
          exit 1
        end

        unless defined?(ProcessAwesomeListService) && defined?(ProcessCategoryService)
          say('ERROR: ProcessAwesomeListService or ProcessCategoryService not loaded. Cannot proceed.', :red)
          exit 1
        end

        original_pcs_target_dir = ProcessCategoryService::TARGET_DIR
        original_pcs_output_filename = ProcessCategoryService::OUTPUT_FILENAME

        begin
          silence_warnings do
            ProcessCategoryService.const_set(:TARGET_DIR, custom_output_dir)
            ProcessCategoryService.const_set(:OUTPUT_FILENAME, options[:output_filename])
          end
          puts "Output will be saved to: #{custom_output_dir.join(options[:output_filename])}"

          awesome_list_service = ProcessAwesomeListService.new(repo_identifier:, sync: sync_mode)
          result = awesome_list_service.call

          if result.success?
            say("Successfully processed repository '#{repo_identifier}' in #{mode_text} mode. Output file:", :green)
            puts "- #{result.value!}"

            if sync_mode
              puts '✅ GitHub stats were fetched synchronously and included in the output file.'
            else
              puts '⏳ GitHub stats are being processed in the background. The file will be updated when complete.'
            end
          else
            say("ERROR: Failed to process repository '#{repo_identifier}': #{result.failure}", :red)
          end
        rescue StandardError => e
          say("ERROR: An unexpected error occurred: #{e.message}", :red)
          puts e.backtrace.first(5).join("\n")
        ensure
          silence_warnings do
            ProcessCategoryService.const_set(:TARGET_DIR, original_pcs_target_dir)
            ProcessCategoryService.const_set(:OUTPUT_FILENAME, original_pcs_output_filename)
          end
        end

        puts 'Repository processing finished.'
      end

      private

      def silence_warnings
        old_verbose, $VERBOSE = $VERBOSE, nil
        yield
      ensure
        $VERBOSE = old_verbose
      end
    end
  end
end
