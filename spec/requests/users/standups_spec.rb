# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/users/standups", type: :request do
  login_admin

  describe "GET #index" do
    it "assigns all standups as @standups" do
      standup = FactoryBot.create(:standup, user_id: @admin.id)

      get standups_account_user_path(@admin.id)

      expect(assigns(:user)).to eq(@admin)
      expect(assigns(:standups)).to eq([standup])
    end
  end
end
