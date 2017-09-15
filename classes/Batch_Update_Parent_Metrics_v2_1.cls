/**************************** Batch apex to Update The Parent Metrics for the Existing Metrics*************************/
   
global class Batch_Update_Parent_Metrics_v2_1 implements Database.Batchable<sObject>, Database.Stateful
{ 
/***** VARIABLES *****/ 
  public Integer count = 0;
  public Set<Id> sUpIds = new Set<Id>();
  global final List<Account> lo_AccList;
/*** END VARIABLES ***/
    
/***** PROPERTY *****/
  global Integer prop_GetCurrentYear { get; set; }
  global String prop_GetCurrentPeriod { get; set; }
  global List<String>  prop_lstAccTy { get; set; }
  global List<String>  prop_lstCounDom { get; set; }
/*** END PROPERTY *********/
    
/***** CONSTRUCTOR *****/
    global Batch_Update_Parent_Metrics_v2_1()
    {
    }
    
    global Batch_Update_Parent_Metrics_v2_1(List<Account> lstAcc)
    {
        lo_AccList = lstAcc;
    }
    
    
/*** END CONSTRUCTOR ***/

/***** START *****/
  global database.querylocator start(Database.BatchableContext bc)
  {
    if(!Test.isRunningTest())
    {
        return Database.getQueryLocator([SELECT id, Type, Country_Domain__c 
                                         FROM Account 
                                         WHERE 
                                            RecordType.name='Partner' AND 
                                            Type IN:prop_lstAccTy AND 
                                            Status__c = 'Active' AND 
                                            Id IN (SELECT Account__c 
                                                   FROM Metrics__c 
                                                   WHERE 
                                                     Performance_Period__c=: prop_GetCurrentPeriod AND 
                                                     Performance_Year__c=: prop_GetCurrentYear) AND BillingCountry IN:prop_lstCounDom]);
    }
    else
    {
          return Database.getQueryLocator([SELECT id, Type, Country_Domain__c 
                                             FROM Account 
                                             WHERE id IN:lo_AccList LIMIT 50]);
        
    }
  }
/*** END START ***/

/***** EXECUTE *****/
  global void execute(Database.BatchableContext bc, sObject[] objects)
  {
    //Collect All the Account Id from each of the batches
    List<Id> lstAccIds = new List<Id>();
    for(sObject s : objects)
      lstAccIds.add(((Account)s).Id);
      
    //Get all the Metrices related to collected Account, filter by the query's WHERE clause condition
    List<Metrics__c> lstAllM =  [SELECT id,  
                                        Metric_Code__c, Metric_Parent_Code__c,Parent_Metrics__c, 
                                        Account__c 
                                 FROM Metrics__c 
                                 WHERE 
                                       Account__c IN : lstAccIds AND 
                                       Metric_Parent_Code__c != null AND
                                       Parent_Metrics__c = null AND  
                                       Performance_Period__c=:prop_GetCurrentPeriod AND 
                                       Performance_Year__c=:prop_GetCurrentYear 
                                 LIMIT 50000];
                                 
    //Map of All Parent Metric code and Account Id
    Set<String> sMC = new Set<String>();//Metric Codes  
    Set<String> sMPC  = new Set<String>(); //All Metric Parent Codes
    for(Metrics__c m : lstAllM)
    {
      sMC.add(m.Metric_Code__c);
      if(m.Metric_Parent_Code__c != null)
        sMPC.add(m.Metric_Parent_Code__c);
    }

    //Query for salesforce record id of all the Parent Metric Code  
    List<Metrics__c> lstAllMIds = [SELECT id, Metric_Code__c    
                                   FROM Metrics__c 
                                   WHERE 
                                      Metric_Code__c IN : sMPC  AND Performance_Period__c=:prop_GetCurrentPeriod AND 
                                       Performance_Year__c=:prop_GetCurrentYear
                                   LIMIT 50000];
                                   
    //Map Parent Metric Code vs its Salesforce Id                              
    Map<String, Id> mMCvsId = new Map<String, Id>();                                 
    for(Metrics__c m : lstAllMIds)
    {
      mMCvsId.put(m.Metric_Code__c, m.Id);
      sMC.add(m.Metric_Code__c); //Adding all the collected Child and Parent Metric Code at one place
    }  

    //Account Id vs All Related Metrics
    Map<Id, List<Metrics__c>> mAccIdvsLstM = new Map<Id, List<Metrics__c>>();   
    for(Metrics__c mA: [SELECT id, Account__c, Metric_Code__c FROM Metrics__c WHERE Metric_Code__c IN : sMC AND Performance_Period__c=:prop_GetCurrentPeriod AND 
                                       Performance_Year__c=:prop_GetCurrentYear])
    {   
      if(mAccIdvsLstM.containsKey(mA.Account__c))
      {
        List<Metrics__c> tMs = mAccIdvsLstM.get(mA.Account__c);
        tMs.add(mA);
        mAccIdvsLstM.put(mA.Account__c, tMs);
      }
      else
        mAccIdvsLstM.put(mA.Account__c, new List<Metrics__c>{mA});  
    }
    
    //Set the Metrics's Parent Metric with Salesforce Id   
    Map<Id, Metrics__c> mapMUp = new Map<Id, Metrics__c>(); 
    for(Metrics__c m : lstAllM)
    {
      if(m.Metric_Parent_Code__c != null && m.Parent_Metrics__c == null && mapMUp.size() < 10000)
      {
        List<Metrics__c> tempLst = mAccIdvsLstM.get(m.Account__c);
        for(Metrics__c t : tempLst)
        {
          if(t.Metric_code__c == m.Metric_Parent_Code__c)
          {
            mapMUp.put(m.Id, new Metrics__c(Id= m.Id, Parent_Metrics__c= t.Id)); 
          }         
        }       
      }
    }
    
    //Update the Metrics records to preserve the relationship      
    if(!mapMUp.isEmpty())
    {    
      update mapMUp.values();
      count = count + mapMUp.size();
      sUpIds.addAll(mapMup.keySet());
    }
  }
/*** END EXECUTE ***/

/***** FINISH *****/
  global void finish(Database.BatchableContext bc)
  {  
    System.Debug('--###--> ' + count);
    String strIds = '';
    for(Id i : sUpIds)
      strIds = strIds + ', ' + i;
    //Write email code to update the Admin about the batch completion and status 
     AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
    TotalJobItems, CreatedBy.Email
    FROM AsyncApexJob WHERE Id =
    :BC.getJobId()];
    // Send an email to the Apex job's submitter notifying of job completion.
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String[] toAddresses = new String[] {a.CreatedBy.Email};
    mail.setToAddresses(toAddresses);
    mail.setSubject('Apex Sharing Recalculation ' + a.Status);
   
    if( a.NumberOfErrors ==0)
    {
        mail.setPlainTextBody ('The batch Apex job processed ' + a.TotalJobItems +
        ' batches with '+ a.NumberOfErrors + ' failures.'+ 'Now Go back To your Global Dealer Program to and create a new List view in order to view the Newly created Global Dealer Program');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    else
    {
        mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +
        ' batches with '+ a.NumberOfErrors + ' failures.');
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
    }       
  }
/*** END FINISH ***/  
}//END CLASS Batch_Update_Parent_Metrics_v2_1