module NavigationHelper
  def active_link_to(name = nil, path = nil, sub_page, page, **options, &block)
    if block_given?
      path = name
      name = capture(&block)
    end

    classes = Array(options[:class])

    if page == true
      active = request.path == path
      classes << "active-link" if active
    end

    options[:class] = classes.compact.join(" ").strip

    link_to(name, path, options.merge(aria: { current: active ? "page" : nil }))
  end
end
