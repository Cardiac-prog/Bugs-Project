class Bug < ApplicationRecord
  belongs_to :reported_by
  belongs_to :assigned_to
  belongs_to :project
end
