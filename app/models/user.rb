class User < ApplicationRecord
  include User::Preservable, User::PasswordHistory

  has_secure_password
  belongs_to :account
  has_many :magic_links, dependent: :destroy
  has_many :sessions, dependent: :destroy
  has_many :team_users, dependent: :destroy
  has_many :teams, through: :team_users

  # scope :no_activity_for, ->(days = 60) { where("last_login_at IS NULL OR last_login_at <= ?", Time.current - days.days) }
  # # app/jobs/deactivate_inactive_users_job.rb
  # class DeactivateInactiveUsersJob < ApplicationJob
  #   queue_as :default

  #   def perform
  #     User.no_activity_for(60).update_all(active: false)
  #   end
  # end

  enum :role, %i[ owner executive admin member assessor system ].index_by(&:itself), default: "member", scopes: false

  scope :regular, -> { where.not(role: [ :system, :owner ]) }
  scope :active, -> { where(active: true, role: roles.except("system").keys) }
  scope :inactive, -> { where(active: false, role: roles.except("system").keys) }
  scope :by_active, ->(active) { active.presence ? where(active: ActiveModel::Type::Boolean.new.cast(active)) : all }
  scope :by_role, ->(role) { role.present? ? where(role: role) : all }
  scope :by_team, ->(team) { team.presence ? joins(:teams).where(teams: { id: team }) : includes(:teams) }
  scope :matching, ->(query) do
    return all if query.blank?

    if connection.adapter_name == "PostgreSQL"
      quoted_query = connection.quote(query)
      ts_query = "websearch_to_tsquery('english', #{quoted_query})"

      from_subquery = <<~SQL
        (SELECT #{table_name}.*, ts_rank_cd(search_vector, #{ts_query}) AS rank
        FROM #{table_name}
        WHERE search_vector @@ #{ts_query}) AS #{table_name}
      SQL

      from(Arel.sql(from_subquery)).order("rank DESC")
    else
      where("name LIKE :q OR email_address LIKE :q", q: "%#{query}%")
        .limit(10)
    end
  end

  validates :name, presence: true
  normalizes :email_address, with: ->(email) { email.strip.downcase.presence }
  validates :email_address, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { scope: :account_id, case_sensitive: false }
  validates :password, password_complexity: true, confirmation: true, presence: true, if: -> { new_record? || password.present? }
  validates :role, uniqueness: { scope: :account_id }, if: -> { system? || owner? }

  def self.status_options = [ [ "Active", true ], [ "Inactive", false ] ]

  def self.assignable_roles
    roles.except("owner", "system").keys
  end

  def self.assignable_roles_for_select
    assignable_roles.map { |r| [ r.humanize, r ] }
  end

  def owner_or_admin? = role.in?(%w[owner admin])

  def can_view_assessment? = role.in?(%w[member assessor])

  def can_create_assessment? = role.in?(%w[admin])

  def send_magic_link(**attributes)
    attributes[:purpose] = attributes.delete(:for) if attributes.key?(:for)

    magic_links.create!(attributes).tap do |magic_link|
      MagicLinkMailer.sign_up_instructions(magic_link).deliver_later
    end
  end
end
