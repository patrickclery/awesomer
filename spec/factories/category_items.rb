# frozen_string_literal: true

FactoryBot.define do
  factory :category_item do
    association :category
    sequence(:name) { |n| "Item #{n}" }
    description { 'A useful tool or library' }
    primary_url { 'https://github.com/owner/repo' }
    github_repo { 'owner/repo' }
    demo_url { nil }
    stars { nil }
    commits_past_year { nil }
    last_commit_at { nil }
    previous_stars { nil }

    trait :with_stats do
      stars { 100 }
      commits_past_year { 50 }
      last_commit_at { 1.day.ago }
    end

    trait :needs_update do
      stars { 150 }
      previous_stars { 100 }
    end

    trait :no_update_needed do
      stars { 105 }
      previous_stars { 100 }
    end

    trait :new_item do
      stars { 100 }
      previous_stars { nil }
    end
  end
end
