class User < ApplicationRecord
  extend Devise::Models

  has_many :campaigns, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable
  # 
  enum user_type: [:normal, :shopify]
end
