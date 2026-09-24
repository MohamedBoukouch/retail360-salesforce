public with sharing class Customer360Controller {

    @AuraEnabled(cacheable=true)
    public static Contact getCustomer(Id customerId) {

        if (customerId == null) {
            return null;
        }

        List<Contact> customers = [
            SELECT Id,
                   Name,
                   FirstName,
                   LastName,
                   Email,
                   Phone,
                   AccountId,
                   Account.Name
            FROM Contact
            WHERE Id = :customerId
            LIMIT 1
        ];

        if (customers.isEmpty()) {
            return null;
        }

        return customers[0];
    }

    @AuraEnabled(cacheable=true)
    public static List<CustomerVisit__c> getCustomerVisits(
        Id customerId
    ) {

        if (customerId == null) {
            return new List<CustomerVisit__c>();
        }

        return [
            SELECT Id,
                   Name,
                   Store__c,
                   Store__r.Name,
                   Sales_Rep__c,
                   Check_In__c,
                   Check_Out__c,
                   Duration__c,
                   Visit_Status__c,
                   Purchase_Made__c
            FROM CustomerVisit__c
            WHERE Customer__c = :customerId
            ORDER BY Check_In__c DESC
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Recommendation__c> getRecommendations(
        Id customerId
    ) {

        if (customerId == null) {
            return new List<Recommendation__c>();
        }

        return [
            SELECT Id,
                   Name,
                   Product__c,
                   Product__r.Name,
                   Sales_Rep__c,
                   Confidence__c,
                   Reason__c,
                   Status__c
            FROM Recommendation__c
            WHERE Customer__c = :customerId
            ORDER BY Confidence__c DESC
        ];
    }
}