public with sharing class CustomerVisitTriggerHandler {

    public static void beforeInsert(
        List<CustomerVisit__c> newVisits
    ) {

        CustomerVisitService.processVisits(
            newVisits,
            null
        );
    }

    public static void beforeUpdate(
        List<CustomerVisit__c> newVisits,
        Map<Id, CustomerVisit__c> oldVisits
    ) {

        CustomerVisitService.processVisits(
            newVisits,
            oldVisits
        );
    }
}