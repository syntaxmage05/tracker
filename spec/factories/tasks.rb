# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    type { "Todo" }
    title { "MyString" }
    is_completed { false }
  end
end
