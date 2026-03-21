# frozen_string_literal: true

# app/services/notification_services/slack_webhooks/new_account.rb
module NotificationServices
  module SlackWebhooks
    class NewAccount < Base
      WEBHOOK_URL = Rails.application.credentials.slack[:webhook_url].freeze

      attr_reader :user, :account
      def initialize(params)
        @user = params[:user]
        @account = params[:account]
      end

      def send_message
        super(WEBHOOK_URL, message)
      end

      private

        def message
          "A New User has appeared! #{account.name} - #{user.email}"
        end
    end
  end
end
