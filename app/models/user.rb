class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :omniauth_providers => [:google_oauth2]


  has_many :user_projects
  has_many :projects, through: :user_projects

  # has_many :tasks
  has_many :user_projects, dependent: :destroy
  has_many :projects, through: :user_projects

  has_many :user_bugs, dependent: :destroy
  has_many :bugs, through: :user_bugs
  
  validates :name, presence: true
  validates :email, presence: true
  validates :role, presence: true

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(:email => data["email"]).first

    unless user
      user = User.create(
        name: data["name"],
        email: data["email"],
        encrypted_password: Devise.friendly_token[0,20]
      )
    end
    user
  end

end
