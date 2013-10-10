class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :recoverable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :admin
  # attr_accessible :title, :body

  has_many :game_user_joins, :dependent => :destroy
  has_many :games, :through => :game_user_joins
  has_many :ships, :dependent => :destroy

  # accepts_nested_attributes_for :game_user_joins

  validates :name, presence: true
  
end

