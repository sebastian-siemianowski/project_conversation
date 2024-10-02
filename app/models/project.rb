class Project < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :status_changes, dependent: :destroy

  enum status: { not_started: 0, in_progress: 1, completed: 2, on_hold: 3 }

  validates :title, presence: true
end
