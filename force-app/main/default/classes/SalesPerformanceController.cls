public with sharing class SalesPerformanceController {
    @AuraEnabled(cacheable=true)
    public static List<SalesPerformanceService.PerformanceWrapper> getPerformancesBySalesRep(Id salesRepId) {
        return SalesPerformanceService.getPerformancesBySalesRep(salesRepId);
    }

    @AuraEnabled(cacheable=true)
    public static List<SalesPerformanceService.PerformanceWrapper> getPerformancesByStore(Id storeId) {
        return SalesPerformanceService.getPerformancesByStore(storeId);
    }

    @AuraEnabled(cacheable=true)
    public static List<SalesPerformanceService.PerformanceWrapper> getPerformancesByStoreAndPeriod(Id storeId, String period) {
        return SalesPerformanceService.getPerformancesByStoreAndPeriod(storeId, period);
    }
}
