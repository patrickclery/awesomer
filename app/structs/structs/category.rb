# frozen_string_literal: true

require 'dry-struct'
require_relative 'category_item' # This should now correctly resolve to ./category_item.rb

module Types
  include Dry.Types()
end

module Structs
  class Category < Dry::Struct
    attribute :name, Types::String
    attribute? :awesome_list_id, Types::Integer.optional
    attribute? :parent_id, Types::Integer.optional
    attribute? :repo_count, Types::Integer.optional
    attribute? :created_at, Types::Params::Time.optional
    attribute? :updated_at, Types::Params::Time.optional
    attribute? :repos, Types::Array.of(Structs::CategoryItem).optional
    attribute? :custom_order, Types::Integer.optional
  end
end
