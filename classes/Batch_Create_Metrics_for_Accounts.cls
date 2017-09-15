/**************** Batch Class To create the Metrics for every Account ************************/

global class Batch_Create_Metrics_for_Accounts implements Database.Batchable<sObject>
{
    /*******VARIABLES********/  
    //public List<Account> acct_ids = [SELECT id,Type,Country_Domain__c FROM Account WHERE RecordType.name='Partner' AND Type IN ('Partner-Commercial','Authorized-Partner-Combo','Authorized-Partner-Residential','Premier-Partner-Combo','Premier-Partner-Residential','Residential Installer','Elite-Partner-Combo','Elite-Partner-Residential')];                                                                                                    
    public List<Metrics__c> loMetrics = new List<Metrics__c>(); 
    public List<String> lst_ErrorMessages = new List<String>();
    public list<Account> acct_ids;
    List<String> lst_MetricInsertError = new list<String>();
    global final String query;
    /******END VARIABLES****/
    /******PROPERTY*******/
   global String prop_CurrentPeriod {get;set;} 
   global Integer prop_CurrentYear{get;set;}
   global List<Metric_Template__c> prop_lst_InsertedMetricTemplate {get;set;}
   global List<String> lstAccTypes{get;set;} 
   global List<String> lst_CountrySupp {get;set;}
   
   
    /******END PROPERTY *********/
    /******CONSTRUCTOR********/
    global Batch_Create_Metrics_for_Accounts()
    {
       
    }
    
    /*****END CONSTRUCTOR****/
    /*******START METHOD****/
    global database.querylocator start(Database.BatchableContext bc)
    {
        
        if(!Test.isRunningTest())
        {
            return Database.getQueryLocator([SELECT id,Type,Country_Domain__c,BillingCountry FROM Account WHERE RecordType.name='Partner' AND Type IN :splittingAccTypes(lstAccTypes,'',true) AND Status__c='Active' AND BillingCountry IN: splittingCountryDomain(lst_CountrySupp,'',true)]);                                                                                                    
         }
         else
         {
             return Database.getQueryLocator([SELECT id,Type,Country_Domain__c,BillingCountry FROM Account WHERE RecordType.name='Partner' AND Type IN :splittingAccTypes(lstAccTypes,'',true) AND Status__c='Active' AND BillingCountry IN: splittingCountryDomain(lst_CountrySupp,'',true) LIMIT 100]);                                                                                                    
            
         }   
         
    }
    /*****END START METHOD***/
    /*****EXECUTE METHOD****/
    global void execute(Database.BatchableContext bc, sObject[] objects)
    {
        acct_ids = new List<Account>();
 
        for(sObject s : objects)
        {
            Account a = (Account)s;
            acct_ids.add(a);
        }   
        
        InsertMetricsTable();
        
    }
    /*****END EXECUTE METHOD***/
    /***** FINISH ***********/
    global void finish(Database.BatchableContext bc)
    {
        
            BatchSchedule__c b = BatchSchedule__c.getOrgDefaults();
            DateTime n = datetime.now().addMinutes(2);
            String cron = '';
     
            cron += n.second();
            cron += ' ' + n.minute();
            cron += ' ' + n.hour();
            cron += ' ' + n.day();
            cron += ' ' + n.month();
            cron += ' ' + '?';
            cron += ' ' + n.year();
     
            b.scheduled_id__c = System.schedule('UpdateParent'+System.Now(), cron, new BatchScheduler_To_UpdateParentMetrics(prop_CurrentPeriod,prop_CurrentYear,splittingAccTypes(lstAccTypes,'',true),splittingCountryDomain(lst_CountrySupp,'',true)));
            if(!Test.isRunningTest())
            {
                update b;
            }
        
        
        // Get the ID of the AsyncApexJob representing this batch job
        // from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
        TotalJobItems, CreatedBy.Email
        FROM AsyncApexJob WHERE Id =
        :BC.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Apex Sharing Recalculation ' + a.Status);
        mail.setPlainTextBody
        ('The batch Apex job processed ' + a.TotalJobItems +
        ' batches with '+ a.NumberOfErrors + ' failures.'+ 'Please wait for the next batch to execute for updating the parent Metrics');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    /***** END FINISH *******/
    /***************************Method to insert the Metrics for all Partner Accounts*******************************/ 
  public void InsertMetricsTable()
  { 
    /*****Local varialbles*********/
    
    List<String> lst_MTAccountTypes = new List<String>();
    List<String> lst_MTCountrySupp = new List<String>();
    Integer i =0;
     
    List<Metric_Template__c> lst_MTAfterSplit = new List<Metric_Template__c>(); 
    /******End Local variables*********/
    
    /****** Loop to create metric rows for all Partner Accounts ********/  
    if(!acct_ids.isEmpty())
System.debug('#AccId '+ acct_ids);
     for(Account a: acct_ids) //Loop to create the Metric rows and add to the empty List 'lometrics'
     {  // checking for all Partner Types and Country Domain and retriving the respective Metric Templates
        System.debug('#1 '+lstAccTypes+'#2'+ a.Type  +'# 3'+lst_CountrySupp);
        if(lstAccTypes !=null && lst_CountrySupp != null)
        lst_MTAccountTypes = splittingAccTypes(lstAccTypes, a.Type ,false);
        lst_MTCountrySupp =  splittingCountryDomain(lst_CountrySupp, a.BillingCountry, false);
        
System.debug('MAccty'+lst_MTAccountTypes+'MCounSup'+lst_MTCountrySupp);


        if(lst_MTAccountTypes !=null && lst_MTCountrySupp!=null)
        {
            lst_MTAfterSplit = [SELECT id 
                              FROM Metric_Template__c 
                              WHERE Account_Type__c IN:lst_MTAccountTypes AND 
                              Countries_Supported__c IN: lst_MTCountrySupp AND 
                              Performance_Period__c=:prop_CurrentPeriod AND Performance_Year__c=:prop_CurrentYear AND id IN:prop_lst_InsertedMetricTemplate ];
System.debug('$Metric'+ lst_MTAfterSplit);                    

            if(!lst_MTAfterSplit.isEmpty())
            {                   
                for(Metric_Template__c mt : lst_MTAfterSplit)
                {
                    loMetrics.add(new Metrics__c(Account__c = a.id,
                                        External_Id__c = 'EX'+Math.random(), //Generating External Id
                                        Metric_Template__c= mt.id));
                }            
            }
             
        } //END IF
        else
        {
            lst_MetricInsertError.add('Error while splitting');
        }
     }  
     Database.SaveResult[] metricsSaveResult = Database.Insert(loMetrics);
    for(Database.SaveResult sr : metricsSaveResult)
    {       
        if (!sr.isSuccess()) 
        {
            Database.Error lst_err  = sr.getErrors()[i];
            lst_MetricInsertError.add('The following error has been occured'+lst_err.getMessage());
        }
        i++;
    }
  } //END FUNC InsertMetricsTable   
 /**************** function to split the account types************/
    public List<String> splittingAccTypes(List<String> ls, String a, Boolean flag)
    {   
    system.debug('\n@1');
        List<String> lst_MatchAccTypes = new List<String>();
    system.debug('\n@2');
        List<String> splString = new List<String>();
    system.debug('\n@3');
        Set<String> set_splAcc ;
    system.debug('\n@4');
        Set<String> set_Acctypes = new Set<String>();
    system.debug('\n@5');
        String acc = a;
    system.debug('\n@6');
        
        System.debug('#1 '+ls+'#2'+ acc +'# 3'+flag);
    system.debug('\n@7');
        if(!ls.isempty())
        for(String s : ls)
        {
            system.debug('\n@8');
            splString = s.split(', ');
            
            system.debug('split****'+splString);
            set_splAcc = new Set<String>(splString);
            system.debug('\n@9');
            if(acc <> '' && set_splAcc.contains(acc) && flag ==false)
            {
                system.debug('\n@10');
                lst_MatchAccTypes.add(s); 
            } 
            if(flag==true)
            {
                if(!set_splAcc.isEmpty())
                for(String cd : set_splAcc)
                    set_Acctypes.add(cd);
                    system.debug('\n@11');
            }
        }
        if(!lst_MatchAccTypes.isEmpty() && flag==false)
        {
            system.debug('matched****'+lst_MatchAccTypes);
            return lst_MatchAccTypes;
        }        
        else if(!set_Acctypes.isEmpty() && flag == true)
        {
            system.debug('\n@13');
            List<String> lstAccTypes = new List<String>(set_Acctypes);
            system.debug('\n@14');
            return lstAccTypes;
        }
        else 
        {
        system.debug('\n@15');
            return null;
        }
    } // END FUNC splitting
    public List<String> splittingCountryDomain(List<String> ls, String a , Boolean flag)
    {   
        List<String> lst_MatchCounSupp = new List<String>(); 
        List<String> splString = new List<String>();
        Set<String> set_splAcc;
        Set<String> set_CountrySupp = new Set<String>();
        String acc = a;
        
        System.debug('#1C '+ls+'#2C'+ acc +'# 3C'+flag);  
        
            for(String s : ls)
            {
                splString = s.split(', ');
                system.debug('split****'+splString);
                set_splAcc = new Set<String>(splString);
                if(acc <> '' && set_splAcc.contains(acc) && flag ==false)
                {
                    lst_MatchCounSupp.add(s);
                    system.debug('matched****'+lst_MatchCounSupp);
                }  
                if(flag==true)
                {
                    if(!set_splAcc.isEmpty())
                        for(String cd : set_splAcc)
                            set_CountrySupp.add(cd);
        System.debug('\n@set_splAcc'+set_splAcc+'\n@set_CountrySupp'+set_CountrySupp);
                }
            }
            if(!lst_MatchCounSupp.isEmpty() && flag==false)
            {
                return lst_MatchCounSupp;
            }
            else if(!set_CountrySupp.isEmpty() && flag == true)
            {
                List<String> lstCountrySupp = new List<String>(set_CountrySupp);
                return lstCountrySupp;
            }
            else 
            {
                return null;
            }
        } // END FUNC splitting
}// END class Batch_Create_Metrics_for_Accounts