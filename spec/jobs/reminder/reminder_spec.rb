# frozen_string_literal: true

require "rails_helper"
include ActiveSupport::Testing::TimeHelpers

RSpec.describe Reminders::FindTeamsJob do
  include ActiveJob::TestHelper

  before do
    ActiveJob::Base.queue_adapter = :test
  end

  describe "job enqueueing" do
    it "matches with enqueued job" do
      Reminders::FindTeamsJob.perform_later
      expect(Reminders::FindTeamsJob).to have_been_enqueued
    end
  end

  describe "finding teams with reminders" do
    it "finds a team with reminders" do
      travel_to Time.utc(2026, 3, 21, 14, 30) do
        team = FactoryBot.create(
          :team,
          has_reminder: true,
          reminder_time: Time.current, # matches travel_to
          timezone: "UTC"
        )

        team.update(
          days: [
            DaysOfWeekMembership.new(team_id: team.id, day: Time.current.strftime("%A").downcase)
          ]
        )

        job = Reminders::FindTeamsJob.new
        job.perform_now

        expect(job.instance_variable_get(:@_teams)).to eq([team])
      end
    end
  end
end
