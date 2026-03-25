# frozen_string_literal: true

module StandupBroadcasts
  extend ActiveSupport::Concern

  included do
    # Scopes
    scope :users_standups, lambda { |user|
      user
        .standups
        .includes(:dids, :todos, :blockers)
        .references(:tasks)
        .order("standup_date DESC")
    }

    scope :teams_standups_by_date, lambda { |team, date|
      team
        .users
        .flat_map { |u| u.standups.where(standup_date: date)
          .includes(:dids, :todos, :blockers)
          .references(:tasks) }
    }

    scope :notification_standups, lambda { |user|
      includes(user: { teams: { users: { standups: %i[dids todos blockers] } } })
        .references(:tasks)
        .where(teams: { users: user.id })
        .order(created_at: :desc)
        .limit(10)
    }

    # Callbacks
    after_create_commit do
      # Update the current user's standups
      broadcast_update_to(
        [user, :standups],
        target: dom_id(user, :standups),
        html: render(
          partial: "standups/standup",
          collection: Standup.users_standups(user),
          locals: { caller: "activity_mine", user: user }
        )
      )

      # Update notifications for the user
      broadcast_update_to(
        [user, "notification_standups"],
        target: "notification_standups",
        html: render(
          partial: "layouts/components/notifications",
          locals: { notification_standups: Standup.notification_standups(user) }
        )
      )

      # Update teams' standups
      user.teams.each do |team|
        broadcast_update_to(
          [team, standup_date, :standups],
          target: "#{team.id}_#{standup_date}_standups",
          html: render(
            partial: "standups/standup",
            collection: Standup.teams_standups_by_date(team, standup_date),
            locals: { caller: "teams_show", user: user }
          )
        )
      end
    end

    after_update_commit do
      # Replace the updated standup for the current user
      broadcast_replace_to [user, :standups],
        target: self,
        locals: { caller: "activity_mine", user: user }

      # Replace the updated standup for each team
      user.teams.each do |team|
        broadcast_replace_to [team, standup_date, :standups],
          target: self,
          locals: { caller: "teams/standups_index", user: user }
      end
    end

    after_destroy_commit do
      # Remove the standup for the current user
      broadcast_remove_to [user, :standups]

      # Update notifications after deletion
      broadcast_update_to [user, "notification_standups"],
        target: "notification_standups",
        html: render(
          partial: "layouts/components/notifications",
          locals: { notification_standups: Standup.notification_standups(user) }
        )

      # Remove the standup from each team
      user.teams.each do |team|
        broadcast_remove_to [team, standup_date, :standups]
      end
    end
  end
end
