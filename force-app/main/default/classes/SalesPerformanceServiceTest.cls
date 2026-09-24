@IsTest
private class SalesPerformanceServiceTest {
    @TestSetup
    static void setupData() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'SalesRep',
            Email = 'sp-svc-test@example.com',
            AccountId = testAccount.Id
        );
        insert testContact;

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
    static void testGetPerformancesBySalesRepReturnsWrappers() {
        List<SalesPerformanceService.PerformanceWrapper> wrappers =
            SalesPerformanceService.getPerformancesBySalesRep(UserInfo.getUserId());

        System.assertEquals(3, wrappers.size());
    }

    @IsTest
    static void testGetPerformancesBySalesRepNullId() {
        List<SalesPerformanceService.PerformanceWrapper> wrappers =
            SalesPerformanceService.getPerformancesBySalesRep(null);
        System.assert(wrappers.isEmpty());
    }

    @IsTest
    static void testGetPerformancesByStoreNullId() {
        List<SalesPerformanceService.PerformanceWrapper> wrappers =
            SalesPerformanceService.getPerformancesByStore(null);
        System.assert(wrappers.isEmpty());
    }

    @IsTest
    static void testGetPerformancesByPeriodReturnsWrappers() {
        List<SalesPerformanceService.PerformanceWrapper> wrappers =
            SalesPerformanceService.getPerformancesByPeriod('MONTHLY');

        System.assertEquals(3, wrappers.size());
    }

    @IsTest
    static void testGetPerformancesByPeriodNoMatches() {
        List<SalesPerformanceService.PerformanceWrapper> wrappers =
            SalesPerformanceService.getPerformancesByPeriod('YEARLY');
        System.assert(wrappers.isEmpty());
    }

    @IsTest
    static void testCalculateAchievementPercentNormalValues() {
        System.assertEquals(50, SalesPerformanceService.calculateAchievementPercent(500, 1000));
    }

    @IsTest
    static void testCalculateAchievementPercentNullSalesAmount() {
        System.assertEquals(0, SalesPerformanceService.calculateAchievementPercent(null, 1000));
    }

    @IsTest
    static void testCalculateAchievementPercentNullTarget() {
        System.assertEquals(0, SalesPerformanceService.calculateAchievementPercent(500, null));
    }

    @IsTest
    static void testCalculateAchievementPercentZeroTarget() {
        System.assertEquals(0, SalesPerformanceService.calculateAchievementPercent(500, 0));
    }

    @IsTest
    static void testCalculateAchievementPercentBothNull() {
        System.assertEquals(0, SalesPerformanceService.calculateAchievementPercent(null, null));
    }

    @IsTest
    static void testGetPerformancesByStoreAndPeriodNullValues() {
        List<SalesPerformanceService.PerformanceWrapper> wrappers =
            SalesPerformanceService.getPerformancesByStoreAndPeriod(null, null);
        System.assert(wrappers.isEmpty());
    }
}
