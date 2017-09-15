public class DealerLocatorFormController {

    public String getName() {
        return 'DealerLocatorFormController';
    }

    public Account getAccount() {
        return [select id, name, Type, Partner_Facts__c, Website, Phone, Dealer_Rank__c, Dealer_Tier__c, BillingStreet, BillingCity, BillingState, BillingPostalCode
                 from Account 
                 where id = :ApexPages.currentPage().getParameters().get('id')]; 
    } 
}