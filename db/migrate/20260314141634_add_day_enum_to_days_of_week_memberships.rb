# frozen_string_literal: true

class AddDayEnumToDaysOfWeekMemberships < ActiveRecord::Migration[8.0]
  def change
    # Create the PostgreSQL enum type
    create_enum :days_of_week, %w[sunday monday tuesday wednesday thursday friday saturday]

    # Add the column using the enum type
    change_table :days_of_week_memberships do |t|
      t.remove :day
      t.column :day, :enum, enum_type: :days_of_week, null: false, default: "monday"
    end
  end
end
