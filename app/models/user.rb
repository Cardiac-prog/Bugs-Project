class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { manager: 0, qa: 1, developer: 2 }
  validates :role, presence: true, inclusion: { in: roles.keys }

  has_many :reported_bugs, class_name: "Bug", foreign_key: "reported_by_id"     # qa_id
  has_and_belongs_to_many :assigned_bugs, class_name: "Bug", join_table: "bugs_users"   # , foreign_key: "user_id", association_foreign_key: "bug_id", dependent: :destroy


  has_many :managed_projects, class_name: "Project", foreign_key: "manager_id", dependent: :destroy      # A manager can have multiple projects
  has_and_belongs_to_many :projects, join_table: "projects_qas"               # For many-to-many relationship by join table b/w Projects and QAs
end                                                                  # specifying join table name as "projects_qas" bcz the two joined tabled are Project and User and rails default behaviour is like it will find table named "projects_users"



# Availabitlity of many to many
#
