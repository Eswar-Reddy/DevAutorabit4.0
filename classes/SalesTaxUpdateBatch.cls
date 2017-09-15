global class SalesTaxUpdateBatch implements Database.Batchable<sObject>,Database.AllowsCallouts {
   global final String query;
   global List<String> stateList;
   global DateTime period;
   global String recordTypeName; 
   global String partnerName;
    
    global  SalesTaxUpdateBatch(String year,String month,String day){
        stateList = Label.SalesTaxUpdateStates.split(';');
        period = datetime.newInstance(Integer.valueOf(year),Integer.valueOf(month),Integer.valueOf(day),0,0,0);
        recordTypeName = 'Residential Customer';
        partnerName = 'Gabi Solar';
        query = 'select id,BillingStreet,BillingCity,BillingState,BillingPostalCode,Sales_Tax_Rate__c from Account where Partner_Account__r.Name != :partnerName AND Sales_Tax_Rate__c = null AND RecordType.Name = :recordTypeName  AND BillingState IN :stateList AND CreatedDate >= :period ORDER BY CreatedDate DESC';
    }
     
   global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Account> accountList = (List<Account>)scope;
        Set<Id> accountIds = new Set<Id>();
        for(Account acc : accountList){
            accountIds.add(acc.Id);
        }
        if(accountIds != null && accountIds.size()>0)
           AccountHandlerUtilities.updateSalesTax(accountIds);
        
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}