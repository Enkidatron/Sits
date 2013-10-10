class AddOwnerToGameUserJoin < ActiveRecord::Migration
  def change
    add_column :game_user_joins, :owner, :boolean
  end
end
