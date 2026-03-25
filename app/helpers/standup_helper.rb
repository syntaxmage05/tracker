# frozen_string_literal: true

module StandupHelper
  def standup_header(standup, caller)
    caller ||= [controller_path, action_name].join("_")
    case caller
    when "activity_mine", "users/standups_index"
      standup.standup_date
    when "teams/standups_index", "teams_show"
      link_to standup.user.name, standups_account_user_path(standup.user), data: { turbo_frame: "_top" }
    else
      "..."
    end
  end
end
