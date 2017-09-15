@isTest
private class TestLeaseOrderWizardController {

    static Account testPartnerAccount;
    static Account testEndCustomerAccount;
    static User testPartnerUser;

    static void setupAccounts()
    {
        testEndCustomerAccount = getPartnerAccount();

        testPartnerAccount = getPartnerAccount();
        testPartnerUser = getPartnerPortalUser( testPartnerAccount );
        testPartnerAccount = testPartnerUser.Contact.Account;
        testPartnerAccount.BillingState = 'Rajasthan';
        update testPartnerAccount;
    }

    private static List<Price_List_Item__c> createProductsList(){
        List<Price_List_Item__c> prodList = new List<Price_List_Item__c>();
        Price_List__c priceList = new Price_List__c();
        try{
            priceList.CurrencyIsoCode = 'USD';
            priceList.Oracle_Operating_Unit__c = 'SPCN OU';
            priceList.DSR_PO_Group_Email__c ='test@test.com';
            insert priceList;
        }catch(Exception e){
            for(Price_List__c p : [Select p.Will_Call_Fee__c, p.Shipping_Codes__c, p.RecordTypeId, p.Packaged_System_Item_ID__c, p.Oracle_Operating_Unit__c, p.Name, p.Id, p.Expedite_Fee__c, p.CurrencyIsoCode From Price_List__c p where p.Oracle_Operating_Unit__c like 'SPCN OU' LIMIT 1])
                priceList = p;
        }
        for(integer i=0;i<5;i++){
            Item__c testItem = new Item__c();
            testItem.Name = 'OracleItemId'+i;
            testItem.CurrencyIsoCode = 'USD';
            testItem.Description__c = 'test description'+i;
            testItem.Long_Description__c = 'test long description'+i;
            testItem.Item_ID__c = 'test'+i;
            insert testItem;
            Price_List_Item__c plItem = new Price_List_Item__c();
            plItem.Name = 'testItemName'+i;
            plItem.CurrencyIsoCode = 'USD';
            //plItem.Description__c = 'test Item Desc'+i;
            plItem.Category__c = 'Module';
            plItem.Item_ID__c = testItem.ID;
            plItem.Pricing_1__c = 5;
            plItem.Effective_Start_Date__c = System.today().addMonths(-1);
            plItem.Effective_End_Date__c = System.today().addMonths(+1);
            //plItem.Oracle_Item_ID__c = 'item4'+i;
            plItem.Price_List__c = priceList.ID;
            insert plItem;
            prodList.add(plItem);
        }
        return prodList;
    }

    private static List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper> createWrapperList(){
        List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper> wrapperList = new List<LeaseOrderWizardController.PurchaseOrderLineItemWrapper>();
        LeaseOrderWizardController.PurchaseOrderLineItemWrapper pWrap1 = new LeaseOrderWizardController.PurchaseOrderLineItemWrapper('','','','','',true,true);
        LeaseOrderWizardController.PurchaseOrderLineItemWrapper pwrap2 = new LeaseOrderWizardController.PurchaseOrderLineItemWrapper('test','test','test','test','5.0','USD',5.0,5.0,true,true);
        LeaseOrderWizardController.PurchaseOrderLineItemWrapper pwrap3 = new LeaseOrderWizardController.PurchaseOrderLineItemWrapper();
        wrapperList.add(pWrap1);
        wrapperList.add(pWrap2);
        wrapperList.add(pWrap3);
        return wrapperList;
    }

    private static Account getPartnerAccount(){
        String recType ='';
        for(RecordType r:[select id,Name from RecordType where sObjectType ='Account' and name ='Partner' LIMIT 1])
             recType = r.ID;

        Account acct = new Account(name='test'+String.valueOf(DateTime.now().getTime()),recordTypeID=recType);
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
        acct.Oracle_Account_Number__c = 't' + System.now().getTime();
        acct.Oracle_Warehouse__c = String.valueOf( System.now().getTime() );

        insert acct;
        setDealerShippingSite(acct);
        setDealerBillingSite(acct);
        return acct;
    }

    private static Ship_to_Site__c setDealerShippingSite(Account acct){
        Ship_to_Site__c shipSite = new Ship_to_Site__c();
        shipSite.Dealer_Account__c = acct.ID;
        shipSite.Address1__c ='Test Address1';
        shipSite.Address2__c ='Test Address2';
        shipSite.Address3__c ='Test Address3';
        shipSite.City__c ='Jaipur';
        shipSite.State__c='Rajasthan';
        shipSite.Country__c ='India';
        shipSite.Contact_First_Name__c='Con FirName';
        shipSite.Contact_Last_Name__c='Con LastName';
        shipSite.Zip__c='302018';
        insert shipSite;
        return shipSite;
    }

    private static Bill_to_Site__c setDealerBillingSite(Account acct){
        Bill_To_Site__c billToSite = new Bill_To_Site__c();
        billToSite.Dealer_Account__c = acct.ID;
        billToSite.Address1__c ='Test Address1';
        billToSite.Address2__c ='Test Address2';
        billToSite.Address3__c ='Test Address3';
        billToSite.City__c ='Jaipur';
        billToSite.State__c='Rajasthan';
        billToSite.Country__c ='India';
        /*billToSite.Contact_First_Name__c='Con FirName';
        billToSite.Contact_Last_Name__c='Con LastName';*/
        billToSite.Zip__c='302018';
        billToSite.Site_ID__c = String.valueOf(DateTime.now().getTime());
        insert billToSite;
        return billToSite;
    }

    private static User getPartnerPortalUser(Account acct){
        User user = null;
        for(User u:[select id,Name,contactId,Contact.AccountID, Contact.Account.Id,Contact.Account.AccountNumber,Contact.Account.Name,Contact.Account.ShippingStreet,Contact.Account.ShippingState,Contact.Account.ShippingCity,Contact.Account.ShippingCountry,Contact.Account.ShippingPostalCode,Contact.Account.Oracle_Operating_Unit__c, Contact.Account.Oracle_Account_Number__c from User where (Profile.Name = 'Partner Delegated Administrator') and ContactID != null and Contact.Authorized_to_Order__c = true and Contact.Account.Online_Order_Access__c = true and Contact.Account.ShippingCountry != null and Contact.Account.ShippingCity != null and Contact.Account.ShippingStreet != null and Contact.Account.ShippingState != null and Contact.Account.ShippingPostalCode != null and isActive=true LIMIT 1]){
            user =u;
        }
        if(user != null) return user;
        if(acct == null){
            acct =  getPartnerAccount();
        }
        Contact cont = new Contact(AccountID = acct.id,FirstName='testconbyPO2',LastName='testconbyPO2');
        cont.Email ='te@test.com';
        cont.Authorized_to_Order__c = true;
        insert cont;
        String username ='testconbyPO2@world.com';
        user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
        user.ContactId = cont.Id;
        user.Username = username;
        user.Alias = 'yoo';
        user.CommunityNickname = username.subString(0,7);
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.Email = cont.Email;
        user.LocaleSidKey = 'en_US';
        List<Profile> lstProfile = [select Id from Profile where Name = 'Partner Executive'];
        if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            insert user;
        }
        if(user.Id != null)
            for(User u:[select id,Name,contactId,Contact.AccountID, Contact.Account.AccountNumber,Contact.Account.Name,Contact.Account.ShippingStreet,Contact.Account.ShippingState,Contact.Account.ShippingCity,Contact.Account.ShippingCountry,Contact.Account.ShippingPostalCode,Contact.Account.Oracle_Operating_Unit__c, Contact.Account.Oracle_Account_Number__c from User where id =:user.ID LIMIT 1])
                user = u;
        return user;
    }

    private static User getEUResidentialUser(Account acct){
        User user = null;
        for(User u:[select id,Name,contactId,Contact.AccountID, Contact.Account.AccountNumber,Contact.Account.Name,Contact.Account.ShippingStreet,Contact.Account.ShippingState,Contact.Account.ShippingCity,Contact.Account.ShippingCountry,Contact.Account.ShippingPostalCode,Contact.Account.Oracle_Operating_Unit__c, Contact.Account.Oracle_Account_Number__c from User where (Profile.Name = 'EU Residential Installer') and ContactID != null and Contact.Authorized_to_Order__c = true and Contact.Account.Online_Order_Access__c = true and isActive = true LIMIT 1]){
            user =u;
        }
        if(user != null) return user;
        if(acct == null){
            acct =  getPartnerAccount();
        }
        Contact cont = new Contact(AccountID = acct.id,FirstName='testconbyPO2',LastName='testconbyPO2');
        cont.Email ='te@test.com';
        cont.Authorized_to_Order__c = true;
        insert cont;
        String username ='testconbyPO2@world.com';
        user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
        user.ContactId = cont.Id;
        user.Username = username;
        user.Alias = 'yoo';
        user.CommunityNickname = username.subString(0,7);
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.Email = cont.Email;
        user.LocaleSidKey = 'en_US';
        List<Profile> lstProfile = [select Id from Profile where Name = 'EU Residential Installer'];
        if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            insert user;
        }
        if(user.Id != null)
            for(User u:[select id,Name,contactId,Contact.AccountID, Contact.Account.AccountNumber,Contact.Account.Name,Contact.Account.ShippingStreet,Contact.Account.ShippingState,Contact.Account.ShippingCity,Contact.Account.ShippingCountry,Contact.Account.ShippingPostalCode,Contact.Account.Oracle_Operating_Unit__c, Contact.Account.Oracle_Account_Number__c from User where id =:user.ID LIMIT 1])
                user = u;
        return user;
    }

    private static SunPower_Design__c getDesignObjectWithItems(Account acct){
        SunPower_Design__c desObj = null;
        if(desObj == null){
            desObj = new SunPower_Design__c();
            desObj.SmartMount__c = true;
            desObj.DealerAccount__c= acct.id;
            desObj.Name='DES-123';
            desObj.Purchase_Order_Number__c ='TEST-123';
            desObj.system_size__c=25.0;
            insert desObj;
            List<SunPower_Design_Item__c> desItem = new List<SunPower_Design_Item__c>();
            for(integer i=0;i<5;i++){
                SunPower_Design_Item__c s1 = new SunPower_Design_Item__c(sunPower_Design__c = desObj.id);
                s1.Component_Type__c ='inverter - A';
                s1.Description__c ='Test Item '+i+'Description';
                s1.Is_Smart_Pack_Item__c =true;
                s1.Item_ID__c = '111'+(i+100);
                s1.Quantity__c =20 + i;
                desItem.add(s1);
            }
            if(desItem != null && desItem.size()>0)
                insert desItem;
        }
        return desObj;
    }

    private static Opportunity createOpp(Account acct,User u){
        Opportunity opp = new Opportunity();
        opp.AccountId = acct.ID;
        opp.Name = 'testOpp';
        opp.StageName = 'won';
        opp.ownerId = u.Id;
        opp.Probability =10;
        opp.CloseDate = System.today();
        opp.Reason_Won_Lost__c = 'Best Economics';
        insert opp;
        return opp;
    }

    private static void createPOLineItems(Purchase_Order__c po){
        for(integer i=0;i<5;i++){
            Item__c testItem = new Item__c();
            testItem.Name = 'OracleItemId'+i;
            testItem.CurrencyIsoCode = 'USD';
            testItem.Description__c = 'test description'+i;
            testItem.Long_Description__c = 'test long description'+i;
            testItem.Item_ID__c = 'testdesignitem'+i;
            testItem.active__c = true;
            insert testItem;

            Purchase_Order_Line__c pLine1 = new Purchase_Order_Line__c();
            pLine1.Purchase_Order__c = po.ID;
            pLine1.Oracle_Item_ID__c = testItem.ID;
            pLine1.Item_Description__c = 'test item'+i;
            pLine1.Item_ID__c = 'testid'+i;
            pLine1.Price__c = 5;
            pLine1.Quantity__c = 5;
            pLine1.Unit_Price__c = 5;
            pLine1.Item_Type__c = PriceListItemUtilityLease.ALACARTE_POITEMTYPE;
            pLine1.Quantity_per_Box__c = 2;
            pLine1.Order_Line_Number__c = '1.0';
            pLine1.CurrencyIsoCode = 'USD';
            insert pLine1;
        }
    }

    static testMethod void testAddLeaseLineItems(){
        final Integer DEALER_FEES_VALUE = 10000;

        setupAccounts();

        ApexPages.StandardController stdctrl;
        LeaseOrderWizardController leaseController;

        System.runAs(testPartnerUser){
            stdctrl = new Apexpages.Standardcontroller( new Purchase_Order__c() );
            leaseController = new LeaseOrderWizardController(stdctrl);

            Test.startTest();

                leaseController.purchaseOrder.Dealer_Fees__c = DEALER_FEES_VALUE;
                leaseController.addLeaseItemsToList();

            Test.stopTest();
        }

        //System.assert( leaseController.selLeaseProductItems != null, 'The lease line items should be instantiated' );
        //System.assertEquals( 4, leaseController.selLeaseProductItems.size(), 'There should be 3 line items created for dealer fees and 1 item for performance guarantee' );

        /*for( LeaseOrderWizardController.PurchaseOrderLineItemWrapper itemWrapper : leaseController.selLeaseProductItems )
        {
            if( itemWrapper.Name.equals( LeaseOrderWizardController.LEASE_INSTALLATION ) )
            {
                System.assertEquals( DEALER_FEES_VALUE * LeaseOrderWizardController.LEASE_INSTALLATION_PERCENTAGE, itemWrapper.totalPrice, 'The price of a lease construction line should be its percentage of the dealer fee' );
            }
            else if( itemWrapper.Name.equals( LeaseOrderWizardController.LEASE_INTERCONNECT ) )
            {
                System.assertEquals( DEALER_FEES_VALUE * LeaseOrderWizardController.LEASE_INTERCONNECT_PERCENTAGE, itemWrapper.totalPrice, 'The price of a lease interconnect line should be its percentage of the dealer fee' );
            }
            else if( itemWrapper.Name.equals( LeaseOrderWizardController.LEASE_ORIGINATION ) )
            {
                System.assertEquals( DEALER_FEES_VALUE * LeaseOrderWizardController.LEASE_ORIGINATION_PERCENTAGE, itemWrapper.totalPrice, 'The price of a lease origination line should be its percentage of the dealer fee' );
            }
            else if( itemWrapper.Name.equals( LeaseOrderWizardController.PERFORMANCE_GUARANTEE ) )
            {
                System.assertEquals( 0, itemWrapper.totalPrice, 'The price of a performance guarantee line item should always be 0' );
            }
        }*/
    }

    static testMethod void testDefaultLineItemPriceToZero()
    {
        setupAccounts();

        List<Price_List_Item__c> productList = createProductsList();

        ApexPages.StandardController stdctrl;
        LeaseOrderWizardController leaseController;

        System.runAs(testPartnerUser){

            stdctrl = new Apexpages.Standardcontroller( new Purchase_Order__c() );
            leaseController = new LeaseOrderWizardController(stdctrl);

            Test.startTest();

                leaseController.products = productList;
                leaseController.singleAddedprodId = productList[0].Id;
                leaseController.addItemToList();

            Test.stopTest();
        }

       //System.assertEquals( 1, leaseController.selectedProductsToShow.size(), 'A product should have been added into the controller\'s selected list' );
       //System.assertEquals( 0.0, leaseController.selectedProductsToShow[0].pOrderLine.Unit_Price__c, 'When a price line item is added on the lease page, the unit price should default to 0' );
       //System.assertEquals( 0.0, leaseController.selectedProductsToShow[0].pOrderLine.Price__c, 'When a price line item is added on the lease page, the unit price should default to 0' );
    }

    static testMethod void testSetWarehouseOnAddingLineItem()
    {
        setupAccounts();

        List<Price_List_Item__c> productList = createProductsList();

        Purchase_Order__c testOrder = new Purchase_Order__c();

        ApexPages.StandardController stdCtrl;
        LeaseOrderWizardController leaseController;

        Test.startTest();

            System.runAs( testPartnerUser )
            {
                stdCtrl = new ApexPages.StandardController( testOrder );
                leaseController = new LeaseOrderWizardController( stdCtrl );

                leaseController.products = productList;
                leaseController.singleAddedprodId = productList[0].Id;
                leaseController.addItemToList();
            }

        Test.stopTest();

        //System.assertEquals( 1, leaseController.selectedProductsToShow.size(), 'Only one item should be added to the controller at a time' );
        //System.assertEquals( testPartnerAccount.Oracle_Warehouse__c, leaseController.selectedProductsToShow[0].pOrderLine.Oracle_Warehouse__c, 'When user line items are created, they should be stamped with the partner warehouse' );
    }

    static testMethod void testSetWareHouseOnAutoLineItem()
    {
        final String WAREHOUSE_SETTING = 'TEST WAREHOUSE';

        setupAccounts();

        delete [ SELECT Id FROM LeaseOrderSettings__c ];
        LeaseOrderSettings__c setting = new LeaseOrderSettings__c();
        setting.Warehouse_Id__c = WAREHOUSE_SETTING;
        insert setting;

        Purchase_Order__c testOrder = new Purchase_Order__c();

        ApexPages.StandardController stdCont;
        LeaseOrderWizardController leaseController;

        Test.startTest();

            System.runAs( testPartnerUser )
            {
                stdCont = new ApexPages.StandardController( testOrder );
                leaseController = new LeaseOrderWizardController( stdCont );

                leaseController.purchaseOrder.Dealer_Fees__c = 1000;
                leaseController.addLeaseItemsToList();
            }

        Test.stopTest();

        /*System.assertEquals( 4, leaseController.selLeaseProductItems.size(), 'Line items should have been automatically created for fee fields' );
        for( LeaseOrderWizardController.PurchaseOrderLineItemWrapper lineItem : leaseController.selLeaseProductItems )
        {
            System.assertEquals( WAREHOUSE_SETTING, lineItem.pOrderLine.Oracle_Warehouse__c, 'Auto line items should set their warehouse from custom settings' );
        }*/
    }

   /* static testMethod void testSetItemIDOnAutoLines()
    {
        // delete existing line items
        delete [ SELECT Id FROM Item__c WHERE Description__c IN :LeaseOrderWizardController.AUTO_LINE_DESCRIPTIONS limit 1];
        // recreate items for auto descriptions
        Map<String, Item__c> itemDescriptionToItem = new Map<String, Item__c>();
        List<Item__c> testAutoLineItems = new List<Item__c>();
        for( String itemDescription : LeaseOrderWizardController.AUTO_LINE_DESCRIPTIONS )
        {
            Item__c newItem = new Item__c();
            newItem.Description__c = itemDescription;
            newItem.Item_ID__c = testAutoLineItems.size() + String.valueOf( System.now().getTime() );
            newItem.Name = newItem.Item_ID__c;
            itemDescriptionToItem.put( itemDescription, newItem );
            testAutoLineItems.add( newItem );
        }
        insert testAutoLineItems;

        // create price list
        Price_List__c testPriceList = new Price_List__c();
        testPriceList.Oracle_Operating_Unit__c = 'TESTPRICELIST';
        testPriceList.DSR_PO_Group_Email__c = 'test@test.com.test' + System.now().getTime();
        insert testPriceList;

        // create price list items for auto line items
        List<Price_List_Item__c> productsList = new List<Price_List_Item__c>();
        for( Item__c item : testAutoLineItems )
        {
            Price_List_Item__c newListItem = new Price_List_Item__c();
            newListItem.Item_ID__c = item.Id;
            newListItem.Price_List__c = testPriceList.Id;
            productsList.add( newListItem );
        }
        insert productsList;

        setupAccounts();
        Purchase_Order__c testOrder = new Purchase_Order__c();

        ApexPages.StandardController stdCtrl;
        LeaseOrderWizardController leaseController;

        Test.startTest();

            System.runAs( testPartnerUser )
            {
                stdCtrl = new ApexPages.StandardController( testOrder );
                leaseController = new LeaseOrderWizardController( stdCtrl );

                leaseController.purchaseOrder.Dealer_Fees__c = 1000;
                leaseController.addLeaseItemsToList();
            }

        Test.stopTest();

        //System.assertEquals( LeaseOrderWizardController.AUTO_LINE_DESCRIPTIONS.size(), leaseController.selLeaseProductItems.size(), 'The same number of line items as descriptions should have been created' );
        Map<Id, Item__c> itemsMap = new Map<Id, Item__c>( testAutoLineItems );
        //for( LeaseOrderWizardController.PurchaseOrderLineItemWrapper lineItem : leaseController.selLeaseProductItems )
      //  {
      //      System.assertNotEquals( null, lineItem.pOrderLine.Oracle_Item_ID__c, 'Auto line items should always be bound to an item record' );
     //       System.assertEquals( itemsMap.get( lineItem.pOrderLine.Oracle_Item_ID__c ).Description__c, lineItem.Name, 'Line items should be properly bound to item records based on description' );
      //  }
    }  */

    static testMethod void testMarkEndCustomerAccountOnSubmit()
    {
        setupAccounts();

        List<Price_List_Item__c> productList = createProductsList();

        Purchase_Order__c testOrder = new Purchase_Order__c();

        ApexPages.StandardController stdCtrl;
        LeaseOrderWizardController leaseController;

        Test.startTest();

            System.runAs( testPartnerUser )
            {
                stdCtrl = new ApexPages.StandardController( testOrder );
                leaseController = new LeaseOrderWizardController( stdCtrl );
                leaseController.purchaseOrder.Shipping_Method__c = 'Other';
                insert leaseController.purchaseOrder;

                leaseController.products = productList;
                leaseController.singleAddedprodId = productList[0].Id;
                leaseController.addItemToList();

                leaseController.purchaseOrder.End_Customer_Account__c = testEndCustomerAccount.Id;
                leaseController.retrieveEndCustomerBillTo();
                leaseController.retrieveEndCustomerShipTo();
                leaseController.submitOrder();
            }

        Test.stopTest();

        Account updatedEndCustomerAccount = [ SELECT Id, Lease_Order_Placed__c FROM Account WHERE Id = :testEndCustomerAccount.Id LIMIT 1 ];
        //System.assert( updatedEndCustomerAccount.Lease_Order_Placed__c, 'When an order is submitted, the end customer account should be marked as a lease customer' );
    }

    static testMethod void testRetrieveEndCustomerBillTo()
    {
        setupAccounts();

        Bill_To_Site__c endCustomerBillTo = [ SELECT Id FROM Bill_To_Site__c WHERE Dealer_Account__c = :testEndCustomerAccount.Id LIMIT 1 ];

        Purchase_Order__c testOrder = new Purchase_Order__c();
        ApexPages.Standardcontroller stdCtrl;
        LeaseOrderWizardController leaseController;

        Test.startTest();

            System.runAs( testPartnerUser )
            {
                stdCtrl = new ApexPages.Standardcontroller( testOrder );
                leaseController = new LeaseOrderWizardController( stdCtrl );

                leaseController.purchaseOrder.End_Customer_Account__c = testEndCustomerAccount.Id;
                leaseController.retrieveEndCustomerBillTo();
            }

        Test.stopTest();

        //System.assertEquals( endCustomerBillTo.Id, leaseController.purchaseOrder.Bill_to_Site__c, 'The bill to created for the end customer account should be attached to the order' );
    }

    static testMethod void testRetrieveEndCustomerShipTo()
    {
        setupAccounts();

        Ship_to_Site__c endCustomerShipTo = [ SELECT Id FROM Ship_to_Site__c WHERE Dealer_Account__c = :testEndCustomerAccount.Id LIMIT 1 ];

        Purchase_Order__c testOrder = new Purchase_Order__c();
        ApexPages.StandardController stdCtrl;
        LeaseOrderWizardController leaseController;

        Test.startTest();

            System.runAs( testPartnerUser )
            {
                stdCtrl = new ApexPages.StandardController( testOrder );
                leaseController = new LeaseOrderWizardController( stdCtrl );

                leaseController.purchaseOrder.End_Customer_Account__c = testEndCustomerAccount.Id;
                leaseController.retrieveEndCustomerShipTo();
            }

        Test.stopTest();

        //System.assertEquals( endCustomerShipTo.Id, leaseController.purchaseOrder.Ship_to_Site__c, 'The ship to created for the end customer account should be attached to the order' );
    }

    static testMethod void testRetrieveEndCustomerOpportunity()
    {
        setupAccounts();

        Opportunity endCustomerOpportunity = new Opportunity();
        endCustomerOpportunity.Name = testEndCustomerAccount.Name + ' Opportunity';
        endCustomerOpportunity.StageName = 'Some Stage';
        endCustomerOpportunity.CloseDate = Date.today();
        endCustomerOpportunity.AccountId = testEndCustomerAccount.Id;
        endCustomerOpportunity.Partner_Portal_Registration__c = true;
        insert endCustomerOpportunity;

        Purchase_Order__c testOrder = new Purchase_Order__c();
        ApexPages.StandardController stdCtrl;
        LeaseOrderWizardController leaseController;

        Test.startTest();

            System.runAs( testPartnerUser )
            {
                stdCtrl = new ApexPages.Standardcontroller( testOrder );
                leaseController = new LeaseOrderWizardController( stdCtrl );

                leaseController.purchaseOrder.End_Customer_Account__c = testEndCustomerAccount.Id;
                leaseController.retrieveEndCustomerOpportunity();
            }

        Test.stopTest();

        //System.assertEquals( endCustomerOpportunity.Id, leaseController.purchaseOrder.Opportunity__c, 'The partner opportunity under the end customer account should be attached to the order' );
    }

    static testMethod void testGetQuantityMessage()
    {
        setupAccounts();
        Purchase_Order__c testOrder = new Purchase_Order__c();
        ApexPages.StandardController stdCtrl;
        LeaseOrderWizardController leaseController;

        Test.startTest();

            System.runAs( testPartnerUser )
            {
                stdCtrl = new ApexPages.Standardcontroller( testOrder );
                leaseController = new LeaseOrderWizardController( stdCtrl );
                leaseController.showQuantityMessage = true;
                leaseController.getQunatityMessage();
            }

        Test.stopTest();

        List<ApexPages.Message> errorMessages = ApexPages.getMessages();
        System.assertEquals(System.Label.POQuantityErrorMessage ,  errorMessages[0].getSummary());

    }

    /*static testMethod void testShowDesignPageByButton()
    {
        final Integer DEALER_FEES_VALUE = 10000;
        setupAccounts();
        Purchase_Order__c testOrder = new Purchase_Order__c();
        ApexPages.StandardController stdCtrl;
        LeaseOrderWizardController leaseController;
        PageReference newPage;
        String DESIGN_URL;

        Test.startTest();

            System.runAs( testPartnerUser )
            {
                stdCtrl = new ApexPages.Standardcontroller( testOrder );
                leaseController = new LeaseOrderWizardController( stdCtrl );
                leaseController.dealerAccount = testPartnerAccount;
                leaseController.purchaseOrder.Dealer_Fees__c = DEALER_FEES_VALUE;
                leaseController.addLeaseItemsToList();
                leaseController.updatePOLineItems();
                DESIGN_URL = '/apex/Design_Tools?tabName=SmartPack2&purchaseOrder='+ leaseController.purchaseOrder.Id ;
                newPage = leaseController.showDesignPagebyButton();
            }

        Test.stopTest();

        System.assertEquals(DESIGN_URL ,  newPage.getUrl());
    }*/

    static testMethod void testUpdatePOLineItems()
    {

        final Integer DEALER_FEES_VALUE = 10000;
        setupAccounts();
        Purchase_Order__c testOrder = new Purchase_Order__c();
        ApexPages.StandardController stdCtrl;
        LeaseOrderWizardController leaseController;

        Test.startTest();

            System.runAs( testPartnerUser )
            {
                stdCtrl = new ApexPages.Standardcontroller( testOrder );
                leaseController = new LeaseOrderWizardController( stdCtrl );
                leaseController.purchaseOrder.Dealer_Fees__c = DEALER_FEES_VALUE;
                leaseController.addLeaseItemsToList();
                leaseController.updatePOLineItems();
            }

        Test.stopTest();
    }

    static testMethod void testShowPage3ByButton()
    {
        setupAccounts();
        Purchase_Order__c testOrder = new Purchase_Order__c();
        ApexPages.StandardController stdCtrl;
        LeaseOrderWizardController leaseController;
        PageReference newPage;

        Test.startTest();

            System.runAs( testPartnerUser )
            {
                stdCtrl = new ApexPages.Standardcontroller( testOrder );
                leaseController = new LeaseOrderWizardController( stdCtrl );
                newPage = leaseController.showPage3ByButton();
            }

        Test.stopTest();
    }

    static testMethod void testShowPage2ByButton()
    {
        setupAccounts();
        Purchase_Order__c testOrder = new Purchase_Order__c();
        ApexPages.StandardController stdCtrl;
        LeaseOrderWizardController leaseController;
        PageReference newPage;

        Test.startTest();

            System.runAs( testPartnerUser )
            {
                stdCtrl = new ApexPages.Standardcontroller( testOrder );
                leaseController = new LeaseOrderWizardController( stdCtrl );
                newPage = leaseController.showPage2byButton();
            }

        Test.stopTest();
    }

    static testMethod void testShowPage4ByButtonFrom3()
    {
        setupAccounts();
        Purchase_Order__c testOrder = new Purchase_Order__c();
        ApexPages.StandardController stdCtrl;
        LeaseOrderWizardController leaseController;
        PageReference newPage;

        Test.startTest();

            System.runAs( testPartnerUser )
            {
                stdCtrl = new ApexPages.Standardcontroller( testOrder );
                leaseController = new LeaseOrderWizardController( stdCtrl );
                newPage = leaseController.showPage4byButtonFrom3();
            }

        Test.stopTest();
    }

    static testMethod void testShowPage4ByButtonFrom3ForError()
    {
        final Integer DEALER_FEES_VALUE = 10000;
        setupAccounts();
        Purchase_Order__c testOrder = new Purchase_Order__c();
        ApexPages.StandardController stdCtrl;
        LeaseOrderWizardController leaseController;
        PageReference newPage;

        Test.startTest();

            System.runAs( testPartnerUser )
            {
                stdCtrl = new ApexPages.Standardcontroller( testOrder );
                leaseController = new LeaseOrderWizardController( stdCtrl );
                leaseController.purchaseOrder.Dealer_Fees__c = DEALER_FEES_VALUE;
                leaseController.addLeaseItemsToList();
                leaseController.updatePOLineItems();
                leaseController.purchaseOrder.Name = null;
                leaseController.purchaseOrder.End_Customer_Account__c = null;
                leaseController.purchaseOrder.Dealer_Account__c = null;
                newPage = leaseController.showPage4byButtonFrom3();
            }

        Test.stopTest();
    }

    static testMethod void testShowPage3ByButtonFrom4()
    {

        final Integer DEALER_FEES_VALUE = 10000;
        setupAccounts();
        Purchase_Order__c testOrder = new Purchase_Order__c();
        ApexPages.StandardController stdCtrl;
        LeaseOrderWizardController leaseController;
        PageReference newPage;

        Test.startTest();

            System.runAs( testPartnerUser )
            {
                stdCtrl = new ApexPages.Standardcontroller( testOrder );
                leaseController = new LeaseOrderWizardController( stdCtrl );
                leaseController.purchaseOrder.Dealer_Fees__c = DEALER_FEES_VALUE;
                leaseController.addLeaseItemsToList();
                leaseController.updatePOLineItems();
                leaseController.purchaseOrder.End_Customer_Account__c = null;
                leaseController.purchaseOrder.Dealer_Account__c = null;
                leaseController.purchaseOrder.Name = null;
                leaseController.purchaseOrder.Ship_to_Site__c = null;
                newPage = leaseController.showPage3byButtonFrom4();
            }

        Test.stopTest();

    }

  /*  static testMethod void testOppShippingAddressToShipToSite()
    {
        final Integer DEALER_FEES_VALUE = 10000;
        setupAccounts();
        Purchase_Order__c testOrder = new Purchase_Order__c();
        ApexPages.StandardController stdCtrl;
        LeaseOrderWizardController leaseController;
        PageReference newPage;
        Opportunity opp = createOpp(testPartnerAccount, testPartnerUser);
        Test.startTest();

            System.runAs( testPartnerUser )
            {
                stdCtrl = new ApexPages.Standardcontroller( testOrder );
                leaseController = new LeaseOrderWizardController( stdCtrl );
                leaseController.dealerAccount = testPartnerAccount;
                leaseController.purchaseOrder.Dealer_Fees__c = DEALER_FEES_VALUE;
                leaseController.purchaseOrder.Order_Status__c = 'New';
                leaseController.addLeaseItemsToList();
                leaseController.updatePOrder(false);
                leaseController.selectedCustomerOpportunity = opp.Id;
                leaseController.setOppShippingAddressToShipToSite();

            }

        Test.stopTest();
    }  */

    static testMethod void testSetPOShipToSiteContact()
    {
        setupAccounts();
        Purchase_Order__c testOrder = new Purchase_Order__c();
        ApexPages.StandardController stdCtrl;
        LeaseOrderWizardController leaseController;
        PageReference newPage;
        Test.startTest();

            System.runAs( testPartnerUser )
            {
                stdCtrl = new ApexPages.Standardcontroller( testOrder );
                leaseController = new LeaseOrderWizardController( stdCtrl );
                newPage = leaseController.setPOShipToSiteContact();
            }

        Test.stopTest();
    }

    static testMethod void testUpdatePOOnAction()
    {
        setupAccounts();
        Purchase_Order__c testOrder = new Purchase_Order__c();
        ApexPages.StandardController stdCtrl;
        LeaseOrderWizardController leaseController;
        PageReference newPage;
        Test.startTest();

            System.runAs( testPartnerUser )
            {
                stdCtrl = new ApexPages.Standardcontroller( testOrder );
                leaseController = new LeaseOrderWizardController( stdCtrl );
                leaseController.isUserAuthorized = true;
                leaseController.isPartnerUser = true;

                newPage = leaseController.updatePOOnAction();
            }

        Test.stopTest();
    }

    static testMethod void testUpdatePOOnActionWithNullPurchaseOrder()
    {
        setupAccounts();
        Purchase_Order__c testOrder = new Purchase_Order__c();
        ApexPages.StandardController stdCtrl;
        LeaseOrderWizardController leaseController;
        PageReference newPage;
        Test.startTest();

            System.runAs( testPartnerUser )
            {
                stdCtrl = new ApexPages.Standardcontroller( testOrder );
                leaseController = new LeaseOrderWizardController( stdCtrl );
                leaseController.isUserAuthorized = true;
                leaseController.isPartnerUser = false;
                leaseController.purchaseOrder = null;

                newPage = leaseController.updatePOOnAction();
            }

        Test.stopTest();
    }

    static testMethod void testGetCategories()
    {
        setupAccounts();
        Purchase_Order__c testOrder = new Purchase_Order__c();
        ApexPages.StandardController stdCtrl;
        LeaseOrderWizardController leaseController;
        PageReference newPage;
        Test.startTest();

            System.runAs( testPartnerUser )
            {
                stdCtrl = new ApexPages.Standardcontroller( testOrder );
                leaseController = new LeaseOrderWizardController( stdCtrl );
                List<SelectOption> categories= leaseController.getCategories();
            }

        Test.stopTest();
    }

    static testMethod void testLineNumberingOnTabChange()
    {
        setupAccounts();

        Purchase_Order__c testOrder = new Purchase_Order__c();

        List<Price_List_Item__c> productList = createProductsList();

        ApexPages.StandardController stdCtrl;
        LeaseOrderWizardController leaseController;

        Test.startTest();

            System.runAs( testPartnerUser )
            {
                stdCtrl = new ApexPages.StandardController( testOrder );
                leaseController = new LeaseOrderWizardController( stdCtrl );
                leaseController.purchaseOrder.Lease__c = TRUE;
                leaseController.purchaseOrder.Lease_Number__c = 'TEST LEASE';
                leaseController.purchaseOrder.Dealer_Fees__c = 1000.0;
                leaseController.purchaseOrder.System_Fees__c = 500.0;
                leaseController.purchaseOrder.Projected_Install__c = Date.Today();
                leaseController.purchaseOrder.End_Customer_Account__c = testEndCustomerAccount.Id;

                leaseController.products = productList;
                leaseController.singleAddedprodId = productList[0].Id;
                // contributes 1 line item
                leaseController.addItemToList();

                // contributes 4 line items
                leaseController.addLeaseItemsToList();

                leaseController.showPage2byButton();
            }

            System.assert( !ApexPages.hasMessages(), 'An error should not have been thrown: ' + ApexPages.getMessages() );

        Test.stopTest();

        System.assertEquals( 5, leaseController.selectedProductsToShow.size(), 'Auto generated line items and one added line item should be attached' );
        Double lineNumber = -1;
        for( LeaseOrderWizardController.PurchaseOrderLineItemWrapper itemWrapper : leaseController.selectedProductsToShow )
        {
            System.assert( lineNumber < Double.valueOf( itemWrapper.lineNumber ), lineNumber + ' is not greather than ' + itemWrapper.lineNumber );
            lineNumber = Double.valueOf( itemWrapper.lineNumber );
        }
    }
}