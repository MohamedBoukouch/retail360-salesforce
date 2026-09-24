@IsTest
private class RecommendationServiceTest {
    @TestSetup
    static void setupData() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Customer',
            Email = 'rec-service-test@example.com',
            AccountId = testAccount.Id
        );
        insert testContact;

        Product2 testProduct = new Product2(Name = 'Test Product');
        insert testProduct;

        List<Recommendation__c> recs = new List<Recommendation__c>();
        for (Integer i = 0; i < 3; i++) {
            recs.add(new Recommendation__c(
                Customer__c = testContact.Id,
                Product__c = testProduct.Id,
                Confidence__c = 80 + i,
                Status__c = 'PENDING'
            ));
        }
        insert recs;
    }

    @IsTest
    static void testGetRecommendationsByCustomerReturnsWrappers() {
        Contact c = [SELECT Id FROM Contact WHERE Email = 'rec-service-test@example.com'];
        List<RecommendationService.RecommendationWrapper> wrappers =
            RecommendationService.getRecommendationsByCustomer(c.Id);

        System.assertEquals(3, wrappers.size());
        System.assertEquals('Test Product', wrappers[0].productName);
        System.assertEquals('PENDING', wrappers[0].status);
        System.assertNotEquals(null, wrappers[0].confidence);
    }

    @IsTest
    static void testGetRecommendationsByCustomerNullId() {
        List<RecommendationService.RecommendationWrapper> wrappers =
            RecommendationService.getRecommendationsByCustomer(null);
        System.assert(wrappers.isEmpty());
    }

    @IsTest
    static void testGetRecommendationsByStatusReturnsWrappers() {
        List<RecommendationService.RecommendationWrapper> wrappers =
            RecommendationService.getRecommendationsByStatus('PENDING');

        System.assertEquals(3, wrappers.size());
    }

    @IsTest
    static void testGetRecommendationsByStatusNoMatches() {
        List<RecommendationService.RecommendationWrapper> wrappers =
            RecommendationService.getRecommendationsByStatus('ACCEPTED');
        System.assert(wrappers.isEmpty());
    }

    @IsTest
    static void testGetRecentRecommendationsReturnsLimitedWrappers() {
        Contact c = [SELECT Id FROM Contact WHERE Email = 'rec-service-test@example.com'];
        List<RecommendationService.RecommendationWrapper> wrappers =
            RecommendationService.getRecentRecommendations(c.Id, 2);

        System.assertEquals(2, wrappers.size());
    }

    @IsTest
    static void testGetRecentRecommendationsNullId() {
        List<RecommendationService.RecommendationWrapper> wrappers =
            RecommendationService.getRecentRecommendations(null, 5);
        System.assert(wrappers.isEmpty());
    }

    @IsTest
    static void testConvertToWrapperPopulatesAllFields() {
        Contact c = [SELECT Id FROM Contact WHERE Email = 'rec-service-test@example.com'];
        List<RecommendationService.RecommendationWrapper> wrappers =
            RecommendationService.getRecommendationsByCustomer(c.Id);

        System.assertEquals(3, wrappers.size());
        for (RecommendationService.RecommendationWrapper w : wrappers) {
            System.assertNotEquals(null, w.id);
            System.assertNotEquals(null, w.name);
            System.assertEquals(c.Id, w.customerId);
            System.assertNotEquals(null, w.productId);
        }
    }
}
