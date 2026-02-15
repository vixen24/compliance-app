module User::Preservable
  extend ActiveSupport::Concern

  included do
    before_destroy :prevent_non_owner_from_deleting_owner
    before_update  :prevent_non_owner_from_modifying_owner
    validate :only_one_owner_per_account, on: :create
  end

  private

  def prevent_non_owner_from_deleting_owner
    if role == "owner" && !Current.user&.owner?
      errors.add(:base, "Only an owner can delete another owner")
      throw :abort
    end
  end

  def prevent_non_owner_from_modifying_owner
    if role_was == "owner" && !Current.user&.owner? && changed?
      errors.add(:base, "Only an owner can modify another owner")
      throw :abort
    end
  end

  def only_one_owner_per_account
    return unless role == "owner"
    if User.where(account_id: account_id, role: "owner").exists?
      errors.add(:base, "An owner already exists for this account")
    end
  end
end
