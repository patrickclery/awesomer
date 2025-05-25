# frozen_string_literal: true

require 'rails_helper'
# VCR is usually required in spec_helper or rails_helper
# require 'vcr'

# Note: Structs::Category, Structs::CategoryItem, and ParseMarkdownOperation
# are expected to be available via Rails eager loading.

# Custom VCR helper will be used from support files (loaded by rails_helper)

RSpec.describe SyncGitStatsOperation, :vcr do # Apply VCR to all examples in this describe block
  include Dry::Monads[:result] # Include monads for direct Success/Failure usage in tests
  include Test::Support::VCR # Ensure custom helper is available
  # ActiveSupport::Testing::TimeHelpers is included via rails_helper

  subject(:operation_call) { described_class.new.call(categories: initial_categories) }

  let(:markdown_content) { File.read(Rails.root.join('spec/fixtures/awesome_self_hosted_snippet.md')) }
  let!(:initial_categories) do # Use let! to ensure ParseMarkdownOperation runs before mocks might be needed
    parse_result = ParseMarkdownOperation.new.call(markdown_content:)
    # Allow parsing to fail if fixture is bad, but this spec focuses on SyncGitStatsOperation
    parse_result.success? ? parse_result.value! : []
  end

  # Removed stats_fetcher_mock and App::Container.stub

  # Identify GitHub items from the fixture based on ParseMarkdownOperation's output
  # Davis: https://github.com/tchapi/davis
  # Xandikos: https://github.com/jelmer/xandikos
  let(:davis_item_original) do
    # Ensure initial_categories is not empty and has a first element
    return nil if initial_categories.empty? || initial_categories.first[:items].empty?
    initial_categories.first[:items].find { |item| item[:primary_url] == 'https://github.com/tchapi/davis' }
  end
  let(:xandikos_item_original) do
    return nil if initial_categories.empty? || initial_categories.first[:items].empty?
    initial_categories.first[:items].find { |item| item[:primary_url] == 'https://github.com/jelmer/xandikos' }
  end

  describe '#call' do
    context 'when categories are provided' do
      before do
        allow(ProcessMarkdownWithStatsJob).to receive(:perform_later)
      end

      it 'returns a Success result' do
        expect(operation_call).to be_success
      end

      it 'returns the original categories unchanged' do
        result = operation_call.value!
        expect(result).to eq(initial_categories)

        # Verify that the original objects are returned (not modified)
        if davis_item_original
          returned_davis_item = result.first[:items].find { |item| item[:primary_url] == 'https://github.com/tchapi/davis' }
          expect(returned_davis_item).to be(davis_item_original)
          expect(returned_davis_item[:stars]).to be_nil # No stats yet
        end
      end

      it 'queues a ProcessMarkdownWithStatsJob with serialized categories' do
        expect(ProcessMarkdownWithStatsJob).to receive(:perform_later) do |args|
          expect(args[:categories]).to be_an(Array)
          expect(args[:categories].first).to be_a(Hash)
          expect(args[:categories].first[:name]).to eq(initial_categories.first[:name])
          expect(args[:repo_identifier]).to be_nil # No repo_identifier passed in this test
        end

        operation_call
      end

      it 'logs the appropriate messages' do
        expect(Rails.logger).to receive(:info).with(/Queueing background jobs for GitHub stats/)
        expect(Rails.logger).to receive(:info).with(/Background job queued successfully/)

        operation_call
      end

      context 'when repo_identifier is provided' do
        subject(:operation_call_with_repo) {
          described_class.new.call(categories: initial_categories, repo_identifier:)
        }

        let(:repo_identifier) { 'awesome-selfhosted/awesome-selfhosted' }

        it 'passes repo_identifier to the background job' do
          expect(ProcessMarkdownWithStatsJob).to receive(:perform_later) do |args|
            expect(args[:categories]).to be_an(Array)
            expect(args[:repo_identifier]).to eq(repo_identifier)
          end

          operation_call_with_repo
        end
      end
    end

    context 'when categories array is empty' do
      let(:initial_categories) { [] }

      before do
        allow(ProcessMarkdownWithStatsJob).to receive(:perform_later)
      end

      it 'returns Success with an empty array' do
        expect(operation_call).to be_success
        expect(operation_call.value!).to eq([])
      end

      it 'still queues the background job' do
        expect(ProcessMarkdownWithStatsJob).to receive(:perform_later) do |args|
          expect(args[:categories]).to eq([])
          expect(args[:repo_identifier]).to be_nil
        end
        operation_call
      end
    end

    context 'when a category has no items' do
      let(:initial_categories) { [ {custom_order: 0, items: [], name: "Empty Cat"} ] }

      before do
        allow(ProcessMarkdownWithStatsJob).to receive(:perform_later)
      end

      it 'returns Success with the category unchanged' do
        expect(operation_call).to be_success
        updated_category = operation_call.value!.first
        expect(updated_category[:name]).to eq("Empty Cat")
        expect(updated_category[:items]).to be_empty
      end
    end

    context 'when an error occurs' do
      before do
        allow(ProcessMarkdownWithStatsJob).to receive(:perform_later).and_raise(StandardError.new("Job queue error"))
      end

      it 'returns a Failure result' do
        expect(operation_call).to be_failure
        expect(operation_call.failure).to include("SyncGitStatsOperation failed: Job queue error")
      end
    end
  end
end
