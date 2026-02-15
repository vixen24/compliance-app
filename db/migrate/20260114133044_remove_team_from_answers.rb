class RemoveTeamFromAnswers < ActiveRecord::Migration[8.2]
  def change
    remove_reference :answers, :team, foreign_key: true
  end
end
