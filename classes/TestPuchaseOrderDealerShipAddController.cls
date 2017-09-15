/* This test class for PuchaseOrderDealerShipAddController */
    @isTest
private without sharing class TestPuchaseOrderDealerShipAddController {
    
    @isTest
    public static void testWAREShipToSiteAdd(){
        Account acct = getPartnerAccount();
        User u = getPartnerPortalUser(acct);
        acct = u.Contact.Account;
        System.runAs(u){
            Ship_to_Site__c shipToSite = new Ship_to_Site__c();
            Test.setCurrentPage(Page.PuchaseOrderPopup_NewDealerShipAdd);
            ApexPages.currentPage().getParameters().put('dealerAccountID',acct.ID);
            ApexPages.currentPage().getParameters().put('recType','WARE');
            ApexPages.Standardcontroller stdController = new Apexpages.Standardcontroller(shipToSite);
            PuchaseOrderDealerShipAddController addShipToSiteCtrl = new PuchaseOrderDealerShipAddController(stdController);         
                
            shipToSite.Address1__c = 'test address1';         
            shipToSite.City__c = 'test city';
            shipToSite.State__c = 'test state';
            shipToSite.Country__c = 'test country';       
            shipToSite.Zip__c = '8888';
            addShipToSiteCtrl.saveShipToSite();
            addShipToSiteCtrl.getAttentionContacts();
        }
    }
    
    @isTest
    public static void testOPPTShipToSiteAdd(){
        Account acct = getPartnerAccount();
        User u = getPartnerPortalUser(acct);
        acct = u.Contact.Account;
        System.runAs(u){
            Ship_to_Site__c shipToSite = new Ship_to_Site__c();
            Test.setCurrentPage(Page.PuchaseOrderPopup_NewDealerShipAdd);
            ApexPages.currentPage().getParameters().put('dealerAccountID',acct.ID);
            ApexPages.currentPage().getParameters().put('recType','OPPT');
            ApexPages.Standardcontroller stdController = new Apexpages.Standardcontroller(shipToSite);
            PuchaseOrderDealerShipAddController addShipToSiteCtrl = new PuchaseOrderDealerShipAddController(stdController);
            addShipToSiteCtrl.saveShipToSite();
        }
    }
    
    @isTest
    public static void testRESIShipToSiteAdd(){
        Account acct = getPartnerAccount();
        User u = getPartnerPortalUser(acct);
        acct = u.Contact.Account;
        System.runAs(u){
            Ship_to_Site__c shipToSite = new Ship_to_Site__c();
            Test.setCurrentPage(Page.PuchaseOrderPopup_NewDealerShipAdd);
            ApexPages.currentPage().getParameters().put('dealerAccountID',acct.ID);
            ApexPages.currentPage().getParameters().put('recType','RESI');
            ApexPages.currentPage().getParameters().put('oppId','1');
            ApexPages.Standardcontroller stdController = new Apexpages.Standardcontroller(shipToSite);
            PuchaseOrderDealerShipAddController addShipToSiteCtrl = new PuchaseOrderDealerShipAddController(stdController);
            addShipToSiteCtrl.saveShipToSite();
        }
    }

    @isTest
    public static void testOPPTShipToSiteAddWithDupUniqueID(){
        Account acct = getPartnerAccount();
        User u = getPartnerPortalUser(acct);
        acct = u.Contact.Account;
        System.runAs(u){
            Ship_to_Site__c shipToSite = new Ship_to_Site__c();           
            Test.setCurrentPage(Page.PuchaseOrderPopup_NewDealerShipAdd);
            ApexPages.currentPage().getParameters().put('dealerAccountID',acct.ID);
            ApexPages.currentPage().getParameters().put('recType','OPPT');
            ApexPages.Standardcontroller stdController = new Apexpages.Standardcontroller(shipToSite);
            PuchaseOrderDealerShipAddController addShipToSiteCtrl = new PuchaseOrderDealerShipAddController(stdController);
            // inserting duplicate ship to site record
            Ship_to_Site__c shipsiteDup = new Ship_to_Site__c();
            shipsiteDup.Dealer_Account__c = acct.ID;   
            shipsiteDup.Address1__c = 'test address1';         
            shipsiteDup.City__c = 'test city';
            shipsiteDup.State__c = 'test state';
            shipsiteDup.Country__c = 'test country';       
            shipsiteDup.Zip__c = '8888';
            insert shipsiteDup;
                        
            addShipToSiteCtrl.saveShipToSite();         
            //System.assert(!addShipToSiteCtrl.isSucceeded);
        }
    }

    @isTest
    public static void testRESIShipToSiteAddWithDupUniqueID(){
        Account acct = getPartnerAccount();
        User u = getPartnerPortalUser(acct);
        acct = u.Contact.Account;
        System.runAs(u){
            Ship_to_Site__c shipToSite = new Ship_to_Site__c();           
            Test.setCurrentPage(Page.PuchaseOrderPopup_NewDealerShipAdd);
            ApexPages.currentPage().getParameters().put('dealerAccountID',acct.ID);
            ApexPages.currentPage().getParameters().put('recType','RESI');
            ApexPages.Standardcontroller stdController = new Apexpages.Standardcontroller(shipToSite);
            PuchaseOrderDealerShipAddController addShipToSiteCtrl = new PuchaseOrderDealerShipAddController(stdController);
            // inserting duplicate ship to site record
            Ship_to_Site__c shipsiteDup = new Ship_to_Site__c();
            shipsiteDup.Dealer_Account__c = acct.ID;   
            /*         
            The user returned by getPartnerPortalUser(acct)
            does not have values for any of the following
            values. Hence commented this and passed 
            static values.
            shipsiteDup.Address1__c = acct.ShippingStreet;          
            shipsiteDup.City__c = acct.ShippingCity;
            shipsiteDup.Country__c = acct.ShippingCountry;          
            shipsiteDup.State__c = acct.ShippingState;
            shipsiteDup.Zip__c = acct.ShippingPostalCode;
            */
            shipsiteDup.Address1__c = 'test address1';         
            shipsiteDup.City__c = 'test city';
            shipsiteDup.State__c = 'test state';
            shipsiteDup.Country__c = 'test country';       
            shipsiteDup.Zip__c = '8888';
            insert shipsiteDup;
                        
            addShipToSiteCtrl.saveShipToSite();         
           //System.assert(!addShipToSiteCtrl.isSucceeded);
        }
    }

    @isTest
    public static void testNULLSaveShipToSite(){
        Account acct = getPartnerAccount();
        User u = getPartnerPortalUser(acct);
        acct = u.Contact.Account;
        System.runAs(u){
            Ship_to_Site__c shipToSite = new Ship_to_Site__c();
            Test.setCurrentPage(Page.PuchaseOrderPopup_NewDealerShipAdd);
            ApexPages.currentPage().getParameters().put('dealerAccountID',acct.ID);
            ApexPages.currentPage().getParameters().put('recType','RESI');
            ApexPages.Standardcontroller stdController = new Apexpages.Standardcontroller(shipToSite);
            PuchaseOrderDealerShipAddController addShipToSiteCtrl = new PuchaseOrderDealerShipAddController(stdController);         
                
            addShipToSiteCtrl.shipToSite.Address1__c = 'Address1';         
            addShipToSiteCtrl.shipToSite.Address2__c = 'Address2';
            addShipToSiteCtrl.shipToSite.Address3__c = 'Address3';
            addShipToSiteCtrl.shipToSite.City__c = 'City';
            addShipToSiteCtrl.shipToSite.State__c = 'State';
            addShipToSiteCtrl.shipToSite.Country__c = 'Country';       
            addShipToSiteCtrl.shipToSite.Zip__c = 'Zip';
            addShipToSiteCtrl.saveShipToSite();
        }
    }

    private static User getPartnerPortalUser(Account acct){
        User user = null;
        for(User u:[select id,Name,contactId,Contact.AccountID, Contact.Account.ID,Contact.Account.AccountNumber,Contact.Account.Name,Contact.Account.ShippingStreet,Contact.Account.ShippingState,Contact.Account.ShippingCity,Contact.Account.ShippingCountry,Contact.Account.ShippingPostalCode, Contact.Account.Oracle_Account_Number__c from User where (Profile.Name = 'Partner Executive' or Profile.Name = 'EU Partner Executive' or Profile.Name = 'Partner Delegated Administrator') and ContactID != null and Contact.Authorized_to_Order__c = true and Contact.Account.Online_Order_Access__c = true and isActive = true LIMIT 1]){
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
        acct.Type = 'Residential Installer';
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
        //shipSite.Country__c ='India';
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

}