public with sharing class RetailDashboardController {
    @AuraEnabled(cacheable=true)
    public static RetailDashboardService.DashboardWrapper getFullDashboard() {
        return RetailDashboardService.getFullDashboard();
    }
}
