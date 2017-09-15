/*** TestClass added in Sunpower TPO Phase 1 -- 20/10/2013, to cover New Code QuoteManagement class ***/
@isTest(seeAllData = true)
public class TestQuoteManagementTPO{
    static testMethod void testQuoteManagementTPO(){
        //Profile p = [SELECT Id FROM Profile WHERE Name='system administrator']; 
        //User u = [select id from User where ProfileId =: p.Id and IsActive=true and Country_Domain__c='rvar-fr' limit 1];
        
         /*** [START] RA 20.MAY.2015 - created test user to avoid errors in query encountered on every deployment ***/ 
        User Usr = new User(
          Username = 'testxxx@sunpower.com',
          LastName = 'xxxx', 
          Email = 'testxxx@sunpower.com', 
          Alias = 'testxxx', 
          CommunityNickname = 'testxxxx',
          TimeZoneSidKey = 'America/Los_Angeles', 
          LocaleSidKey = 'en_US', 
          Country_Domain__c='rvar-fr',
          IsActive=true,
          EmailEncodingKey = 'ISO-8859-1', 
          ProfileId = ([select Id from Profile where name = 'System Administrator'])[0].id, 
          LanguageLocaleKey = 'en_us');

        /*** [END] RA 20.MAY.2015 ***/ 

        Account acc = new Account();
        acc.Name = 'Test AccountQuote';
        acc.Type ='Home Owner';
        acc.BillingCity = 'Cassis';
        acc.BillingStreet = 'Cassis';
        acc.BillingPostalCode ='13260';
        acc.BillingCountry = 'France'; 
        acc.Country_Domain__c = 'rvar-fr';
        
        insert acc;
        
        //create Contact
        Contact con;
        con = TestUtils.createContact( 'testcon', acc.id, false);
        con.Phone = '22 33 44 55 66';
        insert con;
    
         //create Item
        Item__c newItem = new Item__c();
        newItem = [select id,Item_ID__c from Item__c where Item_ID__c=:'125565'];
        
        //Create Opportunity
        Opportunity newOpportunity;
        newOpportunity = TestUtils.createOpportunities( 1, acc.id, con.id, false).get(0);
        insert newOpportunity;
        
        //Create TPOMPPT
        TPO_MPPT__c  newMppt = new TPO_MPPT__c ();
            newMppt.DC_Cabinet__c = 3.0;
            newMppt.Module_Name__c = '245W (Model SPR-245NE-WHT-D)';        
            newMppt.Module_Quantity__c = 37.0;
            newMppt.Item_ID__c = 125565.0;
            newMppt.Inverter_Quantity__c = 1.0;
            newMppt.Inverter_Name_1__c = 'SPR-3600P-TL1-EU';
            newMppt.Inverter_Name_2__c = 'SPR-4200P-TL1-EU';
            newMppt.MPPT_1_Module_Qty__c = 16.0;
            newMppt.MPPT_1_String_Qty__c = 2.0;
            newMppt.MPPT_2_Module_Qty__c = 2.0;
            newMppt.MPPT_2_String_Qty__c = 1.0;
            newMppt.MPPT_3_Module_Qty__c = 10.0;
            newMppt.MPPT_3_String_Qty__c = 1.0;
            newMppt.MPPT_4_Module_Qty__c = 9.0;
            newMppt.MPPT_4_String_Qty__c = 1.0;
            newMppt.Surface__c = 43.88;
            newMppt.Wats_Power__c = 4000.0;
        insert newMppt;
        
        Quote newQuote = new Quote();
            newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test', newOpportunity.Id, false).get(0);        
            newQuote.Module_Oracle_Item_Number__c = newItem.id;
            newQuote.System_Model__c = '245W (Model SPR-245NE-WHT-D)';
        insert newQuote;
            
            newQuote.Modules_Per_String_Roof1__c = 37.0;
            newQuote.Modules_Per_String_Roof2__c = 37.0;
            newQuote.Modules_Per_String_Roof3__c = 37.0; 
            newQuote.Modules_Per_String_Roof4__c = 37.0;
        update newQuote;
    }
    
     static testMethod void testQuoteManagementTPO1(){
        
        //Profile p = [SELECT Id FROM Profile WHERE Name='system administrator']; 
        //User u = [select id from User where ProfileId =: p.Id and IsActive=true and Country_Domain__c='rvar-fr' limit 1];
        
        /*** [START] RA 20.MAY.2015 - created test user to avoid errors in query encountered on every deployment ***/ 
        User Usr = new User(
          Username = 'testxxx@sunpower.com',
          LastName = 'xxxx', 
          Email = 'testxxx@sunpower.com', 
          Alias = 'testxxx', 
          CommunityNickname = 'testxxxx',
          TimeZoneSidKey = 'America/Los_Angeles', 
          LocaleSidKey = 'en_US', 
          Country_Domain__c='rvar-fr',
          IsActive=true,
          EmailEncodingKey = 'ISO-8859-1', 
          ProfileId = ([select Id from Profile where name = 'System Administrator'])[0].id, 
          LanguageLocaleKey = 'en_us');

        /*** [END] RA 20.MAY.2015 ***/ 

        Account acc = new Account();
        acc.Name = 'Test AccountQuote';
        acc.Type ='Home Owner';
        acc.BillingCity = 'Cassis';
        acc.BillingStreet = 'Cassis';
        acc.BillingPostalCode ='13260';
        acc.BillingCountry = 'France'; 
        acc.Country_Domain__c = 'rvar-fr';
        
        insert acc;
        
        //create Contact
        Contact con;
        con = TestUtils.createContact( 'testcon', acc.id, false);
        con.Phone = '22 33 44 55 66';
        insert con;
    
         //create Item
        Item__c newItem = new Item__c();
        newItem = [select id,Item_ID__c from Item__c where Item_ID__c=:'125565'];
        
        //Create Opportunity
        Opportunity newOpportunity;
        newOpportunity = TestUtils.createOpportunities( 1, acc.id, con.id, false).get(0);
        insert newOpportunity;
       
        TPO_MPPT__c  newMppt = new TPO_MPPT__c ();
            newMppt.DC_Cabinet__c = 3.0;
            newMppt.Module_Name__c = '245W (Model SPR-245NE-WHT-D)';        
            newMppt.Module_Quantity__c = 37.0;
            newMppt.Item_ID__c = 125565.0;
            newMppt.Inverter_Quantity__c = 1.0;
            newMppt.Inverter_Name_1__c = 'SPR-3600P-TL1-EU';
            newMppt.Inverter_Name_2__c = 'SPR-4200P-TL1-EU';
            newMppt.MPPT_1_Module_Qty__c = 16.0;
            newMppt.MPPT_1_String_Qty__c = 2.0;
            newMppt.MPPT_2_Module_Qty__c = 2.0;
            newMppt.MPPT_2_String_Qty__c = 1.0;
            newMppt.MPPT_3_Module_Qty__c = 10.0;
            newMppt.MPPT_3_String_Qty__c = 1.0;
            newMppt.MPPT_4_Module_Qty__c = 9.0;
            newMppt.MPPT_4_String_Qty__c = 1.0;
            newMppt.Surface__c = 43.88;
            newMppt.Wats_Power__c = 4000.0;
        insert newMppt;
        
       Quote newQuote1 = new Quote();
            newQuote1 = TestUtils.createQuotes( 1, 'Quick Quote Test1', newOpportunity.Id, false).get(0);        
            newQuote1.Module_Oracle_Item_Number__c = newItem.id;
            newQuote1.System_Model__c = '245W (Model SPR-245NE-WHT-D)';
            newQuote1.Modules_Per_String_Roof1__c = 37.0;
        insert newQuote1;
            newQuote1.Modules_Per_String_Roof1__c = null;           
        update newQuote1;   
   
    }
}