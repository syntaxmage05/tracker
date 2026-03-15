# frozen_string_literal: true

class CreateDaysOfWeekMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :days_of_week_memberships, id: :uuid do |t|
      t.references :team, null: false, foreign_key: true, type: :uuid
      t.integer :day

      t.timestamps
    end
  end
end
