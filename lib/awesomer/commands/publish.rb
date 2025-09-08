# frozen_string_literal: true

require 'thor'
require_relative '../../config/environment' if File.exist?(File.expand_path('../../config/environment', __dir__))

module Awesomer
  module Commands
    class Publish < Thor::Group
      include Thor::Actions

      def self.banner
        'awesomer publish'
      end

      desc 'Publish changes to the public awesomer repository'

      def check_submodule
        submodule_path = Rails.root.join('static', 'awesomer')

        unless Dir.exist?(submodule_path)
          say '❌ Submodule not found at static/awesomer', :red
          say 'Please ensure the submodule is properly initialized.', :yellow
          exit 1
        end

        say '✅ Submodule found', :green
      end

      def check_for_changes
        Dir.chdir(Rails.root.join('static', 'awesomer')) do
          @has_changes = !`git status --porcelain`.strip.empty?

          if @has_changes
            say '📝 Changes detected in submodule:', :yellow
            system('git status --short')
          else
            say 'ℹ️  No changes to publish', :blue
          end
        end
      end

      def commit_changes
        return unless @has_changes

        Dir.chdir(Rails.root.join('static', 'awesomer')) do
          say '📦 Committing changes...', :cyan

          # Add all changes
          system('git add .')

          # Create commit message with timestamp
          commit_message = "Update awesome lists - #{Time.now.strftime('%Y-%m-%d %H:%M')}"
          success = system("git commit -m '#{commit_message}'")

          if success
            say '✅ Changes committed', :green
          else
            say '❌ Failed to commit changes', :red
            exit 1
          end
        end
      end

      def push_to_remote
        return unless @has_changes

        Dir.chdir(Rails.root.join('static', 'awesomer')) do
          say '🚀 Pushing to remote repository...', :cyan

          success = system('git push origin main')

          if success
            say '✅ Successfully published to https://github.com/patrickclery/awesomer', :green

            # Show the commit URL
            commit_sha = `git rev-parse HEAD`.strip
            say "📎 View commit: https://github.com/patrickclery/awesomer/commit/#{commit_sha}", :blue
          else
            say '❌ Failed to push changes', :red
            say 'You may need to pull changes first or resolve conflicts.', :yellow
            exit 1
          end
        end
      end

      def update_parent_repository
        return unless @has_changes

        say '📝 Updating parent repository...', :cyan

        # Stage the submodule update in the parent repo
        system('git add static/awesomer')

        if `git status --porcelain static/awesomer`.strip.empty?
          say 'ℹ️  No submodule reference changes in parent', :blue
        else
          system("git commit -m 'Update awesomer submodule'")
          say '✅ Parent repository updated', :green
        end
      end

      def summary
        if @has_changes
          say "\n#{'=' * 50}", :green
          say '✅ Publishing complete!', :green
          say '=' * 50, :green
          say "\nThe awesome lists have been published to:"
          say '  https://github.com/patrickclery/awesomer', :blue
        else
          say "\n✅ No changes to publish", :green
        end
      end
    end
  end
end
