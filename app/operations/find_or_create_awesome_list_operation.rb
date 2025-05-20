# frozen_string_literal: true

class FindOrCreateAwesomeListOperation
  include Dry::Monads[:result, :do]

  # Input: fetched_repo_data (hash with :owner, :repo, :repo_description, :last_commit_at (for README))
  def call(fetched_repo_data:)
    owner = fetched_repo_data[:owner]
    repo_name = fetched_repo_data[:repo]
    repo_description = fetched_repo_data[:repo_description]
    readme_last_commit_at = fetched_repo_data[:last_commit_at]

    return Failure("Owner or repo name missing from fetched data") if owner.blank? || repo_name.blank?

    repo_shortname = "#{owner}/#{repo_name}"

    aw_list = AwesomeList.find_or_initialize_by(github_repo: repo_shortname)
    aw_list.name = repo_name # Use repo name for the list name
    aw_list.description = repo_description
    aw_list.last_commit_at = readme_last_commit_at
    
    if yield save_record(aw_list, repo_shortname)
      Success(aw_list)
    else
      # This else block might not be reached if save_record returns a Failure that propagates
      # However, if save_record returned Success(false), this structure would be different.
      # Given save_record returns Success(model) or Failure(message), yield handles it.
      # This line is effectively unreachable if save_record is monadic and yield is used.
      Failure("Upsert failed due to unhandled save_record outcome") # Should not happen
    end
  end

  private

  def save_record(record, repo_shortname_for_error_msg)
    if record.save
      puts "Upserted AwesomeList record for: #{repo_shortname_for_error_msg}, Last Commit: #{record.last_commit_at}" # Log
      Success(record)
    else
      Failure("Failed to save AwesomeList record for #{repo_shortname_for_error_msg}: #{record.errors.full_messages.join(', ')}")
    end
  rescue ActiveRecord::ActiveRecordError => e
    Failure("Database error saving AwesomeList for #{repo_shortname_for_error_msg}: #{e.message}")
  rescue StandardError => e
 