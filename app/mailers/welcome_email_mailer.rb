# frozen_string_literal: true

class WelcomeEmailMailer < ApplicationMailer
  default from: "welcome@standup-app.com"

  def welcome_email(user)
    @user = user
    attachments["standup.jpeg"] = File.read("app/assets/images/standup.jpeg")
    make_bootstrap_mail(to: @user.email, subject: "Welcome to Tracker App, #{user.email}!!")
  end
end
