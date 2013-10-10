class GameUserJoin < ActiveRecord::Base
  attr_accessible :game_id, :moderator, :user_id

  belongs_to :game
  belongs_to :user
end
