class AddTeamToAssessments < ActiveRecord::Migration[8.2]
  def up
    # 1. Add as nullable first so we can backfill safely
    add_reference :assessments, :team, foreign_key: true, null: true

    # 2. Backfill — assign all existing rows to team_id = 1
    execute <<~SQL
      UPDATE assessments SET team_id = 1;
    SQL

    # 3. Now enforce non-null
    change_column_null :assessments, :team_id, false
  end

  def down
    remove_reference :assessments, :team, foreign_key: true
  end
end
