class AddUrlToAnswers < ActiveRecord::Migration[8.2]
  def change
    add_column :answers, :url, :string
  end
end
