class Current < ActiveSupport::CurrentAttributes
  attribute :session, :team, :account, :user
  attribute :http_method, :request_id, :user_agent, :ip_address, :referrer

  def session=(value)
    super
    self.user = value&.user
  end

  def with_account(value, &)
    with(account: value, &)
  end

  def without_account(&)
    with(account: nil, &)
  end
end

# Note
# session: nil   user: nil   → no request context
# session: yes   user: nil   → guest request
# session: yes   user: yes   → authenticated request
