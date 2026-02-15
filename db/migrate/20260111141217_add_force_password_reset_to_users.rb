class AddForcePasswordResetToUsers < ActiveRecord::Migration[8.2]
  def change
    add_column :users, :force_password_reset, :boolean
  end
end
