public with sharing class Customer360Selector {

    public static Contact selectCustomer(Id customerId) {

        if (customerId == null) {
            return null;
        }

        List<Contact> customers = [
            SELECT
                Id,
                FirstName,
                LastName,
                Name,
                Email,
                Phone,
                AccountId,
                Account.Name
            FROM Contact
            WHERE Id = :customerId
            LIMIT 1
        ];

        if (customers.isEmpty()) {
            return null;
        }

        return customers[0];
    }


    public static List<CustomerVisit__c> selectVisits(Id customerId) {

        if (customerId == null) {
            return new List<CustomerVisit__c>();
        }

        return [
            SELECT
                Id,
                Name,
                Customer__c,
                Store__c,
                Store__r.Name,
                Sales_Rep__c,
                Sales_Rep__r.Name,
                Check_In__c,
                Check_Out__c,
                Duration__c,
                Visit_Status__c,
                Purchase_Made__c
            FROM CustomerVisit__c
            WHERE Customer__c = :customerId
            ORDER BY Check_In__c DESC
        ];
    }


    public static List<Opportunity> selectOpportunities(Id customerId) {

        if (customerId == null) {
            return new List<Opportunity>();
        }

        return [
            SELECT
                Id,
                Name,
                StageName,
                Amount,
                CloseDate,
                Probability,
                AccountId
            FROM Opportunity
            WHERE AccountId IN (
                SELECT AccountId
                FROM Contact
                WHERE Id = :customerId
            )
            ORDER BY CloseDate DESC
        ];
    }


    public static List<Case> selectCases(Id customerId) {

        if (customerId == null) {
            return new List<Case>();
        }

        return [
            SELECT
                Id,
                CaseNumber,
                Subject,
                Status,
                Priority,
                CreatedDate
            FROM Case
            WHERE ContactId = :customerId
            ORDER BY CreatedDate DESC
        ];
    }


    public static List<Recommendation__c> selectRecommendations(
        Id customerId
    ) {

        if (customerId == null) {
            return new List<Recommendation__c>();
        }

        return [
            SELECT
                Id,
                Name,
                Customer__c,
                Product__c,
                Product__r.Name,
                Sales_Rep__c,
                Sales_Rep__r.Name,
                Confidence__c,
                Reason__c,
                Status__c
            FROM Recommendation__c
            WHERE Customer__c = :customerId
            ORDER BY CreatedDate DESC
        ];
    }
}