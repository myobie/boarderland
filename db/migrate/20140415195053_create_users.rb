class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :wunderlist_id
      t.json :data
      t.timestamps
    end
  end
end
