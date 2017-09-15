@isTest(SeeAllData=True)
// Test class for "afterQuoteUpdate" trigger and "TPO_CopyRentaltoLeaseSchedule" class
Public class TestafterQuoteUpdate{
private static String session = '1234133123123x';
static testMethod void TPO_CopyRentaltoLeaseSchedule(){
        Account newAccount;
        Contact newContact;
        Opportunity newOpportunity;
        Quote newQuote;

        newAccount = [Select ID from Account Where Name='Test Class DO NOT TOUCH'];
              
        //create Item
        Item__c newItem = new Item__c(Item_ID__c = '1234124123123x',Product_Type__c= 'testtype');
        insert newItem;
        
        //Create PriceList
        Price_List__c priceItem = new Price_List__c();
        priceItem.Name='TPO FR Pricelist';
        priceItem.DSR_PO_Group_Email__c='commande@sunpowercorp.com';
        priceItem.CurrencyIsoCode='EUR';
        insert priceItem;
        
        //Create PriceList Item 
        Price_List_Item__c newPriceListItem = new Price_List_Item__c();
        newPriceListItem.Item_ID__c= newItem.id;
        newPriceListItem.Category__c='Module';
        //newPriceListItem.Is_Active__c= 'true';
        newPriceListItem.Price_List__c=priceItem.id;
        newPriceListItem.Name='230W (Model SPR-230E-WHT-D)';
        insert newPriceListItem;
        
        //Create Contact
        newContact = TestUtils.createContact('QuickQuote TEST CONTACT 1', newAccount.Id, true );
        
        //Create Opportunity
        newOpportunity = TestUtils.createOpportunities(1, newAccount.id, newContact.Id, true).get(0);
        
        //Create Quote
        newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test ', newOpportunity.Id, false).get(0);
        newQuote.QuoteType__c = 'Lease';
        newQuote.installDate__c = 'December 2013';
        newQuote.Description__c = 'dec Test';
        newQuote.Grid_Connection_Type__c = '3 Phase';
        newQuote.Multiple_Roofs__c=true;
        newQuote.Irregular_Roof__c=true;
        newQuote.System_Cost__c =30000;
        newQuote.System_Model__c = '230W (Model SPR-230E-WHT-D)';
        newQuote.Modules_Per_String_Roof1__c = 35;
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
        newQuote.Lease_Annual_Escalation__c = 14.5;
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
        newQuote.Module_Oracle_Item_Number__c = null;
        newQuote.Account__c=newAccount.id; 
        newQuote.Is_Locked__c = true;
        
       
        Test.startTest();
            insert newQuote;    
        Test.StopTest();
        
        newQuote.Customer_Downpayment_Type__c ='0 Deposit Offer';
        update newQuote;
       
        List<Roof_Details__c> rfList = new List<Roof_Details__c>();
        
        //Create Roof Details Records
         for(integer i = 0; i < 4; i ++){
            Roof_Details__c rf = new Roof_Details__c();
            rf.Shading_Measurement_Date__c = date.today();
            rf.Quote_Id__c =newQuote.Id;
            rf.Roof_Type__c ='Ardoise' ;
            rf.Jan__c = 99;
            rf.Feb__c = 99;
            rf.Mar__c = 99;
            rf.Apr__c = 99;
            rf.May__c = 99;
            rf.Jun__c = 99;
            rf.Jul__c = 99;
            rf.Aug__c = 99;
            rf.Sep__c = 99;
            rf.Oct__c = 99;
            rf.Nov__c = 99;
            rf.Dec__c = 99;
            rf.Direction__c = 180;
            rf.Roof_Height_M_FR__c = 8;
            rf.Account__c = newAccount.id;
            if(i == 0)
                rf.Name = 'Roof 1';
                rf.Direction__c = 180;
                if(i == 1)
                rf.Name = 'Roof 2';
                rf.Direction__c = 180;
                if(i == 2)
                rf.Name = 'Roof 3';
                rf.Direction__c = 180;
                if(i == 3)
                rf.Name = 'Roof 4';
                rf.Direction__c = 180;
            rfList.add(rf);
        }
        
        upsert rfList;    
                
        id quoteID = newQuote.Id;
        //List<Lease_Schedule__c> leaseList = TestUtils.createLeaseSchedules(quoteID, true);    
        
        //Create System Production
        System_Production__c sysPro = new System_Production__c();
        sysPro.Quote__c = newQuote.id;
        insert sysPro;
        
        
        
        
        User usr;
        usr = TestUtils.createUser('system administrator', false);
        insert usr;
        Profile p = [SELECT Id FROM Profile WHERE Name='system administrator']; 
        User u = [select id from User where ProfileId =: p.Id and IsActive=true limit 1];
        
        System.runAs(u) {
        }
      
      
        Rental_Schedule__c newRenSch = new Rental_Schedule__c ();
        newRenSch.Quote__c = newQuote.id;
        newRenSch.Year__c = 1.0;
        newRenSch.TVs_1__c = 0.0;
        newRenSch.TVs_2__c = 0.0;
        newRenSch.Payments_to_the_customer_1__c = 0.0;
        newRenSch.Payments_to_the_customer_2__c = 0.0;
        newRenSch.Customer_Downpayment_Type__c ='DownPayment1';
        
        insert newRenSch ;
 }
 static testMethod void TPO_CopyRentaltoLeaseSchedule1(){
        Account newAccount;
        Contact newContact;
        Opportunity newOpportunity;
        Quote newQuote;
        newAccount = [Select ID from Account Where Name='Test Class DO NOT TOUCH'];
              
        //create Item
        Item__c newItem = new Item__c(Item_ID__c = '1234124123123x',Product_Type__c= 'testtype');
        insert newItem;
        
        //Create PriceList
        Price_List__c priceItem = new Price_List__c();
        priceItem.Name='TPO FR Pricelist';
        priceItem.DSR_PO_Group_Email__c='commande@sunpowercorp.com';
        priceItem.CurrencyIsoCode='EUR';
        insert priceItem;
        
        //Create PriceList Item 
        Price_List_Item__c newPriceListItem = new Price_List_Item__c();
        newPriceListItem.Item_ID__c= newItem.id;
        newPriceListItem.Category__c='Module';
        //newPriceListItem.Is_Active__c= 'true';
        newPriceListItem.Price_List__c=priceItem.id;
        newPriceListItem.Name='230W (Model SPR-230E-WHT-D)';
        insert newPriceListItem;
        
        //Create Contact
        newContact = TestUtils.createContact('QuickQuote TEST CONTACT 1', newAccount.Id, true );
        
        //Create Opportunity
        newOpportunity = TestUtils.createOpportunities(1, newAccount.id, newContact.Id, true).get(0);
        
        //Create Quote
        newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test ', newOpportunity.Id, false).get(0);
        newQuote.QuoteType__c = 'Lease';
        newQuote.installDate__c = 'December 2013';
        newQuote.Description__c = 'dec Test';
        newQuote.Grid_Connection_Type__c = '3 Phase';
        newQuote.Multiple_Roofs__c=true;
        newQuote.Irregular_Roof__c=true;
        newQuote.System_Cost__c =30000;
        newQuote.System_Model__c = '230W (Model SPR-230E-WHT-D)';
        newQuote.Modules_Per_String_Roof1__c = 35;
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
        newQuote.Lease_Annual_Escalation__c = 14.5;
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
        newQuote.Module_Oracle_Item_Number__c = null;
        newQuote.Account__c=newAccount.id;
        newQuote.Is_Locked__c = true;
        
       
        Test.startTest();
            insert newQuote;    
        Test.StopTest();
        
        newQuote.Customer_Downpayment_Type__c ='With Deposit Offer';
        update newQuote;
        
       List<Roof_Details__c> rfList = new List<Roof_Details__c>();
        
        //Create Roof Details Records
         for(integer i = 0; i < 4; i ++){
            Roof_Details__c rf = new Roof_Details__c();
            rf.Shading_Measurement_Date__c = date.today();
            rf.Quote_Id__c =newQuote.Id;
            rf.Roof_Type__c ='Ardoise' ;
            rf.Jan__c = 99;
            rf.Feb__c = 99;
            rf.Mar__c = 99;
            rf.Apr__c = 99;
            rf.May__c = 99;
            rf.Jun__c = 99;
            rf.Jul__c = 99;
            rf.Aug__c = 99;
            rf.Sep__c = 99;
            rf.Oct__c = 99;
            rf.Nov__c = 99;
            rf.Dec__c = 99;
            rf.Direction__c = 180;
            rf.Roof_Height_M_FR__c = 8;
            rf.Account__c = newAccount.id;
            if(i == 0)
                rf.Name = 'Roof 1';
                rf.Direction__c = 180;
                if(i == 1)
                rf.Name = 'Roof 2';
                rf.Direction__c = 180;
                if(i == 2)
                rf.Name = 'Roof 3';
                rf.Direction__c = 180;
                if(i == 3)
                rf.Name = 'Roof 4';
                rf.Direction__c = 180;
            rfList.add(rf);
        }
        
        upsert rfList;    
                
        id quoteID = newQuote.Id;
        //List<Lease_Schedule__c> leaseList = TestUtils.createLeaseSchedules(quoteID, true);    
        
        //Create System Production
        System_Production__c sysPro = new System_Production__c();
        sysPro.Quote__c = newQuote.id;
        insert sysPro;
        
        User usr;
        usr = TestUtils.createUser('system administrator', false);
        insert usr;
        Profile p = [SELECT Id FROM Profile WHERE Name='system administrator']; 
        User u = [select id from User where ProfileId =: p.Id and IsActive=true limit 1];
        
        System.runAs(u) {}
        Rental_Schedule__c newRenSch = new Rental_Schedule__c ();
        newRenSch.Quote__c = newQuote.id;
        newRenSch.Year__c = 1.0;
        newRenSch.TVs_1__c = 0.0;
        newRenSch.TVs_2__c = 0.0;
        newRenSch.Payments_to_the_customer_1__c = 0.0;
        newRenSch.Payments_to_the_customer_2__c = 0.0;
        newRenSch.Customer_Downpayment_Type__c ='DownPayment2';
        
        insert newRenSch ;
 }          
}