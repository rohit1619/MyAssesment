public class RiskEventTriggerController {
    public static void riskEvantHandler(List<Risk_Alert_Event__e> reskAlertEvent){
        try{
            List<Case> casesToCreate = new List<Case>();
            
            // Get users (excluding account owner)
            List<User> users = [SELECT Id FROM User WHERE IsActive = TRUE LIMIT 2];
            Id fallbackUserId = users.size() > 1 ? users[1].Id : UserInfo.getUserId();
            
            for (Risk_Alert_Event__e event : reskAlertEvent) {
                if (event.Account_Id__c != null) {
                    Account acc = [SELECT Id, Name, OwnerId FROM Account WHERE Id = :event.Account_Id__c LIMIT 1];
                    
                    Id caseOwnerId = (acc.OwnerId == fallbackUserId && users.size() > 0) ? users[0].Id : fallbackUserId;
                    
                    Case c = new Case(
                        AccountId = acc.Id,
                        Subject = 'High Risk Alert - ' + acc.Name,
                        OwnerId = caseOwnerId,
                        Origin = 'Internal',
                        Status = 'New',
                        Priority = 'High'
                    );
                    
                    casesToCreate.add(c);
                }
            }
            
            if (!casesToCreate.isEmpty()) {
                insert casesToCreate;
            }
        }
        catch(Exception e){
            system.debug('Error: '+e.getMessage());
        }
    }
}