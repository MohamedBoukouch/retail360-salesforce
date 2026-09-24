@IsTest
private class RecommendationControllerTest {
    @TestSetup
    static void setupData() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Customer',
            Email = 'controller.test@example.com',
            AccountId = testAccount.Id
        );
        insert testContact;

        Product2 testProduct = new Product2(Name = 'Test Product');
        insert testProduct;

        List<Recommendation__c> recs = new List<Recommendation__c>();
        for (Integer i = 0; i < 4; i++) {
            recs.add(new Recommendation__c(
                Customer__c = testContact.Id,
                Product__c = testProduct.Id,
                Confidence__c = 70 + i,
                Status__c = 'PENDING'
            ));
        }
        insert recs;
    }

    @IsTest
    static void testGetRecommendationsByCustomerReturnsWrappers() {
        Contact c = [SELECT Id FROM Contact WHERE Email = 'controller.test@example.com'];
        List<RecommendationService.RecommendationWrapper> wrappers =
            RecommendationController.getRecommendationsByCustomer(c.Id);

        System.assertEquals(4, wrappers.size());
        System.assertEquals(73, wrappers[0].confidence);
    }

    @IsTest
    static void testGetRecommendationsByCustomerNullId() {
        List<RecommendationService.RecommendationWrapper> wrappers =
            RecommendationController.getRecommendationsByCustomer(null);
        System.assert(wrappers.isEmpty());
    }

    @IsTest
    static void testGetRecentRecommendationsReturnsLimitedWrappers() {
        Contact c = [SELECT Id FROM Contact WHERE Email = 'controller.test@example.com'];
        List<RecommendationService.RecommendationWrapper> wrappers =
            RecommendationController.getRecentRecommendations(c.Id, 2);

        System.assertEquals(2, wrappers.size());
        System.assertEquals(73, wrappers[0].confidence);
    }

    @IsTest
    static void testGetRecentRecommendationsNullId() {
        List<RecommendationService.RecommendationWrapper> wrappers =
            RecommendationController.getRecentRecommendations(null, 5);
        System.assert(wrappers.isEmpty());
    }
}
