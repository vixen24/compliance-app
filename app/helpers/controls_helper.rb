module ControlsHelper
  def render_full_framework_code_badges(assessment, control, preloaded_fcs = nil)
    # Use preloaded data if available (no query), otherwise fallback
    framework_controls = if preloaded_fcs && preloaded_fcs.key?(control.control_id)
      preloaded_fcs[control.control_id]
    else
      FrameworkControl
        .where(framework_id: assessment.framework_ids, control_id: control.control_id)
        .includes(:framework)
        .to_a
    end

    return "" if framework_controls.blank?

    framework_controls.map do |fc|
      tag.span("#{fc.framework.code} #{fc.code}", class: "text-sm text-base-content/80 font-semibold bg-base-300 px-2 py-1 rounded")
    end.join(" ").html_safe
  end

  def render_framework_code_badges(assessment)
    assessment.frameworks.map do |framework|
      tag.span("#{framework.code}", class: "text-sm text-base-content/80 font-semibold bg-base-300 px-2 py-1 rounded")
    end.join(" ").html_safe
  end
end
