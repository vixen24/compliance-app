class AddTsvectorToAssessmentControl < ActiveRecord::Migration[8.2]
  def up
    return unless connection.adapter_name == "PostgreSQL"

    add_column :assessment_controls, :search_vector, :tsvector, as: "to_tsvector('english', question)", stored: true
    add_index :assessment_controls, :search_vector, using: :gin, name: "index_assessment_controls_on_search_vector"
  end

  def down
    return unless connection.adapter_name == "PostgreSQL"

    remove_index :assessment_controls, name: "index_assessment_controls_on_search_vector"
    remove_column :assessment_controls, :search_vector
  end
end
