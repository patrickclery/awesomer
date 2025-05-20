# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FindOrCreateAwesomeListOperation do
  include Dry::Monads[:result]

  subject(:operation) { described_class.new }

  let(:owner) { "test-owner" }
  let(:repo_name) { "test-repo" }
  let(:repo_shortname) { "#{owner}/#{repo_name}" }
  let(:repo_description) { "A test awesome list." }
  let(:readme_commit_date) { Time.zone.parse('2024-01-10T10:00:00Z') }
  let(:fetched_data) do
    {
      content: '## Some Content',
      last_commit_at: readme_commit_date,
      name: 'README.md',
      owner:,
      repo: repo_name,
      repo_description: # Readme content, not directly used by this op
    }
  end

  context 'when AwesomeList does not exist' do
    it 'creates a new AwesomeList record and returns Success(record)' do
      expect { operation.call(fetched_repo_data: fetched_data) }
        .to change(AwesomeList, :count).by(1)

      result = operation.call(fetched_repo_data: fetched_data)
      expect(result).to be_success
      aw_list = result.value!
      expect(aw_list).to be_a(AwesomeList)
      expect(aw_list.github_repo).to eq(repo_shortname)
      expect(aw_list.name).to eq(repo_name)
      expect(aw_list.description).to eq(repo_description)
      expect(aw_list.last_commit_at).to be_within(1.second).of(readme_commit_date)
      expect(aw_list).to be_persisted
    end
  end

  context 'when AwesomeList already exists' do
    let!(:existing_list) do
      AwesomeList.create!(
        description: "Old Description",
        github_repo: repo_shortname,
        last_commit_at: readme_commit_date - 1.day,
        name: "Old Name"
      )
    end

    it 'updates the existing AwesomeList record and returns Success(record)' do
      expect { operation.call(fetched_repo_data: fetched_data) }
        .not_to change(AwesomeList, :count)

      result = operation.call(fetched_repo_data: fetched_data)
      expect(result).to be_success
      aw_list = result.value!
      expect(aw_list.id).to eq(existing_list.id)
      expect(aw_list.name).to eq(repo_name)
      expect(aw_list.description).to eq(repo_description)
      expect(aw_list.last_commit_at).to be_within(1.second).of(readme_commit_date)
    end
  end

  context 'when owner or repo name is missing in fetched_data' do
    let(:incomplete_data) { fetched_data.merge(owner: nil) }

    it 'returns a Failure' do
      result = operation.call(fetched_repo_data: incomplete_data)
      expect(result).to be_failure
      expect(result.failure).to eq("Owner or repo name missing from fetched data")
    end
  end

  context 'when AwesomeList save fails (e.g., validation error)' do
    before do
      allow_any_instance_of(AwesomeList).to receive(:save).and_return(false)
      # Simulate AR errors object
      errors_double = instance_double(ActiveModel::Errors, full_messages: [ "Validation failed" ])
      allow_any_instance_of(AwesomeList).to receive(:errors).and_return(errors_double)
    end

    it 'returns a Failure with error messages' do
      result = operation.call(fetched_repo_data: fetched_data)
      expect(result).to be_failure
      expect(result.failure).to eq("Failed to save AwesomeList record for #{repo_shortname}: Validation failed")
    end
  end

  context 'when a database error occurs during save' do
    before do
      allow_any_instance_of(AwesomeList).to receive(:save).and_raise(ActiveRecord::StatementInvalid.new("DB down"))
    end

    it 'returns a Failure with the DB error message' do
      result = operation.call(fetched_repo_data: fetched_data)
      expect(result).to be_failure
      expect(result.failure).to eq("Database error saving AwesomeList for #{repo_shortname}: DB down")
    end
  end
end
