# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Edit User", type: :system do
  login_admin

  it "should be able to visit the user index and see at least one user" do
    visit account_users_path
    expect(current_path).to eql(account_users_path)
    expect(page).to have_content(@admin.email)
  end

  context "when clicking and editing a user" do
    it "should click edit and go to edit page" do
      visit account_users_path
      first("tbody tr").click_on("Edit")
      expect(current_path).to eql(edit_account_user_path(@admin))
    end

    context "on the edit page" do
      it "edits the user successfully" do
        visit account_users_path
        first("tbody tr").click_on("Edit")

        within "#edit_user" do
          fill_in "user_email", with: "test@test.com"
        end

        click_button("Edit User")
        expect(current_path).to eql(account_users_path)
      end

      it "fails to edit the user successfully" do
        visit account_users_path
        first("tbody tr").click_on("Edit")

        within "#edit_user" do
          fill_in "user_email", with: ""
          select("User", from: "user_role")
        end

        click_button("Edit User")
        expect(current_path).to eql(account_user_path(@admin))
      end
    end
  end
end
