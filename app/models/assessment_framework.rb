class AssessmentFramework < ApplicationRecord
  belongs_to :assessment
  belongs_to :framework
  # has_many :assessment_controls
end
