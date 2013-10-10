class Ship < ActiveRecord::Base
  attr_accessible :name

  belongs_to :user
  belongs_to :game
  belongs_to :ship_class
  validates :user_id, presence: true
  validates :name, presence: true
  validates :ship_class, presence: true
end
