@isTest
public class TestOpportunityRolesManagement {
    @isTest
    public static void test_TestOpportunityRolesManagement()
    {     
        Map<String, Schema.RecordTypeInfo> nameToOppRoleRecordTypeInfoMap = Schema.SObjectType.Opportunity_Role__c.getRecordTypeInfosByName();
        Map<String, Schema.RecordTypeInfo> nameToOppRecordTypeInfoMap = Schema.SObjectType.Opportunity.getRecordTypeInfosByName();
        Id frameworkParentRecTypeId = nameToOppRoleRecordTypeInfoMap.get('Framework Master Agreement').getRecordTypeId();
        Id frameworkChildRecTypeId = nameToOppRoleRecordTypeInfoMap.get('Framework Child').getRecordTypeId();
        Id componentsRecordTypeId = nameToOppRecordTypeInfoMap.get('Components').getRecordTypeId();
        Id substationRecordTypeId = nameToOppRoleRecordTypeInfoMap.get('Substation').getRecordTypeId();
        List<Pricebook2> pbList = [Select Id From Pricebook2 where Name ='Standard Price Book' limit 1];
        Id pbId;
        if(pbList.size()>0)
            pbId = pbList.get(0).Id;
        Product2 p = new Product2(Name = 'TestProduct', IsActive = true, Family='PV Cell', Product_Type__c = 'PV Module', Unit__c =1000);
        insert p;
        
        PricebookEntry pe = new PricebookEntry(Product2Id = p.Id, Pricebook2Id = pbId, IsActive = true, UnitPrice = 10.0);
        insert pe;          
        
        Account accObj = new Account();
            accObj.Name = 'Testing Account' +String.valueOf(DateTime.Now());
            accObj.Type ='Commercial';      
            accObj.BillingCity = 'chicago';
            accObj.BillingCountry = 'Spain';
            accObj.BillingStreet = 'btm';
            accObj.BillingPostalCode = '12311';
            accObj.Theater__c = 'Europe';
            accObj.Territory__c = 'Spain';

            insert accObj; 
        
        Opportunity oppObj = new Opportunity();
            oppObj.RecordTypeId = componentsRecordTypeId;
            oppObj.Name = 'testOpp';
            oppObj.AccountId = accObj.Id;
            oppObj.StageName = '01 – Assess Opportunity';
            oppObj.CloseDate = Date.today();    
            insert oppObj;
        
        Opportunity oppBlank = new Opportunity();
            oppBlank.RecordTypeId = componentsRecordTypeId;
            oppBlank.Name = 'testOpp1';
            oppBlank.StageName = '01 – Assess Opportunity';
            oppBlank.CloseDate = Date.today();    
            insert oppBlank;
        
        OpportunityLineItem oppLine = new OpportunityLineItem();
            oppLine.OpportunityId = oppObj.Id;
            oppLine.PricebookEntryId = pe.Id;
            oppLine.UnitPrice = 5.0;
            oppLine.Quantity = 2.0;
            insert oppLine;
        
        oppObj = [Select Id, Amount, System_SizePV__c from Opportunity where Id =:oppObj.Id];
//        System.Debug('Debug->'+oppObj.Amount);//value should be 10
//        System.Debug('Debug->'+oppObj.System_SizePV__c);//value should be 2
        
        Opportunity_Role__c oppRoleParent = new Opportunity_Role__c();
            oppRoleParent.RecordTypeId = frameworkParentRecTypeId;
            oppRoleParent.Amount_Approved__c = 50;
            oppRoleParent.MW_Approved__c = 1;
            oppRoleParent.Contract_Signed_Date__c = system.today();
            oppRoleParent.Opp_Name__c = oppObj.Id;      // Added Reetan 11/30/2012
        
        Opportunity_Role__c oppRoleParent1 = new Opportunity_Role__c();
            oppRoleParent1.RecordTypeId = frameworkParentRecTypeId;
            oppRoleParent1.Amount_Approved__c = 50;
            oppRoleParent1.MW_Approved__c = 1;
            oppRoleParent1.MW_Applied1__c = null;
            oppRoleParent1.Contract_Signed_Date__c = system.today();       
            oppRoleParent1.Opp_Name__c = oppObj.Id;     // Added Reetan 11/30/2012
        
        Test.startTest();
        insert oppRoleParent;
        insert oppRoleParent1;
        
        Opportunity_Role__c oppRoleChild = new Opportunity_Role__c();
            oppRoleChild.RecordTypeId = frameworkChildRecTypeId;
            oppRoleChild.Opp_Name__c = oppObj.Id;
            oppRoleChild.Parent_Framework_Agreement__c = oppRoleParent.Id;
            oppRoleChild.Opp_Name__c = oppObj.Id;   // Added Reetan 11/30/2012
            insert oppRoleChild;
        
        Opportunity_Role__c oppRoleChild1 = new Opportunity_Role__c();
            oppRoleChild1.RecordTypeId = frameworkChildRecTypeId;
            oppRoleChild1.Opp_Name__c = oppObj.Id;
            oppRoleChild1.Parent_Framework_Agreement__c = oppRoleParent.Id;
            oppRoleChild1.Opp_Name__c = oppObj.Id;  // Added Reetan 11/30/2012
            insert oppRoleChild1;       
        
        oppRoleChild = [Select Id, Opp_Name__c, Amount1__c from Opportunity_Role__c where Id =:oppRoleChild.Id];
        System.Debug('Debug->'+oppRoleChild );
        update oppRoleChild;
        
        oppRoleChild = [Select Id, Opp_Name__c,Parent_Framework_Agreement__c, Amount1__c from Opportunity_Role__c where Id =:oppRoleChild.Id];
        System.Debug('Debug->'+oppRoleChild );
        oppRoleChild.Parent_Framework_Agreement__c = oppRoleParent1.Id;
        update oppRoleChild;
        
        delete oppRoleChild1;

        Opportunity_Role__c oppRoleChild2 = new Opportunity_Role__c();
            oppRoleChild2.RecordTypeId = frameworkChildRecTypeId;
            oppRoleChild2.Opp_Name__c = oppObj.Id;    // Added Reetan 11/30/2012
            oppRoleChild2.Parent_Framework_Agreement__c = oppRoleParent.Id;
            oppRoleChild2.Infrastructure_Account__c = accObj.Id;        
            insert oppRoleChild2;       
        
        accObj.Transmission_Capacity__c = 3.0;
        accObj.Transmission_Capacity_Used__c = 1.6;
        update accObj;
        
        Opportunity_Role__c testOppRole = new Opportunity_Role__c();
            testOppRole.RecordTypeId = substationRecordTypeId;
            testOppRole.Opp_Name__c = oppObj.Id;
            insert testOppRole;
        Test.stopTest();
    }
    
    @isTest
    public static void testContract_Notification_Submission(){
        Id componentsRecordTypeId = Schema.SObjectType.Opportunity_Role__c.getRecordTypeInfosByName().get('Components').getRecordTypeId();
        
        UserManagement.is_Test = true;
        User currentUser = new User(id=userInfo.getUserID(), Business_Unit__c='NA Commercial');
        update currentUser;       
            
        Account accObj = new Account();
            accObj.Name = 'Testing Account' +String.valueOf(DateTime.Now());
            accObj.Type ='Commercial';      
            accObj.BillingCity = 'chicago';
            accObj.BillingCountry = 'Spain';
            accObj.BillingStreet = 'btm';
            accObj.BillingPostalCode = '12311';
            accObj.Theater__c = 'Europe';
            accObj.Territory__c = 'Spain';

            insert accObj; 

        Opportunity oppObj = new Opportunity();
            oppObj.Name = 'testOpp';
            oppObj.AccountId = accObj.Id;
            oppObj.StageName = '01 – Assess Opportunity';
            oppObj.CloseDate = Date.today();    
            insert oppObj;
        
        OpportunityTeamMember opp_sales = new OpportunityTeamMember();
            opp_sales.UserId = currentUser.Id;
            opp_sales.TeamMemberRole = 'Management';
            opp_sales.OpportunityId = oppObj.Id;
            insert opp_sales;
        
        Quote newQuote = new Quote();
            newQuote.Name = 'Test quote';
            newQuote.Quote_Steps__c= 'TEst Array Layout';
            newQuote.opportunityid = oppObj.Id;
            insert newQuote;
        
        Opportunity_Role__c oppRoleContractNotify = new Opportunity_Role__c();
            oppRoleContractNotify.RecordTypeId = componentsRecordTypeId;
            oppRoleContractNotify.Opp_Name__c = oppObj.Id;
            oppRoleContractNotify.Contract_Status__c = 'In Review';
            oppRoleContractNotify.Quote_No__c = newQuote.Id;
            oppRoleContractNotify.Contract_Type__c = 'EPC';
        
        Test.startTest();
        delete [Select id, Email from Contact where Name ='Dummy Contact'];
        try{
            insert oppRoleContractNotify;
        }catch(Exception e){}
        
        oppRoleContractNotify.Contract_Status__c = 'Draft';
        try{
            update oppRoleContractNotify;
        }catch(Exception e){}
        oppRoleContractNotify.Contract_Status__c = 'In Review';
        try{
            update oppRoleContractNotify;
        }catch(Exception e){}
        Test.stopTest();       
    }

}