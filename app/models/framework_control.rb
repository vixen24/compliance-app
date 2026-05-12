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

  def full_framework_code
    "#{framework.code} #{code}"
  end
end
