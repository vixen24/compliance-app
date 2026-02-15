class RemoveControlScopeToAssessments < ActiveRecord::Migration[8.2]
  def change
    remove_column :assessments, :control_scope, :string
  end
end
