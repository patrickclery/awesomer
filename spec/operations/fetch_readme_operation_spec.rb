# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FetchReadmeOperation, :vcr do
  include Dry::Monads[:result]
  include Test::Support::VCR

  subject(:operation) { described_class.new }

  # Ensure ENV['GITHUB_API_KEY'] is set for VCR recording to avoid rate limits.

  let(:repo_polycarbohydrate_awesome_tor) { 'Polycarbohydrate/awesome-tor' }
  let(:url_polycarbohydrate_awesome_tor) { 'https://github.com/Polycarbohydrate/awesome-tor' }
  let(:cassette_name_for_awesome_tor) { 'polycarbohydrate_awesome-tor' }

  shared_examples 'a successful README fetch for awesome-tor' do |identifier_type|
    let(:current_repo_identifier) {
 identifier_type == :owner_repo ? repo_polycarbohydrate_awesome_tor : url_polycarbohydrate_awesome_tor }

    it 'fetches readme, commit date, description, and repo details successfully' do
      vcr('github', cassette_name_for_awesome_tor, record: :new_episodes) do
        result = operation.call(repo_identifier: current_repo_identifier)
        expect(result).to be_success
        data = result.value!
        expect(data[:content].downcase).to include("awesome-tor")
        expect(data[:name]).to match(/README\.md/i)
        expect(data[:owner].downcase).to eq('polycarbohydrate')
        expect(data[:repo].downcase).to eq('awesome-tor')
        expect(data[:repo_description]).to be_a(String).or(be_nil)
        expect(data[:last_commit_at]).to (be_a(Time).or be_nil)
      end
    end
  end

  context 'with Polycarbohydrate/awesome-tor (owner/repo)' do
    it_behaves_like 'a successful README fetch for awesome-tor', :owner_repo
  end

  context 'with Polycarbohydrate/awesome-tor (GitHub URL)' do
    it_behaves_like 'a successful README fetch for awesome-tor', :url
  end

  context 'with a non-existent repository' do
    let(:repo_identifier) { 'nonexistent-owner/nonexistent-repo-for-fetch-test' }

    it 'returns a Failure' do
      vcr('github', 'nonexistent-owner_nonexistent-repo-for-fetch-test', record: :new_episodes) do
        result = operation.call(repo_identifier:)
        expect(result).to be_failure
        expect(result.failure).to eq("Repository not found: #{repo_identifier}")
      end
    end
  end

  context 'with an invalid repo_identifier format' do
    let(:repo_identifier) { 'invalid_repo_id' }

    it 'returns a Failure (no VCR needed as it fails before API call)' do
      result = operation.call(repo_identifier:)
      expect(result).to be_failure
      expected_message = "Invalid GitHub repository identifier: #{repo_identifier}. " \
                         "Expected 'owner/repo' or full URL."
      expect(result.failure).to eq(expected_message)
    end
  end

  # Simulating API errors not directly tied to 404s (like 500, 403 rate limit) with VCR alone is hard
  # without a way to reliably trigger them from GitHub during recording.
  # These would ideally be tested by having cassettes that *did* record such errors.
  # The operation's rescue blocks for Octokit::Error and StandardError cover these generically.
  # For now, we'll assume the happy paths and explicit NotFounds are the primary VCR targets.
end
