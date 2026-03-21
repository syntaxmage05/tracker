# frozen_string_literal: true

require "rails_helper"

RSpec.describe Reminders::EmailUserOnTeamJob do
  include ActiveJob::TestHelper

  let(:user) { FactoryBot.create(:user) }

  let(:team) do
    team = FactoryBot.create(
      :team,
      user_ids: [user.id],
      has_reminder: true,
      reminder_time: Time.at(
        Time.now.utc.to_i - (Time.now.utc.to_i % 15.minutes)
      ).utc
    )

    team.update(
      days: [
        DaysOfWeekMembership.new(
          team_id: team.id,
          day: Time.now.utc.strftime("%A").downcase
        )
      ]
    )

    team
  end

  before do
    ActiveJob::Base.queue_adapter = :test
  end

  describe "job enqueueing" do
    it "matches with enqueued job" do
      Reminders::EmailUserOnTeamJob.perform_later
      expect(Reminders::EmailUserOnTeamJob).to have_been_enqueued
    end

    it "enqueues a mailer based job" do
      job = Reminders::EmailUserOnTeamJob.new(team)

      expect {
        job.perform_now
      }.to have_enqueued_job
    end
  end

  describe "email delivery" do
    it "reminder email is sent" do
      expect {
        perform_enqueued_jobs do
          EmailReminderMailer.reminder_email(user, team).deliver_later
        end
      }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end
  end
end
