class AddNameAndCountryToTeam < ActiveRecord::Migration[8.2]
  def change
    add_column :teams, :name, :string, null: false
  end
end
