public with sharing class StorePerformanceController {

    @AuraEnabled(cacheable=true)
    public static List<Store__c> getStores() {

        return [
            SELECT Id,
                   Name,
                   Store_Code__c,
                   City__c,
                   Region__c,
                   Employees__c,
                   Monthly_Target__c,
                   Status__c
            FROM Store__c
            WHERE Status__c = 'ACTIVE'
            ORDER BY Name
        ];
    }
}