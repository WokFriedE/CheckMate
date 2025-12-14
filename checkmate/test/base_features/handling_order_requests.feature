Feature: Handling Order Requests
  Professors can approve or deny student requests and receive notifications.

  Scenario: Verify professors can approve/deny student requests
    Given I view pending student requests
    When I approve or deny a request
    Then the order status should update with 200 OK

  Scenario: Verify professors receive timely notifications
    Given a student submits a request
    When I check GET "/notifications"
    Then I should receive the notification within 5 minutes

  Scenario: Verify professors can assign higher limits to club leaders
    Given I update a user role via POST "/users" with role "club"
    Then I should receive 201 Created and the role should appear in user settings
