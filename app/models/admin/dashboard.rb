class Admin::Dashboard
  attr_reader :account

  def initialize(account)
    @account = account
  end

  def call
    Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
      {
        active_users: active_users_count,
        inactive_users: inactive_users_count,
        teams: teams_count,
        active_sessions: active_sessions_count,
        storage: storage_metrics,
        open_assessment: open_assessment,
        closed_assessment: closed_assessment,
        mfa_status: mfa_status,
        password_complexity: password_complexity,
        session_timeout: session_timeout
      }
    end
  end

  private

  def active_users_count
    account.users.non_system.active.count
  end

  def inactive_users_count
    account.users.non_system.inactive.count
  end

  def open_assessment
    account.assessments.where(status: :open).count
  end

  def closed_assessment
    account.assessments.where(status: :closed).count
  end

  def teams_count
    @teams_count ||= account.teams.count
  end

  def active_sessions_count
    @active_sessions_count ||= account.sessions.count
  end

  def mfa_status
    account.mfa_enabled? ? "Enabled" : "Disabled"
  end

  def password_complexity
    account.password_complexity? ? "Enabled" : "Disabled"
  end

  def session_timeout
    Session.session_timeout_map.key(account.session_timeout)
  end

  def storage_metrics
    @storage_metrics ||= begin
      available_bytes  = System::Storage.available_bytes
      total_bytes = System::Storage.total_bytes
      used_bytes = (total_bytes - available_bytes).to_f

      {
        used: used_bytes,
        total: total_bytes,
        percent: ((used_bytes / total_bytes) * 100).round(2)
      }
    end
  end

  def cache_key
    [
      "admin_dashboard",
      account.id,
      account.updated_at.to_i
    ].join("/")
  end
end
