/**
 * Created by chaitoo on 3/7/17.
 */

@IsTest
private class TestProductConfigurationREST {

    @TestSetup
    public static void testDataSetup() {
        Price_List__c priceList = TestClassFactory.createPriceList();
    }

    static testMethod void testMethod1() {
        Test.startTest();
        ProductConfigurationREST.Response mlRResp = new ProductConfigurationREST.Response();
		
        List<Id> listIds = new List<Id>();
        List<Master_Configurator__c> masterConfigList = new List<Master_Configurator__c>([select Id from Master_Configurator__c]);
        
        for(Master_Configurator__c mc:masterConfigList){
            listIds.add(mc.Id);
        }
        
        mlRResp = ProductConfigurationREST.doPost(listIds);
        Test.stopTest();
    }
}