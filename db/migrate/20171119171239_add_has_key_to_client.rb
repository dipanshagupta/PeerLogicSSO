class AddHasKeyToClient < ActiveRecord::Migration[5.1]
  def change
    add_column :clients, :hasKey, :boolean
  end
end
