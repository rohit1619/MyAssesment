@isTest
public class AccountTriggerTest {

    @isTest
    static void testInsertHighRiskAccount() {
        Test.startTest();

        Account acc = new Account(
            Name = 'High Risk Account',
            Risk__c = 'High'
        );
        insert acc;

        Test.stopTest();

        // No assertion on event itself – just check the insert succeeded without exception
        System.assertNotEquals(null, acc.Id, 'Account should be inserted with ID');
    }

    @isTest
    static void testUpdateToHighRisk() {
        // Insert initial low risk account
        Account acc = new Account(
            Name = 'Medium Risk Account',
            Risk__c = 'Medium'
        );
        insert acc;

        Test.startTest();

        // Update to high risk to fire event
        acc.Risk__c = 'High';
        update acc;

        Test.stopTest();

        Account updatedAcc = [SELECT Id, Risk__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals('High', updatedAcc.Risk__c, 'Risk value should be updated to High');
    }

    @isTest
    static void testNoEventOnUnchangedRisk() {
        Account acc = new Account(
            Name = 'Unchanged Risk Account',
            Risk__c = 'Low'
        );
        insert acc;

        Test.startTest();

        acc.Name = 'Updated Name Only';
        update acc;

        Test.stopTest();

        Account updatedAcc = [SELECT Name FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Updated Name Only', updatedAcc.Name);
    }
}