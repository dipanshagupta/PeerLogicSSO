class AddRequestedToClient < ActiveRecord::Migration[5.1]
  def change
    add_column :clients, :requested, :boolean
  end
end
