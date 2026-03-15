# frozen_string_literal: true

class DaysOfWeekMembership < ApplicationRecord
  enum :day, {
    sunday: "sunday",
    monday: "monday",
    tuesday: "tuesday",
    wednesday: "wednesday",
    thursday: "thursday",
    friday: "friday",
    saturday: "saturday"
  }, suffix: true
  belongs_to :team
end
