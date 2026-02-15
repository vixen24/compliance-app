class RenameAnswerScopeToControlScopeOnAssessments < ActiveRecord::Migration[8.2]
  def change
    rename_column :assessments, :answer_scope, :control_scope
  end
end
