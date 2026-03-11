# frozen_string_literal: true

module SystemMacros
  def login_user
    before(:each) do
      @user = FactoryBot.create(:user)
      @user.add_role :user, @user.account
      login_as(@user, scope: :user)
    end
  end

  def login_admin
    before(:each) do
      @admin = FactoryBot.create(:user)
      @admin.add_role :admin, @admin.account
      login_as(@admin, scope: :user)
    end
  end
end
