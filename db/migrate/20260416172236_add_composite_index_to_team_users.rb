class AddCompositeIndexToTeamUsers < ActiveRecord::Migration[8.2]
  def change
    add_index :team_users, [ :user_id, :team_id ], unique: true
  end
end
