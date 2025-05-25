# frozen_string_literal: true

require "dry-struct"

module Types
  include Dry.Types()
end

module Structs
  class CategoryItem < Dry::Struct
    attribute :name, Types::String
    attribute :primary_url, Types::String
    attribute? :github_repo, Types::String.optional
    attribute? :demo_url, Types::String.optional
    attribute? :description, Types::String.optional
    attribute? :commits_past_year, Types::Integer.optional
    attribute? :last_commit_at, Types::Params::Time.optional
    attribute? :stars, Types::Integer.optional
    attribute? :category_id, Types::Integer.optional
    attribute? :created_at, Types::Params::Time.optional
    attribute? :updated_at, Types::Params::Time.optional
  end
end
