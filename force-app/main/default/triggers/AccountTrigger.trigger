trigger AccountTrigger on Account (After Update, After Insert) {
    if(Trigger.isInsert){
        AccountTriggerController.insertTriggerHandler(Trigger.new);
    }
    if(Trigger.isUpdate){
        AccountTriggerController.updateTriggerHandler(Trigger.New, Trigger.OldMap);
    }
}