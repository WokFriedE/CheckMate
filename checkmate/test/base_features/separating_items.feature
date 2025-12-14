Feature: Separating Items in an Inventory
  To control borrowing permissions and enforce stock limits.

  Scenario: Verify ability to mark items as request-only
    Given I open an item settings page
    When I set "can_be_prebooked" to false
    Then I should receive a 201 Created response
    And the item should be flagged as request-only

  Scenario: Verify max quantity per student enforced
    Given I attempt a checkout exceeding the max quantity
    Then I should receive 400 Invalid request response

  Scenario: Verify booking timeframe enforcement
    Given I attempt a prebooking outside the allowed timeframe
    Then I should receive 400 Invalid timeframe response within 3 seconds
