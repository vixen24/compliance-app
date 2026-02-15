class ChangeStatusDefaultInAssessments < ActiveRecord::Migration[8.2]
  def change
    change_column_default :assessments, :status, from: "live", to: "open"
  end
end
