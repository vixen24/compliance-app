class AddAccountIdToAssessments < ActiveRecord::Migration[8.2]
  def change
    add_foreign_key :assessments, :accounts, column: :account_id
  end
end
