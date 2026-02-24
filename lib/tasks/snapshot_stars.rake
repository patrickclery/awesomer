# frozen_string_literal: true

namespace :awesomer do
  desc 'Snapshot current star counts for all repos via GraphQL'
  task snapshot_stars: :environment do
    puts "Fetching stars for #{Repo.count} repos..."
    start_time = Time.current

    operation = SnapshotStarsOperation.new
    result = operation.call

    elapsed = (Time.current - start_time).round(1)

    if result.success?
      puts result.value!
      puts "Completed in #{elapsed}s"
    else
      puts "ERROR: #{result.failure}"
      exit 1
    end
  end
end
