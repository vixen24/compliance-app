class ChangeAssessmentsSlugIndexToScoped < ActiveRecord::Migration[8.2]
  def change
    remove_index :assessments, name: "index_assessments_on_slug"
  end
end
