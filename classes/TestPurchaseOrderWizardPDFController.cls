/* This test class for PurchaseOrderWizardPDFController */
    @isTest
private class TestPurchaseOrderWizardPDFController {

@isTest
    public static void testNewPurchaseOrderPDF(){
        Account acct = getPartnerAccount();
        User u = getPartnerPortalUser(acct);
        acct = u.Contact.Account;
        System.runAs(u){
            Purchase_Order__c po = new Purchase_Order__c();
            Ship_to_Site__c shToSite = setDealerShippingSite(acct);
            Bill_to_Site__c billToSite = setDealerBillingSite(acct);
            po.Ship_to_Site__c = shToSite.ID;
            po.Ship_to_Site__r = shToSite;
            po.Bill_to_Site__c = billToSite.ID;
            po.Bill_to_Site__r = billToSite;
            
            po.System_Size__c = 1;
            po.Accept_Expedited_Delivery_Charges__c = false;
            po.Dealer_Account__c = acct.ID;
            po.Delivery_Charges__c = 5;
            po.Order_Status__c = 'New';
            po.Order_Total__c = 5;
            po.Order_Wizard_Step__c = '4';
            insert po;
            createPOLineItems(po);
        
            ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(po);
            PurchaseOrderWizardPDFController poPDFCtrl = new PurchaseOrderWizardPDFController(stdctrl);
            PurchaseOrderWizardPDFController.PurchaseOrderLineItemWrapper pWrap = new PurchaseOrderWizardPDFController.PurchaseOrderLineItemWrapper('testItem','1','test','AlaCarte','2',true,true);
            PurchaseOrderWizardPDFController.PurchaseOrderLineItemWrapper pWrap1 = new PurchaseOrderWizardPDFController.PurchaseOrderLineItemWrapper('tst','2','test2','Ala-Carte','5',5.0,true,true,10.0);
        }
    }
    
    @isTest
    public static void testNewPurchaseOrderPDFWithID(){
        Account acct = getPartnerAccount();
        User u = getPartnerPortalUser(acct);
        acct = u.Contact.Account;
        
        System.runAs(u){
            Purchase_Order__c po = new Purchase_Order__c();
            Ship_to_Site__c shToSite = setDealerShippingSite(acct);
            Bill_to_Site__c billToSite = setDealerBillingSite(acct);
            //Opportunity opp = new Opportunity();
            //opp.AccountId = acct.ID;
            //insert opp;
            //po.Opportunity__c = opp.ID;
            //po.Opportunity__r = opp;
            po.Ship_to_Site__c = shToSite.ID;
            po.Ship_to_Site__r = shToSite;
            po.Bill_to_Site__c = billToSite.ID;
            po.Bill_to_Site__r = billToSite;
            
            po.System_Size__c = 1;
            po.Accept_Expedited_Delivery_Charges__c = true;
            po.Dealer_Account__c = acct.ID;
            po.Delivery_Charges__c = 5;
            po.Order_Status__c = 'New';
            po.Order_Total__c = 5;
            po.Order_Wizard_Step__c = '4';
            insert po;
            createPOLineItems(po);
            
            Test.setCurrentPage(Page.PurchaseOrderWizardPDF);
            ApexPages.currentPage().getParameters().put('id',po.ID);        
            ApexPages.Standardcontroller stdctrl = new Apexpages.Standardcontroller(po);
            PurchaseOrderWizardPDFController poPDFCtrl = new PurchaseOrderWizardPDFController(stdctrl);
            PurchaseOrderWizardPDFController.PurchaseOrderLineItemWrapper pWrap = new PurchaseOrderWizardPDFController.PurchaseOrderLineItemWrapper('testItem','1','test','AlaCarte','2',true,true);
            PurchaseOrderWizardPDFController.PurchaseOrderLineItemWrapper pWrap1 = new PurchaseOrderWizardPDFController.PurchaseOrderLineItemWrapper('tst','2','test2','Ala-Carte','5',5,true,true,5);
        }
    }
    
    Private static void createPOLineItems(Purchase_Order__c po){        
        Purchase_Order_Line__c pLine1 = new Purchase_Order_Line__c();
        pLine1.Purchase_Order__c = po.ID;
        pLine1.Item_Description__c = 'test item';
        pLine1.Item_ID__c = 'testid';
        pLine1.Price__c = 5;
        pLine1.Quantity__c = 5;
        pLine1.Unit_Price__c = 5;
        pLine1.SmartPack_Item__c = false;
        pLine1.Quantity_per_Box__c = 2;
        pLine1.Order_Line_Number__c = '1.0';
        pLine1.CurrencyIsoCode = 'USD';
        insert pLine1;
        
        Purchase_Order_Line__c pLine2 = new Purchase_Order_Line__c();
        pLine2.Purchase_Order__c = po.ID;
        pLine2.Item_Description__c = 'test item2';
        pLine2.Item_ID__c = 'testid2';
        pLine2.Price__c = 5;
        pLine2.Quantity__c = 5;
        pLine2.Unit_Price__c = 5;
        pLine2.SmartPack_Item__c = false;
        pLine2.Quantity_per_Box__c = 2;
        pLine2.Order_Line_Number__c = '2.0';
        pLine2.CurrencyIsoCode = 'USD';
        insert pLine2;
    
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
        acct.Online_Order_Access__c = true;
        acct.Oracle_Account_Number__c = 'test-12345';
        acct.BillingCity = 'san mateo';
        acct.BillingStreet = 'Concar drive';
        acct.BillingPostalCode ='94402';
        acct.BillingCountry = 'USA'; 
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
        for(User u:[select id,Name,contactId,Contact.AccountID, Contact.Account.Id,Contact.Account.AccountNumber,Contact.Account.Name,Contact.Account.ShippingStreet,Contact.Account.ShippingState,Contact.Account.ShippingCity,Contact.Account.ShippingCountry,Contact.Account.ShippingPostalCode, Contact.Account.Oracle_Account_Number__c from User where (Profile.Name = 'Partner Executive' or Profile.Name = 'EU Partner Executive' or Profile.Name = 'Partner Delegated Administrator' ) and Contact.AccountID !=null and ContactID != null and Contact.Authorized_to_Order__c = true and Contact.Account.Online_Order_Access__c = true and isActive =true LIMIT 1]){
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
        
        return user;
        
    }
     
}//class ends