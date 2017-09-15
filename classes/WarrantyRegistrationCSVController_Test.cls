/*
  Test functionality of WarrantyRegistrationCSVController
  
  @Author Anjali Khandelwal (Appirio offhsore)
*/

@isTest
private class WarrantyRegistrationCSVController_Test
{
    static Warranty_Registration__c wrc_test1;
    static WarrantyRegistrationCSVController wrcc;
    public static testMethod void testWarrantyRegistrationCSVController()
    {
        Account acct = getPartnerAccount();
        User test_user =getPartnerPortalUser(acct);               
        System.runAs(test_user){ 
        
        //Start new context       
        Test.startTest();
        acct = test_user.Contact.Account;
        Opportunity test_opp1 = createOpp(acct,test_user);
        insert test_opp1;
        Date edt = System.today();
        Account customer1 = new Account(Name='DummyCustomerAcc1',CurrencyIsoCode='USD',Theater__c='North America',BillingCity='testCity',BillingCountry='testCountry',BillingStreet='testStreet',BillingPostalCode='testZipCode');
        insert customer1;
        wrc_test1 = new Warranty_Registration__c(Delivery_Date__c=edt,Partner_SFDC_ID__c=acct.Id,Customer_SFDC_ID__c=customer1.Id,status__c = 'Draft');
        insert wrc_test1 ;
        
        createTestData();
        //ErrorMsg will be generated as no warrantyId is set
        try{
            wrcc = new WarrantyRegistrationCSVController();
        }
        catch(Exception ex)
        {
            System.assertEquals(ex.getMessage(),'List has no rows for assignment to SObject');
        }
        //No warranty object is get as warrantyId is not set
        System.assertEquals(wrcc.warranty, null);//Assert warranty
        //WarrantyId is set
        ApexPages.currentPage().getParameters().put('warrantyId' , wrc_test1.Id);
        wrcc = new WarrantyRegistrationCSVController();       
        System.assertEquals(wrcc.warranty.Id , wrc_test1.Id);//Assert warranty
        Test.stopTest();
        }
    }
    
     //Create Partner Portal user
     private static User getPartnerPortalUser(Account acct){
        User user = null;
       
        if(acct == null){
            acct =  getPartnerAccount();
        }
        Contact cont = new Contact(AccountID = acct.id,FirstName='testconbyPO2',LastName='testconbyPO2');
        cont.Email ='te@test.com';
        cont.Authorized_to_Order__c = true;
        cont.RecordTypeID = util.GetRecordTypeIdsByDeveloperName(Contact.SObjectType).get('Partner'); //MAM 19.MAY.2015 Get Contact Partner RecordTypeId        
        insert cont;        
        
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
     private static Account getPartnerAccount(){
        String recType ='';
        for(RecordType r:[select id,Name from RecordType where sObjectType ='Account' and name ='Partner' LIMIT 1])
             recType = r.ID;             
        Account acct = new Account(name='test1'+String.valueOf(DateTime.now().getTime()),recordTypeID=recType);
        acct.ShippingCity = 'Jaipur';
        acct.ShippingStreet = 'Durgapura';
        acct.ShippingCountry = 'India';
        acct.ShippingState='Rajasthan';
        acct.ShippingPostalCode ='302018';
        acct.BillingCity = 'Jaipur';
        acct.BillingStreet = 'Durgapura';
        acct.BillingCountry = 'India';
        acct.BillingState='Rajasthan';
        acct.BillingPostalCode ='302018';
        acct.Online_Order_Access__c = true;
        acct.Oracle_Account_Number__c = 'test_oracle';
        acct.Theater__c = 'North America';
        acct.CurrencyIsoCode='USD';
        acct.Country_Domain__c = 'rvar-us';
        insert acct;
        return acct;                     
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
    private static void createTestData()
    {
        List<WR_ORACLE_SalesOrder__c> lstSalesOrder = new List<WR_ORACLE_SalesOrder__c>();
        List<WR_FDS_Product__c> lstProduct = new List<WR_FDS_Product__c>();
        Date edt = System.today();
        //Test data for salesorder
        WR_ORACLE_SalesOrder__c salesOrder1 = new WR_ORACLE_SalesOrder__c(Sales_Order__c='test_salesorder1',CurrencyIsoCode='USD',Oracle_Account_Number__c='test_oracle',Packing_Slip__c='testPackingSlip1');
        lstSalesOrder.add(salesOrder1);
        WR_ORACLE_SalesOrder__c salesOrder2 = new WR_ORACLE_SalesOrder__c(Sales_Order__c='test_salesorder2',CurrencyIsoCode='USD',Oracle_Account_Number__c='test_oracle',Packing_Slip__c='testPackingSlip2');
        lstSalesOrder.add(salesOrder2);
        insert lstSalesOrder;
        //Test data for products
        WR_FDS_Product__c salesOrderLnItem1 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip1',WR_ORACLE_SalesOrder__c = salesOrder1.Id,Product_Name__c = 'testproduct1',Product_Type__c = 'testproducttype1',Serial_Number__c = '_testSrNo1');
        lstProduct.add(salesOrderLnItem1);
        WR_FDS_Product__c salesOrderLnItem2 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip1',WR_ORACLE_SalesOrder__c = salesOrder1.Id,Product_Name__c = 'testproduct2',Product_Type__c = 'testproducttype1',Serial_Number__c = '_testSrNo2');
        lstProduct.add(salesOrderLnItem2);
        WR_FDS_Product__c salesOrderLnItem3 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip2',WR_ORACLE_SalesOrder__c = salesOrder2.Id,Product_Name__c = 'testproduct3',Product_Type__c = 'testproducttype2',Serial_Number__c = '_testSrNo3');
        lstProduct.add(salesOrderLnItem3);
        WR_FDS_Product__c salesOrderLnItem4 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip2',WR_ORACLE_SalesOrder__c = salesOrder2.Id,Product_Name__c = 'testproduct4',Product_Type__c = 'testproducttype2',Serial_Number__c = '_testSrNo4');
        lstProduct.add(salesOrderLnItem4);
        insert lstProduct; 
        
        //Test data is for WR_Line_Item__c
           
        List<WR_Line_Item__c> lstWrLnItem = new List<WR_Line_Item__c>(); 
        WR_Line_Item__c wrLnItem1 = new WR_Line_Item__c(WR_FDS_Product__c = salesOrderLnItem1.Id,Warranty_Registration__c = wrc_test1.Id);
        WR_Line_Item__c wrLnItem2 = new WR_Line_Item__c(WR_FDS_Product__c = salesOrderLnItem2.Id,Warranty_Registration__c = wrc_test1.Id);  
        WR_Line_Item__c wrLnItem3 = new WR_Line_Item__c(WR_FDS_Product__c = salesOrderLnItem3.Id,Warranty_Registration__c = wrc_test1.Id);            
        WR_Line_Item__c wrLnItem4 = new WR_Line_Item__c(WR_FDS_Product__c = salesOrderLnItem4.Id,Warranty_Registration__c = wrc_test1.Id);                
        lstWrLnItem.add(wrLnItem1);
        lstWrLnItem.add(wrLnItem2);
        lstWrLnItem.add(wrLnItem3);
        lstWrLnItem.add(wrLnItem4);
        insert lstWrLnItem;      
    }    
}