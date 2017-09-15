/*********************************************************************
Name        : AccountExtension_Test
Created On  : Nov 3, 2011
Created By  : Anjali Jain(Appirio Offshore)
Description : Test class for AccountExtension. Tests NA/EU Residential and Commercial customer via partner portal user
History     : 1.0 Created   
**********************************************************************/


@isTest
private class AccountExtension_Test {

    private static Id commercialCustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Commercial Customer').getRecordTypeId();
    private static Id residentialCustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Residential Customer').getRecordTypeId();
     //put it in some util class
    private static Id commercialRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial').getRecordTypeId();
    private static Id residentialRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Home Owner').getRecordTypeId(); 
    
    static Account partnerAccount;
    static Contact partnerContact;
    static User partnerUser;
    
    static String Country = 'United States'; 
    static String County = 'San Francisco'; 
    static String Address = '123 Madison Ave'; 
    static String City = 'San Francisco'; 
    static String State = 'CA'; 
    static String Zip = '94105'; 
    
    private static user getPartnerUser(){   
        UserManagement.IS_TEST = true;
        
        partnerAccount = TestUtils.createAccount('TEST_BOOYAH', TestUtils.getPartnerRecordTypeId(), false);
        //make lease enabled partner
        partnerAccount.Lease2_0_Program_Partner__c = true;
        partnerAccount.Oracle_Vendor_Number__c = 'VN'+String.ValueOf(DateTime.Now().getTime()).substring(0, 10)+String.ValueOf(Math.random()).substring(0,10);
        partnerAccount.Oracle_Vendor_Site_Code__c  = 'VSC'+String.ValueOf(DateTime.Now().getTime()).substring(0, 10)+String.ValueOf(Math.random()).substring(0,10);
        partnerAccount.Oracle_Warehouse__c  = 'BWGUY'+String.ValueOf(DateTime.Now().getTime()).substring(0, 10)+String.ValueOf(Math.random()).substring(0,10);
        insert partnerAccount;
        
        partnerContact = TestUtils.createContact( 'TEST_HEYAHH', partnerAccount.Id, true );
        
        partnerUser = TestUtils.createPartnerPortalUser( partnerContact, false );
        return partnerUser;
    }
    
    private static user getPartnerUser1(){   
        UserManagement.IS_TEST = true;
        
        partnerAccount = TestUtils.createAccount('TEST_BOOYAH', TestUtils.getPartnerRecordTypeId(), false);
        //make lease enabled partner
        partnerAccount.Lease2_0_Program_Partner__c = true;
        partnerAccount.Oracle_Vendor_Number__c = 'VN'+String.ValueOf(DateTime.Now().getTime()).substring(0, 10)+String.ValueOf(Math.random()).substring(0,10);
        partnerAccount.Oracle_Vendor_Site_Code__c  = 'VSC'+String.ValueOf(DateTime.Now().getTime()).substring(0, 10)+String.ValueOf(Math.random()).substring(0,10);
        partnerAccount.Oracle_Warehouse__c  = 'BWGUY'+String.ValueOf(DateTime.Now().getTime()).substring(0, 10)+String.ValueOf(Math.random()).substring(0,10);
        partnerAccount.Country_Domain__c = 'rvar-fr';
        insert partnerAccount;
        
        partnerContact = TestUtils.createContact( 'TEST_HEYAHH', partnerAccount.Id, true );
        
        partnerUser = TestUtils.createPartnerPortalUser( partnerContact, false );
        partnerUser.Country_Domain__c = 'rvar-fr';
        return partnerUser;
    }

    static testmethod void testEnableUserToCreateLeaseAccounts() {        
        ApexPages.Standardcontroller stdCtrl;
        AccountExtension dealRegistration;

        Test.startTest();        
        partnerUser = getPartnerUser();
        System.runAs( partnerUser ){    
            PageReference pg = Page.AccountNew;            
            Test.setCurrentPage(pg);     
            stdCtrl = new ApexPages.Standardcontroller( new Account() );
            dealRegistration = new AccountExtension ( stdCtrl ) ;            
        }            
        Test.stopTest();
        
        System.assert( dealRegistration.isLeaseEnabledPartner , 'The partner should be lease enabled' );
    }
    
    static testmethod void testDisableUserToCreateLeaseAccounts() {                
        ApexPages.Standardcontroller stdCtrl;
        AccountExtension dealRegistration;

        Test.startTest();   
        partnerUser = getPartnerUser();  
        partnerAccount.Lease2_0_Program_Partner__c = false;
        update partnerAccount;
           
        System.runAs( partnerUser ){
            PageReference pg = Page.AccountNew;            
            Test.setCurrentPage(pg);
            stdCtrl = new ApexPages.Standardcontroller( new Account() );
            dealRegistration = new AccountExtension ( stdCtrl );
        }                
        Test.stopTest();
        
        System.assert( !dealRegistration.isLeaseEnabledPartner , 'The partner should not be lease enabled' );
    }
    
    
    static testmethod void testRetrieveVertexAddresses() {  //original uncommented
        
        Vertex_Address_Validation__c newVertex = TestUtils.createValidation( '99999', true );
        
        List<Vertex_Address_Validation__c> validAddresses;
        Test.startTest();
        partnerUser = getPartnerUser();
        System.runAs( partnerUser ){            
            validAddresses = AccountExtension.checkAddressInformation( '99999' );            
        }            
        Test.stopTest();
        
        System.assertEquals( 1, validAddresses.size() );        
    }
    
    static testmethod void testCreateCustomerForNAResidentialWithLease() {
        SFDCSpecialUtilities.isRunningTest = True;   
             
        partnerUser = getPartnerUser();
        System.runAs(partnerUser){ 
            ApexPages.currentPage().getParameters().put('RecordType',residentialCustomerRecordTypeId);
            ApexPages.StandardController stdCont = new ApexPages.StandardController(new Account());
            AccountNewController accountNewController = new AccountNewController(stdCont);
            accountNewController.newUrl='/apex/AccountNew?retURL=/001/o&ent=Account&save_new=1&sfdc.override=1';
            //PageReference pg = accountNewController.redirect();
            PageReference pg = Page.AccountNew;            
            Test.setCurrentPage(pg);
            AccountExtension accExtension  =  new AccountExtension(stdCont);
            System.assertNotEquals(null,pg);
            System.assertNotEquals(true,accExtension.isEUProfile);
            accExtension.opp.Name = 'TestNAResidOpp1';
            accExtension.opp.CloseDate = System.today();
            accExtension.opp.StageName = '12% Qualified Opportunity';
            accExtension.opp.Project_Stage__c='Qualification in Process';
            accExtension.newCustomer.Lease__c = true;
            accExtension.newCustomer.BillingCountry = 'India';
            accExtension.newCustomer.BillingCity = 'Delhi';
            accExtension.newCustomer.BillingState = 'Delhi';
            accExtension.newCustomer.BillingStreet = 'South City';
            accExtension.newCustomer.BillingPostalCode = '3021001';
            accExtension.newCustomer.Phone = '989189111';
            accExtension.newCustomer.Oracle_County__c = 'San Francisco';
            accExtension.newCustomer.Status__c = 'Active';
            accExtension.validatedAddress = true;
            pg = accExtension.save();                        
            Account newCustomer;
            List<Account> newCustomerList = [
            Select id, Name , RecordType.Name, BillingCountry, BillingCity,BillingStreet,BillingState,BillingPostalCode,
                ShippingCountry,ShippingCity,ShippingStreet,ShippingState,ShippingPostalCode, Oracle_Shipping_County__c,
                Partner_Portal_Registration__c, Lease__c, Oracle_County__c, Oracle_Sales_Channel__c,
                Oracle_Customer_Classification__c,Oracle_Warehouse__c,Oracle_Account_Type__c,
                Oracle_Operating_Unit__c,Oracle_Order_Type__c
                from Account where name = 'TestNAResidOpp1' and Partner_Portal_Registration__c = true];
            
            if(newCustomerList != null && newCustomerList.size() >0) {
                newCustomer = newCustomerList[0];
                system.debug('*****  newCustomer ' +newCustomer.Oracle_Warehouse__c);
            }
            System.debug( newCustomer);
            if(newCustomer!=null){
                System.assertEquals( newCustomer.BillingCountry, newCustomer.ShippingCountry );
                System.assertEquals( newCustomer.BillingCity , newCustomer.ShippingCity );
                System.assertEquals( newCustomer.Oracle_Shipping_County__c , newCustomer.Oracle_County__c );
                System.assertEquals(true,newCustomer.Partner_Portal_Registration__c);            
            
                System.assertEquals( AccountExtension.O_CUSTOMER_CLASSIFICATION, newCustomer.Oracle_Customer_Classification__c );
                System.assertEquals( partnerAccount.Oracle_Warehouse__c, newCustomer.Oracle_Warehouse__c);
                System.assertEquals( AccountExtension.O_ACCOUNT_TYPE, newCustomer.Oracle_Account_Type__c );
                System.assertEquals( AccountExtension.O_OPERATING_UNIT, newCustomer.Oracle_Operating_Unit__c );
                System.assertEquals( AccountExtension.O_ORDER_TYPE, newCustomer.Oracle_Order_Type__c );
                System.assertEquals( AccountExtension.O_SALES_CHANNEL, newCustomer.Oracle_Sales_Channel__c );
            }
            
        }
    }
  
    
    static testmethod void testCreateCustomerForNAResidentialWithLease1() {       
        SFDCSpecialUtilities.isRunningTest = True;
        partnerUser = getPartnerUser1();
        System.runAs(partnerUser){ 
            ApexPages.currentPage().getParameters().put('RecordType',residentialCustomerRecordTypeId);
            ApexPages.StandardController stdCont = new ApexPages.StandardController(new Account());
            AccountNewController accountNewController = new AccountNewController(stdCont);
            accountNewController.newUrl='/apex/AccountNew?retURL=/001/o&ent=Account&save_new=1&sfdc.override=1';
            //PageReference pg = accountNewController.redirect();
            PageReference pg = Page.AccountNew;            
            Test.setCurrentPage(pg);
            AccountExtension accExtension  =  new AccountExtension(stdCont);
            System.assertNotEquals(null,pg);
            System.assertNotEquals(true,accExtension.isEUProfile);
            List<SelectOption> stateOption = accExtension.stateOption;
            List<SelectOption> langOption = accExtension.getPrefLangs();
            
            accExtension.opp.Name = 'TestNAResidOpp2';
            accExtension.opp.StageName = '75% - Customer Contract in place';
            accExtension.opp.Project_Stage__c='Deposit Sent';
            accExtension.opp.CloseDate = System.today();
            accExtension.newCustomer.Lease__c = true;
            accExtension.newCustomer.BillingCountry = 'India';
            accExtension.newCustomer.BillingCity = 'Hyderabad';
            accExtension.newCustomer.BillingState = 'Hyderabad';
            accExtension.newCustomer.BillingStreet = 'South City';
            accExtension.newCustomer.BillingPostalCode = '3021201';
            accExtension.newCustomer.Phone = '989145611';
            accExtension.newCustomer.Oracle_County__c = 'San Francisco';
            accExtension.validatedAddress = true;
            accExtension.newCustomer.Status__c = 'Active';
            accExtension.newCustomer.Type = 'Home Owner';
            accExtension.newCustomer.Phone='11 11 11 11 11';
            accExtension.newCustomer.PersonEmail = 'n@n.com';
            accExtension.newCustomer.Lat__c = 43.2151340000;
            accExtension.newCustomer.Log__c = 5.5371200000;
            accExtension.newCustomer.Theater__c ='Europe';

            pg = accExtension.saveAndQuote();                        
            
            Account newCustomer;
            List<Account> newCustomerList = [
            Select id, Name , RecordType.Name, BillingCountry, BillingCity,BillingStreet,BillingState,BillingPostalCode,
                ShippingCountry,ShippingCity,ShippingStreet,ShippingState,ShippingPostalCode, Oracle_Shipping_County__c,
                Partner_Portal_Registration__c, Lease__c, Oracle_County__c, Oracle_Sales_Channel__c,
                Oracle_Customer_Classification__c,Oracle_Warehouse__c,Oracle_Account_Type__c,
                Oracle_Operating_Unit__c,Oracle_Order_Type__c
                from Account where name = 'TestNAResidOpp1' and Partner_Portal_Registration__c = true];
            
            if(newCustomerList != null && newCustomerList.size() >0) {
                newCustomer = newCustomerList[0];
                system.debug('*****  newCustomer ' +newCustomer.Oracle_Warehouse__c);
            }
            System.debug( newCustomer);
            if(newCustomer!=null){
                System.assertEquals( newCustomer.BillingCountry, newCustomer.ShippingCountry );
                System.assertEquals( newCustomer.BillingCity , newCustomer.ShippingCity );
                System.assertEquals( newCustomer.Oracle_Shipping_County__c , newCustomer.Oracle_County__c );
                System.assertEquals(true,newCustomer.Partner_Portal_Registration__c);            
            
                System.assertEquals( AccountExtension.O_CUSTOMER_CLASSIFICATION, newCustomer.Oracle_Customer_Classification__c );
                System.assertEquals( partnerAccount.Oracle_Warehouse__c, newCustomer.Oracle_Warehouse__c);
                System.assertEquals( AccountExtension.O_ACCOUNT_TYPE, newCustomer.Oracle_Account_Type__c );
                System.assertEquals( AccountExtension.O_OPERATING_UNIT, newCustomer.Oracle_Operating_Unit__c );
                System.assertEquals( AccountExtension.O_ORDER_TYPE, newCustomer.Oracle_Order_Type__c );
                System.assertEquals( AccountExtension.O_SALES_CHANNEL, newCustomer.Oracle_Sales_Channel__c );
                
                Contact cTest = accExtension.createContact(newCustomer);
            }
            
        }
    }

    /*static testmethod void testCreateTPOFRAccountOpportunityContactForPartnerUsers(){
        ApexPages.StandardController stdCont = new ApexPages.StandardController(new Account());
        AccountExtension accExtension  =  new AccountExtension(stdCont);
        accExtension.saveAndQuote();
    }*/
    
    //MAM 21.MAR.2015 start uncomment test method
    static testmethod void testCreateCustomerForNAResidentialWithNoLease() {
        UserManagement.IS_TEST = true;
        Account testPartner = TestClassFactory.CreateDealer('TestDealer', 'North America');

        partnerContact = TestClassFactory.testContact('lastName', 'testpartnercon@noemail.com', TestClassFactory.retrieveRecordTypeID('Contact', 'Partner'));
        partnerContact.AccountId = testPartner.Id;
        partnerContact.Authorized_To_Order__c = TRUE;
        insert partnerContact;      
        
        UserRole role = [SELECT Id FROM UserRole WHERE Name LIKE '%Partner Executive' LIMIT 1];

        Id execProfileId = SFDCSpecialUtilities.getProfileIdByName('Partner Executive');

        User partnerUser2 = new User(alias = 'cashman1', email = partnerContact.Email, 
                          emailencodingkey='UTF-8', lastname='Testing', 
                          languagelocalekey='en_US', localesidkey='en_US', 
                          profileid = execProfileId,  country='United States', 
                          communityNickName = 'cashman1', timezonesidkey='America/Los_Angeles', 
                          username=string.valueOf(math.random())+'u1@testorg.com',
                          contactId=partnerContact.Id, UserRole = role);

        System.runAs(partnerUser2) {
            ApexPages.currentPage().getParameters().put('RecordType',residentialCustomerRecordTypeId);
            ApexPages.StandardController stdCont = new ApexPages.StandardController(new Account());
            AccountNewController accountNewController = new AccountNewController(stdCont);
            accountNewController.newUrl='/apex/AccountNew?retURL=/001/o&ent=Account&save_new=1&sfdc.override=1';
            PageReference pg = accountNewController.redirect();
            AccountExtension accExtension  =  new AccountExtension(stdCont);
            //System.assertNotEquals(null,pg);
            //System.assertNotEquals(true,accExtension.isEUProfile);
            accExtension.opp.Name = 'TestNAResidOpp1';
            accExtension.opp.CloseDate = System.today();
            accExtension.newCustomer.Lease__c = false;
            accExtension.newCustomer.BillingCountry = 'India';
            accExtension.newCustomer.BillingCity = 'Delhi';
            accExtension.newCustomer.BillingState = 'Delhi';
            accExtension.newCustomer.BillingStreet = 'South City';
            accExtension.newCustomer.BillingPostalCode = '3021001';
            accExtension.newCustomer.Phone = '989189111';
            pg = accExtension.save();
            
        }
    }
    
    
    static testmethod void testCreateCustomerForEUResidential() {
        User    sysAdminUser    = TestCommon.getSysAdminUser();
        User    partnerUser2    = null;
        Account partnerAccount2 = null;
        System.runAs(sysAdminUser){ 
            partnerAccount2 = TestCommon.getPartnerAccount();
            insert partnerAccount2;
            partnerUser2    = TestCommon.getEUPartnerPortalUser(partnerAccount2);
            
            //System.assertNotEquals(null,partnerUser2);
        }
        System.runAs(partnerUser2){ 
            ApexPages.currentPage().getParameters().put('RecordType',residentialCustomerRecordTypeId);
            ApexPages.StandardController stdCont = new ApexPages.StandardController(new Account());
            AccountNewController accountNewController = new AccountNewController(stdCont);
            accountNewController.newUrl='/apex/AccountNew?retURL=/001/o&ent=Account&save_new=1&sfdc.override=1';
            PageReference pg = accountNewController.redirect();
            AccountExtension accExtension  =  new AccountExtension(stdCont);
            //System.assertNotEquals(null,pg);
            //System.assertEquals(true,accExtension.isEUProfile);
            accExtension.opp.Name = 'TestEUResidOpp1';
            accExtension.opp.CloseDate = System.today();
            accExtension.newCustomer.BillingCountry = 'India';
            accExtension.newCustomer.BillingCity = 'Delhi';
            accExtension.newCustomer.BillingState = 'Delhi';
            accExtension.newCustomer.BillingStreet = 'South City';
            accExtension.newCustomer.BillingPostalCode = '3021001';
            accExtension.newCustomer.Phone = '989189111';
            pg = accExtension.save();
            //System.assertNotEquals(null,pg);
            Account newCustomer;
            List<Account> newCustomerList = [
            Select id, Name , RecordType.Name, BillingCountry, BillingCity,BillingStreet,BillingState,BillingPostalCode,
                ShippingCountry,ShippingCity,ShippingStreet,ShippingState,ShippingPostalCode, 
                Partner_Portal_Registration__c, Lease__c,
                Oracle_Customer_Classification__c,Oracle_Warehouse__c,Oracle_Account_Type__c,
                Oracle_Operating_Unit__c,Oracle_Order_Type__c
                from Account where name = 'TestEUResidOpp1' and Partner_Portal_Registration__c = true];
            
            if(newCustomerList != null && newCustomerList.size() >0) {
                newCustomer = newCustomerList[0];
                system.debug('*****  newCustomer ' +newCustomer.Name);
            }
            // System.assertEquals(newCustomer.ShippingCountry,newCustomer.BillingCountry);
            // System.assertEquals(newCustomer.ShippingCity,newCustomer.BillingCity);
            // System.assertEquals(true,newCustomer.Partner_Portal_Registration__c);
           
          pg= accExtension.cancel();
            
        }
    }
    //MAM 21.MAR.2015 end
    
     //Create Opportunity between user and account
        private static Opportunity createOpp(Account acct,User u){   
            Opportunity opp = new Opportunity();      
            opp.AccountId = acct.ID;
            opp.Name = 'TestNACommOpp1';
            opp.ownerId = u.Id;
            opp.CloseDate = System.today();
            opp.Reason_Won_Lost__c = 'Best Economics';
            opp.StageName = '12% Qualified Opportunity';
            opp.System_Size_KwP__c = 100;
            opp.Location_of_Installation__c = 'Metal Roof';
            opp.Mounting_System__c = 'PV Only';
            opp.ARRA_Compliance__c = 'Non ARRA';
                         
            return opp;
        }
    
    //MAM 21.MAR.2015 start uncomment test method
    static testmethod void testCreateCustomerForNACommercial() {
        
        UserManagement.IS_TEST = true;
        Account testPartner = TestClassFactory.CreateDealer('TestDealer', 'North America');

        partnerContact = TestClassFactory.testContact('lastName', 'testpartnercon@noemail.com', TestClassFactory.retrieveRecordTypeID('Contact', 'Partner'));
        partnerContact.AccountId = testPartner.Id;
        partnerContact.Authorized_To_Order__c = TRUE;
        insert partnerContact; 

        Account newCustomer = new Account(Name='NACommAcc1',CurrencyIsoCode='EUR',Theater__c='Test',
            BillingCity='testCity',BillingCountry='Test',BillingStreet='testStreet',BillingPostalCode='11111',
            ShippingCity='testCity',ShippingCountry='Test',ShippingStreet='testStreet',ShippingPostalCode='11111',
            Facility_State__c = 'India',Facility_City__c = 'testCity',Type='Other',
            Facility_Address__c = 'testStreet',Facility_Address_2__c ='testStreet2', Facility_Zip__c ='11111',
            Country_Domain__c = 'combo-it', RecordTypeId = commercialCustomerRecordTypeId);
            newCustomer.Partner_Portal_Registration__c = true;
            
            insert newCustomer;     
        
        UserRole role = [SELECT Id FROM UserRole WHERE Name LIKE '%Partner Executive' LIMIT 1];

        Id execProfileId = SFDCSpecialUtilities.getProfileIdByName('Partner Executive');

        User partnerUser2 = new User(alias = 'cashman1', email = partnerContact.Email, 
                          emailencodingkey='UTF-8', lastname='Testing', 
                          languagelocalekey='en_US', localesidkey='en_US', 
                          profileid = execProfileId,  country='United States', 
                          communityNickName = 'cashman1', timezonesidkey='America/Los_Angeles', 
                          username=string.valueOf(math.random())+'u1@testorg.com',
                          contactId=partnerContact.Id, UserRole = role);
        insert partnerUser2;

        newCustomer.OwnerId = partnerUser2.Id;
        update newCustomer;

        System.runAs(partnerUser2) { 
            
            
            
            system.debug('*** acc created  ' + newCustomer.Id); 
            Opportunity opp = createOpp(newCustomer,partnerUser2);
            opp.RecordTypeId = commercialRecordTypeId;
            opp.Partner_Portal_Registration__c = true;
            insert opp;
            
            Contact cont = new Contact(AccountID = newCustomer.id,FirstName='testconbyPO2',LastName='testconbyPO2');
            cont.Email ='te@test.com';
            cont.Authorized_to_Order__c = true;
            cont.Partner_Portal_Registration__c = true;
            insert cont;
            
                  
           ApexPages.currentPage().getParameters().put('RecordType',commercialCustomerRecordTypeId);
            ApexPages.StandardController stdCont = new ApexPages.StandardController(new Account());
            AccountNewController accountNewController = new AccountNewController(stdCont);
            accountNewController.newUrl='/apex/AccountNew?retURL=/001/o&ent=Account&save_new=1&sfdc.override=1';
            PageReference pg = accountNewController.redirect();
            AccountExtension accExtension  =  new AccountExtension(stdCont);
            //System.assertNotEquals(null,pg);
            //System.assertNotEquals(true,accExtension.isEUProfile);
            accExtension.opp.Name = 'TestNACommOpp1';
            accExtension.opp.CloseDate = System.today();
            accExtension.opp.StageName = '12% Qualified Opportunity';
            accExtension.opp.System_Size_KwP__c = 100;
            accExtension.opp.Location_of_Installation__c = 'Metal Roof';
            accExtension.opp.Mounting_System__c = 'PV Only';
            accExtension.opp.ARRA_Compliance__c = 'Non ARRA';
            accExtension.newCustomer.BillingCountry = 'India';
            accExtension.newCustomer.BillingCity = 'Delhi';
            accExtension.newCustomer.BillingState = 'Delhi';
            accExtension.newCustomer.BillingStreet = 'South City';
            accExtension.newCustomer.BillingPostalCode = '3021001';
            accExtension.newCustomer.Phone = '989189111';            
            
            pg = accExtension.save();
            
            
             
            Test.startTest();
             
            ApexPages.currentPage().getParameters().put('RecordType',commercialCustomerRecordTypeId);
            ApexPages.currentPage().getParameters().put('id',newCustomer.Id);
            ApexPages.currentPage().getParameters().put('isEdit','Y');
            stdCont = new ApexPages.StandardController(newCustomer); 
            accExtension  =  new AccountExtension(stdCont);

            accExtension.newCustomer.BillingCountry = 'US';
            accExtension.newCustomer.BillingCity = 'GGN';
            accExtension.newCustomer.BillingState = 'GGN';
            accExtension.newCustomer.BillingStreet = 'NA Max';
            accExtension.newCustomer.BillingPostalCode = '981911';
            accExtension.newCustomer.Phone = '99999901';
            accExtension.opp.Project_Stage__c = 'Qualification in Process';
            accExtension.opp.PO_Receipt_Date__c = System.today();
            accExtension.opp.System_Size_KwP__c = 200;
            accExtension.opp.Deposit_received__c =System.today() +4;
            accExtension.opp.ARRA_Compliance__c = 'ARRA';
            accExtension.opp.Projected_Delivery_Date__c = System.today() +5;
            accExtension.opp.Installation_Date__c = System.today() +1;
            accExtension.opp.Warranty__c = '10 Year (Included)';
            accExtension.opp.Facility_Address_2__c = 'Address 2';
            accExtension.opp.Financing_Status__c = 'Cash';
            accExtension.opp.Financing_Options_Provided_date__c =System.today();
            accExtension.opp.Financing_Application_Submitted__c = true;
            accExtension.opp.Financing_in_Place_date__c =System.today();
            accExtension.opp.Rebate_Confirmed__c=true;
            accExtension.opp.Location_of_Installation__c ='Carport';
            accExtension.opp.Invertor__c = 'SPR-111';
            accExtension.opp.Mounting_System__c = 'PV Only';
              
            accExtension.opp.EPA_Requested__c =System.today();
            accExtension.opp.EPA_Generated__c =System.today()+1;
            accExtension.opp.Ground_or_Roof_Space__c ='11';
            accExtension.opp.Zone_Monitoring__c = 'Yes';
            accExtension.opp.Utility_Voltage__c = '202';
            accExtension.opp.Number_of_Sites_to_Install_Solar__c = '2';
            accExtension.opp.Grounding__c = 'Positive';
            accExtension.opp.Site_Audit_Review_Status__c ='On Hold';
            accExtension.opp.Revision__c = 11;
            accExtension.opp.Site_Audit_Form_Received__c = System.today();
            accExtension.opp.Site_Audit_Complete__c = System.today()+10;
            accExtension.opp.Inspection_Date__c = System.today()+7;
            accExtension.opp.Final_Inspection_Schedule_Date__c = System.today()+11;
            accExtension.opp.Inspection_Report_Sent__c= System.today()+11;
            accExtension.opp.Final_Insp_Report_Sent__c= System.today()+12;

            Opportunity tempOpp = accExtension.createOpportunity(newCustomer, cont);
            
            pg = accExtension.save();

            pg= accExtension.cancel();
             
        }
    }
    //MAM 21.MAR.2015 end

    
    static testmethod void testUpdateDetails() {
        SFDCSpecialUtilities.isRunningTest = True; 
        
        Account newAccount = TestUtils.createAccount('IAMTEST', TestUtils.getPartnerRecordTypeId(), false);
        newAccount.Oracle_Account_Number__c = 'IAMTEST-12345';
        insert newAccount;
        
        Contact newContact = TestUtils.createContact('IAMALSOTEST', newAccount.Id, false);
        newContact.Email ='myname@test.com';
        insert newContact;
        
        UserManagement.IS_TEST = true;
        User newUser = testUtils.createPartnerPortalUser(newContact, false);
        newUser.Username = 'IAMTESTUSER@test.com';
        newUser.CommunityNickname = 'IAMTESTUSER';
        insert newUser;
        
        Opportunity newOpp = createOpp(newAccount, newUser);
        newOpp.Name = 'TESTOPP';
        insert newOpp;
        
        ApexPages.Standardcontroller stdCtrl;
        AccountExtension acctExt;
        
        partnerUser = getPartnerUser();
        System.runAs( partnerUser ){
            PageReference pg = Page.AccountNew;            
            Test.setCurrentPage(pg);
            stdCtrl = new ApexPages.Standardcontroller( new Account() );
            acctExt = new AccountExtension ( stdCtrl );
        }
        
        Test.startTest();
            try {
                acctExt.updateDetails(newOpp, newAccount, newContact);
            }
            catch (DmlException e) {
            }
        Test.stopTest();
        
        //System.assertEquals();
    }
    
    //MAM 20.MAR.2015 uncomment out the test class for code coverage increase 
    static testmethod void testCancel() {
        ApexPages.Standardcontroller stdCtrl;
        AccountExtension acctExt;

        Test.startTest();   
        partnerUser = getPartnerUser();  
           
        System.runAs( partnerUser ){
            PageReference pg = Page.AccountNew;            
            Test.setCurrentPage(pg);
            ApexPages.currentPage().getParameters().put('isEdit', 'Y');
            
            stdCtrl = new ApexPages.Standardcontroller( new Account() );
            acctExt = new AccountExtension ( stdCtrl );
            
            //For isEdit = Y
            acctExt.isEdit = 'Y'; 
            PageReference pageref = acctExt.cancel();
            
            //recTypeId = commercialCustomerRecordTypeId 
            acctExt.isEdit = 'N'; 
            acctExt.recTypeId = commercialCustomerRecordTypeId;
            pageref = acctExt.cancel(); 
            
            //recTypeId  = residentialRecordTypeId
            acctExt.recTypeId = residentialRecordTypeId;
            pageref = acctExt.cancel(); 
        }                
        Test.stopTest();
        
        /*ApexPages.Standardcontroller stdCtrl;
        AccountExtension acctExt;
        
        System.runAs( partnerUser ){
            stdCtrl = new ApexPages.Standardcontroller( new Account() );
            acctExt = new AccountExtension ( stdCtrl );
        }
        
        ApexPages.currentPage().getParameters().put('isEdit', 'Y');
        
        Test.startTest();
            PageReference pageref = acctExt.cancel();
        Test.stopTest();*/
    }
    //MAM 20.MAR.2015 end
}