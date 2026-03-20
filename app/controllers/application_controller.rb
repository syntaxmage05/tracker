# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  layout :layout_by_resource
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  protect_from_forgery with: :exception
  allow_browser versions: :modern
  helper_method :current_account

  helper_method :current_date

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, error: exception.message
  end
  add_flash_types :error

  def current_account
    return nil unless user_signed_in?

    @_current_account ||= current_user.account
  end

  def current_date
    # session[:current_date] = session[:current_date] || Time.zone.today.iso8601
    # @_current_date ||= session[:current_date]
    @_current_date ||= session[:current_date] ||= Time.zone.today.iso8601
  end

  def visible_teams
    return [] unless current_user && current_account

    @_visible_teams ||=
      if current_user.has_role? :admin, current_account
        current_account.teams.includes(:users)
      else
        current_user.teams.includes(:users)
      end
  end

  def set_teams_and_standups(date)
    @team = Team.includes(:users).find(params[:id])
    @standups = @team.users.flat_map do |u|
      u.standups.where(standup_date: date)
        .includes(:dids, :todos, :blockers)
        .references(:tasks)
    end
  end

  protected

    def layout_by_resource
      if devise_controller?
        "devise"
      else
        "application"
      end
    end
end
