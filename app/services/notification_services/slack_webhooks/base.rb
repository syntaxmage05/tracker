# frozen_string_literal: true

# app/services/notification_services/slack_webhooks/base.rb
module NotificationServices
  module SlackWebhooks
    class Base
      private

        def send_message(webhook, message)
          notifier = Slack::Notifier.new(webhook)
          notifier.ping(message)
        end
    end
  end
end
