/**************************************************
** PR- 01923
**Created By- Anuradha
**Created On- December 21 , 2010
**Desciption- Test class for controller OpportunityValuesController 
*****************************************************/
@isTest
public class TestOpportunityValuesController {
  @isTest
  public static void testOpportunityValuesController (){    
    
    List<User> userList = new List<User>();
    User admin = TestClassFactory.testUser('System Administrator','admTest@user.com','admTest');
    admin.ByPassValidation__c = true;
    admin.division = 'Test';
    admin.country ='US';
    system.RunAs(admin){
        for(Integer i=1; i <= 10; i++){ 
            User u = TestClassFactory.testUser('System Administrator','Test'+i+'User@user.com','yoo'+i);
            u.ByPassValidation__c = true;
            u.SOX_Profile_was_approval_received__c = true;
            userList.add(u);
        }
        insert userList;
    }
    Account acct = new Account();
    acct.Name = 'TestDuplicate';
    acct.Type ='Commercial'; 
    acct.billingCity = 'TestCity';
    acct.BillingCountry = 'TestCountry';
    acct.BillingPostalCode = '12345';
    acct.BillingState = 'TestState';
    acct.BillingStreet = 'TestStreet';   
    insert acct;
     
    Opportunity opp = new Opportunity();
    opp.AccountId = acct.Id;
    opp.Name = 'testOpp';
    opp.CloseDate = System.today().addDays(14);
    opp.Sales_Steps__c = 'Shortlisted';
    opp.Contract_Type__c = 'Design';
    opp.Financing__c = 'PPA';
    opp.Business_Unit__c = 'Utility';
    opp.Region__c = 'New York';
    opp.StageName = 'Open';
    opp.Probability = 5;
    opp.Budgetary_Pricing_Agreed_On_Date__c = System.today();
    insert opp;
    
    List<OpportunityTeamMember> oppTeamMem  = new  List<OpportunityTeamMember> ();
    for(Integer i=0; i < 10; i++){
        OpportunityTeamMember oppMem = new OpportunityTeamMember();     
        oppMem.OpportunityId = opp.Id;
        if(i == 1 || i == 0)            
            oppMem.TeamMemberRole = 'Project Manager';
        if(i == 2 || i == 3)            
            oppMem.TeamMemberRole = 'Sales Analyst';
        if(i == 4 || i == 5)            
            oppMem.TeamMemberRole = 'Project Designer';
        if(i == 6 || i == 7)            
            oppMem.TeamMemberRole = 'Proposal Designer';
        if(i == 8 || i == 9)            
            oppMem.TeamMemberRole = 'Structured Finance';
        oppMem.UserId = userList.get(i).Id;
        oppTeamMem.Add(oppMem);
    }
    insert oppTeamMem;
    
    List<Product2> prodList = new List<Product2>();
    Product2 prdObj = new Product2(name='testproduct',family='Development', Product_Type__c = 'PV Module');
    Product2 prdObj1 = new Product2(name='testproduct1',family='Development', Product_Type__c = 'PV Module');
    prodList.add(prdObj);
    prodList.add(prdObj1);
    insert prodList ;
    Id priceBookId;
    for(priceBook2 priceBook : [select ID from Pricebook2 where IsStandard = TRUE]){
        priceBookId = priceBook.id;
    }
    List<PricebookEntry> peList = new List<PricebookEntry>();
    PricebookEntry pE1 = new PricebookEntry(Product2Id =prdObj.Id ,Isactive=true ,UnitPrice=100);
    PricebookEntry pE2 = new PricebookEntry(Product2Id =prdObj1.Id ,Isactive=true ,UnitPrice=200);
    if(priceBookId != null){
        pE1.priceBook2Id = priceBookId ;
        pE2.priceBook2Id = priceBookId ;
        peList.add(pE1);
        peList.add(pE2);        
        insert peList ;
        List<OpportunityLineItem> oppItemList = new List<OpportunityLineItem>();
        OpportunityLineItem opp_product = new OpportunityLineItem(OpportunityId = opp.id, Quantity = 1, totalPrice = 1000000, priceBookEntryId = pE1.Id);
        OpportunityLineItem opp_product1 = new OpportunityLineItem(OpportunityId = opp.id, Quantity = 1, totalPrice = 2000000, priceBookEntryId = pE2.Id);
        oppItemList.add(opp_product);
        oppItemList.add(opp_product1);   
        insert oppItemList;
    }
    Test.startTest();         
    OpportunityValuesController  oppVal = new OpportunityValuesController ();
    oppVal.oppId = opp.Id;
    Opportunity opps = oppVal.OppObj;
    opps = oppVal.OppObj;
    oppVal.OppObj = opp;
    Test.stopTest();
  }
}