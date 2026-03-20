# frozen_string_literal: true

# app/controllers/users/standups_controller.rb
class Users::StandupsController < ApplicationController
  def index
    @user ||= User.find(params[:id]) # Make sure this is set
    @standups = @user.standups
      .includes(:dids, :todos, :blockers)
      .references(:tasks)
      .order("standup_date DESC")
  end
end
