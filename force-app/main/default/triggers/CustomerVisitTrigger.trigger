trigger CustomerVisitTrigger on CustomerVisit__c (
    before insert,
    before update
) {

    if (Trigger.isBefore) {

        if (Trigger.isInsert) {

            CustomerVisitTriggerHandler.beforeInsert(
                Trigger.new
            );
        }

        if (Trigger.isUpdate) {

            CustomerVisitTriggerHandler.beforeUpdate(
                Trigger.new,
                Trigger.oldMap
            );
        }
    }
}