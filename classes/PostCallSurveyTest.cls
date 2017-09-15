@isTest

public class PostCallSurveyTest{
    
    /*
Function     : Test_createPostCallSurveyObjectWithContactLastSurveyDateUpdate
Parameter    : 
Returen Type : 
Summary      : This function create a Case then update case status as closed along with  Survey_Sent__c as true ion order to call Trigger afterCaseInsertUpdate then eventually call PostCallSurvey.createPostCallSurveyObjectWithContactLastSurveyDateUpdate  
*/
    
    static testMethod void Test_createPostCallSurveyObjectWithContactLastSurveyDateUpdate(){
        Test.StartTest();
        
        Account acc = new Account();
        acc.Name = 'Test Account1-'+ String.valueOf(DateTime.Now());
        acc.Type ='Commercial';
        acc.BillingCity = 'san mateo';
        acc.BillingState = 'CA';
        acc.BillingStreet = 'Concar drive';
        acc.BillingPostalCode ='94402';
        acc.BillingCountry = 'USA'; 
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'Test Contact-'+ String.valueOf(DateTime.Now());
        con.AccountId = acc.Id;
        con.Email='test123l3scrum@testl3scrumuat.com';
        insert con;
        
        List<Case> caseList = new List<Case>();
        Case newCase = new Case(); 
        newCase.Type = 'Customer Complaint';
        newCase.ContactID=con.Id;
        caseList.add(newCase);
        
        insert caseList;
        
        Case caseUpdate=[SELECT Status,Resolution__c,Resolution_Comment__c,Survey_Sent__c,Contact.Issue_Resolution_Survey_Sent_date__c FROM Case WHERE ID =:newCase.Id];
        caseUpdate.Status='Closed';
        caseUpdate.Resolution__c='Resolved';
        caseUpdate.Resolution_Comment__c='Test Comment';
        caseUpdate.Survey_Sent__c=True;
        update caseUpdate;
        Test.StopTest();
        Case caseUpdateAfterSurveySent=[SELECT Status,Resolution__c,Resolution_Comment__c,Survey_Sent__c,Contact.Issue_Resolution_Survey_Sent_date__c FROM Case WHERE ID =:newCase.Id];
        system.assertEquals(System.today(), caseUpdateAfterSurveySent.Contact.Issue_Resolution_Survey_Sent_date__c);    
    }
    
}