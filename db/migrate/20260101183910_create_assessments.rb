class CreateAssessments < ActiveRecord::Migration[8.2]
  def change
    create_table :assessments do |t|
      t.references :account, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :status, default: 'draft', null: false
      t.date :due_date
      t.string :version

      t.timestamps
    end
  end
end
