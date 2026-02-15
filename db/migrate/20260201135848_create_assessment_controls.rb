class CreateAssessmentControls < ActiveRecord::Migration[8.2]
  def change
    create_table :assessment_controls do |t|
      t.references :assessment, null: false, foreign_key: true
      t.references :control, null: false, foreign_key: true

      # snapshot field from controls
      t.text :question
      t.string :name
      t.string :code
      t.text :description
      t.string :domain
      t.string :category
      t.string :guidiance
      t.string :evidence

      t.timestamps
    end

    add_index :assessment_controls, [ :assessment_id, :control_id ], unique: true
  end
end
