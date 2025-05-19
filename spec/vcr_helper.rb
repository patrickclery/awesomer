# frozen_string_literal: true

require 'vcr'
require 'neatjson'
require 'base64'

VCR.configure do |config|
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = false
  config.ignore_localhost                        = true
  config.ignore_host 'chromedriver.storage.googleapis.com'
  config.cassette_library_dir                    = File.expand_path('../cassettes', __dir__)
  config.default_cassette_options                = {
    match_requests_on: %i[method uri body],
    record:            ENV['CI'] ? :none : :once,
    record_on_error:   false,
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

      VCR_ALLOWED_KEYS = %i[erb match match_requests_on record].freeze

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

        # Use this if you want to match the body of a request, but ignore certain keys
        # https://code.whatever.social/questions/74107430/how-do-i-match-a-vcr-request-when-a-part-of-the-body-is-variable-and-cannot-be-p
        # https://gist.github.com/kemenaran/2dcc463fdda3e476983bf5500f3524b9
        # @param [Array] keys The keys in a JSON response that won't be compared to match the cassette
        def body_as_json_excluding(*keys)
          unless vcr_exclude_json_keys?
            warn 'WARNING: VCR_EXCLUDE_JSON_KEYS is false, no keys will be ignored in the JSON'
            return :body
          end

          lambda do |r1, r2|
            keys = keys.map(&:to_s)
            JSON.parse(r1.body).except(*keys) == JSON.parse(r2.body).except(*keys)
          end
        end

        # @param [String] directory Where the test YML is stored
        # @param [String] name filename to use - useful when you want to use the same file for multiple tests.
        # @param [Proc] block
        def vcr(directory, name, **additional_options, &block)
          return yield unless ::VCR.turned_on?

          # Get the current test name
          filename = sanitize_filename(name)

          if additional_options[:match].present?
            additional_options[:match_requests_on] = additional_options[:match]
            additional_options.delete(:match)
          end
          options = vcr_options
            .merge(additional_options.slice(*VCR_ALLOWED_KEYS))
            .merge(vcr_options_overrides)

          # Freeze the time so that the originally_recorded_at is the same
          time_travel = additional_options.key?(:time_travel) ? additional_options[:time_travel] : vcr_time_travel?

          full_path_to_file = "#{directory}/#{filename}"
          ::VCR.use_cassette(full_path_to_file, **options) do |cassette|
            # Only freeze the time if we are recording
            if time_travel && (!cassette.recording? && cassette.record_mode != :all)
              travel_to(cassette.originally_recorded_at || Time.current, &block)
            else
              yield
            end
          end
        end

        # Default options for VCR
        def vcr_options
          {
            match_requests_on: %i[method uri],
            record:            :none,
            record_on_error:   true,
          }
        end

        # These options will override everything if specified in .env.test.local
        def vcr_options_overrides
          options                   = {}
          if ENV['VCR_MATCH_REQUESTS_ON'].present?
            options[:match_requests_on] = ENV['VCR_MATCH_REQUESTS_ON'].split.map(&:to_sym)
          end
          options[:record]        ||= vcr_record_mode
          options[:record_on_error] = ENV['VCR_RECORD_ON_ERROR'].to_sym if ENV['VCR_RECORD_ON_ERROR'].present?
          options
        end

        def vcr_record_on_error?
          ENV['VCR_RECORD_ON_ERROR'].to_bool
        end

        def vcr_record_mode
          ENV.fetch('VCR_RECORD_MODE', :once).to_sym
        end

        def vcr_time_travel?
          ENV['VCR_TIME_TRAVEL'].to_bool
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
