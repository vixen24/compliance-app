class RemoveAssessmentFromAnswers < ActiveRecord::Migration[8.2]
  def change
    if index_exists?(:answers, :assessment_id, name: :index_answers_on_assessment_id)
      remove_index :answers, name: :index_answers_on_assessment_id
    end

    remove_column :answers, :assessment_id if column_exists?(:answers, :assessment_id)
  end
end
