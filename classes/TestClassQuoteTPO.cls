/*** Class added in Sunpower TPO Phase 1 -- 20/10/2013, to cover UpdateStatusOnQuote,TPO_CreateQLI,TPO_QLI_updateQuote,TPO_SolrifQLIUpdate,TriggertocreateLP ***/  
@isTest(seeAllData = true)
public class TestClassQuoteTPO {/*
 private static String ITEM_ID_FAKE = '1234123123123x';
 
    //Test Method to cover UpdateStatusOnQuote Trigger.
    static testMethod void testUpdateStatusOnQuote(){
    //create account
        Account acc = new Account();
        acc.Name = 'Test AccountQuote';
        acc.Type ='Home Owner';
        acc.BillingCity = 'Cassis';
        acc.BillingStreet = 'Cassis';
        acc.BillingPostalCode ='13260';
        acc.BillingCountry = 'France'; 
        acc.Country_Domain__c = 'rvar-fr';
        
        insert acc;
        
        //Create Quote
        Quote newQuote;
        Opportunity newOpportunity;
        newOpportunity = [Select Id from Opportunity Where Name='Test Class DO NOT TOUCH'];
        newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test ', newOpportunity.Id, false).get(0);
        insert newQuote;
           
        String caseRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Service Case').getRecordTypeId();
        
        //create case
        Case newCase = new Case();       
        newCase.Status = 'New';
        newCase.RecordTypeId = caseRecTypeId;
        newCase.AccountId = acc.Id;
        newCase.Quote__c = newQuote.id;
        insert newCase;

        Test.startTest();
        newCase.Status = 'In Process';
        update newCase;
    
        newCase.Status = 'Assigned';
     //   update newCase;

        newCase.Status = 'Waiting for Partner Response';
      //  update newCase;

        newCase.Status = 'Closed';
      //  update newCase;
        Test.StopTest();  
     }
  
   //Test Method to cover TPO_CreateQLI Class.
   static testMethod void TestTPO_CreateQLI(){
        //create Quote
        Quote newQuote;
        Opportunity newOpportunity;
        newOpportunity = [Select Id from Opportunity Where Name='Test Class DO NOT TOUCH'];
        newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test ', newOpportunity.Id, false).get(0);
        newQuote.Inverter_Model_Roof1__c ='SPR-600P-TL1-EU';
        newQuote.Inverter_Model__c='model1';
        newQuote.Inverter_Model_Roof2__c='roof2';
        newQuote.Inverter_Model_2__c='model2';
        newQuote.Inverter_Model_Roof3__c='roof3';
        newQuote.Inverter_Model_3__c='model3';
        newQuote.Inverter_Model_Roof4__c='roof4';
        newQuote.Inverter_Model_4__c='model4';
        newQuote.Wiring_Distance__c = 'greater than 2.5 meters';
        insert newQuote;
        system.debug('########'+newQuote.id);
        
        Id quoteID = newQuote.Id; 
       
        Global_Variable__c newGlobalVariable = new Global_Variable__c();
        Date dt = date.today()+2;
        newGlobalVariable.Start_Date__c = Date.parse('9/9/2013');
        newGlobalVariable.End_Date__c = dt;
        newGlobalVariable.Variable_Type__c = 'TPO France';
        newGlobalVariable.Variable_Value__c = '0';
        newGlobalVariable.Name = 'FitRate';
        insert newGlobalVariable;
        
        Global_Variable__c newGlobalVariable1 = new Global_Variable__c();
        Date dt1 = date.today()+2;
        newGlobalVariable1.Start_Date__c = Date.parse('9/9/2013');
        newGlobalVariable1.End_Date__c = dt1;
        newGlobalVariable1.Variable_Type__c = 'TPO France';
        newGlobalVariable1.Variable_Value__c = '0';
        newGlobalVariable1.Name = 'ERDFFee';
        insert newGlobalVariable1;
        
        Global_Variable__c newGlobalVariable2 = new Global_Variable__c();
        Date dt2 = date.today()+2;
        newGlobalVariable2.Start_Date__c = Date.parse('9/9/2013');
        newGlobalVariable2.End_Date__c = dt2;
        newGlobalVariable2.Variable_Type__c = 'TPO France';
        newGlobalVariable2.Variable_Value__c = '0';
        newGlobalVariable2.Name = 'Origination';
        insert newGlobalVariable2;
        
        Global_Variable__c newGlobalVariable3 = new Global_Variable__c();
        Date dt3 = date.today()+2;
        newGlobalVariable3.Start_Date__c = Date.parse('9/9/2013');
        newGlobalVariable3.End_Date__c = dt3;
        newGlobalVariable3.Variable_Type__c = 'TPO France';
        newGlobalVariable3.Variable_Value__c = '0';
        newGlobalVariable3.Name = 'Interconnection';
        insert newGlobalVariable3;
        
        Global_Variable__c newGlobalVariable4 = new Global_Variable__c();
        Date dt4 = date.today()+2;
        newGlobalVariable4.Start_Date__c = Date.parse('9/9/2013');
        newGlobalVariable4.End_Date__c = dt4;
        newGlobalVariable4.Variable_Type__c = 'TPO France';
        newGlobalVariable4.Variable_Value__c = '0';
        newGlobalVariable4.Name = 'FITRateEsc';
        insert newGlobalVariable4;
       
        Price_List__c priceItem = new Price_List__c();
        priceItem.Name='TPO FR Pricelist';
        priceItem.DSR_PO_Group_Email__c='commande@sunpowercorp.com';
        priceItem.CurrencyIsoCode='EUR';
        insert priceItem;
       
        TPO_CreateQLI QLI = new TPO_CreateQLI(new ApexPages.StandardController(new Quote()));
        apexPages.currentPage().getParameters().put('qid',quoteID);
        QLI.createQuoteLine();
        
    }
    
    
    //Test Method to cover TPO_Create TPO_QLI_updateQuote and TPO_SolrifQLIUpdate.
    static testMethod void TestTPO_QLI_updateQuote(){
    
        Account newAccount = new Account();
        newAccount.Name = 'Test AccountQuote';
        newAccount.Type ='Home Owner';
        newAccount.BillingCity = 'Cassis';
        newAccount.BillingStreet = 'Cassis';
        newAccount.BillingPostalCode ='13260';
        newAccount.BillingCountry = 'France'; 
        newAccount.Country_Domain__c = 'rvar-fr';
        
        insert newAccount;
       
        //create Contact
        Contact con;
        con = TestUtils.createContact( 'testcon', newAccount.id, false);
        con.Phone = '22 33 44 55 66';
        insert con;
        
        //create Item
        Item__c newItem = new Item__c(Item_ID__c = ITEM_ID_FAKE,Product_Type__c= 'testtype');
        insert newItem;
        
        //Create Opportunity
        Opportunity newOpportunity;
        newOpportunity = TestUtils.createOpportunities( 1, newAccount.id, con.id, false).get(0);
        insert newOpportunity;
            
        //create Quote
        Quote newQuote;
        //newOpportunity = [Select Id from Opportunity Where Name='Test Class DO NOT TOUCH'];
        newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test ', newOpportunity.Id, false).get(0);
        newQuote.Account__c = newAccount.id;
        newQuote.Module_Oracle_Item_Number__c = newItem.id;
        insert newQuote;
        
        //Create Price List
        Price_List__c priceList = new Price_List__c();
        priceList.Name='TPO FR Pricelist';
        priceList.CurrencyIsoCode='EUR';
        priceList.DSR_PO_Group_Email__c = 'commande@sunpowercorp.com';
        insert priceList;
        
        //Create Price list Item
        Price_List_Item__c newpricelistitem = new Price_List_Item__c();
        newpricelistitem.Name='SPR E20 327';
        newpricelistitem.Item_ID__c = newItem.id;
        newpricelistitem.CurrencyIsoCode='EUR';
        newPricelistitem.Price_List__c = priceList.id;
        newpricelistitem.Manufacturing_cost__c = 0.0; 
        newPricelistitem.Category__c = 'Module';
        insert newpricelistitem;
        
        List<Quote_Line__c> qllist = new List<Quote_Line__c>();
        //create Quoteline
        Quote_Line__c newQL1 = new Quote_Line__c(Item__c = newItem.id,Quote__c = newQuote.id,Roof__c = 'Roof 1',Quantity__c = 1000);
        //insert newQL1;
        qllist.add(newQL1);
        
        Quote_Line__c newQL2 = new Quote_Line__c(Item__c = newItem.id,Quote__c = newQuote.id,Roof__c = 'Roof 2',Quantity__c = 1000);
        //iert newQL2;
        qllist.add(newQL2);
        
        Quote_Line__c newQL3 = new Quote_Line__c(Item__c = newItem.id,Quote__c = newQuote.id,Roof__c = 'Roof 3',Quantity__c = 1000);
       //isert newQL3;
        qllist.add(newQL3);
        
        Quote_Line__c newQL4 = new Quote_Line__c(Item__c = newItem.id,Quote__c = newQuote.id,Roof__c = 'Roof 4',Quantity__c = 1000);
        //insert newQL4;
        qllist.add(newQL4);
        insert qllist;
        
    }
    
    //Test method to cover TPO_QLI_updateQuote
    static testMethod void TestTPO_QLI_updateQuote2(){
    
        SFDCSpecialUtilities.isRunningTest = True;
        test.startTest();
        
        Account newAccount = new Account();
        newAccount.Name = 'Test AccountQuote';
        newAccount.Type ='Home Owner';
        newAccount.BillingCity = 'Cassis';
        newAccount.BillingStreet = 'Cassis';
        newAccount.BillingPostalCode ='13260';
        newAccount.BillingCountry = 'France'; 
        newAccount.Country_Domain__c = 'rvar-fr';
        
        insert newAccount;
       
        //create Contact
        Contact con;
        con = TestUtils.createContact( 'testcon', newAccount.id, false);
        con.Phone = '22 33 44 55 66';
        insert con;
        
        //create Item
        Item__c newItem = new Item__c(Item_ID__c = ITEM_ID_FAKE,Product_Type__c= 'testtype');
        insert newItem;
        
        //Create Opportunity
        Opportunity newOpportunity;
        newOpportunity = TestUtils.createOpportunities( 1, newAccount.id, con.id, false).get(0);
        insert newOpportunity;
            
        //create Quote
        Quote newQuote;
        //newOpportunity = [Select Id from Opportunity Where Name='Test Class DO NOT TOUCH'];
        newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test ', newOpportunity.Id, false).get(0);
        newQuote.Account__c = newAccount.id;
        newQuote.Module_Oracle_Item_Number__c = newItem.id;
        insert newQuote;
        
        Quote_Line__c newQL1 = new Quote_Line__c(Item__c = newItem.id,Quote__c = newQuote.id,Roof__c = 'Roof 1',Quantity__c = 1000);
        insert newQL1;
        
        
       /* Quote_Line__c newQL2 = new Quote_Line__c(Item__c = newItem.id,Quote__c = newQuote.id,Roof__c = 'Roof 2',Quantity__c = 1000);
        insert newQL2;
        
        
        Quote_Line__c newQL3 = new Quote_Line__c(Item__c = newItem.id,Quote__c = newQuote.id,Roof__c = 'Roof 3',Quantity__c = 1000);
        insert newQL3;
        
        
        Quote_Line__c newQL4 = new Quote_Line__c(Item__c = newItem.id,Quote__c = newQuote.id,Roof__c = 'Roof 4',Quantity__c = 1000);
        insert newQL4;*//*
        
        test.stoptest();
        
    }
    
    
    //Test Method to cover TriggertocreateLP Trigger.
    static testMethod void testTriggertocreateLP(){
        //create account
        
        Account newAccount;
        newAccount = [Select ID from Account Where Name='Test Class DO NOT TOUCH'];
        
        //Create Quote
        Quote newQuote;
        Opportunity newOpportunity;
        newOpportunity = [Select Id from Opportunity Where Name='Test Class DO NOT TOUCH'];
        newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test ', newOpportunity.Id, false).get(0);
        insert newQuote;
        
        //Create LeasePayment
        LeasePayment__c newLP = new LeasePayment__c();
        newLP.Account__c = newAccount.Id;
        insert newLP;

        //Create Agreement
        echosign_dev1__SIGN_Agreement__c newAgreement = new echosign_dev1__SIGN_Agreement__c();
        newAgreement.Account__c = newAccount.id;
        newAgreement.Agg_created_through__c='LOI';
        newAgreement.Quote__c=newQuote.id;
        insert newAgreement;
        newAgreement.Agreement_Name__c= 'Test Agr';
        update newAgreement;
        
        
    }
    
    //Test Method to cover TPO_CreateNewCaseExt Class.
    /*static testMethod void testTPO_CreateNewCaseExt(){
    Account acc = new Account(Name = 'tesee', Account_Status__c = 'Active', 
                            BillingStreet = 'West Mare', BillingCity = 'SanFrancisco', BillingPostalCode = '2345', BillingCountry = 'United States of America', Phone = '1234');
    insert acc;
    
    Contact newContact;
    newContact = TestUtils.createContact('TESCONTACTT', acc.Id, true );
    upsert newContact ;
    
    Quote newQuote;
    Opportunity newOpportunity;
    newOpportunity = [Select Id from Opportunity Where Name='Test Class DO NOT TOUCH'];
    newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test ', newOpportunity.Id, false).get(0);
    insert newQuote;

    Id quoteID = newQuote.Id; 
  
    TPO_CreateNewCaseExt caseExt = new TPO_CreateNewCaseExt();
    ApexPages.currentPage().getParameters().put('qid',quoteID);
    ApexPages.currentPage().getParameters().put('aid', acc.id);
    caseExt.Description = 'Test Data';
    caseExt.fileBody = Blob.valueOf('Unit Test Attachment Body');
    caseExt.fileName = 'test Attchment';
    caseExt.createCase();

  }*/
    
    
    //Test Method to cover ViewPVSIMResponseController Class.
   /*static testMethod void TestViewPVSIMResponseController(){
    Opportunity newOpportunity;
    Quote newQuote;
    newOpportunity = [Select Id from Opportunity Where Name='Test Class DO NOT TOUCH'];
    newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test ', newOpportunity.Id, false).get(0);
    insert newQuote;
    
    System_Production__c newSysPro = new System_Production__c(Quote__c = newQuote.id);
    insert newSysPro;
    
    ApexPages.currentPage().getParameters().put('systemId',newSysPro.id);
    ViewPVSIMResponseController vprc = new ViewPVSIMResponseController();
    }*/
    
}