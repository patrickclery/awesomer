# frozen_string_literal: true

FactoryBot.define do
  factory :star_snapshot do
    association :repo
    stars { 100 }
    snapshot_date { Date.current }
  end
end
