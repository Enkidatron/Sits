class Game < ActiveRecord::Base
  attr_accessible :description, :users

  has_many :game_user_joins, :dependent => :destroy
  has_many :users, :through => :game_user_joins
  has_many :ships, :through => :users, :dependent => :destroy

  # accepts_nested_attributes_for :game_user_joins

  validates :description, presence: true
end
