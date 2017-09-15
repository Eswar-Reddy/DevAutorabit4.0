//Test Class for RackingCalculationREST
@isTest
private class TestRackingCalculationREST {
    
    @TestSetup
    public static void testDataSetup() {
        Price_List__c priceList = TestClassFactory.createPriceList();
        RackingCalculationREST RCalRest = new RackingCalculationREST();
    }
    //Usage - /services/apexrest/getRackingCalculation?moduleConfigurationId=a6k340000003zUc&masterConfigurationIds=a6h34000000CcQ5,a6hM0000000Cdvv&ModuleCount=27
    static TestMethod void testMethod1(){
        Test.startTest();
        RackingCalculationREST.Response RCalResponse = new RackingCalculationREST.Response();
        Master_Configurator__c masterConf = [select Id from Master_Configurator__c limit 1];
        Module_Configuration__c moduleConf = [select Id from Module_Configuration__c limit 1];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.httpMethod = 'GET';
        req.addParameter('moduleConfigurationId', moduleConf.Id);
        req.addParameter('masterConfigurationIds', masterConf.id);
        req.addParameter('ModuleCount', '27');
        RestContext.request = req;
        RestContext.response = res;
        
        RCalResponse = RackingCalculationREST.doGet();
        Test.stopTest();
    }
}