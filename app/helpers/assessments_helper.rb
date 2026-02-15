module AssessmentsHelper
  def default_state_for(role)
    case role
    when "member"
      "draft"
    when "assesor"
      "submitted"
    else
      ""
    end
  end
end
