class AddFactionToShipClass < ActiveRecord::Migration
  def change
    add_column :ship_classes, :faction, :string
    add_column :ship_classes, :classification, :string
  end
end
