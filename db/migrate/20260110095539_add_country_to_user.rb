class AddCountryToUser < ActiveRecord::Migration[8.2]
  def change
    add_column :users, :country, :string
  end
end
