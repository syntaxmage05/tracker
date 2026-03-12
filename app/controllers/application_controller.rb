# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  protect_from_forgery with: :exception
  allow_browser versions: :modern

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, error: exception.message
  end
  add_flash_types :error

  before_action :authenticate_user!
  layout :layout_by_resource

  helper_method :current_account

  def current_account
    @current_account ||= current_user.account
    @current_account
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
