class Game < ActiveRecord::Base
  attr_accessible :description

  has_many :games_users
  has_many :users, :through => :games_users
  has_many :ships, :dependent => :destroy
end
