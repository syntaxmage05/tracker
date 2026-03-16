# frozen_string_literal: true

FactoryBot.define do
  factory :standup do
    user
    standup_date { "2026-03-13" }
  end
end
