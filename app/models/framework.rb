class Framework < ApplicationRecord
  has_many :framework_controls, dependent: :destroy
  has_many :controls, through: :framework_controls

  has_many :assessment_frameworks, dependent: :destroy
  has_many :assessments, through: :assessment_frameworks
end
