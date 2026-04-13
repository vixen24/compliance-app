class AddDeletedAtToAssessmentBatch < ActiveRecord::Migration[8.2]
  def change
    add_column :assessment_batches, :deleted_at, :datetime
  end
end
