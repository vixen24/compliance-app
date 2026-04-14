class AllowNullCredentialsForSystemUsers < ActiveRecord::Migration[8.2]
  def up
    change_column_null :users, :email_address, true
    change_column_null :users, :password_digest, true
  end

  def down
    change_column_null :users, :email_address, false
    change_column_null :users, :password_digest, false
  end
end
