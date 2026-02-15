class AddControlIdToControls < ActiveRecord::Migration[8.2]
  def change
    add_column :controls, :control_id, :integer, null: false
  end
end
