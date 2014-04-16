class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :wunderlist_id
      t.json :data
      t.timestamps
    end
  end
end
