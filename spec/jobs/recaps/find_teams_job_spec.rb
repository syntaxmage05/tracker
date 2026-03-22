# frozen_string_literal: true

# spec/jobs/recaps/find_teams_job_spec.rb
require "rails_helper"
include ActiveJob::TestHelper

RSpec.describe Recaps::FindTeamsJob do
  it "matches with enqueued job" do
    ActiveJob::Base.queue_adapter = :test
    Recaps::FindTeamsJob.perform_later
    expect(Recaps::FindTeamsJob).to have_been_enqueued
  end

  it "finds a team with recaps" do
    team = FactoryBot.create(
      :team,
      has_recap: true,
      recap_time: Time.at(Time.now.utc.to_i - (Time.now.utc.to_i % 15.minutes)).utc
    )

    team.update(
      days: [
        DaysOfWeekMembership.new(
          team_id: team.id,
          day: Time.now.utc.strftime("%A").downcase
        )
      ]
    )

    job = Recaps::FindTeamsJob.new
    job.perform_now
    expect(job.instance_variable_get(:@_teams)).to eq([team])
  end
end
