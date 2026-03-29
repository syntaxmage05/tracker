# frozen_string_literal: true

Rails.configuration.stripe = {
  publishable_key: Rails.application.credentials.stripe[:pkey],
  secret_key: Rails.application.credentials.stripe[:api_key]
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

StripeEvent.signing_secret = Rails.application.credentials.stripe[:signing_secret]

StripeEvent.configure do |events|
  events.subscribe "customer.", StripeSubscriptionUpdate.new
end
