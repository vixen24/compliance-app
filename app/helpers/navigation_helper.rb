module NavigationHelper
  def active_link_to(name = nil, path = nil, sub_page = nil, page = true, **options, &block)
    if block_given?
      path = name
      name = capture(&block)
    end

    classes = Array(options[:class])

    if page
      active = request.path.start_with?(path)
      classes << "active-link__selected" if active
    end

    options[:class] = classes.compact.join(" ").strip

    link_to(name, path, options.merge(aria: { current: active ? "page" : nil }))
  end
end
