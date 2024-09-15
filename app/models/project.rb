  class Project < ApplicationRecord
    has_many :bugs, dependent: :destroy              # A project has many bugs, when a project is deleted, all its associated bugs will also be removed
    belongs_to :manager, class_name: "User"   # Because manager can create project (A project have a manager)
    has_and_belongs_to_many :qas, class_name: "User", join_table: "projects_qas"    # A project has many QAs And  a QA can be assigned to many projects        # For many-to-many relationship by join table b/w Projects and QAs
    # specifying join table name as "projects_qas" bcz the two joined tabled are Project and User and rails default behaviour is like it will find table named "projects_users"

    # formatting date
    def formatted_start_date
      start_date.strftime("%d-%m-%y") if start_date
    end

    def formatted_end_date
      end_date.strftime("%d-%m-%y") if end_date
    end

    validates :title, :description, :start_date, :end_date, presence: true         # validates while creating & updating project

    validate :end_date_after_start_date    # To ensure end date is after start date


    def end_date_after_start_date
      if end_date.present? && start_date.present? && end_date < start_date
        errors.add(:end_date, "must be after the start date")
      end
    end
  end
