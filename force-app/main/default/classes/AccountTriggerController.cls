public class AccountTriggerController {
    public static void insertTriggerHandler(List<Account> accList){
        try{
            List<Risk_Alert_Event__e> events = new List<Risk_Alert_Event__e>();
            
            for (Account acc : accList) {
                
                if (acc.Risk__c == 'High') {
                    events.add(new Risk_Alert_Event__e(
                        Account_Id__c  = acc.Id
                    ));
                }
            }
            
            if (!events.isEmpty()) {
                EventBus.publish(events);
            }
        }
        catch(Exception e){
            system.debug('Error: '+e.getMessage());
        }
    }
    
    public static void updateTriggerHandler(List<Account> accList, Map<Id,Account> accMap){
        try{
            List<Risk_Alert_Event__e> events = new List<Risk_Alert_Event__e>();
            
            for (Account acc : accList) {
                Account oldAcc = accMap.get(acc.Id);
                
                if (acc.Risk__c == 'High' && oldAcc.Risk__c != 'High') {
                    events.add(new Risk_Alert_Event__e(
                        Account_Id__c  = acc.Id
                    ));
                }
            }
            
            if (!events.isEmpty()) {
                EventBus.publish(events);
            }
        }
        catch(Exception e){
            system.debug('Error: '+e.getMessage());
        }
    }
}