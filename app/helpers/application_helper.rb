module ApplicationHelper
  def page_title(separator = " - ")
    app_name = Rails.configuration.x.app_name
    content = content_for(:title)
    content.present? ? "#{content}#{separator}#{app_name}" : app_name
  end

  def svg_tag(filename, options = {})
    asset = Rails.application.assets.load_path.find(filename)
    return unless asset && File.exist?(asset.path)

    file = File.read(asset.path)
    doc = Nokogiri::HTML::DocumentFragment.parse(file)
    svg = doc.at_css("svg")

    if options[:class].present?
      svg["class"] = options[:class]
    end

    svg.to_html.html_safe
  end

  def nested_dom_id(*records)
    suffix = records.last.is_a?(Integer) || records.last.is_a?(String) ? "_#{records.pop}" : ""
    records.map { |r| dom_id(r) }.join("_") + suffix
  end
end
