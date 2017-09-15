Public Class Test_AddProductFromPsr_Extension 
{
@isTest
 public static void testproduct()
 { 
   Boolean errorFound = false;

   // test.startTest();
   Account acc = new Account();
   acc.Name ='TestAcc';
   acc.Account_Status__c = 'Prospective';
   acc.SPWR_Relationship_Type__c = 'Competitor';
   acc.Phone = '2352352355';
   acc.BillingCity = 'Chennai';
   acc.BillingCountry = 'India';
   acc.BillingStreet = 'st.john Street';
   acc.BillingPostalCode = '3275932';
   insert acc;
      
   opportunity opp = new opportunity();
   opp.Name ='Testopp';
   opp.Account = acc;
   opp.StageName ='Binding Offer';
   opp.CloseDate = System.Today();
   insert opp;
   
   //define price book , active one
  // Pricebook2 pb1 = [select Id from Pricebook2 where Name='Standard Price Book'];

   //Pricebook2 pb1 = new Pricebook2(name ='test price book test' ,isactive=true); 
   //insert pb1;
   Pricebook2 pb1 = [select ID from Pricebook2 where IsStandard = TRUE];
   
   
   Quote Q1 = New Quote();
   Q1.Name = 'TestQuote';
   Q1.Opportunity = opp;
   Q1.OpportunityId = opp.id;
   Q1.PriceBook2Id = pb1.Id;
   insert Q1;
   
   Q1.Name = 'Test';
   update Q1;
   
    ApexPages.currentPage().getParameters().put('id', Q1.id);
  // product.quoteid  = Q1.id; 

  //add PSR into quote 
  PSR__c psrObj = new PSR__c(Quote__c =Q1.id ,Estimate_Urgent_Request__c=true,PM_Cost__c=true);
  insert psrObj ;

   Estimate__c  estObj = new Estimate__c(name='testestimate' ,PSR__c =psrObj.Id);
   insert estObj ;
  
  
   //Product2 prdObj = [select Id,family from Product2 limit 1];
   
  // PricebookEntry pE1 = [select Id,Product2Id from PricebookEntry where Pricebook2Id =:pb1.Id and Isactive=true and CurrencyIsoCode ='USD' limit 1 ];
   
   Product2 prdObj = new Product2(name='testproduct',family='Development');
   insert prdObj ;

   PricebookEntry pE1 = new PricebookEntry(Product2Id =prdObj.Id ,Isactive=true ,UnitPrice=100 ,Pricebook2Id=pb1.Id );
   insert pE1 ;
   
   QuoteLineItem lineItem = new QuoteLineItem(Estimate__c=estObj.Id, Product__c=prdObj.Id ,Quantity =1,UnitPrice=0 ,QuoteId=Q1.Id, PricebookEntryId=pE1.Id);
   insert lineItem;

   ApexPages.StandardController stdController = new ApexPages.StandardController(Q1);
  
   test.startTest();

   AddProductFromPsr_Extension  product = new AddProductFromPsr_Extension(stdController); 
  
      
   product.getlstPSR();
   product.getLineItems();

   for(AddProductFromPsr_Extension.PSRLineItems nestPSRLines: product.psrLIlst){
       
       for(AddProductFromPsr_Extension.cQuoteLineItem nextLineItem : nestPSRLines.cQuoteLTLst){

                  nextLineItem.selected = true ;
       }
   }

   product.updatelineitem();
   product.goToQuoteView();

  test.stopTest();


  
 }
}