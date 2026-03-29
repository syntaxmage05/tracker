# frozen_string_literal: true

class StripeSubscriptionUpdateJob < ApplicationJob
  queue_as :default

  def perform(event_id)
    # Retrieve the Stripe event
    event = ::Stripe::Event.retrieve(event_id)

    # Find the account in your DB by Stripe customer ID
    account = Account.find_by(stripe_customer_id: event.data.object.customer)
    return unless account # Stop if account not found

    # Prepare data to update
    data = { subscription_status: event.data.object.status }

    # Add trial end if it exists
    if event&.data&.object&.trial_end.present?
      data[:trial_ends_at] = Time.at(event.data.object.trial_end)
    end

    # Update product if plan info exists
    if event&.data&.object&.plan&.id
      product = Product.find_by(price_id: event.data.object.plan.id)
      data[:product_id] = product.product_id if product
    end

    # Update the account with subscription info
    account.update(data)
  end
end
