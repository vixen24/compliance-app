class CreateFrameworks < ActiveRecord::Migration[8.2]
  def change
    create_table :frameworks do |t|
      t.string :code, null: false
      t.string :name
      t.text :description
      t.string :version

      t.timestamps
    end

    add_index :frameworks, :code, unique: true
  end
end
