/* TestMethod class to do code coverage for 
 * Quote Trigger --> CreatePurchaseOrderandPurchaseOrderLine
 * Uses Org data to do the validation of the trigger code
 */
@isTest(SeeAllData=true)
public class CreatePOandPOLTrigOrgData_Test
{
  public static testMethod void TM1()
  {
   Test.StartTest();
   Map<String, Id> mRTquo = new Map<String, Id>();
   Map<String, Id> mRTitm = new Map<String, Id>();
   Map<String, Id> mRTPLI = new Map<String, Id>();
   Map<String, Id> mRTusr = new Map<String, Id>();
   
   for(RecordType rt : [SELECT id, name, sObjectType FROM RecordType WHERE sObjectType IN ('Quote','Item__c', 'Price_List_Item__c')])
    {
      if(rt.sObjectType == 'Quote')
        mRTquo.put(rt.Name, rt.Id);
      if(rt.sObjectType == 'Item__c')
        mRTitm.put(rt.Name, rt.Id);
      if(rt.sObjectType == 'Price_List_Item__c')
        mRTPLI.put(rt.Name, rt.Id);
    }

    for(user rt : [SELECT id, name FROM user])
      mRTusr.put(rt.Name, rt.Id);  
      
    List<Account> lstacc = [SELECT Id, Name, OwnerId, Partner_Account__c FROM Account WHERE OwnerId =: mRTusr.get('David Lorenzo') AND Name Like 'Sample %' ];
    List<Contact> lstcon = [SELECT Id, Name, OwnerId, AccountId FROM Contact WHERE OwnerId =: mRTusr.get('David Lorenzo') AND Name Like 'Sample %' ];
    List<Opportunity> lstopp = [SELECT Id, Name, OwnerId, AccountId FROM Opportunity WHERE OwnerId =: mRTusr.get('David Lorenzo') AND Name Like 'Sample %' ];
 
    /***** QUOTE SUMMARY *****/  
    List<Quote_Summary__c> lstQS = new List<Quote_Summary__c>();
    for(integer i=0; i<lstopp.size(); i++)
    {
      Quote_Summary__c QS = new Quote_Summary__c();
      QS.opportunity__c = lstopp[i].id;
      QS.Account_Name__c = lstacc[i].id;
      QS.Lease_Doc_Signed__c = true;
      lstQS.add(QS);
    }
    insert lstQS;
    /*** END QUOTE SUMMARY ***/
    
    /***** QUOTE *****/  
    List<Quote> lstQ = new List<Quote>();
    for(integer i=0; i<lstopp.size(); i++)
    {
      Quote Q = new Quote();
      Q.Opportunityid = lstopp[i].id;
      Q.account__c = lstacc[i].id;
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
    //system.debug('-->Q-0-->' + lstQ[0].name);
    /***** CUSTOM SETTING *****/
    Lease_2_1_PO_Creation__c L21POC = new Lease_2_1_PO_Creation__c();
    L21POC = [SELECT id, 
                     Safe_Harbour_Calculation__c, 
                     Price_List_Name__c, 
                     Lease_InterConnect_Percentage__c, 
                     Lease_Installation_Percentage__c, 
                     Lease_Origination_Percentage__c 
             FROM Lease_2_1_PO_Creation__c 
             WHERE name= 'Settings'];
    /***** End CUSTOM SETTING *****/
    
    /***** PRICE LIST *****/
    Price_List__c PLc = new Price_List__c();
    PLc = [ SELECT Name, CurrencyIsoCode, Oracle_Operating_Unit__c, 
                   Expedite_Fee__c, Will_Call_Fee__c, Packaged_System_Item_ID__c, 
                   DSR_PO_Group_Email__c, Promotional_Discount_Item_Id__c, recordTypeId 
            FROM Price_List__c     
            WHERE Name=: L21POC.Price_List_Name__c];
    /***** End PRICE LIST *****/
    
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
    for(Integer i=11; i<16; i++)
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
  /***** Sample ITEM *****/
  List<Item__c> lstISamp = new List<Item__c>();
  for(integer i=1; i<4; i++)
    {
      Item__c It = new Item__c();
      It.name = 'Test Item' + String.valueOf(i);
      It.Item_ID__c = '21464'+String.valueOf(i);
      It.Active__c = True;
      It.CurrencyIsoCode = 'USD';
      It.Description__c = 'Test Sample Item' + String.valueOf(i)+'Test oracle Item' + String.valueOf(i);
      It.Long_Description__c = 'Test Sample oracle Item' + String.valueOf(i)+'Test Item' + String.valueOf(i);
      It.Product_Type__c = 'Test Sample Product' + String.valueOf(i);
      It.Item_Category_1__c = 'Test Item Catrgory1' + String.valueOf(i);
      It.Item_Category_1__c = 'Test Item Catrgory2' + String.valueOf(i);
      It.Item_Category_1__c = '3' + String.valueOf(i);
      if(i<2)
          It.Line_Type__c = 'Standard Line';
      else
          It.Line_Type__c = 'Credit Only';
      lstISamp.add(It);
    }
    insert lstISamp;
  /***** End Sample ITEM *****/
    /***** End ITEM *****/
    
    /***** PRICE LIST ITEM *****/
    List<Price_List_Item__c> lstPLI = new List<Price_List_Item__c>();
    for(Integer i=0; i<10; i++)
    {
      Price_List_Item__c PLI = new Price_List_Item__c();
      PLI.Price_List__c = PLc.id;
      PLI.Name = lstI[i].Name + ' Price List Item';
      PLI.CurrencyIsoCode = 'USD';
      PLI.Pricing_1__c = 0.0+i;
      PLI.recordTypeId = mRTPLI.get('EU');
      PLI.Effective_Start_Date__c = Date.Today().addDays(-30); 
      PLI.Effective_End_Date__c = Date.Today().addDays(30);
      PLI.Cost_per_Panel_cell_SH__c = 77 + i; 
      PLI.Cost_of_System_Per_Panel__c = 177 + i;
      if(i<4)
      {
        PLI.Safe_Harbor_ITEM__c = lstI2SH[i].Id; 
        PLI.Item_ID__c = lstI[i].id;
      }
      if(i==4)
      {
        PLI.Safe_Harbor_ITEM__c = lstI2SH[i].Id; 
        PLI.Item_ID__c = lstI[i].id;
        PLI.Disc_Item_ID__c = lstISamp[0].id;
      }
      if(i==5)
      {
        PLI.Item_ID__c = lstI[i].id;
        PLI.Disc_Item_ID__c = lstISamp[1].id;
      }
      if(i==6)
      {
        PLI.Item_ID__c = lstI[i].id;
        PLI.Disc_Item_ID__c = lstISamp[2].id;
      }
      if(i<10 && i>6)
      {PLI.Item_ID__c = lstI[i].id;}
      
      lstPLI.add(PLI);
    }
    insert lstPLI;
/*** END PRICE LIST ITEM ***/
    
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
    for(Integer i=0; i<lstQ.size(); i++)
    {
      lstQ[i].Is_Locked__c = true;
      lstQ[i].Lease_Doc_Signed__c = true;
    }
    //system.debug('-->Q-1-->' + lstQ[1].name);
    update lstQ;
    //system.debug('-->Q-2-->' + lstQ[2].name);
/*** END QUOTE UPDATE END ***/

/***** CREATE PURCHASE ORDER *****/
    List<Purchase_Order__c> lstPO = new List<Purchase_Order__c>();
    for(integer i=0; i<lstQ.size(); i++)
    {
        lstPO.add(new Purchase_Order__c(name= lstQ[i].Consolidated_Lease_Number__c,
                                          Quote__c = lstQ[i].Id,
                                          Delivery_Charges__c = 1000.00,
                                          Dealer_Fees__c = lstQ[i].Dealer_Fees__c, 
                                          Projected_Install__c = null, 
                                          Opportunity__c = lstQ[i].OpportunityId,
                                          Dealer_Account__c = lstQ[i].Opportunity.Account.Partner_Account__c,
                                          End_Customer_Account__c = lstQ[i].Opportunity.AccountId,
                                          Lease_Number__c= lstQ[i].Consolidated_Lease_Number__c,
                                          Lease__c= true,//(lstQ[i].Quote_Steps__c != null && lstQ[i].Quote_Steps__c == 'Lease') ? true : false,//qot.Opportunity.Account.Lease__c,
                                          Oracle_Order_Type__c= 'SPEB RVAR Lease 2' + String.valueOf(i),
                                          DSR_Po_Group_Email__c= '',
                                          Assigned_DSR__c = lstQ[i].Opportunity.Account.Partner_Account__r.Primary_PSR__c,
                                          Assigned_RSM__c = lstQ[i].Opportunity.Account.Partner_Account__r.RSM__c,
                                          Attention__c = lstCon[i].id,
                                          Order_Status__c= 'New',
                                          Financier__c= null,
                                          Requested_Delivery_Date__c= Date.Today().addDays(7),
                                          Oracle_Vendor_Number__c= lstQ[i].Opportunity.Account.Partner_Account__r.Oracle_Vendor_Number__c,
                                          Oracle_Vendor_Site_Code__c= lstQ[i].Opportunity.Account.Partner_Account__r.Oracle_Vendor_Site_Code__c,
                                          Ship_to_Site__c = null,//mapAccvsSTSite.containsKey(lstQ[i].Opportunity.AccountId) ? mapAccvsSTSite.get(lstQ[i].Opportunity.AccountId)[0] : null,
                                          Contact_Id__c = 'Contact ID' + String.valueOf(i),//((!mapAccvsContacts.isEmpty() && mapAccvsContacts.containsKey(lstQ[i].Opportunity.AccountId) && mapAccvsContacts.get(lstQ[i].Opportunity.AccountId) != null) ? mapAccvsContacts.get(lstQ[i].Opportunity.AccountId)[0].Id : null),
                                          Ship_To_Contact__c = lstCon[i].id//((!mapAccvsContacts.isEmpty() && mapAccvsContacts.containsKey(lstQ[i].Opportunity.AccountId) && mapAccvsContacts.get(lstQ[i].Opportunity.AccountId) != null) ? mapAccvsContacts.get(lstQ[i].Opportunity.AccountId)[0].Id : null)
                                          ));
    }
    insert lstPO;
/*** End Purchase Order ***/

/*** Start Purchase Order Line ***/
    List<Purchase_Order_Line__c> lstPOL = new List<Purchase_Order_Line__c>();
    for(integer i=0; i<lstQ.size(); i++)
    {
        for(integer j=0; j<5; j++)
        {
          lstPOL.add(new Purchase_Order_Line__c(Unit_Price__c= j,
                                                    Order_Line_Number__c= 12345 + String.valueOf(i),
                                                    Quantity__c = 1+j,
                                                    Purchase_Order__c = lstPO[i].Id, 
                                                    Price__c = 11+j,
                                                    Item_Number__c = lstI[i].Name, 
                                                    Item_ID__c = lstI[i].Item_ID__c, 
                                                    Item_Description__c = lstI[i].Description__c,
                                                    Oracle_Item_ID__c = lstI[i].Id,
                                                    Parent_Item__c = lstI[i].Id,
                                                    Safe_Harbor_Item__c = lstI2SH[i].Id,
                                                    Oracle_Warehouse__c = 'Oracle Warehouse ' + String.valueOf(i+j)));
            
        }
    }
    insert lstPOL;
/*** End Purchase Order Line ***/  

    for(integer i=0; i<lstPO.size(); i++)
    {
      Purchase_Order__c POrder = lstPO[i];

      PageReference pageRef = Page.LeaseOrderWizardInternal;
      Test.setCurrentPage(pageRef);
      ApexPages.StandardController std = new ApexPages.StandardController(POrder);
      LeaseOrderWizardControllerInternal cont = new LeaseOrderWizardControllerInternal(std);
      if(i==0)
      {
        Purchase_Order__c po = cont.propPurchaseOrder; 
        cont.propPurchaseOrder.Projected_Install__c = Date.Today().addDays(7);
        cont.propPurchaseOrder.Financier__c = 'Rabobank';
      
        DateTime userCT = cont.userCurrentTime;
        Integer userCTH = cont.userCurrentTimeHour;
        String dayOfW = cont.dayOfWeek;
        Integer TabToDisplay = cont.propTabToDisplay;
      
        String ShipingAddress = cont.propShipingAddress;
        String BillingAddress = cont.propBillingAddress;
        Boolean OrderConfirmation = cont.showOrderConfirmation;
        List<Purchase_Order_Line__c> OrderedPOLList = cont.propOrderedPOLList;
        User CurrentUser = cont.propCurrentUser;
 
        cont.propGotoTab = 1;
        Integer goNxt1 = cont.propGotoTab;
        cont.SwitchTab();

        cont.propGotoTab = 2;
        cont.Foxing();
        Integer goNxt2 = cont.propGotoTab;
        cont.calcDayDifference();
        cont.SwitchTab();

        cont.propGotoTab = 3;
        Integer goNxt3 = cont.propGotoTab;
        cont.SwitchTab();

        cont.propGotoTab = 4;
        Integer goNxt4 = cont.propGotoTab;
        cont.SwitchTab(); 
      
        PageReference pS = cont.SavePOFinancier();
      }
      else if(i==1)
      {
        Purchase_Order__c po = cont.propPurchaseOrder; 
        cont.propPurchaseOrder.Projected_Install__c = null;
        cont.propPurchaseOrder.Financier__c = 'Rabobank';
      
        DateTime userCT = cont.userCurrentTime;
        Integer userCTH = cont.userCurrentTimeHour;
        String dayOfW = cont.dayOfWeek;
        Integer TabToDisplay = cont.propTabToDisplay;
      
        String ShipingAddress = cont.propShipingAddress;
        String BillingAddress = cont.propBillingAddress;
        Boolean OrderConfirmation = cont.showOrderConfirmation;
        List<Purchase_Order_Line__c> OrderedPOLList = cont.propOrderedPOLList;
        User CurrentUser = cont.propCurrentUser;
 
        cont.propGotoTab = 1;
        Integer goNxt1 = cont.propGotoTab;
        cont.SwitchTab();

        cont.propGotoTab = 2;
        cont.Foxing();
        Integer goNxt2 = cont.propGotoTab;
        cont.calcDayDifference();
        cont.SavePOFinancierDummy();
        cont.SwitchTab();       
      }
      else if(i==2)
      {
        Purchase_Order__c po = cont.propPurchaseOrder; 
        cont.propPurchaseOrder.Projected_Install__c = Date.Today().addDays(7);
        cont.propPurchaseOrder.Financier__c = '';
      
        DateTime userCT = cont.userCurrentTime;
        Integer userCTH = cont.userCurrentTimeHour;
        String dayOfW = cont.dayOfWeek;
        Integer TabToDisplay = cont.propTabToDisplay;
      
        String ShipingAddress = cont.propShipingAddress;
        String BillingAddress = cont.propBillingAddress;
        Boolean OrderConfirmation = cont.showOrderConfirmation;
        List<Purchase_Order_Line__c> OrderedPOLList = cont.propOrderedPOLList;
        User CurrentUser = cont.propCurrentUser;
 
        cont.propGotoTab = 1;
        Integer goNxt1 = cont.propGotoTab;
        cont.SwitchTab();

        cont.propGotoTab = 2;
        cont.Foxing();
        Integer goNxt2 = cont.propGotoTab;
        cont.calcDayDifference();
        cont.SavePOFinancierDummy();
        cont.SwitchTab();       
      }
      else if(i==3)
      {
        Purchase_Order__c po = cont.propPurchaseOrder; 
        cont.propPurchaseOrder.Projected_Install__c = Date.Today().addDays(7);
        cont.propPurchaseOrder.Financier__c = 'Rabobank';
      
        DateTime userCT = cont.userCurrentTime;
        Integer userCTH = cont.userCurrentTimeHour;
        String dayOfW = cont.dayOfWeek;
        Integer TabToDisplay = cont.propTabToDisplay;
      
        String ShipingAddress = cont.propShipingAddress;
        String BillingAddress = cont.propBillingAddress;
        Boolean OrderConfirmation = cont.showOrderConfirmation;
        List<Purchase_Order_Line__c> OrderedPOLList = cont.propOrderedPOLList;
        User CurrentUser = cont.propCurrentUser;
 
        cont.propGotoTab = 1;
        Integer goNxt1 = cont.propGotoTab;
        cont.SwitchTab();

        cont.propGotoTab = 2;
        cont.Foxing();
        Integer goNxt2 = cont.propGotoTab;
        cont.calcDayDifference();
        cont.propPurchaseOrder.Requested_Delivery_Date__c = date.Today().addDays(1);
        cont.SwitchTab();

        cont.propGotoTab = 3;
        Integer goNxt3 = cont.propGotoTab;
        cont.SwitchTab();

        cont.propGotoTab = 4;
        Integer goNxt4 = cont.propGotoTab;
        cont.SwitchTab(); 
        
        cont.SavePOFinancierDummy();
        PageReference pS = cont.SavePOFinancier();
      }   
    }
    Test.StopTest();   
  }//End TM TM1
}//End Class CreatePOandPOLTrigOrgData_Test