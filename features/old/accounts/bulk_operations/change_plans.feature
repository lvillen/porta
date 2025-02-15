@javascript
Feature: Bulk operations
  In order to transfer applications from one plan to another
  As a provider
  I want to change applications' plans in bulk

  Background:
    Given a provider "foo.3scale.localhost"
      And provider "foo.3scale.localhost" has multiple applications enabled
      And provider "foo.3scale.localhost" has "account_plans" switch allowed

    Given a default account plan "Bronze" of provider "foo.3scale.localhost"
      And an account plan "Gold" of provider "foo.3scale.localhost"

    Given these buyers signed up to provider "foo.3scale.localhost"
      | bob  |
      | jane |
      | mike |

      And I don't care about application keys

    Given current domain is the admin domain of provider "foo.3scale.localhost"
      And I am logged in as provider "foo.3scale.localhost"

  Scenario: No plan is selected
    Given an application plan "Advanced" of provider "foo.3scale.localhost"
    And I am on the accounts admin page
    When I check select for "bob"
    And I press "Change account plan"
    And I press "Change plan" and I confirm dialog box
    Then I should see "Required parameter missing: plan_id"

  Scenario: Unable to change plans unless account_plans switch allowed
    Given an application plan "Advanced" of provider "foo.3scale.localhost"
      And provider "foo.3scale.localhost" has "account_plans" switch denied
      And I am on the accounts admin page

    When I follow "Group/Org."
     And I check select for "bob" and "mike"
    Then I should not see "Change account plan"

  Scenario: Cant change plan to the same
    Given an application plan "Advanced" of provider "foo.3scale.localhost"
      And I am on the accounts admin page

    When I check select for "bob"
     And I press "Change account plan"
    Then I should see "Transfer these accounts to different account plan"

    When I select "Bronze" from "Plan"
     And I press "Change plan" and I confirm dialog box
     Then I should see "There were some errors"

  Scenario: Mass change of account plans
    Given an application plan "Advanced" of provider "foo.3scale.localhost"
      And I am on the accounts admin page

    When I follow "Group/Org."
    Then I should see following table:
     | Group/Org. ▲ | Plan   |
     | bob          | Bronze |
     | jane         | Bronze |
     | mike         | Bronze |

    When I check select for "bob" and "mike"
     And I press "Change account plan"

    Then I should see "Transfer these accounts to different account plan"

    When I select "Gold" from "Plan"
     And I press "Change plan" and I confirm dialog box

    Then I should see "Action completed successfully"
     And I should see following table:
     | Group/Org. ▲ | Plan   |
     | bob          | Gold   |
     | jane         | Bronze |
     | mike         | Gold   |
