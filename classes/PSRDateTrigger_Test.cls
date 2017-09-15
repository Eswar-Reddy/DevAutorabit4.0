@isTest(seeAllData=true)
private class PSRDateTrigger_Test{
    static testMethod void testAddPSRRecord(){
   
    //Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book 2009', Description = 'Price Book 2009 Products', IsActive = true, isStandard=true);
    //insert pb;
    
    Pricebook2 pb = [Select Id From Pricebook2 Where isActive=true AND isStandard=true Limit 1];

    Product2 product = new Product2();
    product.Name='Test Product';
    product.IsActive=true;
    insert product;

    // Create a pricebook entry for custom pricebook
    PricebookEntry pbe = new PricebookEntry();
    pbe.UseStandardPrice = false;
    pbe.Pricebook2Id=pb.id;
    pbe.Product2Id=product.id;
    pbe.IsActive=true;
    pbe.UnitPrice=99;
    insert pbe;

      //Create Opportunity
    Opportunity opp =new Opportunity();
    opp.name = 'TestOppPSR';  
    opp.StageName= 'Binding Offer';
    opp.Closedate = System.today(); 
    opp.Business_Unit__c = 'UPP Intl';
    opp.country__c='United States';
    insert opp;
    
    Opportunity oppty = [SELECT StageName FROM Opportunity WHERE Id =: opp.Id];
    
    System.debug('+++ Opp Stage: '+oppty.StageName);
    
     //Create Site
    Site_Information_Form__c site =new Site_Information_Form__c();   
    site.Site_Status__c='Active';
    site.opportunity_del__c = opp.ID;
    insert site;
    
    //Create Quote    
    Quote quote = new Quote();
    quote.Name = 'TestQuote';            
    quote.opportunityid =opp.id;
    quote.Quote_Steps__c = 'Array Layout';    
    insert quote; 
           
    //Create PSR record
    PSR__c psr = new PSR__c();
    psr.Quote__c = quote.ID;
    psr.site__c = site.ID;
    psr.opportunity__c = opp.ID;
    psr.PV_Module_Type__c = product.Id;
    psr.Array_Layout__c = false;
    psr.Product_Type__c = 'T-10';
    psr.Module_Type__c = 'SunPower 230'; 
    psr.Requested_System_Size__c = 1000.00;
    psr.Site_Survey_SubContractor__c=false;
    psr.Array_Layout_Due__c = Date.newInstance(2014, 06, 26);
    psr.Electrical_Support_Due__c = Date.newInstance(2014, 07, 28);
    insert psr;
    
    psr.Array_Layout_Due__c = Date.newInstance(2015, 06, 26);
    psr.Electrical_Support_Due__c = Date.newInstance(2015, 07, 28);
    update psr;

    Design__c design = new Design__c();
    design.psr__c =psr.id;
    design.site__c=site.id;
    design.Date_of_Agreed_Delivery__c = Date.newInstance(2001, 06, 26);
    insert design;
    
    design.Date_of_Agreed_Delivery__c = Date.newInstance(2000, 06, 26);
    update design;
    
    psr.Array_Layout_Due__c = design.Date_of_Agreed_Delivery__c;
    update design;
    
    System.assertEquals(psr.Array_Layout_Due__c, Date.newInstance(2000, 06, 26));
    
    design.Date_of_Agreed_Delivery__c = Date.newInstance(2014, 06, 28);
    update design;
    
    psr.Array_Layout_Due__c = design.Date_of_Agreed_Delivery__c;
    update psr;
    
    System.assertEquals(psr.Array_Layout_Due__c, Date.newInstance(2014, 06, 28));
    
    psr.Array_Layout_Due__c = Date.newInstance(2028, 06, 28);
    update psr;
    
    design.Date_of_Agreed_Delivery__c = psr.Array_Layout_Due__c;
    update design;
    Single_Line__c single = new Single_Line__c();
    single.psr__c=psr.id;
    single.design__c=design.id;
    single.site__c=site.id;
    single.status__c='Active';
    single.Negotiated_Due_Date__c = Date.newInstance(2007, 01, 01);
    insert single;
    
    single.Negotiated_Due_Date__c = Date.newInstance(2011, 01, 01);
    update single;
    
    psr.Electrical_Support_Due__c = single.Negotiated_Due_Date__c;
    update psr;
    
    System.assertEquals(psr.Electrical_Support_Due__c, Date.newInstance(2011, 01, 01));
    
    psr.Electrical_Support_Due__c = Date.newInstance(1990, 06, 28);
    update psr;
    
    single.Negotiated_Due_Date__c = psr.Electrical_Support_Due__c;
    update single;
    
    }
}