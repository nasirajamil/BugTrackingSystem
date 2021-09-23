class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_projects, dependent: :destroy
  has_many :projects, through: :user_projects

  has_many :user_bugs, dependent: :destroy
  has_many :bugs, through: :user_bugs
  
  validates :name, presence: true
  validates :email, presence: true
  validates :role, presence: true

end
