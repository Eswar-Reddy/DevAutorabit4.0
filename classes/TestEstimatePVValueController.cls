/**************************************************
** PR- 01923
**Created By- Anuradha
**Created On- December 21 , 2010
**Desciption- Test class for controller EstimatePVValueController
*****************************************************/

public class TestEstimatePVValueController {
  @isTest
  public static void testEstimatePVValueController(){
            
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
    
    Quote qt = new Quote();
    qt.Name = 'test';
    qt.OpportunityId = opp.ID;
    insert qt;    
    
   List<OpportunityTeamMember> oppTeamMem  = new  List<OpportunityTeamMember> ();
         
    OpportunityTeamMember oppMem1 = new OpportunityTeamMember();
    oppMem1.UserId = userinfo.getUserId();
    oppMem1.TeamMemberRole = 'Project Manager';
    oppMem1.OpportunityId = opp.Id;
    oppTeamMem.Add(oppMem1);
    
    OpportunityTeamMember oppMem2 = new OpportunityTeamMember();
    oppMem2.UserId = userinfo.getUserId();
    oppMem2.TeamMemberRole = 'Sales Analyst' ;
    oppMem2.OpportunityId = opp.Id;
    oppTeamMem.Add(oppMem2);
    
    OpportunityTeamMember oppMem3 = new OpportunityTeamMember();
    oppMem3.UserId = userinfo.getUserId();
    oppMem3.TeamMemberRole = 'Sales Analyst' ;
    oppMem3.OpportunityId = opp.Id;
    oppTeamMem.Add(oppMem3);
    
    insert oppTeamMem;   
    
    Product2 prdObj = new Product2(name='testproduct',family='Development');
    insert prdObj ;
    Id priceBookId;
    for(priceBook2 priceBook : [select ID from Pricebook2 where IsStandard = TRUE]){
        priceBookId = priceBook.id;
    }
    
    PricebookEntry pE1 = new PricebookEntry(Product2Id =prdObj.Id ,Isactive=true ,UnitPrice=100);
    if(priceBookId != null){
        pE1.priceBook2Id = priceBookId ;
        insert pE1 ;
        
        OpportunityLineItem opp_product = new OpportunityLineItem(OpportunityId = opp.id, Quantity = 1, totalPrice = 1000000, priceBookEntryId = pE1.Id);
        insert opp_product;
        
        
    }
    
    EstimatePVValueController estimate = new EstimatePVValueController ();
    estimate.quoteIDVal = qt.ID;
    
    
    
    Quote qts = estimate.relatedTo ;
  }
  
  @isTest
  public static void testEstimatePVValueController1(){
            
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
    
    Product2 prdObj = new Product2(name='testproduct',family='Development');
    insert prdObj ;
       
    PriceBook2 book = [select id from PriceBook2 where IsStandard=true  limit 1];
    
    
    PricebookEntry pE1 = new PricebookEntry(Product2Id =prdObj.Id ,Isactive=true ,UnitPrice=100);
    pE1.Pricebook2Id = book.id;
    insert pE1 ;
    
    Quote qt = new Quote();
    qt.Name = 'test';
    qt.OpportunityId = opp.ID;
    qt.Pricebook2Id=book.id;
    insert qt;    
    
    QuoteLineItem quoteLine = new QuoteLineItem();
    quoteLine.PricebookEntryId=pE1.id;
    quoteLine.QuoteId = qt.id;
    quoteLine.Product__c=prdObj.id;
    quoteLine.UnitPrice=100;
    quoteLine.Quantity=100;
    insert quoteLine;
    
    
   List<OpportunityTeamMember> oppTeamMem  = new  List<OpportunityTeamMember> ();
         
    OpportunityTeamMember oppMem1 = new OpportunityTeamMember();
    oppMem1.UserId = userinfo.getUserId();
    oppMem1.TeamMemberRole = 'Project Manager';
    oppMem1.OpportunityId = opp.Id;
    oppTeamMem.Add(oppMem1);
    
    OpportunityTeamMember oppMem2 = new OpportunityTeamMember();
    oppMem2.UserId = userinfo.getUserId();
    oppMem2.TeamMemberRole = 'Sales Analyst' ;
    oppMem2.OpportunityId = opp.Id;
    oppTeamMem.Add(oppMem2);
    
    OpportunityTeamMember oppMem3 = new OpportunityTeamMember();
    oppMem3.UserId = userinfo.getUserId();
    oppMem3.TeamMemberRole = 'Sales Analyst' ;
    oppMem3.OpportunityId = opp.Id;
    oppTeamMem.Add(oppMem3);
    
    insert oppTeamMem;   
    
    OpportunityLineItem opp_product = new OpportunityLineItem(OpportunityId = opp.id, Quantity = 1, totalPrice = 1000000, priceBookEntryId = pE1.Id);
    insert opp_product;
       
          
    
    
    
    EstimatePVValueController estimate = new EstimatePVValueController ();
    estimate.quoteIDVal = qt.ID;
    
    
    
    Quote qts = estimate.relatedTo ;
  }
}