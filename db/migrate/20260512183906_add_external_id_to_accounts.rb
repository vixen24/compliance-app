class AddExternalIdToAccounts < ActiveRecord::Migration[8.2]
  def change
    add_column :accounts, :external_account_id, :integer, null: false
    add_index :accounts, :external_account_id, unique: true
  end
end
