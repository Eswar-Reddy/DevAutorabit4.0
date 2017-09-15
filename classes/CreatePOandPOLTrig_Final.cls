/***
Class Name: CreatePOandPOLTrig_Final
Description: Test Class

Revision History:
MAM 22.MAY.2015 - Commented out test class since this is a duplicate of TestCreatePOandPOLTrig_Final
***/

@isTest(SeeAllData=true)
public class CreatePOandPOLTrig_Final
{
  /*public static testMethod void TM1()
     {
        Account newAccount;
        Contact newContact;
        Opportunity newOpportunity;
        Quote newQuote;
        
        //Profile p = [SELECT Id FROM Profile WHERE Name='system administrator']; 
        User u = [select id from User where ProfileId =: p.Id and IsActive=true and Country_Domain__c='rvar-fr' limit 1];
        
        //[START] RA 20.MAY.2015 - created test user to avoid errors in query encountered on every deployment 

        User Usr = new User(
          Username = 'testxxx@sunpower.com',
          LastName = 'xxxx', 
          Email = 'testxxx@sunpower.com', 
          Alias = 'testxxx', 
          CommunityNickname = 'testxxxx',
          TimeZoneSidKey = 'America/Los_Angeles', 
          LocaleSidKey = 'en_US', 
          Country_Domain__c='rvar-fr',
          IsActive=true,
          EmailEncodingKey = 'ISO-8859-1', 
          ProfileId = ([select Id from Profile where name = 'System Administrator'])[0].id, 
          LanguageLocaleKey = 'en_us');

        //[END] RA 20.MAY.2015 

        newAccount = [Select ID from Account Where Name='Test Class DO NOT TOUCH'];
        newAccount.CurrencyIsoCode = 'USD';
        newAccount.BillingStreet = '10 Main Rd.';
        newAccount.BillingState = 'NY';
        newAccount.BillingCity = 'New York';
        newAccount.BillingCountry = 'United States';
        newAccount.BillingPostalCode = '31349';
        newAccount.ShippingStreet = 'The Landmark @ One Market, Suite 300';
        newAccount.ShippingState = 'CA';
        newAccount.ShippingCity = 'San Francisco';
        newAccount.ShippingCountry = 'United States';
        newAccount.ShippingPostalCode = '94105';
        newAccount.x_Account_Owner__c = newAccount.OwnerId;
        update newAccount;
  
  
   Map<String, Id> mRTquo = new Map<String, Id>();
   Map<String, Id> mRTitm = new Map<String, Id>();
   Map<String, Id> mRTusr = new Map<String, Id>();
   //Birlasoft Rashmi - optimizing record type queries
   List<String> lstrec = new List<String>{'Quote','Item__c'};
   
   for(RecordType rt : GW_RecTypes.getRecordTypeforSelectedObjectList(lstrec))
    {
      if(rt.sObjectType == 'Quote')
        mRTquo.put(rt.Name, rt.Id);
      if(rt.sObjectType == 'Item__c')
        mRTitm.put(rt.Name, rt.Id);
            
    }
    
        newContact = TestUtils.createContact('QuickQuote TEST CONTACT 1', newAccount.Id, true );
        newOpportunity = TestUtils.createOpportunities(1, newAccount.id, newContact.Id, true).get(0);
        
        Quote_Summary__c QS = new Quote_Summary__c();
        
          QS.opportunity__c = newOpportunity.id;
          QS.Account_Name__c = newAccount.id;
          QS.Lease_Doc_Signed__c = true;
          insert QS;
          
    
        newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test1 ', newOpportunity.Id, false).get(0);
        
      newQuote.Opportunityid = newOpportunity.id;
      newQuote.account__c = newOpportunity.Accountid;
      newQuote.Quote_Summary__c = QS.id;
      newQuote.Oracle_Vendor_email_field_value__c = 'test@test.com';// Rishi
      //Q.TestPSR_Email__c = 'test2@test2.com';// Rishi
      newQuote.Primary_PSR_Email_Id__c = 'test3@test3.com';// Rishi
      newQuote.Inverter_Brand__c = 'SunPower';// Rishi
      newQuote.Inverter_Model__c = 'SPR-5000m (240V)';// Rishi
      newQuote.Inverter_Quantity__c = 1;// Rishi
      newQuote.Inverter_Brand_2__c = 'SunPower 2';// Rishi
      newQuote.Inverter_Model_2__c = 'SPR-5000m (241V)';// Rishi
      newQuote.Inverter_Quantity_2__c = 2;// Rishi
      newQuote.Inverter_Brand_3__c = 'SunPower 3';// Rishi
      newQuote.Inverter_Model_3__c = 'SPR-5000m (242V)';// Rishi
      newQuote.Inverter_Quantity_3__c = 3;// Rishi
      newQuote.Inverter_Brand_4__c = 'SunPower 4';// Rishi
      newQuote.Inverter_Model_4__c = 'SPR-5000m (243V)';// Rishi
      newQuote.Inverter_Quantity_4__c = 4;// Rishi
      newQuote.Quote_Inverter_Values__c = 'SunPower SPR-5000m (240V) 7';// Rishi 
      newQuote.Temp_Contact_1__c = newContact.ID;
      newQuote.Dealer_Fees__c = 300;
      newQuote.recordTypeId = mRTquo.get('Proposal Quote');
      newQuote.Is_Locked__c = false;
      newQuote.Lease_Doc_Signed__c = false;
      
      insert newQuote;
      
      
      
      List<Item__c> lstI = new List<Item__c>();
       for(integer i=1; i<11; i++)
      {
      Item__c It = new Item__c();
      It.name = 'Test Item' + String.valueOf(i);
      It.Item_ID__c = '21462'+String.valueOf(i);
      It.Active__c = True;
      It.CurrencyIsoCode = 'USD';
     // It.Description__c = 'Test Item' + String.valueOf(i)+'Test oracle Item' + String.valueOf(i);
      It.Description__c = 'PERFORMANCE GUARANTEE';
      It.Long_Description__c = 'PERFORMANCE GUARANTEE';
      It.Product_Type__c = 'Test Product' + String.valueOf(i);
      It.Item_Category_1__c = 'Test Item Catrgory1' + String.valueOf(i);
      It.Item_Category_1__c = 'Test Item Catrgory2' + String.valueOf(i);
      It.Item_Category_1__c = '3' + String.valueOf(i);
      if(i<3)
          It.Line_Type__c = 'Standard Line';
      else
          It.Line_Type__c = 'Credit Only';
      lstI.add(It);
    }
    insert lstI;
    
    List<Quote_Line__c> lstQL = new List<Quote_Line__c>();
   
      for(Integer j=0; j<lstI.size(); j++)
      {
        Quote_Line__c QL = new Quote_Line__c();
        QL.Quote__c = newQuote.id;
        QL.Quantity__c = 5;
        QL.Unit_Price__c = 101;
        QL.CurrencyIsoCode = 'USD';
        QL.Item__c = lstI[j].Id;
        lstQL.add(QL);
      }
    
    insert lstQL;
    
    Lease_Schedule__c LSList ;
         List<Lease_Schedule__c> lstSched= new List<Lease_Schedule__c>();
          Lease_2_1_PO_Creation__c mc = Lease_2_1_PO_Creation__c.getValues('Year Number');
          if(mc == null)
          {
            mc = new Lease_2_1_PO_Creation__c ( Name = 'Year Number');
            mc.Guarantee_Number__c = 50;
            insert mc;
          }
          Lease_Schedule__c ls = new Lease_Schedule__c();     
          ls.Remaining_Lease_Period__c = 'Year' +' 1';
          ls.Guarantee_Year__c = 'Year'+' 1';
          ls.Annual_Lease_Payments_Year__c = +'2001';
          ls.Temp_Monthly_Lease_Payments__c = 'Year'+ '1' + '11 Monthly Lease Payments';
          ls.Monthly_Payments_and_with_automatic_ACH__c = '11 monthly payments of $277.87';
          ls.Quote__c = newquote.Id;
          
          insert ls;
          
          FR_Record_Type__c frt1 = FR_Record_Type__c.getValues('FR RecordType Id');
    String leasePaymentRTId  = frt1.FR_LeasePayment_RT_Id__c;
          
          list<LeasePayment__c> lstLP = new List<LeasePayment__c>(); 
       for(integer i=1; i<3; i++){
    lstLP.add(new LeasePayment__c(name= 'lptest'+i,       
                                            Quote__c= newquote.ID,
                                            Opportunity__c = newOpportunity.ID,
                                            Account__c = newaccount.ID, //Partner_Account__c = qq.Account__r.ParentId,
                                            End_Customer_Account__c = newaccount.ID,
                                            RecordTypeId =leasePaymentRTId,
                                            Contact__c = newcontact.ID,
                                            Date_Lease_Document_signed__c = Date.Today(),
                                            Partner_Account__c = newaccount.ID
                                             ));
             } 
            insert lstLP;
            
            List<Purchase_Order__c> lstlpo = new LIst<Purchase_Order__c>();
             for(integer i=1; i<3; i++){
          lstlpo.add(new Purchase_Order__c(name= 'Testlp'+i,
                                          Quote__c= newquote.Id,
                                          Dealer_Fees__c= 7385, 
                                          Projected_Install__c= null, 
                                          Opportunity__c= newopportunity.ID,
                                          Dealer_Account__c= newaccount.ID,
                                          End_Customer_Account__c= newaccount.ID));                                          
         }
          insert lstlpo ; 
          
          
    Test.StartTest();

     
       newQuote.Is_Locked__c = true;
       newQuote.Lease_Doc_Signed__c = true;
      
     update newQuote;

   Test.StopTest();
  
}

public static testMethod void TM2()
     {
        Account newAccount;
        Contact newContact;
        Opportunity newOpportunity;
        Quote newQuote;
        
        //Profile p = [SELECT Id FROM Profile WHERE Name='system administrator']; 
        //User u = [select id from User where ProfileId =: p.Id and IsActive=true and Country_Domain__c='rvar-fr' limit 1];
        
        //[START] RA 20.MAY.2015 - created test user to avoid errors in query encountered on every deployment 
        User Usr = new User(
          Username = 'testxxx@sunpower.com',
          LastName = 'xxxx', 
          Email = 'testxxx@sunpower.com', 
          Alias = 'testxxx', 
          CommunityNickname = 'testxxxx',
          TimeZoneSidKey = 'America/Los_Angeles', 
          LocaleSidKey = 'en_US', 
          Country_Domain__c='rvar-fr',
          IsActive=true,
          EmailEncodingKey = 'ISO-8859-1', 
          ProfileId = ([select Id from Profile where name = 'System Administrator'])[0].id, 
          LanguageLocaleKey = 'en_us');

        //[END] RA 20.MAY.2015 

        newAccount = [Select ID from Account Where Name='Test Class DO NOT TOUCH'];
        newAccount.CurrencyIsoCode = 'USD';
        newAccount.BillingStreet = '10 Main Rd.';
        newAccount.BillingState = 'NY';
        newAccount.BillingCity = 'New York';
        newAccount.BillingCountry = 'France';
        newAccount.BillingPostalCode = '31349';
        newAccount.ShippingStreet = 'The Landmark @ One Market, Suite 300';
        newAccount.ShippingState = 'CA';
        newAccount.ShippingCity = 'San Francisco';
        newAccount.ShippingCountry = 'United States';
        newAccount.ShippingPostalCode = '94105';
        newAccount.x_Account_Owner__c = newAccount.OwnerId;
        update newAccount;
  
  
   Map<String, Id> mRTquo = new Map<String, Id>();
   Map<String, Id> mRTitm = new Map<String, Id>();
   Map<String, Id> mRTusr = new Map<String, Id>();
   //Birlasoft Rashmi - optimizing record type queries
   List<String> lstrec = new List<String>{'Quote','Item__c'};
   
   for(RecordType rt : GW_RecTypes.getRecordTypeforSelectedObjectList(lstrec))
    {
      if(rt.sObjectType == 'Quote')
        mRTquo.put(rt.Name, rt.Id);
      if(rt.sObjectType == 'Item__c')
        mRTitm.put(rt.Name, rt.Id);
            
    }
    
        newContact = TestUtils.createContact('QuickQuote TEST CONTACT 1', newAccount.Id, false );
        newContact.Phone = '11 22 22 22 22';
        insert newContact;
        
        newOpportunity = TestUtils.createOpportunities(1, newAccount.id, newContact.Id, true).get(0);
        
        Quote_Summary__c QS = new Quote_Summary__c();
        
          QS.opportunity__c = newOpportunity.id;
          QS.Account_Name__c = newAccount.id;
          QS.Lease_Doc_Signed__c = true;
          insert QS;
    
        newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test1 ', newOpportunity.Id, false).get(0);
        
      newQuote.Opportunityid = newOpportunity.id;
      newQuote.account__c = newOpportunity.Accountid;
      newQuote.Quote_Summary__c = QS.id;
      newQuote.Oracle_Vendor_email_field_value__c = 'test@test.com';// Rishi
      //Q.TestPSR_Email__c = 'test2@test2.com';// Rishi
      newQuote.Primary_PSR_Email_Id__c = 'test3@test3.com';// Rishi
      newQuote.Inverter_Brand__c = 'SunPower';// Rishi
      newQuote.Inverter_Model__c = 'SPR-5000m (240V)';// Rishi
      newQuote.Inverter_Quantity__c = 1;// Rishi
      newQuote.Inverter_Brand_2__c = 'SunPower 2';// Rishi
      newQuote.Inverter_Model_2__c = 'SPR-5000m (241V)';// Rishi
      newQuote.Inverter_Quantity_2__c = 2;// Rishi
      newQuote.Inverter_Brand_3__c = 'SunPower 3';// Rishi
      newQuote.Inverter_Model_3__c = 'SPR-5000m (242V)';// Rishi
      newQuote.Inverter_Quantity_3__c = 3;// Rishi
      newQuote.Inverter_Brand_4__c = 'SunPower 4';// Rishi
      newQuote.Inverter_Model_4__c = 'SPR-5000m (243V)';// Rishi
      newQuote.Inverter_Quantity_4__c = 4;// Rishi
      newQuote.Quote_Inverter_Values__c = 'SunPower SPR-5000m (240V) 7';// Rishi 
      newQuote.Temp_Contact_1__c = newContact.ID;
      newQuote.Dealer_Fees__c = 300;
      newQuote.recordTypeId = mRTquo.get('Proposal Quote');
      newQuote.Is_Locked__c = false;
      newQuote.Lease_Doc_Signed__c = false;
      
      insert newQuote;
      
      List<Item__c> lstI = new List<Item__c>();
       for(integer i=1; i<11; i++)
      {
      Item__c It = new Item__c();
      It.name = 'Test Item' + String.valueOf(i);
      It.Item_ID__c = '21462'+String.valueOf(i);
      It.Active__c = True;
      It.CurrencyIsoCode = 'USD';
     // It.Description__c = 'Test Item' + String.valueOf(i)+'Test oracle Item' + String.valueOf(i);
      It.Description__c = 'PERFORMANCE GUARANTEE';
      It.Long_Description__c = 'PERFORMANCE GUARANTEE';
      It.Product_Type__c = 'Test Product' + String.valueOf(i);
      It.Item_Category_1__c = 'Test Item Catrgory1' + String.valueOf(i);
      It.Item_Category_1__c = 'Test Item Catrgory2' + String.valueOf(i);
      It.Item_Category_1__c = '3' + String.valueOf(i);
      if(i<3)
          It.Line_Type__c = 'Standard Line';
      else
          It.Line_Type__c = 'Credit Only';
      lstI.add(It);
    }
    
    insert lstI;
    
    
    FR_Record_Type__c frt1 = FR_Record_Type__c.getValues('FR RecordType Id');
    String leasePaymentRTId  = frt1.FR_LeasePayment_RT_Id__c;
      
      list<LeasePayment__c> lstLP = new List<LeasePayment__c>(); 
       for(integer i=1; i<3; i++){
    lstLP.add(new LeasePayment__c(name= 'lptest'+i,       
                                            Quote__c= newquote.ID,
                                            Opportunity__c = newOpportunity.ID,
                                            Account__c = newaccount.ID, //Partner_Account__c = qq.Account__r.ParentId,
                                            End_Customer_Account__c = newaccount.ID,
                                            RecordTypeId =leasePaymentRTId,
                                            Contact__c = newcontact.ID,
                                            Date_Lease_Document_signed__c = Date.Today(),
                                            Partner_Account__c = newaccount.ID
                                             ));
             } 
            insert lstLP;
            
            List<Purchase_Order__c> lstlpo = new LIst<Purchase_Order__c>();
             for(integer i=1; i<3; i++){
          lstlpo.add(new Purchase_Order__c(name= 'Testlp'+i,
                                          Quote__c= newquote.Id,
                                          Dealer_Fees__c= 7385, 
                                          Projected_Install__c= null, 
                                          Opportunity__c= newopportunity.ID,
                                          Dealer_Account__c= newaccount.ID,
                                          End_Customer_Account__c= newaccount.ID));                                          
         }
          insert lstlpo ;  
          
    
    
    Test.StartTest();

     
       newQuote.Is_Locked__c = true;
       newQuote.Lease_Doc_Signed__c = true;
      
     update newQuote;

   Test.StopTest();
  
}*/

  
}