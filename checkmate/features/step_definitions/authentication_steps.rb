# frozen_string_literal: true

# Step definitions for authentication features

When('I visit the login page') do
  visit login_path
end

When('I visit the signup page') do
  visit signup_path
end

When('I visit the root page') do
  visit root_path
end

When('I visit the landing page without logging in') do
  visit landing_path
end

Then('I should see {string}') do |text|
  # Check both content and buttons (submit values don't appear in has_content?)
  visible = page.has_content?(text) || page.has_button?(text)
  assert visible, "Expected to see '#{text}' on the page"
end

Then('I should see an email input field') do
  assert page.has_field?('email'), 'Expected to see an email input field'
end

Then('I should see a password input field') do
  assert page.has_field?('password'), 'Expected to see a password input field'
end

Then('I should see a {string} button') do |button_text|
  assert page.has_button?(button_text), "Expected to see a '#{button_text}' button"
end

Then('I should see a link to {string}') do |link_text|
  assert page.has_link?(link_text), "Expected to see a link with text '#{link_text}'"
end

Then('I should be redirected to the login page') do
  assert_equal login_path, current_path, 'Expected to be redirected to login page'
end

Then('I should not be redirected') do
  # Just verify the page loaded successfully
  assert_equal 200, page.status_code, 'Expected page to load successfully with status 200'
end
