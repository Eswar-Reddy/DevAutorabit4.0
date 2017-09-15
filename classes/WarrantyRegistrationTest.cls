/**
 Created By : Paritosh
 Created on :- 02/08/2013
 Code Covered:- Class:- WarrantyRegistration, GenerateWarranty_CLS

Revision History:
MAM 16.JUN.2015 - Moved some of the testmethods of WarrantyRegistrationTest to  WarrentyRegistrationCustom_Test

 */
@isTest
private class WarrantyRegistrationTest {
    
    static Warranty_Registration__c wrc_test1;
    static Warranty_Registration__c wrc_test2;
    static WarrantyRegistrationController wrc;
    static Attachment testAttachment;
    static Integer i=1;
    static List<WR_ORACLE_SalesOrder__c> lstSalesOrder;
    static List<WR_FDS_Product__c> lstProduct;
    static List<WR_FDS_Product__c> lstProduct1; 

    //This method is used to test classes "WarrantyRegistration" and "GenerateWarranty_CLS"
    static testMethod void testWarrantyRegistrationPDF() {
        
        WarrantyRegistrationController wrc1;
        Account acct = getEUItalyPartnerAccount();
        User test_user =getPartnerPortalUser(acct); 
        System.runAs(test_user){ 
        
              
        acct = test_user.Contact.Account;
        Opportunity test_opp1 = createOpp(acct,test_user);
        test_opp1.Warranty_Signed_Italy__c = true;
        insert test_opp1;       
        Date edt = System.today();
        
        //Insert List of customer in database
        List<Account> lstCust = new List<Account>();
        Account customer1 = new Account(Name='DummyCustomerAcc1',CurrencyIsoCode='EUR',Theater__c='Europe',BillingCity='testCity',BillingCountry='Italy',BillingStreet='testStreet',BillingPostalCode='testZipCode',Country_Domain__c = 'combo-it');
        lstCust.add(customer1);
        Account customer2 = new Account(Name='DummyCustomerAcc2',CurrencyIsoCode='EUR',Theater__c='Europe',BillingCity='testCity1',BillingCountry='Italy',BillingStreet='testStreet1',BillingPostalCode='testZipCode1',Country_Domain__c = 'combo-it');
        lstCust.add(customer2);
        insert lstCust;
        
        //Create Opportunity for customers
        List<Opportunity> lstOpp = new List<Opportunity>();
        Opportunity test_opp2 = createOpp(customer1,test_user);
        Opportunity test_opp3 = createOpp(customer2,test_user);
        test_opp2.Warranty_Signed_Italy__c = true;
        test_opp3.Warranty_Signed_Italy__c = true;
        lstOpp.add(test_opp2);
        lstOpp.add(test_opp3);
        //Start new context       
        Test.startTest(); 
        insert lstOpp;     
           
        List<Warranty_Registration__c> lstwarranty = new List<Warranty_Registration__c>();
        wrc_test1 = new Warranty_Registration__c(Delivery_Date__c=edt,Partner_SFDC_ID__c=acct.Id,Customer_SFDC_ID__c=customer1.Id,status__c = 'Draft');    
        lstwarranty.add(wrc_test1);    
        wrc_test2 = new Warranty_Registration__c(Delivery_Date__c=edt,Partner_SFDC_ID__c=acct.Id,Customer_SFDC_ID__c=customer2.Id,status__c = 'Draft');    
        lstwarranty.add(wrc_test2);       
        insert lstwarranty;    
        //createData(wrc_test1);
        wrc = new WarrantyRegistrationController(); 
        ApexPages.currentPage().getParameters().put('warrantyNumber',wrc_test1.Id);
        ApexPages.currentPage().getParameters().put('warrantyID',wrc_test1.Id);
        ApexPages.currentPage().getParameters().put('customerNumber',wrc_test1.Customer_SFDC_ID__c);
        wrc.resumeRegistration(); //Resume registration successfully
        wrc.createCustomerRequest(); //Create customer request
        //Insert required fields in Customer        
        wrc.newCustomer.BillingCity='testCity';
        wrc.newCustomer.BillingCountry='Italy';
        wrc.newCustomer.BillingStreet='testStreet';
        wrc.newCustomer.BillingPostalCode='testZipCode';
        wrc.newCustomer.Name='cust_test';        
        wrc.newCustomer.Theater__c = 'Europe';
        wrc.newCustomer.CurrencyIsoCode='EUR';
        wrc.newCustomer.Country_Domain__c = 'rvar-it';
        wrc.newCustomer.Email__c = 'RA'+String.valueof(Math.Random())+'@testUniqEmail'+String.valueof(Math.Random())+'.com';
        Attachment att1 = createAttachment();
        //Add attachment to docList
        wrc.docList.add(att1);
        //Move to step 5 when warranty.delivery_date__c = null
        ApexPages.currentPage().getParameters().put('step','5');
       // wrc.warranty.delivery_date__c = null;  
        wrc.warranty.delivery_date__c = System.today() + 10;  
        createData(wrc_test1); 
        ApexPages.currentPage().getParameters().put('Id',wrc_test1.Id);
        WarrantyRegistration wr = new WarrantyRegistration();
                wr.attachPDF(wrc.warranty.Id, 'de');  
                wr.attachPDF(wrc.warranty.Id, 'fr_BE'); 
                wr.attachPDF(wrc.warranty.Id, 'fr'); 
                wr.attachPDF(wrc.warranty.Id, 'it'); 
                wr.attachPDF(wrc.warranty.Id, 'es'); 
                wr.attachPDF(wrc.warranty.Id, 'nl_BE'); 
                wr.attachPDF(wrc.warranty.Id, 'en_GB'); 
       // ApexPages.currentPage().getParameters().put('warrantyID',wrc_test1.Id);
        GenerateWarranty_CLS GWC = new GenerateWarranty_CLS(new ApexPages.StandardController(wrc_test1));
        GWC.viewDetails();
       //PageReference newpg= Page.Generate_Warranty_German; 
       Test.stopTest();
    }
    
        
    }
    
    //MAM 16.JUN.2015 moved to WarrentyRegistrationCustom_Test class
    //This method is used to test classes "WarrentyRegistrationCustom"
    /*
    static testMethod void testWarrentyRegistrationCustom() {
        WarrantyRegistrationController wrc1;
        Account acct = getEUItalyPartnerAccount();
        User test_user =getPartnerPortalUser(acct); 
        
        System.runAs(test_user){ 
                  
            acct = test_user.Contact.Account;
            Opportunity test_opp1 = createOpp(acct,test_user);
            test_opp1.Warranty_Signed_Italy__c = true;
            insert test_opp1;       
            Date edt = System.today();
            
            //Insert List of customer in database
            List<Account> lstCust = new List<Account>();
            Account customer1 = new Account(Name='DummyCustomerAcc1',CurrencyIsoCode='EUR',Theater__c='Europe',BillingCity='testCity',BillingCountry='Italy',BillingStreet='testStreet',BillingPostalCode='testZipCode',Country_Domain__c = 'combo-it');
            lstCust.add(customer1);
            Account customer2 = new Account(Name='DummyCustomerAcc2',CurrencyIsoCode='EUR',Theater__c='Europe',BillingCity='testCity1',BillingCountry='Italy',BillingStreet='testStreet1',BillingPostalCode='testZipCode1',Country_Domain__c = 'combo-it');
            lstCust.add(customer2);
            insert lstCust;
            
            //Create Opportunity for customers
            List<Opportunity> lstOpp = new List<Opportunity>();
            Opportunity test_opp2 = createOpp(customer1,test_user);
            Opportunity test_opp3 = createOpp(customer2,test_user);
            test_opp2.Warranty_Signed_Italy__c = true;
            test_opp3.Warranty_Signed_Italy__c = true;
            lstOpp.add(test_opp2);
            lstOpp.add(test_opp3);
            //Start new context       
            Test.startTest(); 
            insert lstOpp;     
               
            List<Warranty_Registration__c> lstwarranty = new List<Warranty_Registration__c>();
            wrc_test1 = new Warranty_Registration__c(Delivery_Date__c=edt,Partner_SFDC_ID__c=acct.Id,Customer_SFDC_ID__c=customer1.Id,status__c = 'Draft');    
            lstwarranty.add(wrc_test1);    
            wrc_test2 = new Warranty_Registration__c(Delivery_Date__c=edt,Partner_SFDC_ID__c=acct.Id,Customer_SFDC_ID__c=customer2.Id,status__c = 'Draft');    
            lstwarranty.add(wrc_test2);       
            insert lstwarranty;    
            //createData(wrc_test1);
            wrc = new WarrantyRegistrationController(); 
            ApexPages.currentPage().getParameters().put('warrantyNumber',wrc_test1.Id);
            ApexPages.currentPage().getParameters().put('warrantyID',wrc_test1.Id);
            ApexPages.currentPage().getParameters().put('customerNumber',wrc_test1.Customer_SFDC_ID__c);
            wrc.resumeRegistration(); //Resume registration successfully
            wrc.createCustomerRequest(); //Create customer request
            //Insert required fields in Customer        
            wrc.newCustomer.BillingCity='testCity';
            wrc.newCustomer.BillingCountry='Italy';
            wrc.newCustomer.BillingStreet='testStreet';
            wrc.newCustomer.BillingPostalCode='testZipCode';
            wrc.newCustomer.Name='cust_test';        
            wrc.newCustomer.Theater__c = 'Europe';
            wrc.newCustomer.CurrencyIsoCode='EUR';
            wrc.newCustomer.Country_Domain__c = 'rvar-it';
            wrc.newCustomer.Email__c = 'RA'+String.valueof(Math.Random())+'@testUniqEmail'+String.valueof(Math.Random())+'.com';
            Attachment att1 = createAttachment();
            //Add attachment to docList
            wrc.docList.add(att1);
            //Move to step 5 when warranty.delivery_date__c = null
            ApexPages.currentPage().getParameters().put('step','5');
            // wrc.warranty.delivery_date__c = null;  
            wrc.warranty.delivery_date__c = System.today() + 10;  
            createData(wrc_test1); 
            ApexPages.currentPage().getParameters().put('Id',wrc_test1.Id);
            
            WarrantyRegistration wr = new WarrantyRegistration();
                    wr.attachPDF(wrc_test1.Id, 'de');  
                    wr.attachPDF(wrc_test1.Id, 'fr_BE'); 
                    wr.attachPDF(wrc_test1.Id, 'fr'); 
                    wr.attachPDF(wrc_test1.Id, 'it'); 
                    wr.attachPDF(wrc_test1.Id, 'es'); 
                    wr.attachPDF(wrc_test1.Id, 'nl_BE'); 
                    wr.attachPDF(wrc_test1.Id, 'en_GB'); 
            
            PageReference pageRef = Page.WarrentyRegistrationCustom;
            pageRef.getParameters().put('ids', wrc_test1.Id); 
            Test.setCurrentPageReference(pageRef);
        
            ApexPages.StandardController Warr_cntrl = new ApexPages.StandardController(wrc_test1);
            WarrentyRegistrationCustom Warr = new WarrentyRegistrationCustom(Warr_cntrl);
            
            
            Warr.strWRId = wrc_test1.Id; 
            Warr.strAttId= [SELECT Id, Name, ContentType, BodyLength, Description FROM Attachment WHERE ParentId =: wrc_test1.Id limit 1].Id;
            
            Warr.OnInit();
            Warr.CheckSize();        
            Warr.ContinueWithSend();
            Warr.CancelandReturn();
            
            Warranty_Registration__c wrc_test3 = new Warranty_Registration__c();
            PageReference pageRef1 = Page.WarrentyRegistrationCustom;
            Test.setCurrentPageReference(pageRef1);
            
            ApexPages.StandardController Warr_cntrl1 = new ApexPages.StandardController(wrc_test3);
            WarrentyRegistrationCustom Warr1 = new WarrentyRegistrationCustom(Warr_cntrl1);
            Warr1.OnInit();
            
           Test.stopTest();
        
        }
    }
    */
    //MAM 16.MAM.2015 end
    
    private static Account getEUItalyPartnerAccount(){
        String recType ='';
        recType = String.valueOf( GW_RecTypes.GetRecordTypeId('Account','Partner'));         
        Account acct = new Account(name='test2'+String.valueOf(DateTime.now().getTime()),recordTypeID=recType);
        acct.ShippingCity = 'Jaipur';
        acct.ShippingStreet = 'Sitapura';
        acct.ShippingCountry = 'Italy';
        acct.ShippingState='Rajasthan';
        acct.ShippingPostalCode ='302020';
        acct.BillingCity = 'Jaipur';
        acct.BillingStreet = 'Sitapura';
        acct.BillingCountry = 'Italy';
        acct.BillingState='Rajasthan';
        acct.BillingPostalCode ='302020';
        acct.Online_Order_Access__c = true;
        acct.Oracle_Account_Number__c = 'test_oracle2';
        acct.Theater__c = 'Europe';
        acct.CurrencyIsoCode='EUR';
        acct.Country_Domain__c = 'combo-it';
        acct.Territory__c = 'Italy';
        acct.Type = 'Partner';
        //acct.OwnerId = WR_Opportunity_Assigned_Owner__c.getInstance('OpportunityOwner').Opportunity_Owner_ID__c; 
        insert acct;
        return acct;                     
    }  
    
    private static User getPartnerPortalUser(Account acct){
        User user = null;   
           
        if(acct == null){
            acct =  getEUItalyPartnerAccount();
        }
        Contact cont = new Contact(AccountID = acct.id,FirstName='testconbyPO2',LastName='testconbyPO2');
        cont.Email ='RA'+String.valueof(Math.Random())+'@testUniqEmail2'+String.valueof(Math.Random())+'.com';
        cont.Authorized_to_Order__c = true;
        cont.RecordTypeID = util.GetRecordTypeIdsByDeveloperName(Contact.SObjectType).get('Partner'); //MAM 19.MAY.2015 Get Contact Partner RecordTypeId
                        
        insert cont;        
       // User user = [Select id from user where id =: userInfo.getUserId()];  
        String username ='anjalitest@test1.com';      
        user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
        user.ContactId = cont.Id;
        user.Username = username;
        user.Alias = 'anjali';
        user.CommunityNickname = username.subString(0,7);
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US'; 
        user.Email = cont.Email;
        user.LocaleSidKey = 'en_US';    
        user.Edit_Partner_Users__c = true;
        List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Delegated Administrator'];
        if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            insert user;
        }
        if(user.Id != null)
          for(User u:[select id,Name,contactId,Contact.AccountID, Contact.Account.AccountNumber,Contact.Account.CurrencyIsoCode,Contact.Account.Name,Contact.Account.Country_Domain__c,Contact.Account.Theater__c,Contact.Account.ShippingStreet,Contact.Account.ShippingState,Contact.Account.ShippingCity,Contact.Account.ShippingCountry,Contact.Account.ShippingPostalCode,Contact.Account.Oracle_Operating_Unit__c, Contact.Account.Oracle_Account_Number__c from User where id =:user.ID LIMIT 1])
            user = u; 
        return user;
        
    }   
    
    //Create Opportunity between user and account
    private static Opportunity createOpp(Account acct,User u){
    
        Opportunity opp = new Opportunity();      
        opp.AccountId = acct.ID;
        opp.Name = 'testOpp';
        opp.StageName = 'won';
        opp.ownerId = u.Id;
        opp.Probability =10;
        opp.CloseDate = System.today();
        opp.Reason_Won_Lost__c = 'Best Economics';             
        return opp;
    }  
    
   
    //  Creating attachment for uploading
    
    private static Attachment createAttachment(){
        testAttachment = new Attachment();
        testAttachment.OwnerId = UserInfo.getUserId();
        testAttachment.IsPrivate = true;
        blob b = blob.valueOf('Test class for WarrantyRegistrationcontroller');
        testAttachment.Body = b;
        testAttachment.name = 'exAttachment'+i;
        testAttachment.ParentId = wrc.warranty.id;
        insert testAttachment;
        i++;
        return testAttachment;
        
    }    
    
    
    //This Method if for creating WR_Line_Item__c objects for Warranty.
    
    private static void createdata(Warranty_Registration__c wrc_test)
    {               
            createTestData();
            List<WR_Line_Item__c> lstWrLnItem = new List<WR_Line_Item__c>(); 
            WR_Line_Item__c wrLnItem1 = new WR_Line_Item__c(WR_FDS_Product__c = lstProduct.get(0).Id,Warranty_Registration__c = wrc_test.Id);
            WR_Line_Item__c wrLnItem2 = new WR_Line_Item__c(WR_FDS_Product__c = lstProduct.get(1).Id,Warranty_Registration__c = wrc_test.Id);  
            WR_Line_Item__c wrLnItem3 = new WR_Line_Item__c(WR_FDS_Product__c = lstProduct.get(2).Id,Warranty_Registration__c = wrc_test.Id);            
            WR_Line_Item__c wrLnItem4 = new WR_Line_Item__c(WR_FDS_Product__c = lstProduct.get(3).Id,Warranty_Registration__c = wrc_test.Id); 
            WR_Line_Item__c wrLnItem5 = new WR_Line_Item__c(WR_FDS_Product__c = lstProduct.get(4).Id,Warranty_Registration__c = wrc_test.Id);  
            WR_Line_Item__c wrLnItem6 = new WR_Line_Item__c(WR_FDS_Product__c = lstProduct.get(5).Id,Warranty_Registration__c = wrc_test.Id);            
            WR_Line_Item__c wrLnItem7 = new WR_Line_Item__c(WR_FDS_Product__c = lstProduct.get(6).Id,Warranty_Registration__c = wrc_test.Id); 
            WR_Line_Item__c wrLnItem8 = new WR_Line_Item__c(WR_FDS_Product__c = lstProduct.get(7).Id,Warranty_Registration__c = wrc_test.Id); 
            
            lstWrLnItem.add(wrLnItem1);
            lstWrLnItem.add(wrLnItem2);
            lstWrLnItem.add(wrLnItem3);
            lstWrLnItem.add(wrLnItem4); 
            lstWrLnItem.add(wrLnItem5);
            lstWrLnItem.add(wrLnItem6);
            lstWrLnItem.add(wrLnItem7);  
            lstWrLnItem.add(wrLnItem8);        
            insert lstWrLnItem;
            ApexPages.currentPage().getParameters().put('warrantyNumber',wrc_test.Id);
            ApexPages.currentPage().getParameters().put('customerNumber',wrc_test.Customer_SFDC_ID__c);
            ApexPages.currentPage().getParameters().put('warrantyID',wrc_test.Id);
        
    } 
    
    
    // This method is for creating test data-- creating salesOrder, SalesOrderLineItem
   
    private static void createTestData()
    {
        lstSalesOrder = new List<WR_ORACLE_SalesOrder__c>();
        lstProduct = new List<WR_FDS_Product__c>();
        lstProduct1 = new List<WR_FDS_Product__c>();
        Date edt = System.today();
        //Create test data for salesOrder
        WR_ORACLE_SalesOrder__c salesOrder1 = new WR_ORACLE_SalesOrder__c(Sales_Order__c='test_salesorder1',CurrencyIsoCode='USD',Oracle_Account_Number__c='test_oracle2',Packing_Slip__c='testPackingSlip1');
        lstSalesOrder.add(salesOrder1);
        WR_ORACLE_SalesOrder__c salesOrder2 = new WR_ORACLE_SalesOrder__c(Sales_Order__c='test_salesorder2',CurrencyIsoCode='USD',Oracle_Account_Number__c='test_oracle2',Packing_Slip__c='testPackingSlip2');
        lstSalesOrder.add(salesOrder2);
        WR_ORACLE_SalesOrder__c salesOrder3 = new WR_ORACLE_SalesOrder__c(Sales_Order__c='test_salesorder3',CurrencyIsoCode='USD',Oracle_Account_Number__c='test_oracle2',Packing_Slip__c='testPackingSlip3');
        lstSalesOrder.add(salesOrder3);
        insert lstSalesOrder;
        
        //Create test data for salesOrderLineItem
        WR_FDS_Product__c salesOrderLnItem1 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip1',WR_ORACLE_SalesOrder__c = salesOrder1.Id,Product_Type__c = 'Module', Product_Name__c = 'SPRtstPdct1', Converted_To_Asset__c = true, Serial_Number__c = 'testSN1');
        lstProduct.add(salesOrderLnItem1);
        WR_FDS_Product__c salesOrderLnItem2 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip1',WR_ORACLE_SalesOrder__c = salesOrder1.Id,Product_Type__c = 'Module', Product_Name__c = 'SPRtstPdct2', Converted_To_Asset__c = true, Serial_Number__c = 'testSN2');
        lstProduct.add(salesOrderLnItem2);
        WR_FDS_Product__c salesOrderLnItem3 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip2',WR_ORACLE_SalesOrder__c = salesOrder2.Id,Product_Name__c = 'tstPdct3', Converted_To_Asset__c = false, Serial_Number__c = 'testSN3');
        lstProduct.add(salesOrderLnItem3);
        WR_FDS_Product__c salesOrderLnItem4 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip2',WR_ORACLE_SalesOrder__c = salesOrder2.Id,Product_Name__c = 'tstPdct4', Converted_To_Asset__c = false, Serial_Number__c = 'testSN4');
        lstProduct.add(salesOrderLnItem4);
        WR_FDS_Product__c salesOrderLnItem5 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip3',WR_ORACLE_SalesOrder__c = salesOrder3.Id,Product_Name__c = 'tstPdct5', Serial_Number__c = 'testSN5');
        lstProduct.add(salesOrderLnItem5);
        WR_FDS_Product__c salesOrderLnItem6 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip3',WR_ORACLE_SalesOrder__c = salesOrder1.Id,Product_Type__c = 'Module', Product_Name__c = 'SPRtstPdct6', Converted_To_Asset__c = false, Serial_Number__c = 'testSN6');
        lstProduct.add(salesOrderLnItem6);
        WR_FDS_Product__c salesOrderLnItem7 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip2',WR_ORACLE_SalesOrder__c = salesOrder2.Id,Product_Type__c = 'Module', Product_Name__c = 'SPRtstPdct7', Converted_To_Asset__c = false, Serial_Number__c = 'testSN7');
        lstProduct.add(salesOrderLnItem7);
        WR_FDS_Product__c salesOrderLnItem8 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip3',WR_ORACLE_SalesOrder__c = salesOrder3.Id,Product_Type__c = 'Module', Product_Name__c = 'SPRtstPdct8', Serial_Number__c = 'testSN8');
        lstProduct.add(salesOrderLnItem8);
        insert lstProduct; 
        lstProduct1.add(salesOrderLnItem3);
        lstProduct1.add(salesOrderLnItem4);
        lstProduct1.add(salesOrderLnItem5);       
    }
    
    
}