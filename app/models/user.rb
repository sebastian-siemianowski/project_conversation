class User < ApplicationRecord
  has_many :projects

  enum role: { member: 0, admin: 1 }
  # Set a default role for new users
  after_initialize :set_default_role, if: :new_record?

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  private

  def set_default_role
    self.role ||= :member
  end
end
