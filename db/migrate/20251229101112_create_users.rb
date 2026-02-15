class CreateUsers < ActiveRecord::Migration[8.2]
  def change
    create_table :users do |t|
      t.references :account, null: false, foreign_key: true
      t.string :email_address, null: false
      t.string :password_digest, null: false
      t.string :role, default: 'member', null: false
      t.string :name

      t.timestamps
    end
    add_index :users, :email_address, unique: true
    add_index :users, :role
  end
end
