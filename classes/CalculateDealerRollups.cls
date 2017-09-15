public without sharing class CalculateDealerRollups 
{
    
    public static void calculateRollupsInsert(List<Opportunity> newOpps)
    {
        Set<Id> accountIds = new Set <Id>();
        for(Opportunity o : newOpps)
        {
            accountIds.add(o.Partner_Account_Id__c);
        }
        
        if (!accountIds.isEmpty()) calculateRollupsInsert_Acct(accountIds);
    }
    
    
    public static void calculateRollupsInsert_Acct(Set<Id> accountIds)
    {
        // Added by Ganesh Chedella for Case Number 527135
        // Creating a string List of reasons for Reason Won/Lost to be excluded from the impact list which are in Custom Settings
        List<OpportunityLostReasons__c> lostReasons = OpportunityLostReasons__c.getAll().values();
        List<String> reasonsList = new List<String>();
        for(OpportunityLostReasons__c olr : lostReasons){
            reasonsList.add(olr.Name);
        }

        Map <Id, Decimal> oppWonCountMap = new Map <Id, Decimal>();
        Map <Id, Decimal> oppTotalCountMap = new Map <Id, Decimal>();
        Map <Id, Decimal> oppSLAPassCountMap = new Map <Id, Decimal>();
        Map <Id, Decimal> oppSLAFailCountMap = new Map <Id, Decimal>();
        Map <Id, Decimal> avgTimelyUpdatesMap = new Map <Id, Decimal>();
        Date d365 = system.today().addDays(-365);
        Date d180 = system.today().addDays(-180);
        Date d120 = system.today().addDays(-120);
        Date d090 = system.today().addDays(-90);
        Date d060 = system.today().addDays(-60);
        datetime d46min = system.now().addMinutes(-46);
        
        /*
        List <RecordType> recTypes = new List <RecordType>();
        system.debug('@@@@@CalculateDealerRollups.calculateRollupsInsert_Acct (SOQL): Aggregate for recTypes');
        recTypes =[SELECT Id FROM RecordType WHERE DeveloperName = 'Home_Owner' AND sObjectType = 'Opportunity'];
        Id hoOppRecTypeId;
        if(!recTypes.isEmpty())
        {
           hoOppRecTypeId = recTypes[0].Id;
        }
        */
        
        Id hoOppRecTypeId;
        if(SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Opportunity.SobjectType).containsKey('Home_Owner'))
	    {
	    	hoOppRecTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Opportunity.SobjectType).get('Home_Owner');
	    }
	    else
	    {
	    	//SunPowerException.recordError('CalculateDealerRollups', 'calculateRollupsInsert_Acct', 'No Home Owner Opportunity Record Type Found');
	    	return;
	    }
	    
        List <AggregateResult> oppWonCount = [SELECT Partner_Account_Id__c, COUNT(Id) oppCount
                                                    FROM Opportunity
                                                   WHERE Partner_Account_Id__c IN :accountIds 
                                                     AND IsWon = true
                                                     AND CreatedDate >= :d365
                                                     AND Dealer_Assignment_Date__c >= :d090
                                                     AND Lead_Manufacturer__c = 'SunPower'
                                                     AND RecordTypeId = :hoOppRecTypeId
                                                GROUP BY Partner_Account_Id__c
                                                  HAVING COUNT(Id) > 0];

        List <AggregateResult> oppTotalCount = [SELECT Partner_Account_Id__c, COUNT(Id) oppCount
                                                    FROM Opportunity
                                                   WHERE Partner_Account_Id__c IN :accountIds AND Reason_Won_Lost__c  NOT IN :reasonsList
                                                     AND CreatedDate >= :d365
                                                     AND Dealer_Assignment_Date__c >= :d090
                                                     AND Lead_Manufacturer__c = 'SunPower'
                                                     AND RecordTypeId = :hoOppRecTypeId
                                                GROUP BY Partner_Account_Id__c
                                                  HAVING COUNT(Id) > 0];
                                         
        List <AggregateResult> oppSLAPassCount = [SELECT Partner_Account_Id__c, COUNT(Id) oppCount
                                                    FROM Opportunity
                                                   WHERE Partner_Account_Id__c IN :accountIds AND Reason_Won_Lost__c  NOT IN :reasonsList
                                                     AND Pass_SLA__c = 'Pass'
                                                     AND CreatedDate >= :d365
                                                     AND Dealer_Assignment_Date__c >= :d090
                                                     AND Lead_Manufacturer__c = 'SunPower'
                                                     AND RecordTypeId = :hoOppRecTypeId
                                                     AND Is_Excluded_from_SLA_Score__c = FALSE
                                                GROUP BY Partner_Account_Id__c
                                                  HAVING COUNT(Id) > 0];                                   
        List <AggregateResult> oppSLAFailCount = [SELECT Partner_Account_Id__c, COUNT(Id) oppCount
                                                    FROM Opportunity
                                                   WHERE Partner_Account_Id__c IN :accountIds AND Reason_Won_Lost__c  NOT IN :reasonsList
                                                     AND Pass_SLA__c = 'Fail'
                                                     AND CreatedDate >= :d365
                                                     AND Dealer_Assignment_Date__c >= :d090
                                                     AND Dealer_Assignment_Date__c < :d46min
                                                     AND Lead_Manufacturer__c = 'SunPower'
                                                     AND RecordTypeId = :hoOppRecTypeId
                                                     AND Is_Excluded_from_SLA_Score__c = FALSE
                                                GROUP BY Partner_Account_Id__c
                                                  HAVING COUNT(Id) > 0]; 
                                      
        List <AggregateResult> avgTimelyUpdates = [SELECT Partner_Account_Id__c, AVG(SFDC_Timely_Updates__c) oppAvg
                                                    FROM Opportunity
                                                   WHERE Partner_Account_Id__c IN :accountIds AND Reason_Won_Lost__c  NOT IN :reasonsList
                                                     AND CreatedDate >= :d365
                                                     //Changed by Debasish starts 10/13/2016 Pivotal#128347213 Case #00751852
                                                     //AND Dealer_Assignment_Date__c >= :d180
                                                     AND Dealer_Assignment_Date__c >= :d090
                                                     //AND Dealer_Assignment_Date__c <= :d060
                                                     AND Dealer_Assignment_Date__c <= :system.today()
                                                     //Changed by Debasish ends 10/13/2016 Pivotal#128347213 Case #00751852
                                                     AND Lead_Manufacturer__c = 'SunPower'
                                                     AND RecordTypeId = :hoOppRecTypeId
                                                GROUP BY Partner_Account_Id__c
                                                  HAVING COUNT(Id) > 0];          
        
        for(AggregateResult owCnt : oppWonCount)
        {
            try
            {
                oppWonCountMap.put(string.valueof(owCnt.get('Partner_Account_Id__c')), Decimal.valueOf(double.valueOf(owCnt.get('oppCount'))));
            }
            catch (system.nullPointerException e)
            {
                oppWonCountMap.put(string.valueof(owCnt.get('Partner_Account_Id__c')), 0.0);
            }
        }
        
        for(AggregateResult onwCnt : oppTotalCount)
        {
            try
            {
                oppTotalCountMap.put(string.valueOf(onwCnt.get('Partner_Account_Id__c')), Decimal.valueOf(double.valueOf(onwCnt.get('oppCount'))));
            }
            catch (system.nullPointerException e)
            {
                oppTotalCountMap.put(string.valueOf(onwCnt.get('Partner_Account_Id__c')), 0.0);
            }
        }
        
        for(AggregateResult oslapCnt : oppSLAPassCount)
        {
            try
            {
                oppSLAPassCountMap.put(string.valueof(oslapCnt.get('Partner_Account_Id__c')), Decimal.valueOf(double.valueOf(oslapcnt.get('oppCount'))));
            }
            catch (system.nullPointerException e)
            {
                oppSLAPassCountMap.put(string.valueof(oslapCnt.get('Partner_Account_Id__c')), 0.0);
            }
        }
        
        for(AggregateResult oslafCnt : oppSLAFailCount)
        {
            try
            {
                oppSLAFailCountMap.put(string.valueOf(oslafCnt.get('Partner_Account_Id__c')), Decimal.valueOf(double.valueOf(oslafCnt.get('oppCount'))));
            }
            catch (system.nullPointerException e)
            {
                oppSLAFailCountMap.put(string.valueOf(oslafCnt.get('Partner_Account_Id__c')), 0.0);
            }
        }
        
        for(AggregateResult avgTU : avgTimelyUpdates)
        {
            try
            {
                avgTimelyUpdatesMap.put(string.valueof(avgTU.get('Partner_Account_Id__c')), Decimal.valueOf(double.valueOf(avgTU.get('oppAvg'))));
            }
            catch (system.nullPointerException e)
            {
                avgTimelyUpdatesMap.put(string.valueof(avgTU.get('Partner_Account_Id__c')), 0.0);
            }
        }
        
        List <Account> accountsToUpdate = new List <Account>([SELECT Id, Opp_Convert_Rate__c, Contact_SLA__c, SFDC_Timely_Updates__c FROM Account WHERE Id IN :accountIds]);
        
        for(Account a : accountsToUpdate)
        {
            Decimal wonCount = oppWonCountMap.get(a.Id);
            Decimal totalCount = oppTotalCountMap.get(a.Id);
            
            if(string.isBlank(string.valueOf(wonCount)))
            {
                wonCount = 0;
            }
                        
            if(string.isBlank(string.valueOf(totalCount)))
            {
                totalCount = 0;
            }
            
            Decimal percentOppConvert = 0;
            if(totalCount != 0)
            {
                percentOppConvert = wonCount.divide(totalCount, 5)*100;
            }
            
            Decimal passCount = oppSLAPassCountMap.get(a.Id);
            Decimal failCount = oppSLAFailCountMap.get(a.Id);
            if(string.isBlank(string.valueOf(passCount)))
            {
                passCount = 0;
            }
                
            if(string.isBlank(string.valueOf(failCount)))
            {
                failCount = 0;  
            }
            
            Decimal totalOppSLACount = passCount + failCount;
            Decimal percentOppSLA = 0;
            if(totalOppSLACount != 0)
            {
                percentOppSLA = passCount.divide(totalOppSLACount, 5)*100;
            }
            
            Decimal averageUpdate = avgTimelyUpdatesMap.get(a.Id);
            if(string.isBlank(string.valueOf(averageUpdate)))
            {
                averageUpdate = 0;
            }
            
            a.Opp_Convert_Rate__c = percentOppConvert;
            a.Contact_SLA__c = percentOppSLA;
            a.SFDC_Timely_Updates__c = averageUpdate;  
        }
        
        Database.saveResult [] srList = database.update(accountsToUpdate, false);
        
        List <Job_Result__c> jobresults = new List <Job_Result__c>();
        
        Integer rowIndex = 0;
        
        for (Database.SaveResult sr : srList) 
        {
            if (sr.isSuccess()) 
            {
                // Operation was successful, so get the ID of the record that was processed
            }
            else 
            {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) 
                {
                    Job_Result__c jr = new Job_Result__c();
                    jr.Result__c = 'CalculateDealerRollups failed for Account Id: ' + accountsToUpdate[rowIndex].Id + ' - ' + err.getStatusCode() + ': ' + err.getMessage();
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
}