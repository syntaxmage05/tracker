class CreateTaskMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :task_memberships, id: :uuid do |t|
      t.references :task, null: false, foreign_key: true, type: :uuid
      t.references :standup, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
