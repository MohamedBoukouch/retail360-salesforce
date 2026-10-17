
@isTest
private class OrderCalculatorTest {

    @isTest
    static void myUnitTest() {
        // TO DO: implement unit test
    }

    @isTest
    static void calculatesTotal(){
        List<Decimal> mounts = new List<Decimal>{100,20,33};
        Decimal total = orderCalculator.calculateTotal(amounts);
        System.assertEquals(153, total);
    }

    @IsTest
    static void handlesNullList() {
        Decimal result =
            OrderCalculator.calculateTotal(null);

        System.assertEquals(0, result);
    }
}