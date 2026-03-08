# frozen_string_literal: true

module ApplicationHelper
  FLASH_COLORS = {
    success: "green",
    error: "red",
    alert: "orange",
    notice: "yellow"
  }.freeze

  def flash_messages
    flash.each do |type, message|
      next if type == :form_error

      color = FLASH_COLORS[type.to_sym] || type.to_s

      concat(
        content_tag(:div, class: flash_css_classes(color), role: type) do
          content_tag(:span, message.html_safe, class: "block sm:inline")
        end
      )
    end

    nil
  end

  private

    def flash_css_classes(color)
      "alert transition-all duration-1000 ease-in-out p-4 m-4 mt-5 w-3/5 " \
      "bg-#{color}-100 border border-#{color}-400 text-#{color}-700 rounded-lg"
    end
end
