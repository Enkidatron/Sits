class AddPhaseToGame < ActiveRecord::Migration
  def change
    add_column :games, :phase, :integer, :null => false, :default => 0
  end
end
