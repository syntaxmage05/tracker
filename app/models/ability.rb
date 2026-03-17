# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present? # Guard clause for nil user

    if user.has_role?(:admin, user.account)
      # Admin can do everything
      can :manage, :all
    else
      # Regular user permissions

      # Activity feed
      can [:mine, :feed], ActivityController

      # User profile
      can [:password, :update_password, :me, :update_me], User, id: user.id

      # Teams
      can [:read, :new, :standups], Team, account_id: user.account_id
      can :create, Team
      can [:update, :destroy], Team, account_id: user.account_id

      # Team memberships
      can :manage, TeamMembership, team: { account_id: user.account_id }

      # Days of week
      can :manage, DaysOfWeekMembership, team: { account_id: user.account_id }

      # Standups
      can :manage, Standup, user_id: user.id
      can :read, Standup, team: { account_id: user.account_id }

      # Users in same account
      can :read, User, account_id: user.account_id

      # Cannot manage other users
      cannot :manage, User
    end
  end
end
