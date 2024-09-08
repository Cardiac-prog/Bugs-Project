class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { manager: 0, qa: 1, developer: 2 }
  validates :role, presence: true, inclusion: { in: roles.keys }

  has_many :reported_bugs, class_name: "Bug", foreign_key: "reported_by_id"
  has_many :assigned_bugs, class_name: "Bug", foreign_key: "assigned_to_id"
end
