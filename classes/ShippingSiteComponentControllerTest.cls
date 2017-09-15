@isTest(SeeAllData=true)
private class ShippingSiteComponentControllerTest {

    @isTest static void test_method_one() {
        Account testPartner = TestClassFactory.CreateDealer('dealerName', 'North America');
        //Get record types to be tested
        Id dwRecordTypeId =  Schema.SObjectType.Ship_to_Site__c.getRecordTypeInfosByName().get('Dealer Warehouse').getRecordTypeId();
        Id isRecordTypeId =  Schema.SObjectType.Ship_to_Site__c.getRecordTypeInfosByName().get('Installation Site').getRecordTypeId();
        //Instantiate object
        ShippingSiteComponentController sscc = new ShippingSiteComponentController();
        sscc.getCountryCodes();
        sscc.compControllerTest2();
        //Create new records
        Ship_to_Site__c sts = new Ship_to_Site__c();
        sts.Address1__c = '1st Ave S';
        sts.City__c = 'Richmond';
        sts.State__c = 'GA';
        sts.Country__c = 'USA';
        sts.Zip__c = '30901';
        sts.SiteID__c = '01010102';
        sts.RecordTypeId = dwRecordTypeId;
        sts.Status__c = 'Active';
        sts.Oracle_Operating_Unit__c = 'SPNA OU';
        sts.Dealer_Account__c = testPartner.Id;
        //Test Dealer Warehouse
        String recordString = JSON.serialize(sts);
        ShippingSiteComponentController.saveShippingSite(recordString,'Dealer Warehouse');
        //Test Installation Site
        sts.RecordtypeId = isRecordTypeId;
        recordString = JSON.serialize(sts);
        ShippingSiteComponentController.saveShippingSite(recordString,'Installation Site');
        //Test single vertex data
        sts.Address1__c = '1st Ave S';
        sts.City__c = 'Fredonia (Biscoe)';
        sts.State__c = 'AR';
        sts.Country__c = 'USA';
        sts.Zip__c = '72017';
        sts.SiteID__c = '01010103';
        ResultMessage rm = ShippingSiteComponentController.saveShippingSite(recordString,'Installation Site');
    }
}