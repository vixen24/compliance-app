class ChangeControlIdNullableInControls < ActiveRecord::Migration[8.2]
  def change
    change_column :controls, :control_id, :integer, null: true
  end
end
