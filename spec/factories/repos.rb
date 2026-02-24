# frozen_string_literal: true

FactoryBot.define do
  factory :repo do
    sequence(:github_repo) { |n| "owner/repo-#{n}" }
    stars { nil }
  end
end
