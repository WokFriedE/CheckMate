Feature: Access Control
  As the system
  I want to enforce role-based access control
  So that users can only access features appropriate to their role

  Scenario: Unauthenticated user can access the landing page
    When I visit the landing page without logging in
    Then I should see "CheckMate"
    And I should not be redirected

  Scenario: Unauthenticated user can access the login page
    When I visit the login page
    Then I should see "Login"
    And I should not be redirected

  Scenario: Unauthenticated user can access the signup page
    When I visit the signup page
    Then I should see "Sign up"
    And I should not be redirected
