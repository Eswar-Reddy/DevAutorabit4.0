/**************************************************
** PR- 01923
**Created By- Anuradha
**Created On- December 21 , 2010
**Desciption- Test class for controller SingleLineManagement 
*****************************************************/

public class TestSingleLineManagement  {
  @isTest
  public static void testSingleLineManagement (){
    PSR__c psr = new PSR__c ();
    psr.array_layout_completed__c = Date.today();
    psr.electrical_support_completed__c = Date.Today();
    psr.cost_estimate_completed__c = Date.TOday();
    insert psr;
            
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
    
    Site_Information_Form__c sif = new Site_Information_Form__c();
    sif.Opportunity_del__c = opp.Id;
    sif.Site_Name__c = 'test';
    insert sif;       
                
    Design__c design = new Design__c();
    design.site__c = sif.ID;
    design.Opportunity__c = opp.Id;
    insert design;
                      
    Single_Line__c sl = new Single_Line__c();
    sl.quote__c = qt.Id;
    sl.Design__c = design.Id;
    //sl.Site__c = sif.Id;//test clss fixation
    //insert sl;//test clss fixation
    
    List<Single_Line__c> sls = new List<Single_Line__c>();
    sls.Add(sl);
    
    //test clss fixation
    Single_Line__c sl1 = new Single_Line__c();
    sl1.quote__c = qt.Id;    
    sl1.PSR__c = psr.Id;//test clss fixation
    sl1.Primary_PSR_Single_Line__c = true;
    sls.add(sl1);
    SingleLineManagement.beforeSingleLineInsert(sls);
    SingleLineManagement.afterSingleLineInsert(sls);
    //test clss fixation
    
    SingleLineManagement.beforeSingleLineUpdate(sls , new List<Single_Line__c>());
    SingleLineManagement.populateRelatedObjects(sls);
    SingleLineManagement.afterSingleLineUpdate(sls , new List<Single_Line__c>());    
  }
}