class ChangeDefaultStatusOnAssessments < ActiveRecord::Migration[8.2]
  def change
    change_column_default :assessments, :status, from: "draft", to: "live"
  end
end
