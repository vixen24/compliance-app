class ChangeControlIdToAssessmentControlIdOnAnswers < ActiveRecord::Migration[8.2]
  def change
    rename_column :answers, :control_id, :assessment_control_id
  end
end
