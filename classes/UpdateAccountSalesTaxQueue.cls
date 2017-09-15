public class UpdateAccountSalesTaxQueue implements Queueable, Database.AllowsCallouts {
    private Set<Id> accountIds;
    
    public UpdateAccountSalesTaxQueue(Set<Id> accIds) {
        this.accountIds = accIds;    
    }
    
    public void execute(QueueableContext context){
        AccountHandlerUtilities.updateSalesTax(accountIds);
    }
}