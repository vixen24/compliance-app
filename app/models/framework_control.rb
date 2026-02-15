class FrameworkControl < ApplicationRecord
  belongs_to :framework
  belongs_to :control

  scope :for_assessment, ->(assessment) {
    joins(framework: :assessments)
      .where(assessments: { id: assessment })
  }

  scope :for_control, ->(control) {
    where(control_id: control.control_id)
  }

  def self.for_display(assessment:, control:)
    for_assessment(assessment).for_control(control).includes(:framework)
  end

  def full_framework_code
    "#{framework.code} #{code}"
  end
end
