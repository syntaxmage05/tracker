# frozen_string_literal: true

class TeamsController < ApplicationController
  load_and_authorize_resource except: [:create]

  def index
    @teams = visible_teams
  end

  def show
    @team = Team.includes(:users).find(params[:id])
  end

  def new
    @team = Team.new
    set_users
  end

  def create
  end

  def destroy
    @team = Team.find(params[:id])
    @team.destroy
    redirect_to teams_url, notice: "Team was successfully destroyed!"
  end

  private

    def set_users
      @_set_users ||= (
        current_account.users.where.not(invitation_accepted_at: nil) +
        User.with_role(:admin, current_account)
      ).uniq
    end
end
