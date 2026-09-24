public with sharing class RecommendationController {
    @AuraEnabled(cacheable=true)
    public static List<RecommendationService.RecommendationWrapper> getRecommendationsByCustomer(Id customerId) {
        return RecommendationService.getRecommendationsByCustomer(customerId);
    }

    @AuraEnabled(cacheable=true)
    public static List<RecommendationService.RecommendationWrapper> getRecentRecommendations(Id customerId, Integer limitCount) {
        return RecommendationService.getRecentRecommendations(customerId, limitCount);
    }
}
