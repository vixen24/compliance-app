class FixAnswersForeignKey < ActiveRecord::Migration[8.2]
  def change
    remove_foreign_key :answers, column: :assessment_control_id
    add_foreign_key :answers, :assessment_controls
  end
end
