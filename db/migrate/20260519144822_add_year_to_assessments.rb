class AddYearToAssessments < ActiveRecord::Migration[8.2]
  def change
    add_column :assessments, :year, :integer
    add_index :assessments, :year
  end
end
