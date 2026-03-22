# frozen_string_literal: true

class EmailRecapMailer < ApplicationMailer
  def recap_email(user, team, standups)
    @user = user
    @team = team
    @standups = standups

    make_bootstrap_mail(
      to: @user.email,
      subject: "#{team.name} Standups Recap!"
    )
  end
end
