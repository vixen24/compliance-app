class AddAccountToAssessmentBatch < ActiveRecord::Migration[8.2]
  def change
    add_reference :assessment_batches, :account, null: false, foreign_key: true
  end
end
