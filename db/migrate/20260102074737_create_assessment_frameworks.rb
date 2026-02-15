class CreateAssessmentFrameworks < ActiveRecord::Migration[8.2]
  def change
    create_table :assessment_frameworks do |t|
      t.references :assessment, null: false, foreign_key: true
      t.references :framework, null: false, foreign_key: true

      t.timestamps
    end
  end
end
