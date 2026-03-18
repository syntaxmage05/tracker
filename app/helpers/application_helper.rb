# frozen_string_literal: true

module ApplicationHelper
  def flash_class_for(type)
    {
      success: "bg-green-100 border-green-400 text-green-700",
      error: "bg-red-100 border-red-400 text-red-700",
      alert: "bg-orange-100 border-orange-400 text-orange-700",
      notice: "bg-yellow-100 border-yellow-400 text-yellow-700"
    }[type.to_sym] || "bg-gray-100 border-gray-400 text-gray-700"
  end

  def flash_messages(_opts = {})
    flash.each do |msg_type, message|
      next if msg_type == :form_error

      classes = flash_class_for(msg_type)

      concat(
        content_tag(
          :div,
          class: [
            "alert",
            "transition-all",
            "duration-1000",
            "ease-in-out",
            "p-4",
            "m-4",
            "mt-5",
            "w-3/5",
            classes,
            "border",
            "rounded-lg"
          ].join(" "),
          role: msg_type
        ) do
          concat(
            content_tag(:span, message, class: "block sm:inline")
          )
        end
      )
    end
    nil
  end

  # Add method for user avatars
  def user_avatar_url(email, size = 45)
    if email.blank?
      return "https://ui-avatars.com/api/?name=User&size=#{size}"
    end

    email = email.downcase
    hash = Digest::MD5.hexdigest(email)
    "https://www.gravatar.com/avatar/#{hash}?s=#{size}&d=mp"
  end
end
