@IsTest
private class CustomerVisitServiceTest {

    @TestSetup
    static void setupData() {

        Store__c store = new Store__c(
            Name = 'Test Store',
            Store_Code__c = 'TEST-001'
        );

        insert store;
    }

    @IsTest
    static void shouldCalculateVisitDuration() {

        Store__c store = [
            SELECT Id
            FROM Store__c
            WHERE Store_Code__c = 'TEST-001'
            LIMIT 1
        ];

        CustomerVisit__c visit = new CustomerVisit__c(
            Store__c = store.Id,
            Check_In__c = Datetime.newInstance(
                2026,
                9,
                24,
                10,
                0,
                0
            ),
            Check_Out__c = Datetime.newInstance(
                2026,
                9,
                24,
                10,
                45,
                0
            ),
            Purchase_Made__c = false
        );

        Test.startTest();

        insert visit;

        Test.stopTest();

        CustomerVisit__c savedVisit = [
            SELECT Id, Duration__c
            FROM CustomerVisit__c
            WHERE Id = :visit.Id
        ];

        System.assertEquals(
            45,
            savedVisit.Duration__c,
            'Visit duration should be 45 minutes.'
        );
    }

    @IsTest
    static void shouldRejectInvalidVisitDuration() {

        Store__c store = [
            SELECT Id
            FROM Store__c
            WHERE Store_Code__c = 'TEST-001'
            LIMIT 1
        ];

        CustomerVisit__c visit = new CustomerVisit__c(
            Store__c = store.Id,
            Check_In__c = Datetime.newInstance(
                2026,
                9,
                24,
                11,
                0,
                0
            ),
            Check_Out__c = Datetime.newInstance(
                2026,
                9,
                24,
                10,
                0,
                0
            ),
            Purchase_Made__c = false
        );

        Test.startTest();

        try {

            insert visit;

            System.assert(
                false,
                'An invalid visit should not be inserted.'
            );

        } catch (DmlException e) {

            System.assert(
                e.getMessage().contains(
                    'Check Out must be later than Check In.'
                ),
                'Expected validation error was not returned.'
            );
        }

        Test.stopTest();
    }
}