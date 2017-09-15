@isTest
global class EMEAAlaCarteController_Test {
    

    @TestSetup
    public static void testDataSetup() {
        TestClassFactory.createAndInsertLeaseAgreementSettings();
        Lease_2_1_PO_Creation__c settings = new Lease_2_1_PO_Creation__c(name='Lease_2_1_Bypass',Lease_2_1_Test_Method_Bypass__c=true);
        insert settings;
        TestClassFactory.createModuleInverterRatios();
    }
    
    public static testMethod void testEMEAAlaCarteController() {        
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
            EMEAAlaCarteController controller = new EMEAAlaCarteController(sc);
            
            PageReference pageRef = Page.EMEAAlaCartePage;
            Test.setCurrentPage(pageRef);
            
            controller.callComponent1ControllerMethod();
            
            system.assertEquals(null, controller.setAlaCarteOrderItems());
            
            EMEAAlaCarteController.getOpportunities();
            EMEAAlaCarteController.getShippingContacts();
            EMEAAlaCarteController.getDealerWarehouses(testPartner.Id);
            
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
            controller.initModules();
            
            controller.purchaseOrder.Module_Quantity__c = 40;
            controller.orderLines.add(new Purchase_Order_Line__c(Item_Id__c='test003',Quantity__c = 1));

            Test.startTest();
            
            system.assertEquals(Page.EMEAOrderOpportunitySelection.getURL(), controller.ToOpportunitySelect().getURL());
            system.assertEquals(Page.EMEAOrderShipping.getURL(), controller.ToShipping().getURL());
            system.assertEquals(Page.order_details.getURL(), controller.ToOrderType().getURL());
            system.assertEquals(Page.EMEAOrderShipping.getURL(), controller.ToShipping().getURL());
            system.assertEquals(Page.EMEAAlaCartePage.getURL(), controller.ToSystemsConfig().getURL());
            
        
            controller.purchaseOrder.Order_Type__c = 'Ala Carte';
            controller.sts = new Ship_To_Site__c(State__c = 'CO');                                                         
            //set mock

            controller.buildRepsonseList('{"pricing_order_response": {"sales_order": {"order_header": {"qp_api_start_date": "06-SEP-2016 19:30:46", "order_total": "2190.9", "smart_pack_flag": "", "cust_account_number": "18112", "custom_api_end_date": "06-SEP-2016 19:30:46", "custom_api_start_date": "06-SEP-2016 19:30:46", "ship_to_state_code": "", "sales_type": "PURCHASE", "system_count": "0", "channel_type": "RVAR", "monitoring_opt_out": "Y", "discount_percent": "", "country": "DE", "qp_api_end_date": "06-SEP-2016 19:30:46", "racking_opt_out": "Y", "order_source": "", "inverter_type": "", "currency_code": "EUR"}, "status": "S", "order_lines": {"order_line": {"product_line_type": "A La Carte", "adjusted_unit_price": "219.09", "internal_adj_unit_price": "219.09", "extended_list_price": "3171.9", "category_id": "", "item_description": "PVM, SPR-E20-327, I AR-S6 M3 B1 MC4", "unit_price": "317.19", "discount_percent": "30.93", "internal_unit_price": "317.19", "ordered_quantity": "10", "pv_flag": "", "ordered_item": "517741", "extended_price": "2190.9", "internal_extended_price": "2190.9"} }, "status_message": "--Routine: QP_PREQ_PUB.PRICE_REQUEST SUCCESS"} } }');
            controller.setCRDDates('{"query_order_response": {"exception_dates": ["2016-11-01", "2016-12-08", "2016-12-26"], "status": "S", "lead_time": "4", "status_message": "", "earliest_crd_date": "2016-09-12"} }');  
            controller.purchaseOrder.Name = String.valueOf(Math.random());
            controller.purchaseOrder.Requested_Delivery_Date__c = Date.today().addDays(30);
            controller.crd = '01/01/2016';       
            controller.saveFromShipping(); 
            

            controller.buildRepsonseList('{"pricing_order_response":{"sales_order":{"order_header":{"qp_api_start_date":"23-SEP-201608:58:25","order_total":"3171.9","smart_pack_flag":"","cust_account_number":"18112","custom_api_end_date":"23-SEP-201608:58:25","custom_api_start_date":"23-SEP-201608:58:25","ship_to_state_code":"","sales_type":"PURCHASE","system_count":"0","channel_type":"RVAR","monitoring_opt_out":"Y","discount_percent":"","country":"DE","qp_api_end_date":"23-SEP-201608:58:25","racking_opt_out":"Y","order_source":"","inverter_type":"","currency_code":"EUR"},"status":"S","order_lines":{"order_line":{"product_line_type":"ALaCarte","adjusted_unit_price":"317.19","internal_adj_unit_price":"317.19","extended_list_price":"3237.3","category_id":"","item_description":"PVM,SPR-E20-327,IAR-S6M3B1MC4","unit_price":"323.73","discount_percent":"2.02","internal_unit_price":"323.73","ordered_quantity":"10","pv_flag":"","ordered_item":"517741","extended_price":"3171.9","internal_extended_price":"3171.9"}},"status_message":"--Routine:QP_PREQ_PUB.PRICE_REQUESTSUCCESS"}}}');    
            controller.saveFromOrderConfig();
            


      
            controller.purchaseOrder.Accept_Terms__c = TRUE;
            controller.submitOrder();
            
                                
            ApexPages.currentPage().getParameters().put('POID', controller.purchaseOrder.Id);

            Test.setMock(HttpCalloutMock.class, new CashOrdersMockResponse());
            controller.doCallout();            
            Test.setMock(HttpCalloutMock.class, new CRDMockResponse());
            controller.doCRDCallout();
            controller.doDocGenCallout();
            
            sc = new ApexPages.StandardController(new Purchase_Order__c());
            controller = new EMEAAlaCarteController(sc);
            
            Test.stopTest();
        }
        
    }
  
    public static testMethod void testEMEAAlaCarteControllerWithOpp() {
        Id oppRecTypeId = SFDCSpecialUtilities.getRecordTypeIdsByDeveloperName(Opportunity.sObjectType).get('Home_Owner');
        Opportunity testOpp = TestClassFactory.testOpportunity('TestOpp', '01 – Prospecting', Date.newInstance(2099, 01, 01), oppRecTypeId);
        
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
        insert s;
        
        Contact partnerContact = TestClassFactory.testContact('lastName', 'testpartnercon@noemail.com', TestClassFactory.retrieveRecordTypeID('Contact', 'Partner'));
        partnerContact.AccountId = testPartner.Id;
        partnerContact.Authorized_To_Order__c = TRUE;
        insert partnerContact;

        testOpp.Partner_Account_Id__c = testPartner.Id;        
        testOpp.Primary_Contact__c = partnerContact.Id;
        insert testOpp;
        
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
            EMEAAlaCarteController controller = new EMEAAlaCarteController(sc);
            
            PageReference pageRef = Page.EMEAAlaCartePage;                        
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('POID', controller.purchaseOrder.Id);
            
            controller.callComponent1ControllerMethod();
            
            system.assertEquals(null, controller.setAlaCarteOrderItems());
            
            EMEAAlaCarteController.getOpportunities();
            EMEAAlaCarteController.getShippingContacts();
            EMEAAlaCarteController.getDealerWarehouses(testPartner.Id);
            
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
            controller.purchaseOrder.Opportunity__c = testOpp.Id;                      
            
            controller.purchaseOrder.Module_Quantity__c = 40;
            controller.orderLines.add(new Purchase_Order_Line__c(Item_Id__c='test003',Quantity__c = 1));

            Test.startTest();
            
            system.assertEquals(Page.EMEAOrderOpportunitySelection.getURL(), controller.ToOpportunitySelect().getURL());
            system.assertEquals(Page.EMEAOrderShipping.getURL(), controller.ToShipping().getURL());
            system.assertEquals(Page.order_details.getURL(), controller.ToOrderType().getURL());
            system.assertEquals(Page.EMEAOrderShipping.getURL(), controller.ToShipping().getURL());
            system.assertEquals(Page.EMEAAlaCartePage.getURL(), controller.ToSystemsConfig().getURL());
            
            controller.purchaseOrder.Order_Type__c = 'Ala Carte';
            controller.sts = new Ship_To_Site__c(State__c = 'CO');            
            
            //set mock
            Test.setMock(HttpCalloutMock.class, new CashOrdersMockResponse());
            controller.doCallout();
            controller.saveFromOrderConfig();
            controller.saveFromShipping();
            
            controller.purchaseOrder.Accept_Terms__c = TRUE;
            controller.submitOrder();         
            
            PageReference pageRef2 = Page.EMEAOrderShipping;
            Test.setCurrentPage(pageRef2);
            
            Test.stopTest();
        }
        
    }
  
    public static testMethod void testEMEAAlaCarteControllerNegatives() {
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
            EMEAAlaCarteController controller = new EMEAAlaCarteController(sc);
            
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
            
            //set mock
            Test.setMock(HttpCalloutMock.class, new CashOrdersNegativeResponse());
            controller.doCallout();
            
            try {
                controller.savePDF();
            } catch(Exception e) {
                System.debug('pdf error');
            }
            
            Test.stopTest();
            
        }
    }
    
    global class CashOrdersMockResponse implements HttpCalloutMock {
        String responseString = '{"pricing_order_response": {"sales_order": {"order_header": {"qp_api_start_date": "06-SEP-2016 19:30:46", "order_total": "2190.9", "smart_pack_flag": "", "cust_account_number": "18112", "custom_api_end_date": "06-SEP-2016 19:30:46", "custom_api_start_date": "06-SEP-2016 19:30:46", "ship_to_state_code": "", "sales_type": "PURCHASE", "system_count": "0", "channel_type": "RVAR", "monitoring_opt_out": "Y", "discount_percent": "", "country": "DE", "qp_api_end_date": "06-SEP-2016 19:30:46", "racking_opt_out": "Y", "order_source": "", "inverter_type": "", "currency_code": "EUR"}, "status": "S", "order_lines": {"order_line": {"product_line_type": "A La Carte", "adjusted_unit_price": "219.09", "internal_adj_unit_price": "219.09", "extended_list_price": "3171.9", "category_id": "", "item_description": "PVM, SPR-E20-327, I AR-S6 M3 B1 MC4", "unit_price": "317.19", "discount_percent": "30.93", "internal_unit_price": "317.19", "ordered_quantity": "10", "pv_flag": "", "ordered_item": "517741", "extended_price": "2190.9", "internal_extended_price": "2190.9"} }, "status_message": "--Routine: QP_PREQ_PUB.PRICE_REQUEST SUCCESS"} } }';
        
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
    global class CRDMockResponse implements HttpCalloutMock {
        String responseString = '{"query_order_response": {"exception_dates": ["2016-11-01", "2016-12-08", "2016-12-26"], "status": "S", "lead_time": "4", "status_message": "", "earliest_crd_date": "2016-09-12"} }';
        
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
}