class Bug < ApplicationRecord
  # Associations
  belongs_to :reported_by, class_name: "User"             # reported_by  is developer
  belongs_to :assigned_to, class_name: "User"    # assigned_to is qa
  belongs_to :project

  belongs_to :developer, class_name: "User", optional: true
  belongs_to :qa, class_name: "User", optional: true

  # Enums
  enum category: { ui: 0, backend: 1, performance: 2, security: 3, other: 4 }
  enum priority: { low: 0, medium: 1, high: 2, critical: 3 }
end
