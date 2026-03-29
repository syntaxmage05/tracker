# frozen_string_literal: true

class NewRegistrationService
  Result = ImmutableStruct.new(:success?, :user, :account, :error)

  attr_reader :user, :account, :product
  def initialize(params)
    @user = params[:user]
    @account = params[:account]
    @product = params[:product]
  end

  def process_registration
    account_create
    create_stripe_objects
    send_welcome_email
    notify_slack

    Result.new(
      success?: true,
      user: user,
      account: account,
      error: nil
    )
  rescue ActiveRecord::RecordInvalid, Slack::Notifier, ::Stripe::StripeError => exception
    Result.new(
      success?: false,
      user: user,
      account: account,
      error: exception.message
    )
  end

  private

    def account_create
      account.save!
      post_account_setup
    end

    def post_account_setup
      user.account_id = account.id
      user.save!
      user.add_role :admin, account
    end

    def create_stripe_objects
      Subscription::Create.new(product, user, account).process
    end

    def send_welcome_email
      WelcomeEmailMailer.welcome_email(user).deliver_later
    end

    def notify_slack
      SlackNotificationJob.perform_later(user)
    end
end
