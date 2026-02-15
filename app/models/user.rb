class User < ApplicationRecord
  include User::Preservable

  has_secure_password
  belongs_to :account
  has_many :magic_links, dependent: :destroy
  has_many :sessions, dependent: :destroy

  has_many :team_users, dependent: :destroy
  has_many :teams, through: :team_users

  # scope :inactive_for, ->(days = 60) { where("last_login_at IS NULL OR last_login_at <= ?", Time.current - days.days) }
  # # app/jobs/deactivate_inactive_users_job.rb
  # class DeactivateInactiveUsersJob < ApplicationJob
  #   queue_as :default

  #   def perform
  #     User.inactive_for(60).update_all(active: false)
  #   end
  # end

  enum :role, %i[ owner executive admin member assessor system ].index_by(&:itself), default: "member", scopes: false

  scope :owner, -> { where(active: true, role: :owner) }
  scope :admin, -> { where(active: true, role: %i[ owner admin ]) }
  scope :member, -> { where(active: true, role: :member) }
  scope :active, -> { where(active: true, role: %i[ owner admin member ]) }
  scope :member_or_admin, -> { where.not(role: :owner) }
  scope :by_team, ->(team) {
    return unless team.present?
    joins(:teams).where(teams: { id: team })
  }

  normalizes :email_address, with: ->(value) { value.strip.downcase.presence }
  validates :email_address, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, :password_confirmation, presence: true, on: :create
  validates :password, confirmation: true, length: { minimum: 6 }, allow_blank: true

  def owner_or_admin?
    role.in?(%w[owner admin])
  end

  def self.signup_enabled?
    User.count.zero?
  end

  def can_view_assessment?
    role.in?(%w[member assessor])
  end

  def can_create_assessment?
    role.in?(%w[admin])
  end

  def send_magic_link(**attributes)
    attributes[:purpose] = attributes.delete(:for) if attributes.key?(:for)

    magic_links.create!(attributes).tap do |magic_link|
      MagicLinkMailer.sign_up_instructions(magic_link).deliver_later
    end
  end
end
