# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FetchReadmeOperation, :vcr do # Apply VCR to all examples
  include Dry::Monads[:result]

  subject(:operation) { described_class.new }

  context 'with a valid repo_identifier (owner/repo)' do
    # Using a known public repo that is unlikely to disappear or change its README drastically
    let(:repo_identifier) { 'Polycarbohydrate/awesome-tor' }

    it 'fetches and decodes the README content successfully' do
      VCR.use_cassette('github/polycarbohydrate_awesome_tor') do
        result = operation.call(repo_identifier:)
        expect(result).to be_success
        expect(result.value!).to be_a(String)
        expect(result.value!.downcase).to include("awesome-tor")
      end
    end
  end

  context 'with a valid GitHub URL' do
    let(:repo_identifier) { 'https://github.com/Polycarbohydrate/awesome-tor' }

    it 'fetches and decodes the README content successfully' do
      VCR.use_cassette('github/polycarbohydrate_awesome_tor') do
        result = operation.call(repo_identifier:)
        expect(result).to be_success
        expect(result.value!).to be_a(String)
        expect(result.value!.downcase).to include("awesome-tor")
      end
    end
  end

  context 'with a repository that has no README' do
    # Note: Finding a repo guaranteed to *never* have a README is tricky.
    # This test might become fragile or need a dedicated test repo.
    # For now, we'll use a less common repo or a non-existent one for the cassette.
    # The GitHub API returns 404 if a README isn't found at the default path.
    let(:repo_identifier) { 'empty-owner/empty-repo-for-readme-test' } # This repo should not exist

    it 'returns a Failure' do
      VCR.use_cassette('github/no_readme_repo') do
        result = operation.call(repo_identifier:)
        expect(result).to be_failure
        expect(result.failure).to eq("README not found for repository: empty-owner/empty-repo-for-readme-test")
      end
    end
  end

  context 'with an invalid repo_identifier format' do
    let(:repo_identifier) { 'invalid_repo_id' }

    it 'returns a Failure' do
      # No VCR needed as it fails before API call
      result = operation.call(repo_identifier:)
      expect(result).to be_failure
      expect(result.failure).to eq("Invalid GitHub repository identifier: #{repo_identifier}. Expected 'owner/repo' or full URL.")
    end
  end

  # Removed VCR for this context to directly mock Net::HTTP
  context 'when GitHub API returns an error (e.g., server error)' do
    let(:repo_identifier) { 'Polycarbohydrate/awesome-tor' }
    let(:http_double) { instance_double(Net::HTTP) }
    let(:error_response) do
      instance_double(Net::HTTPInternalServerError,
                      body: "{\"message\": \"Server Error\"}",
                      code: "500",
                      message: "Internal Server Error")
    end

    before do
      allow(Net::HTTP).to receive(:new).and_return(http_double)
      allow(http_double).to receive(:use_ssl=)
      allow(http_double).to receive(:request).and_return(error_response)
    end

    it 'returns a Failure with the API error' do
      result = operation.call(repo_identifier:)
      expect(result).to be_failure
      expect(result.failure).to match(%r{GitHub API request for README failed for Polycarbohydrate/awesome-tor: 500 Internal Server Error})
    end
  end

  context 'when network error occurs' do
    let(:repo_identifier) { 'Polycarbohydrate/awesome-tor' }

    before do
      allow_any_instance_of(Net::HTTP).to receive(:request).and_raise(SocketError.new("Failed to open TCP connection"))
    end

    it 'returns a Failure' do
      # VCR might not be ideal here as we are testing a low-level network error simulation.
      # If VCR is on, it might try to play back a cassette. We want to force the SocketError.
      # Forcing VCR off for this specific example might be an option, or ensure WebMock raises.
      # WebMock.disable_net_connect!(allow_localhost: true) is usually active with VCR.

      # This will run without VCR recording if `allow_http_connections_when_no_cassette = false` (default VCR)
      # and no cassette matches. The mock will take effect.
      result = operation.call(repo_identifier:)
      expect(result).to be_failure
      expect(result.failure).to include("Network error while fetching README for Polycarbohydrate/awesome-tor: Failed to open TCP connection")
    end
  end
end
