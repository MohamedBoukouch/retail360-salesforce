@IsTest
private class RetailDashboardSelectorTest {
    @TestSetup
    static void setupData() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Customer',
            Email = 'dash-sel-test@example.com',
            AccountId = testAccount.Id
        );
        insert testContact;

        Product2 testProduct = new Product2(Name = 'Test Product');
        insert testProduct;

        Store__c testStore = new Store__c(
            Name = 'Test Store',
            Store_Code__c = 'TEST-SEL-001',
            City__c = 'Test City',
            Region__c = 'Souss-Massa',
            Status__c = 'ACTIVE',
            Monthly_Target__c = 50000,
            Employees__c = 10
        );
        insert testStore;

        CustomerVisit__c visit = new CustomerVisit__c(
            Store__c = testStore.Id,
            Customer__c = testContact.Id,
            Sales_Rep__c = UserInfo.getUserId(),
            Visit_Status__c = 'COMPLETED',
            Duration__c = 30,
            Purchase_Made__c = true
        );
        insert visit;

        Recommendation__c rec = new Recommendation__c(
            Customer__c = testContact.Id,
            Product__c = testProduct.Id,
            Confidence__c = 85,
            Status__c = 'PENDING'
        );
        insert rec;
    }

    @IsTest
    static void testSelectAllStoresReturnsRecords() {
        List<Store__c> stores = RetailDashboardSelector.selectAllStores();
        System.assert(!stores.isEmpty());
    }

    @IsTest
    static void testSelectStoresByIdsReturnsRecords() {
        Store__c store = [SELECT Id FROM Store__c LIMIT 1];
        Set<Id> storeIds = new Set<Id>{store.Id};
        List<Store__c> stores = RetailDashboardSelector.selectStoresByIds(storeIds);
        System.assertEquals(1, stores.size());
    }

    @IsTest
    static void testSelectStoresByIdsEmptySet() {
        List<Store__c> stores = RetailDashboardSelector.selectStoresByIds(new Set<Id>());
        System.assert(stores.isEmpty());
    }

    @IsTest
    static void testSelectRecentVisitsReturnsRecords() {
        Store__c store = [SELECT Id FROM Store__c LIMIT 1];
        Set<Id> storeIds = new Set<Id>{store.Id};
        List<CustomerVisit__c> visits = RetailDashboardSelector.selectRecentVisits(storeIds, 10);
        System.assert(!visits.isEmpty());
    }

    @IsTest
    static void testSelectRecentVisitsEmptySet() {
        List<CustomerVisit__c> visits = RetailDashboardSelector.selectRecentVisits(new Set<Id>(), 10);
        System.assert(visits.isEmpty());
    }

    @IsTest
    static void testSelectRecentRecommendationsReturnsRecords() {
        Contact c = [SELECT Id FROM Contact WHERE Email = 'dash-sel-test@example.com'];
        Set<Id> contactIds = new Set<Id>{c.Id};
        List<Recommendation__c> recs = RetailDashboardSelector.selectRecentRecommendations(contactIds, 10);
        System.assert(!recs.isEmpty());
    }

    @IsTest
    static void testSelectRecentRecommendationsEmptySet() {
        List<Recommendation__c> recs = RetailDashboardSelector.selectRecentRecommendations(new Set<Id>(), 10);
        System.assert(recs.isEmpty());
    }

    @IsTest
    static void testSelectContactIdsByStoresReturnsIds() {
        Store__c store = [SELECT Id FROM Store__c LIMIT 1];
        Set<Id> storeIds = new Set<Id>{store.Id};
        Set<Id> contactIds = RetailDashboardSelector.selectContactIdsByStores(storeIds);
        System.assert(contactIds.size() > 0);
    }

    @IsTest
    static void testSelectContactIdsByStoresEmptySet() {
        Set<Id> contactIds = RetailDashboardSelector.selectContactIdsByStores(new Set<Id>());
        System.assert(contactIds.isEmpty());
    }
}
