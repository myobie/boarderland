class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :wunderlist_id
      t.json    :data
      t.timestamps
    end
  end
end
