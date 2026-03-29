# frozen_string_literal: true

class StripeSubscriptionUpdate
  def call(event)
    StripeSubscriptionUpdateJob.perform_later(event.id)
  end
end
