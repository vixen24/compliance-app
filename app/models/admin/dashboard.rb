class Admin::Dashboard
  attr_reader :account

  def initialize(account)
    @account = account
  end

  def call
    @call ||= {
      users: users_count,
      teams: teams_count,
      users_without_team: users_without_team_count,
      active_sessions: active_sessions_count,
      storage: storage_metrics
    }
  end

  private

  def users_count
    account.users.count
  end

  def teams_count
    account.teams.count
  end

  def users_without_team_count
    account.users.where.missing(:team_users).count
  end

  def active_sessions_count
    account.sessions.count
  end

  def storage_metrics
    {
      used: System::Storage.used_bytes,
      total: System::Storage.total_bytes,
      percent: System::Storage.percent_used
    }
  end
end
