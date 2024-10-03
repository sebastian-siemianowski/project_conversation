class Project < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :status_changes, dependent: :destroy

  enum status: { not_started: 0, in_progress: 1, completed: 2, on_hold: 3 }

  validates :title, presence: true

  def self.destroy_all
    if Rails.env.development? || Rails.env.test?
      Project.all.each do |project|
        project.destroy
      end
    end
  end
end
