// Test class for Class QuoteManagement 
// Test class for Trigger QuoteSummaryIsLocked
@isTest
public class TestQuoteManagement {
    static testMethod void testQuoteTrigger1() {
    
        QuoteManagement qm = new QuoteManagement ();
        
        Opportunity oppty = new Opportunity();
        oppty.Name = 'TestOpp'; // 'Test class oppty for quote';
        oppty.StageName= 'Binding Offer';
        oppty.Closedate = System.today();
        oppty.Sales_Analyst__c = UserInfo.getUserId();
        insert oppty;

            
        // START Modified Reetan on 15 Sept
        
        // Create Quote Summary
        Quote_Summary__c QS = new Quote_Summary__c();
        //QS.Locked_Scenario__c = q1.Id;
        QS.Ammendment__c = 'Product';
        QS.Lease_to_be_Amended__c = 'Hello';
        QS.Override_30KW_Limit__c = FALSE;
        QS.Comments__c = 'Comment';//JAJA SEPT2815
        insert QS;
            
        // END Modified Reetan on 15 Sept            
            
        //Opportunity insertedoppty = [select id,name from opportunity where name = 'TestOpp'];
        Quote quote1 = new Quote();
            quote1.Name = 'Test - quote';
            quote1.Quote_Steps__c= 'TEst Array Layout';
            quote1.ShippingCity ='.';
            quote1.ShippingCountry ='.';
            quote1.Override_30KW_Limit__c = FALSE;
            quote1.opportunityid = oppty.id;
            quote1.Lease_Doc_Signed__c = false;
            
            quote1.Quote_Summary__c = QS.Id;
            quote1.Is_Locked__c = TRUE;
       
                 
            Test.startTest();
            
            delete [Select id, Email from Contact where Id=:UserInfo.getUserId() or Email = 'davide.pasi@sunpowercorp.com'];
            insert quote1;       
            
            Test.stopTest();                 
      }    
      
      static testMethod void testQuoteTrigger2() {
      
      // Create Quote Summary
        Quote_Summary__c QS = new Quote_Summary__c();
        //QS.Locked_Scenario__c = q1.Id;
        QS.Ammendment__c = 'Product';
        QS.Lease_to_be_Amended__c = 'Hello';
        QS.Override_30KW_Limit__c = FALSE;
        QS.Comments__c = 'Comment';//JAJA SEPT2815
        insert QS;
        
        Test.startTest();
        
            Quote quote2 = [Select q.Id, q.Opportunity.Id, q.Opportunity.Sales_Analyst__c, q.Lease_Doc_Signed__c, Opportunity_Owner_s_Manager__c, //crystal added one field 11/3/2015
                            q.ShippingCity, q.sales_analyst__c From Quote q 
                            where q.Opportunity.Sales_Analyst__c != null limit 1];                                                                               
      
            if (quote2 != null) {          
                Quote quote3 = quote2.clone(true);
                quote3.Name ='Test quote3';
                quote3.ShippingCity ='.';
                quote3.ShippingCountry ='.';
                quote3.IsSendApprovaltoSalesAnalyst__c = true;
                quote3.Lease_Doc_Signed__c = TRUE; 

                QS.Override_30KW_Limit__c = TRUE;
                QS.Locked_Scenario__c = quote3.Id;
                update QS;     

                update quote3;       
               }
           Test.stopTest();

       }
       
       static testMethod void testQuoteTrigger3() {
           Test.startTest();
                List <Quote> list1= new List<Quote>([Select q.Id, q.Opportunity.Id, q.Opportunity.Sales_Analyst__c, Opportunity_Owner_s_Manager__c, //crystal added one field 11/3/2015
                                                    q.ShippingCity, q.sales_analyst__c From Quote q 
                                                    where q.Opportunity.Sales_Analyst__c != null limit 1]);
                                            
                QuoteManagement.beforeQuoteInsert(list1);             
          
                List<QuoteLineItem> list100= new List<QuoteLineItem>([Select LineNumber, CurrencyIsoCode, QuoteId, 
                                                                    PricebookEntryId, Quantity, UnitPrice, Discount, 
                                                                    ListPrice, Subtotal, TotalPrice, Product_Name__c,
                                                                    Product__c, Cost__c, Product_Type__c, Unit__c,
                                                                    Product_Family__c, Total_Cost__c, Site__c,
                                                                    Total_Cost_new__c FROM QuoteLineItem limit 1]); 
                
                QuoteManagement.beforeQuoteLineItesInsertMethod(list100);
                
                //Added by Venkat Ramesh
                List<Quote> quoteList = [select id from Quote where OpportunityId !=null and IsSyncing = true and 
                                         LineItemsFromOpp__c = true limit 1];                                                              
                
                if(quoteList.size()>0) {
                    List<QuoteLineItem> quoteLineItemsList = [select id, QuoteId, PricebookEntryId, UnitPrice, 
                                                              Site__c, ServiceDate, Quantity, Cost__c from 
                                                              QuoteLineItem where QuoteId =:quoteList[0].Id];
                                                              
                    QuoteManagement.beforeQuoteLineItesInsertMethod(quoteLineItemsList);        
                }
        //End Venkat Ramesh
       /* QuoteLineItem qli= [Select LineNumber, CurrencyIsoCode, QuoteId, PricebookEntryId, Quantity, UnitPrice,
                            Discount, ListPrice, Subtotal, TotalPrice, Product_Name__c, Product__c, Site__c, Cost__c,
                            Product_Type__c, Product_Family__c, Total_Cost__c, Total_Cost_new__c, Unit__c 
                            FROM QuoteLineItem limit 1];       */
         //if (qli==null) return;
        //QuoteLineItem qli2=qli.clone(true);
       //update qli2;
   
        Test.stopTest();                 
    }   
}