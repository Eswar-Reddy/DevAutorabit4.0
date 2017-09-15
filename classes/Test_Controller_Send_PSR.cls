@isTest
private class Test_Controller_Send_PSR {
    
    //This test method covers following scenarios
    //1)Array_Layout__c = true and Design_Urgent_Request__c = true and PM_Cost__c = true
    //2)Array_Layout__c = false and Design_Urgent_Request__c = true and PM_Cost__c = true
    //3)Array_Layout__c = false and Design_Urgent_Request__c = false and PM_Cost__c = true
   static testMethod void testController_Send_PSR1(){

        //Quote quote = null;

        Opportunity oppty = new Opportunity();
        oppty.Name = 'TestOpp'; // 'Test class oppty for quote';
        oppty.StageName= 'Binding Offer';
        oppty.Closedate = System.today();
        insert oppty;

        //Opportunity insertedoppty = [select id,name from opportunity where name = 'TestOpp'];
        Quote quote = new Quote();
        quote.Name = 'Test quote';
        quote.Quote_Steps__c= 'TEst Array Layout';
        //quote.Quote_Status__c = 'Ordered';
        quote.opportunityid =oppty.id;
        insert quote;
        
        
        for (Quote currentQuote :
            [Select q.Quote_Steps__c, q.Id 
                From Quote q 
                where quote_steps__c like '%Array Layout' and Quote_Status__c !='Expired'
                order by CreatedDate DESC limit 1]){
        
            quote=currentQuote;
            
        }
        quote.Proposal_Due__c = Date.today().addMonths(3);
        update quote;
         
        //create a psr record
        PSR__c psr = new PSR__c();
        psr.Quote__c = quote.ID;
        psr.Array_Layout__c = true;
        psr.Design_Urgent_Request__c = true;
        psr.PM_Cost__c = true;
        psr.Product_Type__c = 'T-10';
        psr.Module_Type__c = 'SunPower 230';    
        psr.Requested_System_Size__c = 1000.00;
        insert psr;


        //create a psr record 
        PSR__c psr2 = new PSR__c();
        psr2.Quote__c = quote.ID;
        psr2.Array_Layout__c = false;
        psr2.Design_Urgent_Request__c = true;
        psr2.Array_Layout_Revision__c = true;
        psr2.PM_Cost__c = true;
        psr2.Product_Type__c = 'T-10';
        psr2.Module_Type__c = 'SunPower 230';       
        psr2.Requested_System_Size__c = 1000.00;
        //psr2.Kickoff_Meeting_Date__c = Date.today();//to cover condition PSR.Kickoff_Meeting_Date__c ==null
        insert psr2;

        //create a psr record
        PSR__c psr3 = new PSR__c();
        psr3.Quote__c = quote.ID;
        psr3.Array_Layout__c = false;
        psr3.Design_Urgent_Request__c = false;
        psr3.PM_Cost__c = true;
        psr3.Product_Type__c = 'T-10';
        psr3.Module_Type__c = 'SunPower 230';
        psr3.Requested_System_Size__c = 1000.00;            
        insert psr3;


        //instance of Standard Controller
        ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(psr);
        //instance of Controller_Send_PSR
        Controller_Send_PSR sendPSRController = new Controller_Send_PSR(stdctrl);
        //calling public methods
        sendPSRController.returnToPSR();
        sendPSRController.sendPSRAction();
        
        //instance of Standard Controller
        stdctrl = new Apexpages.Standardcontroller(psr2);
        //instance of Controller_Send_PSR
        sendPSRController = new Controller_Send_PSR(stdctrl);
        //calling public methods
        sendPSRController.returnToPSR();
        sendPSRController.sendPSRAction();
        
        //instance of Standard Controller
        stdctrl = new Apexpages.Standardcontroller(psr3);
        //instance of Controller_Send_PSR
        sendPSRController = new Controller_Send_PSR(stdctrl);
        //calling public methods
        sendPSRController.returnToPSR();
        sendPSRController.sendPSRAction();
               
    }
    
    
    
    //This test method covers following scenarios
    //1)Array_Layout__c = true and Design_Urgent_Request__c = false and Array_Layout_Due__c != null
     static testMethod void testController_Send_PSR2(){

       //Quote quote = null;

        Opportunity oppty = new Opportunity();
        oppty.Name = 'TestOpp'; // 'Test class oppty for quote';
        oppty.StageName= 'Binding Offer';
        oppty.Closedate = System.today();
        insert oppty;

        //Opportunity insertedoppty = [select id,name from opportunity where name = 'TestOpp'];
        Quote quote = new Quote();
        quote.Name = 'Test quote';
        quote.Quote_Steps__c= 'TEst Array Layout';
        //quote.Quote_Status__c = 'Ordered';
        quote.opportunityid = oppty.id;
        insert quote;

        
        for (Quote currentQuote :
            [Select q.Quote_Steps__c, q.Id 
                From Quote q 
                where quote_steps__c like '%Array Layout' and Quote_Status__c !='Expired'
                order by CreatedDate DESC limit 1]){
        
            quote=currentQuote;
        }
        
        quote.Proposal_Due__c = Date.today().addDays(3);
        update quote;
        //create a psr record
        PSR__c psr = new PSR__c();
        psr.Quote__c = quote.ID;
        psr.Array_Layout__c = true;

        psr.Design_Urgent_Request__c = false;
        psr.PM_Cost__c = true;
        //psr.Array_Layout_Due__c = Date.today().addDays(2);
        insert psr;

        //instance of Standard Controller
        ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(psr);
        //instance of Controller_Send_PSR
        Controller_Send_PSR sendPSRController = new Controller_Send_PSR(stdctrl);
        //calling public methods
        sendPSRController.returnToPSR();
        sendPSRController.sendPSRAction();       
    } 
    

    //This test method covers following scenarios
    //1)Array_Layout__c = true and Array_Layout_Due__c != null 
    //      and PSR_Sent__c!=null
   static testMethod void testController_Send_PSR3(){

      //Quote quote = null;

        Opportunity oppty = new Opportunity();
        oppty.Name = 'TestOpp'; // 'Test class oppty for quote';
        oppty.StageName= 'Binding Offer';
        oppty.Closedate = System.today();
        insert oppty;

        //Opportunity insertedoppty = [select id,name from opportunity where name = 'TestOpp'];
        Quote quote = new Quote();
        quote.Name = 'Test quote';
        quote.Quote_Steps__c= 'TEst Array Layout';
        //quote.Quote_Status__c = 'Ordered';
        quote.opportunityid = oppty.id;
        insert quote;

        for (Quote currentQuote :
            [Select q.Quote_Steps__c, q.Id 
                From Quote q 
                where quote_steps__c like '%Array Layout' and Quote_Status__c !='Expired'
                order by CreatedDate DESC limit 1]){
        
            quote=currentQuote;
            
        }

        //create a psr record
        quote.Proposal_Due__c = Date.today().addDays(3);
        update quote;

        PSR__c psr = new PSR__c();
        psr.Quote__c = quote.ID;
        psr.Array_Layout__c = true;
        psr.Array_Layout_Due__c = Date.today().addDays(2);      
        
        
        insert psr;
        //instance of Standard Controller
        ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(psr);
        //instance of Controller_Send_PSR
        Controller_Send_PSR sendPSRController = new Controller_Send_PSR(stdctrl);
        //calling public methods
        sendPSRController.returnToPSR();
        sendPSRController.sendPSRAction();       
    }

    //This test method cover following scenarios
    // 1)Array_Layout__c = true and Proposal_Designer__c != null
    // 2)Array_Layout__c = true and design!=null
    static testMethod void testController_Send_PSR4(){

        //Quote quote = null;

        Opportunity oppty = new Opportunity();
        oppty.Name = 'TestOpp'; // 'Test class oppty for quote';
        oppty.StageName= 'Binding Offer';
        oppty.Closedate = System.today();
        insert oppty;

        //Opportunity insertedoppty = [select id,name from opportunity where name = 'TestOpp'];
        Quote quote = new Quote();
        quote.Name = 'Test quote';
        quote.Quote_Steps__c= 'TEst Array Layout';
        //quote.Quote_Status__c = 'Ordered';
        quote.opportunityid = oppty.id;
        insert quote;

        for (Quote currentQuote :
            [Select q.Quote_Steps__c, q.Id 
                From Quote q 
                where quote_steps__c like '%Array Layout' and Quote_Status__c !='Expired'
                order by CreatedDate DESC limit 1]){
        
            quote=currentQuote;
            
        }

        //create a psr record
        PSR__c psr = new PSR__c();
        psr.Quote__c = quote.ID;
        psr.Array_Layout__c = true;
        //psr.Array_Layout_Due__c = Date.today().addDays(2);             
        //psr.Proposal_Designer__c = UserInfo.getUserId();
        insert psr;
        
        //create a design
        Design__c design = new Design__c();
        insert design;
        
        //create another psr record
        PSR__c psr1 = new PSR__c();
        psr1.Quote__c = quote.ID;
        psr1.Array_Layout__c = true;
        psr1.Design__c = design.ID;
        //psr.Array_Layout_Due__c = Date.today().addDays(2);             
        //psr1.Proposal_Designer__c = UserInfo.getUserId();
        psr1.PM_Cost__c = false;
        insert psr1;
                
        ApexPages.Standardcontroller stdctrl;
        Controller_Send_PSR sendPSRController;
        
        //instance of Standard Controller
        stdctrl = new Apexpages.Standardcontroller(psr);
        //instance of Controller_Send_PSR
        sendPSRController = new Controller_Send_PSR(stdctrl);
        //calling public methods       
        sendPSRController.sendPSRAction(); 
        
        stdctrl = new Apexpages.Standardcontroller(psr1);
        sendPSRController = new Controller_Send_PSR(stdctrl);
        //calling public methods       
        sendPSRController.sendPSRAction();
              
    }
    //This test method cover following scenarios
    // 1) Array_Layout__c == false and PM_Cost__c = false
    // 2) Array_Layout__c == false and PM_Cost__c = true and Design != null
    
    static testMethod void testController_Send_PSR5(){

        //Quote quote = null;

        Opportunity oppty = new Opportunity();
        oppty.Name = 'TestOpp'; // 'Test class oppty for quote';
        oppty.StageName= 'Binding Offer';
        oppty.Closedate = System.today();
        insert oppty;

        //Opportunity insertedoppty = [select id,name from opportunity where name = 'TestOpp'];
        Quote quote = new Quote();
        quote.Name = 'Test quote';
        quote.Quote_Steps__c= 'TEst Array Layout';
        //quote.Quote_Status__c = 'Ordered';
        quote.opportunityid = oppty.id;
        insert quote;

        for (Quote currentQuote :
            [Select q.Quote_Steps__c, q.Id 
                From Quote q 
                where quote_steps__c like '%Array Layout' and Quote_Status__c !='Expired'
                order by CreatedDate DESC limit 1]){
        
            quote=currentQuote;
            
        }
        
        //create another psr record
        PSR__c psr1 = new PSR__c();
        psr1.Quote__c = quote.ID;
        psr1.Array_Layout__c = false;                   
        psr1.PM_Cost__c = false;
        insert psr1;
        
        //create a design
        Design__c design = new Design__c();
        insert design;
        
        //create another psr record
        PSR__c psr2 = new PSR__c();
        psr2.Quote__c = quote.ID;
        psr2.Array_Layout__c = false;                   
        psr2.PM_Cost__c = true;
        psr2.Design__c = design.ID;
        insert psr2;
            
        ApexPages.Standardcontroller stdctrl;
        Controller_Send_PSR sendPSRController;
        
        stdctrl = new Apexpages.Standardcontroller(psr1);
        sendPSRController = new Controller_Send_PSR(stdctrl);
        //calling public methods       
        sendPSRController.sendPSRAction();
        
        stdctrl = new Apexpages.Standardcontroller(psr2);
        sendPSRController = new Controller_Send_PSR(stdctrl);
        //calling public methods       
        sendPSRController.sendPSRAction();
               
    }
    
    //This test method covers following scenarios
    //1)Site_Survey_Standard__c = true ;so task will be created and Site_Survey_ID__c will get updated.
    static testMethod void testController_Send_PSR6(){
        
        Site_Information_Form__c site;
        //Quote quote = null;

        Opportunity oppty = new Opportunity();
        oppty.Name = 'TestOpp'; // 'Test class oppty for quote';
        oppty.StageName= 'Binding Offer';
        oppty.Closedate = System.today();
        insert oppty;

        //Opportunity insertedoppty = [select id,name from opportunity where name = 'TestOpp'];
        Quote quote = new Quote();
        quote.Name = 'Test quote';
        quote.Quote_Steps__c= 'TEst Array Layout';
        //quote.Quote_Status__c = 'Ordered';
        quote.opportunityid = oppty.id;
        insert quote;

        Account acc;
        
        for (Quote currentQuote :
            [Select q.Quote_Steps__c, q.Id 
                From Quote q 
                where quote_steps__c like '%Array Layout' and Quote_Status__c !='Expired' 
                order by CreatedDate DESC limit 1]){
        
            quote=currentQuote;
            
        }
        quote.Proposal_Due__c = Date.today().addMonths(3);
        update quote;
        
        Id quoteId = '0Q080000000Gp95CAC';
        
        //creating test account
        //List<RecordType> accRecordTypeList = [SELECT Id FROM RecordType 
        //                                                WHERE SObjectType = 'Account'
        //                                                AND Name = 'Standard'];
        //Get RecordtypeId of Standard  
        //Modified by: Nikki - CS    
        Id standardRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        
        acc = new Account();
        //acc.RecordTypeId = accRecordTypeList.get(0).id;
        acc.RecordTypeId = standardRecTypeId;
        acc.CurrencyIsoCode = 'USD';
        acc.Industry = 'Other';
        acc.Name = 'test000011111';
        acc.BillingState = 'BillingState';
        acc.BillingCity = 'Jind';
        acc.BillingCountry = 'India';
        acc.BillingStreet = 'Rohtak Road';
        acc.BillingPostalCode = '126102';
        acc.Online_Order_Access__c = false;
        insert acc; 
        
        //creating test site
        //List<RecordType> siteRecordTypeList = [SELECT Id FROM RecordType 
        //                                                WHERE SObjectType = 'Site_Information_Form__c'
        //                                                AND Name = 'Standard Site'];
        //Modified by: Nikki - CS
         //Get RecordtypeId of Standard Site      
        Id standardSiteRecTypeId = Schema.SObjectType.Site_Information_Form__c.getRecordTypeInfosByName().get('Standard Site').getRecordTypeId();
        
        site = new Site_Information_Form__c();
        //site.RecordTypeId = siteRecordTypeList.get(0).id;
        site.RecordTypeId = standardSiteRecTypeId;
        site.Account__c = acc.id;
        site.Site_Status__c = 'Active';
        site.Site_State__c = 'state';
        insert site;
        
        //create a psr record
        PSR__c psr = new PSR__c();
        psr.Site__c = site.id;
        //done by hemant
        //psr.Quote__c = quote.ID;
        psr.Quote__c = quoteId;
        psr.Array_Layout__c = true;
        psr.Design_Urgent_Request__c = false;
        psr.Single_Line_based_on_Design__c = false;
        psr.Estimate_Urgent_Request__c = false;
        psr.PM_Cost__c = true;
        //psr.Kickoff_Meeting_Date__c = date.today().addDays(2);
        //psr.Site_Survey_Due__c = date.today().addDays(4);
        psr.Site_Survey_Due__c = null;
        //Array Layout Due date must be earlier than the Proposal Due date
        psr.Array_Layout_Due__c = date.today().addDays(6);
        psr.Cost_Estimate_Due__c = date.today().addDays(11);
        psr.Site_Survey_ID__c = null;
        psr.Site_Survey_Standard__c = true;//set to true
        psr.Site_Survey_SubContractor__c = false;//set to false 
        insert psr;
        
        //Site_Survey_Standard__c = true ;so task will be created and Site_Survey_ID__c will get updated.
        
        System.assertEquals(null, psr.Site_Survey_ID__c);//initially Site_Survey_ID__c is null
        //instance of Standard Controller
        ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(psr);
        //instance of Controller_Send_PSR
        Controller_Send_PSR sendPSRController = new Controller_Send_PSR(stdctrl);
        //calling public methods
        sendPSRController.returnToPSR();
        sendPSRController.sendPSRAction();
        //fetch updated psr record
        List<PSR__c> psrList = [Select Site_Survey_ID__c,id From PSR__c where id = :psr.id];
        //System.assertNotEquals(null, psrList.get(0).Site_Survey_ID__c);//Site_Survey_ID__c has been updated
    }
    
    //This test method covers following scenarios
    //1)Site_Survey_SubContractor__c = true ;so task will be created and Site_Survey_ID__c will get updated.
   static testMethod void testController_Send_PSR7(){
        
        Site_Information_Form__c site;
        //Quote quote = null;

        Opportunity oppty = new Opportunity();
        oppty.Name = 'TestOpp'; // 'Test class oppty for quote';
        oppty.StageName= 'Binding Offer';
        oppty.Closedate = System.today();
        insert oppty;

        //Opportunity insertedoppty = [select id,name from opportunity where name = 'TestOpp'];
        Quote quote = new Quote();
        quote.Name = 'Test quote';
        quote.Quote_Steps__c= 'TEst Array Layout';
        //quote.Quote_Status__c = 'Ordered';
        quote.opportunityid = oppty.id;
        insert quote;

        Account acc;
        
        for (Quote currentQuote :
            [Select q.Quote_Steps__c, q.Id 
                From Quote q 
                where quote_steps__c like '%Array Layout' and Quote_Status__c !='Expired'
                order by CreatedDate DESC limit 1]){
        
            quote=currentQuote;
            
        }
        quote.Proposal_Due__c = Date.today().addMonths(3);
        update quote;
        
        Id quoteId = '0Q080000000Gp95CAC';
        
        //creating test account
        //List<RecordType> accRecordTypeList = [SELECT Id FROM RecordType 
        //                                                WHERE SObjectType = 'Account'
        //                                                AND Name = 'Standard'];
        //Modified by: Nikki - CS
        //Get RecordtypeId of Standard      
        Id standardRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        
        acc = new Account();
       // acc.RecordTypeId = accRecordTypeList.get(0).id;
        acc.RecordTypeId = standardRecTypeId;
        acc.CurrencyIsoCode = 'USD';
        acc.Industry = 'Other';
        acc.Name = 'test001';
        acc.BillingState = 'BillingState';
        acc.BillingCity = 'Jind';
        acc.BillingCountry = 'India';
        acc.BillingStreet = 'Rohtak Road';
        acc.BillingPostalCode = '126102';
        acc.Online_Order_Access__c = false;
        insert acc; 
        
        //creating test site
        //List<RecordType> siteRecordTypeList = [SELECT Id FROM RecordType 
        //                                                WHERE SObjectType = 'Site_Information_Form__c'
        //                                               AND Name = 'Standard Site'];
        //Modified by: Nikki - CS
        //Get RecordtypeId of Standard Site      
        Id standardSiteRecTypeId = Schema.SObjectType.Site_Information_Form__c.getRecordTypeInfosByName().get('Standard Site').getRecordTypeId();
        
        site = new Site_Information_Form__c();
        //site.RecordTypeId = siteRecordTypeList.get(0).id;
        site.RecordTypeId = standardSiteRecTypeId;
        site.Account__c = acc.id;
        site.Site_Status__c = 'Active';
        site.Site_State__c = 'state';
        insert site;
        
        //create a psr record
        PSR__c psr = new PSR__c();
        psr.Site__c = site.id;
        //psr.Quote__c = quote.ID;
        psr.Quote__c = quoteId;
        psr.Array_Layout__c = true;
        psr.Design_Urgent_Request__c = false;
        psr.Single_Line_based_on_Design__c = false;
        psr.Estimate_Urgent_Request__c = false;
        psr.PM_Cost__c = true;
        //psr.Kickoff_Meeting_Date__c = date.today().addDays(2);
        //psr.Site_Survey_Due__c = date.today().addDays(4);
        psr.Site_Survey_Due__c = null;
        //Array Layout Due date must be earlier than the Proposal Due date
        psr.Array_Layout_Due__c = date.today().addDays(6);
        psr.Cost_Estimate_Due__c = date.today().addDays(11);
        psr.Site_Survey_ID__c = null;
        psr.Site_Survey_Standard__c = false;//set to false
        psr.Site_Survey_SubContractor__c = true;//set to true   
        insert psr;
        
        //Site_Survey_Standard__c = true ;so task will be created and Site_Survey_ID__c will get updated.
        
        System.assertEquals(null, psr.Site_Survey_ID__c);//initially Site_Survey_ID__c is null
        //instance of Standard Controller
        ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(psr);
        //instance of Controller_Send_PSR
        Controller_Send_PSR sendPSRController = new Controller_Send_PSR(stdctrl);
        //calling public methods
        sendPSRController.returnToPSR();
        sendPSRController.sendPSRAction();
        //fetch updated psr record
        List<PSR__c>  psrList = [Select Site_Survey_ID__c,id From PSR__c where id = :psr.id];
        //System.assertNotEquals(null, psrList.get(0).Site_Survey_ID__c);//Site_Survey_ID__c has been updated
    }
    
    //This test method covers following scenarios
    //1)Site_Survey_SubContractor__c = false and  Site_Survey_Standard__c = false;
    //so no task will be created and Site_Survey_ID__c will not be updated.
    static testMethod void testController_Send_PSR8(){
        
        Site_Information_Form__c site;
        //Quote quote = null;

        Opportunity oppty = new Opportunity();
        oppty.Name = 'TestOpp'; // 'Test class oppty for quote';
        oppty.StageName= 'Binding Offer';
        oppty.Closedate = System.today();
        insert oppty;

        //Opportunity insertedoppty = [select id,name from opportunity where name = 'TestOpp'];
        Quote quote = new Quote();
        quote.Name = 'Test quote';
        quote.Quote_Steps__c= 'TEst Array Layout';
        //quote.Quote_Status__c = 'Ordered';
        quote.opportunityid = oppty.id;
        insert quote;

        Account acc;
        
        for (Quote currentQuote :
            [Select q.Quote_Steps__c, q.Id 
                From Quote q 
                where quote_steps__c like '%Array Layout' and Quote_Status__c !='Expired'
                order by CreatedDate DESC limit 1]){
        
            quote=currentQuote;
            
        }
        quote.Proposal_Due__c = Date.today().addMonths(3);
        update quote;
        
        //creating test account
        //List<RecordType> accRecordTypeList = [SELECT Id FROM RecordType 
        //                                                WHERE SObjectType = 'Account'
        //                                                AND Name = 'Standard'];
        //Modified by Nikki - CS
        //Get RecordtypeId of Standard      
        Id standardRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        
        acc = new Account();
        //acc.RecordTypeId = accRecordTypeList.get(0).id;
        acc.RecordTypeId = standardRecTypeId;
        acc.CurrencyIsoCode = 'USD';
        acc.Industry = 'Other';
        acc.Name = 'test002';
        acc.BillingState = 'BillingState';
        acc.BillingCity = 'Jind';
        acc.BillingCountry = 'India';
        acc.BillingStreet = 'Rohtak Road';
        acc.BillingPostalCode = '126102';
        acc.Online_Order_Access__c = false;
        insert acc; 
        
        //creating test site
        //List<RecordType> siteRecordTypeList = [SELECT Id FROM RecordType 
        //                                                WHERE SObjectType = 'Site_Information_Form__c'
        //                                                AND Name = 'Standard Site'];
        //Modified by: Nikki - CS
        //Get RecordtypeId of Standard Site      
        Id standardSiteRecTypeId = Schema.SObjectType.Site_Information_Form__c.getRecordTypeInfosByName().get('Standard Site').getRecordTypeId();                                              
        site = new Site_Information_Form__c();
        //site.RecordTypeId = siteRecordTypeList.get(0).id;
        site.RecordTypeId = standardSiteRecTypeId;
        site.Account__c = acc.id;
        site.Site_Status__c = 'Active';
        site.Site_State__c = 'state';
        insert site;
        
        //create a psr record
        PSR__c psr = new PSR__c();
        psr.Site__c = site.id;
        psr.Quote__c = quote.ID;
        psr.Array_Layout__c = true;
        psr.Design_Urgent_Request__c = false;
        psr.Single_Line_based_on_Design__c = false;
        psr.Estimate_Urgent_Request__c = false;
        psr.PM_Cost__c = true;
        //psr.Kickoff_Meeting_Date__c = date.today().addDays(2);
        psr.Site_Survey_Due__c = date.today().addDays(4);
        //Array Layout Due date must be earlier than the Proposal Due date
        psr.Array_Layout_Due__c = date.today().addDays(6);
        psr.Cost_Estimate_Due__c = date.today().addDays(11);
        psr.Site_Survey_ID__c = null;
        psr.Site_Survey_Standard__c = false;//set to false
        psr.Site_Survey_SubContractor__c = false;//set to false
        insert psr;
        
        //Site_Survey_Standard__c = true ;so task will be created and Site_Survey_ID__c will get updated.
        
        System.assertEquals(null, psr.Site_Survey_ID__c);//initially Site_Survey_ID__c is null
        //instance of Standard Controller
        ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(psr);
        //instance of Controller_Send_PSR
        Controller_Send_PSR sendPSRController = new Controller_Send_PSR(stdctrl);
        //calling public methods
        sendPSRController.returnToPSR();
        sendPSRController.sendPSRAction();
        //fetch updated psr record
        List<PSR__c>  psrList = [Select Site_Survey_ID__c,id From PSR__c where id = :psr.id];
        System.assertEquals(null, psrList.get(0).Site_Survey_ID__c);//Site_Survey_ID__c has not been updated
    }
    
    //This test method covers following scenarios
    //1)Array_Layout__c = false and Design__c == null and  PM_Cost__c = false
    static testMethod void testController_Send_PSR9(){
        
        Site_Information_Form__c site;
        //Quote quote = null;

        Opportunity oppty = new Opportunity();
        oppty.Name = 'TestOpp'; // 'Test class oppty for quote';
        oppty.StageName= 'Binding Offer';
        oppty.Closedate = System.today();
        insert oppty;

        //Opportunity insertedoppty = [select id,name from opportunity where name = 'TestOpp'];
        Quote quote = new Quote();
        quote.Name = 'Test quote';
        quote.Quote_Steps__c= 'TEst Array Layout';
        //quote.Quote_Status__c = 'Ordered';
        quote.opportunityid = oppty.id;
        insert quote;

        Account acc;
        
        for (Quote currentQuote :
            [Select q.Quote_Steps__c, q.Id 
                From Quote q 
                where quote_steps__c like '%Array Layout' and Quote_Status__c !='Expired'
                order by CreatedDate DESC limit 1]){
        
            quote=currentQuote;
            
        }
        quote.Proposal_Due__c = Date.today().addMonths(3);
        update quote;
        
        //creating test account
        //List<RecordType> accRecordTypeList = [SELECT Id FROM RecordType 
        //                                                WHERE SObjectType = 'Account'
        //                                                AND Name = 'Standard'];
        //Modified by: Nikki - CS
        //Get RecordtypeId of Standard      
        Id standardRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        
        acc = new Account();
        //acc.RecordTypeId = accRecordTypeList.get(0).id;
        acc.RecordTypeId = standardRecTypeId;
        acc.CurrencyIsoCode = 'USD';
        acc.Industry = 'Other';
        acc.Name = 'test003';
        acc.BillingState = 'BillingState';
        acc.BillingCity = 'Jind';
        acc.BillingCountry = 'India';
        acc.BillingStreet = 'Rohtak Road';
        acc.BillingPostalCode = '126102';
        acc.Online_Order_Access__c = false;
        insert acc; 
        
        //creating test site
        //List<RecordType> siteRecordTypeList = [SELECT Id FROM RecordType 
        //                                                WHERE SObjectType = 'Site_Information_Form__c'
        //                                                AND Name = 'Standard Site'];
        //Modified by: Nikki - CS
        //Get RecordtypeId of Standard Site      
        Id standardSiteRecTypeId = Schema.SObjectType.Site_Information_Form__c.getRecordTypeInfosByName().get('Standard Site').getRecordTypeId(); 
        site = new Site_Information_Form__c();
        //site.RecordTypeId = siteRecordTypeList.get(0).id;
        site.RecordTypeId = standardSiteRecTypeId;
        site.Account__c = acc.id;
        site.Site_Status__c = 'Active';
        site.Site_State__c = 'state';
        insert site;
        
        //create a psr record
        PSR__c psr = new PSR__c();
        psr.Site__c = site.id;
        psr.Quote__c = quote.ID;
        psr.Array_Layout__c = false;
        psr.Design_Urgent_Request__c = false;
        psr.Single_Line_based_on_Design__c = false;
        psr.Estimate_Urgent_Request__c = false;
        psr.PM_Cost__c = true;
        //psr.Kickoff_Meeting_Date__c = date.today().addDays(2);
        insert psr;
        
        //instance of Standard Controller
        ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(psr);
        //instance of Controller_Send_PSR
        Controller_Send_PSR sendPSRController = new Controller_Send_PSR(stdctrl);
        //calling public methods
        sendPSRController.returnToPSR();
        sendPSRController.sendPSRAction();


    }
    
    //This test method covers following scenarios
    //1)Array_Layout__c = false and Design__c != null and  PM_Cost__c = true
    static testMethod void testController_Send_PSR10(){
        
        Site_Information_Form__c site;
        //Quote quote = null;

        Opportunity oppty = new Opportunity();
        oppty.Name = 'TestOpp'; // 'Test class oppty for quote';
        oppty.StageName= 'Binding Offer';
        oppty.Closedate = System.today();
        insert oppty;

        //Opportunity insertedoppty = [select id,name from opportunity where name = 'TestOpp'];
        Quote quote = new Quote();
        quote.Name = 'Test quote';
        quote.Quote_Steps__c= 'TEst Array Layout';
        //quote.Quote_Status__c = 'Ordered';
        quote.opportunityid = oppty.id;
        insert quote;

        Account acc;
        
        for (Quote currentQuote :
            [Select q.Quote_Steps__c, q.Id 
                From Quote q 
                where quote_steps__c like '%Array Layout' and Quote_Status__c !='Expired'
                order by CreatedDate DESC limit 1]){
        
            quote=currentQuote;
            
        }
        quote.Proposal_Due__c = Date.today().addMonths(3);
        update quote;
        
       
        //creating test account
   /*List<RecordType> accRecordTypeList = [SELECT Id FROM RecordType 
                                                        WHERE SObjectType = 'Account'
                                                        AND Name = 'Standard'];*/
        //Modified by: Nikki - CS
        //Get RecordtypeId of Standard      
        Id standardRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard').getRecordTypeId();                                                
        
        acc = new Account();
        //acc.RecordTypeId = accRecordTypeList.get(0).id;
        acc.RecordTypeId = standardRecTypeId;
        acc.CurrencyIsoCode = 'USD';
        acc.Industry = 'Other';
        acc.Name = 'test01';
        acc.BillingState = 'BillingState';
        acc.BillingState = 'BillingState';
        acc.BillingCity = 'Jind';
        acc.BillingCountry = 'India';
        acc.BillingStreet = 'Rohtak Road';
        acc.BillingPostalCode = '126102';
        acc.Online_Order_Access__c = false;
        insert acc; 
        
        //creating test site
        /*List<RecordType> siteRecordTypeList = [SELECT Id FROM RecordType 
                                                        WHERE SObjectType = 'Site_Information_Form__c'
                                                        AND Name = 'Standard Site'];*/
        ////Modified by: Nikki - CS
        //Get RecordtypeId of Standard Site      
        Id standardSiteRecTypeId = Schema.SObjectType.Site_Information_Form__c.getRecordTypeInfosByName().get('Standard Site').getRecordTypeId();
        
        site = new Site_Information_Form__c();
        //site.RecordTypeId = siteRecordTypeList.get(0).id;
        site.RecordTypeId = standardSiteRecTypeId;
        site.Account__c = acc.id;
        site.Site_Status__c = 'Active';
        site.Site_State__c = 'state';
        insert site;
        
        String recordTypeIdDesign;
                
        //querying record type id for family
        //List<RecordType> lstRecordTypes = [Select r.SobjectType, r.Name, r.Id, r.DeveloperName From RecordType r where r.Name = 'Proposal Design' and SobjectType ='Design__c' limit 1];
        //if(lstRecordTypes != null && lstRecordTypes.size() > 0){
        //    recordTypeIdDesign = lstRecordTypes.get(0).Id;
        //}
        
        //Modified by Nikki - CS
        //Get RecordtypeId of Proposal     
        Id proposalRecTypeId = Schema.SObjectType.Design__c.getRecordTypeInfosByName().get('Proposal Design').getRecordTypeId();          
                
        Design__c testDesign1 = new Design__c();
        //testDesign1.PSR__c = psr1.Id;
        testDesign1.site__c = site.Id;
        //testDesign1.RecordTypeId = recordTypeIdDesign;
        testDesign1.RecordTypeId = proposalRecTypeId;
        //testDesign1.opportunity__c = testOpp.Id;
        testDesign1.Revision_Letter__c = 'A';
        //testDesign.Proposal_Designer__c = 
        testDesign1.Date_Design_Completed__c = System.today().addMonths(1);
        testDesign1.Status__c = 'Not Started';
        
        insert testDesign1;
                
        //create a psr record
        PSR__c psr = new PSR__c();
        psr.Site__c = site.id;
        psr.Design__c = testDesign1.Id;
        psr.Quote__c = quote.ID;
        psr.Array_Layout__c = false;
        psr.Design_Urgent_Request__c = false;
        psr.Single_Line_based_on_Design__c = false;
        psr.Estimate_Urgent_Request__c = true;
        psr.Cost_Estimate_Due__c = null;
        psr.Electrical_Support_Due__c = Date.today().addDays(5);
        psr.PM_Cost__c = true;
        psr.Site_Survey_Standard__c = true;
        //psr.Kickoff_Meeting_Date__c = date.today().addDays(2);
        insert psr;
        
        //instance of Standard Controller
        ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(psr);
        //instance of Controller_Send_PSR
        Controller_Send_PSR sendPSRController = new Controller_Send_PSR(stdctrl);
        
        //calling public methods     
        sendPSRController.sendPSRAction();

    }
    
    //This test method covers following scenarios
    //1)Array_Layout__c = true and Design_Urgent_Request__c = false and site__c != null
     static testMethod void testController_Send_PSR11(){

       //Quote quote = null;

        Opportunity oppty = new Opportunity();
        oppty.Name = 'TestOpp'; // 'Test class oppty for quote'
        oppty.StageName= 'Binding Offer';
        oppty.Closedate = System.today();
        insert oppty;

        //Opportunity insertedoppty = [select id,name from opportunity where name = 'TestOpp'];
        Quote quote = new Quote();
        quote.Name = 'Test quote';
        quote.Quote_Steps__c= 'TEst Array Layout';
        //quote.Quote_Status__c = 'Ordered';
        quote.opportunityid = oppty.id;
        insert quote;

        //creating test account
        /*List<RecordType> accRecordTypeList = [SELECT Id FROM RecordType 
                                                        WHERE SObjectType = 'Account'
                                                        AND Name = 'Standard'];*/
        //Modified by: Nikki - CS
        //Get RecordtypeId of Standard      
        Id standardRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        Account acc = new Account();
        //acc.RecordTypeId = accRecordTypeList.get(0).id;
        acc.RecordTypeId = standardRecTypeId;
        acc.CurrencyIsoCode = 'USD';
        acc.Industry = 'Other';
        acc.Name = 'test02';
        acc.BillingState = 'BillingState';
        acc.BillingCity = 'Jind';
        acc.BillingCountry = 'India';
        acc.BillingStreet = 'Rohtak Road';
        acc.BillingPostalCode = '126102';
        acc.Online_Order_Access__c = false;
        insert acc; 
        
        for (Quote currentQuote :
            [Select q.Quote_Steps__c, q.Id, Kickoff_Meeting_Date__c 
                From Quote q 
                where quote_steps__c like '%Array Layout' and Quote_Status__c !='Expired'
                order by CreatedDate DESC limit 1]){
        
            quote=currentQuote;
        }
        
        quote.Proposal_Due__c = Date.today().addMonths(3);
        quote.Kickoff_Meeting_Date__c = Date.today().addDays(10);
        update quote;
        
        String recordTypeIdDesign;
                
        //creating test site
        /*List<RecordType> siteRecordTypeList = [SELECT Id FROM RecordType 
                                                        WHERE SObjectType = 'Site_Information_Form__c'
                                                        AND Name = 'Standard Site'];*/
        //Modified by: Nikki - CS
        //Get RecordtypeId of Standard Site      
        Id standardSiteRecTypeId = Schema.SObjectType.Site_Information_Form__c.getRecordTypeInfosByName().get('Standard Site').getRecordTypeId(); 
        
        Site_Information_Form__c site = new Site_Information_Form__c();
        //site.RecordTypeId = siteRecordTypeList.get(0).id;
        site.RecordTypeId = standardSiteRecTypeId;
        site.Account__c = acc.id;
        site.Site_Status__c = 'Active';
        site.Site_State__c = 'state';
        insert site;
        
        //create a psr record
        PSR__c psr = new PSR__c();
        psr.Quote__c = quote.ID;
        psr.Site__c = site.id;
        psr.Array_Layout__c = true;

        psr.Design_Urgent_Request__c = false;
        psr.PM_Cost__c = true;
        psr.Site_Survey_Standard__c = true;
        
        //psr.Array_Layout_Due__c = Date.today().addDays(2);
        insert psr;

        //instance of Standard Controller
        ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(psr);
        //instance of Controller_Send_PSR
        Controller_Send_PSR sendPSRController = new Controller_Send_PSR(stdctrl);
        
        //calling public methods       
        sendPSRController.sendPSRAction();       
       
    } 
    
    //This test method covers following scenarios
    //1)Array_Layout__c = true and Design_Urgent_Request__c = true and Array_Layout_Due__c != null
     static testMethod void testController_Send_PSR12(){

       //Quote quote = null;

        Opportunity oppty = new Opportunity();
        oppty.Name = 'TestOpp'; //'Test class oppty for quote';
        oppty.StageName= 'Binding Offer';
        oppty.Closedate = System.today();
        insert oppty;

        //Opportunity insertedoppty = [select id,name from opportunity where name = 'TestOpp'];
        Quote quote = new Quote();
        quote.Name = 'Test quote';
        quote.Quote_Steps__c= 'TEst Array Layout';
        //quote.Quote_Status__c = 'Ordered';
        quote.opportunityid = oppty.id;
        insert quote;

        //creating test account
        //Modified by Nikki
       // List<RecordType> accRecordTypeList = [SELECT Id FROM RecordType 
       //                                                 WHERE SObjectType = 'Account'
       //                                                 AND Name = 'Standard'];
                                                        
        
        //Get RecordtypeId of Standard      
        Id standardRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        
        Account acc = new Account();
        //acc.RecordTypeId = accRecordTypeList.get(0).id;
        acc.RecordTypeId = standardRecTypeId;
        acc.CurrencyIsoCode = 'USD';
        acc.Industry = 'Other';
        acc.Name = 'test04';
        acc.BillingState = 'BillingState';
        acc.BillingCity = 'Jind';
        acc.BillingCountry = 'India';
        acc.BillingStreet = 'Rohtak Road';
        acc.BillingPostalCode = '126102';
        acc.Online_Order_Access__c = false;
        insert acc; 
        
        for (Quote currentQuote :
            [Select q.Quote_Steps__c, q.Id, Kickoff_Meeting_Date__c 
                From Quote q 
                where quote_steps__c like '%Array Layout' and Quote_Status__c !='Expired' 
                order by CreatedDate DESC limit 1]){
        
            quote=currentQuote;
        }
        
        quote.Proposal_Due__c = Date.today().addMonths(3);
        quote.Kickoff_Meeting_Date__c = Date.today().addDays(10);
        update quote;
        
        String recordTypeIdDesign;
                
        //creating test site
        //Modified by Nikki
        //List<RecordType> siteRecordTypeList = [SELECT Id FROM RecordType 
        //                                                WHERE SObjectType = 'Site_Information_Form__c'
        //                                                 AND Name = 'Standard Site'];
        
        //Get RecordtypeId of Standard Site      
        Id standardSiteRecTypeId = Schema.SObjectType.Site_Information_Form__c.getRecordTypeInfosByName().get('Standard Site').getRecordTypeId();                                               
        
        Site_Information_Form__c site = new Site_Information_Form__c();
        //site.RecordTypeId = siteRecordTypeList.get(0).id;
        site.RecordTypeId = standardSiteRecTypeId;
        site.Account__c = acc.id;
        site.Site_Status__c = 'Active';
        site.Site_State__c = 'state';
        insert site;
        Id quoteId = '0Q080000000Gp95CAC';

        //create a psr record
        PSR__c psr = new PSR__c();
        //psr.Quote__c = quote.ID;
        psr.Quote__c = quoteId;
        psr.Site__c = site.id;
        psr.Array_Layout__c = true;

        psr.Design_Urgent_Request__c = true;
        //psr.Array_Layout_Revision__c = true;
        psr.Single_Line_based_on_Design__c = true;
        psr.PM_Cost__c = true;
        psr.Site_Survey_Standard__c = true;
        
        psr.Array_Layout_Due__c = Date.today().addDays(2);
        insert psr;

        //instance of Standard Controller
        ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(psr);
        //instance of Controller_Send_PSR
        Controller_Send_PSR sendPSRController = new Controller_Send_PSR(stdctrl);
        
        //calling public methods      
        sendPSRController.sendPSRAction();       
    }
    //This test method covers following scenarios
    //1)Array_Layout_Revision__c = true ;
    static testMethod void testController_Send_PSR13(){
        
        Site_Information_Form__c site;
        //Quote quote = null;

        Opportunity oppty = new Opportunity();
        oppty.Name = 'TestOpp'; // 'Test class oppty for quote';
        oppty.StageName= 'Binding Offer';
        oppty.Closedate = System.today();
        insert oppty;

        //Opportunity insertedoppty = [select id,name from opportunity where name = 'TestOpp'];
        Quote quote = new Quote();
        quote.Name = 'Test quote';
        quote.Quote_Steps__c= 'TEst Array Layout';
        //quote.Quote_Status__c = 'Ordered';
        quote.opportunityid = oppty.id;
        insert quote;
        Account acc;
        
        for (Quote currentQuote :
            [Select q.Quote_Steps__c, q.Id 
                From Quote q 
                where quote_steps__c like '%Array Layout' and Quote_Status__c !='Expired' 
                order by CreatedDate DESC limit 1]){
        
            quote=currentQuote;
            
        }
        quote.Proposal_Due__c = Date.today().addMonths(3);
        update quote;
        
        Id quoteId = '0Q080000000Gp95CAC';
        
        //creating test account
        // List<RecordType> accRecordTypeList = [SELECT Id FROM RecordType 
        //                                                 WHERE SObjectType = 'Account'
        //                                                AND Name = 'Standard'];
        
        //Modified by: Nikki
        //Get RecordtypeId of Standard      
        Id standardRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard').getRecordTypeId();                                             
        
        acc = new Account();
        //acc.RecordTypeId = accRecordTypeList.get(0).id;
        acc.RecordTypeId =standardRecTypeId; 
        acc.CurrencyIsoCode = 'USD';
        acc.Industry = 'Other';
        acc.Name = 'test05';
        acc.BillingState = 'BillingState';
        acc.BillingCity = 'Jind';
        acc.BillingCountry = 'India';
        acc.BillingStreet = 'Rohtak Road';
        acc.BillingPostalCode = '126102';
        acc.Online_Order_Access__c = false;
        insert acc; 
        
        //creating test site
        //List<RecordType> siteRecordTypeList = [SELECT Id FROM RecordType 
        //                                                WHERE SObjectType = 'Site_Information_Form__c'
        //                                                AND Name = 'Standard Site'];
        //Modified by Nikki - CS
        //Get RecordtypeId of Standard Site    
        Id standardSiteRecTypeId = Schema.SObjectType.Site_Information_Form__c.getRecordTypeInfosByName().get('Standard Site').getRecordTypeId();
        
        site = new Site_Information_Form__c();
        //site.RecordTypeId = siteRecordTypeList.get(0).id;
        site.RecordTypeId = standardSiteRecTypeId;
        site.Account__c = acc.id;
        site.Site_Status__c = 'Active';
        site.Site_State__c = 'state';
        insert site;
        
        //create a psr record
        PSR__c psr = new PSR__c();
        psr.Site__c = site.id;
        // done by hemant
        psr.Quote__c = quoteId;
        //psr.Array_Layout__c = true;
        psr.Array_Layout_Revision__c = true;
        psr.Design_Urgent_Request__c = false;
        psr.Single_Line_based_on_Design__c = false;
        psr.Estimate_Urgent_Request__c = false;
        psr.PM_Cost__c = true;
        //psr.Kickoff_Meeting_Date__c = date.today().addDays(2);
        psr.Site_Survey_Due__c = date.today().addDays(4);
        //Array Layout Due date must be earlier than the Proposal Due date
        //psr.Array_Layout_Due__c = date.today().addDays(6);
        psr.Array_Layout_Due__c = null;
        psr.Cost_Estimate_Due__c = date.today().addDays(11);
        psr.Site_Survey_ID__c = null;
        psr.Site_Survey_Standard__c = true;//set to true
        psr.Site_Survey_SubContractor__c = false;//set to false 
        insert psr;
        
        if (psr.Array_Layout_Revision__c && psr.Site__c!=null){
            System.debug('**********************yes*****************');
        }
        //Site_Survey_Standard__c = true ;so task will be created and Site_Survey_ID__c will get updated.
        
        System.assertEquals(null, psr.Site_Survey_ID__c);//initially Site_Survey_ID__c is null
        //instance of Standard Controller
        ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(psr);
        //instance of Controller_Send_PSR
        Controller_Send_PSR sendPSRController = new Controller_Send_PSR(stdctrl);
        //calling public methods
        sendPSRController.returnToPSR();
        sendPSRController.sendPSRAction();
        //fetch updated psr record
        List<PSR__c> psrList = [Select Site_Survey_ID__c,id From PSR__c where id = :psr.id];
        //System.assertNotEquals(null, psrList.get(0).Site_Survey_ID__c);//Site_Survey_ID__c has been updated
    }
    

    static testMethod void testController_Send_PSR14(){
        
        Site_Information_Form__c site;
        //Quote quote = null;

        Opportunity oppty = new Opportunity();
        oppty.Name = 'TestOpp'; // 'Test class oppty for quote';
        oppty.StageName= 'Binding Offer';
        oppty.Closedate = System.today();
        insert oppty;

        //Opportunity insertedoppty = [select id,name from opportunity where name = 'TestOpp'];
        Quote quote = new Quote();
        quote.Name = 'Test quote';
        quote.Quote_Steps__c= 'TEst Array Layout';
        //quote.Quote_Status__c = 'Ordered';
        quote.opportunityid = oppty.id;
        insert quote;
        Account acc;
        
        for (Quote currentQuote :
            [Select q.Quote_Steps__c, q.Id 
                From Quote q 
                where quote_steps__c like '%Array Layout' and Quote_Status__c !='Expired'
                order by CreatedDate DESC limit 1]){
        
            quote=currentQuote;
            
        }
        quote.Proposal_Due__c = Date.today().addMonths(2);
        update quote;
        
        Id quoteId = '0Q080000000Gp95CAC';
        
        //creating test account
        //List<RecordType> accRecordTypeList = [SELECT Id FROM RecordType 
        //                                            WHERE SObjectType = 'Account'
        //                                              AND Name = 'Standard'];
        
        //Modified by: Nikki - CS
        //Get RecordtypeId of Standard      
        Id standardRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        acc = new Account();
        //acc.RecordTypeId = accRecordTypeList.get(0).id;
        acc.RecordTypeId = standardRecTypeId; 
        acc.CurrencyIsoCode = 'USD';
        acc.Industry = 'Other';
        acc.Name = 'test06';
        acc.BillingState = 'BillingState';
        acc.BillingCity = 'Jind';
        acc.BillingCountry = 'India';
        acc.BillingStreet = 'Rohtak Road';
        acc.BillingPostalCode = '126102';
        acc.Online_Order_Access__c = false;
        insert acc; 
        
        //creating test site
        //List<RecordType> siteRecordTypeList = [SELECT Id FROM RecordType 
        //                                                WHERE SObjectType = 'Site_Information_Form__c'
        //                                                AND Name = 'Standard Site'];
        
        //Modified by: Nikki - CS
        //Get RecordtypeId of Standard Site      
        Id standardSiteRecTypeId = Schema.SObjectType.Site_Information_Form__c.getRecordTypeInfosByName().get('Standard Site').getRecordTypeId();                                               
        
        site = new Site_Information_Form__c();
        //site.RecordTypeId = siteRecordTypeList.get(0).id;
        site.RecordTypeId = standardSiteRecTypeId;
        site.Account__c = acc.id;
        site.Site_Status__c = 'Active';
        site.Site_State__c = 'state';
        insert site;
        
        String recordTypeIdDesign;
                
        //querying record type id for family
        //List<RecordType> lstRecordTypes = [Select r.SobjectType, r.Name, r.Id, r.DeveloperName From RecordType r where r.Name = 'Proposal Design' and SobjectType ='Design__c' limit 1];
        //if(lstRecordTypes != null && lstRecordTypes.size() > 0){
        //    recordTypeIdDesign = lstRecordTypes.get(0).Id;
        //}
        //Modified by Nikki - CS
        //Get RecordtypeId of Standard Site      
        Id proposalRecTypeId = Schema.SObjectType.Design__c.getRecordTypeInfosByName().get('Proposal Design').getRecordTypeId();                                               
                
                
        Design__c testDesign1 = new Design__c();
        //testDesign1.PSR__c = psr1.Id;
        testDesign1.site__c = site.Id;
        //testDesign1.RecordTypeId = recordTypeIdDesign;
        testDesign1.RecordTypeId = proposalRecTypeId;
        //testDesign1.opportunity__c = testOpp.Id;
        testDesign1.Revision_Letter__c = 'A';
        //testDesign.Proposal_Designer__c = 
        testDesign1.Date_Design_Completed__c = System.today().addMonths(1);
        testDesign1.Status__c = 'Not Started';
        
        insert testDesign1;
                
        //create a psr record
        PSR__c psr = new PSR__c();
        psr.Site__c = site.id;
        psr.Design__c = null;
        //psr.Quote__c = quote.ID;
        psr.Quote__c = quoteId;
        psr.Array_Layout__c = true;
        psr.Array_Layout_Due__c = null;
        psr.Design_Urgent_Request__c = false;
        //psr.Array_Layout_Revision__c = true;
        psr.Single_Line_based_on_Design__c = false;
        psr.Estimate_Urgent_Request__c = true;
        psr.PM_Cost_without_Design__c = true;
        psr.Cost_Estimate_Due__c = null;
        psr.Electrical_Support_Due__c = Date.today().addDays(5);
        psr.PM_Cost__c = false;
        psr.Single_Line_based_on_Design__c=true;
        psr.Site_Survey_Standard__c = false;
        //psr.Kickoff_Meeting_Date__c = date.today().addDays(2);
        insert psr;
        //instance of Standard Controller
        ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(psr);
        //instance of Controller_Send_PSR
        Controller_Send_PSR sendPSRController = new Controller_Send_PSR(stdctrl);
       
        //calling public methods     
        sendPSRController.sendPSRAction();
        
    }
    
    
    static testMethod void testController_Send_PSR15(){
        
        Site_Information_Form__c site;
        //Quote quote = null;

        Opportunity oppty = new Opportunity();
        oppty.Name = 'TestOpp'; // 'Test class oppty for quote';
        oppty.StageName= 'Binding Offer';
        oppty.Closedate = System.today();
        insert oppty;

        //Opportunity insertedoppty = [select id,name from opportunity where name = 'TestOpp'];
        Quote quote = new Quote();
        quote.Name = 'Test quote';
        quote.Quote_Steps__c= 'TEst Array Layout';
        //quote.Quote_Status__c = 'Ordered';
        quote.opportunityid = oppty.id;
        insert quote;
        Account acc;
        
        for (Quote currentQuote :
            [Select q.Quote_Steps__c, q.Id 
                From Quote q 
                where quote_steps__c like '%Array Layout' and Quote_Status__c !='Expired'
                order by CreatedDate DESC limit 1]){
        
            quote=currentQuote;
            
        }
        quote.Proposal_Due__c = Date.today().addMonths(2);
        update quote;
        
        Id quoteId = '0Q080000000Gp95CAC';
        
        //creating test account
        //List<RecordType> accRecordTypeList = [SELECT Id FROM RecordType 
        //                                                WHERE SObjectType = 'Account'
        //                                                AND Name = 'Standard'];
        
        //Modified by Nikki - CS
        //Get RecordtypeId of Standard      
        Id standardRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        
        acc = new Account();
        //acc.RecordTypeId = accRecordTypeList.get(0).id;
        acc.RecordTypeId = standardRecTypeId;
        acc.CurrencyIsoCode = 'USD';
        acc.Industry = 'Other';
        acc.Name = 'test07';
        acc.BillingState = 'BillingState';
        acc.BillingCity = 'Jind';
        acc.BillingCountry = 'India';
        acc.BillingStreet = 'Rohtak Road';
        acc.BillingPostalCode = '126102';
        acc.Online_Order_Access__c = false;
        insert acc; 
        
        //creating test site
        //List<RecordType> siteRecordTypeList = [SELECT Id FROM RecordType 
        //                                                WHERE SObjectType = 'Site_Information_Form__c'
        //                                                AND Name = 'Standard Site'];
        //Modified By: Nikki - CS
        //Get RecordtypeId of Standard Site      
        Id standardSiteRecTypeId = Schema.SObjectType.Site_Information_Form__c.getRecordTypeInfosByName().get('Standard Site').getRecordTypeId();  
        
        site = new Site_Information_Form__c();
        //site.RecordTypeId = siteRecordTypeList.get(0).id;
        site.RecordTypeId = standardSiteRecTypeId;
        site.Account__c = acc.id;
        site.Site_Status__c = 'Active';
        site.Site_State__c = 'state';
        insert site;
        
        String recordTypeIdDesign;
                
        //querying record type id for family
        //List<RecordType> lstRecordTypes = [Select r.SobjectType, r.Name, r.Id, r.DeveloperName From RecordType r where r.Name = 'Proposal Design' and SobjectType ='Design__c' limit 1];
        //if(lstRecordTypes != null && lstRecordTypes.size() > 0){
        //    recordTypeIdDesign = lstRecordTypes.get(0).Id;
        //}
                
        //Modified by Nikki - CS
        //Get RecordtypeId of Standard Site      
        Id proposalRecTypeId = Schema.SObjectType.Design__c.getRecordTypeInfosByName().get('Proposal Design').getRecordTypeId();  
             
        Design__c testDesign1 = new Design__c();
        //testDesign1.PSR__c = psr1.Id;
        testDesign1.site__c = site.Id;
        //testDesign1.RecordTypeId = recordTypeIdDesign;
        testDesign1.RecordTypeId = proposalRecTypeId;
        //testDesign1.opportunity__c = testOpp.Id;
        testDesign1.Revision_Letter__c = 'A';
        //testDesign.Proposal_Designer__c = 
        testDesign1.Date_Design_Completed__c = System.today().addMonths(1);
        testDesign1.Status__c = 'Not Started';
        
        insert testDesign1;
                
        //create a psr record
        PSR__c psr = new PSR__c();
        psr.Site__c = site.id;
        psr.Design__c = null;
        //psr.Quote__c = quote.ID;
        psr.Quote__c = quoteId;
        psr.Array_Layout_Revision__c = true;
        psr.Array_Layout_Due__c = Date.today().addDays(-15);
        psr.Design_Urgent_Request__c = false;
        psr.Single_Line_based_on_Design__c = false;
        psr.Estimate_Urgent_Request__c = true;
        psr.PM_Cost_without_Design__c = true;
        psr.Cost_Estimate_Due__c = null;
        psr.Electrical_Support_Due__c = Date.today().addDays(5);
        psr.PM_Cost__c = false;
        psr.Single_Line_based_on_Design__c=true;
        psr.Site_Survey_Standard__c = false;
        //psr.Kickoff_Meeting_Date__c = date.today().addDays(2);
        insert psr;
        //instance of Standard Controller
        ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(psr);
        //instance of Controller_Send_PSR
        Controller_Send_PSR sendPSRController = new Controller_Send_PSR(stdctrl);
        
        //calling public methods     
        sendPSRController.sendPSRAction();
       
    }
    
    static testMethod void testController_Send_PSR16(){
        
        Site_Information_Form__c site;
       //Quote quote = null;

        Opportunity oppty = new Opportunity();
        oppty.Name = 'TestOpp'; // 'Test class oppty for quote';
        oppty.StageName= 'Binding Offer';
        oppty.Closedate = System.today();
        insert oppty;

        //Opportunity insertedoppty = [select id,name from opportunity where name = 'TestOpp'];
        Quote quote = new Quote();
        quote.Name = 'Test quote';
        quote.Quote_Steps__c= 'TEst Array Layout';
        //quote.Quote_Status__c = 'Ordered';
        quote.opportunityid = oppty.id;
        insert quote;
        Account acc;
        
        for (Quote currentQuote :
            [Select q.Quote_Steps__c, q.Id 
                From Quote q 
                where quote_steps__c like '%Array Layout' and Quote_Status__c !='Expired'
                order by CreatedDate DESC limit 1]){
        
            quote=currentQuote;
            
        }
        quote.Proposal_Due__c = Date.today().addMonths(2);
        update quote;
        
        Id quoteId = '0Q080000000Gp95CAC';
        
        //creating test account
        //List<RecordType> accRecordTypeList = [SELECT Id FROM RecordType 
        //                                                 WHERE SObjectType = 'Account'
        //                                                AND Name = 'Standard'];
        //Get RecordtypeId of Standard      
        Id standardRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        
        acc = new Account();
        //acc.RecordTypeId = accRecordTypeList.get(0).id;
        acc.RecordTypeId = standardRecTypeId;
        acc.CurrencyIsoCode = 'USD';
        acc.Industry = 'Other';
        acc.Name = 'test08';
        acc.BillingState = 'BillingState';
        acc.BillingCity = 'Jind';
        acc.BillingCountry = 'India';
        acc.BillingStreet = 'Rohtak Road';
        acc.BillingPostalCode = '126102';
        acc.Online_Order_Access__c = false;
        insert acc; 
        
        //creating test site
        //List<RecordType> siteRecordTypeList = [SELECT Id FROM RecordType 
        //                                                WHERE SObjectType = 'Site_Information_Form__c'
        //                                                AND Name = 'Standard Site'];
        //Modified By: Nikki - CS
        //Get RecordtypeId of Standard Site      
        Id standardSiteRecTypeId = Schema.SObjectType.Site_Information_Form__c.getRecordTypeInfosByName().get('Standard Site').getRecordTypeId();                                               
        site = new Site_Information_Form__c();
        //site.RecordTypeId = siteRecordTypeList.get(0).id;
        site.RecordTypeId = standardSiteRecTypeId;
        site.Account__c = acc.id;
        site.Site_Status__c = 'Active';
        site.Site_State__c = 'state';
        insert site;
        
        String recordTypeIdDesign;
                
        //querying record type id for family
        List<RecordType> lstRecordTypes = [Select r.SobjectType, r.Name, r.Id, r.DeveloperName From RecordType r where r.Name = 'Proposal Design' and SobjectType ='Design__c' limit 1];
        if(lstRecordTypes != null && lstRecordTypes.size() > 0){
            recordTypeIdDesign = lstRecordTypes.get(0).Id;
        }
                
        //Modified by Nikki - CS
        //Get RecordtypeId of Standard Site      
        Id proposalRecTypeId = Schema.SObjectType.Design__c.getRecordTypeInfosByName().get('Proposal Design').getRecordTypeId();         
        Design__c testDesign1 = new Design__c();
        
        //testDesign1.PSR__c = psr1.Id;
        testDesign1.site__c = site.Id;
        //testDesign1.RecordTypeId = recordTypeIdDesign;
        testDesign1.RecordTypeId = proposalRecTypeId;
        //testDesign1.opportunity__c = testOpp.Id;
        testDesign1.Revision_Letter__c = 'A';
        //testDesign.Proposal_Designer__c = 
        testDesign1.Date_Design_Completed__c = System.today().addMonths(1);
        testDesign1.Status__c = 'Not Started';
        
        insert testDesign1;
                
        //create a psr record
        PSR__c psr = new PSR__c();
        psr.Site__c = site.id;
        psr.Design__c = null;
        //psr.Quote__c = quote.ID;
        psr.Quote__c = quoteId;
        psr.Array_Layout__c = true;
        psr.Design_Urgent_Request__c = false;
        psr.Single_Line_based_on_Design__c = false;
        psr.Estimate_Urgent_Request__c = true;
        psr.PM_Cost_without_Design__c = true;
        psr.Cost_Estimate_Due__c = null;
        psr.Electrical_Support_Due__c = Date.today().addDays(5);
        psr.PM_Cost__c = false;
        psr.Site_Survey_Standard__c = false;
        //psr.Kickoff_Meeting_Date__c = date.today().addDays(2);
        insert psr;
        //instance of Standard Controller
        ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(psr);
        //instance of Controller_Send_PSR
        Controller_Send_PSR sendPSRController = new Controller_Send_PSR(stdctrl);
        
        //calling public methods     
        sendPSRController.sendPSRAction();
                
    }   
    
    static testMethod void testController_Send_PSR17(){
        
        //Pagereference p = new Pagereference('/apex/Send_PSR');
        //Test.setCurrentPage(p);
        Site_Information_Form__c site;
        //Quote quote = null;

        Opportunity oppty = new Opportunity();
        oppty.Name = 'TestOpp'; // 'Test class oppty for quote';
        oppty.StageName= 'Binding Offer';
        oppty.Closedate = System.today();
        insert oppty;

        //Opportunity insertedoppty = [select id,name from opportunity where name = 'TestOpp'];
        Quote quote = new Quote();
        quote.Name = 'Test quote';
        quote.Quote_Steps__c= 'TEst Array Layout';
        //quote.Quote_Status__c = 'Ordered';
        quote.opportunityid = oppty.id;
        insert quote;
        Account acc;
        
        for (Quote currentQuote :
            [Select q.Quote_Steps__c, q.Id 
                From Quote q 
                where quote_steps__c like '%Array Layout' and Quote_Status__c !='Expired'
                order by CreatedDate DESC limit 1]){
        
            quote=currentQuote;
            
        }
        quote.Proposal_Due__c = Date.today().addMonths(2);
        update quote;
        
        Id quoteId = '0Q080000000Gp95CAC';
        
        //creating test account
        //List<RecordType> accRecordTypeList = [SELECT Id FROM RecordType 
        //                                                WHERE SObjectType = 'Account'
        //                                                AND Name = 'Standard'];
        
        //Modified by: Nikki - CS
        //Get RecordtypeId of Standard      
        Id standardRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        
        acc = new Account();
        //acc.RecordTypeId = accRecordTypeList.get(0).id;
        acc.RecordTypeId = standardRecTypeId;
        acc.CurrencyIsoCode = 'USD';
        acc.Industry = 'Other';
        acc.Name = 'test09';
        acc.BillingState = 'BillingState';
        acc.BillingCity = 'Jind';
        acc.BillingCountry = 'India';
        acc.BillingStreet = 'Rohtak Road';
        acc.BillingPostalCode = '126102';
        acc.Online_Order_Access__c = false;
        insert acc; 
        
        //creating test site
        /*List<RecordType> siteRecordTypeList = [SELECT Id FROM RecordType 
                                               WHERE SObjectType = 'Site_Information_Form__c'
                                               AND Name = 'Standard Site'];*/
                                               
                                               
        //Modified by: Nikki - CS
        //Get RecordtypeId of Standard Site      
        Id standardSiteRecTypeId = Schema.SObjectType.Site_Information_Form__c.getRecordTypeInfosByName().get('Standard Site').getRecordTypeId();                                       
        
        site = new Site_Information_Form__c();
        //site.RecordTypeId = siteRecordTypeList.get(0).id;
        site.RecordTypeId = standardSiteRecTypeId;
        site.Account__c = acc.id;
        site.Site_Status__c = 'Active';
        site.Site_State__c = 'state';
        insert site;
        
        String recordTypeIdDesign;
                
        //querying record type id for family
        //List<RecordType> lstRecordTypes = [Select r.SobjectType, r.Name, r.Id, r.DeveloperName From RecordType r where r.Name = 'Proposal Design' and SobjectType ='Design__c' limit 1];
        //if(lstRecordTypes != null && lstRecordTypes.size() > 0){
        //    recordTypeIdDesign = lstRecordTypes.get(0).Id;
        //}
        
        //Modified by Nikki - CS
        //Get RecordtypeId of Standard Site      
        Id proposalRecTypeId = Schema.SObjectType.Design__c.getRecordTypeInfosByName().get('Proposal Design').getRecordTypeId();          
                
        Design__c testDesign1 = new Design__c();
        //testDesign1.PSR__c = psr1.Id;
        testDesign1.site__c = site.Id;
        //testDesign1.RecordTypeId = recordTypeIdDesign;
        testDesign1.RecordTypeId = proposalRecTypeId;
        //testDesign1.opportunity__c = testOpp.Id;
        testDesign1.Revision_Letter__c = 'A';
        //testDesign.Proposal_Designer__c = 
        testDesign1.Date_Design_Completed__c = System.today().addMonths(1);
        testDesign1.Status__c = 'Not Started';
        
        insert testDesign1;
                
        //create a psr record
        PSR__c psr = new PSR__c();
        psr.Site__c = site.id;
        //psr.Design__c = testDesign1.Id;
        //psr.Quote__c = quote.ID;
        psr.Quote__c = quoteId;
        //psr.Array_Layout__c = false;
        psr.Design_Urgent_Request__c = true;
        psr.Single_Line_based_on_Design__c = false;
        psr.Estimate_Urgent_Request__c = true;
        psr.Cost_Estimate_Due__c = null;
        psr.Electrical_Support_Due__c = Date.today().addDays(5);
        psr.PM_Cost__c = true;
        //psr.Site_Survey_Standard__c = true;
        //psr.Kickoff_Meeting_Date__c = date.today().addDays(2);
        psr.Array_Layout_Due__c = Date.today();
        psr.Array_Layout__c = true;
        psr.Design__c = null;
        psr.Site_Survey_Standard__c = false;

        insert psr;
        
        //instance of Standard Controller
        ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(psr);
        //instance of Controller_Send_PSR
        Controller_Send_PSR sendPSRController = new Controller_Send_PSR(stdctrl);
        
        //calling public methods     
        sendPSRController.sendPSRAction();
        Integer daycount=sendPSRController.getNumberOfDays(null, null);
        daycount=sendPSRController.getNumberOfDays(System.today(),System.today());
        daycount=sendPSRController.getNumberOfDays(System.today(),System.today().addDays(10));

    } 
    
}