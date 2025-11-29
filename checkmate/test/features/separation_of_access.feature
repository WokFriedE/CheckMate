Feature: Separation of Access
  To maintain proper authorization boundaries.

  Scenario: Verify a student cannot access Admin/Settings endpoint
    Given I am logged in as a Student
    When I attempt to access "/admin/settings"
    Then I should receive 403 Forbidden

  Scenario: Verify an Admin can successfully update a user's role
    Given I am logged in as an Admin
    When I navigate to User Management and update a user's role
    Then the user's role should update successfully and appear in the list
