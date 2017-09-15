@IsTest
public with sharing class LeaseOrderWizardControllerInternal_Test {
	


	private static TestMethod void testConstructor1() {
        
        // create installer account
        Account installer = TestFactory_StandardObjects.getInstallerAccount();
        // create installer contact
        Contact shipToContact = TestFactory_StandardObjects.createPartnerContact(installer.Id);
        insert shipToContact;
        // create account contact role for ship to contact
        AccountContactRole acr = TestFactory_StandardObjects.createAccountContactRole();
        acr.AccountId = installer.Id;
        acr.ContactId = shipToContact.Id;
        acr.IsPrimary = true;
        acr.Role = 'Shipping Contact';
        insert acr;
        
        Bill_To_Site__c bts = TestFactory_Ordering.createBillToSite(installer.Id);
		insert bts;

		Ship_To_Site__c sts = TestFactory_Ordering.createDealerWarehouseShipToSite(bts.Dealer_Account__c);
		insert sts;

		Opportunity o = TestFactory_StandardObjects.createHomeOwnerOpportunity(null, bts.Dealer_Account__c);
		insert o;

        // setup PO
        insert new Lease_2_1_PO_Creation__c(Name='Lease_2_1_Bypass', Lease_2_1_Test_Method_Bypass__c = true);

		Purchase_Order__c order = TestFactory_Ordering.createPurchaseOrder();
		order.Opportunity__c = o.Id;
		order.Bill_To_Site__c = bts.Id;
		order.Ship_To_Site__c = sts.Id;
		order.Dealer_Account__c = bts.Dealer_Account__c;
        order.Ship_To_Contact__c = shipToContact.Id;
        order.End_Customer_Account__c = o.AccountId;
        order.Requested_Delivery_Date__c = Date.today().addDays(10);
		insert order;
        
        Item__c item = TestFactory_Configurations.getItem();
        Purchase_Order_Line__c poLine = TestFactory_Ordering.createPurchaseOrderLine();
        poLine.Purchase_Order__c = order.Id;
        poLine.Oracle_Item_ID__c = item.Id;
        insert poLIne;

		Test.startTest();
		
        PageReference pr = Page.LeaseOrderWizardInternal;
		pr.getParameters().put('id',order.Id);
        Test.setCurrentPage(pr);
        ApexPages.StandardController stdctrl = new Apexpages.Standardcontroller( new Purchase_Order__c() );
        
        LeaseOrderWizardControllerInternal leaseController = new LeaseOrderWizardControllerInternal(stdctrl);

        leaseController.AddressTransformation(order);

		PageReference p2 = leaseController.switchTab();
        
        leaseController.Foxing();
        leaseController.updatePOrder(true, 'Submitted');        
        leaseController.calcDayDifference();
        leaseController.SavePOFinancierDummy();
        
        String s1 = leaseController.propShipingAddress;
        String s2 = leaseController.propBillingAddress;
        String s3 = leaseController.propInstShipingAddress;
        String s4 = leaseController.prop3MsgOnSubmit;
        String s5 = leaseController.prop4MsgOnSubmit;
        Boolean b1 = leaseController.showOrderConfirmation;
        Boolean b2 = leaseController.propFinancierChanged;
        Integer i1 = leaseController.propTabToDisplay;
        Integer i2 = leaseController.propGotoTab;
        List<Purchase_Order_Line__c> poLinesList = leaseController.propOrderedPOLList;
        User u = leaseController.propCurrentUser;
        
        
		Test.stopTest();
		
	}
}