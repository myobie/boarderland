class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.integer :wunderlist_id
      t.json    :data
      t.timestamps
    end

    add_index :lists, :wunderlist_id
  end
end
