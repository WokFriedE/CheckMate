Feature: Organizer Inventory Management
  As an organizer
  I want to manage items in my inventory
  So that I can prepare and maintain event resources efficiently.

  Scenario: Organizer successfully adds a new item to inventory
    Given I am logged in as an Organizer
    And I am on the "Inventory Dashboard" page
    When I click "Add Item"
    And I fill in "Item Name" with "Projector"
    And I fill in "Quantity" with "5"
    And I click "Save"
    Then I should see a success message "Item added successfully"
    And the item "Projector" should appear in my inventory list

  Scenario: Organizer successfully edits an existing item
    Given I am logged in as an Organizer
    And an item named "Projector" exists in my inventory
    When I click "Edit" next to "Projector"
    And I update "Quantity" to "8"
    And I click "Save"
    Then I should see "Item updated successfully"
    And the item "Projector" should show quantity "8" in my list

  Scenario: Organizer filters items by category
    Given I am logged in as an Organizer
    And I am on the "Inventory Dashboard"
    When I select category "Electronics" from the filter dropdown
    Then I should see only items under "Electronics" displayed
    And items from other categories should not appear

  Scenario: Organizer views low-stock warning items
    Given I am logged in as an Organizer
    And I have items in my inventory with quantity less than 3
    When I open the "Dashboard" tab
    Then I should see a "Low Stock" warning section
    And each low-stock item should show a red alert icon
