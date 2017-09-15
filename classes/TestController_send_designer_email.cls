/*********************************************************************
    Name  : TestController_send_designer_email
    Date  : July 20,2011
    Description:This is a Test Class For Class "Controller_send_designer_email".
*********************************************************************/

@isTest
private class TestController_send_designer_email {

    static testMethod void controller_send_designer_emailTest(){
        
        // Getting Opportunity of Role- Sales Analyst
        List<OpportunityTeamMember> OTMList = [Select id, User.Name, TeamMemberRole , OpportunityId from OpportunityTeamMember where TeamMemberRole in ('Sales Analyst') limit 1];
        
        //Account test data inserted
        Account testAccount = new Account();
        testAccount.Name = 'Test Acc'+String.valueOf(DateTime.now());
        testAccount.BillingState = 'BillingState';
        testAccount.BillingCity = 'Jind';
        testAccount.BillingCountry = 'India';
        testAccount.BillingStreet = 'Rohtak Road';
        testAccount.BillingPostalCode = '126102';
        testAccount.Online_Order_Access__c = false;
        insert testAccount;
            
        //creating test site
        List<RecordType> siteRecordTypeList = [SELECT Id FROM RecordType 
                                                        WHERE SObjectType = 'Site_Information_Form__c'
                                                        AND Name = 'Standard Site'];
        Site_Information_Form__c site = new Site_Information_Form__c();
        site.RecordTypeId = siteRecordTypeList.get(0).id;
        site.Account__c = testAccount.id;
        site.Site_Status__c = 'Active';
        site.Site_State__c = 'state';
        insert site;
        
        //insert Design Record
        Design__c testDesign1 = new Design__c();
        testDesign1.site__c = site.Id;
        testDesign1.Revision_Letter__c = 'A';
        testDesign1.Date_Design_Completed__c = System.today().addMonths(1);
        testDesign1.Status__c = 'Not Started';
        
        if(OTMList.size() > 0){
            testDesign1.opportunity__c = OTMList[0].OpportunityId;
        }else{

            //Opportunity test data inserted
            Opportunity testOpp = new Opportunity();
            testOpp.Name = 'TestOpp';
            testOpp.AccountId = testAccount.Id;
            testOpp.CloseDate = System.today().addDays(14);
            testOpp.Sales_Steps__c = 'Shortlisted';
            testOpp.Contract_Type__c = 'Design';
            testOpp.Financing__c = 'PPA';
            testOpp.Business_Unit__c = 'Utility';
            testOpp.Region__c = 'New York';
            testOpp.StageName = 'Open';
            testOpp.Probability = 5;
            testOpp.Budgetary_Pricing_Agreed_On_Date__c = System.today();
            insert testOpp;
            
            testDesign1.opportunity__c = testOpp.Id;
        }
        insert testDesign1;
        
        //create a psr record
        PSR__c psr = new PSR__c();
        psr.Site__c = site.id;
        psr.Design__c = testDesign1.Id;
        psr.Array_Layout__c = false;
        psr.Design_Urgent_Request__c = false;
        psr.Single_Line_based_on_Design__c = false;
        psr.Estimate_Urgent_Request__c = true;
        psr.Cost_Estimate_Due__c = null;
        psr.Electrical_Support_Due__c = Date.today().addDays(5);
        psr.PM_Cost__c = true;
        psr.Site_Survey_Standard__c = true;
        psr.Design_Comments__c = 'test Design comment';
        psr.Additional_Product_Requests__c = 'test Additional Product Requests';
        insert psr;
        
        Controller_send_designer_email designEmail = new Controller_send_designer_email();
        designEmail.designID = testDesign1.Id;
        designEmail.relatedTo = testDesign1; 
        Design__c d = designEmail.relatedTo;
        
        System.assertEquals(psr.Design_Comments__c ,designEmail.designComments);
        System.assertEquals(psr.Additional_Product_Requests__c ,designEmail.AdditionalProductRequests );        
    } 
}