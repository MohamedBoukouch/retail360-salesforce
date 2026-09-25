public with sharing class CustomerVisitController {
    public class VisitFormWrapper {
        @AuraEnabled
        public Id storeId;
        @AuraEnabled
        public String storeName;
        @AuraEnabled
        public Id customerId;
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
        wrapper.storeId = visit.Store__c;
        wrapper.customerId = visit.Customer__c;
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

    @AuraEnabled(cacheable=true)
    public static List<Store__c> searchStores(String searchTerm) {
        if (searchTerm == null || searchTerm == '') {
            return [
                SELECT Id, Name FROM Store__c
                WHERE Status__c = 'ACTIVE'
                ORDER BY Name ASC
                LIMIT 10
            ];
        }
        return [
            SELECT Id, Name FROM Store__c
            WHERE Name LIKE :('%' + searchTerm + '%')
            AND Status__c = 'ACTIVE'
            ORDER BY Name ASC
            LIMIT 10
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> searchCustomers(String searchTerm) {
        if (searchTerm == null || searchTerm == '') {
            return [
                SELECT Id, Name FROM Contact
                ORDER BY Name ASC
                LIMIT 10
            ];
        }
        return [
            SELECT Id, Name FROM Contact
            WHERE Name LIKE :('%' + searchTerm + '%')
            ORDER BY Name ASC
            LIMIT 10
        ];
    }

    @AuraEnabled
    public static Id saveVisit(Id visitId, Id storeId, Id customerId,
            Datetime checkIn, Datetime checkOut,
            Decimal duration, Boolean purchaseMade, String visitStatus) {
        CustomerVisit__c visit = new CustomerVisit__c(
            Id = visitId,
            Store__c = storeId,
            Customer__c = customerId,
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
