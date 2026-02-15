class CreateAnswers< ActiveRecord::Migration[8.2]
  def change
    create_table :answers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :control, null: false, foreign_key: true
      t.string :status
      t.text :comment

      t.timestamps
    end
  end
end
