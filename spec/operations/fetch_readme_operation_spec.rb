# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FetchReadmeOperation, :vcr do
  include Dry::Monads[:result]
  subject(:operation) { described_class.new }

  # Ensure ENV['GITHUB_API_KEY'] is set for VCR recording to avoid rate limits.

  let(:repo_polycarbohydrate_awesome_tor) { 'Polycarbohydrate/awesome-tor' }
  let(:url_polycarbohydrate_awesome_tor) { 'https://github.com/Polycarbohydrate/awesome-tor' }
  let(:cassette_awesome_tor_details) { 'github/octokit_polycarbohydrate_awesome-tor_details' }

  # Removed global Octokit::Client stubbing; VCR will handle actual client calls.

  shared_examples 'a successful README fetch for awesome-tor' do |identifier_type|
    let(:current_repo_identifier) { identifier_type == :owner_repo ? repo_polycarbohydrate_awesome_tor : url_polycarbohydrate_awesome_tor }

    it 'fetches readme, commit date, description, and repo details successfully' do
      VCR.use_cassette(cassette_awesome_tor_details, record: :new_episodes) do
        result = operation.call(repo_identifier: current_repo_identifier)
        expect(result).to be_success
        data = result.value!
        expect(data[:content].downcase).to include("awesome-tor")
        expect(data[:name]).to match(/README/i)
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

  context 'with a repository that has no README or does not exist' do
    let(:repo_identifier) { 'empty-owner/empty-repo-that-does-not-exist' }

    it 'returns a Failure' do
      VCR.use_cassette('github/octokit_empty-owner_empty-repo-not-found', record: :new_episodes) do # New cassette name
        result = operation.call(repo_identifier:)
        expect(result).to be_failure
        # Octokit might raise NotFound for repository first, or for readme.
        expect(result.failure).to match(/Repository not found|README not found for repository/)
      end
    end
  end

  context 'with an invalid repo_identifier format' do
    let(:repo_identifier) { 'invalid_repo_id' }

    it 'returns a Failure (no VCR needed)' do
      result = operation.call(repo_identifier:)
      expect(result).to be_failure
      expect(result.failure).to eq("Invalid GitHub repository identifier: #{repo_identifier}. Expected 'owner/repo' or full URL.")
    end
  end

  context 'when GitHub API returns a 404 for repo data (mocked at HTTP level for Octokit)' do
    let(:repo_identifier) { 'Polycarbohydrate/awesome-tor' }

    it 'returns a Failure indicating repository not found' do
      # This test requires a cassette that records a 404 for the initial repo data fetch.
      # Or, to test Octokit's error handling without a specific cassette for this rare state:
      # allow_any_instance_of(Octokit::Client).to receive(:repository).and_raise(Octokit::NotFound)
      # For VCR based test:
      VCR.use_cassette('github/octokit_polycarbohydrate_awesome-tor_repo_not_found', record: :once) do
        result = operation.call(repo_identifier:)
        expect(result).to be_failure
        expect(result.failure).to eq("Repository not found: Polycarbohydrate/awesome-tor")
      end
    end
  end

  context 'when GitHub API returns a 404 for README content' do
    let(:repo_identifier) { 'jekyll/jekyll-test-readme-does-not-exist' } # A repo that exists but give it a path that won't have a README

    # Or use a repo you control where README can be temporarily removed for recording.
    it 'returns a Failure indicating README not found' do
      # This cassette should record the repo data fetch successfully, but the README fetch as 404.
      VCR.use_cassette('github/octokit_jekyll_no_readme_content', record: :once) do
        result = operation.call(repo_identifier:)
        expect(result).to be_failure
        expect(result.failure).to eq("README not found for repository: jekyll/jekyll-test-readme-does-not-exist")
      end
    end
  end

  # Test for network errors (SocketError) - this is hard to test reliably with VCR for Octokit
  # as Octokit uses Faraday, which has its own adapter system.
  # Mocking Faraday adapter or using WebMock to block requests would be more appropriate here.
  context 'when a network error occurs (e.g., SocketError)', :skip_vcr_for_network_error_test do
    let(:repo_identifier) { 'Polycarbohydrate/awesome-tor' }

    before do
      # This will mock Faraday's underlying adapter to simulate a network issue
      # This requires knowledge of Octokit's Faraday setup.
      # A simpler way for some Faraday versions/adapters:
      # allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::ConnectionFailed.new("test connection failed"))
      # More generically, if Octokit allows passing a custom adapter for testing:
      # For now, let's assume a high-level Octokit client error that might wrap a network issue.
      # This test is difficult to make robust without deeper Faraday mocking or specific VCR hooks for network failures.
      # We can test the operation's rescue Octokit::Error for a generic API error instead.
      allow_any_instance_of(Octokit::Client).to receive(:repository).and_raise(Octokit::Error.new("Simulated network or client error"))
    end

    it 'returns a Failure' do
      result = operation.call(repo_identifier:)
      expect(result).to be_failure
      expect(result.failure).to include("GitHub API error fetching repo data for Polycarbohydrate/awesome-tor: Simulated network or client error")
    end
  end
end
