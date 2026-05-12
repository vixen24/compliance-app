class AssessmentBatch < ApplicationRecord
  has_many :assessments, dependent: :destroy

  attr_accessor :team_ids, :framework_ids

  enum :status, %i[ open closed ].index_by(&:itself), default: "open"

  scope :available, -> { where(deleted_at: nil) }
  scope :discarded, -> { where.not(deleted_at: nil) }

  validates :name,
            presence: true,
            length: { maximum: 72 },
            uniqueness: { scope: :account_id }

  validates :framework_ids, presence: true
  validates :team_ids, presence: true


  def self.status_options_for_select
    statuses.keys.map { |s| [ s.humanize, s ] }
  end

  # creates AssessmentBatch & associated assessments, frameworks, and controls
  def save_batch
    return false unless valid?

    validate_assessments
    return false if errors.any?

    ActiveRecord::Base.transaction do
      save!
      inserted_assessments = insert_assessments!
      insert_assessment_frameworks!(inserted_assessments)
      insert_assessment_controls(inserted_assessments)
    end

    true
  end

  def update_batch(status)
    return false unless self.class.statuses.key?(status.to_s)

    ActiveRecord::Base.transaction do
      update_column(:status, status)
      assessments.update_all(status: status, updated_at: Time.current)
    end

    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def destroy_batch
    soft_delete && schedule_cleanup
  end

  # Triggered by scheduled job
  def delete_assessments(batch_size)
    AssessmentControl.where(assessment_id: assessment_ids(id)).in_batches(of: batch_size).delete_all
    AssessmentFramework.where(assessment_id: assessment_ids(id)).in_batches(of: batch_size).delete_all
    Assessment.where(assessment_batch_id: id).in_batches(of: batch_size).delete_all
  end

  # Triggered by scheduled job
  def delete_batch
    AssessmentBatch.discarded.where(id: id).delete_all
  end

  private

  # def team_ids_presence
  #   if team_ids.blank?
  #     errors.add(:base, "Select at least one subsidiary")
  #   end
  # end

  # def framework_ids_presence
  #   if framework_ids.blank?
  #     errors.add(:base, "Select at least one framework")
  #   end
  # end

  def validate_assessments
    assessments = build_assessments

    assessments.each do |assessment|
      next if assessment.valid?

      assessment.errors.full_messages.each do |msg|
        errors.add(:base, "Assessment error (Team #{assessment.team_id}): #{msg}")
      end
    end
  end

  def build_assessments
    team_ids.map do |team_id|
      Assessment.new(
        name: name,
        slug: normalize_slug(name),
        team_id: team_id,
        framework_ids: framework_ids,
        user_id: user_id,
        account_id: account_id,
        assessment_batch: self
      )
    end
  end

  def insert_assessments!
    now = Time.current

    rows = team_ids.map do |team_id|
      {
        name: name,
        slug: normalize_slug(name),
        team_id: team_id,
        user_id: user_id,
        account_id: account_id,
        assessment_batch_id: id,
        status: "open",
        created_at: now,
        updated_at: now
      }
    end

    result = Assessment.insert_all!(rows, returning: %w[id team_id])

    result.rows.map do |id, team_id|
      { id: id, team_id: team_id }
    end
  end

  def insert_assessment_frameworks!(assessments)
    now = Time.current

    rows = assessments.flat_map do |assessment|
      framework_ids.map do |framework_id|
        {
          assessment_id: assessment[:id],
          framework_id: framework_id,
          created_at: now,
          updated_at: now
        }
      end
    end

    ActiveRecord::Base.logger.silence do
      AssessmentFramework.insert_all!(rows) if rows.any?
    end
  end

  def insert_assessment_controls(assessments)
    controls = Control.joins(:framework_controls)
                      .where(framework_controls: { framework_id: framework_ids })
                      .distinct

    now = Time.current

    rows = assessments.flat_map do |assessment|
      controls.map do |control|
        {
          assessment_id: assessment[:id],
          control_id: control.id,
          question: control.question,
          name: control.name,
          code: control.code,
          description: control.description,
          domain: control.domain,
          category: control.category,
          created_at: now,
          updated_at: now
        }
      end
    end

    ActiveRecord::Base.logger.silence do
      AssessmentControl.insert_all(rows, unique_by: %i[assessment_id control_id]) if rows.any?
    end
  end

  def soft_delete
    update_all(:status, "closed", deleted_at: Time.current, updated_at: Time.current)
    assessments.update_all(:status, "closed", deleted_at: Time.current, updated_at: Time.current)
  end

  def schedule_cleanup
    AssessmentBatchCleanupJob.set(wait: 24.hours).perform_later(self)
    true
  end

  def assessment_ids(batch_id)
    Assessment.where(assessment_batch_id: batch_id).select(:id)
  end

  def normalize_slug(value)
    value.to_s.parameterize
  end
end
