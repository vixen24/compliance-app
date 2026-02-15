class AddAssessmentToAnswers < ActiveRecord::Migration[8.2]
  def change
    add_reference :answers, :assessment, foreign_key: true
  end
end
