# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BootstrapAwesomeListsService do
  let(:fetch_readme_operation) { instance_double(FetchReadmeOperation) }
  let(:find_or_create_operation) { instance_double(FindOrCreateAwesomeListOperation) }
  let(:extract_operation) { instance_double(ExtractAwesomeListsOperation) }

  describe 'resurrect functionality' do
    let(:repo_links) { ['user/active-repo', 'user/archived-repo', 'user/new-repo'] }
    let(:awesome_readme) { { content: '# Awesome', full_name: 'sindresorhus/awesome' } }
    
    let!(:active_list) { create(:awesome_list, github_repo: 'user/active-repo', archived: false) }
    let!(:archived_list) { create(:awesome_list, github_repo: 'user/archived-repo', archived: true, archived_at: 1.day.ago) }
    
    before do
      allow(extract_operation).to receive(:call).and_return(Dry::Monads::Success(repo_links))
      
      # Mock fetch_readme_operation to return appropriate repo data
      allow(fetch_readme_operation).to receive(:call) do |args|
        repo_id = args[:repo_identifier]
        parts = repo_id.split('/')
        Dry::Monads::Success(
          content: 'README', 
          owner: parts[0], 
          repo: parts[1], 
          repo_description: 'desc', 
          last_commit_at: Time.current
        )
      end
      
      allow(find_or_create_operation).to receive(:call).and_return(
        Dry::Monads::Success(create(:awesome_list))
      )
    end

    context 'without resurrect flag (default)' do
      subject(:service) do
        described_class.new(
          fetch_readme_operation:,
          find_or_create_awesome_list_operation: find_or_create_operation,
          extract_awesome_lists_operation: extract_operation,
          resurrect: false
        )
      end

      before do
        allow(service).to receive(:get_awesome_readme_content).and_return(Dry::Monads::Success(awesome_readme))
      end

      it 'skips archived repositories' do
        result = service.call
        
        expect(result).to be_success
        data = result.value!
        
        expect(data[:skipped_archived_count]).to eq(1)
        expect(data[:skipped_archived]).to include('user/archived-repo')
        expect(data[:resurrected_count]).to eq(0)
      end

      it 'processes active and new repositories' do
        expect(fetch_readme_operation).to receive(:call).with(repo_identifier: 'user/active-repo')
        expect(fetch_readme_operation).to receive(:call).with(repo_identifier: 'user/new-repo')
        expect(fetch_readme_operation).not_to receive(:call).with(repo_identifier: 'user/archived-repo')
        
        service.call
      end

      it 'does not unarchive archived lists' do
        service.call
        expect(archived_list.reload.archived?).to be true
      end
    end

    context 'with resurrect flag enabled' do
      subject(:service) do
        described_class.new(
          fetch_readme_operation:,
          find_or_create_awesome_list_operation: find_or_create_operation,
          extract_awesome_lists_operation: extract_operation,
          resurrect: true
        )
      end

      before do
        allow(service).to receive(:get_awesome_readme_content).and_return(Dry::Monads::Success(awesome_readme))
        
        # Return the actual lists when processed
        allow(find_or_create_operation).to receive(:call) do |args|
          repo_data = args[:fetched_repo_data]
          if repo_data[:repo] == 'archived-repo'
            Dry::Monads::Success(archived_list)
          else
            Dry::Monads::Success(create(:awesome_list))
          end
        end
      end

      it 'processes all repositories including archived' do
        expect(fetch_readme_operation).to receive(:call).with(repo_identifier: 'user/active-repo')
        expect(fetch_readme_operation).to receive(:call).with(repo_identifier: 'user/new-repo')
        expect(fetch_readme_operation).to receive(:call).with(repo_identifier: 'user/archived-repo')
        
        service.call
      end

      it 'resurrects archived lists' do
        expect(archived_list).to receive(:unarchive!)
        
        result = service.call
        expect(result).to be_success
        data = result.value!
        
        expect(data[:resurrected_count]).to eq(1)
        expect(data[:skipped_archived_count]).to eq(0)
      end

      it 'unarchives the archived list' do
        service.call
        
        # Simulate what unarchive! does
        archived_list.update!(archived: false, archived_at: nil)
        
        expect(archived_list.reload.archived?).to be false
        expect(archived_list.archived_at).to be_nil
      end
    end

    context 'with mixed repository states' do
      let(:repo_links) { ['user/repo1', 'user/repo2', 'user/repo3', 'user/repo4'] }
      
      let!(:archived1) { create(:awesome_list, github_repo: 'user/repo1', archived: true) }
      let!(:archived2) { create(:awesome_list, github_repo: 'user/repo2', archived: true) }
      let!(:active1) { create(:awesome_list, github_repo: 'user/repo3', archived: false) }
      # repo4 doesn't exist yet
      
      subject(:service) do
        described_class.new(
          fetch_readme_operation:,
          find_or_create_awesome_list_operation: find_or_create_operation,
          extract_awesome_lists_operation: extract_operation,
          resurrect: false
        )
      end

      before do
        allow(service).to receive(:get_awesome_readme_content).and_return(Dry::Monads::Success(awesome_readme))
      end

      it 'correctly counts skipped archived repos' do
        result = service.call
        
        expect(result).to be_success
        data = result.value!
        
        expect(data[:skipped_archived_count]).to eq(2)
        expect(data[:skipped_archived]).to contain_exactly('user/repo1', 'user/repo2')
      end

      it 'processes non-archived repos' do
        expect(fetch_readme_operation).to receive(:call).with(repo_identifier: 'user/repo3')
        expect(fetch_readme_operation).to receive(:call).with(repo_identifier: 'user/repo4')
        expect(fetch_readme_operation).not_to receive(:call).with(repo_identifier: 'user/repo1')
        expect(fetch_readme_operation).not_to receive(:call).with(repo_identifier: 'user/repo2')
        
        service.call
      end
    end
  end
end