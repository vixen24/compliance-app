class AddAccountToTeam < ActiveRecord::Migration[8.2]
  def change
    add_reference :teams, :account, null: false, foreign_key: true
  end
end
