public with sharing class CustomerVisitController {
    public class VisitFormWrapper {
        @AuraEnabled
        public String storeName;
        @AuraEnabled
        public String customerName;
        @AuraEnabled
        public Datetime checkIn;
        @AuraEnabled
        public Datetime checkOut;
        @AuraEnabled
        public Decimal duration;
        @AuraEnabled
        public Boolean purchaseMade;
        @AuraEnabled
        public String visitStatus;
    }

    @AuraEnabled(cacheable=true)
    public static VisitFormWrapper getVisit(Id visitId) {
        if (visitId == null) {
            return new VisitFormWrapper();
        }

        List<CustomerVisit__c> visits = CustomerVisitSelector.selectByIds(new Set<Id>{visitId});
        if (visits.isEmpty()) {
            return new VisitFormWrapper();
        }

        CustomerVisit__c visit = visits[0];
        VisitFormWrapper wrapper = new VisitFormWrapper();
        wrapper.checkIn = visit.Check_In__c;
        wrapper.checkOut = visit.Check_Out__c;
        wrapper.duration = visit.Duration__c;
        wrapper.purchaseMade = visit.Purchase_Made__c;
        wrapper.visitStatus = visit.Visit_Status__c;

        if (visit.Customer__c != null) {
            Contact c = [SELECT Id, Name FROM Contact WHERE Id = :visit.Customer__c];
            wrapper.customerName = c.Name;
        }

        if (visit.Store__c != null) {
            Store__c s = [SELECT Id, Name FROM Store__c WHERE Id = :visit.Store__c];
            wrapper.storeName = s.Name;
        }

        return wrapper;
    }

    @AuraEnabled
    public static Id saveVisit(Id visitId, Datetime checkIn, Datetime checkOut,
            Decimal duration, Boolean purchaseMade, String visitStatus) {
        CustomerVisit__c visit = new CustomerVisit__c(
            Id = visitId,
            Check_In__c = checkIn,
            Check_Out__c = checkOut,
            Duration__c = duration,
            Purchase_Made__c = purchaseMade,
            Visit_Status__c = visitStatus
        );
        upsert visit;
        return visit.Id;
    }
}
