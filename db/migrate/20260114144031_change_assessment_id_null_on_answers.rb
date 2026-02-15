class ChangeAssessmentIdNullOnAnswers < ActiveRecord::Migration[8.2]
  def change
    change_column_null :answers, :assessment_id, false
  end
end
