@isTest
private class TestQualificationServices
{

    static testMethod void testGetQualificationByFormId()
    {
    	Qualification__c USQualification = new Qualification__c(Name='US');
    	insert USQualification;

    	Qualification_Rule__c qr = new Qualification_Rule__c();
    	qr.Qualification__c = USQualification.Id;
    	qr.Field_API_Name__c = 'Roof_Orientation__c';
    	qr.Accepted_Values__c = 'East';
    	qr.Field_Type__c = QualificationServices.TEXT_RULE_TYPE;

    	insert qr;

    	Dynaform__c form = new Dynaform__c(Name='Basic test landing page');
    	form.Qualification__c = USQualification.Id;
    	insert form;

        Test.startTest();

        	Qualification__c returnedQualification = QualificationServices.getQualificationByFormId( form.Id );

        Test.stopTest();

        System.assertEquals( USQualification.Id, returnedQualification.Id, 'The qualification related to the Form should be returned.');
        System.assertEquals( 1, returnedQualification.Qualification_Rules__r.size(), 'The qualification should be returned with its related qualificationRules.');
        System.assertEquals( qr.Id, returnedQualification.Qualification_Rules__r[0].Id, 'The qualification should be returned with its related qualificationRules.');
    }

    static testMethod void testGetQualificationByFormId_noQualification()
    {
    	Dynaform__c form = new Dynaform__c(Name='Basic test landing page');
    	insert form;

        Test.startTest();

        	Qualification__c returnedQualification = QualificationServices.getQualificationByFormId( form.Id );

        Test.stopTest();

        System.assertEquals( null, returnedQualification, 'Nothing should be returned when the form has no related Qualification.');
    }
}