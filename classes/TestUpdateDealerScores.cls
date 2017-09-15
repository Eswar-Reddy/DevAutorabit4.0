@IsTest (SeeAllData=true)
public with sharing class TestUpdateDealerScores {
    
    static testMethod void testUpdateDealerScores() 
    {       
        
        UpdateDealerScores b = new UpdateDealerScores();
        
        Test.startTest();
        
        Id batchProcessId = Database.executeBatch(b);
        
        Test.stopTest();

    }
    
    static testMethod void testUpdateDealerScoreRollups() 
    {       
    
        SFDCSpecialUtilities.isRunningTest = true;
        
        UpdateDealerOpportunityScores b = new UpdateDealerOpportunityScores();
        
        Test.startTest();
        
        Id batchProcessId = Database.executeBatch(b);
        
        Test.stopTest();


    }
    
    static testMethod void testUpdateDealerOpportunityScores() 
    {       
    
        SFDCSpecialUtilities.isRunningTest = true;
        
        UpdateDealerOpportunityScores b = new UpdateDealerOpportunityScores();
        
        Test.startTest();
        
        Id batchProcessId = Database.executeBatch(b);
        
        Test.stopTest();


    }
    static testMethod void testInsertScoreSetting()
    {
        List <Score_Setting__c> ssList = new List <Score_Setting__c>();
        
        Score_Setting__c dsNumGreatThanEqual = new Score_Setting__c();
        dsNumGreatThanEqual.Field_Name__c = 'AccountNumber';
        dsNumGreatThanEqual.Field_Value__c = '100';
        dsNumGreatThanEqual.Field_Label__c = 'Account Number';
        dsNumGreatThanEqual.Calculation_Type__c = 'Number';
        dsNumGreatThanEqual.Operator__c = 'Greater than or equal to';
        dsNumGreatThanEqual.Score_Value__c = 30;
        ssList.add(dsNumGreatThanEqual);
                
        test.startTest();
        
        insert ssList;
        
        test.stopTest();        
    }     
    
    
    static testMethod void testUpdateScoreSetting()
    {
        List <Score_Setting__c> ssList = new List <Score_Setting__c>();
        
        Score_Setting__c dsNumGreatThanEqual = new Score_Setting__c();
        dsNumGreatThanEqual.Field_Name__c = 'AccountNumber';
        dsNumGreatThanEqual.Field_Value__c = '100';
        dsNumGreatThanEqual.Field_Label__c = 'Account Number';
        dsNumGreatThanEqual.Calculation_Type__c = 'Number';
        dsNumGreatThanEqual.Operator__c = 'Greater than or equal to';
        dsNumGreatThanEqual.Score_Value__c = 30;
        ssList.add(dsNumGreatThanEqual);
                
        insert ssList;
        
        test.startTest();
        
        ssList[0].Score_Value__c = 20;
        
        update ssList;
        
        test.stopTest();        
    }        
    
    static testMethod void testInsertAccount()
    {
        List <Account> testInsertAccounts = new List <Account>();
        for(Integer i = 0; i<1; i++)
        {
            Account acct = new Account();
            acct.Name = 'Test12346956564' + string.valueOf(i);
            acct.Type = 'Elite-Partner-Residential';
            acct.RSM_Discretionary_Adj__c = 5;
            acct.AccountNumber = string.valueOf(i)+'00';
            acct.BillingCity = 'Test City';
            acct.BillingStreet = i + ' Main Street';
            acct.BillingState = 'AZ';
            acct.BillingCountry = 'United States';
            acct.BillingPostalCode = '12345';
            acct.Opp_Convert_Rate__c = 70;
            testInsertAccounts.add(acct);
        }
        
        test.startTest();
        insert testInsertAccounts;
        
        testInsertAccounts[0].BillingStreet = 'Test Street';
        
        update testInsertAccounts;
        test.stopTest();
        
    }
    
    static testMethod void testLeadFlowOptInOut()
    {
        Account acct = new Account();
        acct.Name = 'Test123456888999';
        acct.Type = 'Elite-Partner-Residential';
        acct.RSM_Discretionary_Adj__c = 5;
        acct.BillingCity = 'Test City';
        acct.BillingStreet = 'Main Street';
        acct.BillingState = 'AZ';
        acct.BillingCountry = 'United States';
        acct.BillingPostalCode = '12345';
        acct.Opp_Convert_Rate__c = 70;
        insert acct;
        
        Id lsrRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Partner_Lead_Routing' AND sObjectType = 'Account_Approvals__c'][0].Id;
        Id daRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Dealer_Score_Adjustment' AND sObjectType = 'Account_Approvals__c'][0].Id;
        
        List <Account_Approvals__c> aaList = new List <Account_Approvals__c>();
        Account_Approvals__c aa1 = new Account_Approvals__c();
        aa1.Status__c = 'Pending';
        aa1.Account__c = acct.Id;
        aa1.RecordTypeId = lsrRecTypeId;
        aaList.add(aa1);
        
        Account_Approvals__c aa2 = new Account_Approvals__c();
        aa2.Status__c = 'Pending';
        aa2.Account__c = acct.Id;
        aa2.RecordTypeId = daRecTypeId;
        aaList.add(aa2);
        
        test.startTest();
        
        insert aaList;
        
        for(Account_Approvals__c aa : aaList)
        {
            aa.Status__c = 'Approved';
        }
        
        update aaList;
        
        test.stopTest();
    }
}