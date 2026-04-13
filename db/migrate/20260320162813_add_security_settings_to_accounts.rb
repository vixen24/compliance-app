class AddSecuritySettingsToAccounts < ActiveRecord::Migration[8.2]
  def change
    add_column :accounts, :password_complexity, :boolean, null: false, default: true
    add_column :accounts, :session_timeout, :integer
  end
end
