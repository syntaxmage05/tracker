# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { "MyString" }
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }
    account { association :account }
  end
end
