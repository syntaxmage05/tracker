# frozen_string_literal: true

# spec/jobs/recaps/email_user_on_team_job_spec.rb
require "rails_helper"
include ActiveJob::TestHelper

RSpec.describe Recaps::EmailUserOnTeamJob do
  let(:user) { FactoryBot.create(:user) }
  let(:team) do
    team = FactoryBot.create(:team, user_ids: [user.id], has_recap: true, recap_time: Time.current.utc)
    team.update(
      days: [DayOfWeekMembership.new(team_id: team.id, day: Time.now.utc.strftime("%A").downcase)],
      users: [user]
    )
    team
  end
  let!(:standups) do
    [FactoryBot.create(:standup, standup_date: Date.today.iso8601, user_id: user.id)]
  end

  before { ActiveJob::Base.queue_adapter = :test }

  it "matches with enqueued job" do
    Recaps::EmailUserOnTeamJob.perform_later(team)
    expect(Recaps::EmailUserOnTeamJob).to have_been_enqueued
  end

  it "enqueues a mailer based job" do
    job = Recaps::EmailUserOnTeamJob.new(team, Date.today.iso8601)
    expect { job.perform_now }.to have_enqueued_job(ActionMailer::MailDeliveryJob)
  end

  it "recap email is sent" do
    expect {
      perform_enqueued_jobs do
        EmailRecapMailer.recap_email(user, team, standups).deliver_later
      end
    }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end
