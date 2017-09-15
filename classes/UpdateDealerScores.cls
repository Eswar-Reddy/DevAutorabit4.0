global class UpdateDealerScores implements Database.batchable <sObject>
{ 
    global String query;
    global String email;
    global List<Account> accns = new List<Account>();
    global Set <Id> accnIds = new Set <Id>();
    global Boolean deleteJobResults = true;
    
    global Database.querylocator start(Database.BatchableContext BC)
    {
        system.debug('@@@@@UpdateDealerScores.start (SOQL): Aggregate for fieldCategories');
        List <AggregateResult> fieldCategories = new List <AggregateResult>([SELECT Field_Name__c, Filter_Field__c, MAX(Score_Value__c) maxScore FROM Dealer_Scoring__c GROUP BY Field_Name__c, Filter_Field__c]);
        String queryFields = '';
        
        for(AggregateResult fc : fieldCategories)
        {
            String fieldName = string.valueOf(fc.get('Field_Name__c'));
            String filterField = string.valueOf(fc.get('Filter_Field__c'));
            
            if(!queryFields.contains(fieldName))
            {
                queryFields += ', ' + fieldName;
                if(filterField != null && !queryFields.contains(filterField))
                {
                    queryFields += ', ' + filterField;
                }
                
            }
        }
        
        system.debug('@@@@@UpdateDealerScores.start (SOQL): Aggregate for recTypeId');                
        Id recTypeId = [Select Id From RecordType  Where SobjectType = 'Account' and DeveloperName = 'Partner'][0].Id;
        
        query = 'SELECT Id, RSM_Discretionary_Adj__c, Dealer_Score_Percent__c, Dealer_Score_Summary__c, Dealer_Score_Total__c' + queryFields + ' FROM Account WHERE RecordTypeId = :recTypeId AND (Type like \'%Partner-Residential%\' OR Type like \'%Partner-Combo%\') AND Theater__c IN (\'North America\',\'Europe\',\'Central America and the Caribbean\')';
        
        if(deleteJobResults)
        {    
            List <Job_Result__c> jrs = new List <Job_Result__c>();
            
            system.debug('@@@@@UpdateDealerScores.start (SOQL): Aggregate for jrs');
            jrs = [SELECT Id FROM Job_Result__c];
            
            delete jrs;
        }
        
        DealerGeneral__c dg = DealerGeneral__c.getInstance();
        if(test.isRunningTest())
        {
            query += ' LIMIT 1';
        }
        else
        if (dg.Enable_ALR_Dealer_Scoring__c == false) query += ' LIMIT 0';
        
        system.debug('@@@@@ query: ' + query);
        system.debug('@@@@@UpdateDealerScores.start (SOQL): Aggregate for query');
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope)
    {   
        DealerGeneral__c dg = DealerGeneral__c.getInstance();
        if (dg.Enable_ALR_Dealer_Scoring__c == false) return;
        
        for(Account a : scope)
        {
            accns.add(a);
            //accnIds.add(a.Id);
        }
        try
        {
            //CalculateDealerRollups.calculateRollupsInsert_Acct(accnIds);
            CalculateDealerScore cds = new CalculateDealerScore();
            cds.accountList = accns;
            cds.calculateScoresInsert(); 
        }
        catch (exception e)
        {
            Job_Result__c jr = new Job_Result__c();
            jr.Result__c = 'The following accounts failed to update: ' + accns;
            jr.Result__c += ' Error: ' + e.getMessage();
            insert jr;
        }
        
    }
    
    global void finish(Database.BatchableContext BC)
    {
    
    }
}