class CreateTagsTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tags_tasks do |t|
      t.belongs_to :task
      t.belongs_to :tag
      t.timestamps
    end

    add_index :tags_tasks, [:tag_id, :task_id], unique: true
  end
end
