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

  validates :password, presence: true, on: :create
  validates :name, presence: true, unless: -> { owner? }
  normalizes :email_address, with: ->(email) { email.strip.downcase.presence }
  validates :role, uniqueness: { scope: :account_id }, if: -> { system? || owner? }
  validates :password, confirmation: true, complexity: true, history: true, allow_nil: true
  validates :email_address, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { scope: :account_id }

  def send_magic_link(**attributes)
    attributes[:purpose] = attributes.delete(:for) if attributes.key?(:for)

    magic_links.create!(attributes).tap do |magic_link|
      MagicLinkMailer.sign_up_instructions(magic_link).deliver_later
    end
  end
end
