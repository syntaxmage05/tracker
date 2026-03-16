# frozen_string_literal: true

class AddDayEnumToDaysOfWeekMemberships < ActiveRecord::Migration[8.0]
  def up
    # Create the PostgreSQL enum type
    create_enum :days_of_week, %w[sunday monday tuesday wednesday thursday friday saturday]

    # Remove the old column and add the new enum column
    remove_column :days_of_week_memberships, :day
    add_column :days_of_week_memberships, :day, :enum,
      enum_type: :days_of_week, null: false, default: "monday"
  end

  def down
    # FIRST: Remove the enum column (this drops the dependency)
    remove_column :days_of_week_memberships, :day

    # THEN: Drop the enum type (now that nothing depends on it)
    execute <<-SQL
      DROP TYPE days_of_week;
    SQL

    # Add back the original column (assuming it was string)
    add_column :days_of_week_memberships, :day, :string
  end
end
