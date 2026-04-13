class AddMfaToAccounts < ActiveRecord::Migration[8.2]
  def up
    add_column :accounts, :mfa_enabled, :boolean, default: false
    execute "UPDATE accounts SET mfa_enabled = false WHERE mfa_enabled IS NULL"
    change_column_null :accounts, :mfa_enabled, false
  end

  def down
    remove_column :accounts, :mfa_enabled
  end
end
