Feature: Multi-tasked Management of Inventory and Users
  To streamline inventory tracking and user coordination.

  Scenario: Verify item return within 20 seconds
    Given I POST to "/item/return"
    Then I should receive 200 OK "return processed" within 20 seconds

  Scenario: Verify filtering borrowed items by organization/event
    Given I send GET "/items/borrowed?filter_by=organization_id"
    Then I should receive 200 OK with correctly filtered items

  Scenario: Verify invite code creation for organization
    Given I POST to "/orgs/<org_id>/invite"
    Then I should receive 201 Created with valid code and expiration
