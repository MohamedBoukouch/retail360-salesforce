public with sharing class RetailDashboardSelector {
    public static List<Store__c> selectAllStores() {
        return [
            SELECT Id, Name, City__c, Region__c, Status__c,
                Monthly_Target__c, Manager__c, Manager__r.Name,
                Employees__c
            FROM Store__c
            ORDER BY Name ASC
        ];
    }

    public static List<Store__c> selectStoresByIds(Set<Id> storeIds) {
        if (storeIds.isEmpty()) {
            return new List<Store__c>();
        }
        return [
            SELECT Id, Name, City__c, Region__c, Status__c,
                Monthly_Target__c, Manager__c, Manager__r.Name,
                Employees__c
            FROM Store__c
            WHERE Id IN :storeIds
            ORDER BY Name ASC
        ];
    }

    public static List<CustomerVisit__c> selectRecentVisits(Set<Id> storeIds, Integer limitCount) {
        if (storeIds.isEmpty()) {
            return new List<CustomerVisit__c>();
        }
        return [
            SELECT Id, Name, Customer__c, Customer__r.Name,
                Sales_Rep__c, Sales_Rep__r.Name, Visit_Status__c,
                Check_In__c, Check_Out__c, Duration__c, Purchase_Made__c,
                Store__c
            FROM CustomerVisit__c
            WHERE Store__c IN :storeIds
            ORDER BY CreatedDate DESC
            LIMIT :limitCount
        ];
    }

    public static List<Recommendation__c> selectRecentRecommendations(Set<Id> contactIds, Integer limitCount) {
        if (contactIds.isEmpty()) {
            return new List<Recommendation__c>();
        }
        return [
            SELECT Id, Name, Customer__c, Customer__r.Name,
                Product__c, Product__r.Name, Confidence__c, Reason__c, Status__c
            FROM Recommendation__c
            WHERE Customer__c IN :contactIds
            ORDER BY Confidence__c DESC
            LIMIT :limitCount
        ];
    }

    public static Set<Id> selectContactIdsByStores(Set<Id> storeIds) {
        if (storeIds.isEmpty()) {
            return new Set<Id>();
        }
        Set<Id> contactIds = new Set<Id>();
        for (CustomerVisit__c visit : [
            SELECT Customer__c FROM CustomerVisit__c
            WHERE Store__c IN :storeIds
            AND Customer__c != null
        ]) {
            contactIds.add(visit.Customer__c);
        }
        return contactIds;
    }
}
