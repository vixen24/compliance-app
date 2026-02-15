module AnswersHelper
  def classes_for_answer_state(answer)
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
end
