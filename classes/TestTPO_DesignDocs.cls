/*** Test Class added in Sunpower TPO Phase 1 -- 20/10/2013, to cover TPO_DesignDocs Class ***/
//@isTest(seeAllData=true)
public class TestTPO_DesignDocs{/*

static testMethod void TPO_RoofDetailsQuotenew3(){
        SFDCSpecialUtilities.isRunningTest = True; 
        
        Account newAccount;
        Contact newContact;
        Opportunity newOpportunity;
        Quote newQuote;
        
        //Profile p = [SELECT Id FROM Profile WHERE Name='system administrator']; 
        //User u = [select id from User where ProfileId =: p.Id and IsActive=true and Country_Domain__c='rvar-fr' limit 1];
       
        // [START] RA 20.MAY.2015 - created test user to avoid errors in query encountered on every deployment //
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

        // [END] RA 20.MAY.2015 //

        newAccount = [Select ID from Account Where Name='Test Class DO NOT TOUCH'];
              
         //create Item
        Item__c newItem = new Item__c();
        newItem = [select id,Item_ID__c from Item__c where Item_ID__c=:'125565'];
        
        //Create PriceList
        Price_List__c priceItem = new Price_List__c();
        priceItem.Name='TPO FR Pricelist';
        priceItem.DSR_PO_Group_Email__c='commande@sunpowercorp.com';
        priceItem.CurrencyIsoCode='EUR';
        insert priceItem;
        
        Price_List_Item__c newPriceListItem = new Price_List_Item__c();
        newPriceListItem.Item_ID__c= newItem.id;
        newPriceListItem.Category__c='Module';
        //newPriceListItem.Is_Active__c= 'true';
        newPriceListItem.Price_List__c=priceItem.id;
        newPriceListItem.Name='230W (Model SPR-230E-WHT-D)';
        insert newPriceListItem;
        
        newContact = TestUtils.createContact('QuickQuote TEST CONTACT 1', newAccount.Id, true );
        newOpportunity = TestUtils.createOpportunities(1, newAccount.id, newContact.Id, true).get(0);
        //newOpportunity.Lead_Manufacturer__c = ;
        newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test ', newOpportunity.Id, false).get(0);
        newQuote.QuoteType__c = 'Lease';
        newQuote.installDate__c = 'December 2013';
        newQuote.Description__c = 'dec Test';
        newQuote.Grid_Connection_Type__c = '3 Phase';
        newQuote.Multiple_Roofs__c=true;
        newQuote.Irregular_Roof__c=true;
        newQuote.System_Cost__c =30000;
        newQuote.System_Model__c = '230W (Model SPR-230E-WHT-D)';
        newQuote.Modules_Per_String_Roof1__c = 12;
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
        newQuote.Inverter_Model__c = '5.0 kW (Model PVI-5000-OUTD-US (240 V))';
        newQuote.Inverter_Model_2__c = '3.3 kW (Model SPR-3300f-240)';
        newQuote.Inverter_Model_3__c = '6.0 kW (Model SPR-6000m (240V))';
        newQuote.Inverter_Model_4__c = '5.0 kW (Model PVI-5000-OUTD-US (240 V))';
        newQuote.Inverter_Quantity__c = 1;
        newQuote.Inverter_Quantity_2__c = 1;
        newQuote.Inverter_Quantity_3__c = 1;
        newQuote.Inverter_Quantity_4__c = 1;
        newQuote.Inverter_Model_Roof1__c = 'SPR-3000P-TL1-EU';
        newQuote.Inverter_Model_Roof2__c = 'SPR-3600P-TL1-EU';
        newQuote.Inverter_Model_Roof3__c = 'SPR-5000P-TL1-EU';
        newQuote.Inverter_Model_Roof4__c = 'SPR-3000P-TL1-EU';
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
        newQuote.Module_Oracle_Item_Number__c = newItem.id;
        newQuote.DC_Cabinet__c = 3.0;
        newQuote.Dealer_Fees__c = 6295.3;
        newQuote.Origination__c = 1881.3;
        newQuote.Interconnect__c = 1259.0;
        newQuote.Wiring_Distance__c = 'greater than 2.5 meters';
        //newQuote.DownPayment_Type__c = '0 Down Payment';
        //newQuote.OracleItemNumber__c = 125565.0;
       
        Test.startTest();
        insert newQuote;    
        Test.StopTest();
       
       
               
        id quoteID = newQuote.Id;

        
        TPO_MPPT__c  newMppt = new TPO_MPPT__c ();
        newMppt.Module_Name__c = '245W (Model SPR-245NE-WHT-D)';
        newMppt.MPPT_1_String_Qty__c = 1.0;
        newMppt.Module_Quantity__c = 1.0;
        newMppt.Item_ID__c = 125565.0 ;
        newMppt.Inverter_Name_1__c = 'SPR-3600P-TL1-EU';
        newMppt.Inverter_Quantity__c = 1.0;
        newMppt.Surface__c = 18.81;
        newMppt.Wats_Power__c = 4000.0;
        insert newMppt;
        
        string body1='PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz48YWJjIHhtbG5zPSJodHRwOi8vd3d3LndhcnJlbi1zZWxiZXJ0LmNvbSIgeG1sbnM6eHNpPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxL1hNTFNjaGVtYS1pbnN0YW5jZSI';
        Attachment attmt = new Attachment();
        attmt.Name ='Rapport du projet';
        attmt.ParentId = newQuote.Id;
        attmt.body =Blob.valueOf(body1);
        insert attmt;
        
        system.runAs(Usr){
        ApexPages.currentPage().getParameters().put('Id',quoteID);
        ApexPages.StandardController stdCont = new ApexPages.StandardController(newQuote);
        TPO_DesignDocs TPO_rdqn  = new TPO_DesignDocs(stdCont);
            PageReference pg = Page.TPO_designdocs;            
            Test.setCurrentPage(pg);
            //Test.setCurrentPageReference(new PageReference('Page.TPO_DesignDocs')); 
           
            //system.debug('$$$$$$$$$$$$newAccount.ID='+newAccount.ID);
            //System.currentPageReference().getParameters().put('Id', quoteID);
            //System.currentPageReference().getParameters().put('imageId', '1');  
            
            //TPO_DesignDocs TPO_rdqn = new TPO_DesignDocs();
            
            TPO_rdqn.SolrifDesigndocs();


    


        }
    }
*/
}