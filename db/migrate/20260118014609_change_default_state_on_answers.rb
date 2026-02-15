class ChangeDefaultStateOnAnswers < ActiveRecord::Migration[8.2]
  def change
     change_column_default :answers, :state, from: "pending", to: "draft"
  end
end
