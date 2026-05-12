class Assessment < ApplicationRecord
  include Sluggable

  belongs_to :user
  belongs_to :team
  belongs_to :account
  belongs_to :assessment_batch

  has_many :answers
  has_many :assessment_frameworks, dependent: :destroy
  has_many :frameworks, through: :assessment_frameworks
  has_many :assessment_controls, dependent: :destroy
  has_many :controls, through: :assessment_controls

  enum :status, %i[ open closed ].index_by(&:itself), default: :open

  scope :available, -> { where(deleted_at: nil) }
  scope :discarded, -> { where.not(deleted_at: nil) }

  # validate :single_open_assessment, if: :open?
  validates :name, presence: true, length: { maximum: 72 }, uniqueness: { scope: :team_id }

  def single_open_assessment
    return unless team.assessments.open.where.not(id: id).exists?
    errors.add(:base, "A subsidiary can have only one open assessment at a time")
  end

  def framework_control_codes(control)
    frameworks.includes(:framework_controls).where(framework_controls: { control_id: 2 })

    includes(:framework).map do |fc|
      [ fc.framework.code, fc.code ]
    end
  end
end
