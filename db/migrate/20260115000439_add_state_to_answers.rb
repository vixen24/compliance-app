class AddStateToAnswers < ActiveRecord::Migration[8.2]
  def change
    add_column :answers, :state, :string, default: "pending"
  end
end
