class CleanupExpiredSessionsJob < ApplicationJob
  queue_as :low_priority

  def perform(days = 1)
    return unless Rails.env.production?

    expired_sessions = Session.timed_out(days)
    expired_sessions.destroy_all
  end
end
