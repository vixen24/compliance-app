class Assessment < ApplicationRecord
  has_many :assessment_frameworks, dependent: :destroy
  has_many :frameworks, through: :assessment_frameworks
  has_many :assessment_controls, dependent: :destroy
  has_many :controls, through: :assessment_controls

  has_many :answers
  belongs_to :team
  belongs_to :account
  belongs_to :user # user that created the assessment

  enum :status, %i[ open closed ].index_by(&:itself), default: :open

  validates :name, presence: true, length: { maximum: 72 }
  validate :only_one_open_assessment_per_team, if: -> { status == "open" }

  def only_one_open_assessment_per_team
    if team.assessments.where(status: "open").where.not(id: id).exists?
      errors.add(:base, "Only one open assessment is allowed at once. Close all Open assessments and try again")
    end
  end

  def self.bulk_create!(name, team_ids, framework_ids, user)
    assessments = []
    errors = []
    team_ids.each do |team_id|
      assessment = Assessment.create(name: name, team_id: team_id, framework_ids: framework_ids, user_id: user.id, account_id: user.account.id)
      if assessment.save
        assessments << assessment
      else
        errors << assessment.errors.full_messages
      end
    end
     { assessments: assessments, errors: errors }
  end

  def self.bulk_create_with_controls(name, team_ids, framework_ids, user)
    result = bulk_create!(name, team_ids, framework_ids, user)
    if result[:assessments].any?
      CreateAssessmentControlsJob.perform_later(
        result[:assessments].map(&:id),
        framework_ids
      )
    end
    result
  end

  def framework_control_codes(control)
    frameworks.includes(:framework_controls).where(framework_controls: { control_id: 2 })

    includes(:framework).map do |fc|
      [ fc.framework.code, fc.code ]
    end
  end
end
