class Account < ApplicationRecord
  # has_one :join_code
  has_many :users, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :assessments, dependent: :destroy

  validates :name, presence: true
  # before_create :assign_external_account_id

  class << self
    def create_with_owner(account:, owner:)
      create!(**account).tap do |account|
        # account.users.create!(role: :system, name: "System")
        account.users.create!(**owner.with_defaults(role: :owner))
      end
    end
  end

  private

  # def assign_external_account_id
  #   self.external_account_id ||= ExternalIdSequence.next
  # end
end
