@isTest
global class OrderAppController_Test {

    @TestSetup
    public static void testDataSetup() {
        TestClassFactory.createAndInsertLeaseAgreementSettings();
        Lease_2_1_PO_Creation__c settings = new Lease_2_1_PO_Creation__c(name='Lease_2_1_Bypass',Lease_2_1_Test_Method_Bypass__c=true);
        insert settings;
        TestClassFactory.createModuleInverterRatios();

    }
    static String responseString = '{"pricing_order_response":{"sales_order":{"order_header":{"qp_api_start_date":"17-FEB-2016 13:53:14","order_total":"9729","smart_pack_flag":"","cust_account_number":"6424","custom_api_end_date":"17-FEB-2016 13:53:14","custom_api_start_date":"17-FEB-2016 13:53:14","ship_to_state_code":"AZ","sales_type":"PURCHASE","system_count":"1","channel_type":"RVAR","country":"US","monitoring_opt_out":"N","qp_api_end_date":"17-FEB-2016 13:53:14","racking_opt_out":"N","order_source":"","inverter_type":""},"status":"S","order_lines":{"order_line":[{"product_line_type":"Bundle","adjusted_unit_price":"0","internal_unit_price":"","internal_adj_unit_price":"","ordered_quantity":"1","category_id":"","pv_flag":"","item_description":"PACKAGED SYSTEMS","ordered_item":"102868","unit_price":"9729","internal_extended_price":"","extended_price":"9729"},{"product_line_type":"Bundle","adjusted_unit_price":"0","internal_unit_price":"","internal_adj_unit_price":"","ordered_quantity":"1","category_id":"","pv_flag":"","item_description":"MONITORING SYSTEM, RESIDENTIAL, OUTDOOR, PVS5 BASED, 240VAC, US","ordered_item":"test002","unit_price":"0","internal_extended_price":"","extended_price":"0"},{"product_line_type":"Bundle","adjusted_unit_price":"0","internal_unit_price":"","internal_adj_unit_price":"","ordered_quantity":"3","category_id":"","pv_flag":"","item_description":"KIT, BULK, INVISIMOUNT RACKING, 2KW","ordered_item":"invTest01","unit_price":"0","internal_extended_price":"","extended_price":"0"},{"product_line_type":"Bundle","adjusted_unit_price":"0","internal_unit_price":"786.6","internal_adj_unit_price":"648.6","ordered_quantity":"15","category_id":"","pv_flag":"","item_description":"PVM, SPR-X21-345-C-AC, U AR-S1 M5 B1","ordered_item":"test001","unit_price":"0","internal_extended_price":"9729","extended_price":"0"}]},"status_message":"--Routine: QP_PREQ_PUB.PRICE_REQUEST SUCCESS"}}}';

    public static testMethod void testOrderAppController() {
        Account testPartner = TestClassFactory.CreateDealer('dealerName', 'North America');

        Bill_to_Site__c b = new Bill_to_Site__c();
        b.Dealer_Account__c = testPartner.Id;
        b.Address1__c = testPartner.BillingStreet;
        b.City__c = testPartner.BillingCity;
        b.State__c = testPartner.BillingState;
        b.Zip__c = testPartner.BillingPostalCode;
        b.Country__c = testPartner.BillingCountry;
        b.Oracle_County__c = testPartner.Oracle_County__c;
        b.Oracle_Operating_Unit_Code__c = 'SPNA OU';
        insert b;

        Ship_to_Site__c s = new Ship_to_Site__c();
        s.Dealer_Account__c = testPartner.Id;
        s.Address1__c = testPartner.BillingStreet;
        s.City__c = testPartner.BillingCity;
        s.State__c = testPartner.BillingState;
        s.Zip__c = testPartner.BillingPostalCode;
        s.Country__c = testPartner.BillingCountry;
        s.Oracle_County__c = testPartner.Oracle_County__c;
        s.SiteID__c = '99999999test';
        s.Status__c = 'Active';
        s.DriverAssist__c = 'Yes';
        insert s;

        // add duplicate sts
        Ship_to_Site__c s2 = new Ship_to_Site__c();
        s2.Dealer_Account__c = testPartner.Id;
        s2.Address1__c = testPartner.BillingStreet;
        s2.City__c = testPartner.BillingCity;
        s2.State__c = testPartner.BillingState;
        s2.Zip__c = testPartner.BillingPostalCode;
        s2.Country__c = testPartner.BillingCountry;
        s2.Oracle_County__c = testPartner.Oracle_County__c;
        s2.SiteID__c = 'test99999999';
        s2.Status__c = 'Active';
        s2.IsDuplicate__c = true;
        s2.IsDuplicateId__c = s.Id;
        s2.DriverAssist__c = 'Yes';
        insert s2;

        Contact partnerContact = TestClassFactory.testContact('lastName', 'testpartnercon@noemail.com', TestClassFactory.retrieveRecordTypeID('Contact', 'Partner'));
        partnerContact.AccountId = testPartner.Id;
        partnerContact.Authorized_To_Order__c = TRUE;
        insert partnerContact;

        UserRole role = [SELECT Id FROM UserRole WHERE Name LIKE '%Partner Executive' LIMIT 1];

        Id execProfileId = SFDCSpecialUtilities.getProfileIdByName('Partner Executive');

        User currentUser = new User(alias = 'cashman1', email = partnerContact.Email,
                          emailencodingkey='UTF-8', lastname='Testing',
                          languagelocalekey='en_US', localesidkey='en_US',
                          profileid = execProfileId,  country='United States',
                          communityNickName = 'cashman1', timezonesidkey='America/Los_Angeles',
                          username=string.valueOf(math.random())+'u1@testorg.com',
                          contactId=partnerContact.Id, UserRole = role);

        Price_List__c priceList = TestClassFactory.createPriceList();

        System.runAs(currentUser)  {
            ApexPages.StandardController sc = new ApexPages.StandardController(new Purchase_Order__c());
            OrderAppController controller = new OrderAppController(sc);

            PageReference pageRef = Page.OrderTypeSelection;
            Test.setCurrentPage(pageRef);

            controller.callComponent1ControllerMethod();

            system.assertEquals(null, controller.setAlaCarteOrderItems());

            OrderAppController.getOpportunities();
            OrderAppController.getShippingContacts();
            OrderAppController.getDealerWarehouses(testPartner.Id);

            controller.purchaseOrder.Name = String.valueOf(Date.today());
            controller.purchaseOrder.Requested_Delivery_Date__c = Date.today().addDays(30);
            controller.purchaseOrder.Ship_to_Site__c = s.Id;
            controller.bts = b;
            controller.purchaseOrder.Bill_to_Site__c = b.Id;
            controller.shipContact = [SELECT Id, Name, Phone FROM Contact WHERE Id =: currentUser.ContactId];
            controller.sts = s;
            controller.purchaseOrder.Ship_to_Site__c = s.Id;
            controller.purchaseOrder.Ship_to_Contact__c = currentUser.ContactId;
            controller.purchaseOrder.Module_Quantity__c = 33;
            controller.purchaseOrder.Special_Instructions__c = 'This string is totally not null';
            String testString = controller.specialInstructions;
            testString = controller.oppId;
            testString = controller.selectedType;
            testString = controller.jsonHeader;
            Decimal d = controller.totalPrice;
            testString = controller.selectedTemplateId;

            OrderAppController.getDeliveryServicesSelectOptions();
            OrderAppController.updateDeliveryDetails(testString);
            OrderAppController.updateDeliveryDetails(JSON.serialize(s2));
            controller.defaultMonitoringQuantity();
            controller.initModules();
            controller.getModuleTypes();

            controller.selectedModuleTypeIdentifier = controller.configurators.values()[0].Id;
            System.assertNotEquals(controller.selectedModuleTypeIdentifier, null, controller.selectedModuleTypeIdentifier);
            controller.buildManufacturers();
            controller.selectedManufacturer = 'SunPower';
            controller.buildInverterTypes();

            controller.purchaseOrder.Racking_Opt_Out__c = false;
            controller.purchaseOrder.Racking_Type__c = 'Invisimount';
            controller.selectedModuleTypeIdentifier = 'a6k230000004ELr';
            controller.calculateRacking();
            controller.purchaseOrder.Racking_Opt_Out__c = true;
            controller.calculateRacking();

            controller.purchaseOrder.Module_Quantity__c = 40;
            controller.orderLines.add(new Purchase_Order_Line__c(Item_Id__c='test003',Quantity__c = 1));
            system.assertEquals(null, controller.addOrderLine());
            ApexPages.currentPage().getParameters().put('index', '1');
            system.assertEquals(null, controller.removeOrderLine());

            controller.calculateInverterCapacity();

            Test.startTest();
                system.assertEquals(Page.OrderOpportunitySelection.getURL(), controller.ToOpportunitySelect().getURL());
                system.assertEquals(Page.OrderShipping.getURL(), controller.ToShipping().getURL());
                system.assertEquals(Page.OrderTypeSelection.getURL(), controller.ToOrderType().getURL());
                system.assertEquals(Page.OrderShipping.getURL(), controller.ToShippingWithoutOpp().getURL());
                system.assertEquals(Page.OrderConfiguration.getURL(), controller.ToSystemsConfig().getURL());

                controller.purchaseOrder.Order_Type__c = 'Multi-System';
                controller.sts = new Ship_To_Site__c(State__c = 'CO');

                System.assertEquals(controller.powerWallPartner, true, controller.powerWallPartner);
                System.assertNotEquals(controller.flexiRatios, null);

                //set mock
                Test.setMock(HttpCalloutMock.class, new CashOrdersMockResponse());
                //controller.doCallout();

                controller.buildRepsonseList(responseString);
                Ship_To_Site__c tempSite = s.clone(false,true,true,false);
                tempSite.RecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Ship_To_Site__c.sobjectType).get('Opportunity');
                tempSite.SiteID__c = '99999999test2';
                insert tempSite;

                controller.purchaseOrder.Ship_to_Site__c = tempSite.Id;
                controller.saveFromShipping();
                controller.saveFromOrderConfig();

                controller.purchaseOrder.Accept_Terms__c = TRUE;
                controller.purchaseOrder.Ship_To_Site__c = s2.Id;
                controller.submitOrder();
                controller.getEquinoxModules();
                controller.getMonitoringForAC();

                ApexPages.currentPage().getParameters().put('POID', controller.purchaseOrder.Id);
                PageReference pageRef2 = Page.OrderShipping;
                Test.setCurrentPage(pageRef2);
            Test.stopTest();
        }

    }

    public static testMethod void testWithPO() {
        Opportunity o = TestClassFactory.testOpportunity('String name', 'Unidentified', Date.today().addDays(30), SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Opportunity.sobjectType).get('Unidentified'));
        insert o;

        Purchase_Order__c po = new Purchase_Order__c();
        po.Name = '1201147';
        po.Opportunity__c = o.Id;
        po.Order_Type__c = 'alacarte';
        insert po;

        Test.startTest();
            PageReference pg = Page.OrderFinalConfirmation;
            pg.getParameters().put('POID', po.Id);
            Test.setCurrentPage(pg);
            ApexPages.StandardController sc = new ApexPages.StandardController(po);
            OrderAppController controller = new OrderAppController(sc);
            controller.buildRepsonseList(responseString);
            controller.saveFromOrderConfig();
        Test.stopTest();
    }

    public static TestMethod void testOrderAppController2() {

        ComponentControllerBase base = new ComponentControllerBase();

        PageControllerBase pageBase = new PageControllerBase();
        pageBase.getMyComponentController();
        pageBase.setComponentControllerMap('Test', base);
        pageBase.setComponentController(base);
        pageBase.getThis();

        Account testPartner = TestClassFactory.CreateDealer('dealerName', 'North America');

        Bill_to_Site__c b = new Bill_to_Site__c();
        b.Dealer_Account__c = testPartner.Id;
        b.Address1__c = testPartner.BillingStreet;
        b.City__c = testPartner.BillingCity;
        b.State__c = testPartner.BillingState;
        b.Zip__c = testPartner.BillingPostalCode;
        b.Country__c = testPartner.BillingCountry;
        b.Oracle_County__c = testPartner.Oracle_County__c;
        b.Oracle_Operating_Unit_Code__c = 'SPNA OU';
        insert b;

        Ship_to_Site__c s = new Ship_to_Site__c();
        s.Dealer_Account__c = testPartner.Id;
        s.Address1__c = testPartner.BillingStreet;
        s.City__c = testPartner.BillingCity;
        s.State__c = testPartner.BillingState;
        s.Zip__c = testPartner.BillingPostalCode;
        s.Country__c = testPartner.BillingCountry;
        s.Oracle_County__c = testPartner.Oracle_County__c;
        s.SiteID__c = '99999999';
        s.Status__c = 'Active';

        insert s;

        Contact partnerContact = TestClassFactory.testContact('lastName', 'testpartnercon@noemail.com', TestClassFactory.retrieveRecordTypeID('Contact', 'Partner'));
        partnerContact.AccountId = testPartner.Id;
        partnerContact.Authorized_To_Order__c = TRUE;
        insert partnerContact;

        UserRole role = [SELECT Id FROM UserRole WHERE Name LIKE '%Partner Executive' LIMIT 1];

        Id execProfileId = SFDCSpecialUtilities.getProfileIdByName('Partner Executive');

        User currentUser = new User(alias = 'cashman1', email = partnerContact.Email,
                          emailencodingkey='UTF-8', lastname='Testing',
                          languagelocalekey='en_US', localesidkey='en_US',
                          profileid = execProfileId,  country='United States',
                          communityNickName = 'cashman1', timezonesidkey='America/Los_Angeles',
                          username=string.valueOf(math.random())+'u1@testorg.com',
                          contactId=partnerContact.Id, UserRole = role);
        Price_List__c priceList = TestClassFactory.createPriceList();

        System.runAs(currentUser)  {
            Test.startTest();

            ApexPages.StandardController sc = new ApexPages.StandardController(new Purchase_Order__c());
            OrderAppController controller = new OrderAppController(sc);

            PageReference pageRef = Page.OrderTypeSelection;
            Test.setCurrentPage(pageRef);

            controller.purchaseOrder.Name = String.valueOf(Math.random());
            controller.purchaseOrder.Requested_Delivery_Date__c = Date.today().addDays(30);
            controller.purchaseOrder.Ship_to_Site__c = s.Id;
            controller.bts = b;
            controller.purchaseOrder.Bill_to_Site__c = b.Id;
            controller.shipContact = [SELECT Id, Name, Phone FROM Contact WHERE Id =: currentUser.ContactId];
            controller.sts = s;
            controller.purchaseOrder.Ship_to_Site__c = s.Id;
            controller.purchaseOrder.Ship_to_Contact__c = currentUser.ContactId;
            controller.purchaseOrder.Special_Instructions__c = 'null';

            controller.purchaseOrder.Module_Quantity__c = 1;
            controller.defaultMonitoringQuantity();

            controller.initModules();
            controller.getModuleTypes();
            controller.selectedModuleTypeIdentifier = controller.configurators.values()[0].Id;
            System.assertNotEquals(controller.selectedModuleTypeIdentifier, null, controller.selectedModuleTypeIdentifier);

            controller.selectedManufacturer = 'SunPower';
            controller.purchaseOrder.Racking_Opt_Out__c = FALSE;
            controller.purchaseOrder.Racking_Type__c = 'SolarMount';
            controller.purchaseOrder.Module_Quantity__c = 40;
            controller.orderLines.add(new Purchase_Order_Line__c(Item_Id__c='test003',Quantity__c = 1));
            controller.purchaseOrder.Order_Type__c = 'Multi-System';
            controller.sts = new Ship_To_Site__c(State__c = 'CO');

            //set mock
            Test.setMock(HttpCalloutMock.class, new CashOrdersNegativeResponse());
            controller.doCallout();

            Test.stopTest();
        }
    }



    public static testMethod void testOrderAppShipping() {
        Account testPartner = TestClassFactory.CreateDealer('dealerName', 'North America');

        Bill_to_Site__c b = new Bill_to_Site__c();
        b.Dealer_Account__c = testPartner.Id;
        b.Address1__c = testPartner.BillingStreet;
        b.City__c = testPartner.BillingCity;
        b.State__c = testPartner.BillingState;
        b.Zip__c = testPartner.BillingPostalCode;
        b.Country__c = testPartner.BillingCountry;
        b.Oracle_County__c = testPartner.Oracle_County__c;
        b.Oracle_Operating_Unit_Code__c = 'SPNA OU';
        insert b;

        Ship_to_Site__c s = new Ship_to_Site__c();
        s.Dealer_Account__c = testPartner.Id;
        s.Address1__c = testPartner.BillingStreet;
        s.City__c = testPartner.BillingCity;
        s.State__c = testPartner.BillingState;
        s.Zip__c = testPartner.BillingPostalCode;
        s.Country__c = testPartner.BillingCountry;
        s.Oracle_County__c = testPartner.Oracle_County__c;
        s.SiteID__c = '99999999';
        s.Status__c = 'Active';
        insert s;

        Contact partnerContact = TestClassFactory.testContact('lastName', 'testpartnercon@noemail.com', TestClassFactory.retrieveRecordTypeID('Contact', 'Partner'));
        partnerContact.AccountId = testPartner.Id;
        partnerContact.Authorized_To_Order__c = TRUE;
        insert partnerContact;

        UserRole role = [SELECT Id FROM UserRole WHERE Name LIKE '%Partner Executive' LIMIT 1];

        Id execProfileId = SFDCSpecialUtilities.getProfileIdByName('Partner Executive');

        User currentUser = new User(alias = 'cashman1', email = partnerContact.Email,
                          emailencodingkey='UTF-8', lastname='Testing',
                          languagelocalekey='en_US', localesidkey='en_US',
                          profileid = execProfileId,  country='United States',
                          communityNickName = 'cashman1', timezonesidkey='America/Los_Angeles',
                          username=string.valueOf(math.random())+'u1@testorg.com',
                          contactId=partnerContact.Id, UserRole = role);

        Price_List__c priceList = TestClassFactory.createPriceList();

        System.runAs(currentUser)  {

            ApexPages.StandardController sc = new ApexPages.StandardController(new Purchase_Order__c());
            OrderAppController controller = new OrderAppController(sc);

            PageReference pageRef = Page.OrderTypeSelection;
            Test.setCurrentPage(pageRef);

            OrderAppController.getOpportunities();
            OrderAppController.getShippingContacts();
            OrderAppController.getDealerWarehouses(testPartner.Id);

            controller.purchaseOrder.Name = String.valueOf(Date.today());
            controller.purchaseOrder.Requested_Delivery_Date__c = Date.today().addDays(30);
            controller.purchaseOrder.Ship_to_Site__c = s.Id;
            controller.bts = b;
            controller.shipContact = [SELECT Id, Name, Phone FROM Contact WHERE Id =: currentUser.ContactId];
            controller.sts = s;
            controller.purchaseOrder.Ship_to_Site__c = s.Id;
            controller.purchaseOrder.Ship_to_Contact__c = currentUser.ContactId;
            controller.purchaseOrder.Special_Instructions__c = 'This string is totally not null';

            Test.startTest();

            controller.purchaseOrder.Order_Type__c = 'Multi-System';

            Ship_To_Site__c tempSite = s.clone(false,true,true,false);
            tempSite.RecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Ship_To_Site__c.sobjectType).get('Opportunity');
            tempSite.SiteID__c = '99999999test2';
            insert tempSite;

            controller.purchaseOrder.Ship_to_Site__c = tempSite.Id;
            controller.saveFromShipping();

            controller.purchaseOrder.Order_Type__c = 'Ala Carte';
            controller.saveFromShipping();

            controller.purchaseOrder.Order_Type__c = 'Equinox';
            controller.saveFromShipping();

            controller.purchaseOrder.Order_Type__c = 'Storage Bundle';
            controller.saveFromShipping();


            Test.stopTest();
        }

    }

    public static testMethod void testOrderAppStorage() {
        Account testPartner = TestClassFactory.CreateDealer('dealerName', 'North America');

        Bill_to_Site__c b = new Bill_to_Site__c();
        b.Dealer_Account__c = testPartner.Id;
        b.Address1__c = testPartner.BillingStreet;
        b.City__c = testPartner.BillingCity;
        b.State__c = testPartner.BillingState;
        b.Zip__c = testPartner.BillingPostalCode;
        b.Country__c = testPartner.BillingCountry;
        b.Oracle_County__c = testPartner.Oracle_County__c;
        b.Oracle_Operating_Unit_Code__c = 'SPNA OU';
        insert b;

        Ship_to_Site__c s = new Ship_to_Site__c();
        s.Dealer_Account__c = testPartner.Id;
        s.Address1__c = testPartner.BillingStreet;
        s.City__c = testPartner.BillingCity;
        s.State__c = testPartner.BillingState;
        s.Zip__c = testPartner.BillingPostalCode;
        s.Country__c = testPartner.BillingCountry;
        s.Oracle_County__c = testPartner.Oracle_County__c;
        s.SiteID__c = '99999999';
        s.Status__c = 'Active';
        insert s;

        Contact partnerContact = TestClassFactory.testContact('lastName', 'testpartnercon@noemail.com', TestClassFactory.retrieveRecordTypeID('Contact', 'Partner'));
        partnerContact.AccountId = testPartner.Id;
        partnerContact.Authorized_To_Order__c = TRUE;
        insert partnerContact;

        UserRole role = [SELECT Id FROM UserRole WHERE Name LIKE '%Partner Executive' LIMIT 1];

        Id execProfileId = SFDCSpecialUtilities.getProfileIdByName('Partner Executive');

        User currentUser = new User(alias = 'cashman1', email = partnerContact.Email,
                          emailencodingkey='UTF-8', lastname='Testing',
                          languagelocalekey='en_US', localesidkey='en_US',
                          profileid = execProfileId,  country='United States',
                          communityNickName = 'cashman1', timezonesidkey='America/Los_Angeles',
                          username=string.valueOf(math.random())+'u1@testorg.com',
                          contactId=partnerContact.Id, UserRole = role);

        Price_List__c priceList = TestClassFactory.createPriceList();

        Item__c i = new Item__c();
        i.Active__c = true;
        i.Description__c = 'Storage';
        i.Item_ID__c = '55847';
        insert i;

        Storage_Configuration__c sConfig = new Storage_Configuration__c();
        sConfig.Item__c = i.Id;
        insert sConfig;

        System.runAs(currentUser)  {
            ApexPages.StandardController sc = new ApexPages.StandardController(new Purchase_Order__c());
            OrderAppController controller = new OrderAppController(sc);

            PageReference pageRef = Page.OrderTypeSelection;
            Test.setCurrentPage(pageRef);

            OrderAppController.getOpportunities();
            OrderAppController.getShippingContacts();
            OrderAppController.getDealerWarehouses(testPartner.Id);

            //basic methods
            controller.purchaseOrder.Order_Type__c = 'Storage Bundle';
            controller.purchaseOrder.Name = String.valueOf(Date.today());
            controller.purchaseOrder.Requested_Delivery_Date__c = Date.today().addDays(30);
            controller.purchaseOrder.Ship_to_Site__c = s.Id;
            controller.bts = b;
            controller.purchaseOrder.Bill_to_Site__c = b.Id;
            controller.shipContact = [SELECT Id, Name, Phone FROM Contact WHERE Id =: currentUser.ContactId];
            controller.sts = s;
            controller.purchaseOrder.Ship_to_Site__c = s.Id;
            controller.purchaseOrder.Ship_to_Contact__c = currentUser.ContactId;
            controller.purchaseOrder.Special_Instructions__c = 'null';

            controller.purchaseOrder.Module_Quantity__c = 33;
            controller.defaultMonitoringQuantity();

            System.assertEquals(controller.powerWallPartner, true, controller.powerWallPartner);
            System.assertNotEquals(controller.flexiRatios, null);

            controller.initModules();
            controller.getModuleTypes();
            controller.selectedModuleTypeIdentifier = controller.configurators.values()[0].Id;
            System.assertNotEquals(controller.selectedModuleTypeIdentifier, null, controller.selectedModuleTypeIdentifier);
            controller.buildManufacturers();

            controller.purchaseOrder.Racking_Opt_Out__c = FALSE;
            controller.purchaseOrder.Racking_Type__c = 'Invisimount';
            controller.selectedModuleTypeIdentifier = 'a6k230000004ELr';

            controller.calculateRacking();

            Inverter_Configuration__c inverterConfig = [SELECT Inverter_Manufacturer__c, Item__r.Item_Id__c FROM Inverter_Configuration__c
                                                        WHERE Name = 'SolarEdge Storage Inverter' LIMIT 1];
            controller.purchaseOrder.Module_Quantity__c = 33;
            controller.selectedManufacturer = inverterConfig.Inverter_Manufacturer__c;

            controller.orderLines.add(new Purchase_Order_Line__c(Item_Id__c=inverterConfig.Item__r.Item_Id__c,Quantity__c = 1));
            system.assertEquals(null, controller.addOrderLine());
            ApexPages.currentPage().getParameters().put('index', '1');
            system.assertEquals(null, controller.removeOrderLine());

            controller.buildInverterTypes();
            controller.calculateInverterCapacity();
            controller.getFlexiRatios();

            controller.buildStorageSelections();

            try {
                controller.purchaseOrder.Storage__c = [SELECT Id FROM Storage_Configuration__c LIMIT 1].Id;
                controller.selectedStorageId = controller.purchaseOrder.Storage__c;
                controller.purchaseOrder.Storage_Quantity__c = '1';
            } catch(Exception e) {
                System.debug('no storage item found');
            }

            Test.startTest();

            system.assertEquals(Page.OrderShipping.getURL(), controller.ToShipping().getURL());
            system.assertEquals(Page.OrderTypeSelection.getURL(), controller.ToOrderType().getURL());
            system.assertEquals(Page.OrderStorageConfiguration.getURL(), controller.ToSystemsConfig().getURL());

            //set mock
            Test.setMock(HttpCalloutMock.class, new CashOrdersMockResponse());
            controller.doCallout();

            controller.saveFromShipping();
            controller.saveFromOrderConfig();

            controller.purchaseOrder.Accept_Terms__c = TRUE;
            controller.submitOrder();

            controller.getEquinoxModules();
            controller.getMonitoringForAC();

            ApexPages.currentPage().getParameters().put('POID', controller.purchaseOrder.Id);
            PageReference pageRef2 = Page.OrderShipping;
            Test.setCurrentPage(pageRef2);
            Test.stopTest();
        }

    }

    public static testMethod void testOrderAppControllerNegatives() {
        Account testPartner = TestClassFactory.CreateDealer('dealerName', 'North America');

        Bill_to_Site__c b = new Bill_to_Site__c();
        b.Dealer_Account__c = testPartner.Id;
        b.Address1__c = testPartner.BillingStreet;
        b.City__c = testPartner.BillingCity;
        b.State__c = testPartner.BillingState;
        b.Zip__c = testPartner.BillingPostalCode;
        b.Country__c = testPartner.BillingCountry;
        b.Oracle_County__c = testPartner.Oracle_County__c;
        b.Oracle_Operating_Unit_Code__c = 'SPNA OU';
        insert b;

        Ship_to_Site__c s = new Ship_to_Site__c();
        s.Dealer_Account__c = testPartner.Id;
        s.Address1__c = testPartner.BillingStreet;
        s.City__c = testPartner.BillingCity;
        s.State__c = testPartner.BillingState;
        s.Zip__c = testPartner.BillingPostalCode;
        s.Country__c = testPartner.BillingCountry;
        s.Oracle_County__c = testPartner.Oracle_County__c;
        s.SiteID__c = '99999999';
        s.Status__c = 'Active';

        insert s;

        Contact partnerContact = TestClassFactory.testContact('lastName', 'testpartnercon@noemail.com', TestClassFactory.retrieveRecordTypeID('Contact', 'Partner'));
        partnerContact.AccountId = testPartner.Id;
        partnerContact.Authorized_To_Order__c = TRUE;
        insert partnerContact;

        UserRole role = [SELECT Id FROM UserRole WHERE Name LIKE '%Partner Executive' LIMIT 1];

        Id execProfileId = SFDCSpecialUtilities.getProfileIdByName('Partner Executive');

        User currentUser = new User(alias = 'cashman1', email = partnerContact.Email,
                          emailencodingkey='UTF-8', lastname='Testing',
                          languagelocalekey='en_US', localesidkey='en_US',
                          profileid = execProfileId,  country='United States',
                          communityNickName = 'cashman1', timezonesidkey='America/Los_Angeles',
                          username=string.valueOf(math.random())+'u1@testorg.com',
                          contactId=partnerContact.Id, UserRole = role);
        Price_List__c priceList = TestClassFactory.createPriceList();

        System.runAs(currentUser)  {
            Test.startTest();

            ApexPages.StandardController sc = new ApexPages.StandardController(new Purchase_Order__c());
            OrderAppController controller = new OrderAppController(sc);

            PageReference pageRef = Page.OrderTypeSelection;
            Test.setCurrentPage(pageRef);

            //dml validations
            controller.purchaseOrder.Dealer_Account__c = null;
            controller.purchaseOrder.Bill_to_Site__c = null;
            controller.shipContact = [SELECT Id, Name, Phone FROM Contact WHERE Id =: currentUser.ContactId];
            controller.sts = s;
            controller.purchaseOrder.Ship_to_Site__c = s.Id;
            controller.saveFromShipping();
            controller.saveFromOrderConfig();
            controller.submitOrder();

            //random tests for null coverage
            controller.getAvailableTemplates();
            controller.getModuleTypes();
            controller.buildManufacturers();
            controller.buildInverterTypes();
            controller.buildRackingSelection();
            controller.getRacking();


            //calculation validations
            controller.purchaseOrder.Number_Of_Systems__c = -1;
            controller.validateSystemsCalculations();

            controller.purchaseOrder.Number_Of_Systems__c = 1;
            controller.validateSystemsCalculations();

            controller.initModules();
            controller.getModuleTypes();
            controller.selectedModuleTypeIdentifier = controller.configurators.values()[0].Id;
            controller.purchaseOrder.Racking_Opt_Out__c = false;
            controller.purchaseOrder.Racking_Type__c = null;
            controller.validateSystemsCalculations();

            controller.selectedManufacturer = null;
            controller.validateSystemsCalculations();

            controller.buildManufacturers();
            controller.selectedManufacturer = 'SMA';
            controller.orderLines = null;
            controller.purchaseOrder.Monitoring_Quantity__c = -1;
            controller.validateSystemsCalculations();

            controller.purchaseOrder.Monitoring_Opt_Out__c = true;
            controller.defaultMonitoringQuantity();

            controller.purchaseOrder.Module_Quantity__c = 1;
            controller.orderLines = new List<Purchase_Order_Line__c>();
            controller.buildInverterTypes();
            controller.orderLines.add(new Purchase_Order_Line__c(Item_Id__c='test003',Quantity__c = 5));
            controller.validateSystemsCalculations();

            controller.purchaseOrder.Number_of_Systems__c = 1000;
            controller.validateSystemsCalculations();


            controller.selectedModuleTypeIdentifier = controller.configurators.values()[0].Id;
            controller.validateSystemsCalculations();

            controller.purchaseOrder.Racking_Opt_out__c = TRUE;
            controller.calculateRacking();

            controller.orderLines = new List<Purchase_Order_Line__c>();
            controller.orderLines.add(new Purchase_Order_Line__c(Item_Id__c='test003',Quantity__c = 0));
            controller.validateSystemsCalculations();

            controller.purchaseOrder.Order_Type__c = 'Storage Bundle';
            controller.validateSystemsCalculations();
            //set mock
            Test.setMock(HttpCalloutMock.class, new CashOrdersNegativeResponse());
            controller.doCallout();

            try {
                controller.savePDF();
            } catch(Exception e) {
                System.debug('pdf error');
            }

            PageReference ref = Page.OrderConfiguration;
            Test.setCurrentPage(ref);
            ApexPages.currentPage().getParameters().put('selectedTemplateId','a7J220000008dk5');
            try {
                controller.applyTemplate();
            } catch(Exception e) {

            }

            Test.stopTest();

        }
    }

    public static testMethod void testGetAvailableTemplates(){
        Account testPartner = TestClassFactory.CreateDealer('dealerName', 'North America');

        Bill_to_Site__c b = new Bill_to_Site__c();
        b.Dealer_Account__c = testPartner.Id;
        b.Address1__c = testPartner.BillingStreet;
        b.City__c = testPartner.BillingCity;
        b.State__c = testPartner.BillingState;
        b.Zip__c = testPartner.BillingPostalCode;
        b.Country__c = testPartner.BillingCountry;
        b.Oracle_County__c = testPartner.Oracle_County__c;
        b.Oracle_Operating_Unit_Code__c = 'SPNA OU';
        insert b;

        Ship_to_Site__c s = new Ship_to_Site__c();
        s.Dealer_Account__c = testPartner.Id;
        s.Address1__c = testPartner.BillingStreet;
        s.City__c = testPartner.BillingCity;
        s.State__c = testPartner.BillingState;
        s.Zip__c = testPartner.BillingPostalCode;
        s.Country__c = testPartner.BillingCountry;
        s.Oracle_County__c = testPartner.Oracle_County__c;
        s.SiteID__c = '99999999';
        s.Status__c = 'Active';
        insert s;

        Contact partnerContact = TestClassFactory.testContact('lastName', 'testpartnercon@noemail.com', TestClassFactory.retrieveRecordTypeID('Contact', 'Partner'));
        partnerContact.AccountId = testPartner.Id;
        partnerContact.Authorized_To_Order__c = TRUE;
        insert partnerContact;

        UserRole role = [SELECT Id FROM UserRole WHERE Name LIKE '%Partner Executive' LIMIT 1];

        Id execProfileId = SFDCSpecialUtilities.getProfileIdByName('Partner Executive');
        Price_List__c priceList = TestClassFactory.createPriceList();
        User currentUser = new User(alias = 'cashman1', email = partnerContact.Email,
                          emailencodingkey='UTF-8', lastname='Testing',
                          languagelocalekey='en_US', localesidkey='en_US',
                          profileid = execProfileId,  country='United States',
                          communityNickName = 'cashman1', timezonesidkey='America/Los_Angeles',
                          username=string.valueOf(math.random())+'u1@testorg.com',
                          contactId=partnerContact.Id, UserRole = role);


        System.runAs(currentUser)  {
            Test.startTest();

            ApexPages.StandardController sc = new ApexPages.StandardController(new Purchase_Order__c());
            OrderAppController controller = new OrderAppController(sc);

            PageReference pageRef = Page.OrderTypeSelection;
            Test.setCurrentPage(pageRef);

            controller.purchaseOrder.Dealer_Account__c = null;
            controller.purchaseOrder.Bill_to_Site__c = null;
            controller.shipContact = [SELECT Id, Name, Phone FROM Contact WHERE Id =: currentUser.ContactId];
            controller.sts = s;
            controller.purchaseOrder.Ship_to_Site__c = s.Id;
            controller.purchaseOrder.Order_Type__c = 'Single System';

            Order_Template__c testTemplate = createOrderTemplateWithAccount(testPartner.Id);
            testTemplate.Module_Configuration__c = [SELECT Id FROM Module_Configuration__c WHERE Name = 'Test Panel' LIMIT 1].Id;
            insert testTemplate;

            List<Order_Template_Line__c> orderLines = new List<Order_Template_Line__c>();
            for(ModuleInverterJunction__c j : [SELECT Inverter_Configuration__c
                                               FROM ModuleInverterJunction__c
                                               WHERE Module_Configuration__c =: testTemplate.Module_Configuration__c
                                               AND Inverter_Configuration__r.Inverter_Manufacturer__c =: 'SMA']) {
                Order_Template_Line__c line = new Order_Template_Line__c();
                line.Order_Template__c = testTemplate.Id;
                line.Quantity__c = 1;
                line.Inverter_Configuration__c = j.Inverter_Configuration__c;
                orderLines.add(line);
            }
            insert orderLines;

            controller.getAvailableTemplates();

            controller.purchaseOrder.Order_Type__c = 'Multi-System';

            controller.getAvailableTemplates();
            try {
                controller.Previous();
            } catch(Exception e) { }
            try {
                controller.Next();
            } catch(Exception e) { }

            ApexPages.currentPage().getParameters().put('selectedTemplateId',testTemplate.Id);
            controller.applyTemplate();

            controller.template.Name = 'Test2';
            controller.template.Short_Description__c = 'Test2';
            controller.saveTemplate();

            Test.stopTest();
        }
    }

    public static testMethod void testApplyTemplateBlank(){
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(new Purchase_Order__c());
        OrderAppController controller = new OrderAppController(sc);
        PageReference pageRef = Page.OrderTypeSelection;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('selectedTemplateId','');
        controller.applyTemplate();
        Test.stopTest();
    }

    public static Order_Template__c createOrderTemplateWithAccount(Id accountId){
        System.debug('TestClassFactory: Order Template Account Id: ' + accountId);
        Order_Template__c orderTemplate = new Order_Template__c();
        orderTemplate.Name = 'TestTemplate1';
        if(String.isNotBlank(accountId))
           orderTemplate.Account__c = accountId;
        orderTemplate.Number_of_Systems__c = 20;
        orderTemplate.Module_Quantity__c = 20;
        orderTemplate.Racking_Opt_Out__c = false;
        orderTemplate.Monitoring_Opt_Out__c = false;
        orderTemplate.Inverter_Manufacturer__c = 'SMA';
        orderTemplate.Racking_Type__c = 'Invisimount';
        orderTemplate.Active__c = true;

        return orderTemplate;
    }

    global class CashOrdersMockResponse implements HttpCalloutMock {
        //String responseString = '{"pricing_order_response":{"sales_order":{"order_header":{"qp_api_start_date":"17-FEB-2016 13:53:14","order_total":"9729","smart_pack_flag":"","cust_account_number":"6424","custom_api_end_date":"17-FEB-2016 13:53:14","custom_api_start_date":"17-FEB-2016 13:53:14","ship_to_state_code":"AZ","sales_type":"PURCHASE","system_count":"1","channel_type":"RVAR","country":"US","monitoring_opt_out":"N","qp_api_end_date":"17-FEB-2016 13:53:14","racking_opt_out":"N","order_source":"","inverter_type":""},"status":"S","order_lines":{"order_line":[{"product_line_type":"Bundle","adjusted_unit_price":"0","internal_unit_price":"","internal_adj_unit_price":"","ordered_quantity":"1","category_id":"","pv_flag":"","item_description":"PACKAGED SYSTEMS","ordered_item":"102868","unit_price":"9729","internal_extended_price":"","extended_price":"9729"},{"product_line_type":"Bundle","adjusted_unit_price":"0","internal_unit_price":"","internal_adj_unit_price":"","ordered_quantity":"1","category_id":"","pv_flag":"","item_description":"MONITORING SYSTEM, RESIDENTIAL, OUTDOOR, PVS5 BASED, 240VAC, US","ordered_item":"test002","unit_price":"0","internal_extended_price":"","extended_price":"0"},{"product_line_type":"Bundle","adjusted_unit_price":"0","internal_unit_price":"","internal_adj_unit_price":"","ordered_quantity":"3","category_id":"","pv_flag":"","item_description":"KIT, BULK, INVISIMOUNT RACKING, 2KW","ordered_item":"invTest01","unit_price":"0","internal_extended_price":"","extended_price":"0"},{"product_line_type":"Bundle","adjusted_unit_price":"0","internal_unit_price":"786.6","internal_adj_unit_price":"648.6","ordered_quantity":"15","category_id":"","pv_flag":"","item_description":"PVM, SPR-X21-345-C-AC, U AR-S1 M5 B1","ordered_item":"test001","unit_price":"0","internal_extended_price":"9729","extended_price":"0"}]},"status_message":"--Routine: QP_PREQ_PUB.PRICE_REQUEST SUCCESS"}}}';

        // Implement this interface method
        global HTTPResponse respond(HTTPRequest req) {

            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(responseString);
            res.setStatusCode(200);
            return res;
        }
    }

    global class CashOrdersNegativeResponse implements HttpCalloutMock {

        // Implement this interface method
        global HTTPResponse respond(HTTPRequest req) {

            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"foo":"bar"}');
            res.setStatusCode(500);
            res.setStatus('500 Unauthorized');
            return res;
        }
    }
}