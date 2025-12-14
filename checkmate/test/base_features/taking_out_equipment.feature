Feature: Taking Out Equipment
  To verify that checkout operations respect item availability.

  Scenario: Verify successful checkout of an available item
    Given I am logged in as a Student
    When I search and check out an available item
    Then the checkout should succeed and be recorded within 5 seconds

  Scenario: Verify checkout is rejected for request-only items
    Given an item is marked as request-only
    When I attempt to check it out
    Then I should receive a rejection message immediately
