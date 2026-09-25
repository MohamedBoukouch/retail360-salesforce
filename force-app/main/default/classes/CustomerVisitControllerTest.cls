@IsTest
private class CustomerVisitControllerTest {
    @TestSetup
    static void setupData() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Customer',
            Email = 'visit-ctrl-test@example.com',
            AccountId = testAccount.Id
        );
        insert testContact;

        Product2 testProduct = new Product2(Name = 'Test Product');
        insert testProduct;

        Store__c testStore = new Store__c(
            Name = 'Test Store',
            Store_Code__c = 'TEST-VISIT-001',
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
            Check_In__c = DateTime.newInstance(2025, 1, 1, 9, 0, 0),
            Check_Out__c = DateTime.newInstance(2025, 1, 1, 10, 0, 0),
            Duration__c = 60,
            Purchase_Made__c = false
        );
        insert visit;
    }

    @IsTest
    static void testGetVisitReturnsWrapper() {
        CustomerVisit__c visit = [SELECT Id FROM CustomerVisit__c LIMIT 1];
        CustomerVisitController.VisitFormWrapper wrapper = CustomerVisitController.getVisit(visit.Id);

        System.assertNotEquals(null, wrapper);
        System.assertEquals('Test Store', wrapper.storeName);
        System.assertEquals('Test Customer', wrapper.customerName);
        System.assertEquals('COMPLETED', wrapper.visitStatus);
        System.assertEquals(60, wrapper.duration);
        System.assertEquals(false, wrapper.purchaseMade);
        System.assertNotEquals(null, wrapper.storeId);
        System.assertNotEquals(null, wrapper.customerId);
    }

    @IsTest
    static void testGetVisitNullId() {
        CustomerVisitController.VisitFormWrapper wrapper = CustomerVisitController.getVisit(null);

        System.assertNotEquals(null, wrapper);
        System.assertEquals(null, wrapper.storeName);
        System.assertEquals(null, wrapper.customerName);
    }

    @IsTest
    static void testSaveVisitUpdatesRecord() {
        CustomerVisit__c visit = [SELECT Id FROM CustomerVisit__c LIMIT 1];
        Store__c store = [SELECT Id FROM Store__c LIMIT 1];
        Contact contact = [SELECT Id FROM Contact LIMIT 1];

        Id resultId = CustomerVisitController.saveVisit(
            visit.Id,
            store.Id,
            contact.Id,
            DateTime.newInstance(2025, 1, 1, 9, 0, 0),
            DateTime.newInstance(2025, 1, 1, 10, 0, 0),
            60,
            true,
            'COMPLETED'
        );

        System.assertEquals(visit.Id, resultId);

        CustomerVisit__c savedVisit = [
            SELECT Visit_Status__c, Purchase_Made__c, Duration__c, Store__c, Customer__c
            FROM CustomerVisit__c
            WHERE Id = :resultId
        ];
        System.assertEquals('COMPLETED', savedVisit.Visit_Status__c);
        System.assertEquals(true, savedVisit.Purchase_Made__c);
        System.assertEquals(store.Id, savedVisit.Store__c);
        System.assertEquals(contact.Id, savedVisit.Customer__c);
    }

    @IsTest
    static void testSearchStoresWithTerm() {
        List<Store__c> stores = CustomerVisitController.searchStores('Test');
        System.assert(!stores.isEmpty());
    }

    @IsTest
    static void testSearchStoresEmpty() {
        List<Store__c> stores = CustomerVisitController.searchStores('');
        System.assert(!stores.isEmpty());
    }

    @IsTest
    static void testSearchStoresNull() {
        List<Store__c> stores = CustomerVisitController.searchStores(null);
        System.assert(!stores.isEmpty());
    }

    @IsTest
    static void testSearchCustomersWithTerm() {
        List<Contact> customers = CustomerVisitController.searchCustomers('Test');
        System.assert(!customers.isEmpty());
    }

    @IsTest
    static void testSearchCustomersEmpty() {
        List<Contact> customers = CustomerVisitController.searchCustomers('');
        System.assert(!customers.isEmpty());
    }

    @IsTest
    static void testSearchCustomersNull() {
        List<Contact> customers = CustomerVisitController.searchCustomers(null);
        System.assert(!customers.isEmpty());
    }
}
