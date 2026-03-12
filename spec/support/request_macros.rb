# frozen_string_literal: true

module RequestMacros
  def login_user
    before(:each) do
      @user = FactoryBot.create(:user)
      @user.add_role :user, @user.account
      sign_in @user
    end
  end

  def login_admin
    before(:each) do
      @admin = FactoryBot.create(:user)
      @admin.add_role :admin, @admin.account
      sign_in @admin
    end
  end
end
