# frozen_string_literal: true

require "rails_helper"

RSpec.describe "DateChanges", type: :system do
  login_admin

  let(:yesterday) { Time.zone.today - 1.day }
  let(:tomorrow) { Time.zone.today + 1.day }

  before do
    visit activity_mine_path
  end

  it "can select a date from the Flatpickr date picker", js: true do
    visit activity_mine_path

    find("#datePicker").click

    date_label = tomorrow.strftime("%B %-d, %Y")
    day_element = find(".flatpickr-day[aria-label='#{date_label}']", visible: false)
    page.execute_script("arguments[0].click();", day_element)

    # Validate hidden input value updated
    expect(find("#datePickerInput", visible: false).value).to eq(tomorrow.strftime("%Y-%m-%d"))
  end
end
