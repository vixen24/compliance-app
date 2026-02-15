class Feedback < ApplicationRecord
  belongs_to :answer
  belongs_to :user

  has_many :replies, class_name: "Feedback", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Feedback", optional: true

  delegate :assessment, to: :answer
  delegate :team, to: :answer

  scope :chronological, -> { order(created_at: :asc) }
  scope :by_assessors, -> { where(role: "assessor") }
  scope :by_users, -> { where(role: "user") }
end
