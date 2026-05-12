class AddSlugToAssessments < ActiveRecord::Migration[8.2]
  def change
    add_column :assessments, :slug, :string
    add_index :assessments, :slug, unique: true
  end
end
