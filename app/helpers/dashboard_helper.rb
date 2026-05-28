module DashboardHelper
  def dashboard_cards(metrics)
    [
      {
        title: "CONTROLS",
        value: metrics.total[:control_by_framework],
        description: "Total number of controls for framework",
        icon: "pull-request"
      },

      {
        title: "NOT APPLICABLE",
        value: metrics.answer_status_count&.fetch("NA", 0),
        description: "Out-of-scope controls",
        icon: "not-applicable"
      },

      {
        title: "LONGEST AWAITING APPROVAL",
        value: days_ago(metrics.oldest_submitted_answer),
        description: "Oldest submission awaiting approval",
        icon: "clock"
      },

      {
        title: "LATEST SUBMISSION",
        value: days_ago(metrics.earliest_submitted_answer),
        description: "Most recent submission",
        icon: "send"
      }
    ]
  end

  private

  def days_ago(date)
    days = (Time.current.to_date - (date&.to_date || Time.current.to_date)).to_i
    pluralize(days, "day")
  end
end
