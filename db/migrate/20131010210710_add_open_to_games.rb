class AddOpenToGames < ActiveRecord::Migration
  def change
    add_column :games, :open, :boolean, default: true
  end
end
