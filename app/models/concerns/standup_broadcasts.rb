# frozen_string_literal: true

module StandupBroadcasts
  extend ActiveSupport::Concern

  included do
    scope :users_standups, lambda { |user|
      user
        .standups
        .includes(:dids, :todos, :blockers)
        .references(:tasks)
        .order("standup_date DESC")
    }

    after_create_commit do
      broadcast_update_to(
        [user, :standups],
        target: dom_id(user, :standups),
        html: render(
          partial: "standups/standup", collection: Standup.users_standups(user),
          locals: { caller: "activity_mine", user: user }
        )
      )
    end

    after_update_commit do
      broadcast_replace_to [user, :standups], target: self, locals: { caller: "activity_mine", user: user }
    end
  end
end
