class ChangeTeamsSlugToBeUniquePerAccount < ActiveRecord::Migration[8.2]
  def change
    remove_index :teams, :slug

    add_index :teams, [ :account_id, :slug ], unique: true
  end
end
