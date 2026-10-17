public with sharing class orderCalculator {
    public orderCalculator() {

    }

    public static Decimal calculateTotal(List<Decimal> amounts) {
        Decimal total =0 ;

        if(amounts == null){
            return total;
        }

        for(Decimal amount : amounts){
            total+=amount;
        }

        return total;
    }
}