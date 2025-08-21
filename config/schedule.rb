# frozen_string_literal: true

# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever

set :output, "log/cron.log"
set :environment, ENV["RAILS_ENV"] || "development"

# Daily sync job at 2 AM UTC
every 1.day, at: "2:00 am" do
  runner "SyncAwesomeListsJob.perform_later"
end

# Optional: Run a more frequent check for high-priority lists
# every 6.hours do
#   runner "SyncAwesomeListsJob.perform_later(priority: :high)"
# end

# Cleanup old sync logs (keep last 30 days)
every :sunday, at: "3:00 am" do
  runner "SyncLog.where('created_at < ?', 30.days.ago).destroy_all"
end
