# frozen_string_literal: true

require 'thor'

module Awesomer
  module Commands
    # CLI command for auditing parser adapter selection across awesome lists.
    class Audit < Thor
      desc 'repo REPO_IDENTIFIER', 'Audit which adapter works best for a specific awesome list'
      method_option :fetch, default: false, desc: 'Fetch fresh README from GitHub instead of using stored content',
                            type: :boolean
      method_option :verbose, default: false, desc: 'Show per-category breakdown', type: :boolean
      def repo(repo_identifier)
        content = load_content(repo_identifier)
        return unless content

        result = AuditAdaptersService.new.call(content:)

        if result.success?
          render_audit_result(repo_identifier, result.value!, options[:verbose])
        else
          say "ERROR: #{result.failure}", :red
        end
      end

      desc 'all', 'Audit adapter selection for all active awesome lists'
      method_option :mismatches_only, default: false, desc: 'Only show lists where recommended differs from current',
                                      type: :boolean
      def all
        lists = AwesomeList.active.where.not(readme_content: nil)

        if lists.empty?
          say 'No active lists with stored README content found.', :yellow
          say 'Run `bin/awesomer refresh` first to populate README content.', :yellow
          return
        end

        say "Auditing #{lists.count} active lists...\n\n", :cyan

        mismatches = audit_all_lists(lists)
        render_all_summary(mismatches)
      end

      private

      def load_content(repo_identifier)
        if options[:fetch]
          fetch_from_github(repo_identifier)
        else
          load_from_database(repo_identifier)
        end
      end

      def fetch_from_github(repo_identifier)
        say "Fetching README from GitHub for #{repo_identifier}...", :cyan
        result = FetchReadmeOperation.new.call(repo_identifier:)
        if result.success?
          result.value![:content]
        else
          say "ERROR: Failed to fetch README: #{result.failure}", :red
          nil
        end
      end

      def load_from_database(repo_identifier)
        list = AwesomeList.find_by(github_repo: repo_identifier)
        if list.nil?
          say "ERROR: No AwesomeList record found for '#{repo_identifier}'.", :red
          say 'Use --fetch to fetch directly from GitHub.', :yellow
          nil
        elsif list.readme_content.blank?
          say "ERROR: No stored README content for '#{repo_identifier}'.", :red
          say 'Run `bin/awesomer refresh` first, or use --fetch.', :yellow
          nil
        else
          list.readme_content
        end
      end

      def render_audit_result(repo_identifier, data, verbose)
        say "\nAdapter Audit: #{repo_identifier}", :cyan
        say '=' * 70, :green

        render_results_table(data[:results])
        render_recommendation(data)

        return unless verbose && data[:recommended][:parse_success]

        render_category_breakdown(data[:recommended])
      end

      def render_results_table(results)
        say "\n  #{'Adapter'.ljust(35)} #{'Match'.rjust(5)} #{'Categories'.rjust(10)} " \
            "#{'Items'.rjust(7)} #{'Score'.rjust(7)}", :white
        say "  #{'-' * 67}"

        results.each do |r|
          match_str = r[:matches] ? 'Y' : '-'
          cats = r[:parse_success] ? r[:metrics][:category_count].to_s : '-'
          items = r[:parse_success] ? r[:metrics][:total_items].to_s : '-'
          score = r[:score] > 0 ? r[:score].to_s : '-'
          say "  #{r[:adapter_name].ljust(35)} #{match_str.rjust(5)} #{cats.rjust(10)} " \
              "#{items.rjust(7)} #{score.rjust(7)}"
        end
      end

      def render_recommendation(data)
        recommended = data[:recommended]
        current = data[:current_adapter]

        say "\n  Current (priority-based):  #{current}"
        say "  Recommended (by score):   #{recommended[:adapter_name]} (score: #{recommended[:score]})"

        if recommended[:adapter_name] == current
          say "\n  Current adapter is the best fit.", :green
        else
          say "\n  MISMATCH: A different adapter scores higher.", :yellow
        end
      end

      def render_category_breakdown(recommended)
        say "\n  Category breakdown (recommended adapter):", :cyan
        recommended[:metrics][:categories].each do |cat|
          say "    #{cat[:name]}: #{cat[:items]} items"
        end
      end

      def audit_all_lists(lists)
        mismatches = []

        lists.find_each do |list|
          result = AuditAdaptersService.new.call(content: list.readme_content)
          next unless result.success?

          mismatch = render_list_result(list, result.value!)
          mismatches << mismatch if mismatch
        end

        mismatches
      end

      def render_list_result(list, data)
        recommended = data[:recommended][:adapter_name]
        current = data[:current_adapter]
        is_mismatch = recommended != current

        unless options[:mismatches_only] && !is_mismatch
          status = is_mismatch ? 'MISMATCH' : 'OK'
          say "#{status}  #{list.github_repo}", is_mismatch ? :yellow : :green
          say "         Current: #{current}  |  Recommended: #{recommended} (score: #{data[:recommended][:score]})"
        end

        return unless is_mismatch

        {current:, recommended:, repo: list.github_repo, score_diff: data[:recommended][:score]}
      end

      def render_all_summary(mismatches)
        if mismatches.any?
          say "\n#{mismatches.size} mismatch(es) found. " \
              'Run `bin/awesomer audit repo OWNER/REPO --verbose` for details.', :yellow
        else
          say "\nAll lists are using their best adapter.", :green
        end
      end
    end
  end
end
