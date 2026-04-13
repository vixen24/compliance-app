class AddDeletedAtToAssessments < ActiveRecord::Migration[8.2]
  def change
    add_column :assessments, :deleted_at, :datetime
  end
end
