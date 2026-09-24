@IsTest
private class SalesPerformanceControllerTest {
    @TestSetup
    static void setupData() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'SalesRep',
            Email = 'salesctrl.test@example.com',
            AccountId = testAccount.Id
        );
        insert testContact;

        Store__c testStore = new Store__c(
            Name = 'Test Store',
            Store_Code__c = 'TEST-SP-CTRL-001',
            City__c = 'Test City',
            Region__c = 'Souss-Massa',
            Status__c = 'ACTIVE',
            Monthly_Target__c = 50000,
            Employees__c = 10
        );
        insert testStore;

        List<SalesRepPerformance__c> performances = new List<SalesRepPerformance__c>();
        for (Integer i = 1; i <= 4; i++) {
            performances.add(new SalesRepPerformance__c(
                Sales_Rep__c = UserInfo.getUserId(),
                Store__c = testStore.Id,
                Period__c = 'MONTHLY',
                Sales_Amount__c = 1000 * i,
                Target__c = 2000 * i,
                Achievement__c = 50
            ));
        }
        insert performances;
    }

    @IsTest
    static void testGetPerformancesBySalesRepReturnsWrappers() {
        List<SalesPerformanceService.PerformanceWrapper> wrappers =
            SalesPerformanceController.getPerformancesBySalesRep(UserInfo.getUserId());

        System.assertEquals(4, wrappers.size());
    }

    @IsTest
    static void testGetPerformancesBySalesRepNullId() {
        List<SalesPerformanceService.PerformanceWrapper> wrappers =
            SalesPerformanceController.getPerformancesBySalesRep(null);
        System.assert(wrappers.isEmpty());
    }

    @IsTest
    static void testGetPerformancesByStoreNullId() {
        List<SalesPerformanceService.PerformanceWrapper> wrappers =
            SalesPerformanceController.getPerformancesByStore(null);
        System.assert(wrappers.isEmpty());
    }

    @IsTest
    static void testGetPerformancesByStoreAndPeriodNullValues() {
        List<SalesPerformanceService.PerformanceWrapper> wrappers =
            SalesPerformanceController.getPerformancesByStoreAndPeriod(null, null);
        System.assert(wrappers.isEmpty());
    }
}
