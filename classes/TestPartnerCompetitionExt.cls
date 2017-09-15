@isTest
public class TestPartnerCompetitionExt {    
    
    static TestMethod void testPartnerCompExt() {
        
        Lead l1 = TestClassFactory.testLead('lastName', 'company', 'email@example.com');
        l1.Phone = '1234567890';
        l1.MobilePhone = '1111111111';
        insert l1;
        
        Account dealer = TestClassFactory.CreateDealer('Test Dealer', 'North America');
        
        Account a = TestClassFactory.testAccount('name', TestClassFactory.retrieveRecordTypeID('Account', 'Residential Customer'));
        a.Partner_Account__c = dealer.id;
        a.Phone = '1234567890';
        a.Email__c = 'email@example.com';
        insert a;
        
        Opportunity o = TestClassFactory.testOpportunity('name1', 'New Opportunity', Date.today().addDays(10), TestClassFactory.retrieveRecordTypeID('Opportunity', 'Home Owner'));
        o.Partner_Account_Id__c = dealer.Id;
        o.AccountId = a.Id;
        insert o;
        
        Quote q = new Quote();
        q.OpportunityId = o.id;
        q.Name = 'Test Quote';
        insert q;
               
        Test.startTest();
        PageReference pageRef = Page.PartnerCompetitionMatches;
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(l1);
        
        PartnerCompetitionExtension ext = new PartnerCompetitionExtension(sc);
        ext.getLeadDetails();
        ext.getPartnerResults();
        
        Test.stopTest();
    }

}