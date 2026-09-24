@IsTest
private class RecommendationSelectorTest {
    @TestSetup
    static void setupData() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Customer',
            Email = 'rec-test@example.com',
            AccountId = testAccount.Id
        );
        insert testContact;

        Product2 testProduct = new Product2(Name = 'Test Product');
        insert testProduct;

        List<Recommendation__c> recs = new List<Recommendation__c>();
        for (Integer i = 0; i < 5; i++) {
            recs.add(new Recommendation__c(
                Customer__c = testContact.Id,
                Product__c = testProduct.Id,
                Confidence__c = 50 + i,
                Status__c = 'PENDING'
            ));
        }
        insert recs;
    }

    @IsTest
    static void testSelectByCustomerReturnsRecords() {
        Contact c = [SELECT Id FROM Contact WHERE Email = 'rec-test@example.com'];
        List<Recommendation__c> recs = RecommendationSelector.selectByCustomer(c.Id);

        System.assertEquals(5, recs.size());
        System.assertEquals(54, recs[0].Confidence__c);
    }

    @IsTest
    static void testSelectByCustomerNullId() {
        List<Recommendation__c> recs = RecommendationSelector.selectByCustomer(null);
        System.assert(recs.isEmpty());
    }

    @IsTest
    static void testSelectBySalesRepReturnsRecords() {
        List<Recommendation__c> recs = RecommendationSelector.selectBySalesRep(null);
        System.assert(recs.isEmpty());
    }

    @IsTest
    static void testSelectBySalesRepNullId() {
        List<Recommendation__c> recs = RecommendationSelector.selectBySalesRep(null);
        System.assert(recs.isEmpty());
    }

    @IsTest
    static void testSelectByStatusReturnsRecords() {
        List<Recommendation__c> recs = RecommendationSelector.selectByStatus('PENDING');
        System.assertEquals(5, recs.size());
    }

    @IsTest
    static void testSelectByStatusNullStatus() {
        List<Recommendation__c> recs = RecommendationSelector.selectByStatus(null);
        System.assert(recs.isEmpty());
    }

    @IsTest
    static void testSelectRecentByCustomerReturnsLimitedRecords() {
        Contact c = [SELECT Id FROM Contact WHERE Email = 'rec-test@example.com'];
        List<Recommendation__c> recs = RecommendationSelector.selectRecentByCustomer(c.Id, 3);
        System.assertEquals(3, recs.size());
        System.assertEquals(54, recs[0].Confidence__c);
    }

    @IsTest
    static void testSelectRecentByCustomerNullId() {
        List<Recommendation__c> recs = RecommendationSelector.selectRecentByCustomer(null, 10);
        System.assert(recs.isEmpty());
    }

    @IsTest
    static void testSelectRecentByCustomerZeroLimit() {
        Contact c = [SELECT Id FROM Contact WHERE Email = 'rec-test@example.com'];
        List<Recommendation__c> recs = RecommendationSelector.selectRecentByCustomer(c.Id, 0);
        System.assert(recs.isEmpty());
    }
}
