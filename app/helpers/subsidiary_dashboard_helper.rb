module SubsidiaryDashboardHelper
  def subsidiary_insight(compliance_percentage)
     if compliance_percentage.nil? || compliance_percentage.zero?
       return "Compliance data is unavailable"
     end

    case
    when compliance_percentage <= 30
      "Overall control environment is unreliable at this point in time"

    when compliance_percentage <= 49
      "Overall control environment is weak"

    when compliance_percentage <= 69
      "Overall control environment is acceptable but constrained by gaps"

    else
      "Overall control environment is healthy"
    end
  end

  def subsidiary_dashboard_cards(metrics)
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
