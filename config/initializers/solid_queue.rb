# frozen_string_literal: true

# Configure solid_queue for GitHub stats processing
Rails.application.configure do
  config.solid_queue.connects_to = {database: {reading: :primary, writing: :primary}}
end
