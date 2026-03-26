# frozen_string_literal: true

# db/seeds.rb

# Clear existing data
puts "Cleaning database..."
Standup.destroy_all
TaskMembership.destroy_all
Task.destroy_all
TeamMembership.destroy_all
DaysOfWeekMembership.destroy_all
Team.destroy_all
User.destroy_all
Account.destroy_all

puts "=" * 60
puts "Creating accounts..."
puts "=" * 60

accounts = []
3.times do |i|
  account = Account.create!(
    name: Faker::Company.name,
    addr1: Faker::Address.street_address,
    addr2: [Faker::Address.secondary_address, nil].sample,
    city: Faker::Address.city,
    state: Faker::Address.state,
    zip: Faker::Address.zip_code,
    country: Faker::Address.country,
    settings: {
      industry: Faker::Company.industry,
      employee_count: rand(10..500),
      founded: rand(1990..2020)
    }
  )
  accounts << account
  puts "Created account: #{account.name}"
end

puts "\n" + "=" * 60
puts "Creating users with roles..."
puts "=" * 60

users = []
accounts.each_with_index do |account, idx|
  # Create admin for each account
  admin = User.create!(
    name: Faker::Name.name,
    email: "admin#{idx + 1}@#{Faker::Internet.domain_name(domain: account.name.downcase.gsub(' ', ''))}",
    password: "password123",
    password_confirmation: "password123",
    time_zone: Faker::Address.time_zone,
    account_id: account.id
  )
  admin.add_role(:admin, account)
  admin.add_role(:user, account)
  users << admin
  puts "Created admin: #{admin.email}"

  # Create regular users
  rand(3..6).times do |i|
    user = User.create!(
      name: Faker::Name.name,
      email: Faker::Internet.unique.email(domain: account.name.downcase.gsub(" ", "")),
      password: "password123",
      password_confirmation: "password123",
      time_zone: Faker::Address.time_zone,
      account_id: account.id
    )
    user.add_role(:user, account)
    users << user
  end
  puts "Created #{users.select { |u| u.account_id == account.id }.count - 1} regular users for #{account.name}"
end

puts "\nTotal users: #{User.count}"

puts "\n" + "=" * 60
puts "Creating teams..."
puts "=" * 60

teams = []
accounts.each do |account|
  account_users = users.select { |u| u.account_id == account.id }
  account_admin = account_users.find { |u| u.has_role?(:admin, account) }

  # Create 2-4 teams per account
  rand(2..4).times do |i|
    team_name = [
      "#{Faker::Team.name} #{Faker::Company.suffix}",
      "#{Faker::Company.profession} Team",
      "#{Faker::Job.field} Division",
      "#{Faker::Company.buzzword} Squad",
      "Team #{Faker::Name.last_name}"
    ].sample

    team = Team.create!(
      name: team_name,
      account_id: account.id,
      description: Faker::Company.catch_phrase + ". " + Faker::Lorem.sentence(word_count: 5),
      timezone: account_users.sample.time_zone,
      has_reminder: [true, false].sample,
      has_recap: [true, false].sample,
      reminder_time: ["09:00", "10:00", "09:30", "10:30"].sample,
      recap_time: ["16:00", "17:00", "16:30", "17:30"].sample
    )

    # Add team members (admin + random users)
    team_members = [account_admin] + account_users.sample(rand(2..account_users.count - 1))
    team_members.uniq.each do |user|
      TeamMembership.create!(team_id: team.id, user_id: user.id)
    end

    # Add days of week for reminders based on team preferences
    days = case rand(1..3)
           when 1
             ["monday", "tuesday", "wednesday", "thursday", "friday"]
           when 2
             ["monday", "wednesday", "friday"]
    else
             ["tuesday", "thursday"]
    end

    days.each do |day|
      DaysOfWeekMembership.create!(team_id: team.id, day: day)
    end

    teams << team
    puts "Created team: #{team.name} with #{team.users.count} members"
  end
end

puts "\nTotal teams: #{Team.count}"

puts "\n" + "=" * 60
puts "Creating standups and tasks..."
puts "=" * 60

# Track progress
total_standups = 0
total_tasks = 0

# Create standups for the last 60 days
users.each do |user|
  # Determine how many standups this user has (varies by user)
  standup_count = rand(10..25)

  # Generate random dates within the last 60 days
  dates = (0..60).to_a.sample(standup_count).sort.map { |days_ago| Date.today - days_ago.days }

  dates.each do |standup_date|
    # Skip weekends
    next if standup_date.saturday? || standup_date.sunday?

    standup = Standup.create!(
      user_id: user.id,
      standup_date: standup_date,
      created_at: standup_date,
      updated_at: standup_date
    )
    total_standups += 1

    # Determine task counts based on day of week
    # More tasks on Monday/Wednesday, fewer on Friday
    did_count = case standup_date.wday
                when 1 then rand(2..4) # Monday - more tasks
                when 5 then rand(1..2) # Friday - fewer tasks
    else rand(2..3) # Other weekdays
    end

    todo_count = case standup_date.wday
                 when 1 then rand(2..3)
                 when 5 then rand(1..2)
    else rand(1..3)
    end

    # Create Dids (accomplishments)
    did_count.times do
      task = Task.create!(
        type: "Did",
        title: [
          "Completed #{Faker::Company.bs} feature",
          "Fixed #{Faker::Company.catch_phrase} bug",
          "Reviewed #{rand(1..5)} pull requests",
          "Deployed #{Faker::App.name} to production",
          "Wrote documentation for #{Faker::Company.bs}",
          "Optimized #{Faker::ProgrammingLanguage.name} code performance",
          "Met with #{Faker::Name.name} about #{Faker::Company.bs}",
          "Refactored #{Faker::Company.bs} module"
        ].sample,
        is_completed: true,
        created_at: standup_date,
        updated_at: standup_date
      )
      TaskMembership.create!(task_id: task.id, standup_id: standup.id)
      total_tasks += 1
    end

    # Create Todos (planned work)
    todo_count.times do
      task = Task.create!(
        type: "Todo",
        title: [
          "Implement #{Faker::Company.bs} feature",
          "Write tests for #{Faker::Company.bs}",
          "Fix #{Faker::Company.catch_phrase} bug",
          "Update #{Faker::App.name} documentation",
          "Research #{Faker::Company.industry} best practices",
          "Code review for #{Faker::Name.first_name}'s PR",
          "Set up #{Faker::Company.bs} monitoring",
          "Optimize #{Faker::ProgrammingLanguage.name} queries"
        ].sample,
        is_completed: [true, false].sample,
        created_at: standup_date,
        updated_at: standup_date
      )
      TaskMembership.create!(task_id: task.id, standup_id: standup.id)
      total_tasks += 1
    end

    # Create Blockers (30% chance)
    if rand < 0.3
      task = Task.create!(
        type: "Blocker",
        title: [
          "Waiting for #{Faker::Name.name} to review code",
          "Dependency on #{Faker::Company.name} API",
          "Need design assets from #{Faker::Name.first_name}",
          "Environment issue with #{Faker::App.name}",
          "Blocked by #{Faker::Company.catch_phrase} requirement",
          "Awaiting approval from #{Faker::Name.last_name}",
          "Third-party service #{Faker::Company.bs} is down",
          "Legal review needed for #{Faker::Company.bs}"
        ].sample,
        is_completed: [true, false].sample,
        created_at: standup_date,
        updated_at: standup_date
      )
      TaskMembership.create!(task_id: task.id, standup_id: standup.id)
      total_tasks += 1
    end
  end
end

puts "\n" + "=" * 60
puts "Seeding Complete!"
puts "=" * 60
puts "\n📊 Summary:"
puts "  🏢 Accounts: #{Account.count}"
puts "  👥 Users: #{User.count}"
puts "  👑 Admins: #{User.joins(:roles).where(roles: { name: :admin }).count}"
puts "  👤 Regular Users: #{User.joins(:roles).where(roles: { name: :user }).count - User.joins(:roles).where(roles: { name: :admin }).count}"
puts "  👥 Teams: #{Team.count}"
puts "  📝 Standups: #{total_standups}"
puts "  ✅ Tasks: #{total_tasks}"
puts "  🔗 Task Memberships: #{TaskMembership.count}"

puts "\n🔐 Login Credentials:"
accounts.each do |account|
  admin = User.joins(:roles).where(account_id: account.id, roles: { name: :admin }).first
  if admin
    puts "  #{account.name}:"
    puts "    Admin: #{admin.email} / password123"
    regular_users_count = User.joins(:roles).where(account_id: account.id, roles: { name: :user }).count - 1
    puts "    Regular Users: #{regular_users_count} users"
  end
end

puts "\n" + "=" * 60
puts "Sample data verification:"
puts "=" * 60
first_team = Team.first
if first_team
  puts "  Team: #{first_team.name}"
  puts "  Members: #{first_team.users.map(&:name).join(', ')}"
  first_user = first_team.users.first
  if first_user
    recent_standups = first_user.standups.order(standup_date: :desc).limit(3).map(&:standup_date).join(", ")
    puts "  Recent standups: #{recent_standups}"
  end
end
