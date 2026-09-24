public with sharing class SalesPerformanceService {
    public class PerformanceWrapper {
        @AuraEnabled
        public Id id;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public Id salesRepId;
        @AuraEnabled
        public String salesRepName;
        @AuraEnabled
        public Id storeId;
        @AuraEnabled
        public String storeName;
        @AuraEnabled
        public String period;
        @AuraEnabled
        public Decimal salesAmount;
        @AuraEnabled
        public Decimal target;
        @AuraEnabled
        public Decimal achievement;
        @AuraEnabled
        public Decimal achievementPercent;
    }

    public static List<PerformanceWrapper> getPerformancesBySalesRep(Id salesRepId) {
        List<PerformanceWrapper> wrappers = new List<PerformanceWrapper>();
        for (SalesRepPerformance__c perf : SalesPerformanceSelector.selectBySalesRep(salesRepId)) {
            wrappers.add(convertToWrapper(perf));
        }
        return wrappers;
    }

    public static List<PerformanceWrapper> getPerformancesByStore(Id storeId) {
        List<PerformanceWrapper> wrappers = new List<PerformanceWrapper>();
        for (SalesRepPerformance__c perf : SalesPerformanceSelector.selectByStore(storeId)) {
            wrappers.add(convertToWrapper(perf));
        }
        return wrappers;
    }

    public static List<PerformanceWrapper> getPerformancesByPeriod(String period) {
        List<PerformanceWrapper> wrappers = new List<PerformanceWrapper>();
        for (SalesRepPerformance__c perf : SalesPerformanceSelector.selectByPeriod(period)) {
            wrappers.add(convertToWrapper(perf));
        }
        return wrappers;
    }

    public static List<PerformanceWrapper> getPerformancesByStoreAndPeriod(Id storeId, String period) {
        List<PerformanceWrapper> wrappers = new List<PerformanceWrapper>();
        for (SalesRepPerformance__c perf : SalesPerformanceSelector.selectByStoreAndPeriod(storeId, period)) {
            wrappers.add(convertToWrapper(perf));
        }
        return wrappers;
    }

    public static Decimal calculateAchievementPercent(Decimal salesAmount, Decimal target) {
        if (target == null || target == 0) {
            return 0;
        }
        if (salesAmount == null) {
            return 0;
        }
        return (salesAmount / target) * 100;
    }

    private static PerformanceWrapper convertToWrapper(SalesRepPerformance__c perf) {
        PerformanceWrapper w = new PerformanceWrapper();
        w.id = perf.Id;
        w.name = perf.Name;
        w.salesRepId = perf.Sales_Rep__c;
        w.salesRepName = perf.Sales_Rep__r != null ? perf.Sales_Rep__r.Name : null;
        w.storeId = perf.Store__c;
        w.storeName = perf.Store__r != null ? perf.Store__r.Name : null;
        w.period = perf.Period__c;
        w.salesAmount = perf.Sales_Amount__c;
        w.target = perf.Target__c;
        w.achievement = perf.Achievement__c;
        w.achievementPercent = calculateAchievementPercent(perf.Sales_Amount__c, perf.Target__c);
        return w;
    }
}
