class AddGinIndexToControlsQuestion < ActiveRecord::Migration[8.2]
  def change
    execute <<~SQL
      CREATE INDEX index_controls_on_question_tsv
      ON controls USING gin(to_tsvector('english', question));
    SQL
  end
end
