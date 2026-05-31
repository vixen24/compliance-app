class Account < ApplicationRecord
  has_one_attached :logo, dependent: :purge_later
  has_many :assessment_batches, dependent: :destroy
  has_many :assessments, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :sessions, through: :users

  before_create :assign_external_account_id

  # All validations are handled by the SignUp model

  class << self
    def create_with_owner(account:, owner:)
      create!(**account).tap do |account|
        account.create_system_user!
        account.users.create!(**owner.with_defaults(role: :owner))
      end
    end

    def accepting_signups
      count.zero?
    end
  end

  def slug
    "/#{AccountSlug.encode(external_account_id)}"
  end

  def create_system_user!
    SystemUser.create!(
      account_id: id,
      role: "system",
      name: "System"
    )
  end

  private

  def assign_external_account_id
    self.external_account_id ||= ExternalIdSequence.next
  end
end
