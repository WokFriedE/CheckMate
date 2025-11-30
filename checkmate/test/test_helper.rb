ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors, with: :threads)

    # Use transactional fixtures - set to false if using fixtures with PostgreSQL
    # without superuser privileges (avoids referential integrity issues)
    self.use_transactional_tests = true

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    # Disabled by default due to PostgreSQL permission issues with referential integrity
    # fixtures :all unless ENV['SKIP_FIXTURES']

    # Add more helper methods to be used by all tests here...
  end
end
