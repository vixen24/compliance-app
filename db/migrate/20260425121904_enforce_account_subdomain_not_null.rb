class EnforceAccountSubdomainNotNull < ActiveRecord::Migration[8.2]
  def change
    change_column_null :accounts, :subdomain, false
  end
end
