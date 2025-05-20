# frozen_string_literal: true

require 'vcr'
require 'neatjson'
require 'base64'

VCR.configure do |config|
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = false
  config.ignore_localhost                        = true
  config.filter_sensitive_data('[GITHUB_API_KEY]') { ENV['GITHUB_API_KEY'] }
  config.cassette_library_dir                    = File.expand_path('../cassettes', __dir__)
  config.default_cassette_options                = {
    match_requests_on: %i[method uri body],
    record:            ENV['CI'] ? :none : :once,
    record_on_error:   false
  }

  # Make sure headers containing secrets aren't recorded in cassettes and stored in git
  %w[Authorization X-Api-Key].each do |sensitive_header|
    config.filter_sensitive_data("[#{sensitive_header.upcase}]") do |interaction|
      interaction.request.headers[sensitive_header]&.first
    end
  end
end

# Tests using the custom `vcr()` work fine without this, but directly using `VCR.use_cassette` requires the VCR
# to initialize first
enable_vcr = ENV['VCR'].to_bool
VCR.turn_on! if enable_vcr

module Test
  module Support
    module VCR
      extend ActiveSupport::Concern
      include ActiveSupport::Testing::TimeHelpers

      VCR_ALLOWED_KEYS = %i[erb match match_requests_on record record_on_error allow_playback_repeats].freeze

        public def vcr_time_travel?
          ENV['VCR_TIME_TRAVEL'].to_bool
        end

        public def vcr_record_mode
          ENV.fetch('VCR_RECORD_MODE', :once).to_sym
        end

        public def vcr_record_on_error?
          ENV['VCR_RECORD_ON_ERROR'].to_bool
        end

        # Default options for VCR (can be overridden by ENV vars or direct call)
        public def vcr_base_options
          {
            match_requests_on: %i[method uri],
            record:            ENV['CI'] ? :none : :once,
            record_on_error:   false
          }
        end

        # @param [String] directory Where the test YML is stored
        # @param [String] name filename to use - useful when you want to use the same file for multiple tests.
        # @param [Proc] block
        public def vcr(directory, name, **additional_options, &block)
          return yield unless ::VCR.turned_on?

          filename = sanitize_filename(name)

          # Start with base VCR options for this helper
          options = vcr_base_options.dup

          # Apply ENV VAR Overrides if they are set, these have high precedence
          if ENV['VCR_MATCH_REQUESTS_ON'].present?
            options[:match_requests_on] = ENV['VCR_MATCH_REQUESTS_ON'].split.map(&:to_sym)
          end
          if ENV['VCR_RECORD_MODE'].present?
            options[:record] = ENV['VCR_RECORD_MODE'].to_sym
          end
          if ENV['VCR_RECORD_ON_ERROR'].present?
            # Ensure ENV var is converted to boolean if it's a string 'true'/'false'
            options[:record_on_error] = ENV['VCR_RECORD_ON_ERROR'].to_s.downcase == 'true'
          end

          # Then, merge options passed directly to the vcr() call, these take precedence over ENV for this call
          # Ensure :match is converted to :match_requests_on for convenience
          if additional_options[:match].present?
            options[:match_requests_on] = additional_options[:match]
            additional_options.delete(:match)
          end
          options.merge!(additional_options.slice(*VCR_ALLOWED_KEYS))

          time_travel = additional_options.key?(:time_travel) ? additional_options[:time_travel] : vcr_time_travel?

          full_path_to_file = "#{directory}/#{filename}"
          ::VCR.use_cassette(full_path_to_file, **options) do |cassette|
            if time_travel && (!cassette.recording? && cassette.record_mode != :all)
              travel_to(cassette.originally_recorded_at || Time.current, &block)
            else
              yield
            end
          end
        end

        # Use this if you want to match the body of a request, but ignore certain keys
        # https://code.whatever.social/questions/74107430/how-do-i-match-a-vcr-request-when-a-part-of-the-body-is-variable-and-cannot-be-p
        # https://gist.github.com/kemenaran/2dcc463fdda3e476983bf5500f3524b9
        # @param [Array] keys The keys in a JSON response that won't be compared to match the cassette
        public def body_as_json_excluding(*keys)
          unless vcr_exclude_json_keys?
            warn 'WARNING: VCR_EXCLUDE_JSON_KEYS is false, no keys will be ignored in the JSON'
            return :body
          end

          lambda do |r1, r2|
            keys = keys.map(&:to_s)
            JSON.parse(r1.body).except(*keys) == JSON.parse(r2.body).except(*keys)
          end
        end

      included do
        # Little helper lambda to apply json cleanup to request and response
        class << self
          def prettify_json(request)
            return request.body unless json_request?(request)

            request.body.force_encoding('UTF-8')

            # recursively sort all the nested hashes by key
            JSON.neat_generate(JSON.parse(request.body), after_colon: 1, sort: true, wrap: 80)
          end

          private

          def json_request?(request)
            # Match if the request body and the content-type contains the string "application/json"
            request.body.to_s.present? && request.headers['Content-Type'].to_s.include?('application/json')
          end
        end

        # Prevents cassettes from storing in binary
        # NOTE: tried `decode_compressed_response: true` for options - would not work
        # https://stackoverflow.com/questions/21920259/how-to-edit-response-body-returned-by-vcr-gem
        ::VCR.configure do |config|
          config.before_http_request do |request|
            # Prettify unless the request is local
            request.body = prettify_json(request) unless request.parsed_uri.host.in?(%w[localhost 127.0.0.1])
          end
          config.before_record do |cassette|
            cassette.response.body = prettify_json(cassette.response)
          end
        end
      end

      def sanitize_filename(name)
        name.gsub(/[^0-9a-z]/i, '_').squeeze('_')
      end

      def vcr_exclude_json_keys?
        ENV['VCR_EXCLUDE_JSON_KEYS'].to_bool
      end
    end
  end
end
