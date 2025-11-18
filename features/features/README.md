Cucumber test suite (SMART + Organizer).
Drop the 'features' folder into your Rails project root.
Requires: cucumber-rails, capybara, factory_bot_rails, database_cleaner, rspec-rails.
Run individual features:
  bundle exec cucumber features/organizer_inventory.feature
Run all features:
  bundle exec cucumber
Adjust fixture CSV paths and factory definitions as needed.
