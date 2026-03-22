# frozen_string_literal: true

# config/initializers/sidekiq-cron.rb
require "sidekiq-cron"
Sidekiq.strict_args!(false)

# Configure Sidekiq-Cron
Sidekiq::Cron.configure do |config|
  config.cron_poll_interval = 10 # Check every 10 seconds (default is 30)
  # This will help catch the exact 15-minute marks
end

# Define your jobs
jobs_hash = {
  "reminder" => {
    "class" => "Reminders::FindTeamsJob",
    "cron" => "0,15,30,45 * * * *",
    "active_job" => true
  },
  "recap" => {
    "class" => "Recaps::FindTeamsJob",
    "cron" => "0,15,30,45 * * * *",
    "active_job" => true
  }
}

# Only load when Sidekiq server is running
if Sidekiq.server?
  Rails.application.config.after_initialize do
    Sidekiq::Cron::Job.load_from_hash!(jobs_hash)
    puts "✅ Loaded cron jobs: #{Sidekiq::Cron::Job.all.map(&:name)}"
  end
end
