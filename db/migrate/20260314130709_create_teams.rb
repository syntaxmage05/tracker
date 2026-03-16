# frozen_string_literal: true

class CreateTeams < ActiveRecord::Migration[8.0]
  def change
    create_table :teams, id: :uuid do |t|
      t.string :name
      t.references :account, null: false, foreign_key: true, type: :uuid
      t.string :timezone
      t.boolean :has_reminder
      t.boolean :has_recap
      t.time :reminder_time
      t.time :recap_time

      t.timestamps
    end
  end
end
