public with sharing class CustomerVisitService {

    public static void processVisits(
        List<CustomerVisit__c> newVisits,
        Map<Id, CustomerVisit__c> oldVisits
    ) {

        if (newVisits == null || newVisits.isEmpty()) {
            return;
        }

        for (CustomerVisit__c visit : newVisits) {

            calculateDuration(visit);

            validateVisit(visit);
        }
    }

    private static void calculateDuration(CustomerVisit__c visit) {

        if (visit.Check_In__c == null || visit.Check_Out__c == null) {
            return;
        }

        Long durationMilliseconds =
            visit.Check_Out__c.getTime() -
            visit.Check_In__c.getTime();

        if (durationMilliseconds < 0) {
            return;
        }

        Decimal durationMinutes =
            Decimal.valueOf(durationMilliseconds) / 60000;

        visit.Duration__c = durationMinutes;
    }

    private static void validateVisit(CustomerVisit__c visit) {

        if (
            visit.Check_In__c != null &&
            visit.Check_Out__c != null &&
            visit.Check_Out__c < visit.Check_In__c
        ) {
            visit.addError(
                'Check Out must be later than Check In.'
            );
        }
    }
}