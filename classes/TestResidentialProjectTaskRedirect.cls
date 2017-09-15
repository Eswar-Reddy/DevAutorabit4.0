@isTest
private class TestResidentialProjectTaskRedirect
{
    @isTest
    static void testNew()
    {
        Project_Task__c myDoc = new Project_Task__c();
        ApexPages.StandardController sc = new ApexPages.StandardController(myDoc);

        ResidentialProjectNewTaskRedirect redirect = new ResidentialProjectNewTaskRedirect(sc);
        PageReference pr = redirect.redirect();
        System.assert(pr != null);
    }

    @isTest
    static void testDetail()
    {
        Project_Task__c myDoc = new Project_Task__c();
        ApexPages.StandardController sc = new ApexPages.StandardController(myDoc);

        ResidentialProjectTaskRedirect redirect = new  ResidentialProjectTaskRedirect(sc);
        PageReference pr = redirect.redirect();
        System.assert(pr != null);
    }

    @isTest
    static void testEdit()
    {
        Account testPartner = TestClassFactory.CreateDealer('TestDealer', 'North America');
        
        Id rptId = Schema.SObjectType.Residential_Project__c.getRecordTypeInfosByName().get('Project Template').getRecordTypeId();

        Residential_Project__c resProj = new Residential_Project__c();
        resProj.RecordTypeId = rptId;
        resProj.Account__c = testPartner.Id;
        resProj.Status__c = 'Active'; //Hold, Cancelled or Completed
        resProj.Name = 'SPD Template';
        resProj.CurrencyIsoCode = 'USD';
        insert resProj;

        Project_Task__c myDoc = new Project_Task__c();
        myDoc.Name = 'test Task';
        myDoc.Residential_Project__c = resProj.Id;
        myDoc.Status__c = 'Not Started';
        insert myDoc;
        ApexPages.StandardController sc = new ApexPages.StandardController(myDoc);

        ResidentialProjectTaskEditRedirect redirect = new ResidentialProjectTaskEditRedirect(sc);
        PageReference pr = redirect.redirect();
        System.assert(pr != null);
    }
}