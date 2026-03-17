# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dates", type: :request do
  login_user

  describe "GET #update" do
    it "returns http success" do
      get update_date_url(date: "2026-03-14")
      expect(response).to have_http_status(:redirect)
      expect(session[:current_date]).to eql("2026-03-14")
    end
  end
end
