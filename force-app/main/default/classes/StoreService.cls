public with sharing class StoreService {

    public static Store__c getStoreById(Id storeId) {

        if (storeId == null) {
            return null;
        }

        List<Store__c> stores = [
            SELECT Id,
                   Name,
                   Store_Code__c,
                   City__c,
                   Region__c,
                   Manager__c,
                   Employees__c,
                   Monthly_Target__c,
                   Status__c
            FROM Store__c
            WHERE Id = :storeId
            LIMIT 1
        ];

        if (stores.isEmpty()) {
            return null;
        }

        return stores[0];
    }

    public static List<Store__c> getActiveStores() {

        return [
            SELECT Id,
                   Name,
                   Store_Code__c,
                   City__c,
                   Region__c,
                   Manager__c,
                   Employees__c,
                   Monthly_Target__c,
                   Status__c
            FROM Store__c
            WHERE Status__c = 'ACTIVE'
            ORDER BY Name
        ];
    }
}