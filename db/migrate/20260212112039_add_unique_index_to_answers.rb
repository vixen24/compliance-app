class AddUniqueIndexToAnswers < ActiveRecord::Migration[8.2]
  def change
    # Remove redundant single-column index
    remove_index :answers, :assessment_control_id

    # Add composite unique index
    add_index :answers,
              [ :assessment_control_id, :assessment_id ],
              unique: true,
              name: "index_answers_on_control_and_assessment"
  end
end
