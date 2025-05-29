# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BootstrapAwesomeListsService do
  include Dry::Monads[:result]

  let(:fetch_readme_op_double) { instance_double(FetchReadmeOperation) }
  let(:find_or_create_awesome_list_op_double) { instance_double(FindOrCreateAwesomeListOperation) }
  let(:extract_awesome_lists_op_double) { instance_double(ExtractAwesomeListsOperation) }

  let(:service) do
    described_class.new(
      extract_awesome_lists_operation: extract_awesome_lists_op_double,
      fetch_readme_operation: fetch_readme_op_double,
      find_or_create_awesome_list_operation: find_or_create_awesome_list_op_double
    )
  end

  let(:sindresorhus_readme_data) do
    {
      content: "# Awesome\n- [Node.js](https://github.com/sindresorhus/awesome-nodejs)\n- [Python](https://github.com/vinta/awesome-python)",
      last_commit_at: Time.zone.parse('2024-01-15T10:00:00Z'),
      name: 'README.md',
      owner: 'sindresorhus',
      repo: 'awesome',
      repo_description: 'Awesome lists about all kinds of interesting topics'
    }
  end

  let(:extracted_repo_links) do
    [
      'sindresorhus/awesome-nodejs',
      'vinta/awesome-python'
    ]
  end

  let(:nodejs_readme_data) do
    {
      content: '# Awesome Node.js',
      last_commit_at: Time.zone.parse('2024-01-10T10:00:00Z'),
      name: 'README.md',
      owner: 'sindresorhus',
      repo: 'awesome-nodejs',
      repo_description: 'Delightful Node.js packages and resources'
    }
  end

  let(:python_readme_data) do
    {
      content: '# Awesome Python',
      last_commit_at: Time.zone.parse('2024-01-12T15:30:00Z'),
      name: 'README.md',
      owner: 'vinta',
      repo: 'awesome-python',
      repo_description: 'A curated list of awesome Python frameworks, libraries, software and resources'
    }
  end

  let(:nodejs_awesome_list) do
    instance_double(AwesomeList,
                    description: 'Delightful Node.js packages and resources',
                    github_repo: 'sindresorhus/awesome-nodejs',
                    id: 1,
                    name: 'awesome-nodejs')
  end

  let(:python_awesome_list) do
    instance_double(AwesomeList,
                    description: 'A curated list of awesome Python frameworks, libraries, software and resources',
                    github_repo: 'vinta/awesome-python',
                    id: 2,
                    name: 'awesome-python')
  end

  describe '#call' do
    context 'when bootstrap completes successfully' do
      before do
        # Mock fetching sindresorhus/awesome
        allow(fetch_readme_op_double).to receive(:call)
          .with(repo_identifier: 'sindresorhus/awesome')
          .and_return(Success(sindresorhus_readme_data))

        # Mock extracting repository links
        allow(extract_awesome_lists_op_double).to receive(:call)
          .with(markdown_content: sindresorhus_readme_data[:content])
          .and_return(Success(extracted_repo_links))

        # Mock fetching individual repository data
        allow(fetch_readme_op_double).to receive(:call)
          .with(repo_identifier: 'sindresorhus/awesome-nodejs')
          .and_return(Success(nodejs_readme_data))

        allow(fetch_readme_op_double).to receive(:call)
          .with(repo_identifier: 'vinta/awesome-python')
          .and_return(Success(python_readme_data))

        # Mock creating AwesomeList records
        allow(find_or_create_awesome_list_op_double).to receive(:call)
          .with(fetched_repo_data: nodejs_readme_data)
          .and_return(Success(nodejs_awesome_list))

        allow(find_or_create_awesome_list_op_double).to receive(:call)
          .with(fetched_repo_data: python_readme_data)
          .and_return(Success(python_awesome_list))
      end

      example 'returns success with summary data' do
        result = service.call
        expect(result).to be_success

        summary = result.value!
        expect(summary[:successful_count]).to eq(2)
        expect(summary[:failed_count]).to eq(0)
        expect(summary[:total_processed]).to eq(2)
        expect(summary[:successful_records]).to contain_exactly(nodejs_awesome_list, python_awesome_list)
        expect(summary[:failed_repos]).to be_empty
      end

      example 'calls operations in correct sequence' do
        expect(fetch_readme_op_double).to receive(:call).with(repo_identifier: 'sindresorhus/awesome').ordered
        expect(extract_awesome_lists_op_double).to receive(:call).with(markdown_content: sindresorhus_readme_data[:content]).ordered
        expect(fetch_readme_op_double).to receive(:call).with(repo_identifier: 'sindresorhus/awesome-nodejs').ordered
        expect(find_or_create_awesome_list_op_double).to receive(:call).with(fetched_repo_data: nodejs_readme_data).ordered
        expect(fetch_readme_op_double).to receive(:call).with(repo_identifier: 'vinta/awesome-python').ordered
        expect(find_or_create_awesome_list_op_double).to receive(:call).with(fetched_repo_data: python_readme_data).ordered

        service.call
      end
    end

    context 'when fetching sindresorhus/awesome fails' do
      before do
        allow(fetch_readme_op_double).to receive(:call)
          .with(repo_identifier: 'sindresorhus/awesome')
          .and_return(Failure('Repository not found'))
      end

      example 'returns failure without processing further' do
        result = service.call
        expect(result).to be_failure
        expect(result.failure).to eq('Repository not found')

        expect(extract_awesome_lists_op_double).not_to receive(:call)
        expect(find_or_create_awesome_list_op_double).not_to receive(:call)
      end
    end

    context 'when extracting repository links fails' do
      before do
        allow(fetch_readme_op_double).to receive(:call)
          .with(repo_identifier: 'sindresorhus/awesome')
          .and_return(Success(sindresorhus_readme_data))

        allow(extract_awesome_lists_op_double).to receive(:call)
          .with(markdown_content: sindresorhus_readme_data[:content])
          .and_return(Failure('Failed to parse markdown'))
      end

      example 'returns failure without processing repositories' do
        result = service.call
        expect(result).to be_failure
        expect(result.failure).to eq('Failed to parse markdown')

        expect(find_or_create_awesome_list_op_double).not_to receive(:call)
      end
    end

    context 'when some repositories fail to process' do
      before do
        # Mock successful initial steps
        allow(fetch_readme_op_double).to receive(:call)
          .with(repo_identifier: 'sindresorhus/awesome')
          .and_return(Success(sindresorhus_readme_data))

        allow(extract_awesome_lists_op_double).to receive(:call)
          .with(markdown_content: sindresorhus_readme_data[:content])
          .and_return(Success(extracted_repo_links))

        # Mock successful first repository
        allow(fetch_readme_op_double).to receive(:call)
          .with(repo_identifier: 'sindresorhus/awesome-nodejs')
          .and_return(Success(nodejs_readme_data))

        allow(find_or_create_awesome_list_op_double).to receive(:call)
          .with(fetched_repo_data: nodejs_readme_data)
          .and_return(Success(nodejs_awesome_list))

        # Mock failed second repository
        allow(fetch_readme_op_double).to receive(:call)
          .with(repo_identifier: 'vinta/awesome-python')
          .and_return(Failure('Repository not found'))
      end

      example 'continues processing and returns partial success' do
        result = service.call
        expect(result).to be_success

        summary = result.value!
        expect(summary[:successful_count]).to eq(1)
        expect(summary[:failed_count]).to eq(1)
        expect(summary[:total_processed]).to eq(2)
        expect(summary[:successful_records]).to contain_exactly(nodejs_awesome_list)
        expect(summary[:failed_repos].size).to eq(1)
        expect(summary[:failed_repos].first[:repo]).to eq('vinta/awesome-python')
        expect(summary[:failed_repos].first[:error]).to include('Repository not found')
      end
    end

    context 'when no repositories are found' do
      before do
        allow(fetch_readme_op_double).to receive(:call)
          .with(repo_identifier: 'sindresorhus/awesome')
          .and_return(Success(sindresorhus_readme_data))

        allow(extract_awesome_lists_op_double).to receive(:call)
          .with(markdown_content: sindresorhus_readme_data[:content])
          .and_return(Success([]))
      end

      example 'returns success with zero counts' do
        result = service.call
        expect(result).to be_success

        summary = result.value!
        expect(summary[:successful_count]).to eq(0)
        expect(summary[:failed_count]).to eq(0)
        expect(summary[:total_processed]).to eq(0)
        expect(summary[:successful_records]).to be_empty
        expect(summary[:failed_repos]).to be_empty
      end
    end
  end
end
