class Ship < ActiveRecord::Base
  attr_accessible :name

  belongs_to :user, :game, :ship_class
  validates :user_id, presence: true
  validates :name, presence: true
end
