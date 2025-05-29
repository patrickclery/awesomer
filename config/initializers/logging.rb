# frozen_string_literal: true

# Filter out verbose SolidCache database query logs
# This reduces noise while keeping application-level cache hit/miss logs

# Silence SolidCache::Entry database operations
Rails.application.configure do
  config.after_initialize do
    # Silence SolidCache model operations by setting a null logger
    if defined?(SolidCache::Entry)
      SolidCache::Entry.logger = ActiveSupport::Logger.new(IO::NULL)
    end

    # Alternative: Use ActiveSupport's LogSubscriber silencing
    if defined?(ActiveRecord::LogSubscriber)
      # Monkey patch to filter out SolidCache logs
      ActiveRecord::LogSubscriber.class_eval do
        alias_method :original_sql, :sql

        def sql(event)
          payload = event.payload
          return if payload[:name]&.include?("SolidCache") ||
                   payload[:sql]&.include?("solid_cache_entries")

          original_sql(event)
        end
      end
    end
  end
end
