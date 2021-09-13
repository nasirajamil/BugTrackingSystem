class Project < ApplicationRecord
  has_many :user_projects
  has_many :users, through: :user_projects

  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
end
