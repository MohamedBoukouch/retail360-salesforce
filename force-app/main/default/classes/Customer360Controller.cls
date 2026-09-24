public with sharing class Customer360Controller {

    @AuraEnabled(cacheable=true)
    public static Customer360Service.Customer360Data
        getCustomer360(Id customerId) {

        return Customer360Service.getCustomer360(
            customerId
        );
    }
}