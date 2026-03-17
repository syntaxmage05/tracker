# frozen_string_literal: true

FactoryBot.define do
  factory :days_of_week_membership do
    team
    day { "monday" }
  end
end
