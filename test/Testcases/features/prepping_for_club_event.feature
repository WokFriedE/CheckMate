Feature: Prepping for Club Event
  To support clubs in planning and reusing requests efficiently.

  Scenario: Verify multi-item request functionality
    Given I am logged in as a Club Leader
    When I submit an order with more than 2 items
    Then I should receive 201 Created with "order created" within 5 seconds

  Scenario: Verify assignment of borrowed items to members
    Given I include a member name in the comment field
    When I view the order log
    Then the comment should display "owned by student xyz"

  Scenario: Verify ability to duplicate past requests
    Given I access my order history
    When I recreate a past order
    Then I should receive 201 Created with "order recreated"

  Scenario: Verify availability calendar displays accurate data
    Given I send a GET request to "/order"
    Then I should see correct available and reserved flags within 3 seconds
