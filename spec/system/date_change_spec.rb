# frozen_string_literal: true

# # frozen_string_literal: true

# require "rails_helper"

# RSpec.describe "DateChanges", type: :system do
#   login_admin
#   let(:team) { FactoryBot.create(:team, account_id: @admin.account.id) }

#   it "changes the date when the back arrow is pressed" do
#     visit team_standups_path(team)
#     click_on(id: "date_backwards")

#     expect(page).to have_content(
#       (Time.zone.today - 1.day)
#         .strftime("%a, %b #{(Time.zone.today - 1.day).day.ordinalize}")
#     )
#   end

#   it "changes the date when the forwards arrow is pressed" do
#     visit team_standups_path(team)
#     click_on(id: "date_forward")

#     expect(page).to have_content(
#       (Time.zone.today + 1.day)
#         .strftime("%a, %b #{(Time.zone.today + 1.day).day.ordinalize}")
#     )
#   end

#   it "should be able to visit standups and move date from picker", js: true do
#     visit team_standups_path(team)
#     date = (Time.zone.now + 1.day).strftime("%B %-d, %Y")

#     find("#datePicker").click
#     expect(page).to have_selector(".flatpickr-days")
#     find(".flatpickr-calendar .flatpickr-day[aria-label='#{date}']").click

#     expect(page).to have_content(
#       (Time.zone.now + 1.day)
#         .strftime("%a, %b #{(Time.zone.now + 1.day).day.ordinalize}")
#     )
#   end
# end
