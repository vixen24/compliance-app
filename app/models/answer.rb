class Answer < ApplicationRecord
  include Answer::StatePolicy

  belongs_to :assessment_control
  belongs_to :assessment
  belongs_to :user # Remove this user, replace with last_modified_by/at and last review_by/at and accepted
  has_many :feedbacks

  scope :for_frameworks, ->(frameworks = nil) {
  framework_ids = Array(frameworks).map { |f| f.respond_to?(:id) ? f.id : f } .compact

    if framework_ids.any?
      joins(assessment_control: { control: :frameworks }) .where(frameworks: { id: framework_ids }).distinct
    else
      all
    end
  }

  scope :for_open_assessment_for_team, ->(team) {
    joins(assessment_control: :assessment)
      .where(assessments: { status: "open", team_id: team.id })
  }


  scope :for_assessment_control, ->(assessment) {
    joins(:assessment_control)
      .where(assessment_controls: { assessment_id: assessment.id })
  }

  scope :for_framework_control, ->(framework) {
    joins(assessment_control: { control: :framework_controls })
      .where(framework_controls: { framework_id: framework.id })
      .distinct
  }

  scope :approved, -> { where(state: :approved) }
  scope :compliant, -> { where(status: "C") }

  validates :assessment_control_id, uniqueness: { scope: :assessment_id }
  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp, message: "must be a valid URL" }, allow_blank: true

  STATUS_LABELS = {
    "C"   => "Compliant",
    "NC"  => "Not Compliant",
    "OFI" => "Opportunity for Improvement",
    "NA"  => "Not Applicable"
  }.freeze

  def self.upsert_from(attrs)
    find_or_initialize_by(assessment_control_id: attrs[:assessment_control_id], assessment_id: attrs[:assessment_id]).tap { |a| a.assign_attributes(attrs) }
  end

  def self.count_by(attribute, assessment:, framework: nil, only_approved: false)
    scope = approved if only_approved
    scope = scope.for_assessment_control(assessment) if only_approved
    scope = for_assessment_control(assessment) unless only_approved
    scope = scope.for_framework_control(framework) if framework.present?
    scope.group(attribute)
  end

  def self.count_by_account(attribute, account:, only_approved: false)
    scope = approved if only_approved
    scope = scope.for_assessment_control(assessment) if only_approved
    scope = for_assessment_control(assessment) unless only_approved
    scope = scope.for_framework_control(framework) if framework.present?
    scope.group(attribute)
  end

  def self.oldest_submitted_for_assessment(assessment_id)
    where(assessment_id: assessment_id, state: :submitted) .order(:created_at) .pick(:created_at)
  end

  def self.earliest_submitted_for_assessment(assessment_id)
    where(assessment_id: assessment_id, state: :submitted) .order(created_at: :desc) .pick(:created_at)
  end
end




# controls = AssessmentControl
#   .where(assessment_id: 3)
#   .order(:id)
#   .limit(600)


# controls.each do |control|
#   Answer.find_or_create_by!(
#     assessment_control_id: control.id,
#     assessment_id: control.assessment_id,
#   ) do |answer|
#     answer.state  = "approved"
#     answer.status = "C"
#     answer.user_id= 4
#   end
# end



# controls = AssessmentControl
#   .where(assessment_id: 17)
#   .order(:id)
#   .limit(600)

# created_count = 0

# controls.each do |control|
#   break if created_count >= 10  # stop after 10 new answers

#   answer = Answer.find_or_create_by(
#     assessment_control_id: control.id,
#     assessment_id: control.assessment_id
#   ) do |a|
#     a.state   = "approved"
#     a.status  = "C"
#     a.user_id = 4
#   end

#   # Only count if a new record was created
#   created_count += 1 if answer.persisted? && answer.created_at >= 1.second.ago
# end

# puts "Created #{created_count} new answers"
#
#
#
#
#
#
#
#
#
#
# answers_to_update = Answer
#   .where(assessment_id: 4, state: "approved", status: "OFI")
#   .order(:id)   # ensure consistent selection
#   .limit(50)

# # Update them in bulk
# answers_to_update.update_all(state: "approved", status: "NC")
