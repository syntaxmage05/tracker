# frozen_string_literal: true

require "rails_helper"

RSpec.describe SlackNotificationJob, type: :job do
  it "matches with enqueued job" do
    ActiveJob::Base.queue_adapter = :test
    SlackNotificationJob.perform_later
    expect(SlackNotificationJob).to have_been_enqueued
  end

  it "calls the slack service" do
    user = FactoryBot.create(:user)
    ActiveJob::Base.queue_adapter = :test
    expect_any_instance_of(NotificationServices::SlackWebhooks::NewAccount).to receive(:send_message)
    SlackNotificationJob.perform_now(user)
  end
end
