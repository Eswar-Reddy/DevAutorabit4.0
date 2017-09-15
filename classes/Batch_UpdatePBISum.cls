global class Batch_UpdatePBISum implements Database.Batchable<sObject>,Schedulable{    
 
    global database.QueryLocator start(Database.BatchableContext bx){
        //String stgQuote = 'SELECT id,Annual_Incentive_value_Num__c,Quote__c from Cash_Flow_Details__c where Annual_Incentive_value_Num__c != null and Annual_Incentive_value_Num__c>0 and Quote__r.Is_Locked__c = true and Quote__r.PBI_Sum__c = null';
        String stgQuote = 'SELECT id,Annual_Incentive_value_Num__c,Quote__c from Cash_Flow_Details__c where Annual_Incentive_value_Num__c != null and Annual_Incentive_value_Num__c>0 and Quote__r.PBI_Sum__c = null and Quote__r.Is_Locked__c = true';
        System.debug(LoggingLevel.ERROR,'------------stgQuote'+stgQuote);
        return Database.getQueryLocator(stgQuote);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        list<Cash_Flow_Details__c> listCashFlow = (list<Cash_Flow_Details__c>)scope;
        System.debug('-----------listCashFlow'+listCashFlow);
        /*for(Quote objQuote:listQuote){
            System.debug('-----------objQuote'+objQuote);*/
            
            LREngine.Context ctx = new LREngine.Context(Quote.SobjectType, // parent object
                                                        Cash_Flow_Details__c.SobjectType,  // child object
                                                        Schema.SObjectType.Cash_Flow_Details__c.fields.Quote__c); // relationship field name    
            ctx.add(
                new LREngine.RollupSummaryField(
                    Schema.SObjectType.Quote.fields.PBI_Sum__c,
                    Schema.SObjectType.Cash_Flow_Details__c.fields.Annual_Incentive_value_Num__c,
                    LREngine.RollupOperation.Sum)); 
                Sobject[] masters = LREngine.rollUp(ctx, listCashFlow);
            System.debug(LoggingLevel.ERROR,'------------masters'+masters); 
            Database.update(masters, false);
            
            update masters; 
        //}
        
    }
    global void finish(Database.BatchableContext BC){
        
    }
    public void execute(SchedulableContext sc){
        
    }


}