class SystemUser < ApplicationRecord
  self.table_name = "users"

  def authenticate(_password)
    false
  end

  def system?
    true
  end
end
