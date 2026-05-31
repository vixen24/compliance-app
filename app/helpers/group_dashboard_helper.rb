module GroupDashboardHelper
  def executive_insight(metrics)
    return unless metrics.present?

    content_tag :ul, class: "space-y-2" do
      concat(content_tag(:li, class: "flex items-start gap-3") do
        concat content_tag(:span, "▲", class: "text-success font-bold mt-0.5 self-center")
        concat content_tag(:div, class: "inline-flex gap-2") {
          content_tag(:p, "Highest compliance rating:", class: "text-base") +
          content_tag(:p, metrics.compliant_extreme.most.to_sentence, class: "text-base font-medium truncate word-wrap")
        }
      end)

      concat(content_tag(:li, class: "flex items-start gap-3") do
        concat content_tag(:span, "▼", class: "text-error font-bold mt-0.5 self-center")
        concat content_tag(:div, class: "inline-flex gap-2") {
          content_tag(:p, "Lowest compliance rating:", class: "text-base") +
          content_tag(:p, metrics.compliant_extreme.least.to_sentence, class: "text-base font-medium truncate word-wrap")
        }
      end)
    end
  end

  def group_dashboard_cards(metrics)
    [
      {
        title: "GROUP COMPLIANCE",
        value: number_to_percentage(metrics.group_compliance, precision: 0),
        description: "Overall compliance across the group",
        icon: "pull-request"
      },

      {
        title: "ASSESSMENT COVERAGE",
        value: number_to_percentage(metrics.assessment_coverage, precision: 0),
        description: "Controls reviewed vs total controls",
        icon: "gauge"
      },

      {
        title: "NUMBER OF SUBSIDIARIES",
        value: metrics.assessment_batch&.assessments&.count || 0,
        description: "Subsidiaries in view",
        icon: "landmark"
      },

      {
        title: "MOST COMPLIANT SUBSIDIARIES",
        value: metrics.c_values&.count { |v| v > 70 },
        description: "Subsidiaries with 70% and above",
        icon: "shield-check"
      }
    ]
  end
end
