class CreateClients < ActiveRecord::Migration[5.1]
  def change
    create_table :clients do |t|
      
      t.string :key
      t.string :name
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
