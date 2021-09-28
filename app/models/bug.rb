class Bug < ApplicationRecord
  has_one_attached :avatar, dependent: :destroy

  has_many :user_bugs, dependent: :destroy
  has_many :users, through: :user_bugs

  belongs_to :project
  
  validates :title, length: { minimum: 8 }, presence: true
  validates :status, presence: true
  validates :bugtype, presence: true

  scope :newly, -> { where(status: 'new') }
  scope :started, -> { where(status: 'started') }
  scope :completed, -> { where(status: 'completed') }
end
