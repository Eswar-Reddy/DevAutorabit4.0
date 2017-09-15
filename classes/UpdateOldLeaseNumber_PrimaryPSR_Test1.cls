@isTest(SeeAllData=true)
private class UpdateOldLeaseNumber_PrimaryPSR_Test1
{
    static TestMethod void TM1()
    {
      //Map<String, Id> mRTacc = new Map<String, Id>();
      //Map<String, Id> mRTcon = new Map<String, Id>();
      //Map<String, Id> mRTopp = new Map<String, Id>();
      Map<String, Id> mRTquo = new Map<String, Id>();
      Map<String, Id> mRTitm = new Map<String, Id>();
      Map<String, Id> mRTusr = new Map<String, Id>();
      Map<String, Id> mRTPL = new Map<String, Id>();
      Map<String, Id> mRTPLI = new Map<String, Id>();
/***** RECORD TYPES *****/    
      for(RecordType rt : [SELECT id, name, sObjectType FROM RecordType WHERE sObjectType IN ('Quote','Item__c','Price_List__c','Price_List_Item__c')])
      {
        if(rt.sObjectType == 'Quote')
          mRTquo.put(rt.Name, rt.Id);
        if(rt.sObjectType == 'Item__c')
          mRTitm.put(rt.Name, rt.Id);
        if(rt.sObjectType == 'Price_List__c')
          mRTPL.put(rt.Name, rt.Id);
        if(rt.sObjectType == 'Price_List_Item__c')
          mRTPLI.put(rt.Name, rt.Id);         
      }
/*** END RECORD TYPE ***/

/***** USER *****/    
      for(user rt : [SELECT id, name FROM user])
      {
        mRTusr.put(rt.Name, rt.Id);
      }
/*** END USER ***/

/**** FETCH DATA *****/
    List<Account> lstacc = [SELECT Id, Name, OwnerId, Partner_Account__c FROM Account WHERE OwnerId =: mRTusr.get('David Lorenzo') AND Name Like 'Sample %' ];
    List<Contact> lstcon = [SELECT Id, Name, OwnerId, AccountId FROM Contact WHERE OwnerId =: mRTusr.get('David Lorenzo') AND Name Like 'Sample %' ];
    List<Opportunity> lstopp = [SELECT Id, Name, OwnerId, AccountId FROM Opportunity WHERE OwnerId =: mRTusr.get('David Lorenzo') AND Name Like 'Sample %' ];
/**** END FETCH DATA *****/    

/***** ACCOUNT *****        
      List<Account> lstAcc = new List<Account>();
      for(Integer i=0; i<5; i++)
      {
        Account acc = new Account();
        acc.Name = 'Testing of Account' + String.valueOf(i);
        acc.BillingStreet = '10 Main Rd.';
        acc.BillingState = 'NY';
        acc.BillingCity = 'New York';
        acc.BillingCountry = 'United States';
        acc.BillingPostalCode = '31349';
        acc.ShippingStreet = 'The Landmark @ One Market, Suite 300';
        acc.ShippingState = 'CA';
        acc.ShippingCity = 'San Francisco';
        acc.ShippingCountry = 'United States';
        acc.ShippingPostalCode = '94105';
        acc.x_Account_Owner__c = mRTusr.get('Chris Mahoney');
        if(i<1)
        {
          acc.recordTypeId = mRTacc.get('Other');
          acc.Oracle_Vendor_Number__c = '30';
          acc.Oracle_Vendor_Site_Code__c = '51';
        }
        if(i<2 && i>0)
        {
            acc.recordTypeId = mRTacc.get('Residential Customer');
            acc.Oracle_Vendor_Number__c = '40';
            acc.Oracle_Vendor_Site_Code__c = '61';
        }
        if(i<3 && i>1)
        {
            acc.recordTypeId = mRTacc.get('Commercial Customer');
            acc.Oracle_Vendor_Number__c = '50';
            acc.Oracle_Vendor_Site_Code__c = '71';
        }
        if(i<4 && i>2)
        {
            acc.recordTypeId = mRTacc.get('Partner');
            acc.Oracle_Vendor_Number__c = '60';
            acc.Oracle_Vendor_Site_Code__c = '81';
        }
        if(i<5 && i>3)
        {
            acc.recordTypeId = mRTacc.get('Standard');
            acc.Oracle_Vendor_Number__c = '70';
            acc.Oracle_Vendor_Site_Code__c = '91';
        }        
        lstAcc.add(acc);
      }
      insert lstAcc;
/*** END ACCOUNT ***/

/***** CONTACT *****      
      List<Contact> lstCon = new List<Contact>();
      for(Integer i=0; i<lstAcc.size(); i++)
      {
        for(Integer j=0; j<5; j++)
        {
          Contact con = new Contact();
          con.accountid = lstAcc[i].id;
          con.LastName = 'Contact ' + String.valueOf(j);
          con.Email = 'contact' + String.valueOf(i) + '.test' + String.valueOf(j) + '@test.com';
          if(j<3)
          {
            con.recordTypeId = mRTcon.get('Customer');
            con.LMS_Job_ID__c = 'Sales';
          }
          if(j<5 && j>2)
          {
            con.recordTypeId = mRTcon.get('Systems');
            con.LMS_Job_ID__c = 'Business';
          }
          lstCon.add(con);
        }
      }
      insert lstCon;
/*** END CONTACT ***/

/***** OPPORTUNITY *****      
      List<opportunity> lstOpp = new List<opportunity>();
      for(integer i=0; i<lstAcc.size(); i++)
      {
        opportunity Opp = new opportunity();
        Opp.Name = 'Test Oppuriunity' + String.valueOf(i);
        Opp.accountid = lstAcc[i].id;
        Opp.CurrencyIsoCode = 'USD';
        if(i<1)
        {
            Opp.recordTypeId = mRTopp.get('Commercial');
            opp.StageName = '12% - Qualified Opportunity';
            opp.CloseDate = date.newInstance(2012, 5, 12);
        }
        if(i<2 && i>0)
        {
            Opp.recordTypeId = mRTopp.get('Components');
            opp.StageName = '20% - Pre-Purchase Review Received';
            opp.CloseDate = date.newInstance(2012, 5, 12);
        }
        if(i<3 && i>1)
        {
            Opp.recordTypeId = mRTopp.get('Development');
            opp.StageName = '20% - Opportunity Contacted';
            opp.CloseDate = date.newInstance(2012, 5, 12);
        }
        if(i<5 && i>2)
        {
            Opp.recordTypeId = mRTopp.get('Home Owner');
            opp.StageName = '100% - Delivered';
            opp.CloseDate = date.newInstance(2012, 5, 12);
        }
        lstOpp.add(Opp);
      }
      insert lstOpp;
/*** END OPPORTUNITY ***/      

/***** CUSTOM SETTING *****/
      Lease_2_1_PO_Creation__c L21POC = [SELECT id, Safe_Harbour_Calculation__c, 
                                                Price_List_Name__c, 
                                                Lease_InterConnect_Percentage__c, 
                                                Lease_Installation_Percentage__c, 
                                                Lease_Origination_Percentage__c 
                                         FROM Lease_2_1_PO_Creation__c 
                                         WHERE name= 'Settings'];
      L21POC.Price_List_Name__c = 'India - Lease Price list 07072012';
      L21POC.Lease_InterConnect_Percentage__c = 0.20;
      L21POC.Lease_Installation_Percentage__c = 0.70;
      L21POC.Lease_Origination_Percentage__c = 0.40;
      L21POC.Safe_Harbour_Calculation__c = 0.055;
      update L21POC;      
/*** END CUSTOM SETTING ***/

/***** PRICE LIST *****/      
      //List<Price_List__c> lstPLc = new List<Price_List__c>();
      Price_List__c PLc = new Price_List__c();
      PLc.Name = L21POC.Price_List_Name__c;
      PLc.CurrencyIsoCode = 'USD';
      PLc.Oracle_Operating_Unit__c = 'SPEB OU1';
      PLc.Expedite_Fee__c = 10;
      PLc.Will_Call_Fee__c = 10;
      PLc.Packaged_System_Item_ID__c = '102868';
      PLc.DSR_PO_Group_Email__c = 'shree.prashant@birlasoft.com';
      PLc.Promotional_Discount_Item_Id__c = '135176';
      PLc.recordTypeId = mRTPL.get('NA');
      insert PLc;
/*** END PRICE LIST ***/

/***** ITEM *****/    
      List<Item__c> lstI = new List<Item__c>();
      for(integer i=1; i<11; i++)
      {
          Item__c It = new Item__c();
          It.name = 'Test Item' + String.valueOf(i);
          It.Item_ID__c = '21462'+String.valueOf(i);
          It.Active__c = True;
          It.CurrencyIsoCode = 'USD';
          It.Description__c = 'Test Item' + String.valueOf(i)+'Test oracle Item' + String.valueOf(i);
          It.Long_Description__c = 'Test oracle Item' + String.valueOf(i)+'Test Item' + String.valueOf(i);
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
  /***** Safe Harbour Item *****/    
      List<Item__c> lstI2SH = new List<Item__c>();
      for(Integer i=1; i<11; i++)
      {
          Item__c It = new Item__c();
          It.name = 'Test SH Item' + String.valueOf(i);
          It.Item_ID__c = '21463'+String.valueOf(i);
          It.Active__c = True;
          It.CurrencyIsoCode = 'USD';
          It.Description__c = 'Test SH Item' + String.valueOf(i)+'Test oracle Item' + String.valueOf(i);
          It.Long_Description__c = 'Test SH oracle Item' + String.valueOf(i)+'Test Item' + String.valueOf(i);
          It.Product_Type__c = 'Test SH Product' + String.valueOf(i);
          It.Item_Category_1__c = 'Test Item Catrgory1' + String.valueOf(i);
          It.Item_Category_1__c = 'Test Item Catrgory2' + String.valueOf(i);
          It.Item_Category_1__c = '4' + String.valueOf(i);
          if(i<3)
              It.Line_Type__c = 'Standard Line';
          else
              It.Line_Type__c = 'Credit Only';
          lstI2SH.add(It);    
      }
      insert lstI2SH;   
  /*** End Safe Harbour Item ***/     
/*** END ITEM ***/

/***** PRICE LIST ITEM *****/      
      List<Price_List_Item__c> lstPLI = new List<Price_List_Item__c>();
      for(Integer i=0; i<lstI.size(); i++)
      {
        Price_List_Item__c PLI = new Price_List_Item__c();
        PLI.Price_List__c = PLc.id;
        PLI.Name = lstI[i].Name + ' Price List Item';
        PLI.Item_ID__c = lstI[i].id;
        PLI.CurrencyIsoCode = 'USD';
        PLI.recordTypeId = mRTPLI.get('EU');
        PLI.Effective_Start_Date__c = Date.Today().addDays(-30); 
        PLI.Effective_End_Date__c = Date.Today().addDays(30);

          PLI.Safe_Harbor_ITEM__c = lstI2SH[i].Id; 
          PLI.Cost_per_Panel_cell_SH__c = 77 + i; 
          PLI.Cost_of_System_Per_Panel__c = 177 + i;
       
        lstPLI.add(PLI);
      }
      insert lstPLI;
/*** END PRICE LIST ITEM ***/ 

/***** QUOTE SUMMARY *****/      
      List<Quote_Summary__c> lstQS = new List<Quote_Summary__c>();
      for(integer i=0; i<lstOpp.size(); i++)
      {
        Quote_Summary__c QS = new Quote_Summary__c();
        QS.opportunity__c = lstOpp[i].id;
        QS.Account_Name__c = lstAcc[i].id;
        QS.Lease_Doc_Signed__c = true;
        lstQS.add(QS);
      }
      insert lstQS;
/*** END QUOTE SUMMARY ***/

/***** QUOTE *****/      
      List<Quote> lstQ = new List<Quote>();
      for(integer i=0; i<lstOpp.size(); i++)
      {
        Quote Q = new Quote();
        Q.Opportunityid = lstOpp[i].id;
        Q.account__c = lstAcc[i].id;
        Q.Quote_Summary__c = lstQS[i].id;
        Q.Name = 'Test Quote' + String.valueOf(i);
        Q.Temp_Contact_1__c = lstCon[1].id;
        Q.Temp_Contact_2__c = lstCon[2].id;
            //Q.recordTypeId = mRTquo.get('Components');
        Q.Dealer_Fees__c = 300;
        Q.recordTypeId = mRTquo.get('Proposal Quote');
        Q.Is_Locked__c = false;
        Q.Lease_Doc_Signed__c = false;
        lstQ.add(Q);
      }
      insert lstQ;
/*** END QUOTE ***/ 

/***** QUOTE LINE *****/      
      List<Quote_Line__c> lstQL = new List<Quote_Line__c>();
      for(integer i=0; i<lstQ.size(); i++)
      {
        for(Integer j=0; j<lstI.size(); j++)
        {
          Quote_Line__c QL = new Quote_Line__c();
          QL.Quote__c = lstQ[i].id;
          QL.Quantity__c = 3+i+j;
          QL.Unit_Price__c = 99+i+j;
          QL.CurrencyIsoCode = 'USD';
          QL.Item__c = lstI[j].Id;
          lstQL.add(QL);
        }
      }
      insert lstQL;
/***** END QUOTE LINE *****/

/***** QUOTE UPDATE *****/
  //List<Id> lstQuoteIds = new List<Id>();
  for(Integer i=0; i<lstQ.size(); i++)
  {
    lstQ[i].Is_Locked__c = true;
    lstQ[i].Is_Quote_Locked__c = true;
    lstQ[i].Lease_Doc_Signed__c = true;
    //lstQuoteIds.add(lstQ[i].Id);
  }
  update lstQ;
/*** END QUOTE UPDATE ***/

Test.startTest();
/*** SECOND QUOTE SUMMARY CREATION ****/
/***** SECOND QUOTE SUMMARY *****/      
      List<Quote_Summary__c> lstQS2 = new List<Quote_Summary__c>();
      for(integer i=0; i<lstOpp.size(); i++)
      {
        Quote_Summary__c QS = new Quote_Summary__c();
        QS.opportunity__c = lstOpp[i].id;
        QS.Account_Name__c = lstAcc[i].id;
        //QS.Lease_Doc_Signed__c = true;
        lstQS2.add(QS);
      }
      insert lstQS2;
/*** END SECOND QUOTE SUMMARY ***/

/***** SECOND QUOTE *****/      
      List<Quote> lstQ2 = new List<Quote>();
      for(integer i=0; i<lstOpp.size(); i++)
      {
        Quote Q = new Quote();
        Q.Opportunityid = lstOpp[i].id;
        Q.account__c = lstAcc[i].id;
        Q.Quote_Summary__c = lstQS2[i].id;
        Q.Name = 'Test Quote' + String.valueOf(i);
        Q.Temp_Contact_1__c = lstCon[1].id;
        Q.Temp_Contact_2__c = lstCon[2].id;
            //Q.recordTypeId = mRTquo.get('Components');
        Q.Dealer_Fees__c = 300;
        Q.recordTypeId = mRTquo.get('Proposal Quote');
        Q.Is_Locked__c = false;
        Q.Lease_Doc_Signed__c = false;
        lstQ2.add(Q);
      }
      insert lstQ2;
/*** END SECOND QUOTE ***/ 

/***** SECOND QUOTE LINE *****/      
      List<Quote_Line__c> lstQL2 = new List<Quote_Line__c>();
      for(integer i=0; i<lstQ2.size(); i++)
      {
        for(Integer j=0; j<lstI.size(); j++)
        {
          Quote_Line__c QL = new Quote_Line__c();
          QL.Quote__c = lstQ2[i].id;
          QL.Quantity__c = 3+i+j;
          QL.Unit_Price__c = 99+i+j;
          QL.CurrencyIsoCode = 'USD';
          QL.Item__c = lstI[j].Id;
          lstQL2.add(QL);
        }
      }
      insert lstQL2;
/***** END SECOND QUOTE LINE *****/

/***** SECOND QUOTE UPDATE *****/
  //List<Id> lstQuoteIds = new List<Id>();
  for(Integer i=0; i<lstQ2.size(); i++)
  {
    lstQ2[i].Is_Locked__c = true;
    lstQ2[i].Is_Quote_Locked__c = true;
    lstQ2[i].Lease_Doc_Signed__c = true;
    
    //lstQuoteIds.add(lstQ[i].Id);
  }
  update lstQ2;
/*** SECOND END QUOTE UPDATE ***/

/*** UPDATE QUOTE SUMMARY WITH OLD QUOTE(REVISION TO)  *******/
  for(integer i=0; i<lstQS2.size(); i++){
      lstQS2[i].Old_Quote__c = lstQS[i].Id;
  }
   update lstQS2;
/*** END UPDATE QUOTE SUMMARY WITH OLD QUOTE(REVISION TO)  *******/

for(integer i=0; i<lstQS2.size(); i++){
      lstQS2[i].Old_Quote__c = null;
  }
   update lstQS2;
/*** SECOND QUOTE SUMMARY CREATION ****/
Test.stopTest();
}
}