# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  context "Valid Factory" do
    it "has a valid factory" do
      expect(FactoryBot.build(:user)).to be_valid
    end
  end
end
