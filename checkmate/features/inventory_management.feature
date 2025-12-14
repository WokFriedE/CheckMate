Feature: Inventory Management
  As an organizer
  I want to manage items in my inventory
  So that I can prepare and maintain event resources efficiently

  Background:
    Given I am logged in as an organizer with an organization

  Scenario: Organizer can view the inventory page
    When I visit the inventory page
    Then I should see "Create Item"
    And I should see "Create Order"

  Scenario: Organizer can navigate to add item page
    When I visit the inventory page
    And I click on "Create Item"
    Then I should see "Item Details"
    And I should see "Item Name"
    And I should see "Stock"

  Scenario: Organizer can add a new item to inventory
    When I visit the new item page
    And I fill in "inventory_item_detail_item_name" with "Projector"
    And I fill in "inventory_item_count" with "5"
    And I select "self-checkout" from "inventory_request_mode"
    And I fill in "inventory_item_setting_reg_max_check" with "2"
    And I fill in "inventory_item_setting_reg_max_total_quantity" with "5"
    And I click on "Add Item"
    Then I should be on the inventory page
    And I should see "Projector"

  Scenario: Organizer can view existing items in inventory
    Given an item named "Test Camera" exists in the inventory
    When I visit the inventory page
    Then I should see "Test Camera"
