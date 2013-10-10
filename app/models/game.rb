class Game < ActiveRecord::Base
  attr_accessible :description

  has_many :game_user_joins
  has_many :users, :through => :game_user_joins
  has_many :ships, :through => :users, :dependent => :destroy
end
