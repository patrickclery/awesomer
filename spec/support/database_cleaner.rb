# frozen_string_literal: true

require 'database_cleaner-active_record'

DatabaseCleaner.strategy = :transaction

module Minitest
  class Spec
    around do |tests|
      DatabaseCleaner.cleaning(&tests)
    end
  end
end
