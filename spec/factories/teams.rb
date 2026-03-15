# frozen_string_literal: true

FactoryBot.define do
  factory :team do
    name { "MyString" }
    account { association :account }
    timezone { "MyString" }
    has_remainder { false }
    has_recap { false }
    reminder_time { "2026-03-14 16:07:09" }
    recap_time { "2026-03-14 16:07:09" }
  end
end
