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
      fetch_from_github: true, # Default to fetching from GitHub for tests
      fetch_readme_operation: fetch_readme_op_double,
      find_or_create_awesome_list_operation: find_or_create_awesome_list_op_double,
      limit: nil # No limit for most tests
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
    context 'when bootstrap completes successfully with GitHub fetch' do
      before do
        # Mock fetching sindresorhus/awesome
        allow(fetch_readme_op_double).to receive(:call)
          .with(repo_identifier: 'sindresorhus/awesome')
          .and_return(Success(sindresorhus_readme_data))

        # Mock File.write for saving local file
        allow(File).to receive(:write).with(Rails.root.join('static', 'bootstrap.md'), anything)

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
        expect(extract_awesome_lists_op_double).to receive(:call)
          .with(markdown_content: sindresorhus_readme_data[:content]).ordered
        expect(fetch_readme_op_double).to receive(:call).with(repo_identifier: 'sindresorhus/awesome-nodejs').ordered
        expect(find_or_create_awesome_list_op_double).to receive(:call)
          .with(fetched_repo_data: nodejs_readme_data).ordered
        expect(fetch_readme_op_double).to receive(:call).with(repo_identifier: 'vinta/awesome-python').ordered
        expect(find_or_create_awesome_list_op_double).to receive(:call)
          .with(fetched_repo_data: python_readme_data).ordered

        service.call
      end
    end

    context 'when using local file mode' do
      let(:service) do
        described_class.new(
          extract_awesome_lists_operation: extract_awesome_lists_op_double,
          fetch_from_github: false,
          fetch_readme_operation: fetch_readme_op_double,
          find_or_create_awesome_list_operation: find_or_create_awesome_list_op_double,
          limit: nil
        )
      end

      let(:bootstrap_file_path) { Rails.root.join('static', 'bootstrap.md') }

      before do
        # Mock local file existence and content
        allow(File).to receive(:exist?).with(bootstrap_file_path).and_return(true)
        allow(File).to receive(:read).with(bootstrap_file_path).and_return(sindresorhus_readme_data[:content])
        allow(File).to receive(:mtime).with(bootstrap_file_path).and_return(Time.current)

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

      example 'uses local file and returns success' do
        result = service.call
        expect(result).to be_success

        summary = result.value!
        expect(summary[:successful_count]).to eq(2)
        expect(summary[:failed_count]).to eq(0)
        expect(summary[:total_processed]).to eq(2)
      end

      example 'does not fetch from GitHub' do
        expect(fetch_readme_op_double).not_to receive(:call).with(repo_identifier: 'sindresorhus/awesome')
        service.call
      end
    end

    context 'when local file does not exist' do
      let(:service) do
        described_class.new(
          extract_awesome_lists_operation: extract_awesome_lists_op_double,
          fetch_from_github: false,
          fetch_readme_operation: fetch_readme_op_double,
          find_or_create_awesome_list_operation: find_or_create_awesome_list_op_double,
          limit: nil
        )
      end

      before do
        allow(File).to receive(:exist?).with(Rails.root.join('static', 'bootstrap.md')).and_return(false)
      end

      example 'returns failure with helpful message' do
        result = service.call
        expect(result).to be_failure
        expect(result.failure).to include('Local bootstrap.md file not found')
        expect(result.failure).to include('Use --fetch to download it')
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
        allow(File).to receive(:write).with(Rails.root.join('static', 'bootstrap.md'), anything)

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
        allow(File).to receive(:write).with(Rails.root.join('static', 'bootstrap.md'), anything)

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

    context 'when limit is specified' do
      let(:service) do
        described_class.new(
          extract_awesome_lists_operation: extract_awesome_lists_op_double,
          fetch_from_github: true,
          fetch_readme_operation: fetch_readme_op_double,
          find_or_create_awesome_list_operation: find_or_create_awesome_list_op_double,
          limit: 1 # Limit to 1 repository
        )
      end

      before do
        # Mock fetching sindresorhus/awesome
        allow(fetch_readme_op_double).to receive(:call)
          .with(repo_identifier: 'sindresorhus/awesome')
          .and_return(Success(sindresorhus_readme_data))
        allow(File).to receive(:write).with(Rails.root.join('static', 'bootstrap.md'), anything)

        # Mock extracting repository links
        allow(extract_awesome_lists_op_double).to receive(:call)
          .with(markdown_content: sindresorhus_readme_data[:content])
          .and_return(Success(extracted_repo_links))

        # Mock fetching only the first repository
        allow(fetch_readme_op_double).to receive(:call)
          .with(repo_identifier: 'sindresorhus/awesome-nodejs')
          .and_return(Success(nodejs_readme_data))

        # Mock creating AwesomeList record for first repo only
        allow(find_or_create_awesome_list_op_double).to receive(:call)
          .with(fetched_repo_data: nodejs_readme_data)
          .and_return(Success(nodejs_awesome_list))
      end

      example 'processes only the limited number of repositories' do
        result = service.call
        expect(result).to be_success

        summary = result.value!
        expect(summary[:successful_count]).to eq(1)
        expect(summary[:failed_count]).to eq(0)
        expect(summary[:total_processed]).to eq(1) # Should be limited to 1
        expect(summary[:successful_records]).to contain_exactly(nodejs_awesome_list)
      end

      example 'does not call operations for repositories beyond the limit' do
        # Should not fetch the second repository
        expect(fetch_readme_op_double).not_to receive(:call).with(repo_identifier: 'vinta/awesome-python')
        expect(find_or_create_awesome_list_op_double).not_to receive(:call).with(fetched_repo_data: python_readme_data)

        service.call
      end
    end

    context 'when no repositories are found' do
      before do
        allow(fetch_readme_op_double).to receive(:call)
          .with(repo_identifier: 'sindresorhus/awesome')
          .and_return(Success(sindresorhus_readme_data))
        allow(File).to receive(:write).with(Rails.root.join('static', 'bootstrap.md'), anything)

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
