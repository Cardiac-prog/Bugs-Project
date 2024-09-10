class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { manager: 0, qa: 1, developer: 2 }
  validates :role, presence: true, inclusion: { in: roles.keys }

  has_many :reported_bugs, class_name: "Bug", foreign_key: "reported_by_id"     # developer_id
  has_many :assigned_bugs, class_name: "Bug", foreign_key: "assigned_to_id"     # qa_id
  has_many :projects, foreign_key: :manager_id      # A manager can have multiple projects
  # has_and_belongs_to_many :projects               # For many-to-many relationship by join table b/w Projects and QAs
end
