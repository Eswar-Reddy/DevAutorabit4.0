@isTest
public class TestOpportunityContactRoleNew{

  public static testMethod void testMyController() {
        
    
        Account act = new Account();
        act.Name = 'Test Account 1' +String.valueOf(DateTime.Now());
        act.Type ='Commercial';
        act.BillingCity = 'san mateo';
      act.BillingStreet = 'Concar drive';
      act.BillingPostalCode ='94402';
      act.BillingCountry = 'USA'; 
        insert act; 
        
        Opportunity opp1 = new Opportunity();       
            opp1.AccountId = act.Id;
            opp1.Name = 'testOpp';
            opp1.CloseDate = System.today().addDays(14);
            opp1.Sales_Steps__c = 'Shortlisted';
            opp1.Contract_Type__c = 'Design';
            opp1.Financing__c = 'PPA';
            opp1.Business_Unit__c = 'Utility';
            opp1.Region__c = 'New York';
            opp1.StageName = 'Open';
            opp1.Probability = 5;
            opp1.Budgetary_Pricing_Agreed_On_Date__c = System.today();
            //oppList.add(opp1);
            //Test.startTest();
            insert opp1;
        
        Contact cnt = new Contact();
        cnt.LastName = 'Test contact 1' +String.valueOf(DateTime.Now());
        cnt.AccountId = act.Id;
        insert cnt;
        
        Contact cnt2 = new Contact();
        cnt2.LastName = 'Test contact2';
        cnt2.AccountId = act.Id;
        insert cnt2;
        
        OpportunityContactRole role1 = new OpportunityContactRole();
        role1.OpportunityId = opp1.Id;
        role1.ContactId = cnt.id;
        insert role1;
        
        OpportunityContactRole role2 = new OpportunityContactRole();
        role2.OpportunityId = opp1.Id;
        role2.ContactId = cnt2.id;
        role2.isPrimary = true;
        insert role2;
        
        //Test.setCurrentPageReference(new PageReference('Page.OpportunityContactRoleNew')); 
        //System.currentPageReference().getParameters().put('opportunityId', opp1.id);
        
        PageReference tpageRef = Page.OpportunityContactRoleNew;
        Test.setCurrentPage(tpageRef);
        ApexPages.currentPage().getParameters().put('opportunityId', opp1.Id);
        OpportunityContactRoleNew controller = new OpportunityContactRoleNew();
        controller.submit();
        
        
    }   

}