class AddShipClassIdToShips < ActiveRecord::Migration
  def change
    add_column :ships, :ship_class_id, :integer
    add_index :ships, :ship_class_id
  end
end
