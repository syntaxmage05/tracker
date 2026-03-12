# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role? :admin, user.account
      can :manage, :all
    else
      can [:mine, :feed], ActivityController
      can [:password, :update_password, :me, :update_me], User, id: user.id
      cannot :manage, User
    end
  end
end
