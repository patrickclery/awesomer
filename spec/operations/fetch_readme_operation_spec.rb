# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FetchReadmeOperation, :vcr do
  include Dry::Monads[:result]
  subject(:operation) { described_class.new }

  # Using Polycarbohydrate/awesome-tor as the primary test target for VCR
  let(:repo_identifier_owner_repo) { 'Polycarbohydrate/awesome-tor' }
  let(:repo_identifier_url) { 'https://github.com/Polycarbohydrate/awesome-tor' }
  let(:cassette_name_awesome_tor) { 'github/polycarbohydrate_awesome-tor_details' } # Single cassette for all data for this repo

  shared_examples 'a successful README fetch' do |identifier_type|
    let(:current_repo_identifier) { identifier_type == :owner_repo ? repo_identifier_owner_repo : repo_identifier_url }
    it 'fetches readme, commit date, description, and repo details successfully' do
      VCR.use_cassette(cassette_name_awesome_tor, record: :once) do # record: :once to capture all calls first time
        result = operation.call(repo_identifier: current_repo_identifier)
        expect(result).to be_success

        data = result.value!
        expect(data).to be_a(Hash)
        expect(data[:content]).to be_a(String).and(include("awesome-tor"))
        expect(data[:name]).to match(/README/i) # README.md, README.rst etc.
        expect(data[:owner].downcase).to eq('polycarbohydrate')
        expect(data[:repo].downcase).to eq('awesome-tor')
        expect(data[:repo_description]).to be_a(String) # Or be_nil if repo has no description
        # Last commit date can be Time or nil if not found/error
        expect(data[:last_commit_at]).to (be_a(Time).or be_nil), \
          "Expected last_commit_at to be a Time or nil, got: #{data[:last_commit_at].class} (#{data[:last_commit_at]})"
      end
    end
  end

  context 'with a valid repo_identifier (owner/repo)' do
    it_behaves_like 'a successful README fetch', :owner_repo
  end

  context 'with a valid GitHub URL' do
    it_behaves_like 'a successful README fetch', :url
  end

  context 'with a repository that has no README or does not exist' do
    let(:repo_identifier) { 'empty-owner/empty-repo-that-does-not-exist' }

    it 'returns a Failure (likely from repo_data or readme fetch)' do
      VCR.use_cassette('github/empty-owner_empty-repo-for-readme-test_details') do
        result = operation.call(repo_identifier:)
        expect(result).to be_failure
        # Error could be from fetch_repo_data or fetch_readme_from_github
        expect(result.failure).to match(/Failed to fetch repo data|README not found/)
      end
    end
  end

  context 'with an invalid repo_identifier format' do
    let(:repo_identifier) { 'invalid_repo_id' }

    it 'returns a Failure' do
      result = operation.call(repo_identifier:)
      expect(result).to be_failure
      expect(result.failure).to eq("Invalid GitHub repository identifier: #{repo_identifier}. Expected 'owner/repo' or full URL.")
    end
  end

  context 'when GitHub API for repo data returns an error' do
    let(:repo_identifier) { 'Polycarbohydrate/awesome-tor' }

    before do
      # Mock failure specifically for the fetch_repo_data call
      allow(operation).to receive(:fetch_repo_data).with(owner: 'Polycarbohydrate', repo_name: 'awesome-tor')
        .and_return(Failure("Simulated API error fetching repo data"))
    end

    it 'returns the specific Failure' do
      result = operation.call(repo_identifier:)
      expect(result).to be_failure
      expect(result.failure).to eq("Simulated API error fetching repo data")
    end
  end

  context 'when fetching README last commit date returns nil (graceful failure)' do
    let(:repo_identifier) { 'Polycarbohydrate/awesome-tor' }

    before do
      # Mock other calls to succeed
      # Mock this specific method to return Success(nil) as it does on error
      allow(operation).to receive_messages(decode_readme_content: Success("decoded content"), fetch_readme_from_github: Success({'content' => Base64.encode64("content"), 'encoding' => 'base64', 'name' => 'README.md'}), fetch_readme_last_commit_date: Success(nil), fetch_repo_data: Success({'description' => 'Test Desc'}), parse_repo_identifier: Success([ "Polycarbohydrate", "awesome-tor" ]))
    end

    it 'succeeds overall but last_commit_at is nil' do
      result = operation.call(repo_identifier:)
      expect(result).to be_success
      expect(result.value![:last_commit_at]).to be_nil
      expect(result.value![:content]).to eq("decoded content")
    end
  end
end
