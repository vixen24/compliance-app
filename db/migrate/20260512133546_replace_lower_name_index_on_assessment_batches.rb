class ReplaceLowerNameIndexOnAssessmentBatches < ActiveRecord::Migration[8.2]
  def change
    remove_index :assessment_batches,
                 name: :index_assessment_batches_on_lower_name

    add_index :assessment_batches,
              "account_id, lower(name)",
              unique: true,
              name: :index_assessment_batches_on_account_and_lower_name
  end
end
