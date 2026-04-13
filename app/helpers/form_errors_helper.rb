module FormErrorsHelper
  def field_error(model, field)
    return unless model.errors[field].any?

    content_tag(:p, model.errors.full_messages_for(field).first, class: "text-red-500 text-sm mt-1")
  end
end
