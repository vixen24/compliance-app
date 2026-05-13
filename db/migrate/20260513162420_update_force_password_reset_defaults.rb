class UpdateForcePasswordResetDefaults < ActiveRecord::Migration[8.2]
  def change
    change_column_default :users, :force_password_reset, false
    change_column_null :users, :force_password_reset, false
  end
end
