@isTest
private class TestBookedOrders {

	@isTest static void test_method_one() {
		// Implement test code
		// getOrders(String partnerId, String searchQuery)
        Test.setMock(HttpCalloutMock.class, new BookedOrdersNegitiveResponseGenerator());
        BookedOrders.getOrders('123', 'SELECT Id FROM sObject LIMIT 1');
        BookedOrders.getOrders('internal', 'SELECT Id FROM sOBject LIMIT 1');

		Test.setMock(HttpCalloutMock.class, new BookedOrdersResponseGenerator());

        Test.startTest();
        BookedOrders.getOrders('123', 'SELECT Id FROM sObject LIMIT 1');
        BookedOrders.getOrders('internal', 'SELECT Id FROM sOBject LIMIT 1');
        Test.stopTest();
	}

	@isTest static void test_method_two() {
		// Implement test code
		// updateOrders(String updateRequest, String sfAccountId)
        Test.setMock(HttpCalloutMock.class, new BookedOrdersNegitiveResponseGenerator());
        BookedOrders.updateOrders('updateRequest', 'sfAccountId');

		Test.setMock(HttpCalloutMock.class, new BookedOrdersResponseGenerator());
        Test.startTest();
        BookedOrders.updateOrders('updateRequest', 'sfAccountId');
        Test.stopTest();
	}

    @isTest static void test_method_three() {
		// Implement test code
		// getOrderDetails(String searchQuery)
        Test.setMock(HttpCalloutMock.class, new BookedOrdersNegitiveResponseGenerator());
        BookedOrders.getOrderDetails('searchQuery');

		Test.setMock(HttpCalloutMock.class, new BookedOrdersResponseGenerator());
        Test.startTest();
        BookedOrders.getOrderDetails('searchQuery');
        Test.stopTest();
	}

    @isTest static void test_method_four() {
		// Implement test code
		// updateAddress(String updateRequest, String sfAccountId)
        Test.setMock(HttpCalloutMock.class, new BookedOrdersNegitiveResponseGenerator());
        BookedOrders.updateAddress('updateRequest', 'sfAccountId');

		Test.setMock(HttpCalloutMock.class, new BookedOrdersResponseGenerator());
        Test.startTest();
        BookedOrders.updateAddress('updateRequest', 'sfAccountId');
        Test.stopTest();
	}

    @isTest static void test_method_five() {
        Test.startTest();
        BookedOrders.getPartnerInfo();
        Test.stopTest();
	}

    @isTest static void test_method_six() {
        Test.startTest();
        BookedOrders.getPartnerShipTo('sfAccountId', 'SPNA OU');
        Test.stopTest();
	}

    @isTest static void test_method_seven() {
        Test.startTest();
        BookedOrders.getCurrentShipTo('siteId');
        Test.stopTest();
	}

    @isTest static void test_method_eight() {
        Test.startTest();
        BookedOrders.getPartners();
        Test.stopTest();
	}

    @isTest static void test_method_nine() {
        Account dealer = TestClassFactory.CreateDealer('TestdealerName', 'North America');

        Test.startTest();
        BookedOrders.getSalesforceAccountId(dealer.Oracle_Account_Number__c);
        Test.stopTest();
	}

    @isTest static void test_method_ten() {
        Account dealer = TestClassFactory.CreateDealer('TestdealerName', 'North America');

        Ship_to_Site__c sts = new Ship_to_Site__c();
        sts.City__c = 'San Jose';
        sts.Country__c = 'United States';
        sts.Dealer_Account__c = dealer.Id;
        sts.SiteID__c = '123123';

        Ship_to_Site__c sts2 = new Ship_to_Site__c();
        sts2.Address1__c = '77 Rio Robles';
        sts2.City__c = 'San Jose';
        sts2.State__c = 'CA';
        sts2.Zip__c = '95134';
        sts2.Country__c = 'United States';
        sts2.Dealer_Account__c = dealer.Id;
        sts2.SiteID__c = '123123';

        Ship_to_Site__c sts3 = new Ship_to_Site__c();
        sts3.Address1__c = '77 Rio Robles';
        sts3.City__c = 'San Jose';
        sts3.State__c = 'CA';
        sts3.Zip__c = '95134';
        sts3.Country__c = 'United States';
        sts3.Dealer_Account__c = dealer.Id;
        sts3.Residential_Customer_Account__c = dealer.Id;
        sts3.SiteID__c = '123123';

        Test.startTest();
        BookedOrders.insertShipTo(JSON.serialize(sts));
        BookedOrders.insertShipTo(JSON.serialize(sts2));
        BookedOrders.insertShipTo(JSON.serialize(sts3));
        BookedOrders.checkSiteId(sts2.SiteID__c);
        Test.stopTest();
	}

    @isTest static void test_method_eleven() {
        BookedOrders b = new BookedOrders();
        ResultMessage r = new ResultMessage();
    }

    @isTest static void test_method_twelve() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BookedOrdersResponseGenerator());

        BookedOrders.getOrders('', 'SELECT Id FROM sObject LIMIT 1');
        BookedOrders.updateOrders('', 'INTERNAL');
        BookedOrders.getOrderDetails('');
        BookedOrders.updateAddress('', 'INTERNAL');

        ResultMessage message = BookedOrders.getOracleOperatingUnits();
        System.assertNotEquals(null, message);

        Test.stopTest();
    }

    @isTest static void test_method_thirteen() {
        Test.startTest();

        BookedOrders.getOrders('', 'SELECT Id FROM sObject LIMIT 1');
        BookedOrders.updateOrders('INTERNAL', '');
        BookedOrders.getOrderDetails('SELECT Id FROM sObject LIMIT 1');
        BookedOrders.updateAddress('updateRequest', 'INTERNAL');

        Test.stopTest();
    }

    @isTest static void test_method_fourteen() {
        Test.startTest();
        BookedOrders.getDealerAccountInfo('1863');
        Test.stopTest();
    }

    @isTest static void test_method_fifteen() {
        WR_ORACLE_SalesOrder__c so = new WR_ORACLE_SalesOrder__c();
        so.Sales_Order__c = '555';
        so.Packing_Slip__c = '1892';
        so.Oracle_Account_Number__c = '1863';
        insert so;

        BookedOrders.getFlashData('555');
        BookedOrders.getFlashData('556');

        WR_FDS_Product__c p = new WR_FDS_Product__c();
        p.WR_ORACLE_SalesOrder__c = so.Id;
        p.Flash_Test_Date__c = System.today();
        p.Alternate_Packing_Slip__c = '1896';
        p.Packing_Slip__c = '1892';
        p.Serial_Number__c = '123456';
        insert p;

        BookedOrders.getFlashData('555');

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BookedOrdersResponseGenerator());
        BookedOrders.downloadFlashTestDataDocGen(JSON.serialize(p));
        BookedOrders.downloadFlashTestDataDocGen('');
        Test.stopTest();
    }

    @isTest static void test_method_sixteen() {
        BookedOrders.getDeliveryServicesSelectOptions();
        BookedOrders.getDeliveryDetails('35987');
        BookedOrders.getDeliveryDetailsEMEA('35987');
        BookedOrders.updateDeliveryDetails('');

        Account dealer = TestClassFactory.CreateDealer('TestdealerName', 'North America');
        Ship_to_Site__c sts = new Ship_to_Site__c();
        sts.Dealer_Account__c = dealer.Id;
        sts.SiteID__c = '35987';
        sts.Status__c = 'Active';
        sts.State__c = 'CA';
        sts.Address1__c = '1122 Boggie Boggie Avenue';
        sts.City__c = 'My City';
        sts.Zip__c = '18956';
        insert sts;
        BookedOrders.updateDeliveryDetails(JSON.serialize(sts));

        Country_Reference__c cr = new Country_Reference__c();
        cr.Country__c = 'USA';
        cr.CountryCode__c = 'US';
        insert cr;
        BookedOrders.getCountryCodes();
    }
}