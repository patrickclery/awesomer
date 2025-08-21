# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    association :awesome_list
    sequence(:name) { |n| "Category #{n}" }
    parent_id { nil }
    repo_count { 0 }

    trait :with_items do
      after(:create) do |category|
        create_list(:category_item, 3, category:)
      end
    end
  end
end
