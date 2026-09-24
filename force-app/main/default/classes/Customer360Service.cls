public with sharing class Customer360Service {

    public class Customer360Data {

        @AuraEnabled
        public Contact customer;

        @AuraEnabled
        public List<CustomerVisit__c> visits;

        @AuraEnabled
        public List<Opportunity> opportunities;

        @AuraEnabled
        public List<Case> cases;

        @AuraEnabled
        public List<Recommendation__c> recommendations;

        @AuraEnabled
        public Integer totalVisits;

        @AuraEnabled
        public Integer purchases;

        @AuraEnabled
        public Decimal totalOpportunityAmount;
    }


    public static Customer360Data getCustomer360(Id customerId) {

        if (customerId == null) {
            throw new AuraHandledException(
                'Customer Id is required.'
            );
        }

        Customer360Data result = new Customer360Data();

        result.customer =
            Customer360Selector.selectCustomer(customerId);

        if (result.customer == null) {
            throw new AuraHandledException(
                'Customer not found.'
            );
        }

        result.visits =
            Customer360Selector.selectVisits(customerId);

        result.opportunities =
            Customer360Selector.selectOpportunities(customerId);

        result.cases =
            Customer360Selector.selectCases(customerId);

        result.recommendations =
            Customer360Selector.selectRecommendations(customerId);


        result.totalVisits =
            result.visits.size();


        result.purchases = 0;

        for (CustomerVisit__c visit : result.visits) {

            if (visit.Purchase_Made__c == true) {
                result.purchases++;
            }
        }


        result.totalOpportunityAmount = 0;

        for (Opportunity opportunity : result.opportunities) {

            if (opportunity.Amount != null) {

                result.totalOpportunityAmount +=
                    opportunity.Amount;
            }
        }

        return result;
    }
}