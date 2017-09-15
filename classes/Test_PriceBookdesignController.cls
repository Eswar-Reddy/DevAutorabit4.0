@isTest 
Private Class Test_PriceBookdesignController 
{
public static testmethod void testpricebook()
 {
        Date dt =Date.Today();
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
        
        Product2 p = [select Family from Product2 where Id=:prd1.ID ];
        ApexPages.currentPage().getparameters().put('id',design.ID);
        ApexPages.currentPage().getparameters().put('selectedFamily',p.Family);

 
 Test_PriceBookdesignController controller = new Test_PriceBookdesignController();
 Design__c e = controller.setupTestCase();
 PriceBookdesignController controller1 = controller.setupController(e);
 
 List<SelectOption> options = controller1.getPriceBook();


 }
 
 
 public static testmethod void actionsTest() 
 {
  Test_PriceBookdesignController controller = new Test_PriceBookdesignController();
  Design__c e = controller.setupTestCase();  
  PageReference p = Page.ChoosePriceBook;
  p.getParameters().put('id',e.id);
  Test.setCurrentPage(p);
  
  PriceBookdesignController controller2 = New PriceBookdesignController();
  
  Design__c des = new Design__c();
  des.Status__c = 'Invalid';
  des.Refresh_Count__c = 2;
  insert des;

  
  controller2.designId  = des.id;
  //System.assert(controller2.estimateId);
  Design__c order = [Select Id  from Design__c where Id =:controller2.designId ];
  controller2.init();
  controller2.getPriceBook();
  controller2.cancel();
  controller2.save();

 }

 
 private Design__c setupTestCase() 
 {
  Design__c des = new Design__c();
  des.Status__c = 'Invalid';
  des.Refresh_Count__c = 2;
  insert des;
  System.Debug('Ashok' + des.id);
 
  return des;
 
 }

 
 private PriceBookdesignController setupController(Design__c e) {
    
        /* Construct the controller that will be returned by this setup method.*/
        PriceBookdesignController controller = new PriceBookdesignController();
    
        /* Create a page for use in the test. */        
        PageReference p = Page.ChoosePriceBook;
        
        /* Set the case ID in the context for use by the controller. */
        p.getParameters().put('cid',e.id);
        
        /* Set the case ID in the context for use by the controller. */
        Test.setCurrentPage(p);
        
        return controller;
    }

 
 
}