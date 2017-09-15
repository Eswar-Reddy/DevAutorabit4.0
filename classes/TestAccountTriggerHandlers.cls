/*************************
 * Test Class Cases for Account Handlers
 * 2/2/2015
 * Crystal, Praveen
 * **********************/

@isTest
public class TestAccountTriggerHandlers {
    
    //Constants
    static Id HomeOwnerRecTypeId = AccountHandlerUtilities.ResidentialRecTypeId;
    static Id PartnerRecTypeId = AccountHandlerUtilities.PartnerRecTypeId;
    
    //*********Data Initialization methods**************************//
    
    //mock custom trigger skip setting creation
    private static void createMockSettings() {
        List<Trigger_By_Pass__c> byPassSettingsList = new List<Trigger_By_Pass__c>();
        //bypass Account trigger
        Trigger_By_Pass__c AccountbyPass = new Trigger_By_Pass__c();
        AccountbyPass.Name = 'Account';
        AccountbyPass.Is_Active__c = false;
        byPassSettingsList.add(AccountbyPass);
        //bypass AccountCreateShipBillTos trigger
        Trigger_By_Pass__c ShipBillTosbyPass = new Trigger_By_Pass__c();
        ShipBillTosbyPass.Name = 'AccountCreateShipBillTos';
        ShipBillTosbyPass.Is_Active__c = false;
        byPassSettingsList.add(ShipBillTosbyPass);
        //bypass AccountsPartnerAccount trigger
        Trigger_By_Pass__c AccountsPartnerAccountbyPass = new Trigger_By_Pass__c();
        AccountsPartnerAccountbyPass.Name = 'AccountsPartnerAccount';
        AccountsPartnerAccountbyPass.Is_Active__c = false;
        byPassSettingsList.add(AccountsPartnerAccountbyPass);
        //bypass accountOwnerUpdate trigger
        Trigger_By_Pass__c accountOwnerUpdatebyPass = new Trigger_By_Pass__c();
        accountOwnerUpdatebyPass.Name = 'accountOwnerUpdate';
        accountOwnerUpdatebyPass.Is_Active__c = false;
        byPassSettingsList.add(accountOwnerUpdatebyPass);
        //bypass afterAccountInsert trigger
        Trigger_By_Pass__c afterAccountInsertbyPass = new Trigger_By_Pass__c();
        afterAccountInsertbyPass.Name = 'afterAccountInsert';
        afterAccountInsertbyPass.Is_Active__c = false;
        byPassSettingsList.add(afterAccountInsertbyPass);
        //bypass afterAccountUpdate trigger
        Trigger_By_Pass__c afterAccountUpdatebyPass = new Trigger_By_Pass__c();
        afterAccountUpdatebyPass.Name = 'afterAccountUpdate';
        afterAccountUpdatebyPass.Is_Active__c = false;
        byPassSettingsList.add(afterAccountUpdatebyPass);
        //bypass afterInsertUpdateAccSIC trigger
        Trigger_By_Pass__c afterInsertUpdateAccSICbyPass = new Trigger_By_Pass__c();
        afterInsertUpdateAccSICbyPass.Name = 'afterInsertUpdateAccSIC';
        afterInsertUpdateAccSICbyPass.Is_Active__c = false;
        byPassSettingsList.add(afterInsertUpdateAccSICbyPass);
        //bypass beforeAccountInsert trigger
        Trigger_By_Pass__c beforeAccountInsertbyPass = new Trigger_By_Pass__c();
        beforeAccountInsertbyPass.Name = 'beforeAccountInsert';
        beforeAccountInsertbyPass.Is_Active__c = false;
        byPassSettingsList.add(beforeAccountInsertbyPass);
        //bypass beforeAccountUpdate trigger
        Trigger_By_Pass__c beforeAccountUpdatebyPass = new Trigger_By_Pass__c();
        beforeAccountUpdatebyPass.Name = 'beforeAccountUpdate';
        beforeAccountUpdatebyPass.Is_Active__c = false;
        byPassSettingsList.add(beforeAccountUpdatebyPass);
        //bypass checkAccountDuplicate trigger
        Trigger_By_Pass__c checkAccountDuplicatebyPass = new Trigger_By_Pass__c();
        checkAccountDuplicatebyPass.Name = 'checkAccountDuplicate';
        checkAccountDuplicatebyPass.Is_Active__c = false;
        byPassSettingsList.add(checkAccountDuplicatebyPass);
        //bypass InsertGeo trigger
        Trigger_By_Pass__c InsertGeobyPass = new Trigger_By_Pass__c();
        InsertGeobyPass.Name = 'InsertGeo';
        InsertGeobyPass.Is_Active__c = false;
        byPassSettingsList.add(InsertGeobyPass);
        //bypass SetGeolocation trigger
        Trigger_By_Pass__c SetGeolocationbyPass = new Trigger_By_Pass__c();
        SetGeolocationbyPass.Name = 'SetGeolocation';
        SetGeolocationbyPass.Is_Active__c = false;
        byPassSettingsList.add(SetGeolocationbyPass);
        //bypass UpdateOppOnAcctOwnerChange trigger
        Trigger_By_Pass__c UpdateOppOwnerbyPass = new Trigger_By_Pass__c();
        UpdateOppOwnerbyPass.Name = 'UpdateOppOnAcctOwnerChange';
        UpdateOppOwnerbyPass.Is_Active__c = false;
        byPassSettingsList.add(UpdateOppOwnerbyPass);
        //bypass UpdatePrimaryContactDetails trigger
        Trigger_By_Pass__c UpdatePrimaryContactbyPass = new Trigger_By_Pass__c();
        UpdatePrimaryContactbyPass.Name = 'UpdatePrimaryContactDetails';
        UpdatePrimaryContactbyPass.Is_Active__c = false;
        byPassSettingsList.add(UpdatePrimaryContactbyPass);
        //activate AccountTrigger
        Trigger_By_Pass__c AccountTriggerbyPass = new Trigger_By_Pass__c();
        AccountTriggerbyPass.Name = 'AccountTrigger';
        AccountTriggerbyPass.Is_Active__c = true;
        byPassSettingsList.add(AccountTriggerbyPass);
        
        insert byPassSettingsList;
    }
    
    //TestMethod for residential account before and after insert trigger handlers
    public static TestMethod void testBeforeandAfterInsert() {
        
        createMockSettings();
        
        Util.isSkipTrigger('Account',null);
        Util.isSkipTrigger('AccountCreateShipBillTos', null);
        Util.isSkipTrigger('afterAccountInsert', null);
        Util.isSkipTrigger('afterInsertUpdateAccSIC', null);
        Util.isSkipTrigger('beforeAccountInsert', null);
        Util.isSkipTrigger('beforeAccountUpdate', null);
        Util.isSkipTrigger('checkAccountDuplicate', null);
        Util.isSkipTrigger('Insertgeo', null);
        Util.isSkipTrigger('SetGeolocation', null);
        Util.isSkipTrigger('UpdateOppOnAcctOwnerChange', null);
        Util.isSkipTrigger('UpdatePrimaryContactDetails', null);
        
        //mock dealer general settings
        DealerGeneral__c dg = TestClassFactory.testDealerGeneralSetting();
        insert dg;
        
        //insert country reference for theater lookup
        Country_Reference__c cr = new Country_Reference__c();
        cr.Country__c = 'United States';
        cr.Theater__c = 'North America';
        insert cr;
        
        //Vertex table data
        Vertex_Address_Validation__c vertexCounty = new Vertex_Address_Validation__c();
        vertexCounty.Geo_City__c = 'Denver';
        vertexCounty.Geo_Country__c = 'United States';
        vertexCounty.Geo_State__c = 'CO';
        vertexCounty.Geo_Postal_Code__c = '80000';
        vertexCounty.Geo_County__c = 'Jefferson';
        insert vertexCounty;
        
        //Mock SIC data
        SIC__c fakeSIC = TestClassFactory.testSIC();
        insert fakeSIC;
        
        
        //begin making residential account for insert trigger testing
        Account mockHomeOwnerAcct = TestClassFactory.testAccount('John Doe', HomeOwnerRecTypeId);
        mockHomeOwnerAcct.BillingCountry = 'US';
        mockHomeOwnerAcct.Sic = fakeSIC.SIC_Code__c;
        
        Test.startTest();
        insert mockHomeOwnerAcct;
        Test.stopTest();
        
        System.assertNotEquals(mockHomeOwnerAcct.Id, null);
        
        Account results = [SELECT Id, BillingCountry, ShippingCountry, BillingStreet, ShippingStreet, BillingState, ShippingState,
                                  BillingPostalCode, ShippingPostalCode, ShippingCity, BillingCity, Theater__c, Oracle_County__c,
                                  AccountNumber, Integration_Id__c, ACBParanet_Id__c, Country_Domain__c, Geolocation__Longitude__s, Geolocation__Latitude__s,
                                  First_Level_SIC_Name__c, Second_Level_SIC_Name__c, Third_Level_SIC_Name__c, SPWR_Industry_Type__c
                           FROM Account
                           WHERE ID =: mockHomeOwnerAcct.Id];
        System.debug(results);
        System.assertEquals('United States', results.BillingCountry);
        System.assertEquals('12345 Main St', results.BillingStreet); //System.assertEquals(results.ShippingStreet, results.BillingStreet);
        System.assertEquals('Denver', results.BillingCity);
        System.assertEquals('CO', results.BillingState);
        System.assertEquals('80000', results.BillingPostalCode);
        System.assertEquals('United States', results.BillingCountry);
        System.assertNotEquals(null, results.Oracle_County__c);
        System.assertNotEquals(null, results.ACBParanet_ID__c);
        System.assertNotEquals(null, results.AccountNumber);
        System.assertNotEquals(null, results.Integration_ID__c);
        System.assertNotEquals(null, results.First_Level_SIC_Name__c);
        System.assertNotEquals(null, results.Second_Level_SIC_Name__c);
        System.assertNotEquals(null, results.Third_Level_SIC_Name__c);
        System.assertNotEquals(null, results.SPWR_Industry_Type__c);
        System.assertEquals('North America', results.Theater__c); 
        
        //Added By NDeGuzman 04.24.15
        //Fix to increase the code coverage
        Set<Id> accId = new Set<Id>();
            accId.add(mockHomeOwnerAcct.Id);
        AccountHandlerUtilities.loadPartnerAccounts(accId);
        //END
        
        Ship_To_Site__c ShipTo = [SELECT Id, Dealer_Account__r.Id FROM Ship_To_Site__c WHERE Residential_Customer_Account__r.Id =: mockHomeOwnerAcct.Id];
        System.assertNotEquals(ShipTo.id, null);
        
        Bill_To_Site__c BillTo = [SELECT Id, Dealer_Account__r.Id FROM Bill_To_Site__c WHERE Dealer_Account__r.Id =: mockHomeOwnerAcct.Id];
        //System.assertNotEquals(BillTo.Id, null);
        //TO DOs **********
        
    }

    //TestMethod for testing partner record type logic on Before and After insert handlers    
    static TestMethod void testPartnerBeforeandAfterInsert() {
        
        createMockSettings();
        
        Util.isSkipTrigger('Account',null);
        Util.isSkipTrigger('AccountCreateShipBillTos', null);
        Util.isSkipTrigger('afterAccountInsert', null);
        Util.isSkipTrigger('afterInsertUpdateAccSIC', null);
        Util.isSkipTrigger('beforeAccountInsert', null);
        Util.isSkipTrigger('beforeAccountUpdate', null);
        Util.isSkipTrigger('checkAccountDuplicate', null);
        Util.isSkipTrigger('Insertgeo', null);
        Util.isSkipTrigger('SetGeolocation', null);
        Util.isSkipTrigger('UpdateOppOnAcctOwnerChange', null);
        Util.isSkipTrigger('UpdatePrimaryContactDetails', null);
        
        //mock dealer general settings
        DealerGeneral__c dg = TestClassFactory.testDealerGeneralSetting();
        insert dg;
        
        //insert country reference for theater lookup
        Country_Reference__c cr = new Country_Reference__c();
        cr.Country__c = 'United States';
        cr.Theater__c = 'North America';
        insert cr;
        
        //Vertex table data
        Vertex_Address_Validation__c vertexCounty = new Vertex_Address_Validation__c();
        vertexCounty.Geo_City__c = 'Denver';
        vertexCounty.Geo_Country__c = 'United States';
        vertexCounty.Geo_State__c = 'CO';
        vertexCounty.Geo_Postal_Code__c = '80000';
        vertexCounty.Geo_County__c = 'Jefferson';
        insert vertexCounty;

        //create 2 fake partners to kick off the csat cycle map
        Account partner1 = TestClassFactory.testAccount('TestPartner1', PartnerRecTypeId);
        partner1.Status__c = 'Active';
        partner1.CSAT_Cycle_Code__c = '1';
        partner1.Type = 'Partner-Commercial';
        partner1.Theater__c = 'North America';
        insert partner1;
        
        Account partner2 = TestClassFactory.testAccount('TestPartner2', PartnerRecTypeId);
        partner2.Status__c = 'Active';
        partner2.CSAT_Cycle_Code__c = '2';
        partner2.Type = 'Premier-Partner-Combo';
        partner2.Theater__c = 'North America';
        insert partner2; 
        
        Account mockPartnerAcct = TestClassFactory.testAccount('SuperSolarPower', PartnerRecTypeId);
        mockPartnerAcct.Type = 'Premier-Partner-Residential'; 
        mockPartnerAcct.Dealer_Score_Total__c = 78;
        mockPartnerAcct.Dealer_Locator_Phone__c = '888-888-8888';
        mockPartnerAcct.Phone = '888-888-8888';
        mockPartnerAcct.website = 'www.sunpowercorp.com';
        mockPartnerAcct.Oracle_Account_Number__c = '123';
        mockPartnerAcct.Status__c = 'Active';
        mockPartnerAcct.Geolocation__Latitude__s = 39.718887;
        mockPartnerAcct.Geolocation__Longitude__s = -104.974036;
        mockPartnerAcct.Theater__c = 'North America';
        
        //Added By NDeGuzman 04.24.15
        //Fix to increase the code coverage
        Set<Id> accId = new Set<Id>();
            accId.add(mockPartnerAcct.Id);
        AccountHandlerUtilities.loadPartnerAccounts(accId);
        
        List<Account> accList = new List<Account>();
            accList.add(mockPartnerAcct);
        //END
        
        Test.startTest();
            insert mockPartnerAcct;
        system.debug('MOCK: ' + mockPartnerAcct);
        Test.stopTest();
        
        System.assertNotEquals(mockPartnerAcct.Id, null);
        
        Account results = [SELECT Id, CSAT_Cycle_Code__c, Theater__c, Country_Domain__c, Line_of_Business__c, AccountNumber, Status__c,
                                  ACBParanet_ID__c, Integration_ID__c
                           FROM Account
                           WHERE Id =: mockPartnerAcct.Id];
        System.debug(results);
        System.assertNotEquals(results.CSAT_Cycle_Code__c, null);
        System.assertEquals(results.Country_Domain__c, 'rvar-us');
        System.assertNotEquals(null, results.AccountNumber);
        System.assertNotEquals(null, results.ACBParanet_ID__c);
        System.assertNotEquals(null, results.Integration_ID__c);
                
        Business_Registration__c brResult = [SELECT Id, Account__c FROM Business_Registration__c WHERE Account__c =: results.Id];
        System.AssertEquals(brResult.Account__c, results.Id); 
        
    }

}