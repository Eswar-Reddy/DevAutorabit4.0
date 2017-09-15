@isTest
public class testCalculateDealerScoreTrigger{
    
    static testMethod void insertScoreSetting()
    {
        Profile p = [select id from profile where name='System Administrator'];
        User u = new User(alias = 'utest', email='unit.test@unit.test.com',
        emailencodingkey='UTF-8', lastname='Unit Test', 
        languagelocalekey='en_US',
        localesidkey='en_GB', profileid = p.Id,
        timezonesidkey='Europe/London', 
        username='unit.test12345688899@unit.test.com');
        
        system.runAs(u)
        {
            List <Score_Setting__c> scoreSettings = new List <Score_Setting__c>();
            for(Integer i = 0; i<1; i++)
            {
                Score_Setting__c dsText = new Score_Setting__c();
                dsText.Field_Name__c = 'Type';
                dsText.Field_Value__c = 'Elite-Partner-Residential';
                dsText.Field_Label__c = 'Type';
                dsText.Calculation_Type__c = 'Text';
                dsText.Score_Value__c = 20;
                scoreSettings.add(dsText);
                
                Score_Setting__c dsPct = new Score_Setting__c();
                dsPct.Field_Name__c = 'Opp_Convert_Rate__c';
                dsPct.Field_Label__c = 'Opp Convert Rate';
                dsPct.Calculation_Type__c = 'Percent';
                dsPct.Score_Value__c = 30;
                scoreSettings.add(dsPct);
                
                Score_Setting__c dsNumGreatThanEqual = new Score_Setting__c();
                dsNumGreatThanEqual.Field_Name__c = 'AccountNumber';
                dsNumGreatThanEqual.Field_Value__c = '100';
                dsNumGreatThanEqual.Field_Label__c = 'Account Number';
                dsNumGreatThanEqual.Calculation_Type__c = 'Number';
                dsNumGreatThanEqual.Operator__c = 'Greater than or equal to';
                dsNumGreatThanEqual.Score_Value__c = 30;
                scoreSettings.add(dsNumGreatThanEqual);
                
                Score_Setting__c dsNumGreatThan = new Score_Setting__c();
                dsNumGreatThan.Field_Name__c = 'AccountNumber';
                dsNumGreatThan.Field_Value__c = '200';
                dsNumGreatThan.Field_Label__c = 'Account Number';
                dsNumGreatThan.Calculation_Type__c = 'Number';
                dsNumGreatThan.Operator__c = 'Greater than';
                dsNumGreatThan.Score_Value__c = 30;
                scoreSettings.add(dsNumGreatThan);
                
                Score_Setting__c dsNumLessThanEqual = new Score_Setting__c();
                dsNumLessThanEqual.Field_Name__c = 'AccountNumber';
                dsNumLessThanEqual.Field_Value__c = '300';
                dsNumLessThanEqual.Field_Label__c = 'Account Number';
                dsNumLessThanEqual.Calculation_Type__c = 'Number';
                dsNumLessThanEqual.Operator__c = 'Less than or equal to';
                dsNumLessThanEqual.Score_Value__c = 30;
                scoreSettings.add(dsNumLessThanEqual);
                
                Score_Setting__c dsNumLessThan = new Score_Setting__c();
                dsNumLessThan.Field_Name__c = 'AccountNumber';
                dsNumLessThan.Field_Value__c = '400';
                dsNumLessThan.Field_Label__c = 'Account Number';
                dsNumLessThan.Calculation_Type__c = 'Number';
                dsNumLessThan.Operator__c = 'Less than';
                dsNumLessThan.Score_Value__c = 30;
                scoreSettings.add(dsNumLessThan);
                
                Score_Setting__c dsNumEquals = new Score_Setting__c();
                dsNumEquals.Field_Name__c = 'AccountNumber';
                dsNumEquals.Field_Value__c = '400';
                dsNumEquals.Field_Label__c = 'Account Number';
                dsNumEquals.Calculation_Type__c = 'Number';
                dsNumEquals.Operator__c = 'Equals';
                dsNumEquals.Score_Value__c = 30;
                scoreSettings.add(dsNumEquals);
                
                Score_Setting__c dsNumBetween = new Score_Setting__c();
                dsNumBetween.Field_Name__c = 'AccountNumber';
                dsNumBetween.Field_Value__c = '300;400';
                dsNumBetween.Field_Label__c = 'Account Number';
                dsNumBetween.Calculation_Type__c = 'Number';
                dsNumBetween.Operator__c = 'Between';
                dsNumBetween.Score_Value__c = 30;
                scoreSettings.add(dsNumBetween);
            }
            
            test.startTest();
            insert scoreSettings;
            test.stopTest();
        }
    }
    
    static testMethod void insertAccount()
    {
        Profile p = [select id from profile where name='System Administrator'];
        User u = new User(alias = 'utest', email='unit.test@unit.test.com',
        emailencodingkey='UTF-8', lastname='Unit Test', 
        languagelocalekey='en_US',
        localesidkey='en_GB', profileid = p.Id,
        timezonesidkey='Europe/London', 
        username='unit.test9870064562934@unit.test.com');
        
        system.runAs(u)
        {
            List <Account> testInsertAccounts = new List <Account>();
            
            for(Integer i = 0; i<1; i++)
            {
                Account acct = new Account();
                acct.Name = 'Test962345976' + string.valueOf(i);
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
            test.stopTest();
        }
    }
    
    static testMethod void calculateScore() {
        
        Profile p = [select id from profile where name='System Administrator'];
        User u = new User(alias = 'utest', email='unit.test@unit.test.com',
        emailencodingkey='UTF-8', lastname='Unit Test', 
        languagelocalekey='en_US',
        localesidkey='en_GB', profileid = p.Id,
        timezonesidkey='Europe/London', 
        username='unit.test2435087234500@unit.test.com');
        
        system.runAs(u)
        {
            
            List <Score_Setting__c> scoreSettings = new List <Score_Setting__c>();
            for(Integer i = 0; i<1; i++)
            {
                Score_Setting__c dsText = new Score_Setting__c();
                dsText.Field_Name__c = 'Type';
                dsText.Field_Value__c = 'Elite-Partner-Residential';
                dsText.Field_Label__c = 'Type';
                dsText.Calculation_Type__c = 'Text';
                dsText.Score_Value__c = 20;
                scoreSettings.add(dsText);
                
            }
            
            DealerGeneral__c dg = new DealerGeneral__c();
            dg.Email_Address_For_ALR_Alerts__c         = 'test@sunpowercorp.com';
            dg.Enable_ALR_Process__c                 = true;
            dg.Enforce_Agreement_Check_Dealer_Search__c   = false;
            dg.Google_Client_Id_Maps__c               = '';
            dg.Google_Private_key_Maps__c             = '';
            dg.Lead_Test_First_Name__c               = 'SPWR Test';
            
            List <Score_Setting__c> updateSettings = new List <Score_Setting__c>();
            for(Score_Setting__c ss : scoreSettings)
            {
                ss.Score_Value__c = 40;
                updateSettings.add(ss);
            }
            
            List <Account> testInsertAccounts = new List <Account>();
            List <Opportunity> testInsertOpportunities = new List <Opportunity>();
            for(Integer i = 0; i<1; i++)
            {
                Account acct = new Account();
                acct.Name = 'Test780234587024' + string.valueOf(i);
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
            insert dg;
            
            insert scoreSettings;
        
            insert testInsertAccounts;
        
            testInsertAccounts[0].BillingState = 'CO';
            
            update testInsertAccounts[0];
            
            update updateSettings;
        
            delete scoreSettings;
            
            test.stopTest();
        
        }
        
    }
}