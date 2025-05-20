# frozen_string_literal: true

require "dry-struct"

module Types
  include Dry.Types()
end

module Structs
  class CategoryItem < Dry::Struct
    attribute :id, Types::Integer
    attribute :name, Types::String
    attribute :url, Types::String
    attribute? :description, Types::String.optional
    attribute? :commits_past_year, Types::Integer.optional
    attribute? :last_commit_at, Types::Params::Time.optional
    attribute? :stars, Types::Integer.optional
  end
end
