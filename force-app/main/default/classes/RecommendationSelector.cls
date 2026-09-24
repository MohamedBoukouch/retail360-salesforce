public with sharing class RecommendationSelector {
    public static List<Recommendation__c> selectByCustomer(Id customerId) {
        if (customerId == null) {
            return new List<Recommendation__c>();
        }
        return [
            SELECT Id, Name, Customer__c, Product__c, Product__r.Name,
                Sales_Rep__c, Confidence__c, Reason__c, Status__c
            FROM Recommendation__c
            WHERE Customer__c = :customerId
            ORDER BY Confidence__c DESC
        ];
    }

    public static List<Recommendation__c> selectBySalesRep(Id salesRepId) {
        if (salesRepId == null) {
            return new List<Recommendation__c>();
        }
        return [
            SELECT Id, Name, Customer__c, Customer__r.Name, Product__c,
                Product__r.Name, Sales_Rep__c, Confidence__c, Reason__c, Status__c
            FROM Recommendation__c
            WHERE Sales_Rep__c = :salesRepId
            ORDER BY Confidence__c DESC
        ];
    }

    public static List<Recommendation__c> selectByStatus(String status) {
        if (status == null) {
            return new List<Recommendation__c>();
        }
        return [
            SELECT Id, Name, Customer__c, Customer__r.Name, Product__c,
                Product__r.Name, Sales_Rep__c, Confidence__c, Reason__c, Status__c
            FROM Recommendation__c
            WHERE Status__c = :status
            ORDER BY Confidence__c DESC
        ];
    }

    public static List<Recommendation__c> selectRecentByCustomer(Id customerId, Integer limitCount) {
        if (customerId == null) {
            return new List<Recommendation__c>();
        }
        return [
            SELECT Id, Name, Customer__c, Product__c, Product__r.Name,
                Sales_Rep__c, Confidence__c, Reason__c, Status__c
            FROM Recommendation__c
            WHERE Customer__c = :customerId
            ORDER BY Confidence__c DESC
            LIMIT :limitCount
        ];
    }
}
