class Assessment::Batch
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :team_ids, default: []
  attribute :framework_ids, default: []

  validates :name, presence: true, length: { maximum: 72 }
  validates :team_ids, presence: { message: "must select at least one team" }
  validates :framework_ids, presence: { message: "must select at least one framework" }

  def save(user)
    return false unless valid?
    Assessment.batch_create!(name, team_ids, framework_ids, user)
  end
end
