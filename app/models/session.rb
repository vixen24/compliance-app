class Session < ApplicationRecord
  belongs_to :user

  scope :timed_out, ->(days = 1) do
    where("created_at <= ?", Time.current - days.days)
  end

  scope :matching, ->(query) do
    return joins(:user) if query.blank?

    ts_query = sanitize_sql_array([ "websearch_to_tsquery('english', ?)", query ])

    joins(:user)
      .select("sessions.*, ts_rank_cd(users.search_vector, #{ts_query}) AS search_rank")
      .where("users.search_vector @@ #{ts_query}")
      .order("search_rank DESC")
  end

  def self.options_for_session_timeout
    [
      [ "None", nil ],
      [ "1 minute", 60 ],
      [ "30 minutes", 1800 ],
      [ "1 hour", 3600 ],
      [ "24 hours", 86400 ]
    ]
  end

  def self.session_timeout_map
    options_for_session_timeout.to_h
  end

  private
end
