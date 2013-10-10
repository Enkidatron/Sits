class AddGameIdToShips < ActiveRecord::Migration
  def change
    add_column :ships, :game_id, :integer
    add_index :ships, :game_id
  end
end
