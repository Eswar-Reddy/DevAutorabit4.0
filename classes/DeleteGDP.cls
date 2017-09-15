global class DeleteGDP implements Database.Batchable<sObject>
{
   
    global DeleteGDP ()
    {
        
    }
    public List<Global_Dealer_Program__c> gdp_ids;
    global database.querylocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator([SELECT id FROM Global_Dealer_Program__c where performance_period__c='P2' AND Performance_Year__c =2012]);                                                                                                    
    }
    global void execute(Database.BatchableContext bc, sObject[] objects)
    {
        gdp_ids = new List<Global_Dealer_Program__c>();
 
        for(sObject s : objects)
        {
            Global_Dealer_Program__c g = (Global_Dealer_Program__c)s;
            gdp_ids.add(g);
        }   
        
        delete gdp_ids;
        
    }
    global void finish(Database.BatchableContext bc)
    {
    }
}