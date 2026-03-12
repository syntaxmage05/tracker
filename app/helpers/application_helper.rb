# frozen_string_literal: true

module ApplicationHelper
  def tailwind_color_class_for(flash_type)
    {
      success: "green",
      error: "red",
      alert: "orange",
      notice: "yellow"
    }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(_opts = {})
    flash.each do |msg_type, message|
      next if msg_type == :form_error

      color = tailwind_color_class_for(msg_type)

      concat(
        content_tag(
          :div, class: [
          "alert",
          "transition-all",
          "duration-1000",
          "ease-in-out",
          "p-4",
          "m-4",
          "mt-5",
          "w-3/5",
          "bg-#{color}-100",
          "border",
          "border-#{color}-400",
          "text-#{color}-700",
          "rounded-lg"
        ].join(" "), role: msg_type) do
          concat(
            content_tag(:span, message, class: "block sm:inline") # safe, no html_safe
          )
        end
      )
    end
    nil
  end
end
