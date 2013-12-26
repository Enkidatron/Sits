class AddStatsToShip < ActiveRecord::Migration
  def change
  	add_column :ships, :position, :integer
  	add_column :ships, :orientation, :text
  	add_column :ships, :total_cost, :integer

  end
end
