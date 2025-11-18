Given("I am logged in as an Organizer") do
  @user = FactoryBot.create(:user, role: "organizer")
  login_as(@user, scope: :user)
end

Given("I am on the {string} page") do |page_name|
  visit path_for(page_name)
end

When("I click {string}") do |button|
  click_on button
end

When("I fill in {string} with {string}") do |field, value|
  fill_in field, with: value
end

Then("I should see a success message {string}") do |message|
  expect(page).to have_content(message)
end

Then("the item {string} should appear in my inventory list") do |item_name|
  expect(page).to have_content(item_name)
end

Then("the item {string} should show quantity {string} in my list") do |item_name, quantity|
  within(:xpath, "//tr[td[contains(.,'#{item_name}')]]") do
    expect(page).to have_content(quantity)
  end
end

When("I select category {string} from the filter dropdown") do |category|
  select category, from: "Category"
  click_on "Filter"
end

Then("I should see only items under {string} displayed") do |category|
  all('.item-row').each do |row|
    expect(row).to have_content(category)
  end
end

Then("I should see a {string} warning section") do |warning|
  expect(page).to have_content(warning)
end

Then("each low-stock item should show a red alert icon") do
  all('.low-stock .alert-icon').each do |icon|
    expect(icon[:class]).to include('red')
  end
end
