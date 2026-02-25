module AnswersHelper
  def answer_state_classes(answer)
    state = answer&.state || "draft"

    class_names(
      "badge rounded-xl px-1.5 text-xs font-semibold",
      {
        "badge-info"    => state == "draft",
        "badge-warning" => state == "submitted",
        "badge-error"   => state == "rejected",
        "badge-success" => state == "approved"
      }
    )
  end

  def answer_status_classes(status)
    # Exclude "badge-info" => status == "NA"
    class_names(
      "badge rounded-xl px-1.5 text-xs font-semibold",
      {
        "badge-info" => status == "not assessed",
        "badge-warning" => status == "opportunity for improvement",
        "badge-error"   => status == "not compliant",
        "badge-success" => status == "compliant"
      }
    )
  end
end
