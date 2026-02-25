module ControlsHelper
  def render_full_framework_code_badges(assessment, control)
    FrameworkControl.for_display(assessment: assessment, control: control).map do |fc|
      tag.span(fc.full_framework_code, class: "text-xs text-gray-600 font-semibold bg-base-300 px-2 py-1 rounded")
    end.join(" ").html_safe
  end

  def render_framework_code_badges(assessment)
    assessment.frameworks.map do |framework|
      tag.span("#{framework.code}", class: "text-xs text-gray-600 font-semibold bg-base-300 px-2 py-1 rounded")
    end.join(" ").html_safe
  end
end
