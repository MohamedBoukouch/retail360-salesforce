@IsTest
private class SalesPerformanceSelectorTest {
    @TestSetup
    static void setupData() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'SalesRep',
            Email = 'sp-sel-test@example.com',
            AccountId = testAccount.Id
        );
        insert testContact;

        Product2 testProduct = new Product2(Name = 'Test Product');
        insert testProduct;

        List<SalesRepPerformance__c> performances = new List<SalesRepPerformance__c>();
        for (Integer i = 1; i <= 3; i++) {
            performances.add(new SalesRepPerformance__c(
                Sales_Rep__c = UserInfo.getUserId(),
                Period__c = 'MONTHLY',
                Sales_Amount__c = 1000 * i,
                Target__c = 2000 * i,
                Achievement__c = 50
            ));
        }
        insert performances;
    }

    @IsTest
    static void testSelectBySalesRepReturnsRecords() {
        List<SalesRepPerformance__c> perf = SalesPerformanceSelector.selectBySalesRep(UserInfo.getUserId());
        System.assertEquals(3, perf.size());
    }

    @IsTest
    static void testSelectBySalesRepNullId() {
        List<SalesRepPerformance__c> perf = SalesPerformanceSelector.selectBySalesRep(null);
        System.assert(perf.isEmpty());
    }

    @IsTest
    static void testSelectByStoreNullId() {
        List<SalesRepPerformance__c> perf = SalesPerformanceSelector.selectByStore(null);
        System.assert(perf.isEmpty());
    }

    @IsTest
    static void testSelectByPeriodReturnsRecords() {
        List<SalesRepPerformance__c> perf = SalesPerformanceSelector.selectByPeriod('MONTHLY');
        System.assertEquals(3, perf.size());
    }

    @IsTest
    static void testSelectByPeriodNullPeriod() {
        List<SalesRepPerformance__c> perf = SalesPerformanceSelector.selectByPeriod(null);
        System.assert(perf.isEmpty());
    }

    @IsTest
    static void testSelectByStoreAndPeriodNullValues() {
        List<SalesRepPerformance__c> perf = SalesPerformanceSelector.selectByStoreAndPeriod(null, null);
        System.assert(perf.isEmpty());
    }

    @IsTest
    static void testSelectByStoreAndPeriodEmptyResult() {
        Store__c store = new Store__c(
            Name = 'Empty Result Store',
            Store_Code__c = 'TEST-SEL-SP-001',
            City__c = 'Test City',
            Region__c = 'Souss-Massa',
            Status__c = 'ACTIVE',
            Monthly_Target__c = 50000,
            Employees__c = 10
        );
        insert store;

        List<SalesRepPerformance__c> perf = SalesPerformanceSelector.selectByStoreAndPeriod(store.Id, 'YEARLY');
        System.assert(perf.isEmpty());
    }
}
