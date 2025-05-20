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

  context 'with a non-existent repository' do
    let(:repo_identifier) { 'nonexistent-owner/nonexistent-repo-for-test' }

    it 'returns a Failure (from repo_data fetch)' do
      VCR.use_cassette('github/octokit_nonexistent-owner_nonexistent-repo', record: :new_episodes) do
        result = operation.call(repo_identifier:)
        expect(result).to be_failure
        expect(result.failure).to eq("Repository not found: nonexistent-owner/nonexistent-repo-for-test")
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

  context 'when Octokit client cannot find the repository data (Octokit::NotFound)' do
    let(:repo_identifier) { 'polycarbohydrate/private-repo-test' }
    let(:octokit_client_double) { instance_double(Octokit::Client) }

    before do
      allow(Octokit::Client).to receive(:new).and_return(octokit_client_double)
      allow(octokit_client_double).to receive(:repository).with(repo_identifier).and_raise(Octokit::NotFound)
    end

    it 'returns a Failure indicating repository not found' do
      result = operation.call(repo_identifier:)
      expect(result).to be_failure
      expect(result.failure).to eq("Repository not found: #{repo_identifier}")
    end
  end

  context 'when Octokit client cannot find README for an existing repository (Octokit::NotFound)' do
    let(:repo_identifier) { 'octokit/octokit.rb' }
    let(:octokit_client_double) { instance_double(Octokit::Client) }
    let(:mock_repo_data) { double('Octokit::Resource', description: "An awesome list.") }

    before do
      allow(Octokit::Client).to receive(:new).and_return(octokit_client_double)
      allow(octokit_client_double).to receive(:repository).with(repo_identifier).and_return(mock_repo_data)
      allow(octokit_client_double).to receive(:readme).with(repo_identifier).and_raise(Octokit::NotFound)
    end

    it 'returns a Failure indicating README not found' do
      result = operation.call(repo_identifier:)
      expect(result).to be_failure
      expect(result.failure).to eq("README not found for repository: #{repo_identifier}")
    end
  end

  context 'when a network error occurs (simulated via StandardError)' do
    let(:repo_identifier) { 'Polycarbohydrate/awesome-tor' }
    let(:octokit_client_double) { instance_double(Octokit::Client) }

    before do
      allow(Octokit::Client).to receive(:new).and_return(octokit_client_double)
      allow(octokit_client_double).to receive(:repository).with("Polycarbohydrate/awesome-tor")
        .and_raise(StandardError.new("Simulated low-level network problem"))
    end

    it 'returns a Failure' do
      result = operation.call(repo_identifier:)
      expect(result).to be_failure
      expect(result.failure).to include("Unexpected error fetching repo data for Polycarbohydrate/awesome-tor: Simulated low-level network problem")
    end
  end
end
