class CreateAssessmentControlsJob < ApplicationJob
  queue_as :default

  def perform(assessment_ids, framework_ids)
    return if assessment_ids.blank? || framework_ids.blank?

    assessments = Assessment.where(id: assessment_ids)
    controls = Control.joins(:framework_controls).where(framework_controls: { framework_id: framework_ids }).distinct

    now = Time.current
    rows = []

    assessments.each do |assessment|
      controls.each do |control|
        rows << {
          assessment_id: assessment.id,
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

    unless rows.empty?
      ActiveRecord::Base.logger.silence do
        AssessmentControl.insert_all(rows, unique_by: [ :assessment_id, :control_id ])
      end
      Rails.logger.info "Created #{rows.size} AssessmentControls for #{assessments.size} assessments"
    end
  end
end
