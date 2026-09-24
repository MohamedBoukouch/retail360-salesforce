public with sharing class RetailDashboardService {
    public class DashboardWrapper {
        @AuraEnabled
        public List<StoreWrapper> stores;
        @AuraEnabled
        public List<CustomerVisitWrapper> recentVisits;
        @AuraEnabled
        public List<RecommendationService.RecommendationWrapper> recentRecommendations;
    }

    public class StoreWrapper {
        @AuraEnabled
        public Id id;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String city;
        @AuraEnabled
        public String region;
        @AuraEnabled
        public String status;
        @AuraEnabled
        public Decimal monthlyTarget;
        @AuraEnabled
        public Id managerId;
        @AuraEnabled
        public String managerName;
        @AuraEnabled
        public Decimal employees;
    }

    public class CustomerVisitWrapper {
        @AuraEnabled
        public Id id;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public Id customerId;
        @AuraEnabled
        public String customerName;
        @AuraEnabled
        public Id salesRepId;
        @AuraEnabled
        public String salesRepName;
        @AuraEnabled
        public String visitStatus;
        @AuraEnabled
        public Datetime checkIn;
        @AuraEnabled
        public Datetime checkOut;
        @AuraEnabled
        public Decimal duration;
        @AuraEnabled
        public Boolean purchaseMade;
    }

    public static DashboardWrapper getFullDashboard() {
        DashboardWrapper dashboard = new DashboardWrapper();

        List<Store__c> stores = RetailDashboardSelector.selectAllStores();
        dashboard.stores = convertStores(stores);

        if (!stores.isEmpty()) {
            Set<Id> storeIds = new Set<Id>();
            for (Store__c s : stores) {
                storeIds.add(s.Id);
            }

            List<CustomerVisit__c> visits = RetailDashboardSelector.selectRecentVisits(storeIds, 10);
            dashboard.recentVisits = convertVisits(visits);

            Set<Id> contactIds = RetailDashboardSelector.selectContactIdsByStores(storeIds);
            if (!contactIds.isEmpty()) {
                List<Recommendation__c> recs = RetailDashboardSelector.selectRecentRecommendations(contactIds, 10);
                dashboard.recentRecommendations = convertRecommendations(recs);
            } else {
                dashboard.recentRecommendations = new List<RecommendationService.RecommendationWrapper>();
            }
        } else {
            dashboard.recentVisits = new List<CustomerVisitWrapper>();
            dashboard.recentRecommendations = new List<RecommendationService.RecommendationWrapper>();
        }

        return dashboard;
    }

    private static List<StoreWrapper> convertStores(List<Store__c> stores) {
        List<StoreWrapper> wrappers = new List<StoreWrapper>();
        for (Store__c s : stores) {
            StoreWrapper w = new StoreWrapper();
            w.id = s.Id;
            w.name = s.Name;
            w.city = s.City__c;
            w.region = s.Region__c;
            w.status = s.Status__c;
            w.monthlyTarget = s.Monthly_Target__c;
            w.managerId = s.Manager__c;
            w.managerName = s.Manager__r != null ? s.Manager__r.Name : null;
            w.employees = s.Employees__c;
            wrappers.add(w);
        }
        return wrappers;
    }

    private static List<CustomerVisitWrapper> convertVisits(List<CustomerVisit__c> visits) {
        List<CustomerVisitWrapper> wrappers = new List<CustomerVisitWrapper>();
        for (CustomerVisit__c v : visits) {
            CustomerVisitWrapper w = new CustomerVisitWrapper();
            w.id = v.Id;
            w.name = v.Name;
            w.customerId = v.Customer__c;
            w.customerName = v.Customer__r != null ? v.Customer__r.Name : null;
            w.salesRepId = v.Sales_Rep__c;
            w.salesRepName = v.Sales_Rep__r != null ? v.Sales_Rep__r.Name : null;
            w.visitStatus = v.Visit_Status__c;
            w.checkIn = v.Check_In__c;
            w.checkOut = v.Check_Out__c;
            w.duration = v.Duration__c;
            w.purchaseMade = v.Purchase_Made__c;
            wrappers.add(w);
        }
        return wrappers;
    }

    private static List<RecommendationService.RecommendationWrapper> convertRecommendations(List<Recommendation__c> recs) {
        List<RecommendationService.RecommendationWrapper> wrappers = new List<RecommendationService.RecommendationWrapper>();
        for (Recommendation__c rec : recs) {
            RecommendationService.RecommendationWrapper w = new RecommendationService.RecommendationWrapper();
            w.id = rec.Id;
            w.name = rec.Name;
            w.customerId = rec.Customer__c;
            w.customerName = rec.Customer__r != null ? rec.Customer__r.Name : null;
            w.productId = rec.Product__c;
            w.productName = rec.Product__r != null ? rec.Product__r.Name : null;
            w.confidence = rec.Confidence__c;
            w.reason = rec.Reason__c;
            w.status = rec.Status__c;
            wrappers.add(w);
        }
        return wrappers;
    }
}
