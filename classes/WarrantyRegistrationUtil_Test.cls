/*
  Test functionality of WarrantyRegistrationUtil class 
  @Author Anjali Khandelwal (Appirio Offshore)
*/
@isTest
private class WarrantyRegistrationUtil_Test
{
    static Date dt = System.today();
    static WarrantyRegistrationUtil wru;
    static Warranty_Registration__c wrc_test1;
    static Warranty_Registration__c wrc_test2;
    static boolean f;
    static WR_SalesOrderFilter sof;
    static Date edt;
    static Account acct;
    static Account customer1;
    static Account customer2;
    static WR_customerFilter custFilter;   
    static List<WR_SalesOrderLineItemWrapper> lstSalesOrderLineItem;
    static List<WR_SalesOrderLineItemWrapper> lstSalesOrderLineItem1;
    static List<Warranty_Registration__c> lstwarranty;
    static List<WR_ORACLE_SalesOrder__c> lstSalesOrder;
    public static final String ONLINE_WR_CAMPAIGN = 'On Line Warranty';
    /*
        Test Method for DateFormat()
    */
    public static testMethod void testDateFormat()
    {        
        String actualDt = WarrantyRegistrationUtil.dateFormat(dt);
        Integer yr = System.today().year();
        String mnth = WarrantyRegistrationUtil.dateStringFormat(System.today().month());
        String d = WarrantyRegistrationUtil.dateStringFormat(System.today().day());        
        String expectedDt = yr+'-'+mnth+'-'+d;
        System.assertEquals(actualDt,expectedDt);
    }
    
    /*
        Test Method for DateStringFormat()
    */
    public static testMethod void testDateStringFormat()
    {
        Integer i = 15;
        String actualDt = WarrantyRegistrationUtil.dateStringFormat(i);
        String exceptedVal = '15';
        System.assertEquals(exceptedVal,actualDt); //Assert for more than 1 digit number
        i = 8;
        actualDt = WarrantyRegistrationUtil.dateStringFormat(i);
        exceptedVal = '08';
        System.assertEquals(exceptedVal,actualDt); //Assert for more than 1 digit number
    }
    
    /*
        test Method for CreateWarrantySetController()
    */
    public static testMethod void testCreateWarrantySetController()
    {
        acct = getPartnerAccount();
        //Start new context 
        Test.startTest();
        
        createTestData(); //Call to createTestData() for creating test data for test method 
        WR_WarrantySearchFilter wsf = new WR_WarrantySearchFilter();
        wsf.startDate = System.today();
        wsf.endDate = System.today();
        wsf.customerName = 'DummyCustomerAcc1';
        wsf.Status = 'Draft';
        WarrantyRegistrationUtil.createWarrantiesSetController(wsf,acct.Id); 
        wsf.isAscending = false;        
        //test createWarrantiesSetController() with isAscending = false
        WarrantyRegistrationUtil.createWarrantiesSetController(wsf,acct.Id);
        wsf.warrantyNumber = wrc_test1.Id;
        //test createWarrantiesSetController() with warrantyNumber
        WarrantyRegistrationUtil.createWarrantiesSetController(wsf,acct.Id);
        wsf.sortField = 'Name'; 
        //test createWarrantiesSetController() with sortField
        WarrantyRegistrationUtil.createWarrantiesSetController(wsf,acct.Id); 
        
        Test.StopTest();
   } 
   
   //test findCustomershavingWarranty()
   //public static testMethod void testfindCustomershavingWarranty(){
      //  WarrantyRegistrationUtil.findCustomershavingWarranty();
   //}
   
   //test Method for findRegistrationInProcessProducts()
   public static testMethod void testfindRegistrationInProcessProducts(){
        acct = getPartnerAccount();
        User test_user =getPartnerPortalUser(acct);        
        String searchtxt = '';
        edt = System.today();
        System.runAs(test_user){
        f = false;
        //Start new context 
       
        acct = test_user.Contact.Account;
        Opportunity test_opp1 = createOpp(acct,test_user);
        insert test_opp1;       
        Test.startTest(); 
        createTestData(); //Call to createTestData()
        Test.stopTest();
        //Call to findRegistrationInProcessProducts()
        WarrantyRegistrationUtil.findRegistrationInProcessProducts(acct.Id);
        
        }
   }
   
   //Test method for FindSalesOrders()
   public static testMethod void testFindSalesOrders(){
        acct = getPartnerAccount();
        User test_user =getPartnerPortalUser(acct);                
        edt = System.today();
        System.runAs(test_user){
        f = false;
        
        acct = test_user.Contact.Account;
        Opportunity test_opp1 = createOpp(acct,test_user);
        insert test_opp1;
        //Start new context 
        Test.startTest();
        createTestData(); //Create test data
        
        createTestDataforSalesOrder();
        sof.partnerAccountNumber = acct.Oracle_Account_Number__c; 
        //test findSalesOrders() for different different numberType.
        WarrantyRegistrationUtil.findSalesOrders(sof);
        sof.numberType = 'Serial Number';
        WarrantyRegistrationUtil.findSalesOrders(sof);
        sof.numberType = 'Packing List';
        sof.numberValue = sof.numberValue+',ALT-PL#';
        WarrantyRegistrationUtil.findSalesOrders(sof);
        sof.numberType = 'Purchase order';
        WarrantyRegistrationUtil.findSalesOrders(sof);
        sof.sortField = 'Purchase_Order__c';
        WarrantyRegistrationUtil.findSalesOrders(sof); //call findSalesOrders() with sortField value
        Test.stopTest();
        }
    }
   
    //call to CollectSavedWRLineItems()
   /* public static testMethod void testCollectSavedWRLineItems()
    {         
        acct = getPartnerAccount();
        User test_user =getPartnerPortalUser(acct);                
        edt = System.today();
        System.runAs(test_user){
        f = false;
        //Start new context 
        Test.startTest();
        acct = test_user.Contact.Account;
        Opportunity test_opp1 = createOpp(acct,test_user);
        insert test_opp1;        
        createTestData(); //Create Test data
        //call to collectSavedWRLineItems()
        WarrantyRegistrationUtil.collectSavedWRLineItems(lstSalesOrderLineItem);
        Test.stopTest();
        }
    }*/
    
    //Test Method for ConvertIntoWRLineItems()
   public static testMethod void testConvertIntoWRLineItems()
    {
        acct = getPartnerAccount();
        User test_user =getPartnerPortalUser(acct);                
        edt = System.today();
        System.runAs(test_user){
        f = false;
        acct = test_user.Contact.Account;
        Opportunity test_opp1 = createOpp(acct,test_user);
        insert test_opp1;        
        //Start new context 
        Test.startTest();
        createTestData(); //Call to CreateTestData()
        Test.stopTest();
        //Call to convertIntoWRLineItems()
        WarrantyRegistrationUtil.updateWarrantyLineItem(wrc_test1.Id);
        
        }
    }
    
    //Test Method for FindRegisteredProducts() 
    public static testMethod void testFindRegisteredProducts()
    {
        acct = getPartnerAccount();
        User test_user =getPartnerPortalUser(acct);                
        edt = System.today();
        System.runAs(test_user){
        f = false;
        acct = test_user.Contact.Account;
        Opportunity test_opp1 = createOpp(acct,test_user);
        insert test_opp1;       
         //Start new context 
        Test.startTest(); 
        createTestData(); //Call to createTestData()
        Test.stopTest();
        //Call to findRegisteredProducts()
        WarrantyRegistrationUtil.findRegisteredProducts(acct.Id);
        
        }
    }
    
    //Test Method for SortProducts()
   /* public static testMethod void testSortProducts()
    {
        acct = getPartnerAccount();
        User test_user =getPartnerPortalUser(acct);               
        edt = System.today();
        System.runAs(test_user){
        f = false;
        //Start new context 
        
        acct = test_user.Contact.Account;
        Opportunity test_opp1 = createOpp(acct,test_user);
        insert test_opp1;    
        Test.startTest();    
        createTestData(); //Call to createTestData()
        //Call to sortProducts() with Product List size less than 2
        //WarrantyRegistrationUtil.sortProducts(lstSalesOrderLineItem1);
        //Call to sortProducts() with Product List size greater than 2
        //WarrantyRegistrationUtil.sortProducts(lstSalesOrderLineItem);
        Test.stopTest();
        }
    }*/
    
    //Test Method for CreateSharingAccountRule()
    public static testMethod void testCreateSharingAccountRule()
    {
        acct = getPartnerAccount();
        User test_user =getPartnerPortalUser(acct);               
        edt = System.today();
        System.runAs(test_user){
        f = false;
        
        acct = test_user.Contact.Account;
        Opportunity test_opp1 = createOpp(acct,test_user);
        insert test_opp1;  
        //Start new context 
        Test.startTest();      
        createTestData(); //Call to createTestData()
        
        //Call to createAccountSharingRule()
        String partnerName = 'salesforce.com';Test.stopTest();
        WarrantyRegistrationUtil.createAccountSharingRule(partnerName,customer1.Id);
        Campaign cmpgn;
        for(Campaign c: [Select id,ownerId from Campaign where name =: ONLINE_WR_CAMPAIGN]){
            cmpgn = c;
        }  
        if(cmpgn != null){
            WarrantyRegistrationUtil.createCampaignSharingRule(partnerName,cmpgn.Id);
            
            List<CampaignShare> CampaignShareList = [Select id from CampaignShare where CampaignId =: cmpgn.Id];
            System.assert(CampaignShareList.size()!=0);
        }
      }
    } 
     
    //Test Method for CreateAccountSetController() 
    public static testMethod void testCreateAccountSetController()
    {
        acct = getPartnerAccount();        
        User test_user =getPartnerPortalUser(acct);            
        String searchtxt = '';
        edt = System.today();
        System.runAs(test_user){
        f = false;
        
        acct = test_user.Contact.Account;
        Opportunity test_opp1 = createOpp(acct,test_user);
        insert test_opp1;  
        //Start new context 
        Test.startTest();      
        createTestData(); //Call to createTestData() for creating test data for test method
        Test.stopTest();
        //test createAccountSetController()
        WarrantyRegistrationUtil.createAccountSetController(custFilter,0); //MAM 23.MAY.2015 added count parameter            
        custFilter.sortField = 'Name';
        //test createAccountSetController() with sortField value
        WarrantyRegistrationUtil.createAccountSetController(custFilter,0); //MAM 23.MAY.2015 added count parameter         
        custFilter.isAscending = false;  
        //test createAccountSetController() with isAscending value 
        WarrantyRegistrationUtil.createAccountSetController(custFilter,0); //MAM 23.MAY.2015 added count parameter
        custFilter.countryDomain = 'combo-de'; 
        //test createAccountSetController() with countryDomain doesn't ends with US 
        WarrantyRegistrationUtil.createAccountSetController(custFilter,0); //MAM 23.MAY.2015 added count parameter
        
        }
        
    }
    
    //Test Method for sendWarrantyRegistrationNitification() 
    public static testMethod void testSendWarrantyRegistrationNotification()
    {
        acct = getPartnerAccount();        
        User test_user =getPartnerPortalUser(acct);            
        String searchtxt = '';
        edt = System.today();
        System.runAs(test_user){
        f = false;
        
        acct = test_user.Contact.Account;
        Opportunity test_opp1 = createOpp(acct,test_user);
        insert test_opp1;  
        //Start new context 
        Test.startTest();      
        createTestData(); //Call to createTestData() for creating test data for test method
        
        //test createAccountSetController()
        //MAM 20.MAY.2015 uncomment sendWarrantyRegistrationNitification calls
        WarrantyRegistrationUtil.sendWarrantyRegistrationNitification(lstwarranty[0].Id,'italy',test_user.ContactId);
        WarrantyRegistrationUtil.sendWarrantyRegistrationNitification(lstwarranty[0].Id,'ses',test_user.ContactId);
        WarrantyRegistrationUtil.sendWarrantyRegistrationNitification(lstwarranty[0].Id,'it',test_user.ContactId);
        WarrantyRegistrationUtil.sendWarrantyRegistrationNitification(lstwarranty[0].Id,'de',test_user.ContactId);   
        WarrantyRegistrationUtil.sendWarrantyRegistrationNitification(lstwarranty[0].Id,'fr',test_user.ContactId);
        WarrantyRegistrationUtil.sendWarrantyRegistrationNitification(lstwarranty[0].Id,'be',test_user.ContactId);
        //MAM 20.MAY.2015 end  
        List<WR_SalesOrderWrapper> salesOrderWrapperList = WarrantyRegistrationUtil.convertSalesOrderTOSalesOrderWrapper(lstSalesOrder);
        System.assertEquals(salesOrderWrapperList.size(),2);
        Test.stopTest();
        }
        
    }
    
    //Test Method for FindProducts() 
    public static testMethod void testFindProducts()
    {
        acct = getPartnerAccount();        
        User test_user =getPartnerPortalUser(acct);            
        String searchtxt = '';
        edt = System.today();
        System.runAs(test_user){
        f = false;
        
        acct = test_user.Contact.Account;
        Opportunity test_opp1 = createOpp(acct,test_user);
        insert test_opp1;  
        //Start new context 
        Test.startTest();      
        createTestData(); //Call to createTestData() for creating test data for test method
        WR_SalesOrderFilter salesOrderfilter = new WR_SalesOrderFilter ();
        salesOrderfilter.numberType = 'Serial Number';
        salesOrderfilter.numberValue = '333';
        
        Set<Id> salesOrderIds = new Set<Id>();
        
        for(WR_ORACLE_SalesOrder__c so : lstSalesOrder){
            salesOrderIds.add(so.Id);
        }
        
        List<WR_FDS_Product__c> lstProduct = new List<WR_FDS_Product__c>();
        WR_FDS_Product__c salesOrderLnItem1 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip2',Alternate_Packing_Slip__c = 'ALT-PL#',Serial_Number__c = 'SN-Test-445');
        lstProduct.add(salesOrderLnItem1);
        WR_FDS_Product__c salesOrderLnItem2 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip2',Alternate_Packing_Slip__c = 'ALT-PL#',Serial_Number__c = 'SN-Test-446');
        lstProduct.add(salesOrderLnItem2);
        insert lstProduct;
        
        Set<String> serialNums = new Set<String>();
        for(WR_FDS_Product__c fdspr : lstProduct){
                serialNums.add(fdspr.Serial_Number__c);
        }
        
        //test createAccountSetController()
        List<WR_FDS_Product__c> fdsProductList = WarrantyRegistrationUtil.findProducts(salesOrderIds,salesOrderfilter, serialNums);
        //List<WR_SalesOrderWrapper> salesOrderWrapperList = WarrantyRegistrationUtil.convertSalesOrderTOSalesOrderWrapper(lstSalesOrder);
        System.assertEquals(fdsProductList.size(),1);
        
        List<WR_StagingSelection__c> stagingList = WarrantyRegistrationUtil.findAllSelectedInstallationdata(wrc_test1.Id,true);
        System.assertEquals(stagingList.size(),1);
        stagingList = WarrantyRegistrationUtil.findAllInstallationdata(wrc_test1.Id, true);
        System.assertEquals(stagingList.size(),1);
        ApexPages.Standardsetcontroller stdSetController = WarrantyRegistrationUtil.createInstallationStagingsetController(wrc_test1.Id,true,20, 'isNew__c', 'ASC');
        stagingList = (List<WR_StagingSelection__c>)stdSetController.getRecords();
        System.assertEquals(stagingList.size(),1);
        stagingList = new List<WR_StagingSelection__c>();
        for(WR_StagingSelection__c wr : [Select id, Timestamp__c from WR_StagingSelection__c where warranty_registration__c =: wrc_test1.Id]){
            stagingList.add(wr);
        }
        System.assertEquals(stagingList.size(),1);
        WarrantyRegistrationUtil.cleanWarrantyStagingData(wrc_test1.Id,System.now());
        WarrantyRegistrationUtil.cleanWarrantyStagingData(wrc_test1.Id, true,System.now());
        //stagingList = new List<WR_StagingSelection__c>();
        //for(WR_StagingSelection__c wr : [Select id from WR_StagingSelection__c where warranty_registration__c =: wrc_test1.Id]){
            //stagingList.add(wr);
        //}
        //System.assertEquals(stagingList.size(),0);
        Test.stopTest();
        }
        
    }
    
    //Test Method for findSelectedProducts()
   /* public static testMethod void testFindSelectedProducts()
    {
        acct = getPartnerAccount();        
        User test_user =getPartnerPortalUser(acct);            
        String csvStr= '111'+'\n222\n333\n444';
        edt = System.today();
        System.runAs(test_user){
        f = false;
        //Start new context 
        Test.startTest(); 
        acct = test_user.Contact.Account;
        Opportunity test_opp1 = createOpp(acct,test_user);
        insert test_opp1;        
        createTestData(); //Call to createTestData() for creating test data for test method
      
        //test createAccountSetController()
        lstSalesOrderLineItem = WarrantyRegistrationUtil.findSelectedProducts(csvStr,'test_oracle');           
        system.assertEquals(lstSalesOrderLineItem.size(),4);
        Test.stopTest();
        }
        
    }
    */
    //Create Partner Portal user
     private static User getPartnerPortalUser(Account acct1){
        User user = null;      
        if(acct1 == null){
            acct1 =  getPartnerAccount();
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
     
     //Create Partner Account 
     private static Account getPartnerAccount(){
        String recType ='';
        for(RecordType r:[select id,Name from RecordType where sObjectType ='Account' and name ='Partner' LIMIT 1])
             recType = r.ID;             
        Account acct1 = new Account(name='test1'+String.valueOf(DateTime.now().getTime()),recordTypeID=recType);
        acct1.ShippingCity = 'Jaipur';
        acct1.ShippingStreet = 'Durgapura';
        acct1.ShippingCountry = 'India';
        acct1.ShippingState='Rajasthan';
        acct1.ShippingPostalCode ='302018';
        acct1.BillingCity = 'Jaipur';
        acct1.BillingStreet = 'Durgapura';
        acct1.BillingCountry = 'India';
        acct1.BillingState='Rajasthan';
        acct1.BillingPostalCode ='302018';
        acct1.Online_Order_Access__c = true;
        acct1.Oracle_Account_Number__c = 'test_oracle';
        acct1.Theater__c = 'North America';
        acct1.CurrencyIsoCode='USD';
        acct1.Country_Domain__c = 'rvar-us';
        insert acct1;
        return acct1;                     
    }    
    
    
    //Create Opportunity between user and account
    private static Opportunity createOpp(Account acct1,User u){    
        Opportunity opp = new Opportunity();      
        opp.AccountId = acct1.ID;
        opp.Name = 'testOpp';
        opp.StageName = 'won';
        opp.ownerId = u.Id;
        opp.Probability =10;
        opp.CloseDate = System.today();
        opp.Reason_Won_Lost__c = 'Best Economics';             
        return opp;
    }
    
    /*
        Create test data. Create salesOrder, salesOrderLineItem.
    */
    private static void createTestData()
    {
        List<Account> lstCust = new List<Account>();
        // DummyCustomerAcc1
        customer1 = new Account(Name='DCAcc1',CurrencyIsoCode='USD',Theater__c='North America',BillingCity='testCity',BillingCountry='testCountry',BillingStreet='testStreet',BillingPostalCode='testZipCode',Email__c = 'test@test.com',BillingState='testState'); 
        lstCust.add(customer1);
        // DummyCustomerAcc2
        customer2 = new Account(Name='DCAcc2',CurrencyIsoCode='EUR',Theater__c='Europe',BillingCity='testCity1',BillingCountry='testCountry1',BillingStreet='testStreet1',BillingPostalCode='testZipCode1',Email__c = 'test1@test.com',BillingState='testState');
        lstCust.add(customer2);
        insert lstCust;        
        List<Opportunity> lstOpp = new List<Opportunity>();
        Opportunity testCustOpp = new Opportunity(AccountId = customer1.id,Name=customer1.Name,StageName='Qualified Opportunity',CloseDate=Date.today().addDays(1));
        Opportunity testCustOpp1 = new Opportunity(AccountId = customer2.id,Name=customer2.Name,StageName='Qualified Opportunity',CloseDate=Date.today().addDays(1));
        lstOpp.add(testCustOpp);
        lstOpp.add(testCustOpp1);
        insert lstOpp;
        //Create Warranties
        lstwarranty = new List<Warranty_Registration__c>();
        wrc_test1 = new Warranty_Registration__c(Delivery_Date__c=edt,Partner_SFDC_ID__c=acct.Id,Customer_SFDC_ID__c=customer1.Id,status__c = 'Draft');    
        lstwarranty.add(wrc_test1);    
        wrc_test2 = new Warranty_Registration__c(Delivery_Date__c=edt,Partner_SFDC_ID__c=acct.Id,Customer_SFDC_ID__c=customer2.Id,status__c = 'Draft');    
        lstwarranty.add(wrc_test2); 
        insert lstwarranty;         
        lstSalesOrder = new List<WR_ORACLE_SalesOrder__c>();
        List<WR_FDS_Product__c> lstProduct = new List<WR_FDS_Product__c>();
        edt = System.today();
        //Create SaleOrder
        WR_ORACLE_SalesOrder__c salesOrder1 = new WR_ORACLE_SalesOrder__c(Sales_Order__c='test_salesorder1',CurrencyIsoCode='USD',Oracle_Account_Number__c='test_oracle',Packing_Slip__c='testPackingSlip1',So_Created__c = System.today());
        lstSalesOrder.add(salesOrder1);
        WR_ORACLE_SalesOrder__c salesOrder2 = new WR_ORACLE_SalesOrder__c(Sales_Order__c='test_salesorder2',CurrencyIsoCode='USD',Oracle_Account_Number__c='test_oracle',Packing_Slip__c='testPackingSlip2',So_Created__c = System.today());
        lstSalesOrder.add(salesOrder2);
        insert lstSalesOrder;
        //Create instances of WR_FDS_Product__c
        WR_FDS_Product__c salesOrderLnItem1 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip1',WR_ORACLE_SalesOrder__c = salesOrder1.Id, Converted_to_asset__c = false,Product_Type__c='MODULE',Serial_Number__c = 'SN-Test-111');
        lstProduct.add(salesOrderLnItem1);
        WR_FDS_Product__c salesOrderLnItem2 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip1',WR_ORACLE_SalesOrder__c = salesOrder1.Id, Converted_To_Asset__c = true,Serial_Number__c = 'SN-Test-222');
        lstProduct.add(salesOrderLnItem2);
        WR_FDS_Product__c salesOrderLnItem3 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip2',WR_ORACLE_SalesOrder__c = salesOrder2.Id,Serial_Number__c = 'SN-Test-333');
        lstProduct.add(salesOrderLnItem3);
        WR_FDS_Product__c salesOrderLnItem4 = new WR_FDS_Product__c(CurrencyIsoCode='USD',Packing_Slip__c='testPackingSlip2',WR_ORACLE_SalesOrder__c = salesOrder2.Id,Alternate_Packing_Slip__c = 'ALT-PL#',Serial_Number__c = 'SN-Test-444');
        lstProduct.add(salesOrderLnItem4);
        insert lstProduct;   
        //Create instances of WR_Line_Item__c  
        List<WR_Line_Item__c> lstWrLnItem = new List<WR_Line_Item__c>(); 
        WR_Line_Item__c wrLnItem1 = new WR_Line_Item__c(WR_FDS_Product__c = salesOrderLnItem1.Id,Warranty_Registration__c = wrc_test1.Id);
        WR_Line_Item__c wrLnItem2 = new WR_Line_Item__c(WR_FDS_Product__c = salesOrderLnItem2.Id,Warranty_Registration__c = wrc_test1.Id);  
        WR_Line_Item__c wrLnItem3 = new WR_Line_Item__c(WR_FDS_Product__c = salesOrderLnItem3.Id,Warranty_Registration__c = wrc_test1.Id);            
        WR_Line_Item__c wrLnItem4 = new WR_Line_Item__c(WR_FDS_Product__c = salesOrderLnItem4.Id,Warranty_Registration__c = wrc_test1.Id); 
        WR_Line_Item__c wrLnItem5 = new WR_Line_Item__c(WR_FDS_Product__c = salesOrderLnItem1.Id,Warranty_Registration__c = wrc_test2.Id);
        WR_Line_Item__c wrLnItem6 = new WR_Line_Item__c(WR_FDS_Product__c = salesOrderLnItem2.Id,Warranty_Registration__c = wrc_test2.Id);    
        lstWrLnItem.add(wrLnItem1);
        lstWrLnItem.add(wrLnItem2);
        lstWrLnItem.add(wrLnItem3);
        lstWrLnItem.add(wrLnItem4);   
        lstWrLnItem.add(wrLnItem5);
        lstWrLnItem.add(wrLnItem6);         
        insert lstWrLnItem;    
        
        WR_StagingSelection__c stagingData = new WR_StagingSelection__c();
        stagingData.Warranty_Registration__c = lstwarranty[0].Id;
        stagingData.WR_Line_Item__c = lstWrLnItem[0].Id;
        stagingData.WR_FDS_Product__c =lstProduct[0].Id;
        stagingData.ISselected__c = true;
        stagingData.IsInSelectedList__c = true;
        stagingData.Timestamp__c = System.now();
        insert stagingData;
        
        custFilter = new WR_customerFilter();
        custFilter.countryDomain = 'rvar-us';
        custFilter.searchText = 'DummyCustomerAcc1';
        custFilter.dealerID = acct.Id;
        
        custFilter.commercialRecordTypeID = [Select ID From RecordType where Name = 'Commercial Customer' Limit 1].id;
        custFilter.homeOwnerRecordTypeID = [Select ID From RecordType where Name = 'Residential Customer' Limit 1].id;
        WR_FDS_Product__c wfp = new WR_FDS_Product__c(Product_Type__c = 'MODULE');
        WR_SalesOrderLineItemWrapper wSOLIW = new WR_SalesOrderLineItemWrapper(wfp);
        wSOLIW.warrantyId = wrc_test1.Id;
        
        wSOLIW.WR_Line_item_ID = wrLnItem1.Id;
        WR_FDS_Product__c wfp1 = new WR_FDS_Product__c();
        WR_SalesOrderLineItemWrapper wSOLIW1 = new WR_SalesOrderLineItemWrapper(wfp1);
        wSOLIW1.warrantyId = wrc_test1.Id;
        
        wSOLIW1.WR_Line_item_ID = wrLnItem2.Id;
        WR_SalesOrderLineItemWrapper wSOLIW2 = new WR_SalesOrderLineItemWrapper(wfp1);
        wSOLIW2.warrantyId = null;
        wSOLIW2.WR_Line_item_ID = wrLnItem3.Id;
        lstSalesOrderLineItem = new List<WR_SalesOrderLineItemWrapper>();
        lstSalesOrderLineItem1 = new List<WR_SalesOrderLineItemWrapper>();
        lstSalesOrderLineItem1.add(wSOLIW);
        lstSalesOrderLineItem.add(wSOLIW);
        lstSalesOrderLineItem.add(wSOLIW1);
        lstSalesOrderLineItem.add(wSOLIW2);
        
        WR_ORACLE_SalesOrder__c salesOrder = new WR_ORACLE_SalesOrder__c();
        WR_SalesOrderWrapper wSOW = new WR_SalesOrderWrapper(salesOrder);
       
    }
    
    //Create test data for salesorder
    private static void createTestDataforSalesOrder()
    {
        sof = new WR_SalesOrderFilter();
        sof.deliveryStartDate = System.today();
        sof.deliveryEndDate = System.today();      
        sof.isAscending = false;
        sof.sortingOrder = 'ASC'; 
        sof.numberValue = 'test_salesorder,SL#';
        sof.numberType = 'Sales Order';  
              
    }   
}