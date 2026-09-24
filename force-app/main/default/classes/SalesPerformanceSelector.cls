public with sharing class SalesPerformanceSelector {
    public static List<SalesRepPerformance__c> selectBySalesRep(Id salesRepId) {
        if (salesRepId == null) {
            return new List<SalesRepPerformance__c>();
        }
        return [
            SELECT Id, Name, Sales_Rep__c, Sales_Rep__r.Name,
                Store__c, Store__r.Name, Period__c, Sales_Amount__c,
                Target__c, Achievement__c
            FROM SalesRepPerformance__c
            WHERE Sales_Rep__c = :salesRepId
            ORDER BY Period__c DESC
        ];
    }

    public static List<SalesRepPerformance__c> selectByStore(Id storeId) {
        if (storeId == null) {
            return new List<SalesRepPerformance__c>();
        }
        return [
            SELECT Id, Name, Sales_Rep__c, Sales_Rep__r.Name,
                Store__c, Store__r.Name, Period__c, Sales_Amount__c,
                Target__c, Achievement__c
            FROM SalesRepPerformance__c
            WHERE Store__c = :storeId
            ORDER BY Period__c DESC
        ];
    }

    public static List<SalesRepPerformance__c> selectByPeriod(String period) {
        if (period == null || period == '') {
            return new List<SalesRepPerformance__c>();
        }
        return [
            SELECT Id, Name, Sales_Rep__c, Sales_Rep__r.Name,
                Store__c, Store__r.Name, Period__c, Sales_Amount__c,
                Target__c, Achievement__c
            FROM SalesRepPerformance__c
            WHERE Period__c = :period
            ORDER BY Sales_Rep__r.Name ASC
        ];
    }

    public static List<SalesRepPerformance__c> selectByStoreAndPeriod(Id storeId, String period) {
        if (storeId == null || period == null || period == '') {
            return new List<SalesRepPerformance__c>();
        }
        return [
            SELECT Id, Name, Sales_Rep__c, Sales_Rep__r.Name,
                Store__c, Store__r.Name, Period__c, Sales_Amount__c,
                Target__c, Achievement__c
            FROM SalesRepPerformance__c
            WHERE Store__c = :storeId AND Period__c = :period
            ORDER BY Sales_Rep__r.Name ASC
        ];
    }
}
