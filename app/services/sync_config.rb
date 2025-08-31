# frozen_string_literal: true

require 'yaml'
require 'erb'

class SyncConfig
  include Singleton

  attr_reader :config

  def self.method_missing(method, *args, &)
    instance.config[method.to_sym] || super
  end

  def self.respond_to_missing?(method, include_private = false)
    instance.config.key?(method.to_sym) || super
  end

  def self.[](key)
    instance.config[key.to_sym]
  end

  def self.config
    instance.config
  end

  def self.reload!
    instance.instance_variable_set(:@config, instance.send(:load_config))
  end

  def initialize
    @config = load_config
  end

  protected

  def load_config
    config_file = Rails.root.join('config', 'sync.yml')

    unless File.exist?(config_file)
      Rails.logger.warn "Sync config file not found: #{config_file}"
      return default_config
    end

    erb = ERB.new(File.read(config_file))
    yaml = YAML.safe_load(erb.result, aliases: true)

    env_config = yaml[Rails.env] || yaml['default'] || {}
    deep_symbolize_keys(env_config)
  rescue StandardError => e
    Rails.logger.error "Failed to load sync config: #{e.message}"
    default_config
  end

  def default_config
    {
      batch_size: 50,
      default_threshold: 10,
      github: {
        auto_push: false,
        branch: 'main',
        commit_message: '📊 Auto-sync: Update awesome lists [%<date>s]'
      },
      logging: {
        file: 'log/sync.log',
        keep: 10,
        level: 'info',
        max_size: 100
      },
      rate_limiting: {
        max_requests_per_hour: 5000,
        rate_limit_wait: 3600,
        request_delay: 1
      },
      schedule: '0 2 * * *',
      timeout: 3600
    }
  end

  def deep_symbolize_keys(hash)
    hash.each_with_object({}) do |(key, value), result|
      new_key = key.to_sym
      new_value = value.is_a?(Hash) ? deep_symbolize_keys(value) : value
      result[new_key] = new_value
    end
  end
end
