class Bug < ApplicationRecord

  has_many :user_bugs, dependent: :destroy
  has_many :users, through: :user_bugs
  belongs_to :project
  
  validates :title, length: { minimum: 8 }, presence: true
  validates :status, presence: true
  validates :bugtype, presence: true

end
