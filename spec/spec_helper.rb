# frozen_string_literal: true

require "simplecov"
SimpleCov.start "rails"

RSpec.configure do |config|
  # System tests
  config.before(:each, type: :system) { driven_by :rack_test }
  config.before(:each, type: :system, js: true) { driven_by :selenium_chrome_headless }

  # Expectation settings
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # Mock settings
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = false
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  # Optional: recommended for focus, ordering, and verbosity
  # config.filter_run_when_matching :focus
  # config.example_status_persistence_file_path = "spec/examples.txt"
  # config.disable_monkey_patching!
  # config.order = :random
  # Kernel.srand config.seed
end
