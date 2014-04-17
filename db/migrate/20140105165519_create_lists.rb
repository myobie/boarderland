class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.integer :wunderlist_id
      t.json    :data
      t.boolean :synced
      t.integer :user_id
      t.timestamps
    end

    add_index :lists, :wunderlist_id
    add_index :lists, :user_id
  end
end
