class User < ApplicationRecord
  include OwnerProtection, Role

  belongs_to :account
  has_many :magic_links, dependent: :destroy
  has_many :sessions, dependent: :destroy
  has_many :team_users, dependent: :destroy
  has_many :teams, through: :team_users

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

  has_secure_password
  validates :name, presence: true, unless: -> { owner? }
  validates :role, uniqueness: { scope: :account_id }, if: -> { system? || owner? }
  normalizes :email_address, with: ->(email) { email.strip.downcase.presence }
  validates :email_address, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { scope: :account_id, case_sensitive: false }
  validates :password, confirmation: true, password_complexity: true, password_history: true

  def send_magic_link(**attributes)
    attributes[:purpose] = attributes.delete(:for) if attributes.key?(:for)

    magic_links.create!(attributes).tap do |magic_link|
      MagicLinkMailer.sign_up_instructions(magic_link).deliver_later
    end
  end

  def system?
    false
  end
end

# scope :no_activity_for, ->(days = 60) { where("last_login_at IS NULL OR last_login_at <= ?", Time.current - days.days) }
# # app/jobs/deactivate_inactive_users_job.rb
# class DeactivateInactiveUsersJob < ApplicationJob
#   queue_as :default

#   def perform
#     User.no_activity_for(60).update_all(active: false)
#   end
# end
