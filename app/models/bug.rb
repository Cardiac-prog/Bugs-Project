  class Bug < ApplicationRecord
    # Associations
    belongs_to :project
    belongs_to :reported_by, class_name: "User", foreign_key: "reported_by_id"
    belongs_to :assigned_to, class_name: "User", foreign_key: "assigned_to_id"

    # Enums
    enum category: { ui: 0, backend: 1, performance: 2, security: 3, other: 4 }
    enum priority: { low: 0, medium: 1, high: 2, critical: 3 }

    def url
      Rails.application.routes.url_helpers.project_bug_path(self.project, self)
    end
  end
