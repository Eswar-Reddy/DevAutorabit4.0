//Test Class for ModulesListREST
@isTest
private class TestModulesListREST {
    
    @TestSetup
    public static void testDataSetup() {
        Price_List__c priceList = TestClassFactory.createPriceList();
        ModulesListREST mlRest = new ModulesListREST();
    }
    
    static TestMethod void testMethod1(){
        Test.startTest();
        ModulesListREST.Response mlRResp = new ModulesListREST.Response();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.httpMethod = 'GET';
        //operatingUnit=SPNA OU&state=NY&quoteTypes=Cash,Loan,Lease&salesMethodology=Quote&sector=Residential
        //&channel=Indirect&partnerAccountId=0018000000UqMSFAA3
        req.addParameter('operatingUnit', 'SPNA OU');
        req.addParameter('state', 'CO');
        req.addParameter('sector', 'Residential');
        req.addParameter('channel', 'Indirect');
        req.addParameter('quoteTypes', 'Cash,Loan,Lease');
        req.addParameter('salesMethodology', 'Order');
        req.addParameter('includeDiscontinuedModules','false');
        //req.addParameter('partnerAccountId', '0018000000UqMSFAA3');
        RestContext.request = req;
        RestContext.response = res;
        
        mlRResp = ModulesListREST.doGet();
        Test.stopTest();
    }
}