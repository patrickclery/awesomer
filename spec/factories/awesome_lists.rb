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

    trait :with_readme_content do
      readme_content do
        <<~MD
          ## Category A
          - [Item1](https://github.com/user/repo1) - Description one
          - [Item2](https://github.com/user/repo2) - Description two
          - [Item3](https://github.com/user/repo3) - Description three

          ## Category B
          - [Item4](https://github.com/user/repo4) - Description four
          - [Item5](https://github.com/user/repo5) - Description five
          - [Item6](https://github.com/user/repo6) - Description six

          ## Category C
          - [Item7](https://github.com/user/repo7) - Description seven
          - [Item8](https://github.com/user/repo8) - Description eight
        MD
      end
    end
  end
end
