class AddBrandingFieldsToAccounts < ActiveRecord::Migration[8.2]
  def change
    add_column :accounts, :primary_color, :string
    add_column :accounts, :secondary_color, :string
  end
end
