class CreateControls < ActiveRecord::Migration[8.2]
  def change
    create_table :controls do |t|
      t.text :question, null: false
      t.string :name
      t.string :code
      t.text :description
      t.string :domain
      t.string :category

      t.timestamps
    end

    add_index :controls, :code, unique: true
  end
end
