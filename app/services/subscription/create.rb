# frozen_string_literal: true

class Subscription::Create
  DEFAULT_PRODUCT = "prod_UEiVUXI6mqgqQI"

  attr_reader :product_id, :user, :account
  def initialize(product_id, user, account)
    @product_id = product_id
    @user = user
    @account = account
  end

  def process
    update_account
  end

  private

    def product
      @_product ||= Product.find_by(
        product_id: product_id.blank? ? DEFAULT_PRODUCT : product_id
      )
    end

    def customer
      @_customer ||= ::Stripe::Customer.create(
        {
          email: user.email,
          description: "Account: #{account.id}"
        },
        idempotency_key: SecureRandom.uuid
      )
    end

    def subscription
      @_subscription ||= ::Stripe::Subscription.create(
        {
          customer: customer.id,
          items: [
            { price: product.price_id }
          ],
          trial_period_days: 14
        },
        idempotency_key: SecureRandom.uuid
      )
    end

    def update_account
      account.update(
        stripe_customer_id: customer.id,
        stripe_subscription_id: subscription.id,
        subscription_status: subscription.status,
        trial_ends_at: Time.zone.at(subscription.trial_end),
        product_id: product.product_id
      )
    end
end
