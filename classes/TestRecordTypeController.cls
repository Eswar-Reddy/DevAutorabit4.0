@isTest
private class TestRecordTypeController
{
        @isTest
        static void basicTest()
        {
                Test.startTest();
                PageReference pageRef = new PageReference('/apex/AccountNewRedirectPortal');
                Test.setCurrentPage(pageRef);
                RecordTypeController fac=new RecordTypeController();
                fac.objectTypeString='Account';
                List<SelectOption> sos=fac.getRecordTypes();
                System.assert(sos!=null);
                System.assert(sos.size()>0);
                Map<String, String> descMasp = fac.getRecordTypeDescriptions();
                System.assert(descMasp!=null);
                descMasp = RecordTypeController.getAvailableRecordTypeDescriptionsForSObject(Account.SObjectType);
                System.assert(descMasp!=null);
                fac.submit();
                fac.cancel();
                Test.stopTest();
        }

        @isTest
        static void surveyTest()
        {
                Test.startTest();
                PageReference pageRef = new PageReference('/apex/SatSurveyNewRedirectPortal');
                Test.setCurrentPage(pageRef);
                RecordTypeController fac=new RecordTypeController();
                fac.objectTypeString='X1Y_Satisfaction_Survey_Result__c';
                List<SelectOption> sos=fac.getRecordTypes();
                System.assert(sos!=null);
                System.assert(sos.size()>0);
                Map<String, String> descMasp = fac.getRecordTypeDescriptions();
                System.assert(descMasp==null); // there are none
                descMasp = RecordTypeController.getAvailableRecordTypeDescriptionsForSObject(X1Y_Satisfaction_Survey_Result__c.SObjectType);
                System.assert(descMasp!=null);
                fac.submit();
                fac.objectTypeString='Customer_Survey_Result__c';
                sos=fac.getRecordTypes();
                System.assert(sos!=null);
                System.assert(sos.size()>0);
                descMasp = fac.getRecordTypeDescriptions();
                descMasp = RecordTypeController.getAvailableRecordTypeDescriptionsForSObject(Customer_Survey_Result__c.SObjectType);
                fac.submit();
                fac.objectTypeString='Post_Visit_Follow_Up_Survey__c';
                sos=fac.getRecordTypes();
                System.assert(sos!=null);
                System.assert(sos.size()>0);
                descMasp = fac.getRecordTypeDescriptions();
                descMasp = RecordTypeController.getAvailableRecordTypeDescriptionsForSObject(Post_Visit_Follow_Up_Survey__c.SObjectType);
                fac.submit();
                Test.stopTest();
        }       
    
}