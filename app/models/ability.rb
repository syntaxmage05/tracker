# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role? :admin, user.account
      # Admin can do everything
      can :manage, :all
    else
      # Regular user permissions

      # Activity feed
      can [:mine, :feed], ActivityController

      # User profile
      can [:password, :update_password, :me, :update_me], User, id: user.id

      # Teams
      can :read, Team, account_id: user.account_id # Can view teams in their account
      can :create, Team # Can create new teams (automatically sets account_id in controller)
      can [:update, :destroy], Team, account_id: user.account_id # Can modify teams in their account

      # Team memberships
      can :manage, TeamMembership, team: { account_id: user.account_id }

      # Days of week
      can :manage, DaysOfWeekMembership, team: { account_id: user.account_id }

      # Standups (if applicable)
      can :manage, Standup, user_id: user.id # Own standups
      can :read, Standup, team: { account_id: user.account_id } # Team standups

      # Users in same account
      can :read, User, account_id: user.account_id

      # Cannot manage other users
      cannot :manage, User
    end
  end
end
