class CreateAssessmentBatches < ActiveRecord::Migration[8.2]
  def change
    create_table :assessment_batches do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :status, default: 'open', null: false

      t.timestamps
    end

    add_index :assessment_batches, [ :name, :status ]
  end
end
