# frozen_string_literal: true

module Reminders
  class FindTeamsJob < ApplicationJob
    def perform(*_args)
      @_teams = teams
      @_teams.each { |team| Reminders::EmailUserOnTeamJob.perform_later(team) }
    end

    private

      def teams
        fifteen_minute_marker = Time.now.utc.to_i - (Time.now.utc.to_i % 15.minutes)
        start_time = Time.at(fifteen_minute_marker).utc
        end_time = start_time + 15.minutes - 1.second

        Team.includes(:days)
          .where(has_reminder: true)
          .where(reminder_time: start_time..end_time)
          .where("days_of_week_memberships.day = ?", current_day)
          .references(:days_of_week_memberships)
      end

      def current_day
        Time.now.utc.strftime("%A").downcase
      end

      def last_fifteen_marker
        Time.now.utc.to_i - (Time.now.utc.to_i % 15.minutes)
      end
  end
end
