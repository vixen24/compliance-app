module ApplicationHelper
  EXCLUDED_FLASH_PAGES = [
    { controller: "magic_links", action: "show" }
  ].freeze

  def show_flash?
    EXCLUDED_FLASH_PAGES.none? do |page|
      page[:controller] == controller_name && page[:action] == action_name
    end
  end

  def page_title(separator = " - ")
    app_name = Rails.configuration.x.app_name
    content = content_for(:title)
    content.present? ? "#{content}#{separator}#{app_name}" : app_name
  end

  def svg_tag(filename, options = {})
    asset = Rails.application.assets.load_path.find(filename)
    return unless asset && File.exist?(asset.path)

    file = asset.path

    @svg_cache ||= {}
    @svg_cache[file] ||= File.read(file)

    doc = Nokogiri::HTML::DocumentFragment.parse(@svg_cache[file])
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
