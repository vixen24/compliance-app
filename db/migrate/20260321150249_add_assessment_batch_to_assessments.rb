class AddAssessmentBatchToAssessments < ActiveRecord::Migration[8.2]
  def change
    add_reference :assessments, :assessment_batch, foreign_key: true
  end
end
