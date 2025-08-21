# frozen_string_literal: true

FactoryBot.define do
  factory :sync_log do
    association :awesome_list
    started_at { Time.current }
    completed_at { 1.minute.from_now }
    items_checked { 100 }
    items_updated { 10 }
    status { "completed" }
    error_message { nil }
    git_commit_sha { nil }

    trait :completed do
      status { "completed" }
      completed_at { 1.minute.from_now }
    end

    trait :failed do
      status { "failed" }
      completed_at { 1.minute.from_now }
      error_message { "Something went wrong" }
    end

    trait :started do
      status { "started" }
      completed_at { nil }
    end

    trait :with_commit do
      git_commit_sha { "abc123def456" }
    end
  end
end
