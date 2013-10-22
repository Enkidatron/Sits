class AddDecoyStrengthToShipClass < ActiveRecord::Migration
  def change
    add_column :ship_classes, :decoy_strength, :integer
  end
end
