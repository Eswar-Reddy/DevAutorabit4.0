global class UpdateDealerOpportunityScores implements Database.batchable <sObject>
{ 
    global datetime d180days = system.now().addDays(-180);
    global String query;
    global String email;
    
    global Database.querylocator start(Database.BatchableContext BC)
    {
        List <RecordType> recTypes = new List <RecordType>();
        recTypes = [SELECT Id, DeveloperName, sObjectType FROM RecordType];
        Id oppRecTypeId;
        Id accRecTypeId;
        if(!recTypes.isEmpty())
        {
            for(RecordType rt : recTypes)
            {
                if(rt.DeveloperName == 'Home_Owner' && rt.sObjectType == 'Opportunity') oppRecTypeId = rt.Id;
                if(rt.DeveloperName == 'Partner' && rt.sObjectType == 'Account') accRecTypeId = rt.Id;
            }
        }
        query = 'SELECT Id FROM Opportunity WHERE Lead_Manufacturer__c = \'SunPower\' AND RecordTypeId = :oppRecTypeId AND CreatedDate >= :d180days AND Partner_Account_Id__r.RecordTypeId = :accRecTypeId AND Partner_Account_Id__r.Theater__c IN (\'North America\',\'Europe\',\'Central America and the Caribbean\')';
        List <Job_Result__c> jrList = new List <Job_Result__c>();
        
        system.debug('@@@@@UpdateDealerOpportunityScores.start (SOQL): Aggregate for jrList');
        jrList = [SELECT Id FROM Job_Result__c];
        delete jrList;
        
        DealerGeneral__c dg = DealerGeneral__c.getInstance();
        if(test.isRunningTest())
        {
            query += ' LIMIT 200';
        }
        else
        if (dg.Enable_ALR_Dealer_Scoring__c == false) query += ' LIMIT 0';
        system.debug('@@@@@UpdateDealerOpportunityScores.start (SOQL): Aggregate for query');
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope)
    {   
        DealerGeneral__c dg = DealerGeneral__c.getInstance();
        if (dg.Enable_ALR_Dealer_Scoring__c == false) return;
        
        Set <Id> oppIds = new Set <Id>();
        List <Opportunity> opportunitiesWithHistory = new List <Opportunity>();
        
        for(Opportunity o : scope)
        {
            oppIds.add(o.Id);
        }
        
        system.debug('@@@@@UpdateDealerOpportunityScores.execute (SOQL): Aggregate for opportunitiesWithHistory');
        opportunitiesWithHistory = [SELECT Id, Name, Account.Name, CreatedDate, Pass_SLA__c, SFDC_Timely_Updates__c, SFDC_Timely_Update_Stages__c, StageName, Type, Lead_Manufacturer__c, Dealer_Assignment_Date__c, (SELECT OpportunityId, CreatedDate, StageName FROM OpportunityHistories) FROM Opportunity WHERE Id IN :oppIds];
        
        for(Opportunity o : opportunitiesWithHistory)
        {
            String stages = '';
            Datetime assignDate = o.Dealer_Assignment_Date__c;
            if(assignDate == null) assignDate = o.CreatedDate;
            
            //system.debug('@@@@@ Opp: ' + o);
            stages += ';'+o.StageName;
            
            
            for(OpportunityHistory ofh : o.OpportunityHistories)
            {
                //system.debug('@@@@@ History: ' + ofh);

                if(!stages.contains(string.valueOf(ofh.StageName)) && assignDate >= ofh.CreatedDate.addDays(-180))
                {
                    stages += ';'+ofh.StageName;
                }
            }
            //system.debug('@@@@@ Stage Variable Value: ' + stages);
            o.SFDC_Timely_Update_Stages__c = stages;
            if(o.Dealer_Assignment_Date__c == null) o.Dealer_Assignment_Date__c = o.CreatedDate;
            //system.debug('@@@@@ SFDC Timely Updates Set to: ' + o.SFDC_Timely_Update_Stages__c);
        }
        
        try
        {
            Database.saveResult [] srList = database.update(opportunitiesWithHistory, false);
            
            List <Job_Result__c> jobresults = new List <Job_Result__c>();
            
            Integer rowIndex = 0;
            
            for (Database.SaveResult sr : srList) 
            {
                if (sr.isSuccess()) 
                {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully updated opportunity. Opportunity ID: ' + sr.getId());
                }
                else 
                {
                    
                    
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) 
                    {
                        Job_Result__c jr = new Job_Result__c();
                        jr.Result__c = 'UpdateDealerOpportunityScores failed for Opportunity Id: ' + opportunitiesWithHistory[rowIndex].Id + ' - ' + err.getStatusCode() + ': ' + err.getMessage();
                        jobresults.add(jr);                        
                    }
                }
                
                rowIndex += 1;
            }
            
            try
            {
                insert jobresults;
            }
            catch(exception e)
            {
            
            }
        }
        catch(exception e)
        {
            Job_Result__c jr = new Job_Result__c();
            jr.Result__c = e.getMessage();
            insert jr;
        }           
    }
    
    global void finish(Database.BatchableContext BC)
    {
        if(!test.isRunningTest())
        {
            updateDealerScoreRollups udsr = new updateDealerScoreRollups();
            udsr.deleteJobResults = false;
            udsr.scheduledUpdate = false;
            database.executeBatch(udsr,1);
        }
    }
}