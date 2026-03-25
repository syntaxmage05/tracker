# frozen_string_literal: true

module StandupBroadcasts
  extend ActiveSupport::Concern

  included do
    # Scope for fetching a user's standups
    scope :users_standups, lambda { |user|
      user
        .standups
        .includes(:dids, :todos, :blockers)
        .references(:tasks)
        .order("standup_date DESC")
    }

    # Scope for fetching standups for a team on a specific date
    scope :teams_standups_by_date, lambda { |team, date|
      team
        .users
        .flat_map do |u|
          u.standups
            .where(standup_date: date)
            .includes(:dids, :todos, :blockers)
            .references(:tasks)
        end
    }

    # Broadcast after creation
    after_create_commit do
      # Broadcast to the user
      broadcast_update_to(
        [user, :standups],
        target: dom_id(user, :standups),
        html: render(
          partial: "standups/standup",
          collection: Standup.users_standups(user),
          locals: { caller: "activity_mine", user: user }
        )
      )

      # Broadcast to each team the user belongs to
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

    # Broadcast after update
    after_update_commit do
      # Update for the user
      broadcast_replace_to(
        [user, :standups],
        target: self,
        locals: { caller: "activity_mine", user: user }
      )

      # Update for each team
      user.teams.each do |team|
        broadcast_replace_to(
          [team, standup_date, :standups],
          target: self,
          locals: { caller: "teams/standups_index", user: user }
        )
      end
    end

    # Broadcast after destroy
    after_destroy_commit do
      # Remove from user's stream
      broadcast_remove_to([user, :standups])

      # Remove from each team's stream
      user.teams.each do |team|
        broadcast_remove_to([team, standup_date, :standups])
      end
    end
  end
end
