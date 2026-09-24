public with sharing class CustomerVisitSelector {

    public static List<CustomerVisit__c> selectByIds(Set<Id> visitIds) {

        if (visitIds == null || visitIds.isEmpty()) {
            return new List<CustomerVisit__c>();
        }

        return [
            SELECT Id,
                   Name,
                   Customer__c,
                   Store__c,
                   Sales_Rep__c,
                   Check_In__c,
                   Check_Out__c,
                   Duration__c,
                   Visit_Status__c,
                   Purchase_Made__c
            FROM CustomerVisit__c
            WHERE Id IN :visitIds
        ];
    }

    public static List<CustomerVisit__c> selectByStoreId(Id storeId) {

        if (storeId == null) {
            return new List<CustomerVisit__c>();
        }

        return [
            SELECT Id,
                   Name,
                   Customer__c,
                   Store__c,
                   Sales_Rep__c,
                   Check_In__c,
                   Check_Out__c,
                   Duration__c,
                   Visit_Status__c,
                   Purchase_Made__c
            FROM CustomerVisit__c
            WHERE Store__c = :storeId
            ORDER BY Check_In__c DESC
        ];
    }
}