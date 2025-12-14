Feature: User Authentication
  As a user
  I want to be able to access the login and signup pages
  So that I can authenticate with the application

  Scenario: User can view the login page
    When I visit the login page
    Then I should see "Login"
    And I should see an email input field
    And I should see a password input field
    And I should see a "Log in" button

  Scenario: User can view the signup page
    When I visit the signup page
    Then I should see "Sign up"
    And I should see an email input field
    And I should see a password input field
    And I should see a "Create account" button

  Scenario: Login page has link to signup
    When I visit the login page
    Then I should see a link to "Sign up"

  Scenario: Signup page has link to login
    When I visit the signup page
    Then I should see a link to "Log in"

  Scenario: Root page redirects unauthenticated users appropriately
    When I visit the root page
    Then I should see "CheckMate"
