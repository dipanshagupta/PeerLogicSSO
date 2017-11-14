class CreateKeys < ActiveRecord::Migration[5.1]
  def change
    create_table :keys do |t|
      t.string :key
      t.string :initial_value
      t.timestamp :timestamp

      t.timestamps
    end
  end
end
