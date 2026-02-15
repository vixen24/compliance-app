class AddNullInAccountIdToAssessments < ActiveRecord::Migration[8.2]
  def change
    change_column_null :assessments, :account_id, false
  end
end
