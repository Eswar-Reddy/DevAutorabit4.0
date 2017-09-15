@isTest(seealldata=false)
public class TestBatchUpdatePBISum
{
     Static testMethod void TestBatchUpdatePBISum()
    {
        Account newAccount = TestUtils.createAccount('QuickQuote ACCOUNT 1', TestUtils.getResidentialRecordTypeId() , true );
        Contact newContact = TestUtils.createContact('QuickQuote TEST CONTACT 1', newAccount.Id, true );
        Opportunity newOpportunity = TestUtils.createOpportunities(1, newAccount.id, newContact.Id, true).get(0);
		
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
        newQuote.Is_Locked__c = true;
        Insert newQuote;
        System.debug(LoggingLevel.ERROR,'------------Is_Locked__c.Is_Locked__c'+newQuote.Is_Locked__c);
        
        newAccount.sales_Tax_Rate__c = 15.0;
        newAccount.Income__c = 10000;
        update newAccount;
        
       // Id quoteID = '0Q0Q0000000FnXkKAK';
        Id quoteID = newQuote.Id;
        
        Cash_Flow_Details__c objCash = new Cash_Flow_Details__c();
        objCash.Lease_Termination_Value__c = 17087.59;
        objCash.PBI__c = 0.0;
        objCash.annualBillAfter__c = 56.51;
        objCash.annualBillBefore__c = 2000.15;
        objCash.Lease_Payment__c = 0.0; 
        objCash.Lease_Payment_Sales_Tax__c = 0.0;    
        objCash.Year__c = 2013.0; 
        objCash.Quote__c = newQuote.Id;
        objCash.Annual_Incentive_value__c = '200';
        Insert  objCash;
        System.debug(LoggingLevel.ERROR,'------------objCash'+objCash.Annual_Incentive_value__c);
        System.debug(LoggingLevel.ERROR,'------------Quote__r.Is_Locked__c'+objCash.Quote__r.Is_Locked__c);
        System.debug(LoggingLevel.ERROR,'------------Quote__r.PBI_Sum__c'+objCash.Quote__r.PBI_Sum__c);
        
        
        Batch_UpdatePBISum cls = new Batch_UpdatePBISum();
        Database.executeBatch(cls);
    }  
}