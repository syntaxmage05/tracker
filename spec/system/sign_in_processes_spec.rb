# frozen_string_literal: true

require "rails_helper"

RSpec.describe "SignInProcesses", type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:password) { "password" }
  let(:account) { FactoryBot.create(:account) }

  let(:user) do
    create(:user, account: account, password: password).tap do |u|
      u.add_role(:admin, account)
    end
  end

  it "should require the user to log in successfully logs in" do
    visit root_path

    within "#new_user" do
      fill_in "user_email", with: user.email
      fill_in "user_password", with: password
    end

    click_button "Log in"

    expect(current_path).to eql(root_path)
  end

  it "should fail on invalid user" do
    visit root_path

    within "#new_user" do
      fill_in "user_email", with: "test"
      fill_in "user_password", with: "pass"
    end

    click_button "Log in"
    expect(current_path).to eql(new_user_session_path)
  end
end
