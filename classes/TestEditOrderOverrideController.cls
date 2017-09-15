@isTest
private class TestEditOrderOverrideController
{
    static Account partnerAccount;
    static Contact partnerContact;
    static User partnerUser;
    
    static void setupPartner()
    {
        partnerUser = TestUtils.createLeasePartnerInfo( );
    }
    
    static testMethod void testPartnerCashNewPurchaseOrder()
    {
        setupPartner();
        
        Purchase_Order__c testOrder = new Purchase_Order__c();
        testOrder.Name = 'Test Order';
        testOrder.Lease__c = false;
        testOrder.Order_Type__c = 'Test';
        testOrder.Order_Status__c = 'New';
        insert testOrder;
        
        Test.startTest();
        
        ApexPages.PageReference returnedPage;
        
        UserManagement.IS_TEST = TRUE;
        System.runAs( partnerUser )
        {
            ApexPages.StandardController stdController = new ApexPages.StandardController( testOrder );
            EditOrderOverrideController overrideController = new EditOrderOverrideController( stdController );
            
            returnedPage = overrideController.redirect();
        }
        
        Test.stopTest();
    }
    
    static testMethod void testPartnerUserWithPOLease()
    {
        setupPartner();
        
        Purchase_Order__c testOrder = new Purchase_Order__c();
        testOrder.Name = 'Test Order';
        testOrder.Lease__c = TRUE;
        insert testOrder;
        
        Test.startTest();
        
        ApexPages.PageReference returnedPage;
        
        UserManagement.IS_TEST = TRUE;
        System.runAs( partnerUser )
        {
            ApexPages.StandardController stdController = new ApexPages.StandardController( testOrder );
            EditOrderOverrideController overrideController = new EditOrderOverrideController( stdController );
            
            returnedPage = overrideController.redirect();
        }
        
        Test.stopTest();
    }
    
    static testMethod void testPartnerUserWithPurchaseOrder2()
    {
        setupPartner();
        
        Purchase_Order__c testOrder = new Purchase_Order__c();
        testOrder.Name = 'Test Order';
        testOrder.Lease__c = false;
        testOrder.Order_Type__c = 'Test';
        testOrder.Order_Status__c = 'Submitted';
        insert testOrder;
        
        Test.startTest();
        
        ApexPages.PageReference returnedPage;
        
        UserManagement.IS_TEST = TRUE;
        System.runAs( partnerUser )
        {
            ApexPages.StandardController stdController = new ApexPages.StandardController( testOrder );
            EditOrderOverrideController overrideController = new EditOrderOverrideController( stdController );
            
            returnedPage = overrideController.redirect();
        }
        
        Test.stopTest();
    }
    
    static testMethod void testPartnerUserWithPurchaseOrderEU()
    {
        setupPartner();
        
        Purchase_Order__c testOrder = new Purchase_Order__c();
        testOrder.Name = 'Test Order';
        testOrder.Lease__c = false;
        insert testOrder;
        
        Test.startTest();
        
        ApexPages.PageReference returnedPage;
        
        UserManagement.IS_TEST = TRUE;
        Profile p = [SELECT Id FROM Profile Where Name LIKE 'EU%' LIMIT 1];
        partnerUser.ProfileId = p.Id;
        System.runAs( partnerUser )
        {
            ApexPages.StandardController stdController = new ApexPages.StandardController( testOrder );
            EditOrderOverrideController overrideController = new EditOrderOverrideController( stdController );
            
            returnedPage = overrideController.redirect();
        }
        
        Test.stopTest();
    }
    
    static testMethod void testPartnerUserWithPurchaseOrderEU2()
    {
        setupPartner();
        
        Purchase_Order__c testOrder = new Purchase_Order__c();
        testOrder.Name = 'Test Order';
        testOrder.Lease__c = true;
        insert testOrder;
        
        Test.startTest();
        
        ApexPages.PageReference returnedPage;
        
        UserManagement.IS_TEST = TRUE;
        Profile p = [SELECT Id FROM Profile Where Name LIKE 'EU%' LIMIT 1];
        partnerUser.ProfileId = p.Id;
        System.runAs( partnerUser )
        {
            ApexPages.StandardController stdController = new ApexPages.StandardController( testOrder );
            EditOrderOverrideController overrideController = new EditOrderOverrideController( stdController );
            
            returnedPage = overrideController.redirect();
        }
        
        Test.stopTest();
    }
    
    static testMethod void testPartnerUserWithLeaseOrder()
    {
        setupPartner();
        
        Purchase_Order__c testOrder = new Purchase_Order__c();
        testOrder.Name = 'Test Order';
        testOrder.Lease__c = true;
        insert testOrder;
        
        Test.startTest();
        
        ApexPages.PageReference returnedPage;
        
        UserManagement.IS_TEST = TRUE;
        System.runAs( partnerUser )
        {
            ApexPages.StandardController stdController = new ApexPages.StandardController( testOrder );
            EditOrderOverrideController overrideController = new EditOrderOverrideController( stdController );
            
            returnedPage = overrideController.redirect();
        }
        
        Test.stopTest();
        
        System.assertNotEquals( null, returnedPage, 'A page should have been returned by the redirect' );
        System.assert( returnedPage.getURL().contains( Page.LeaseOrderWizard.getURL() ), 'The LeaseOrderWizard page should be returned if partner user visits a purchase order' );
        System.assertEquals( testOrder.Id, returnedPage.getParameters().get( EditOrderOverrideController.POID_KEY ), 'The referenced order should be the order targeted by the user' );
    }
    
    static testMethod void testInternalWithPurchaseOrder()
    {
        User testUser = TestUtils.createUser( 'Standard User', false );
        
        Purchase_Order__c testOrder = new Purchase_Order__c();
        testOrder.Name = 'Test Order';
        testOrder.Lease__c = false;
        testOrder.Order_Status__c = 'New';
        insert testOrder;
        
        Test.startTest();
        
        ApexPages.PageReference returnedPage;
        
        UserManagement.IS_TEST = TRUE;
        System.runAs( testUser )
        {
            ApexPages.currentPage().getParameters().put( 'id', testOrder.Id );
            
            ApexPages.StandardController stdController = new ApexPages.StandardController( testOrder );
            EditOrderOverrideController overrideController = new EditOrderOverrideController( stdController );
            
            returnedPage = overrideController.redirect();
        }
        
        Test.stopTest();
        
    }
    
    static testMethod void testInternalWithLeaseOrder()
    {
        User testUser = TestUtils.createUser( 'Standard User', false );
        
        Purchase_Order__c testOrder = new Purchase_Order__c();
        testOrder.Name = 'Test Order';
        testOrder.Lease__c = true;
        testOrder.Order_Status__c = 'New';
        insert testOrder;
        
        Test.startTest();
        
        ApexPages.PageReference returnedPage;
        
        UserManagement.IS_TEST = TRUE;
        System.runAs( testUser )
        {
            ApexPages.currentPage().getParameters().put( 'id', testOrder.Id );
            
            ApexPages.StandardController stdController = new ApexPages.StandardController( testOrder );
            EditOrderOverrideController overrideController = new EditOrderOverrideController( stdController );
            
            returnedPage = overrideController.redirect();
        }
        
        Test.stopTest();
        
    }
    
    static testMethod void testInternalWithCashNewPO()
    {
        User testUser = TestUtils.createUser( 'Standard User', false );
        
        Purchase_Order__c testOrder = new Purchase_Order__c();
        testOrder.Name = 'Test Order';
        testOrder.Lease__c = false;
        testOrder.Order_Type__c = 'Test';
        testOrder.Order_Status__c = 'New';
        insert testOrder;
        
        Test.startTest();
        
        ApexPages.PageReference returnedPage;
        
        UserManagement.IS_TEST = TRUE;
        System.runAs( testUser )
        {
            ApexPages.currentPage().getParameters().put( 'id', testOrder.Id );
            
            ApexPages.StandardController stdController = new ApexPages.StandardController( testOrder );
            EditOrderOverrideController overrideController = new EditOrderOverrideController( stdController );
            
            returnedPage = overrideController.redirect();
        }
        
        Test.stopTest();
        
    }
    
    static testMethod void testInternalWithCashNewPOSubmitted()
    {
        User testUser = TestUtils.createUser( 'Standard User', false );
        
        Purchase_Order__c testOrder = new Purchase_Order__c();
        testOrder.Name = 'Test Order';
        testOrder.Lease__c = false;
        testOrder.Order_Type__c = 'Test';
        testOrder.Order_Status__c = 'Submitted';
        insert testOrder;
        
        Test.startTest();
        
        ApexPages.PageReference returnedPage;
        
        UserManagement.IS_TEST = TRUE;
        System.runAs( testUser )
        {
            ApexPages.currentPage().getParameters().put( 'id', testOrder.Id );
            
            ApexPages.StandardController stdController = new ApexPages.StandardController( testOrder );
            EditOrderOverrideController overrideController = new EditOrderOverrideController( stdController );
            
            returnedPage = overrideController.redirect();
        }
        
        Test.stopTest();
        
    }
}