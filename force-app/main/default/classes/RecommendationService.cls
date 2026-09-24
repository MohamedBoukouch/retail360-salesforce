public with sharing class RecommendationService {
    public class RecommendationWrapper {
        @AuraEnabled
        public Id id;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public Id customerId;
        @AuraEnabled
        public String customerName;
        @AuraEnabled
        public Id productId;
        @AuraEnabled
        public String productName;
        @AuraEnabled
        public Id salesRepId;
        @AuraEnabled
        public String salesRepName;
        @AuraEnabled
        public Decimal confidence;
        @AuraEnabled
        public String reason;
        @AuraEnabled
        public String status;
    }

    public static List<RecommendationWrapper> getRecommendationsByCustomer(Id customerId) {
        List<RecommendationWrapper> wrappers = new List<RecommendationWrapper>();
        for (Recommendation__c rec : RecommendationSelector.selectByCustomer(customerId)) {
            wrappers.add(convertToWrapper(rec));
        }
        return wrappers;
    }

    public static List<RecommendationWrapper> getRecommendationsBySalesRep(Id salesRepId) {
        List<RecommendationWrapper> wrappers = new List<RecommendationWrapper>();
        for (Recommendation__c rec : RecommendationSelector.selectBySalesRep(salesRepId)) {
            wrappers.add(convertToWrapper(rec));
        }
        return wrappers;
    }

    public static List<RecommendationWrapper> getRecommendationsByStatus(String status) {
        List<RecommendationWrapper> wrappers = new List<RecommendationWrapper>();
        for (Recommendation__c rec : RecommendationSelector.selectByStatus(status)) {
            wrappers.add(convertToWrapper(rec));
        }
        return wrappers;
    }

    public static List<RecommendationWrapper> getRecentRecommendations(Id customerId, Integer limitCount) {
        List<RecommendationWrapper> wrappers = new List<RecommendationWrapper>();
        for (Recommendation__c rec : RecommendationSelector.selectRecentByCustomer(customerId, limitCount)) {
            wrappers.add(convertToWrapper(rec));
        }
        return wrappers;
    }

    private static RecommendationWrapper convertToWrapper(Recommendation__c rec) {
        RecommendationWrapper w = new RecommendationWrapper();
        w.id = rec.Id;
        w.name = rec.Name;
        w.customerId = rec.Customer__c;
        w.productId = rec.Product__c;
        w.productName = rec.Product__r != null ? rec.Product__r.Name : null;
        w.salesRepId = rec.Sales_Rep__c;
        w.confidence = rec.Confidence__c;
        w.reason = rec.Reason__c;
        w.status = rec.Status__c;
        return w;
    }
}
