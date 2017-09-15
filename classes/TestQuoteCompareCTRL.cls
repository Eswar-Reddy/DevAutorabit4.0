@isTest(seealldata=true)
public class TestQuoteCompareCTRL
{
    static Account newAccount;
    static Contact newContact;
    static Opportunity newOpportunity;
  //  static Quote newQuote;

    Static testMethod void QuoteCompareCTRLTest()
    {
    
         Price_List__c pl = new Price_List__c(Name = 'Inverter Model Price List', Packaged_System_Item_ID__c = '102868', DSR_PO_Group_Email__c = 'test@test.com');
        insert pl;
        
        Price_List_Item__c pli = new Price_List_Item__c(Price_list__c = pl.id, Name = '230W (Model SPR-230E-WHT-D)', Category__c = 'Module');
        insert pli;
        
        newAccount = TestUtils.createAccount('QuickQuote ACCOUNT 1', TestUtils.getResidentialRecordTypeId() , true );
        newContact = TestUtils.createContact('QuickQuote TEST CONTACT 1', newAccount.Id, true );
        newOpportunity = TestUtils.createOpportunities(1, newAccount.id, newContact.Id, true).get(0);
       // newQuote = TestUtils.createQuotes(1,'QuickQuoteTest',newOpportunity.id,true).get(0);
        
        //Quote Dummay Data
        Quote newQuote = new Quote();
        newQuote.Name = 'Test';
        newQuote.QuoteType__c = 'Lease';
        newQuote.installDate__c = 'December 2013';
        newQuote.Description__c = 'dec Test';
        newQuote.System_Cost__c =30000;
        newQuote.System_Model__c = '230W (Model SPR-230E-WHT-D)';
        newQuote.Modules_Per_String_Roof1__c = 1;
        newQuote.Modules_Per_String_Roof2__c = 1;
        newQuote.Modules_Per_String_Roof3__c = 1;
        newQuote.Modules_Per_String_Roof4__c  = 1;
        newQuote.Total_Parallel_Strings_Roof1__c = 1;
        newQuote.Total_Parallel_Strings_Roof2__c = 1;
        newQuote.Total_Parallel_Strings_Roof3__c = 1;
        newQuote.Total_Parallel_Strings_Roof4__c = 1;
        newQuote.Inverter_Manufacturer_Roof1__c ='Powerone';
        newQuote.Inverter_Manufacturer_Roof2__c = 'Sunpower';
        newQuote.Inverter_Manufacturer_Roof3__c = 'Powerone';
        newQuote.Inverter_Manufacturer_Roof4__c = 'Sunpower';
        newQuote.General_Derate_Factor__c =5.6;
        newQuote.Inverter_Model__c = '';
        newQuote.Inverter_Model_2__c = '';
        newQuote.Inverter_Model_3__c = '';
        newQuote.Inverter_Model_4__c = '';
        newQuote.Inverter_Quantity__c = 1;
        newQuote.Inverter_Quantity_2__c = 1;
        newQuote.Inverter_Quantity_3__c = 1;
        newQuote.Inverter_Quantity_4__c = 1;
        newQuote.ProposedRate__c ='Residential Service';
        newQuote.Utility_Bill_Annual_Escalation__c = 5.6;
        newQuote.Down_Payment__c = 12546.5;
        newQuote.Full_Prepaid_Lease__c = false;
        newQuote.Partial_Prepayment__c = 0.0;
        newQuote.Optional_Incentives__c = 'Use None'; 
        newQuote.Lease_Annual_Escalation__c = 3.0;
        newQuote.Lease_Sales_Tax_Rate__c = 4.2;
        newQuote.REC_Escalation__c = 4.0;
        newQuote.REC_Life_Years__c = 1;
        newQuote.REC_Value_kWh__c = 1.0;
        newQuote.Buydown_Override__c = false;
        newQuote.PBI_Override__c = false;
        newQuote.PBI_Amount__c = 125.6;
        newQuote.PBI_Years__c = 2013;
        newQuote.Design_Factor__c = 'Automatic';
        newQuote.Buydown_Amount__c = 1254.2;
        newQuote.Opportunityid = newOpportunity.id;
        newQuote.Account__c = newAccount.Id;
        Insert newQuote;
        
        newAccount.sales_Tax_Rate__c = 15.0;
        newAccount.Income__c = 10000;
        update newAccount;
        
       // Id quoteID = '0Q0Q0000000FnXkKAK';
        Id quoteID = newQuote.Id;
       
        //System Production Dummy data
        System_Production__c newSystemProd = new System_Production__c();
        newSystemProd.System_Size_DC__c = 5.232;
        newSystemProd.Total_Energy__c = 8284.271;
        newSystemProd.System_Size_AC__c = 4.6;
        newSystemProd.Upfront_Incentives__c = 852.5718;
        newSystemProd.Monthly_Lease_Payment__c =5120.0;
        newSystemProd.Upfront_Lease_Payment__c = 20.0;
        //newSystemProd.cost_per_watt_DC__c = 2.85;
       // newSystemProd.cost_per_watt_AC__c  =    3.24;
        newSystemProd.Incentive_Design_Factor__c =   '92%';
       // newSystemProd.Monthly_Lease_Payment7_50discount__c  =0;
        newSystemProd.Monthly_Electric_Bill_Without_PV_year1__c =166.679166666666666666666666666667;
        newSystemProd.Monthly_Electric_Bill_With_PV_year1__c =   4.70916666666666666666666666666667;
       // newSystemProd.Monthly_Electric_Bill_saving_year1__c =   161.97;
      //  newSystemProd.Percentage_Electricity_Produced__c    =   87.8;
      //  newSystemProd.Cash_Price_Return_On_Investment_year1__c =    19.8;
        newSystemProd.Monthly_Electric_Bill_Without_PV_year5__c = 187.599166666666666666666666666667;
        newSystemProd.Monthly_Electric_Bill_With_PV_year5__c  =  7.11583333333333333333333333333333;
       // newSystemProd.Monthly_Electric_Bill_saving_year5__c = 180.48;
       // newSystemProd.Cash_Price_Return_On_Investment_year5__c =    22.0;
        newSystemProd.Quote__c  = quoteID ;
       // newSystemProd.Quote__r.Id = quoteID;
        Insert newSystemProd;
        
        List<Lease_Schedule__c> leaseList = TestUtils.createLeaseSchedules(quoteID, false);
      
        Lease_Schedule__c objLeaseSch = new Lease_Schedule__c();
        objLeaseSch.Years__c = '2013';
        objLeaseSch.System_Production_Annual_Production__c  = 8284.0;
       // objLeaseSch.X95_of_S_P_A_P__c   = 7870.0;
       // objLeaseSch.X105_of_S_P_A_P__c  = 8698.0;
        objLeaseSch.Cumulative_Production_kWh__c =  8284.0;
        objLeaseSch.Cost_of_Lease_Per_kWh__c = 0.0; 
        objLeaseSch.Quote__c =quoteID;
        Insert objLeaseSch;
        
        Cash_Flow_Details__c objCash = new Cash_Flow_Details__c();
        objCash.Lease_Termination_Value__c = 17087.59;
        objCash.PBI__c = 0.0;
        objCash.annualBillAfter__c = 56.51;
        objCash.annualBillBefore__c = 2000.15;
        objCash.Lease_Payment__c = 0.0; 
        objCash.Lease_Payment_Sales_Tax__c = 0.0;    
        objCash.Year__c = 2013.0; 
        objCash.Quote__c = quoteID;
        Insert  objCash;
        
        Electric_Bill_Summary__c objElecBill = new Electric_Bill_Summary__c();
       // objElecBill.Electric_Bill_Offset__c = 169.66;
        objElecBill.Quote__c = quoteID;
        Insert objElecBill;

        Monthly_Electric_Bill__c objMElecBill = new Monthly_Electric_Bill__c();
        objMElecBill.Month__c = 'Minimum Bill'; 
        objMElecBill.With_PV_System__c = 54.0;
        objMElecBill.Without_PV_System__c = 2000.0;
        objMElecBill.Quote__c =quoteID;
        objMElecBill.Electric_Bill_Summary__c = objElecBill.id;
        Insert objMElecBill; 
        
        ApexPages.currentPage().getParameters().put('ls1', newSystemProd.Id);
        ApexPages.currentPage().getParameters().put('ls2', newSystemProd.Id);
        ApexPages.currentPage().getParameters().put('ls3', newSystemProd.Id);
        
        QuoteCompareCTRL objQuoteCompare = new QuoteCompareCTRL();
    }
}