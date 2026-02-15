class AddAnswerScopeToAssessment < ActiveRecord::Migration[8.2]
  def change
    add_column :assessments, :answer_scope, :string, null: false, default: "scoped"
  end
end
