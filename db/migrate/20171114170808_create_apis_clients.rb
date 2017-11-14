class CreateApisClients < ActiveRecord::Migration[5.1]
  def self.up
    # Create the association table
    create_table :apis_clients, :id => false do |t|
      t.integer :api_id, :null => false
      t.integer :client_id, :null => false
    end

    # Add table index
    add_index :apis_clients, [:api_id, :client_id], :unique => true

  end

  def self.down
    remove_index :apis_clients, :column => [:api_id, :client_id]
    drop_table :apis_clients
  end
end