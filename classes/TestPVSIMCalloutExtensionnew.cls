//@isTest(seeAllData = true)
public  class TestPVSIMCalloutExtensionnew {
    /*

  public static Account newAccount;
  public static Contact newContact;
  public Static Opportunity newOpportunity;
  public Static QuotelineExtension quoteLine;
  public Static Quote newQuote;
  public static User newUser;
  public static id aid{get;set;}
  public static id qid{get;set;}
   
    
    static testMethod void TestPvsImCalloutExtenion1(){
   
        newAccount = [Select ID,sales_Tax_Rate__c,Income__c,Default_Image__c, Distance_From_Ocean__c,
                                   (SELECT Id,Name,
                                    Current_rate_code__c,
                                    Current_Rate__c,
                                    Annual_Usage__c,
                                    Annual_Bill__c,
                                    Monthly_Jan__c,
                                    Monthly_Apr__c,
                                    Monthly_Aug__c,
                                    Monthly_Dec__c,
                                    Monthly_Feb__c,
                                    Monthly_Jul__c,
                                    Monthly_Jun__c,
                                    Monthly_Mar__c,
                                    Monthly_May__c,
                                    Monthly_Nov__c,
                                    Monthly_Oct__c,
                                    Monthly_Sep__c,
                                    usage__c,
                                    Account__c,
                                    Daily_Hr1__c,
                                    Daily_Hr2__c,
                                    Daily_Hr3__c,
                                    Daily_Hr4__c,
                                    Daily_Hr5__c,
                                    Daily_Hr6__c,
                                    Daily_Hr7__c,
                                    Daily_Hr8__c,
                                    Daily_Hr9__c,
                                    Daily_Hr10__c,
                                    Daily_Hr11__c,
                                    Daily_Hr12__c,
                                    month__c,
                                    AMPM__c                                  
                             FROM 
                                    Electric_Rate_Usage_Inputs1__r)  from Account Where Name='Test Class FR DO NOT TOUCH'];
              
        //create Item
        Item__c newItem = new Item__c(Item_ID__c = '1234124123123x',Product_Type__c= 'testtype');
        insert newItem;
        
        //Create PriceList
        Price_List__c priceItem = new Price_List__c();
        priceItem.Name='TPO FR Pricelist';
        priceItem.DSR_PO_Group_Email__c='commande@sunpowercorp.com';
        priceItem.CurrencyIsoCode='EUR';
        insert priceItem;
        
        Price_List_Item__c newPriceListItem = new Price_List_Item__c();
        newPriceListItem.Item_ID__c= newItem.id;
        newPriceListItem.Category__c='Module';
        newPriceListItem.PV_SIM_No__c =123;
        //newPriceListItem.Is_Active__c= 'true';
        newPriceListItem.Price_List__c=priceItem.id;
        newPriceListItem.Name='6.0 kW (Model PVI-6000-OUTD-US (240 V))';
        insert newPriceListItem;
        
        newContact = [select id,name from contact where name = 'Test Class FR DO NOT TOUCH'];
        newOpportunity = [select id,name from Opportunity where name = 'Test Class FR DO NOT TOUCH'];
        newQuote = [SELECT ID,Name,Module__c from Quote where name = 'Test Class FR DO NOT TOUCH' ];
       
        Test.setCurrentPageReference(new PageReference('Page.TPO_RoofDetailsTab')); 
        
        system.debug('$$$$$$$$$$$$newAccount.ID='+newAccount.ID);
        system.debug('$$$$$$$$$$$$newQuote.ID='+newQuote.ID);
        
        System.currentPageReference().getParameters().put('aId', newAccount.ID);
        System.currentPageReference().getParameters().put('qId', newQuote.ID);
        System.currentPageReference().getParameters().put('imageId', '1');     
        
            
     // TPO_RoofDetailsQuotenew TRDQ = new TPO_RoofDetailsQuotenew();
    //  PVSIMCalloutExtensionnew pvsim = new PVSIMCalloutExtensionnew(TRDQ);
        
         
        Test.startTest();
        // For sending Mock Response
         Test.setMock(WebServiceMock.class, new MockWebserviceResponseGenerator());
     
         PVSIMCalloutExtensionnew pvsim1 = new PVSIMCalloutExtensionnew();
         pvsim1.init(); 
     
     Test.stopTest();
    
    
    }
    
    static testMethod void TestPvsImCalloutExtenion2(){
   
        newAccount = [Select ID,sales_Tax_Rate__c,Income__c,Default_Image__c, Distance_From_Ocean__c,
                                   (SELECT Id,Name,
                                    Current_rate_code__c,
                                    Current_Rate__c,
                                    Annual_Usage__c,
                                    Annual_Bill__c,
                                    Monthly_Jan__c,
                                    Monthly_Apr__c,
                                    Monthly_Aug__c,
                                    Monthly_Dec__c,
                                    Monthly_Feb__c,
                                    Monthly_Jul__c,
                                    Monthly_Jun__c,
                                    Monthly_Mar__c,
                                    Monthly_May__c,
                                    Monthly_Nov__c,
                                    Monthly_Oct__c,
                                    Monthly_Sep__c,
                                    usage__c,
                                    Account__c,
                                    Daily_Hr1__c,
                                    Daily_Hr2__c,
                                    Daily_Hr3__c,
                                    Daily_Hr4__c,
                                    Daily_Hr5__c,
                                    Daily_Hr6__c,
                                    Daily_Hr7__c,
                                    Daily_Hr8__c,
                                    Daily_Hr9__c,
                                    Daily_Hr10__c,
                                    Daily_Hr11__c,
                                    Daily_Hr12__c,
                                    month__c,
                                    AMPM__c                                  
                             FROM 
                                    Electric_Rate_Usage_Inputs1__r)  from Account Where Name='Test Class DO NOT TOUCH'];
              
        //create Item
        Item__c newItem = new Item__c(Item_ID__c = '1234124123123x',Product_Type__c= 'testtype');
        insert newItem;
        
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
        newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test ', newOpportunity.Id, false).get(0);
        newQuote.QuoteType__c = 'Lease';
        newQuote.installDate__c = 'December 2013';
        newQuote.Description__c = 'dec Test';
        newQuote.Grid_Connection_Type__c = '3 Phase';
        newQuote.Multiple_Roofs__c=true;
        newQuote.Irregular_Roof__c=true;
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
       
       
       insert newQuote;    
       
       
       List<Roof_Details__c> rfList = new List<Roof_Details__c>();
         for(integer i = 0; i < 4; i ++){
            Roof_Details__c rf = new Roof_Details__c();
            rf.Shading_Measurement_Date__c = date.today();
            rf.Quote_Id__c =newQuote.ID;
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
        List<Lease_Schedule__c> leaseList = TestUtils.createLeaseSchedules(newQuote.ID, true);    
        
        System_Production__c sysPro = new System_Production__c();
        sysPro.Quote__c = newQuote.ID;
        sysPro.PV_AnnualNetEnergy_Year1__c = 8454.55;
        sysPro.PV_AnnualNetEnergy_Year2__c = 8454.55;
        sysPro.PV_AnnualNetEnergy_Year3__c = 8454.55;
        sysPro.PV_AnnualNetEnergy_Year4__c = 8454.55;
        sysPro.PV_AnnualNetEnergy_Year5__c = 8454.55;
        sysPro.PV_AnnualNetEnergy_Year6__c = 8454.55;
        sysPro.PV_AnnualNetEnergy_Year7__c = 8454.55;
        sysPro.PV_AnnualNetEnergy_Year8__c = 8454.55;
        sysPro.PV_AnnualNetEnergy_Year9__c = 8454.55;
        sysPro.PV_AnnualNetEnergy_Year10__c = 8454.55;
        sysPro.PV_AnnualNetEnergy_Year11__c = 8454.55;
        sysPro.PV_AnnualNetEnergy_Year12__c = 8454.55;
        sysPro.PV_AnnualNetEnergy_Year13__c = 8454.55;
        sysPro.PV_AnnualNetEnergy_Year14__c = 8454.55;
        sysPro.PV_AnnualNetEnergy_Year15__c = 8454.55;
        sysPro.PV_AnnualNetEnergy_Year16__c = 8454.55;
        sysPro.PV_AnnualNetEnergy_Year17__c = 8454.55;
        sysPro.PV_AnnualNetEnergy_Year18__c = 8454.55;
        sysPro.PV_AnnualNetEnergy_Year19__c = 8454.55;
        sysPro.PV_AnnualNetEnergy_Year20__c = 8454.55;
        insert sysPro;
        
        Test.setCurrentPageReference(new PageReference('Page.TPO_RoofDetailsTab')); 
        
        system.debug('$$$$$$$$$$$$newAccount.ID='+newAccount.ID);
        System.currentPageReference().getParameters().put('aId', newAccount.ID);
        System.currentPageReference().getParameters().put('qId', newQuote.ID);
        System.currentPageReference().getParameters().put('imageId', '1');     
        aid = newAccount.ID;
        qid = newQuote.ID; 
            
       TPO_RoofDetailsQuotenew TRDQ = new TPO_RoofDetailsQuotenew();
       PVSIMCalloutExtensionnew pvsim = new PVSIMCalloutExtensionnew(TRDQ);
    
    }*/
    
}