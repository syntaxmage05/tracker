# frozen_string_literal: true

class BillingController < ApplicationController
  def index
    session = Stripe::BillingPortal::Session.create(
      { customer: current_account.stripe_customer_id, return_url: root_url }
    )
    redirect_to session.url, allow_other_host: true
  end
end
