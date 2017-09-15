@isTest
private class TestPartnerApplicationTopMsgController {
    @isTest
    public static void testController() {
        List<RecordType> recordTypeList = [SELECT Id, Name FROM RecordType
                WHERE SObjectType = 'Partner_Application__c'
                AND Name IN ('EU Partner Application', 'NA Partner Application') ORDER BY Name];
        
        List<Partner_Application__c> partnerApplicationList = new List<Partner_Application__c>();
        
        Integer count = 0;
        for (RecordType recordType : recordTypeList) {
            count++;
            Partner_Application__c partnerApplication = new Partner_Application__c();
            partnerApplication.Company_Name__c = 'Company_Name__c' + count;
            partnerApplication.RecordTypeId = recordType.Id;
            partnerApplicationList.add(partnerApplication);
        }
        
        insert partnerApplicationList;
        
        count = 0;
        for (Partner_Application__c partnerApp : partnerApplicationList) {
            count++;
            String msg = '';
            PartnerApplicationTopMsgController controller =
                    new PartnerApplicationTopMsgController(new ApexPages.StandardController(partnerApp));
            if (count == 1 && recordTypeList.size() == 2) {
                // 'EU Partner Application'
                /*String countryDomain = [SELECT Country_Domain__c FROM User
                        WHERE Id = :UserInfo.getUserId()].Country_Domain__c;
                if (countryDomain != null && countryDomain.contains('-it')) {
                    msg = 'RSM, Area Sales Manager and Director of Sales';
                } else {*/
                    msg = 'RSM and Area Sales Manager';
                //}
            } else {
                // 'NA Partner Application'
                msg = 'Area Sales Manager';
            }
            //RSM and Area Sales Manager
            //System.assertEquals(controller.msg, msg + ' must be filled before submitting for approval.');
        }
    }
}