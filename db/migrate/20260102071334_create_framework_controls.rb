class CreateFrameworkControls < ActiveRecord::Migration[8.2]
  def change
    create_table :framework_controls do |t|
      t.references :framework, null: false, foreign_key: true
      t.references :control, null: false, foreign_key: true
      t.string :code, null: false
      t.string :section
      t.string :name
      t.string :description
      t.text :guidance

      t.timestamps
    end

    add_index :framework_controls, [ :framework_id, :control_id ], unique: true
  end
end
