class CreateIntegrations < ActiveRecord::Migration
  def change
    create_table :integrations do |t|
      t.string :access_token
      t.integer :wunderlist_user_id
      t.timestamps
    end
    add_index :integrations, :wunderlist_user_id
  end
end
