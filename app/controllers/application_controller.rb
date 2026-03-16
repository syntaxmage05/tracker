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
    @current_account ||= current_user.account
    @current_account
  end

  def current_date
    session[:current_date] = session[:current_date] || Time.zone.today.iso8601
    @_current_date ||= session[:current_date]
  end

  def visible_teams
    @visible_teams ||=
      if current_user.has_role? :admin, current_account
        current_account.teams.includes(:users)
      else
        current_user.teams.includes(:users)
      end
    @visible_teams
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
