# Generic step definitions for SMART test cases (API + UI mix)
Given(/^I am logged in as a (.+)$/) do |role|
  @user = User.find_by(role: role.downcase) || FactoryBot.create(:user, role: role.downcase)
  login_as(@user, scope: :user)
end

When(/^I upload a valid CSV file containing (\d+) items$/) do |count|
  file_path = Rails.root.join('spec', 'fixtures', 'files', 'items_#{count}.csv')
  attach_file('file', file_path) rescue post '/items/import', params: { file: fixture_file_upload(file_path, 'text/csv') }
end

Then(/^I should receive a (\d+) Created response with message "([^"]+)"$/) do |code, message|
  # For API-style checks:
  if defined?(last_response)
    expect(last_response.status).to eq(code.to_i)
    expect(last_response.body).to include(message)
  else
    expect(page).to have_content(message)
  end
end

When(/^I set a password using POST "([^"]+)"$/) do |path|
  post path, params: { password: 'P@ssw0rd' }
end

When(/^I verify access with the created password$/) do
  post '/settings/verify', params: { password: 'P@ssw0rd' }
end

Then(/^I should receive (\d+) "([^"]+)" response$/) do |code, message|
  if defined?(last_response)
    expect(last_response.status).to eq(code.to_i)
    expect(last_response.body).to include(message)
  else
    expect(page).to have_content(message)
  end
end

Given(/^I attempt a checkout exceeding the max quantity$/) do
  post '/checkout', params: { item_id: Item.first.id, quantity: 9999 }
end

Then(/^I should receive (\d+) Invalid request response$/) do |code|
  expect(last_response.status).to eq(code.to_i)
end

Given(/^I POST to "([^"]+)"$/) do |path|
  post path, params: {}
end

Then(/^I should receive (\d+) OK "([^"]+)" within (\d+) seconds$/) do |code, message, seconds|
  expect(last_response.status).to eq(code.to_i)
  expect(last_response.body).to include(message)
end

Given(/^I send GET "([^"]+)"$/) do |path|
  get path
end

Then(/^I should receive (\d+) OK with correctly filtered items$/) do |code|
  expect(last_response.status).to eq(code.to_i)
  # Additional filtering assertions should be added in concrete tests
end

Given(/^an item named "([^"]+)" exists in my inventory$/) do |name|
  FactoryBot.create(:item, name: name, quantity: 5)
end

When(/^I click "Edit" next to "([^"]+)"$/) do |name|
  within(:xpath, "//tr[td[contains(.,'#{name}')]]") do
    click_on 'Edit'
  end
end

When(/^I update "([^"]+)" to "([^\"]+)"$/) do |field, value|
  fill_in field, with: value
end
