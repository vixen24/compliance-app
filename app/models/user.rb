class User < ApplicationRecord
  include Role

  has_secure_password
  belongs_to :account
  has_many :sessions, dependent: :destroy
  has_many :magic_links, dependent: :destroy
  has_many :team_users, dependent: :destroy
  has_many :teams, through: :team_users

  scope :matching, ->(query) do
    return all if query.blank?

    ts_query = sanitize_sql_array([
      "websearch_to_tsquery('english', ?)",
      query
    ])

    from(<<~SQL)
      (
        SELECT users.*,
              ts_rank_cd(search_vector, #{ts_query}) AS rank
        FROM users
        WHERE search_vector @@ #{ts_query}
          OR name ILIKE #{connection.quote("%#{query}%")}
          OR email_address ILIKE #{connection.quote("%#{query}%")}
      ) users
    SQL
    .order(Arel.sql("rank DESC"))
  end

  validates :password, presence: true, on: :create
  validates :name, presence: true, unless: -> { owner? }
  normalizes :email_address, with: ->(email) { email.strip.downcase.presence }
  validates :role, uniqueness: { scope: :account_id }, if: -> { system? || owner? }
  validates :password, confirmation: true, complexity: true, history: true, allow_nil: true
  validates :email_address, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { scope: :account_id }

  def initials(limit: 2)
    return "" if name.blank?

    name
      .to_s
      .split
      .first(limit)
      .map { |part| part[0] }
      .join
      .upcase
  end

  def send_magic_link(**attributes)
    attributes[:purpose] = attributes.delete(:for) if attributes.key?(:for)

    magic_links.create!(attributes).tap do |magic_link|
      MagicLinkMailer.sign_up_instructions(magic_link).deliver_later
    end
  end
end
