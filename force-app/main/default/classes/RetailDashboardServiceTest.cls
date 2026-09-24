@IsTest
private class RetailDashboardServiceTest {
    @TestSetup
    static void setupData() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Customer',
            Email = 'dash-svc-test@example.com',
            AccountId = testAccount.Id
        );
        insert testContact;

        Product2 testProduct = new Product2(Name = 'Test Product');
        insert testProduct;

        List<Store__c> stores = new List<Store__c>();
        for (Integer i = 1; i <= 2; i++) {
            stores.add(new Store__c(
                Name = 'Test Store ' + i,
                Store_Code__c = 'TEST-SVC-' + i,
                City__c = 'City ' + i,
                Region__c = 'Souss-Massa',
                Status__c = 'ACTIVE',
                Monthly_Target__c = 50000,
                Employees__c = 10
            ));
        }
        insert stores;

        CustomerVisit__c visit = new CustomerVisit__c(
            Store__c = stores[0].Id,
            Customer__c = testContact.Id,
            Sales_Rep__c = UserInfo.getUserId(),
            Visit_Status__c = 'COMPLETED',
            Duration__c = 60,
            Purchase_Made__c = true
        );
        insert visit;

        List<Recommendation__c> recs = new List<Recommendation__c>();
        for (Integer i = 0; i < 3; i++) {
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
    static void testGetFullDashboardReturnsData() {
        RetailDashboardService.DashboardWrapper dashboard = RetailDashboardService.getFullDashboard();

        System.assertNotEquals(null, dashboard.stores);
        System.assertEquals(2, dashboard.stores.size());

        System.assertNotEquals(null, dashboard.recentVisits);
        System.assertEquals(1, dashboard.recentVisits.size());

        System.assertNotEquals(null, dashboard.recentRecommendations);
        System.assertEquals(3, dashboard.recentRecommendations.size());
    }

    @IsTest
    static void testGetFullDashboardEmptyStores() {
        delete [SELECT Id FROM Store__c];
        delete [SELECT Id FROM CustomerVisit__c];
        delete [SELECT Id FROM Recommendation__c];

        RetailDashboardService.DashboardWrapper dashboard = RetailDashboardService.getFullDashboard();

        System.assert(dashboard.stores.isEmpty());
        System.assert(dashboard.recentVisits.isEmpty());
        System.assert(dashboard.recentRecommendations.isEmpty());
    }

    @IsTest
    static void testDashboardWrapperPopulatesStoreFields() {
        RetailDashboardService.DashboardWrapper dashboard = RetailDashboardService.getFullDashboard();

        for (RetailDashboardService.StoreWrapper w : dashboard.stores) {
            System.assertNotEquals(null, w.id);
            System.assertNotEquals(null, w.name);
            System.assertEquals('ACTIVE', w.status);
            System.assertEquals(50000, w.monthlyTarget);
        }
    }

    @IsTest
    static void testDashboardWrapperPopulatesVisitFields() {
        RetailDashboardService.DashboardWrapper dashboard = RetailDashboardService.getFullDashboard();

        System.assertEquals(1, dashboard.recentVisits.size());
        RetailDashboardService.CustomerVisitWrapper w = dashboard.recentVisits[0];
        System.assertEquals('COMPLETED', w.visitStatus);
        System.assertEquals(true, w.purchaseMade);
        System.assertEquals(60, w.duration);
    }

    @IsTest
    static void testDashboardWrapperPopulatesRecommendationFields() {
        RetailDashboardService.DashboardWrapper dashboard = RetailDashboardService.getFullDashboard();

        System.assertEquals(3, dashboard.recentRecommendations.size());
        for (RecommendationService.RecommendationWrapper w : dashboard.recentRecommendations) {
            System.assertNotEquals(null, w.id);
            System.assertEquals('Test Product', w.productName);
        }
    }
}
