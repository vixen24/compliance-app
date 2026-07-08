class AddSearchVectorToUsers < ActiveRecord::Migration[8.2]
  def up
    return unless connection.adapter_name == "PostgreSQL"

    add_column :users,
               :search_vector,
               :tsvector,
               as: "(
                 to_tsvector('english', coalesce(name,'') || ' ' || coalesce(email_address,''))
               )",
               stored: true

    add_index :users,
              :search_vector,
              using: :gin,
              algorithm: :concurrently
  end

  def down
    return unless connection.adapter_name == "PostgreSQL"

    remove_index :users, :search_vector if index_exists?(:users, :search_vector)
    remove_column :users, :search_vector
  end
end