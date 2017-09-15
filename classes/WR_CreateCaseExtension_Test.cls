/*******************************************************************
  Name          :    WR_CreateCaseExtension_Test     
  Purpose       :    Test class for WR_CreateCaseExtension
  
  Created by    :    Anjali Khandelwal(Appirio Off)
  Created Date  :    9th Sept, 2011
  Revision History:
  09.SEP.2011    Anjali Khandelwal    Created.
  24.MAR.2014    Michelle Magsarili   Test class to accommodate change Case RecordType to PSR Case CR Implementation changes
********************************************************************/
@isTest
private class WR_CreateCaseExtension_Test {
    
    static User test_user;
    static List<Warranty_Registration__c> lstwarranty;
    
    static testMethod void testCaseNALogger() {
        createTestNAData();  
        
        //MAM 03/24/2014 Retrieve the Account record created by createTestNAData method
        Account acct = [select id from Account where Email__c = 'partnerstest@test.com'];
        //MAM 03/24/2014 end 
        
        System.runAs(test_user){ 
        
            createTestNADataAsPartnerAccount(acct); //MAM 03/24/2014 create a Residential Account and Warranty Registration record as a Partner Portal User
            
            Test.startTest();       
                ApexPages.currentPage().getParameters().put('warrantyId',lstwarranty[0].Id);
                ApexPages.currentPage().getParameters().put('caseType','Packing Slip');
                ApexPages.currentPage().getParameters().put('numList','testPackingSlip1');
                ApexPages.currentPage().getParameters().put('errMsg','Records Not found');
                
                String strTestDate = '3/24/2014';
                ApexPages.currentPage().getParameters().put('stDate',strTestDate);
                ApexPages.currentPage().getParameters().put('endDt',strTestDate);
                
                ApexPages.StandardController controller = new ApexPages.StandardController(lstwarranty[0]);
                WR_CreateCaseExtension extension = new WR_CreateCaseExtension(controller);
                extension.filecontent = blob.valueOf('test');
                extension.logCase();
                system.assert(extension.caseLog.Id != null);
                Case testCase = [Select c.Type, c.Subject, c.OwnerId, c.Origin, c.Functional_Area__c, c.Description, c.ContactId, c.CaseNumber, c.Business_Unit__c, c.AccountId From Case c where id =: extension.caseLog.Id];
                
            Test.stopTest();
        }
    }
    
    //MAM 03/24/2014 New method createTestNADataAsPartnerAccount
    private static void createTestNADataAsPartnerAccount(Account a){
        date edt = System.today();
            
        //Start new context 
        List<Account> lstCust = new List<Account>();
        // DummyCustomerAcc1
        Account customer1 = new Account(Name='DCAcc1',CurrencyIsoCode='USD',Theater__c='North America',BillingCity='testCity',BillingCountry='testCountry',BillingStreet='testStreet',BillingPostalCode='testZipCode',Email__c = 'test@test.com'); 
        lstCust.add(customer1);
        insert lstCust;
        
         //Create Warranties
        lstwarranty = new List<Warranty_Registration__c>();
        Warranty_Registration__c wrc_test1 = new Warranty_Registration__c(Delivery_Date__c=edt,Partner_SFDC_ID__c=a.Id,Customer_SFDC_ID__c=customer1.Id,status__c = 'Draft');    
        lstwarranty.add(wrc_test1);    
        insert lstwarranty;     
        
    }
    //MAM 03/24/2014 end
     
    private static void createTestNAData()
    {
        date edt = System.today();
        Account acct = getNAPartnerAccount();
        test_user =getPartnerPortalUser(acct);  
        
        //MAM 03/24/2014 Create Custom Setting
        /*Warranty_Case_Owner__c CS_WCO = new Warranty_Case_Owner__c();
        CS_WCO.Name = 'Case Owner ID';
        CS_WCO.WR_CaseOwnerId__c = '00G80000002fWfD';
        insert CS_WCO;*/
        //MAM 03/24/2014 end 
        
        
        List<Account> lstCust = new List<Account>();
        // DummyCustomerAcc1
        Account customer1 = new Account(Name='DCAcc1',CurrencyIsoCode='USD',Theater__c='North America',BillingCity='testCity',BillingCountry='testCountry',BillingStreet='testStreet',BillingPostalCode='testZipCode',Email__c = 'test@test.com'); 
        lstCust.add(customer1);
        insert lstCust;        
        //Create Warranties
        lstwarranty = new List<Warranty_Registration__c>();
        Warranty_Registration__c wrc_test1 = new Warranty_Registration__c(Delivery_Date__c=edt,Partner_SFDC_ID__c=acct.Id,Customer_SFDC_ID__c=customer1.Id,status__c = 'Draft');    
        lstwarranty.add(wrc_test1);    
        insert lstwarranty;         
        edt = System.today();
        //Create SaleOrder
        WR_ORACLE_SalesOrder__c salesOrder1 = new WR_ORACLE_SalesOrder__c(Sales_Order__c='test_salesorder1',CurrencyIsoCode='USD',Oracle_Account_Number__c='test_oracle',Packing_Slip__c='testPackingSlip1',So_Created__c = System.today());
        insert salesOrder1;
        //Create instances of WR_FDS_Product__c
        WR_FDS_Product__c salesOrderLnItem1 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip1',WR_ORACLE_SalesOrder__c = salesOrder1.Id, Converted_to_asset__c = false,Product_Type__c='MODULE',Serial_Number__c = '111');
        insert salesOrderLnItem1;   
        
       
    }
    
    //Create Partner Portal user
     private static User getPartnerPortalUser(Account acct){
        User user = null;
       
        if(acct == null){
            acct =  getNAPartnerAccount();
        }
        Contact cont = new Contact(AccountID = acct.id,FirstName='testconbyPO2',LastName='testconbyPO2');
        cont.Email ='te@test.com';
        cont.Authorized_to_Order__c = true;
        cont.RecordTypeID =  util.GetRecordTypeIdsByDeveloperName(Contact.SObjectType).get('Partner'); //MAM 19.MAY.2015 Get Contact Partner RecordTypeId
        insert cont;        
        
        String username ='anjalitest@test1.com';      
        user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
        user.Edit_Partner_Users__c = true;
        user.ContactId = cont.Id;
        user.Username = username;
        user.Alias = 'anjali';
        user.CommunityNickname = username.subString(0,7);
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.Email = cont.Email;
        user.LocaleSidKey = 'en_US';     
        List<Profile> lstProfile = [select Id from Profile where Name = 'Partner Delegated Administrator'];
        if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            insert user;
        }
        if(user.Id != null)
          for(User u:[select id,Name,contactId,Contact.AccountID, Contact.Account.AccountNumber,Contact.Account.CurrencyIsoCode,Contact.Account.Name,Contact.Account.Country_Domain__c,Contact.Account.Theater__c,Contact.Account.ShippingStreet,Contact.Account.ShippingState,Contact.Account.ShippingCity,Contact.Account.ShippingCountry,Contact.Account.ShippingPostalCode,Contact.Account.Oracle_Operating_Unit__c, Contact.Account.Oracle_Account_Number__c from User where id =:user.ID LIMIT 1])
            user = u; 
        return user;        
    }
     
     //Create Partner Account 
     private static Account getNAPartnerAccount(){
        String recType ='';
        for(RecordType r:[select id,Name from RecordType where sObjectType ='Account' and name ='Partner' LIMIT 1])
             recType = r.ID;             
        Account acct = new Account(Name='test1'+String.valueOf(DateTime.now().getTime()),recordTypeID=recType);
        acct.ShippingCity = 'Jaipur';
        acct.ShippingStreet = 'Durgapura';
        acct.ShippingCountry = 'India';
        acct.ShippingState='Rajasthan';
        acct.ShippingPostalCode ='302018';
        acct.BillingCity = 'Jaipur';
        acct.BillingStreet = 'Durgapura';
        acct.BillingCountry = 'United States';
        acct.BillingState='NJ';
        acct.BillingPostalCode ='302018';
        acct.Online_Order_Access__c = true;
        acct.Oracle_Account_Number__c = 'test_oracle';
        acct.Theater__c = 'North America';
        acct.CurrencyIsoCode='USD';
        acct.Country_Domain__c = 'rvar-us';
        acct.Email__c = 'partnerstest@test.com';
        acct.phone = '111-222-3333';
        insert acct;
        return acct;                     
    }     
    
    static testMethod void testCaseEULogger() {
        createTestEUData();  
        
        //MAM 03/24/2014 Retrieve the Account record created by createTestNAData method
        Account acct = [select id from Account where Email__c = 'partnerstest@test.com'];
        //MAM 03/24/2014 end 
        
        System.runAs(test_user){ 
        
            createTestEUDataAsPartnerAccount(acct); //MAM 03/24/2014 create a Residential Account and Warranty Registration record as a Partner Portal User
            
            Test.startTest();       
                ApexPages.currentPage().getParameters().put('warrantyId',lstwarranty[0].Id);
                ApexPages.currentPage().getParameters().put('caseType','Packing Slip');
                ApexPages.currentPage().getParameters().put('numList','testPackingSlip1');
                ApexPages.currentPage().getParameters().put('errMsg','Records Not found');
                ApexPages.StandardController controller = new ApexPages.StandardController(lstwarranty[0]);
                WR_CreateCaseExtension extension = new WR_CreateCaseExtension(controller);
                extension.filecontent = blob.valueOf('test');
                extension.logCase();
                system.assert(extension.caseLog.Id != null);
                Case testCase = [Select c.Type, c.Subject, c.OwnerId, c.Origin, c.Functional_Area__c, c.Description, c.ContactId, c.CaseNumber, c.Business_Unit__c, c.AccountId From Case c where id =: extension.caseLog.Id];
                
            Test.stopTest();
        }
    }
    
    //MAM 03/24/2014 New method createTestNADataAsPartnerAccount
    private static void createTestEUDataAsPartnerAccount(Account a){
        date edt = System.today();
            
        //Start new context 
        List<Account> lstCust = new List<Account>();
        // DummyCustomerAcc1
        Account customer1 = new Account(Name='DCAcc1',CurrencyIsoCode='EUR',Theater__c='Europe',BillingCity='testCity',BillingCountry='testCountry',BillingStreet='testStreet',BillingPostalCode='testZipCode',Email__c = 'test@test.com'); 
        lstCust.add(customer1);
        insert lstCust;
        
         //Create Warranties
        lstwarranty = new List<Warranty_Registration__c>();
        Warranty_Registration__c wrc_test1 = new Warranty_Registration__c(Delivery_Date__c=edt,Partner_SFDC_ID__c=a.Id,Customer_SFDC_ID__c=customer1.Id,status__c = 'Draft');    
        lstwarranty.add(wrc_test1);    
        insert lstwarranty;     
        
    }
    //MAM 03/24/2014 end
     
    private static void createTestEUData()
    {
        date edt = System.today();
        Account acct = getEUPartnerAccount();
        test_user =getPartnerPortalUser(acct);  
        
        //MAM 03/24/2014 Create Custom Setting
        /*Warranty_Case_Owner__c CS_WCO = new Warranty_Case_Owner__c();
        CS_WCO.Name = 'Case Owner ID';
        CS_WCO.WR_CaseOwnerId__c = '00G80000002fWfD';
        insert CS_WCO;*/
        //MAM 03/24/2014 end 
        
        
        List<Account> lstCust = new List<Account>();
        // DummyCustomerAcc1
        Account customer1 = new Account(Name='DCAcc1',CurrencyIsoCode='EUR',Theater__c='Europe',BillingCity='testCity',BillingCountry='testCountry',BillingStreet='testStreet',BillingPostalCode='testZipCode',Email__c = 'test@test.com'); 
        lstCust.add(customer1);
        insert lstCust;        
        //Create Warranties
        lstwarranty = new List<Warranty_Registration__c>();
        Warranty_Registration__c wrc_test1 = new Warranty_Registration__c(Delivery_Date__c=edt,Partner_SFDC_ID__c=acct.Id,Customer_SFDC_ID__c=customer1.Id,status__c = 'Draft');    
        lstwarranty.add(wrc_test1);    
        insert lstwarranty;         
        edt = System.today();
        //Create SaleOrder
        WR_ORACLE_SalesOrder__c salesOrder1 = new WR_ORACLE_SalesOrder__c(Sales_Order__c='test_salesorder1',CurrencyIsoCode='EUR',Oracle_Account_Number__c='test_oracle',Packing_Slip__c='testPackingSlip1',So_Created__c = System.today());
        insert salesOrder1;
        //Create instances of WR_FDS_Product__c
        WR_FDS_Product__c salesOrderLnItem1 = new WR_FDS_Product__c(CurrencyIsoCode='EUR',Packing_Slip__c='testPackingSlip1',WR_ORACLE_SalesOrder__c = salesOrder1.Id, Converted_to_asset__c = false,Product_Type__c='MODULE',Serial_Number__c = '111');
        insert salesOrderLnItem1;   
        
       
    }
    
    
     //Create EU Partner Account 
     private static Account getEUPartnerAccount(){
        String recType ='';
        for(RecordType r:[select id,Name from RecordType where sObjectType ='Account' and name ='Partner' LIMIT 1])
             recType = r.ID;             
        Account acct = new Account(Name='test1'+String.valueOf(DateTime.now().getTime()),recordTypeID=recType);
        acct.ShippingCity = 'Jaipur';
        acct.ShippingStreet = 'Durgapura';
        acct.ShippingCountry = 'India';
        acct.ShippingState='Rajasthan';
        acct.ShippingPostalCode ='302018';
        acct.BillingCity = 'Jaipur';
        acct.BillingStreet = 'Durgapura';
        acct.BillingCountry = 'France';
        acct.BillingState='FR';
        acct.BillingPostalCode ='302018';
        acct.Online_Order_Access__c = true;
        acct.Oracle_Account_Number__c = 'test_oracle';
        acct.Oracle_Operating_Unit__c = 'SPFR OU';
        acct.Theater__c = 'Europe';
        acct.CurrencyIsoCode='EUR';
        acct.Country_Domain__c = 'rvar-fr';
        acct.Email__c = 'partnerstest@test.com';
        acct.phone = '111-222-3333';
        insert acct;
        return acct;                     
    }     
}