class AddSearchVectorToUsers < ActiveRecord::Migration[8.2]
  disable_ddl_transaction!  # GIN index can be created concurrently

  def up
    # Add tsvector column
    add_column :users, :search_vector, :tsvector

    # Populate initial values
    execute <<-SQL.squish
      UPDATE users
      SET search_vector =#{' '}
        to_tsvector('english', coalesce(name,'') || ' ' || coalesce(email_address,''));
    SQL

    # Add index for fast searching
    add_index :users, :search_vector, using: :gin, algorithm: :concurrently

    # Optional: create trigger to auto-update search_vector on insert/update
    execute <<-SQL.squish
      CREATE FUNCTION users_search_vector_trigger() RETURNS trigger AS $$
      begin
        new.search_vector :=
          to_tsvector('english', coalesce(new.name,'') || ' ' || coalesce(new.email_address,''));
        return new;
      end
      $$ LANGUAGE plpgsql;

      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON users FOR EACH ROW EXECUTE FUNCTION users_search_vector_trigger();
    SQL
  end

  def down
    execute "DROP TRIGGER IF EXISTS tsvectorupdate ON users;"
    execute "DROP FUNCTION IF EXISTS users_search_vector_trigger();"
    remove_index :users, :search_vector
    remove_column :users, :search_vector
  end
end
