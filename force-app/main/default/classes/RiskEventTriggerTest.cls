@isTest
public class RiskEventTriggerTest {

    @isTest
    static void testRiskEventCreatesCase() {
        // Get test users
        List<User> userList = [SELECT Id FROM User WHERE IsActive = TRUE LIMIT 2];

        // Create account with first user as owner
        Account acc = new Account(
            Name = 'Risk Account',
            OwnerId = userList[0].Id
        );
        insert acc;

        Test.startTest();

        // Simulate platform event being published
        Risk_Alert_Event__e event = new Risk_Alert_Event__e(
            Account_Id__c = acc.Id
        );
        Database.SaveResult result = EventBus.publish(event);

        Test.stopTest();

        // Verify the case was created
        List<Case> createdCases = [SELECT Id, AccountId, OwnerId, Subject FROM Case WHERE AccountId = :acc.Id];
        System.assertEquals(1, createdCases.size(), 'One case should be created');

        // Verify that case owner is different from Account owner
        System.assertNotEquals(acc.OwnerId, createdCases[0].OwnerId, 'Case owner should not be Account owner');
    }
}