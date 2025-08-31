# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SyncConfig do
  describe '.instance' do
    it 'returns a singleton instance' do
      instance1 = described_class.instance
      instance2 = described_class.instance
      expect(instance1).to be(instance2)
    end
  end

  describe 'configuration access' do
    context 'when config file exists' do
      let(:config_content) do
        <<~YAML
          default:
            batch_size: 100
            default_threshold: 20
            github:
              branch: develop
              auto_push: true
            schedule: "0 3 * * *"

          test:
            batch_size: 10
            default_threshold: 5
            github:
              branch: test
              auto_push: false
        YAML
      end

      before do
        allow(File).to receive(:exist?).with(Rails.root.join('config', 'sync.yml')).and_return(true)
        allow(File).to receive(:read).with(Rails.root.join('config', 'sync.yml')).and_return(config_content)
        described_class.reload!
      end

      it 'loads test environment config' do
        expect(described_class[:batch_size]).to eq(10)
        expect(described_class[:default_threshold]).to eq(5)
      end

      it 'provides method-style access' do
        expect(described_class.batch_size).to eq(10)
        expect(described_class.default_threshold).to eq(5)
      end

      it 'provides nested configuration access' do
        expect(described_class[:github][:branch]).to eq('test')
        expect(described_class[:github][:auto_push]).to be(false)
      end

      it 'responds to configuration keys' do
        expect(described_class).to respond_to(:batch_size)
        expect(described_class).to respond_to(:default_threshold)
      end

      it 'does not respond to non-existent keys' do
        expect(described_class).not_to respond_to(:non_existent_key)
      end
    end

    context 'when config file does not exist' do
      before do
        allow(File).to receive(:exist?).with(Rails.root.join('config', 'sync.yml')).and_return(false)
        allow(Rails.logger).to receive(:warn)
        described_class.reload!
      end

      it 'returns default configuration' do
        expect(described_class[:batch_size]).to eq(50)
        expect(described_class[:default_threshold]).to eq(10)
        expect(described_class[:github][:branch]).to eq('main')
        expect(described_class[:github][:auto_push]).to be(false)
      end

      it 'logs a warning' do
        expect(Rails.logger).to have_received(:warn).with(/Sync config file not found/)
      end
    end

    context 'when config file has ERB' do
      let(:config_content) do
        <<~YAML
          test:
            batch_size: <%= 5 * 2 %>
            github:
              branch: <%= ENV.fetch('SYNC_BRANCH', 'main') %>
        YAML
      end

      before do
        allow(File).to receive(:exist?).with(Rails.root.join('config', 'sync.yml')).and_return(true)
        allow(File).to receive(:read).with(Rails.root.join('config', 'sync.yml')).and_return(config_content)
        allow(ENV).to receive(:fetch).with('SYNC_BRANCH', 'main').and_return('feature-branch')
        described_class.reload!
      end

      it 'evaluates ERB expressions' do
        expect(described_class[:batch_size]).to eq(10)
        expect(described_class[:github][:branch]).to eq('feature-branch')
      end
    end

    context 'when config file is malformed' do
      before do
        allow(File).to receive(:exist?).with(Rails.root.join('config', 'sync.yml')).and_return(true)
        allow(File).to receive(:read).with(Rails.root.join('config', 'sync.yml')).and_return('invalid: yaml: content:')
        allow(Rails.logger).to receive(:error)
        described_class.reload!
      end

      it 'returns default configuration' do
        expect(described_class[:batch_size]).to eq(50)
        expect(described_class[:default_threshold]).to eq(10)
      end

      it 'logs an error' do
        expect(Rails.logger).to have_received(:error).with(/Failed to load sync config/)
      end
    end
  end

  describe '.reload!' do
    it 'reloads the configuration from file' do
      original_config = described_class.config
      described_class.reload!
      expect(described_class.config).not_to be(original_config)
    end
  end

  describe 'default configuration' do
    before do
      allow(File).to receive(:exist?).with(Rails.root.join('config', 'sync.yml')).and_return(false)
      described_class.reload!
    end

    it 'provides sensible defaults' do
      expect(described_class[:batch_size]).to eq(50)
      expect(described_class[:default_threshold]).to eq(10)
      expect(described_class[:timeout]).to eq(3600)
      expect(described_class[:schedule]).to eq('0 2 * * *')
    end

    it 'provides GitHub defaults' do
      github_config = described_class[:github]
      expect(github_config[:auto_push]).to be(false)
      expect(github_config[:branch]).to eq('main')
      expect(github_config[:commit_message]).to include('Auto-sync')
    end

    it 'provides rate limiting defaults' do
      rate_config = described_class[:rate_limiting]
      expect(rate_config[:max_requests_per_hour]).to eq(5000)
      expect(rate_config[:rate_limit_wait]).to eq(3600)
      expect(rate_config[:request_delay]).to eq(1)
    end

    it 'provides logging defaults' do
      log_config = described_class[:logging]
      expect(log_config[:file]).to eq('log/sync.log')
      expect(log_config[:level]).to eq('info')
      expect(log_config[:keep]).to eq(10)
      expect(log_config[:max_size]).to eq(100)
    end
  end

  describe 'accessing non-existent keys' do
    before do
      allow(File).to receive(:exist?).with(Rails.root.join('config', 'sync.yml')).and_return(false)
      described_class.reload!
    end

    it 'returns nil for non-existent keys' do
      expect(described_class[:non_existent]).to be_nil
    end

    it 'raises NoMethodError for non-existent method-style access' do
      expect { described_class.non_existent }.to raise_error(NoMethodError)
    end
  end
end
