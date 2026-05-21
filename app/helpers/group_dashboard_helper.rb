module GroupDashboardHelper
  def executive_insight(metrics)
    content_tag :ul, class: "space-y-2" do
      concat(content_tag(:li, class: "flex items-start gap-3") do
        concat content_tag(:span, "▲", class: "text-success font-bold mt-0.5 self-center")
        concat content_tag(:div, class: "inline-flex gap-1") {
          content_tag(:p, "Highest compliance rating:", class: "text-base") +
          content_tag(:p, metrics.compliant_extreme.most.to_sentence, class: "text-base font-medium")
        }
      end)

      concat(content_tag(:li, class: "flex items-start gap-3") do
        concat content_tag(:span, "▼", class: "text-error font-bold mt-0.5 self-center")
        concat content_tag(:div, class: "inline-flex gap-2") {
          content_tag(:p, "Lowest compliance rating:", class: "text-base") +
          content_tag(:p, metrics.compliant_extreme.least.to_sentence, class: "text-base font-medium")
        }
      end)
    end
  end
end
