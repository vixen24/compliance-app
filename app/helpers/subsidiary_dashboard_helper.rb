module SubsidiaryDashboardHelper
  def executive_insight(compliance_percentage)
    case true
    when compliance_percentage <= 30
      "Overall control environment is unreliable at this point in time"
    when compliance_percentage > 30 && @compliance_percentage <= 49
      "Overall control environment is weak"
    when compliance_percentage > 49 && @compliance_percentage <= 69
      "Overall control environment is acceptable but constrained by gaps"
    when compliance_percentage >= 70
      "Overall control environment is healthy"
    end
  end
end
