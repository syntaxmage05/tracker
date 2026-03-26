# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.has_role?(:admin, user.account || Account.new)
      # Admin can manage everything
      can :manage, :all

      # Specifically for teams, admin can manage all teams in their account
      can :manage, Team do |team|
        team.account_id == user.account_id
      end

    elsif user.has_role?(:user, user.account || Account.new)
      can [:me, :password, :update_me, :update_password, :standups], User
      can [:feed, :mine], ActivityController
      can [:index, :show], Team

      # Users can only see teams they are members of
      can :show, Team do |team|
        user.teams.include?(team)
      end

      cannot :manage, Account

    else
      can [:new, :create], Account
    end
  end
end
