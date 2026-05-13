class CreateAccountExternalIdSequences < ActiveRecord::Migration[8.2]
  def change
    create_table :account_external_id_sequences do |t|
      t.integer :value, null: false, default: 0

      t.index :value, unique: true
    end
  end
end
