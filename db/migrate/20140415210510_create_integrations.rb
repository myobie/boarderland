class CreateIntegrations < ActiveRecord::Migration
  def change
    create_table :integrations do |t|
      t.string :access_token
      t.timestamps
    end
  end
end
