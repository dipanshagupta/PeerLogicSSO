class AddTtlToKey < ActiveRecord::Migration[5.1]
  def change
    add_column :keys, :ttl, :integer
  end
end
