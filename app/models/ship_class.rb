class ShipClass < ActiveRecord::Base
  attr_accessible :name

  has_many :ship, :dependent => :destroy
  validates :name, presence: true
end
