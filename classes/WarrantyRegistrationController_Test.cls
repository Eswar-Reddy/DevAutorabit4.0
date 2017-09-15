/* Test functionality of WarrantyRegistrationController 

  @Author Anjali Khandelwal
*/
@isTest
private class WarrantyRegistrationController_Test {

   static boolean f;
   static Warranty_Registration__c wrc_test1;
   static Warranty_Registration__c wrc_test2;
   static Warranty_Registration__c wrc_test3;
   static Attachment testAttachment;
   static WarrantyRegistrationController wrc;
   static Integer i=1;
   static List<WR_ORACLE_SalesOrder__c> lstSalesOrder;
   static List<WR_FDS_Product__c> lstProduct;
   static List<WR_FDS_Product__c> lstProduct1; 
   /*
       Test method for existing warranties that are in process, to resume them .
   */
   static Id roleId;
   static{
    roleId = [Select u.UserRoleId From User u where id=: userinfo.getUserId()].UserRoleId;
   }
   static testMethod void testWarrantyRegistration() {
       WarrantyRegistrationController wrc1;
       WarrantyRegistrationController wrc3;
        Account acct = getEUItalyPartnerAccount();
        User test_user = getPartnerPortalUser(acct); 
        System.runAs(test_user){ 
        
              
        acct = test_user.Contact.Account;
        Opportunity test_opp1 = createOpp(acct,test_user);
        //test_opp1.EU_Partner_Account__c = test_user.Contact.AccountId;
        //test_opp1.OwnerId = WR_Opportunity_Assigned_Owner__c.getInstance('OpportunityOwner').Opportunity_Owner_ID__c;
        test_opp1.Warranty_Signed_Italy__c = true;
        insert test_opp1;       
        Date edt = System.today();
        
        boolean errorFound = false;
        ApexPages.Message[] mssgs = ApexPages.getMessages();
        f = true;
        
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
        //test_opp2.EU_Partner_Account__c = test_user.Contact.AccountId;
        //test_opp2.OwnerId = WR_Opportunity_Assigned_Owner__c.getInstance('OpportunityOwner').Opportunity_Owner_ID__c;
        test_opp2.Warranty_Signed_Italy__c = true;
        //test_opp3.EU_Partner_Account__c = test_user.Contact.AccountId;
        //test_opp3.OwnerId = WR_Opportunity_Assigned_Owner__c.getInstance('OpportunityOwner').Opportunity_Owner_ID__c;
        test_opp3.Warranty_Signed_Italy__c = true;
        lstOpp.add(test_opp2);
        lstOpp.add(test_opp3);
        //Start new context       
        Test.startTest(); 
        insert lstOpp;        
        ApexPages.currentPage().getParameters().put('step','4');
        
        wrc1 = new WarrantyRegistrationController(); 
        //When Warranty is null then call some controller methods
        wrc1.attachPDF();
        wrc1.next();
        
        wrc1.back();
        //insert list of warranties into Database
        List<Warranty_Registration__c> lstwarranty = new List<Warranty_Registration__c>();
        wrc_test1 = new Warranty_Registration__c(Delivery_Date__c=edt,Partner_SFDC_ID__c=acct.Id,Customer_SFDC_ID__c=customer1.Id,status__c = 'Draft');    
        lstwarranty.add(wrc_test1);    
        wrc_test2 = new Warranty_Registration__c(Delivery_Date__c=edt,Partner_SFDC_ID__c=acct.Id,Customer_SFDC_ID__c=customer2.Id,status__c = 'Draft');    
        lstwarranty.add(wrc_test2);
        wrc_test3 = new Warranty_Registration__c(Delivery_Date__c=edt,Partner_SFDC_ID__c=acct.Id,Customer_SFDC_ID__c=customer2.Id,status__c = 'Draft');    
        lstwarranty.add(wrc_test3);
        insert lstwarranty;    
        createData(wrc_test1);
        
        wrc = new WarrantyRegistrationController(); 
        //System.assert(wrc.getWarranties()!=null);
        //Call to SearchCustomer when warranty has been created
        wrc.customerFilter.searchText=null;
        wrc.customerFilter.issearchByClick=true;
        wrc.searchCustomers(); //Search customers
        wrc.searchCustomersByClick();
        wrc.customerFilter.searchText='Du';
        wrc.searchCustomersByText();
        wrc.getCustomerList(); //Get CustomerList
        wrc.salesOrderFilter.sortField = 'serialNum';//Search salesorder according to sortfield
        wrc.searchSalesOrders(); // search sales order
        //wrc.selectAllSalesOrder(); //select all sales order
        ApexPages.currentPage().getParameters().put('warrantyID',null);
        wrc.deleteWarranty(); //Delete Warranty 
        //ErrorMsg wil be shown as no warranty is selected for deletion
        mssgs = ApexPages.getMessages();
        for(ApexPages.Message m : mssgs){
            if(m.getDetail()=='Missing id at index: 0')
                errorFound=true;
        }
        //System.assert(errorFound==true);
        errorFound = false;
        //Set some required parameters        
        ApexPages.currentPage().getParameters().put('warrantyNumber',wrc_test1.Id);
        ApexPages.currentPage().getParameters().put('warrantyID',wrc_test1.Id);
        ApexPages.currentPage().getParameters().put('customerNumber',wrc_test1.Customer_SFDC_ID__c);
        wrc.resumeRegistration(); //Resume registration successfully
        //Move to step 5 when warranty.delivery_date__c = null
        wrc.warranty.delivery_date__c = null;         
        wrc.next();
        //Move to step 5 when warranty.delivery_date__c is more than 1 week than today
        wrc.warranty.delivery_date__c = System.today() + 10;
        wrc.back();
        wrc.next();
        wrc.getCustomerList();        
        wrc.customerID = (wrc.customer != null && wrc.customer.Id != null) ? wrc.customer.Id : '';
        wrc.displayCustomerInfo(); //Display customer info
        ApexPages.currentPage().getParameters().put('warrantyID',wrc_test2.Id);   //Set which warranty u want to delete             
        wrc.deleteWarranty(); //Delete warranty
        
        wrc3 = new WarrantyRegistrationController();
        ApexPages.currentPage().getParameters().put('CustomerId',lstCust[0].Id);
        wrc3.setCustomerID();
        wrc.backToProdList();
        
        //MAM 23.MAY.2015 added pagination method calls to test start
        wrc3.Beginning();
        wrc3.NextPaging();
        wrc3.Previous();
        wrc3.End();
        wrc3.getDisablePrevious();
        wrc3.getDisableNext();
        wrc3.getTotal_size();
        wrc3.getPageNumber();
        wrc3.getTotalPages();
        //MAM 23.MAY.2015 end
        
        Test.stopTest();
    }
    } 
      
    public static testMethod void testCreateWarrantyRegistration()
    {
        SFDCSpecialUtilities.isRunningTest = True; 
   
        Account acct = getEUItalyPartnerAccount();
       // Account a = [Select Theater__c,Country_Domain__c from Account where Id =: acct.Id limit 1];      
        User test_user =getPartnerPortalUser(acct);      
        
        Country_Reference__c cr = CreateCountryReference();
        
        
        f = false;        
        System.runAs(test_user){        
        
        acct = test_user.Contact.Account;        
        Opportunity test_opp1 = createOpp(acct,test_user);        
        //test_opp1.EU_Partner_Account__c = test_user.Contact.AccountId;
        //test_opp1.OwnerId = WR_Opportunity_Assigned_Owner__c.getInstance('OpportunityOwner').Opportunity_Owner_ID__c; 
        test_opp1.Warranty_Signed_Italy__c = true;
        insert test_opp1;
        // call to createTestData()
        createTestData();  
        boolean errorFound = false;
        ApexPages.Message[] mssgs = ApexPages.getMessages();
        Date edt = System.today();        
        Date fdt = System.today() + 31;   
               
        wrc = new WarrantyRegistrationController();  //Step 0    
        wrc.searchWarranties();  //call to SearchWarranty()
        //Errormsg will be shown as there is  no warranty associated with current Partner user
        mssgs = ApexPages.getMessages();
        for(ApexPages.Message m : mssgs){
            if(m.getDetail()=='No records found')
                errorFound=true;
        }
        
        //System.assert(errorFound==true);
        errorFound = false;
        wrc.getWarranties();     //call to getWarranty()
        String expctdTab = 'Home';
        //System.assertEquals(expctdTab,wrc.defaultTabName); //Assert Current Tab Name
        wrc.next(); // new Registration,  Step1
        expctdTab = 'CustomerData';
        //System.assertEquals(expctdTab,wrc.defaultTabName); //Assert Current Tab Name
        wrc.saveProductSelection();       
        PageReference ref = wrc.back(); //  Step 0
        //System.assert(ref.getUrl().contains('/apex/WarrantyRegistrationPanel')); //Assert Current Url      
        wrc.next(); //Step 1
        expctdTab = 'CustomerData';
        //System.assertEquals(expctdTab,wrc.defaultTabName); //Assert Current Tab Name    
        wrc.searchCustomers(); //Search customers
        Integer expctdCustomers = 0;
      //System.assertEquals(null,wrc.opportunitySetController); //Assert Customers associated with current Partner user
        wrc.getCustomerList(); //Get customer list        
        wrc.saveOptinPreference();
        wrc.getCountry(); //MAM 11.JUN.2015 - Case 00519601
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
        system.debug('create customer:::' );
         //Start new context 
        Test.startTest(); 
        wrc.createCustomer(); // new customer created, Step 2
        //SuccessMsg will be shown as Customer has been created successfully           
        wrc.customerID = wrc.customer.Id;
        
        mssgs = ApexPages.getMessages();
          for(ApexPages.Message m : mssgs){
            if(m.getDetail()==Label.Create_Customer)
                errorFound=true;
          }
        //System.assert(errorFound==true);
        errorFound = false;                    
        expctdTab = 'InstallationData';
        //System.assertEquals(expctdTab,wrc.defaultTabName); //Assert Current Tab Name
        wrc.back(); // back on new Registration tab, Step 1
        expctdTab = 'CustomerData';
        //System.assertEquals(expctdTab,wrc.defaultTabName); //Assert Current Tab Name
        wrc.next(); // Step 2
        wrc.searchSalesOrders(); // search sales order
        //System.assertEquals(lstSalesOrder.size(),wrc.salesOrderList.size()); //Assert SalesOrderList size
        wrc.getPageSalesOrderList();        
        wrc.selectSalesOrder(); //select all sales order
        //System.assertEquals(lstProduct.size(),wrc.salesOrderProductList.size()); //Assert salesOrderProductList size
        //wrc.getPageSalesOrderProductList();
        wrc.productsPaginator.getRecords();
        wrc.selectSalesOrderLineItem(); //select all sales order Line item
        wrc.productsPaginator.getRecords(); 
        wrc.removeProducts();
       // //System.assertEquals(lstProduct1.size(),wrc.selectedProducts.size());  //Assert selectedProducts size  
        //wrc.getPageSelectedProducts();        
      
        wrc.next(); // warranty details, Step 3
        wrc.saveProductSelection();
        //ErrorMsg will be shown as delivery date is not set
        mssgs = ApexPages.getMessages();
        for(ApexPages.Message m : mssgs){
            if(m.getDetail()==Label.Enter_value)
                errorFound=true;
        }
        //System.assert(errorFound==true);
        errorFound = false;    
        wrc.back(); //back 1 step to set delivery date        
        wrc.warranty.Delivery_Date__c = fdt; //Set delivery date to 15 days more than current date      
        wrc.saveProductSelection();
        wrc.next(); // warranty details, Step 3
        //ErrorMsg will be shown as delivery date is later than 2 weeks from current date
        mssgs = ApexPages.getMessages();
        for(ApexPages.Message m : mssgs){
            if(m.getDetail()==Label.DoD_Greater_than_Today)
                errorFound=true;
        } 
        //System.assert(errorFound==true);
        errorFound = false;      
        wrc.back(); //back 1 step to set delivery date      
        wrc.warranty.Delivery_Date__c = edt; //Set delivery date to current date
        wrc.saveProductSelection();            
        expctdTab = 'WarantyDetails';
        //System.assertEquals(expctdTab,wrc.defaultTabName); //Assert Current tab name
        wrc.back(); //  Step 2
        wrc.next(); //Step 3
        wrc.back(); //  Step 2
        wrc.next(); //Step 3      
        wrc.next(); // on optin tab, Step 4        
        //System.assert(wrc.customerOpportunity != null); //Assert customerOpportunity
        wrc.back(); //  Step 3
        wrc.next(); //Step 4   
        wrc.next();        
        errorFound = false;    
        wrc.back(); //back 1 step to attach document
        //Create Attachment
        Attachment att1 = createAttachment();
        //Attachment att2 = createAttachment();
        //Add attachment to docList
        wrc.docList.add(att1);
        //wrc.docList.add(att2);     
        wrc.attachPDF(); //attach pdf without attaching document in pdf
        
        //Error Msg will be shown as documents are not attached
        mssgs = ApexPages.getMessages();
        for(ApexPages.Message m : mssgs){
            if(m.getDetail()==Label.Upload_File || m.getDetail()==Label.Homeowner_Signed_Document)
                errorFound=true;
        }
        //System.assert(errorFound==true);
        errorFound = false;    
        blob bdy = blob.valueOf('homeowner doc for test class of WarrantyRegistrationcontroller');
        wrc.homeownerDoc.Body = bdy;
        wrc.homeownerDoc.Name = ' homeownerDocAttachment';
        wrc.attachPDF();       //attach pdf             
        Integer expectedDocListSize = 2; 
        //System.assert(expectedDocListSize == wrc.docList.size()); 
        //ErrorMasg will be generated as no docId is set  
        wrc.removeAttachment();  
        mssgs = ApexPages.getMessages();
        for(ApexPages.Message m : mssgs){
            if(m.getDetail()=='Missing id at index: 0')
                errorFound=true;
        }
        //System.assert(errorFound==true);
        errorFound = false;
       ApexPages.currentPage().getParameters().put('docID',wrc.docList.get(0).Id);  //Set which attachment we want to remove     
       //wrc.removeAttachment(); //remove attachment     
       //After removing attachment docList size will be reduced by 1
       expectedDocListSize = 2;
       //System.assert(expectedDocListSize == wrc.docList.size());       
       
       //wrc.next();       //Step 5  , Finalize Step      
       //Errormsg will be displayed as warranty document is not signed by homeowner.
       mssgs = ApexPages.getMessages();
       for(ApexPages.Message m : mssgs){
            if(m.getDetail()==Label.Homeowner_Signed_Document)
                errorFound=true;
       }
       //test.stopTest();
       //System.assert(errorFound==true);
       errorFound = false;
        wrc.back(); //back 1 step, step 4 
       //Deselect all SalesOrderLineItem (Product)
       test.stopTest();
       wrc.selectedProductPaginator.getRecords(); 
       wrc.deselectSalesOrderLineItem();
       wrc.next();      //finalize step, error will be generated as we dont have any selected product
       //Errormsg will be displayed as no product is selected
       mssgs = ApexPages.getMessages(); system.debug('warranty in test::::::::::'  + wrc.warranty);
       //system.debug('selectedProducts in test::::::::::'  + wrc.selectedProducts);
       for(ApexPages.Message m : mssgs){
            system.debug('err msg-----------' + m.getDetail());
            if(m.getDetail()==Label.No_Product_to_Registered)
                errorFound=true;
       }
       //System.assert(errorFound==true);
       errorFound = false;       
       wrc.back(); //back 1 step to select products, step 4
       
       wrc.searchSalesOrders(); // search sales order       
       //wrc.searchSalesOrders(); //SearchSalesOrder according to Sortfield
       
       wrc.customerOpportunity.Warranty_Signed_Italy__c = true;   
       wrc.sortSalesOrders();   //Sort SalesOrder in Ascending Order
       wrc.salesOrderFilter.isAscending = false;
       wrc.sortSalesOrders();   //Sort SalesOrder in descending Order
       //wrc.selectAllSalesOrder(); //select all sales order
       wrc.selectSalesOrder();
       wrc.productsortField = 'ISselected__c';
       wrc.sortProductList();    //Sort ProductList on basis of sortField in Ascending Order
       wrc.isProductAscending = false;
       wrc.sortProductList();    //Sort ProductList on basis of sortField in descending Order
       //wrc.selectAllSalesOrderLineItem(); //Select all SalesOrderLineItem
       wrc.productsPaginator.getRecords();
       wrc.selectSalesOrderLineItem();      
       wrc.SelectedProductSortField = 'ISselected__c';
       wrc.sortSelectedProductList();  //Sort SelectedProductList on basis of sortField in Ascending Order
       wrc.isSelectedProductAscending = false;
       wrc.sortSelectedProductList();  //Sort SelectedProductList on basis of sortField in descending Order
       ApexPages.currentPage().getParameters().put('warrantyNumber',wrc.warranty.Id);            
       ApexPages.currentPage().getParameters().put('warrantyID',wrc.warranty.Id);
       ApexPages.currentPage().getParameters().put('customerNumber',wrc.warranty.Customer_SFDC_ID__c);
       wrc.checkUncheckAllSalesOrders();  //Uncheck All SalesOrders
       wrc.checkUncheckAllLineItems();    //Uncheck All SalesOrdersLineItems
       wrc.checkUncheckAllSelectedItems(); //Uncheck All SelectedItems
       wrc.requestedTabName = 'Home';
       wrc.next();
       //wrc.clearSalesOrder(); 
       //wrc.
       //wrc.clearSalesOrderLineItem(); //Clear all sales orders line item 
       //System.assert(wrc.selectedProducts.size()==0); //SelectedProducts will be empty
    
       //Test.stopTest();
       wrc.deleteWR();
        }
    }
   
    static testMethod void testUploadCSVFile() {
        WarrantyRegistrationController wrc1;
        Account acct = getEUItalyPartnerAccount();
        User test_user =getPartnerPortalUser(acct);               
        System.runAs(test_user){ 
        
        //Start new context       
        Test.startTest();       
        acct = test_user.Contact.Account;
        Opportunity test_opp1 = createOpp(acct,test_user);
        //test_opp1.EU_Partner_Account__c = test_user.Contact.AccountId;
        //test_opp1.OwnerId = WR_Opportunity_Assigned_Owner__c.getInstance('OpportunityOwner').Opportunity_Owner_ID__c;
        test_opp1.Warranty_Signed_Italy__c = true;
        insert test_opp1;       
        Date edt = System.today();
        
        boolean errorFound = false;
        ApexPages.Message[] mssgs = ApexPages.getMessages();
        f = true;
        Id commercialCustomerRecordTypeID = GW_RecTypes.GetRecordTypeId('Account','Commercial Customer');
        //Insert List of customer in database
        List<Account> lstCust = new List<Account>();
        Account customer1 = new Account(Name='DummyCustomerAcc1',CurrencyIsoCode='EUR',Theater__c='Europe',BillingCity='testCity',BillingCountry='Italy',BillingStreet='testStreet',BillingPostalCode='testZipCode',Country_Domain__c = 'combo-it',recordtypeId = commercialCustomerRecordTypeID);
        lstCust.add(customer1);
        Account customer2 = new Account(Name='DummyCustomerAcc2',CurrencyIsoCode='EUR',Theater__c='Europe',BillingCity='testCity1',BillingCountry='Italy',BillingStreet='testStreet1',BillingPostalCode='testZipCode1',Country_Domain__c = 'combo-it',recordtypeId = commercialCustomerRecordTypeID);
        lstCust.add(customer2);
        insert lstCust;
        
        //Create Opportunity for customers
        List<Opportunity> lstOpp = new List<Opportunity>();
        Opportunity test_opp2 = createOpp(customer1,test_user);
        Opportunity test_opp3 = createOpp(customer2,test_user);
        //test_opp2.EU_Partner_Account__c = test_user.Contact.AccountId;
        //test_opp2.OwnerId = WR_Opportunity_Assigned_Owner__c.getInstance('OpportunityOwner').Opportunity_Owner_ID__c;
        test_opp2.Warranty_Signed_Italy__c = true;
        //test_opp3.EU_Partner_Account__c = test_user.Contact.AccountId;
        //test_opp3.OwnerId = WR_Opportunity_Assigned_Owner__c.getInstance('OpportunityOwner').Opportunity_Owner_ID__c;
        test_opp3.Warranty_Signed_Italy__c = true;
        lstOpp.add(test_opp2);
        lstOpp.add(test_opp3);
        insert lstOpp;        
        //insert list of warranties into Database
        List<Warranty_Registration__c> lstwarranty = new List<Warranty_Registration__c>();
        wrc_test1 = new Warranty_Registration__c(Delivery_Date__c=edt,Partner_SFDC_ID__c=acct.Id,Customer_SFDC_ID__c=customer1.Id,status__c = 'Draft');    
        lstwarranty.add(wrc_test1);    
        wrc_test2 = new Warranty_Registration__c(Delivery_Date__c=edt,Partner_SFDC_ID__c=acct.Id,Customer_SFDC_ID__c=customer2.Id,status__c = 'Draft');    
        lstwarranty.add(wrc_test2);       
        insert lstwarranty;    
        createData(wrc_test1);
        ApexPages.currentPage().getParameters().put('customer',lstCust[0].Id);
        String testSalesOrderNumStr = 'test_salesorder1,test_salesorder2,test_salesorder3,test_salesorder4';
        ApexPages.currentPage().getParameters().put('salesoorder',testSalesOrderNumStr);
        wrc = new WarrantyRegistrationController(); 
        //System.assertEquals(wrc.warranty.Status__c, 'Draft');
        //System.assertEquals(wrc.warranty.Customer_SFDC_ID__C,lstCust[0].Id);
        //System.assert(wrc.getWarranties()!=null);
        wrc.csvFileName = 'testCSVFile';
        wrc.uploadCSVFile();
        wrc.csvFileName = 'testCSVFile.csv';
        Blob data = Blob.valueOf('SN#\ntestSN1,\ntestSN2,\ntestSN3,\ntestSN4,\ntestSN5,\ntestSN6,');
        wrc.serialNumFile = data;
        Test.stopTest();
        wrc.uploadCSVFile();
        //System.assertEquals(wrc.csvFileName,'testCSVFile.csv');
        //System.assertEquals(wrc.defaultTabName,WarrantyRegistrationUtil.PRODUCT_SELECTION_TAB );
        
        data = Blob.valueOf('SN#\ntestSN1,\ntestSN2,\ntestSN3,\ntestSN4,\ntestSN5,\ntestSN6,\ntestSN7,\ntestSN8,\ntestSN9,\ntestSN10,\ntestSN11,\ntestSN12,\ntestSN13,\ntestSN14,\ntestSN15,\ntestSN16,');
        wrc.serialNumFile = data;
        
        wrc.uploadCSVFile();
        //wrc.callSNCSV();
        wrc.generateExceptionCSV();
        wrc = new WarrantyRegistrationController(); 
        
        wrc.next();
        wrc.persistWarranty();
        
    }
    } 
    
    
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
    
     //Create Partner Portal user
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
     
     //Create Partner Account for US
  /*   private static Account getPartnerAccount(){
        String recType ='';
        recType = String.valueOf( GW_RecTypes.GetRecordTypeId('Account','Partner'));        
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
    
    //Create Partner Account for Europe
     private static Account getEURPartnerAccount(){
        String recType ='';
        recType = recType = String.valueOf( GW_RecTypes.GetRecordTypeId('Account','Partner'));            
        Account acct = new Account(name='test2'+String.valueOf(DateTime.now().getTime()),recordTypeID=recType);
        acct.ShippingCity = 'Jaipur';
        acct.ShippingStreet = 'Sitapura';
        acct.ShippingCountry = 'Germany';
        acct.ShippingState='Rajasthan';
        acct.ShippingPostalCode ='302020';
        acct.BillingCity = 'Jaipur';
        acct.BillingStreet = 'Sitapura';
        acct.BillingCountry = 'Germany';
        acct.BillingState='Rajasthan';
        acct.BillingPostalCode ='302020';
        acct.Online_Order_Access__c = true;
        acct.Oracle_Account_Number__c = 'test_oracle1';
        acct.Theater__c = 'Europe';
        acct.CurrencyIsoCode='EUR';
        acct.Country_Domain__c = 'combo-de';
        acct.Territory__c = 'Germany';
        acct.Type = 'Partner';
        acct.OwnerId = WR_Opportunity_Assigned_Owner__c.getInstance('OpportunityOwner').Opportunity_Owner_ID__c; 
        insert acct;
        return acct;                     
    }      */
    
    /*
        Create Partner Account(Customer) of Italy
    */
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
    
   
    /*
        This method is for creating test data-- creating salesOrder, SalesOrderLineItem
    */
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
    
    /*
        This Method if for creating WR_Line_Item__c objects for Warranty.
    */
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
    /*
        Creating attachment for uploading
    */
    private static Attachment createAttachment()    
    {
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
    //MAM 11.JUN.2015 start - case 00519601
    public static Country_Reference__c createCountryReference(){
        //insert country reference for theater lookup
        Country_Reference__c cr = new Country_Reference__c();
        cr.Country__c = 'United States';
        cr.Theater__c = 'North America';
        insert cr;
        return cr;
    }
    //MAM 11.JUN.2015 end
    
}