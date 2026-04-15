class Account < ApplicationRecord
  # has_one :join_code
  has_many :users, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :assessments, dependent: :destroy
  has_many :sessions, through: :users
  has_many :assessment_batches, dependent: :destroy

  validates :name, presence: true
  # before_create :assign_external_account_id

  def self.create_with_owner(account:, owner:)
    create!(**account).tap do |account|
      account.create_system_user!

      account.users.create!(
        **owner.with_defaults(role: :owner)
      )
    end
  end

  def create_system_user!
    SystemUser.create!(
      account_id: id,
      role: "system",
      name: "System"
    )
  end


  def self.accepting_signups
    count.zero?
  end

  private

  # def assign_external_account_id
  #   self.external_account_id ||= ExternalIdSequence.next
  # end
end
