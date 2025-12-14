# frozen_string_literal: true

# Step definitions for inventory management features

Given('I am logged in as an organizer with an organization') do
  @current_test_org = create_test_organization(name: 'Test Org', location: 'Test Location')
  @current_test_user = create_test_user(email: 'organizer@test.com', name: 'Test Organizer')
  assign_role(user_datum: @current_test_user, organization: @current_test_org, role: 'organizer')
  login_as_test_user(@current_test_user, role: 'organizer', org: @current_test_org)
end

When('I visit the inventory page') do
  visit organization_item_details_path(@current_test_org.org_id)
end

When('I visit the new item page') do
  visit new_organization_item_detail_path(@current_test_org.org_id)
end

When('I click on {string}') do |link_or_button|
  click_on link_or_button
end

When('I fill in {string} with {string}') do |field, value|
  fill_in field, with: value
end

When('I select {string} from {string}') do |option, field|
  select option, from: field
end

Then('I should be on the inventory page') do
  assert_equal organization_item_details_path(@current_test_org.org_id), current_path,
               'Expected to be on the inventory page'
end

Given('an item named {string} exists in the inventory') do |item_name|
  create_test_item(organization: @current_test_org, name: item_name)
end
