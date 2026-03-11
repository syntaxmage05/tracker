# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Accounts", type: :request do
  before(:each) do
    user = User.create!(
      name: "John",
      email: "test@user.com",
      password: "password"
    )
    sign_in user
  end
  describe "GET #new" do
    # before do
    #   @user.account = nil
    #   @user.save!
    # end

    it "returns http success" do
      get "/accounts/new"
      expect(response).to have_http_status(:success)
    end

    it "renders new template" do
      get "/accounts/new"
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    it "creates an account" do
      post "/accounts", params: { account: FactoryBot.attributes_for(:account) }
      expect(response).to redirect_to root_path
    end

    it "renders :new on failure" do
      post "/accounts", params: { account: FactoryBot.attributes_for(:account, { name: nil }) }
      expect(response).to render_template :new
    end
  end

end
