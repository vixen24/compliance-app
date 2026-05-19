class AddYearToAssessmentBatches < ActiveRecord::Migration[8.2]
  def change
    add_column :assessment_batches, :year, :integer
    add_index :assessment_batches, :year
  end
end
