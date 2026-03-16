class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks, id: :uuid do |t|
      t.string :title
      t.boolean :is_completed

      t.timestamps
    end
  end
end
