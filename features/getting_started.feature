Feature: Getting Started
  To ensure smooth setup and initial use,
  Professors should be able to import items, secure access, and view lists.

  Scenario: Verify importing 40 items from CSV works correctly
    Given I am logged in as a Professor
    When I upload a valid CSV file containing 40 items
    Then I should receive a 201 Created response with message "complete"
    And all 40 items should appear in the inventory list within 1 minute

  Scenario: Validate password protection setup for item requests
    Given I have set a password using POST "/settings/password"
    When I verify access with the created password
    Then I should receive a 200 "access: True" response
    And using an incorrect password should return 401 Unauthorized

  Scenario: Confirm item list displays with sort, filter, and search
    Given I access GET "/items"
    When I apply sort, filter, and search options
    Then I should receive 200 OK with accurate and filtered data
