class Ship < ActiveRecord::Base
  attr_accessible :name, :user_id, :ship_class_id, :game_id

  belongs_to :user
  belongs_to :game
  belongs_to :ship_class
  validates :user_id, presence: true
  validates :name, presence: true
  validates :ship_class, presence: true
end
