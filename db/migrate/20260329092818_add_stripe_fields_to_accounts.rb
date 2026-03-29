# frozen_string_literal: true

class AddStripeFieldsToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :stripe_customer_id, :string
    add_column :accounts, :stripe_subscription_id, :string
    add_column :accounts, :subscription_status, :string
    add_column :accounts, :trial_ends_at, :datetime
    add_column :accounts, :product_id, :string
  end
end
