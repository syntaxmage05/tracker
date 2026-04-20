# Tracker

Tracker is a Ruby on Rails application for running team standups with clear visibility into daily progress, upcoming work, and blockers.

## Overview

Tracker helps teams stay aligned by combining:

- **Daily standup logging** with structured entries (`Did`, `Todo`, and `Blocker`).
- **Team-level views** to review member updates by day.
- **Account + role-based access** for multi-user organizations.
- **Automated reminders and recaps** using Sidekiq + Sidekiq Cron jobs.

The app is built on Rails 8 with PostgreSQL, Hotwire, and Sidekiq.

## Features

- Authentication and invitation flow with Devise / Devise Invitable.
- Account and team management.
- Standup creation/editing with nested task items.
- Activity feed focused on the current user’s standup history.
- Background job scheduling for reminder and recap workflows.

## Tech Stack

- **Backend:** Ruby on Rails 8
- **Database:** PostgreSQL
- **Frontend:** Hotwire (Turbo + Stimulus), Tailwind CSS
- **Background Jobs:** Sidekiq + Sidekiq Cron
- **Testing:** RSpec, Factory Bot, Capybara

## Prerequisites

Before running Tracker locally, install:

- Ruby (version compatible with the project’s Gemfile)
- Bundler
- PostgreSQL
- Redis (required for Sidekiq)

## Local Setup

1. **Clone the repository**

   ```bash
   git clone https://github.com/syntaxmage05/tracker.git
   cd tracker
   ```

2. **Install dependencies**

   ```bash
   bundle install
   ```

3. **Prepare the database**

   ```bash
   bin/rails db:prepare
   ```

4. **Run the development environment**

   ```bash
   bin/dev
   ```

`bin/dev` starts:

- Rails web server
- Tailwind watcher
- Sidekiq worker (via `Procfile.dev`)

## Useful Commands

```bash
# Run the test suite
bundle exec rspec

# Run static analysis
bin/brakeman
bin/rubocop

# Open Sidekiq dashboard (when app is running)
# http://localhost:3000/sidekiq
```

## Background Jobs

Tracker schedules recurring jobs every 15 minutes for:

- Team reminder discovery (`Reminders::FindTeamsJob`)
- Team recap discovery (`Recaps::FindTeamsJob`)

These schedules are configured through Sidekiq Cron during Sidekiq server startup.

## Core Routes

- `/` → personal activity view
- `/t` → teams
- `/s` → standups
- `/sidekiq` → Sidekiq Web UI

## Project Structure

```text
app/
  controllers/   # HTTP endpoints and request flow
  models/        # Domain models (standups, tasks, teams, accounts, users)
  services/      # Service objects for business workflows
  views/         # ERB views and UI templates
config/
  routes.rb      # Route definitions
  initializers/  # Framework and integration setup (Sidekiq, Devise, etc.)
spec/            # RSpec test suite
```

## Deployment

The repository includes Docker and Kamal configuration files for containerized deployment workflows.

## Contributing

1. Create a feature branch.
2. Make and test your changes.
3. Open a pull request with a clear summary and validation steps.

---
