class Control < ApplicationRecord
  has_many :framework_controls, dependent: :destroy
  has_many :frameworks, through: :framework_controls

  has_many :assessment_controls, dependent: :destroy
  has_many :assessments, through: :assessment_controls
end
