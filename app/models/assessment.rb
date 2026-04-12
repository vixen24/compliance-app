class Assessment < ApplicationRecord
  has_many :assessment_frameworks, dependent: :destroy
  has_many :frameworks, through: :assessment_frameworks
  has_many :assessment_controls, dependent: :destroy
  has_many :controls, through: :assessment_controls
  has_many :answers

  belongs_to :team
  belongs_to :account
  belongs_to :user # user that created the assessment
  belongs_to :assessment_batch

  enum :status, %i[ open closed ].index_by(&:itself), default: :open

  validates :name, presence: true, length: { maximum: 72 }
  # validate :single_open_assessment, if: :open?

  def single_open_assessment
    return unless team.assessments.open.where.not(id: id).exists?
    errors.add(:base, "A subsidiary can have only one open assessment at a time")
  end

  # TODO: Add DB constraint for above validation
  # add_index :assessments,
  #         :team_id,
  #         unique: true,
  #         where: "status = 'open'"

  def framework_control_codes(control)
    frameworks.includes(:framework_controls).where(framework_controls: { control_id: 2 })

    includes(:framework).map do |fc|
      [ fc.framework.code, fc.code ]
    end
  end
end
