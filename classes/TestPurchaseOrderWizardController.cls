/* This test class for PurchaseOrderWizardController */
@isTest
private without sharing class TestPurchaseOrderWizardController {

@isTest
    public static void testNewPurchaseOrder1(){
        Account acct = getPartnerAccount();
        User u =getPartnerPortalUser(acct);
        acct = u.Contact.Account;
        System.runAs(u){
            Purchase_Order__c pur = new Purchase_Order__c();
            ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(pur);
            PurchaseOrderWizardController purControl = new PurchaseOrderWizardController(stdctrl);
            purControl.isUserAuthorized = true;
            // Get healthy Spring 2017 purControl.showStep2();
            //purControl.showNextPage();
            // Get healthy Spring 2017 purControl.moveOppsShowLink();
            // Get healthy Spring 2017 purControl.selectedCategory = 'BoS';
            // Get healthy Spring 2017 purControl.moveProductsShowLink();
            // Get healthy Spring 2017 purControl.showPage1byButton();
            // Get healthy Spring 2017 purControl.showPage2byButton();
            // Get healthy Spring 2017 purControl.showPage2byButton();
            // Get healthy Spring 2017 purControl.showPage2byButtonFrom3();
            // Get healthy Spring 2017 purControl.showPage3byButton();
            // Get healthy Spring 2017 purControl.showPage3byButtonFrom4();
            // Get healthy Spring 2017 purControl.showPage4byButtonFrom3();
            /*purControl.moveFirst();
            purControl.moveLast();
            purControl.moveNext();
            purControl.movePrevious();*/
            // Get healthy Spring 2017 purControl.moveAccordingToFilter();
            //purControl.setDealerAddressToShipToSite();
            //purControl.getItemsList();
            purControl.calcDayDifference();
            // Get healthy Spring 2017 purControl.getShippingMethods();
            // Get healthy Spring 2017 purControl.getCategories();
            // Get healthy Spring 2017 purControl.cancel();
            purControl.isEUUser = false;
        }
    }

    // Get healthy Spring 2017
    //@isTest
    //public static void testNewPurchaseOrder3(){
    //    Account acct = getPartnerAccount();
    //    User u =getPartnerPortalUser(acct);
    //    acct = u.Contact.Account;
    //    System.runAs(u){
    //        SunPower_Design__c sunDesign = getDesignObjectWithItems(acct);
    //        if(sunDesign == null) return;
    //        Purchase_Order__c pur = new Purchase_Order__c();
    //        Test.setCurrentPage(Page.PurchaseOrderWizard);
    //        ApexPages.currentPage().getParameters().put('DID',sunDesign.ID);
    //        ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(pur);
    //        PurchaseOrderWizardController purControl = new PurchaseOrderWizardController(stdctrl);
    //        //purControl.getItemsList();
    //        PurchaseOrderWizardController.PurchaseOrderLineItemWrapper pWrap = new PurchaseOrderWizardController.PurchaseOrderLineItemWrapper('','','','','',true,true);
    //        // Get healthy Spring 2017 purControl.delItemFromList();
    //        purControl.submitOrder();
    //        // Get healthy Spring 2017 purControl.getCategories();
    //    }
    //}

@isTest
    public static void testNewPurchaseOrder4(){
        Account acct = getPartnerAccount();
        User u =getPartnerPortalUser(acct);
        acct = u.Contact.Account;
        List<Price_List_Item__c> productList = createProductsList();
            Ship_to_Site__c shToSite = setDealerShippingSite(acct);
            Bill_to_Site__c billToSite = setDealerBillingSite(acct);
        Purchase_Order__c pur = new Purchase_Order__c();
        System.runAs(u){
            SunPower_Design__c sunDesign = getDesignObjectWithItems(acct);
            if(sunDesign == null) return;
            pur.Dealer_Account__c = acct.ID;
            //Ship_to_Site__c shToSite = setDealerShippingSite(acct);
            //Bill_to_Site__c billToSite = setDealerBillingSite(acct);
            pur.Ship_to_Site__c = shToSite.ID;
            pur.Ship_to_Site__r = shToSite;
            pur.Bill_to_Site__c = billToSite.ID;
            pur.Bill_to_Site__r = billToSite;
            pur.Name = 'testpo';
            pur.Order_Status__c = 'New';
            Opportunity opp = createOpp(acct,u);
            pur.Opportunity__c = opp.ID;
            pur.Opportunity__r = opp;
            pur.Requested_Delivery_Date__c = System.today();
            pur.Order_Wizard_Step__c  = 'step 1';
            pur.Sales_Type__c = 'Cash';

            insert pur;
            createPOLineItems(pur);
            Test.starttest();
            Test.setCurrentPage(Page.PurchaseOrderWizard);
            ApexPages.currentPage().getParameters().put('POID',pur.ID);

            ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(pur);
            PurchaseOrderWizardController purControl = new PurchaseOrderWizardController(stdctrl);
            // Get healthy Spring 2017 purControl.updatePOLineItems();
            // Get healthy Spring 2017 purControl.getProducts();
            //purControl.getItemsList();
            PurchaseOrderWizardController.PurchaseOrderLineItemWrapper pWrap = new PurchaseOrderWizardController.PurchaseOrderLineItemWrapper('','','','','',true,true);
            // Get healthy Spring 2017 purControl.delItemFromList();
            purControl.submitOrder();
            // Get healthy Spring 2017 purControl.showPage2byButton();
            PurchaseOrderWizardController.PurchaseOrderLineItemWrapper pwrap2 = new PurchaseOrderWizardController.PurchaseOrderLineItemWrapper('test','test','test','test','5.0','USD',5.0,5.0,true,true);
            PurchaseOrderWizardController.PurchaseOrderLineItemWrapper pwrap3 = new PurchaseOrderWizardController.PurchaseOrderLineItemWrapper();

            purControl.selProductItems = new List<PurchaseOrderWizardController.PurchaseOrderLineItemWrapper>();
            purControl.selProductItems.add(pWrap);
            purControl.selProductItems.add(pWrap2);
            purControl.selProductItems.add(pWrap3);
            // Get healthy Spring 2017 purControl.products = productList;

            // Get healthy Spring 2017 purControl.singleAddedprodId = purControl.products.get(0).ID;
            // Get healthy Spring 2017 purControl.addItemToList();
            purControl.selectedShipToSiteID = acct.ID;
            // Get healthy Spring 2017 purControl.setPOShipToSite();
            purControl.calcDayDifference();
            purControl.submitOrder();
            purControl.selectedCustomerOpportunity = opp.ID;
            // Get healthy Spring 2017 purControl.showStep2();
            Test.stoptest();
        }

        delete pur;
    }

    @isTest
    public static void testNewPurchaseOrder5(){
        Account acct = getPartnerAccount();
        User u =getPartnerPortalUser(acct);
        acct = u.Contact.Account;
        List<Price_List_Item__c> productList = createProductsList();
        Ship_to_Site__c shToSite = setDealerShippingSite(acct);
        Bill_to_Site__c billToSite = setDealerBillingSite(acct);
        System.runAs(u){
            SunPower_Design__c sunDesign = getDesignObjectWithItems(acct);
            if(sunDesign == null) return;
            Purchase_Order__c pur = new Purchase_Order__c();
            pur.Dealer_Account__c = acct.ID;
            //Ship_to_Site__c shToSite = setDealerShippingSite(acct);
            //Bill_to_Site__c billToSite = setDealerBillingSite(acct);
            pur.Ship_to_Site__c = shToSite.ID;
            pur.Ship_to_Site__r = shToSite;
            pur.Bill_to_Site__c = billToSite.ID;
            pur.Bill_to_Site__r = billToSite;
            pur.Name = 'testpo';
            Opportunity opp = createOpp(acct,u);
            pur.Opportunity__c = opp.ID;
            pur.Opportunity__r = opp;
            pur.Requested_Delivery_Date__c = System.today();
            pur.Special_Instructions__c = 'null';
            insert pur;
            createPOLineItems(pur);
            Test.starttest();
            Test.setCurrentPage(Page.PurchaseOrderWizard);
            ApexPages.currentPage().getParameters().put('DID',sunDesign.ID);
            ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(pur);
            PurchaseOrderWizardController purControl = new PurchaseOrderWizardController(stdctrl);
            //purControl.getItemsList();
            PurchaseOrderWizardController.PurchaseOrderLineItemWrapper pWrap = new PurchaseOrderWizardController.PurchaseOrderLineItemWrapper('','','','','',true,true);
            // Get healthy Spring 2017 purControl.delItemFromList();
            // Get healthy Spring 2017 purControl.submitOrder();
            // Get healthy Spring 2017 purControl.showPage2byButton();
            PurchaseOrderWizardController.PurchaseOrderLineItemWrapper pwrap2 = new PurchaseOrderWizardController.PurchaseOrderLineItemWrapper('test','test','test','test','5.0','USD',5.0,5.0,true,true);
            PurchaseOrderWizardController.PurchaseOrderLineItemWrapper pwrap3 = new PurchaseOrderWizardController.PurchaseOrderLineItemWrapper();

            purControl.selProductItems = new List<PurchaseOrderWizardController.PurchaseOrderLineItemWrapper>();
            purControl.selProductItems.add(pWrap);
            purControl.selProductItems.add(pWrap2);
            purControl.selProductItems.add(pWrap3);
            // Get healthy Spring 2017 purControl.products = productList;
            // Get healthy Spring 2017  purControl.singleAddedprodId = purControl.products.get(0).ID;
            // Get healthy Spring 2017 purControl.addItemToList();
            purControl.selectedShipToSiteID = acct.ID;
            // Get healthy Spring 2017 purControl.setPOShipToSite();
            purControl.calcDayDifference();
            String str = purControl.serviceCreditSMSItemId;
            str = purControl.formattedCustShippingAdd;
            Test.stoptest();
        }
    }

    @isTest
    public static void testDeletionOfProdWrapperFromList(){
        Account acct = getPartnerAccount();
        User u =getPartnerPortalUser(acct);
        acct = u.Contact.Account;
        if(acct.Oracle_Operating_Unit__c == null || acct.Oracle_Operating_Unit__c == ''){
            acct.Oracle_Operating_Unit__c = 'SPCN OU';
            update acct;
        }
        List<Price_List_Item__c> productList = createProductsList();
        Ship_to_Site__c shToSite = setDealerShippingSite(acct);
        Bill_to_Site__c billToSite = setDealerBillingSite(acct);
        System.runAs(u){
            SunPower_Design__c sunDesign = getDesignObjectWithItems(acct);
            if(sunDesign == null) return;
            Purchase_Order__c pur = new Purchase_Order__c();
            pur.Dealer_Account__c = acct.ID;
            //Ship_to_Site__c shToSite = setDealerShippingSite(acct);
            //Bill_to_Site__c billToSite = setDealerBillingSite(acct);
            pur.Ship_to_Site__c = shToSite.ID;
            pur.Ship_to_Site__r = shToSite;
            pur.Bill_to_Site__c = billToSite.ID;
            pur.Bill_to_Site__r = billToSite;
            pur.Name = 'testpo';
            Opportunity opp = createOpp(acct,u);
            pur.Opportunity__c = opp.ID;
            pur.Opportunity__r = opp;
            pur.Requested_Delivery_Date__c = System.today();
            pur.Order_Wizard_Step__c  = 'step 1';
            insert pur;
            createPOLineItems(pur);
            Test.starttest();
            Test.setCurrentPage(Page.PurchaseOrderWizard);
            ApexPages.currentPage().getParameters().put('DID',sunDesign.ID);
            ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(pur);
            PurchaseOrderWizardController purControl = new PurchaseOrderWizardController(stdctrl);

            // Get healthy Spring 2017 purControl.getProducts();
            //purControl.getItemsList();
            // Get healthy Spring 2017 purControl.products = productList;

            // Get healthy Spring 2017 purControl.changedQty =  purControl.products.get(1).ID+'~'+'5'+';';
            // Get healthy Spring 2017 purControl.singleAddedprodId = purControl.products.get(0).ID;
            // Get healthy Spring 2017 purControl.addItemToList();

            purControl.selProductItems = null;
            // Get healthy Spring 2017 purControl.singleAddedprodId = purControl.products.get(1).ID;
            // Get healthy Spring 2017 purControl.addItemToList();

            purControl.selProductItems = new List<PurchaseOrderWizardController.PurchaseOrderLineItemWrapper>();
            // Get healthy Spring 2017 PurchaseOrderWizardController.PurchaseOrderLineItemWrapper pWrapper = new PurchaseOrderWizardController.PurchaseOrderLineItemWrapper(purControl.products.get(3).ID,'test','test','test','5.0','USD',5.0,5.0,true,true);
            // Get healthy Spring 2017 PurchaseOrderWizardController.PurchaseOrderLineItemWrapper pWrapper1 = new PurchaseOrderWizardController.PurchaseOrderLineItemWrapper(purControl.products.get(3).ID,'test','test','test','5.0',true,true,'test','test','test');
            // Get healthy Spring 2017 purControl.selProductItems.add(pWrapper);
            // Get healthy Spring 2017 purControl.singleAddedprodId = purControl.products.get(3).ID;
            // Get healthy Spring 2017 purControl.addItemToList();
            //covering synch quantity
            // Get healthy Spring 2017 purControl.changedQty =  purControl.products.get(1).ID+'~'+'5'+';';
            // Get healthy Spring 2017 purControl.delItemFromList();

            // Get healthy Spring 2017 purControl.hdnDelProdLineId = purControl.products.get(0).ID;
            // Get healthy Spring 2017 purControl.delItemFromList();
            // Get healthy Spring 2017 purControl.getWizardStepInt();
            purControl.updatePOOnAction();
            // test the filter
            // Get healthy Spring 2017 purControl.selectedCategory = 'Module';
            // Get healthy Spring 2017 purControl.moveAccordingToFilter();
            // Get healthy Spring 2017 purControl.getProducts();
/*            purControl.moveFirst();
            purControl.moveLast();
            purControl.moveNext();
            purControl.movePrevious();*/
            //covering action function cancel
            purControl.isNewOrder = true;
            // Get healthy Spring 2017 purControl.selectedDesign = null;
            // Get healthy Spring 2017 purControl.designID = sunDesign.ID;
            // Get healthy Spring 2017 purControl.cancel();
            //second case of cancel function
            purControl.isNewOrder = false;
            purControl.dealerAccount = null;
            purControl.isPartnerUser = false;
            // Get healthy Spring 2017 purControl.cancel();
            Test.stoptest();
        }
    }

    @isTest
    public static void testSubmittedOrder(){
        Account acct = getPartnerAccount();
        User u =getPartnerPortalUser(acct);
        acct = u.Contact.Account;
        Ship_to_Site__c shToSite = setDealerShippingSite(acct);
        Bill_to_Site__c billToSite = setDealerBillingSite(acct);
        System.runAs(u){
            SunPower_Design__c sunDesign = getDesignObjectWithItems(acct);
            if(sunDesign == null) return;
            Purchase_Order__c pur = new Purchase_Order__c();
            pur.Dealer_Account__c = acct.ID;
            //Ship_to_Site__c shToSite = setDealerShippingSite(acct);
            //Bill_to_Site__c billToSite = setDealerBillingSite(acct);
            pur.Ship_to_Site__c = shToSite.ID;
            pur.Ship_to_Site__r = shToSite;
            pur.Bill_to_Site__c = billToSite.ID;
            pur.Bill_to_Site__r = billToSite;
            pur.Name = 'testpo';
            Opportunity opp = createOpp(acct,u);
            pur.Opportunity__c = opp.ID;
            pur.Opportunity__r = opp;
            pur.Requested_Delivery_Date__c = System.today();
            pur.Order_Status__c = 'Submitted';
            insert pur;
            createPOLineItems(pur);
            Test.starttest();
            Test.setCurrentPage(Page.PurchaseOrderWizard);
            ApexPages.currentPage().getParameters().put('id',pur.ID);
            ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(pur);
            PurchaseOrderWizardController purControl = new PurchaseOrderWizardController(stdctrl);
            Test.stoptest();
        }
    }

    @isTest
    public static void testStepNavigations(){
        Account acct = getPartnerAccount();
        User u =getPartnerPortalUser(acct);
        acct = u.Contact.Account;
        System.runAs(u){
            Purchase_Order__c pur = new Purchase_Order__c();
            pur.Dealer_Account__c = acct.ID;
            pur.Order_Wizard_Step__c  = 'step 1';
            Opportunity opp = createOpp(acct,u);
            pur.Opportunity__c = opp.ID;
            pur.Opportunity__r = opp;
            insert pur;
            Test.starttest();
            Test.setCurrentPage(Page.PurchaseOrderWizard);
            ApexPages.currentPage().getParameters().put('POID',pur.ID);
            ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(pur);
            PurchaseOrderWizardController purControl = new PurchaseOrderWizardController(stdctrl);
            // Get healthy Spring 2017 purControl.wizardStepNumber = '1';
            // Get healthy Spring 2017 purControl.showPage2byButton();

            purControl.shipToSiteAddress = 'test';
            // Get healthy Spring 2017 purControl.wizardStepNumber = '4';
            // Get healthy Spring 2017 purControl.showPage4byButtonFrom3();

            pur.Accept_Expedited_Delivery_Charges__c = false;
            purControl.isShowCheckbox  = true;
            // Get healthy Spring 2017 purControl.showPage4byButtonFrom3();

            purControl.submitOrder();

            // Get healthy Spring 2017 purControl.prodType2Value = 'In-Roof';
            // Get healthy Spring 2017 purControl.moveAccordingToFilter();
/*
            purControl.moveFirst();
            purControl.moveLast();
            purControl.moveNext();
            purControl.movePrevious();
       */
            purControl.selectedCustomerOpportunity = opp.ID;
            // Get healthy Spring 2017 purControl.wizardStepNumber = '1';
            //purControl.showNextPage();
            Test.stoptest();

        }
    }

    @isTest
    public static void testPOStatusError(){
        Account acct = getPartnerAccount();
        User u =getPartnerPortalUser(acct);
        acct = u.Contact.Account;
        if(acct.Oracle_Operating_Unit__c == null || acct.Oracle_Operating_Unit__c == ''){
            acct.Oracle_Operating_Unit__c = 'SPCN OU';
            update acct;
        }
        List<Price_List_Item__c> productList = createProductsList();
        Ship_to_Site__c shToSite = setDealerShippingSite(acct);
        Bill_to_Site__c billToSite = setDealerBillingSite(acct);
        System.runAs(u){
            SunPower_Design__c sunDesign = getDesignObjectWithItems(acct);
            if(sunDesign == null) return;
            Purchase_Order__c pur = new Purchase_Order__c();
            pur.Dealer_Account__c = acct.ID;
            //Ship_to_Site__c shToSite = setDealerShippingSite(acct);
            //Bill_to_Site__c billToSite = setDealerBillingSite(acct);
            pur.Ship_to_Site__c = shToSite.ID;
            pur.Ship_to_Site__r = shToSite;
            pur.Bill_to_Site__c = billToSite.ID;
            pur.Bill_to_Site__r = billToSite;
            pur.Name = 'testpo';
            Opportunity opp = createOpp(acct,u);
            pur.Opportunity__c = opp.ID;
            pur.Opportunity__r = opp;
            pur.Requested_Delivery_Date__c = System.today();
            pur.Order_Wizard_Step__c  = 'step 1';
            pur.Order_Status__c = 'Error';
            insert pur;
            createPOLineItems(pur);
            Test.starttest();
            Test.setCurrentPage(Page.PurchaseOrderWizard);
            ApexPages.currentPage().getParameters().put('POID',pur.ID);
            ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(pur);
            PurchaseOrderWizardController purControl = new PurchaseOrderWizardController(stdctrl);
            Test.stoptest();
        }
    }

    @isTest
    public static void testPOStatusProcessed(){
        Account acct = getPartnerAccount();
        User u =getPartnerPortalUser(acct);
        acct = u.Contact.Account;
        if(acct.Oracle_Operating_Unit__c == null || acct.Oracle_Operating_Unit__c == ''){
            acct.Oracle_Operating_Unit__c = 'SPCN OU';
            update acct;
        }
        List<Price_List_Item__c> productList = createProductsList();
          Ship_to_Site__c shToSite = setDealerShippingSite(acct);
          Bill_to_Site__c billToSite = setDealerBillingSite(acct);
        System.runAs(u){
            SunPower_Design__c sunDesign = getDesignObjectWithItems(acct);
            if(sunDesign == null) return;
            Purchase_Order__c pur = new Purchase_Order__c();
            pur.Dealer_Account__c = acct.ID;
            //Ship_to_Site__c shToSite = setDealerShippingSite(acct);
            //Bill_to_Site__c billToSite = setDealerBillingSite(acct);
            pur.Ship_to_Site__c = shToSite.ID;
            pur.Ship_to_Site__r = shToSite;
            pur.Bill_to_Site__c = billToSite.ID;
            pur.Bill_to_Site__r = billToSite;
            pur.Name = 'testpo';
            Opportunity opp = createOpp(acct,u);
            pur.Opportunity__c = opp.ID;
            pur.Opportunity__r = opp;
            pur.Requested_Delivery_Date__c = System.today();
            pur.Order_Wizard_Step__c  = 'step 4';
            pur.Order_Status__c = 'Processed';
            insert pur;
            createPOLineItems(pur);
            Test.starttest();
            Test.setCurrentPage(Page.PurchaseOrderWizard);
            ApexPages.currentPage().getParameters().put('POID',pur.ID);
            ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(pur);
            PurchaseOrderWizardController purControl = new PurchaseOrderWizardController(stdctrl);
            // covering the action function showPage4byButtonFrom3
            purControl.isEUUser = true;
            // Get healthy Spring 2017 purControl.showPage4byButtonFrom3();
            Test.stoptest();
        }
    }
    @isTest
    public static void testPOStatusInProcess(){
        Account acct = getPartnerAccount();
        User u =getPartnerPortalUser(acct);
        acct = u.Contact.Account;
        if(acct.Oracle_Operating_Unit__c == null || acct.Oracle_Operating_Unit__c == ''){
            acct.Oracle_Operating_Unit__c = 'SPCN OU';
            update acct;
        }
        List<Price_List_Item__c> productList = createProductsList();
            Ship_to_Site__c shToSite = setDealerShippingSite(acct);
            Bill_to_Site__c billToSite = setDealerBillingSite(acct);
        System.runAs(u){
            SunPower_Design__c sunDesign = getDesignObjectWithItems(acct);
            if(sunDesign == null) return;
            Purchase_Order__c pur = new Purchase_Order__c();
            pur.Dealer_Account__c = acct.ID;
            //Ship_to_Site__c shToSite = setDealerShippingSite(acct);
            //Bill_to_Site__c billToSite = setDealerBillingSite(acct);
            pur.Ship_to_Site__c = shToSite.ID;
            pur.Ship_to_Site__r = shToSite;
            pur.Bill_to_Site__c = billToSite.ID;
            pur.Bill_to_Site__r = billToSite;
            pur.Name = 'testpo';
            Opportunity opp = createOpp(acct,u);
            pur.Opportunity__c = opp.ID;
            pur.Opportunity__r = opp;
            pur.Accept_Expedited_Delivery_Charges__c = false;
            pur.Requested_Delivery_Date__c = System.today();
            pur.Order_Wizard_Step__c  = 'step 3';
            pur.Order_Status__c = 'In Process';
            insert pur;
            createPOLineItems(pur);
            Test.starttest();
            Test.setCurrentPage(Page.PurchaseOrderWizard);
            ApexPages.currentPage().getParameters().put('POID',pur.ID);
            ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(pur);
            PurchaseOrderWizardController purControl = new PurchaseOrderWizardController(stdctrl);

            purControl.shipToSiteAddress = 'test';
            purControl.isShowCheckBox = true;
            // Get healthy Spring 2017 purControl.showPage4byButtonFrom3();

            // if non-partner user
            purControl.isPartnerUser = false;
            purControl.isNewOrder = false;
            purControl.updatePOOnAction();

            purControl.purchaseOrder = null;
            purControl.updatePOOnAction();
            Test.stoptest();

        }
    }

    @isTest
    public static void testUserAuthentication(){
        Account acct = getPartnerAccount();
        User u =getPartnerPortalUser(acct);
        acct = u.Contact.Account;
        if(acct.Oracle_Operating_Unit__c == null || acct.Oracle_Operating_Unit__c == ''){
            acct.Oracle_Operating_Unit__c = 'SPCN OU';
            update acct;
        }
        List<Price_List_Item__c> productList = createProductsList();
            Ship_to_Site__c shToSite = setDealerShippingSite(acct);
            Bill_to_Site__c billToSite = setDealerBillingSite(acct);
        System.runAs(u){

            SunPower_Design__c sunDesign = getDesignObjectWithItems(acct);
            if(sunDesign == null) return;
            Purchase_Order__c pur = new Purchase_Order__c();
            String recType ='';
            for(RecordType r:[select id,Name from RecordType where sObjectType ='Account' and name ='Partner' LIMIT 1])
             recType = r.ID;


            //create different dealer account
            Account acct1 = new Account(name='test'+String.valueOf(DateTime.now().getTime()),recordTypeID=recType);
            acct1.ShippingCity = 'Jaipur';
            acct1.ShippingStreet = 'Durgapura';
            acct1.ShippingCountry = 'India';
            acct1.ShippingState='Rajasthan';
            acct1.ShippingPostalCode ='302018';
            acct1.Online_Order_Access__c = true;
            acct1.Oracle_Account_Number__c = 'test-12345-test';
             acct1.BillingCity = 'san mateo';
            acct1.BillingStreet = 'Concar drive';
            acct1.BillingPostalCode ='94402';
            acct1.BillingState = 'CA';
            acct1.BillingCountry = 'USA';
            insert acct1;

            Test.startTest();
            pur.Dealer_Account__c = acct1.ID;
            //Ship_to_Site__c shToSite = setDealerShippingSite(acct);
            //Bill_to_Site__c billToSite = setDealerBillingSite(acct);
            pur.Ship_to_Site__c = shToSite.ID;
            pur.Ship_to_Site__r = shToSite;
            pur.Bill_to_Site__c = billToSite.ID;
            pur.Bill_to_Site__r = billToSite;
            pur.Name = 'testpo';
            Opportunity opp = createOpp(acct,u);
            pur.Opportunity__c = opp.ID;
            pur.Opportunity__r = opp;
            pur.Requested_Delivery_Date__c = System.today();
            pur.Order_Wizard_Step__c  = 'step 4';
            pur.Order_Status__c = 'New';

            insert pur;
            createPOLineItems(pur);

            Test.setCurrentPage(Page.PurchaseOrderWizard);
            ApexPages.currentPage().getParameters().put('POID',pur.ID);
            ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(pur);
            PurchaseOrderWizardController purControl = new PurchaseOrderWizardController(stdctrl);
            Test.stopTest();
        }
    }

    @isTest
    public static void testEUResidentialUser(){
        Account acct = getPartnerAccount();
        User u = getEUResidentialUser(acct);
        acct = u.Contact.Account;
        if(acct.Oracle_Operating_Unit__c == null || acct.Oracle_Operating_Unit__c == ''){
            acct.Oracle_Operating_Unit__c = 'SPCN OU';
            update acct;
        }
        System.runAs(u){
            Purchase_Order__c pur = new Purchase_Order__c();
            ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(pur);
            PurchaseOrderWizardController purControl = new PurchaseOrderWizardController(stdctrl);
        }
    }

    @isTest
    public static void testNonPartnerUser(){
        Account acct = getPartnerAccount();
        Purchase_Order__c pur = new Purchase_Order__c();
        SunPower_Design__c sunDesign = getDesignObjectWithItems(acct);
        if(sunDesign == null) return;
        Test.setCurrentPage(Page.PurchaseOrderWizard);
        ApexPages.currentPage().getParameters().put('DID',sunDesign.ID);
        ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(pur);
        PurchaseOrderWizardController purControl = new PurchaseOrderWizardController(stdctrl);
    }

    @isTest
    public static void testNonPartnerUser2(){
        Account acct = getPartnerAccount();
        User u =getPartnerPortalUser(acct);
        List<Price_List_Item__c> productList = createProductsList();
        Ship_to_Site__c shToSite = setDealerShippingSite(acct);
        Bill_to_Site__c billToSite = setDealerBillingSite(acct);
        Purchase_Order__c pur = new Purchase_Order__c();
        pur.Dealer_Account__c = acct.ID;
        pur.Ship_to_Site__c = shToSite.ID;
        pur.Ship_to_Site__r = shToSite;
        pur.Bill_to_Site__c = billToSite.ID;
        pur.Bill_to_Site__r = billToSite;
        pur.Ship_To_Contact__c = u.Contact.Id;
        pur.Name = 'testpo';
        pur.Order_Status__c = 'New';
        pur.Requested_Delivery_Date__c = System.today();
        pur.Order_Wizard_Step__c  = 'step 1';
        pur.Sales_Type__c = 'Cash';

        insert pur;
        createPOLineItems(pur);
        Test.starttest();
        Test.setCurrentPage(Page.PurchaseOrderWizard);
        ApexPages.currentPage().getParameters().put('POID',pur.ID);

        ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(pur);
        PurchaseOrderWizardController purControl = new PurchaseOrderWizardController(stdctrl);
        // Get healthy Spring 2017 purControl.updatePOLineItems();
        // Get healthy Spring 2017 purControl.getProducts();
        //purControl.getItemsList();
        PurchaseOrderWizardController.PurchaseOrderLineItemWrapper pWrap = new PurchaseOrderWizardController.PurchaseOrderLineItemWrapper('','','','','',true,true);
        // Get healthy Spring 2017 purControl.delItemFromList();
        purControl.submitOrder();
        // Get healthy Spring 2017 purControl.showPage2byButton();
        PurchaseOrderWizardController.PurchaseOrderLineItemWrapper pwrap2 = new PurchaseOrderWizardController.PurchaseOrderLineItemWrapper('test','test','test','test','5.0','USD',5.0,5.0,true,true);
        PurchaseOrderWizardController.PurchaseOrderLineItemWrapper pwrap3 = new PurchaseOrderWizardController.PurchaseOrderLineItemWrapper();

        purControl.selProductItems = new List<PurchaseOrderWizardController.PurchaseOrderLineItemWrapper>();
        purControl.selProductItems.add(pWrap);
        purControl.selProductItems.add(pWrap2);
        purControl.selProductItems.add(pWrap3);
        // Get healthy Spring 2017 purControl.products = productList;

        // Get healthy Spring 2017 purControl.singleAddedprodId = purControl.products.get(0).ID;
        // Get healthy Spring 2017 purControl.addItemToList();
        purControl.selectedShipToSiteID = acct.ID;
        // Get healthy Spring 2017 purControl.setPOShipToSite();
        purControl.calcDayDifference();
        purControl.submitOrder();
        Test.stoptest();
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

    private static List<PurchaseOrderWizardController.PurchaseOrderLineItemWrapper> createWrapperList(){
        List<PurchaseOrderWizardController.PurchaseOrderLineItemWrapper> wrapperList = new List<PurchaseOrderWizardController.PurchaseOrderLineItemWrapper>();
        PurchaseOrderWizardController.PurchaseOrderLineItemWrapper pWrap1 = new PurchaseOrderWizardController.PurchaseOrderLineItemWrapper('','','','','',true,true);
        PurchaseOrderWizardController.PurchaseOrderLineItemWrapper pwrap2 = new PurchaseOrderWizardController.PurchaseOrderLineItemWrapper('test','test','test','test','5.0','USD',5.0,5.0,true,true);
        PurchaseOrderWizardController.PurchaseOrderLineItemWrapper pwrap3 = new PurchaseOrderWizardController.PurchaseOrderLineItemWrapper();
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
        acct.Oracle_Account_Number__c = 'test-12345';
        acct.NH_SSE_Type__c = 'TPS';

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
            pLine1.SmartPack_Item__c = false;
            pLine1.Quantity_per_Box__c = 2;
            pLine1.Order_Line_Number__c = '1.0';
            pLine1.CurrencyIsoCode = 'USD';
            insert pLine1;
        }
    }
    @isTest
    public static void testNewPurchaseOrder6(){
        Account acct = getPartnerAccount();
        User u =getPartnerPortalUser(acct);
        acct = u.Contact.Account;
        acct.BillingState = 'CA';
        update acct;
        System.runAs(u){
            Purchase_Order__c pur = new Purchase_Order__c();
            pur.Dealer_Account__c = acct.ID;
            //Ship_to_Site__c shToSite = setDealerShippingSite(acct);
            //Bill_to_Site__c billToSite = setDealerBillingSite(acct);
            pur.Name = 'testpo';
            pur.Order_Status__c = 'New';
            Opportunity opp = createOpp(acct,u);
            pur.Opportunity__c = opp.ID;
            pur.Opportunity__r = opp;
            pur.Requested_Delivery_Date__c = System.today();
            pur.Order_Wizard_Step__c  = 'step 1';
            insert pur;
            Test.starttest();
            ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(pur);
            PurchaseOrderWizardController purControl = new PurchaseOrderWizardController(stdctrl);
            Ship_to_Site__c shToSite = setDealerShippingSite(acct);
            Bill_to_Site__c billToSite = setDealerBillingSite(acct);
            purControl.isUserAuthorized = true;
            purControl.selectedCustomerOpportunity = opp.ID;
            purControl.purchaseOrder = pur;
            // Get healthy Spring 2017 purControl.setDealerAddressToShipToSite();
            // Get healthy Spring 2017 purControl.setOppBillingAddressToShipToSite();
            // Get healthy Spring 2017 purControl.setOppShippingAddressToShipToSite();
            // Get healthy Spring 2017 purControl.moveAccordingToFilterOppsList();
            // Get healthy Spring 2017 purControl.moveFirstOppsList();
            // Get healthy Spring 2017 purControl.moveLastOppsList();
            // Get healthy Spring 2017 purControl.moveNextOppsList();
            // Get healthy Spring 2017 purControl.movePreviousOppsList();
            // Get healthy Spring 2017 List<Opportunity> oppList =purControl.getOpportunityList();
            purControl.dealerAccount = null;
            // Get healthy Spring 2017 purControl.setDealerAddressToShipToSite();
            // Get healthy Spring 2017 purControl.setOppBillingAddressToShipToSite();
            // Get healthy Spring 2017 purControl.setOppShippingAddressToShipToSite();
            Test.stoptest();
        }
    }

     @isTest
    public static void testNewPurchaseOrder7(){
        Account acct = getPartnerAccount();
        User u =getPartnerPortalUser(acct);
        acct = u.Contact.Account;
        acct.BillingState = 'CA';
        update acct;
        System.runAs(u){
            Purchase_Order__c pur = new Purchase_Order__c();
            //pur.Dealer_Account__c = acct.ID;
            //Ship_to_Site__c shToSite = setDealerShippingSite(acct);
            //Bill_to_Site__c billToSite = setDealerBillingSite(acct);
            pur.Name = 'testpo';
            pur.Order_Status__c = 'New';
            Opportunity opp = createOpp(acct,u);
            pur.Opportunity__c = opp.ID;
            pur.Opportunity__r = opp;
            pur.Requested_Delivery_Date__c = System.today();
            pur.Order_Wizard_Step__c  = 'step 1';
            pur.OwnerId = u.Id;
            insert pur;
            Test.starttest();
            ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(pur);
            PurchaseOrderWizardController purControl = new PurchaseOrderWizardController(stdctrl);
            //Ship_to_Site__c shToSite = setDealerShippingSite(acct);
            //Bill_to_Site__c billToSite = setDealerBillingSite(acct);
            purControl.isUserAuthorized = true;
            purControl.selectedCustomerOpportunity = opp.ID;
            purControl.purchaseOrder = pur;
            // Get healthy Spring 2017 purControl.setDealerAddressToShipToSite();
            // Get healthy Spring 2017 purControl.setOppBillingAddressToShipToSite();
            // Get healthy Spring 2017 purControl.setOppShippingAddressToShipToSite();
            // Get healthy Spring 2017 purControl.updateQuantity();
            // Get healthy Spring 2017 purControl.setPOShipToSiteContact();
            // Get healthy Spring 2017 purControl.getHasNext();
            // Get healthy Spring 2017 purControl.getHasPrevious();
            // Get healthy Spring 2017 purControl.getQunatityMessage();
            // Get healthy Spring 2017 purControl.showQuantityMessage=true;
            // Get healthy Spring 2017 purControl.getQunatityMessage();
            // Get healthy Spring 2017 purControl.orderOwnerContactID = null;
            // Get healthy Spring 2017 String str = purControl.orderOwnerContactID;
            // Get healthy Spring 2017 purControl.setDealerAddressToShipToSite();
            // Get healthy Spring 2017 purControl.selectedShipToSiteConID =u.Contact.Id;
            // Get healthy Spring 2017 purControl.setPOShipToSiteContact();
            // Get healthy Spring 2017 purControl.currentDealersContactsMap =null;
            // Get healthy Spring 2017 purControl.setPOShipToSiteContact();
            Test.stoptest();
        }
    }

}//class ends