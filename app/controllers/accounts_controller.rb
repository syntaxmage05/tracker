# frozen_string_literal: true

class AccountsController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource only: [:new, :create]

  def new
    redirect_to root_path unless current_user.account.nil?

    @account = Account.new
  end

  def create
    @account = Account.new(account_params)

    result = NewRegistrationService
      .new(account: @account, user: current_user)
      .process_registration

    if result.success
      redirect_to root_path, success: "Your account has been created!"
    else
      @account = result.account
      render :new
    end
  end

  private

    def account_params
      params.expect(account: [:name, :addr1, :addr2, :city, :state, :zip, :country])
    end
end
