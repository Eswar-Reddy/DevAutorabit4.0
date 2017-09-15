@isTest
private class SPVTFailInvocableTest {

    private static testMethod void test_spdNotification() {
        SPVTFailInvocableTestData td = new SPVTFailInvocableTestData();    
        td.CreateTestData();
        
        List <SPVTFailInvocable.Request> reqList = new List <SPVTFailInvocable.Request>();
        SPVTFailInvocable.Request req_1 = new SPVTFailInvocable.Request();
        SPVTFailInvocable.Request req_2 = new SPVTFailInvocable.Request();
        reqList.add(req_1);
        reqList.add(req_2);
        
        List <SPVTFailInvocable.Response> resList = SPVTFailInvocable.getSettings(reqList);
        for (SPVTFailInvocable.Response res : resList) {
            system.assertEquals('Test Direct', res.spdAccountName);        
            system.assertEquals('test@sp.com', res.spdNotificationEmail);        
            system.assertEquals('Test User', res.spdNotificationName);        
            system.assertEquals('xxxxx', res.caseOwnerId);        
            system.assertEquals('yyyyy', res.caseRecordTypeId);        
        }
    }
    
}