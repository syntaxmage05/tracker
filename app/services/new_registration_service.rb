# frozen_string_literal: true

class NewRegistrationService
  Result = ImmutableStruct.new(:success, :user, :account, :error)

  attr_reader :user, :account
  def initialize(params)
    @user = params[:user]
    @account = params[:account]
  end

  def process_registration
    account_create
    send_welcome_email
    notify_slack

    Result.new(success: true, user: user, account: account, error: nil)
  rescue ActiveRecord::RecordInvalid, Slack::Notifier => exception
    Result.new(
      success: false,
      user: user,
      account: account,
      error: exception.message
    )
  end

  private

    def account_create
      post_account_setup if account.save!
    end

    def post_account_setup
      user.account_id = account.id
      user.save!
      user.add_role :admin, account
    end

    def send_welcome_email
      # WelcomeEmailMailer.welcome_email(user).deliver_later
    end

    def notify_slack
      NotificationServices::SlackWebhooks::NewAccount
        .new(
          account: account,
          user: user
        )
        .send_message
    end
end
