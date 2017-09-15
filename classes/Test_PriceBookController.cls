@isTest 
Private Class Test_PriceBookController 
{

public static testmethod void testpricebook()
 {
 //PageReference pageRef = Page.ChoosePriceBook;
 //Test.setCurrentPage(pageRef);
        Date dt = System.Today();
        Account acc = new Account(Name = 'testaccc',CurrencyIsoCode = 'USD', Account_Status__c = 'Active',SPWR_Relationship_Type__c = 'Off-Taker',BillingStreet = 'West Mare',BillingCity = 'SanFrancisco',BillingPostalCode = '2345', BillingCountry = 'United States of America',Phone = '1234');
        insert acc;
        // Done for case # 00066557 Replacing business unit IBD with 'UPP Intl'.
        Opportunity o = new Opportunity(Name = 'Tesrt',StageName= 'Budgetary Pricing',Business_Unit__c='UPP Intl',CloseDate=dt,AccountId = acc.ID);
        Insert o;
        Pricebook2 pb = [select Id from Pricebook2 where Name='Systems Price Book'];
        Product2 prd1 = [select Id,family from Product2 limit 1];
        
        PricebookEntry pE = [select Id from PricebookEntry where Pricebook2Id =:pb.Id limit 1 ];
        Design__c design = new Design__c(Opportunity__c=o.Id,Price_Book__c=pb.Id);
        insert design;
        
        Estimate__c est = new Estimate__c();
        est.Status__c = 'Invalid';
        est.Refresh_Count__c = 2;
        est.Negotiated_Due_Date__c = system.Today();
        est.PM_PPP_Tracking_Date__c = system.Today();
        est.PM_PPP_Review_Tracking_Date__c = system.Today();
        est.Price_Book__c=pb.Id;
        insert est;
        
        Product2 p = [select Family from Product2 where Id=:prd1.ID ];
        ApexPages.currentPage().getparameters().put('id',est.ID);
        ApexPages.currentPage().getparameters().put('selectedFamily',p.Family);

 Test_PriceBookController controller = new Test_PriceBookController();
 Estimate__c e = controller.setupTestCase();
 PriceBookController controller1 = controller.setupController(e);
 
 List<SelectOption> options = controller1.getPriceBook();
 //System.assertEquals(5,options.size());

 }
 
 
 public static testmethod void actionsTest() 
 {
  Test_PriceBookController controller = new Test_PriceBookController();
  Estimate__c e = controller.setupTestCase();  
  PageReference p = Page.ChoosePriceBook;
  p.getParameters().put('id',e.id);
  Test.setCurrentPage(p);
  
  PriceBookController controller2 = New PriceBookController();
  
  Estimate__c est = new Estimate__c();
  est.Status__c = 'Invalid';
  est.Refresh_Count__c = 2;
  est.Negotiated_Due_Date__c = system.Today();
  est.PM_PPP_Tracking_Date__c = system.Today();
  est.PM_PPP_Review_Tracking_Date__c = system.Today();
  insert est;
  
  controller2.estimateId = est.id;
  //System.assert(controller2.estimateId);
  Estimate__c order = [Select Id  from Estimate__c where Id =:controller2.estimateId];
  ApexPages.currentPage().getparameters().put('id',order.ID);
  controller2.init();
  controller2.getPriceBook();
  controller2.cancel();
  controller2.save();

 }

 
 private Estimate__c setupTestCase() 
 {
 Estimate__c est = new Estimate__c();
 est.Status__c = 'Invalid';
 est.Refresh_Count__c = 2;
 est.Negotiated_Due_Date__c = system.Today();
 est.PM_PPP_Tracking_Date__c = system.Today();
 est.PM_PPP_Review_Tracking_Date__c = system.Today();
 insert est;
 System.Debug('Ashok' + est.id);
 
 return est;
 
 }

 
 private PriceBookController setupController(Estimate__c e) {
    
        /* Construct the controller that will be returned by this setup method.*/
        PriceBookController controller = new PriceBookController();
    
        /* Create a page for use in the test. */        
        PageReference p = Page.ChoosePriceBook;
        
        /* Set the case ID in the context for use by the controller. */
        p.getParameters().put('cid',e.id);
        
        /* Set the case ID in the context for use by the controller. */
        Test.setCurrentPage(p);
        
        return controller;
    }

 
 
}