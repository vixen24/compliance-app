module SubsidiaryDashboardHelper
  def subsidiary_insight(compliance_percentage)
    return "Compliance data is unavailable" if compliance_percentage.nil? || compliance_percentage.zero?

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
end
