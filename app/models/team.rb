class Team < ApplicationRecord
  belongs_to :account

  has_many :assessments, dependent: :destroy
  has_many :team_users, dependent: :destroy
  has_many :users, through: :team_users

  scope :for_select, -> { order(:name).pluck(:name, :id) }
  scope :for_team, ->(team) { joins(assessment: :team).where(teams: { id: team.id }) }

  before_validation :normalize_name
  validates :name, presence: true, uniqueness: { scope: :account_id, case_sensitive: false }

  def self.most_compliant_for_account(account_id)
    compliant_count_sql = "SUM(CASE WHEN answers.status = 'C' THEN 1 ELSE 0 END)"

    base = Team .where(account_id: account_id).left_joins(assessments: :answers).group("teams.id")
    max_count = base.pluck(Arel.sql(compliant_count_sql)).max

    base.having("#{compliant_count_sql} = ?", max_count).pluck(:name)
  end

  def self.least_compliant_for_account(account_id)
    compliant_count_sql = "SUM(CASE WHEN answers.status = 'C' THEN 1 ELSE 0 END)"

    base = Team.where(account_id: account_id).left_joins(assessments: :answers).group("teams.id")
    min_count = base.pluck(Arel.sql(compliant_count_sql)).min

    base.having("#{compliant_count_sql} = ?", min_count).pluck(:name)
  end

  private

# Capitalize first letter for consistent sorting
def normalize_name
  return if name.blank?
  self.name = name.strip.sub(/\A\w/) { |c| c.upcase }
end
end
