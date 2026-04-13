class AddIndexToAssessmentBatch < ActiveRecord::Migration[8.2]
  def change
    add_index :assessment_batches, "lower(name)", unique: true, name: "index_assessment_batches_on_lower_name"
  end
end
