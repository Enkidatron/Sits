class GameUserJoin < ActiveRecord::Base
  attr_accessible :game_id, :moderator, :user_id, :owner

  belongs_to :game
  belongs_to :user

  # scope :owned, -> { where(owner: true)}
end
