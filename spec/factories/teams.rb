# frozen_string_literal: true

FactoryBot.define do
  factory :team do
    name { Faker::Team.name }
    account { association :account }
    timezone { "America/Phoenix" }
    has_reminder { true }
    has_recap { true }
    reminder_time { Time.current.change(hour: 9, min: 0) } # 9:00 AM
    recap_time { Time.current.change(hour: 17, min: 0) } # 5:00 PM
    description { Faker::Company.catch_phrase }

    trait :without_notifications do
      has_reminder { false }
      has_recap { false }
      reminder_time { nil }
      recap_time { nil }
    end
  end
end
