# frozen_string_literal: true

FactoryBot.define do
  factory :awesome_list do
    sequence(:name) { |n| "Awesome List #{n}" }
    sequence(:github_repo) { |n| "sindresorhus/awesome-#{n}" }
    description { 'A curated list of awesome things' }
    state { 'completed' }
    last_synced_at { nil }
    last_pushed_at { nil }
    sync_threshold { nil }

    trait :pending do
      state { 'pending' }
    end

    trait :in_progress do
      state { 'in_progress' }
    end

    trait :completed do
      state { 'completed' }
    end

    trait :failed do
      state { 'failed' }
    end

    trait :synced do
      last_synced_at { 1.hour.ago }
    end

    trait :needs_sync do
      last_synced_at { 2.days.ago }
    end

    trait :with_threshold do
      sync_threshold { 25 }
    end
  end
end
