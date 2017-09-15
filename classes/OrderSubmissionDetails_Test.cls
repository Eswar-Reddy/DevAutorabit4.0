@isTest
private class OrderSubmissionDetails_Test {

	static testMethod void testOrderSubmissionDetails() {
        TestClassFactory.createAndInsertLeaseAgreementSettings();
        Lease_2_1_PO_Creation__c settings = new Lease_2_1_PO_Creation__c(name='Lease_2_1_Bypass',Lease_2_1_Test_Method_Bypass__c=true);
        insert settings;

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
        s.SiteID__c = '';
        s.Status__c = '';
        insert s;

        Ship_to_Site__c s2 = new Ship_to_Site__c();
        s2.Dealer_Account__c = testPartner.Id;
        s2.Address1__c = testPartner.BillingStreet;
        s2.City__c = testPartner.BillingCity;
        s2.State__c = testPartner.BillingState;
        s2.Zip__c = testPartner.BillingPostalCode;
        s2.Country__c = testPartner.BillingCountry;
        s2.Oracle_County__c = testPartner.Oracle_County__c;
        s2.SiteID__c = '007';
        s2.Status__c = '';
        insert s2;

        Contact partnerContact = TestClassFactory.testContact('lastName', 'testcontactpartner@noemail.com', TestClassFactory.retrieveRecordTypeID('Contact', 'Partner'));
        partnerContact.AccountId = testPartner.Id;
        partnerContact.Authorized_To_Order__c = TRUE;
        insert partnerContact;

        createRunAsUser(testPartner.Id, partnerContact.Id);
        createRunAsUser2(testPartner.Id, partnerContact.Id);
        createRunAsUser3(testPartner.Id, partnerContact.Id);
        createRunAsUser4(testPartner.Id, partnerContact.Id);
        createRunAsUser5(testPartner.Id, partnerContact.Id);
        testShippingSite(s.Id);
        testDuplicateShippingSite(s.Id);
    }

    static testMethod void sendNewShipToSite() {
        Ship_to_Site__c sts = new Ship_to_Site__c();
        sts.Dealer_Account__c = TestClassFactory.getFakeId(Account.SObjectType);
        sts.Address1__c = '1122 Boggie Boogie Ave';
        sts.City__c = 'City';
        sts.State__c = 'State';
        sts.Zip__c = '12234';
        sts.Country__c = 'Country';
        sts.Oracle_County__c = 'County';
        sts.SiteID__c = '';
        sts.Status__c = '';

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ShipToSiteMockResponse());
        OracleOrderService.saveShippingSiteToOracle(sts, '1187', 'PURCHASE', 'COMBO');
        Test.stopTest();
    }

    static testMethod void sendNewShipToSiteFailure() {
        // test will fail due to uncommited changes

        Account testPartner = TestClassFactory.CreateDealer('dealerName', 'North America');

        Ship_to_Site__c sts = new Ship_to_Site__c();
        sts.Dealer_Account__c = testPartner.Id;
        sts.Address1__c = testPartner.BillingStreet;
        sts.City__c = testPartner.BillingCity;
        sts.State__c = testPartner.BillingState;
        sts.Zip__c = testPartner.BillingPostalCode;
        sts.Country__c = testPartner.BillingCountry;
        sts.Oracle_County__c = testPartner.Oracle_County__c;
        sts.SiteID__c = '';
        sts.Status__c = '';
        insert sts;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ShipToSiteMockResponse());
        OracleOrderService.saveShippingSiteToOracle(sts, '1187', 'PURCHASE', 'COMBO');
        Test.stopTest();
    }

    static testMethod void sendNewOrder() {
        OracleOrderUtility.InformaticaCreateOrderRequest ord = new OracleOrderUtility.InformaticaCreateOrderRequest();
        ord.process_order_request.sales_order_collection.sales_order.sales_order_header.crm_id = 'po.Id';
        ord.process_order_request.sales_order_collection.sales_order.sales_order_header.psr_email_id = 'po.Primary_PSR_Email__c';
        ord.process_order_request.sales_order_collection.sales_order.sales_order_header.cust_acct_number = 'po.Dealer_Account__r.Oracle_Account_Number__c';
        ord.process_order_request.sales_order_collection.sales_order.sales_order_header.bill_to_site_id = 'po.Bill_to_Site__r.Site_ID__c';
        ord.process_order_request.sales_order_collection.sales_order.sales_order_header.ship_to_site_id = 'po.Ship_to_Site__r.SiteID__c';
        ord.process_order_request.sales_order_collection.sales_order.sales_order_header.ship_to_contact_id = 'po.Ship_To_Contact__r.Oracle_Contact_id__c';
        ord.process_order_request.sales_order_collection.sales_order.sales_order_header.operation = 'CREATE';
        ord.process_order_request.sales_order_collection.sales_order.sales_order_header.sales_type = 'PURCHASE';
        ord.process_order_request.sales_order_collection.sales_order.sales_order_header.channel_type = 'COMBO';
        ord.process_order_request.sales_order_collection.sales_order.sales_order_header.cust_po_number = 'po.Name';
        ord.process_order_request.sales_order_collection.sales_order.sales_order_header.request_date = 'String.valueOf(po.Requested_Delivery_Date__c)';
        ord.process_order_request.sales_order_collection.sales_order.sales_order_header.special_instructions = 'po.Special_Instructions__c';

        OracleOrderUtility.InformaticaOrderLines line = new OracleOrderUtility.InformaticaOrderLines();
        line.sales_order_line.operation = 'CREATE';
        line.sales_order_line.crm_id = 'po.Id';
        line.sales_order_line.order_line_type = 'poLine.Oracle_Line_Type__c';
        line.sales_order_line.product_type = 'po.Order_Type__c';
        line.sales_order_line.request_date = 'String.valueOf(po.Requested_Delivery_Date__c)';
        line.sales_order_line.inventory_item_id = 'poLine.Oracle_Item_ID__c';
        line.sales_order_line.line_number = 'poLine.Order_Line_Number__c';
        line.sales_order_line.ordered_quantity = 'String.valueOf(poLine.Quantity__c)';

        ord.process_order_request.sales_order_collection.sales_order.sales_order_lines.add(line);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CreateOrderMockResponse());
        OracleOrderService.saveOrderToOracle(ord, 'a0xe0000002c7T6AAI');
        Test.stopTest();
    }

    static testMethod void sendNewOrderFailure() {
        // test will fail due to uncommited changes
        Account testPartner = TestClassFactory.CreateDealer('dealerName', 'North America');

        Ship_to_Site__c sts = new Ship_to_Site__c();
        sts.Dealer_Account__c = testPartner.Id;
        sts.Address1__c = testPartner.BillingStreet;
        sts.City__c = testPartner.BillingCity;
        sts.State__c = testPartner.BillingState;
        sts.Zip__c = testPartner.BillingPostalCode;
        sts.Country__c = testPartner.BillingCountry;
        sts.Oracle_County__c = testPartner.Oracle_County__c;
        sts.SiteID__c = '';
        sts.Status__c = '';
        insert sts;

        OracleOrderUtility.InformaticaCreateOrderRequest ord = new OracleOrderUtility.InformaticaCreateOrderRequest();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CreateOrderMockResponse());
        OracleOrderService.saveOrderToOracle(ord, 'a0xe0000002c7T6AAI');
        Test.stopTest();
    }

    @future
    private static void createRunAsUser(Id testPartnerId, Id contactId) {
        Purchase_Order__c po = new Purchase_Order__c();
        UserManagement.IS_TEST = true;

        UserRole role = [SELECT Id FROM UserRole WHERE Name LIKE '%Partner Executive' LIMIT 1];

        Id execProfileId = SFDCSpecialUtilities.getProfileIdByName('Partner Executive');

        User currentUser = new User(alias = 'cashman1', email = 'testcontactpartner@noemail.com',
                          emailencodingkey='UTF-8', lastname='Testing',
                          firstname='Test', phone='5555551212', mobilephone='5555551212',
                          languagelocalekey='en_US', localesidkey='en_US',
                          profileid = execProfileId,  country='United States',
                          communityNickName = 'cashman1', timezonesidkey='America/Los_Angeles',
                          username=string.valueOf(math.random())+'u1@testorg.com',
                          contactId=contactId, UserRole = role);

        System.runAs(currentUser) {
            Bill_to_Site__c bts = [SELECT Id FROM Bill_to_Site__c WHERE Dealer_Account__c =: testPartnerId];
            Ship_to_Site__c sts = [SELECT Id FROM Ship_To_Site__c WHERE Dealer_Account__c =: testPartnerId AND SiteID__c = ''];

            po.Racking_Opt_Out__c = true;
            po.Order_Type__c = 'Ala Carte';
            po.Requested_Delivery_Date__c = Date.today();
            po.Name = 'test';
            po.Bill_to_Site__c = bts.id;
            po.Ship_to_Site__c = sts.id;
            po.Dealer_Account__c = testPartnerId;
            po.Accept_Terms__c = true;
            po.Ok_To_Ship__c = 'RELEASE';
            po.PO_Submit_Date__c = Date.today();
            po.PO_Submit_SP_WW__c = 1;
            po.Account_Territory__c = 'Other territory';
            po.Interface_Status__c = 'New';
            po.Ship_To_Contact__c = contactId;
            insert po;

            ApexPages.currentPage().getParameters().put('poID', po.id);
            ApexPages.StandardController sc = new ApexPages.StandardController(po);
            OrderSubmissionDetails controller = new OrderSubmissionDetails(sc);

            PageReference pageRef = Page.OrderSubmissionDetails;
            Test.setCurrentPage(pageRef);

            controller.orderLines = new List<Purchase_Order_Line__c>();
            Purchase_Order_Line__c line = new Purchase_Order_Line__c();
            line.Purchase_Order__c = po.Id;
            line.Item_ID__c = 'test003';
            line.Quantity__c = 5;
            insert line;
            controller.orderLines.add(line);

            string testString = controller.oppId + controller.opp;
            testString = controller.shipContactName;
            testString = controller.poName;
            testString = controller.OppName;

            List<Purchase_Order_Line__c> pol = controller.orderLines;

            ApexPages.StandardController sc2 = new ApexPages.StandardController(po);
            ApexPages.currentPage().getParameters().put('POID', po.Id);
            OrderAppController controller2 = new OrderAppController(sc2);
            PageReference pageRef2 = Page.OrderTypeSelection;
            Test.setCurrentPage(pageRef2);
        }

        po.Order_Status__c = 'Error';
        update po;

        ApexPages.currentPage().getParameters().put('poID', po.id);
        ApexPages.StandardController sc3 = new ApexPages.StandardController(po);
        OrderSubmissionDetails controller3 = new OrderSubmissionDetails(sc3);
        PageReference pageRef3 = controller3.psrSubmitOrder();
        Integer num = controller3.retries;
        String si = controller3.specialInstructions;

        po.Interface_Status__c = null;
        po.Order_Status__c = '';
        update po;
        ApexPages.StandardController sc4 = new ApexPages.StandardController(po);
        OrderSubmissionDetails controller4 = new OrderSubmissionDetails(sc4);
        PageReference pageRef4 = controller4.psrSubmitOrder();
    }

    @future
    private static void createRunAsUser2(Id testPartnerId, Id contactId) {
        Purchase_Order__c po = new Purchase_Order__c();
        UserManagement.IS_TEST = true;

        User currentUser;
        try {
            currentUser = [SELECT Id, ContactId, Contact.AccountId FROM User WHERE Alias = 'cashman1' AND Email = 'testcontactpartner@noemail.com'];
        } catch (Exception e) {
            return;
        }

        System.runAs(currentUser) {
            Bill_to_Site__c bts = [SELECT Id FROM Bill_to_Site__c WHERE Dealer_Account__c =: testPartnerId];
            Ship_to_Site__c sts = [SELECT Id FROM Ship_To_Site__c WHERE Dealer_Account__c =: testPartnerId AND SiteID__c = ''];

            po.Racking_Opt_Out__c = true;
            po.Order_Type__c = 'Ala Carte';
            po.Requested_Delivery_Date__c = Date.today();
            po.Name = 'test';
            po.Bill_to_Site__c = bts.id;
            po.Ship_to_Site__c = sts.id;
            po.Dealer_Account__c = testPartnerId;
            po.Accept_Terms__c = true;
            po.Ok_To_Ship__c = 'RELEASE';
            po.PO_Submit_Date__c = Date.today();
            po.PO_Submit_SP_WW__c = 1;
            po.Account_Territory__c = 'Other territory';
            po.Interface_Status__c = '';
            po.Ship_To_Contact__c = contactId;
            insert po;

            ApexPages.currentPage().getParameters().put('poID', po.id);
            ApexPages.StandardController sc = new ApexPages.StandardController(po);
            OrderSubmissionDetails controller = new OrderSubmissionDetails(sc);

            PageReference pageRef = Page.OrderSubmissionDetails;
            Test.setCurrentPage(pageRef);

            controller.orderLines = new List<Purchase_Order_Line__c>();
            Purchase_Order_Line__c line = new Purchase_Order_Line__c();
            line.Purchase_Order__c = po.Id;
            line.Item_ID__c = 'test004';
            line.Quantity__c = 15;
            insert line;
            controller.orderLines.add(line);

            string testString = controller.oppId + controller.opp;
            testString = controller.shipContactName;
            testString = controller.poName;
            testString = controller.OppName;

            List<Purchase_Order_Line__c> pol = controller.orderLines;

            ApexPages.StandardController sc2 = new ApexPages.StandardController(po);
            ApexPages.currentPage().getParameters().put('POID', po.Id);
            OrderAppController controller2 = new OrderAppController(sc2);
            PageReference pageRef2 = Page.OrderTypeSelection;
            Test.setCurrentPage(pageRef2);
        }
        ApexPages.currentPage().getParameters().put('poID', po.id);
        ApexPages.StandardController sc3 = new ApexPages.StandardController(po);
        OrderSubmissionDetails controller3 = new OrderSubmissionDetails(sc3);

        PageReference pageRef3 = controller3.init();
        PageReference pageRef4 = controller3.reSubmitOrder();

        ResultMessage result = new ResultMessage();
        result.success = true;
        result.message = '{"sales_order_response": {"status": "S", "status_message": "Successfully Processed", "sales_order_response_header": {"order_number": "12217702"}}}';
        PageReference pageRef5 = controller3.checkResult(result);

        result.message = '{"sales_order_response": {"status": "E", "status_message": "Successfully Processed", "sales_order_response_header": {"order_number": "12217702"}}}';
        pageRef5 = controller3.checkResult(result);

        result.message = '{"sales_order_response": {"status": "E", "status_message": "Successfully Processed", "sales_order_response_header": {"order_number": ""}}}';
        pageRef5 = controller3.checkResult(result);

        result.message = null;
        pageRef5 = controller3.checkResult(result);

        result.success = false;
        result.message = 'timeout';
        pageRef5 = controller3.checkResult(result);
    }

    @future
    private static void createRunAsUser3(Id testPartnerId, Id contactId) {
        Purchase_Order__c po = new Purchase_Order__c();
        UserManagement.IS_TEST = true;

        User currentUser;
        try {
            currentUser = [SELECT Id, ContactId, Contact.AccountId FROM User WHERE Alias = 'cashman1' AND Email = 'testcontactpartner@noemail.com'];
        } catch (Exception e) {
            return;
        }

        System.runAs(currentUser) {
            Bill_to_Site__c bts = [SELECT Id FROM Bill_to_Site__c WHERE Dealer_Account__c =: testPartnerId];
            Ship_to_Site__c sts = [SELECT Id FROM Ship_To_Site__c WHERE Dealer_Account__c =: testPartnerId AND SiteID__c = ''];

            po.Racking_Opt_Out__c = true;
            po.Order_Type__c = 'Ala Carte';
            po.Requested_Delivery_Date__c = Date.today();
            po.Name = 'test';
            po.Bill_to_Site__c = bts.id;
            po.Ship_to_Site__c = sts.id;
            po.Dealer_Account__c = testPartnerId;
            po.Accept_Terms__c = true;
            po.Ok_To_Ship__c = 'RELEASE';
            po.PO_Submit_Date__c = Date.today();
            po.PO_Submit_SP_WW__c = 1;
            po.Account_Territory__c = 'Other territory';
            po.Interface_Status__c = '';
            insert po;

            Purchase_Order_Line__c line = new Purchase_Order_Line__c();
            line.Purchase_Order__c = po.Id;
            line.Item_ID__c = 'test004';
            line.Quantity__c = 15;
            insert line;

            OracleOrderUtility.sendNewCashOrder(po.Id, '1187');
        }
    }

    @future
    private static void createRunAsUser4(Id testPartnerId, Id contactId) {
        Purchase_Order__c po = new Purchase_Order__c();
        UserManagement.IS_TEST = true;

        UserRole role = [SELECT Id FROM UserRole WHERE Name LIKE '%Partner Executive' LIMIT 1];

        Id execProfileId = SFDCSpecialUtilities.getProfileIdByName('Partner Executive');

        User currentUser;
        try {
            currentUser = [SELECT Id, ContactId, Contact.AccountId FROM User WHERE Alias = 'cashman1' AND Email = 'testcontactpartner@noemail.com'];
        } catch (Exception e) {
            return;
        }

        System.runAs(currentUser) {
            Bill_to_Site__c bts = [SELECT Id FROM Bill_to_Site__c WHERE Dealer_Account__c =: testPartnerId];
            Ship_to_Site__c sts = [SELECT Id FROM Ship_To_Site__c WHERE Dealer_Account__c =: testPartnerId AND SiteID__c = ''];

            po.Racking_Opt_Out__c = true;
            po.Order_Type__c = 'Ala Carte';
            po.Requested_Delivery_Date__c = Date.today();
            po.Name = 'test';
            po.Bill_to_Site__c = bts.id;
            po.Ship_to_Site__c = sts.id;
            po.Dealer_Account__c = testPartnerId;
            po.Accept_Terms__c = true;
            po.Ok_To_Ship__c = 'RELEASE';
            po.PO_Submit_Date__c = Date.today();
            po.PO_Submit_SP_WW__c = 1;
            po.Account_Territory__c = 'Other territory';
            po.Interface_Status__c = 'New';
            po.Ship_To_Contact__c = contactId;
            insert po;

            ApexPages.currentPage().getParameters().put('poID', po.id);
            ApexPages.StandardController sc = new ApexPages.StandardController(po);
            EMEAOrderSubmissionDetails controller = new EMEAOrderSubmissionDetails(sc);

            PageReference pageRef = Page.EMEAOrderSubmissionDetails;
            Test.setCurrentPage(pageRef);

            controller.orderLines = new List<Purchase_Order_Line__c>();
            Purchase_Order_Line__c line = new Purchase_Order_Line__c();
            line.Purchase_Order__c = po.Id;
            line.Item_ID__c = 'test003';
            line.Quantity__c = 5;
            insert line;
            controller.orderLines.add(line);

            string testString = controller.oppId + controller.opp;
            testString = controller.shipContactName;
            testString = controller.poName;
            testString = controller.OppName;

            List<Purchase_Order_Line__c> pol = controller.orderLines;

            ApexPages.StandardController sc2 = new ApexPages.StandardController(po);
            ApexPages.currentPage().getParameters().put('POID', po.Id);
            OrderAppController controller2 = new OrderAppController(sc2);
            PageReference pageRef2 = Page.OrderTypeSelection;
            Test.setCurrentPage(pageRef2);
        }

        po.Order_Status__c = 'Error';
        update po;

        ApexPages.currentPage().getParameters().put('poID', po.id);
        ApexPages.StandardController sc3 = new ApexPages.StandardController(po);
        EMEAOrderSubmissionDetails controller3 = new EMEAOrderSubmissionDetails(sc3);
        PageReference pageRef3 = controller3.psrSubmitOrder();
        Integer num = controller3.retries;
        po.Interface_Status__c = null;
        po.Order_Status__c = '';
        update po;
        ApexPages.StandardController sc4 = new ApexPages.StandardController(po);
        EMEAOrderSubmissionDetails controller4 = new EMEAOrderSubmissionDetails(sc4);
        PageReference pageRef4 = controller4.psrSubmitOrder();
    }

    @future
    private static void createRunAsUser5(Id testPartnerId, Id contactId) {
        Purchase_Order__c po = new Purchase_Order__c();
        UserManagement.IS_TEST = true;

        User currentUser;
        try {
            currentUser = [SELECT Id, ContactId, Contact.AccountId FROM User WHERE Alias = 'cashman1' AND Email = 'testcontactpartner@noemail.com'];
        } catch (Exception e) {
            return;
        }

        System.runAs(currentUser) {
            Bill_to_Site__c bts = [SELECT Id FROM Bill_to_Site__c WHERE Dealer_Account__c =: testPartnerId];
            Ship_to_Site__c sts = [SELECT Id FROM Ship_To_Site__c WHERE Dealer_Account__c =: testPartnerId AND SiteID__c = ''];

            po.Racking_Opt_Out__c = true;
            po.Order_Type__c = 'Ala Carte';
            po.Requested_Delivery_Date__c = Date.today();
            po.Name = 'test';
            po.Bill_to_Site__c = bts.id;
            po.Ship_to_Site__c = sts.id;
            po.Dealer_Account__c = testPartnerId;
            po.Accept_Terms__c = true;
            po.Ok_To_Ship__c = 'RELEASE';
            po.PO_Submit_Date__c = Date.today();
            po.PO_Submit_SP_WW__c = 1;
            po.Account_Territory__c = 'Other territory';
            po.Interface_Status__c = '';
            po.Ship_To_Contact__c = contactId;
            insert po;

            ApexPages.currentPage().getParameters().put('poID', po.id);
            ApexPages.StandardController sc = new ApexPages.StandardController(po);
            EMEAOrderSubmissionDetails controller = new EMEAOrderSubmissionDetails(sc);

            PageReference pageRef = Page.EMEAOrderSubmissionDetails;
            Test.setCurrentPage(pageRef);

            controller.orderLines = new List<Purchase_Order_Line__c>();
            Purchase_Order_Line__c line = new Purchase_Order_Line__c();
            line.Purchase_Order__c = po.Id;
            line.Item_ID__c = 'test004';
            line.Quantity__c = 15;
            insert line;
            controller.orderLines.add(line);

            string testString = controller.oppId + controller.opp;
            testString = controller.shipContactName;
            testString = controller.poName;
            testString = controller.OppName;

            List<Purchase_Order_Line__c> pol = controller.orderLines;

            ApexPages.StandardController sc2 = new ApexPages.StandardController(po);
            ApexPages.currentPage().getParameters().put('POID', po.Id);
            OrderAppController controller2 = new OrderAppController(sc2);
            PageReference pageRef2 = Page.OrderTypeSelection;
            Test.setCurrentPage(pageRef2);
        }
        ApexPages.currentPage().getParameters().put('poID', po.id);
        ApexPages.StandardController sc3 = new ApexPages.StandardController(po);
        EMEAOrderSubmissionDetails controller3 = new EMEAOrderSubmissionDetails(sc3);
    }

    @future
    private static void testShippingSite(Id stsId) {
        String responseString = '{"process_customer_response":{"ship_to_sites":{"ship_to_site":{"ou_code":"SPNA OU","cust_acct_site_error_message":":Created New site","cust_site_use_return_status":"S","cust_acct_site_id":"3274751","site_use_code":"SHIP_TO"}},"status":"S","status_message":":Created New site","customer":{"cust_account_id":"11058"}}}';

        OracleOrderUtility.checkNewShipToSite(responseString, stsId);
    }

    @future
    private static void testDuplicateShippingSite(Id stsId) {
        String responseString = '{"process_customer_response":{"ship_to_sites":{"ship_to_site":{"ou_code":"SPNA OU","cust_acct_site_error_message":":Created New site","cust_site_use_return_status":"S","cust_acct_site_id":"007","site_use_code":"SHIP_TO"}},"status":"S","status_message":":Created New site","customer":{"cust_account_id":"11058"}}}';

        OracleOrderUtility.checkNewShipToSite(responseString, stsId);
    }

    public class ShipToSiteMockResponse implements HttpCalloutMock {
        String responseString = '{"process_customer_response":{"ship_to_sites":{"ship_to_site":{"ou_code":"SPNA OU","cust_acct_site_error_message":":Created New site","cust_site_use_return_status":"S","cust_acct_site_id":"3274751","site_use_code":"SHIP_TO"}},"status":"S","status_message":":Created New site","customer":{"cust_account_id":"11058"}}}';

        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(responseString);
            res.setStatusCode(200);
            return res;
        }
    }

    public class CreateOrderMockResponse implements HttpCalloutMock {
        String responseString = '{"sales_order_response": {"status": "S", "status_message": "Successfully Processed", "sales_order_response_header": {"order_number": "12217702"}}}';

        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(responseString);
            res.setStatusCode(200);
            return res;
        }
    }
}