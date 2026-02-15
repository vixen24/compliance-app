class CreateFeedbacks < ActiveRecord::Migration[8.2]
  def change
    create_table :feedbacks do |t|
      t.references :answer, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :role, null: false
      t.text :content
      t.integer :parent_id

      t.timestamps
    end
  end
end
