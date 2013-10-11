class AddTurnToGame < ActiveRecord::Migration
  def change
    add_column :games, :turn, :integer, :null => false, :default => 0
  end
end
