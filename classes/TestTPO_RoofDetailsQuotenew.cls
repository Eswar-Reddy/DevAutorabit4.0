/*** Test Class added in Sunpower TPO Phase 1 -- 20/10/2013, to cover TPO_RoofDetailsQuotenew Class ***/
//@isTest(seeAllData=true)
public class TestTPO_RoofDetailsQuotenew{/*
    private static String session = '1234133123123x';
    
   static testMethod void TPO_RoofDetailsQuotenew1(){
        Account newAccount;
        Contact newContact;
        Opportunity newOpportunity;
        Quote newQuote;

        
        User u = TestUtils.createUser('System Administrator', false); //MAM 22.MAY.2015 Use TestUtils.createUser for the user creation
        
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
        newQuote.Description__c = null;
        newQuote.Grid_Connection_Type__c = '3 Phase';
        newQuote.Multiple_Roofs__c=true;
        newQuote.Irregular_Roof__c=true;
        newQuote.System_Cost__c =30000;
        newQuote.System_Model__c = '230W (Model SPR-230E-WHT-D)';
        newQuote.Modules_Per_String_Roof1__c = 1;
        newQuote.Modules_Per_String_Roof1__c = null;
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
        newQuote.Is_Locked__c = false;
        newQuote.Design_Help_Status__c = 'Terminé';
        newQuote.Design_Help_Status__c = '';
        newQuote.Trenching__c ='Greater than 25 Meters';
        newQuote.Trenching__c='25 Meters or Less';
       
        Test.startTest();
        insert newQuote;    
        Test.StopTest();
       
       List<Roof_Details__c> rfList = new List<Roof_Details__c>();
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
        List<Lease_Schedule__c> leaseList = TestUtils.createLeaseSchedules(quoteID, true);    
        
        System_Production__c sysPro = new System_Production__c();
        sysPro.PV_AnnualNetEnergy_Year1__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year2__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year3__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year4__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year5__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year6__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year7__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year8__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year9__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year10__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year11__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year12__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year13__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year14__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year15__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year16__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year17__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year18__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year19__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year20__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year21__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year22__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year23__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year24__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year25__c = 9774.3820366188540;
        
        sysPro.Quote__c = newQuote.id;
        insert sysPro;
        
        system.runAs(u){
            Test.setCurrentPageReference(new PageReference('Page.TPO_RoofDetailsTab')); 
            system.debug('$$$$$$$$$$$$newAccount.ID='+newAccount.ID);
            System.currentPageReference().getParameters().put('aId', newAccount.ID);
            System.currentPageReference().getParameters().put('qId', quoteID);
            System.currentPageReference().getParameters().put('imageId', '1'); 
            
            TPO_RoofDetailsQuotenew TPO_rdqn1 = new TPO_RoofDetailsQuotenew();
                TPO_rdqn1.bRecordCreated = false;
                //TPO_rdqn1.getInitPage();
                TPO_rdqn1.getInverterModels();
                TPO_rdqn1.getInverterModel1();
                TPO_rdqn1.getInverterModel2();
                TPO_rdqn1.getInverterModel3();
                TPO_rdqn1.getInverterModel4();
                TPO_rdqn1.getQuotemodules();
                TPO_rdqn1.getlatestsystemprodrec();
                TPO_rdqn1.callABC();
                TPO_rdqn1.RedirectCreateProp();
                TPO_rdqn1.RedirectRoofDesign();
                TPO_rdqn1.addTab();
                TPO_rdqn1.tabCount=1;
                
               TPO_rdqn1.addTab();
           
               
                
                
       }
    }
    //****************************************************************************************
    static testMethod void TPO_RoofDetailsQuotenew2(){
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
        newQuote.Is_Locked__c = true;
        
       
        //Test.startTest();
            insert newQuote;    
        //Test.StopTest();
       
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
        List<Lease_Schedule__c> leaseList = TestUtils.createLeaseSchedules(quoteID, true);    
        
        //Create System Production
        System_Production__c sysPro = new System_Production__c();
        
        sysPro.PV_AnnualNetEnergy_Year1__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year2__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year3__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year4__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year5__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year6__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year7__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year8__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year9__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year10__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year11__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year12__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year13__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year14__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year15__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year16__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year17__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year18__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year19__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year20__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year21__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year22__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year23__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year24__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year25__c = 9774.3820366188540;
        
        sysPro.Quote__c = newQuote.id;
        
        insert sysPro;
        
        //Create Case
        Case newCase = new Case();       
        newCase.Status = 'New';
        //newCase.RecordTypeId = euInspectionCaseRecTypeId;
        newCase.Quote__c=newQuote.id;
        newCase.Subject='Design Change';
        //newCase.isClosed=true;
        insert newCase;
        
        
        Global_Variable__c newGlobalVariable = new Global_Variable__c();
        Date dt = date.today()+2;
        newGlobalVariable.Start_Date__c = Date.parse('9/9/2013');
        newGlobalVariable.End_Date__c = dt;
        newGlobalVariable.Variable_Type__c = 'TPO France';
        newGlobalVariable.Variable_Value__c = '0';
        newGlobalVariable.Name = 'FitRate';
        insert newGlobalVariable;
        
        Global_Variable__c newGlobalVariable1 = new Global_Variable__c();
        Date dt1 = date.today()+2;
        newGlobalVariable1.Start_Date__c = Date.parse('9/9/2013');
        newGlobalVariable1.End_Date__c = dt1;
        newGlobalVariable1.Variable_Type__c = 'TPO France';
        newGlobalVariable1.Variable_Value__c = '0';
        newGlobalVariable1.Name = 'ERDFFee';
        insert newGlobalVariable1;
        
        Global_Variable__c newGlobalVariable2 = new Global_Variable__c();
        Date dt2 = date.today()+2;
        newGlobalVariable2.Start_Date__c = Date.parse('9/9/2013');
        newGlobalVariable2.End_Date__c = dt2;
        newGlobalVariable2.Variable_Type__c = 'TPO France';
        newGlobalVariable2.Variable_Value__c = '0';
        newGlobalVariable2.Name = 'Origination';
        insert newGlobalVariable2;
        
        Global_Variable__c newGlobalVariable3 = new Global_Variable__c();
        Date dt3 = date.today()+2;
        newGlobalVariable3.Start_Date__c = Date.parse('9/9/2013');
        newGlobalVariable3.End_Date__c = dt3;
        newGlobalVariable3.Variable_Type__c = 'TPO France';
        newGlobalVariable3.Variable_Value__c = '0';
        newGlobalVariable3.Name = 'Interconnection';
        insert newGlobalVariable3;
        
        Global_Variable__c newGlobalVariable4 = new Global_Variable__c();
        Date dt4 = date.today()+2;
        newGlobalVariable4.Start_Date__c = Date.parse('9/9/2013');
        newGlobalVariable4.End_Date__c = dt4;
        newGlobalVariable4.Variable_Type__c = 'TPO France';
        newGlobalVariable4.Variable_Value__c = '0';
        newGlobalVariable4.Name = 'FITRateEsc';
        insert newGlobalVariable4;
        
        
        User usr;
        usr = TestUtils.createUser('system administrator', false);
        insert usr;
        Profile p = [SELECT Id FROM Profile WHERE Name='system administrator']; 
        User u = [select id from User where ProfileId =: p.Id and IsActive=true limit 1];
        Test.startTest(); //JAJA 9.23.15    
        System.runAs(u) {
            Test.setCurrentPageReference(new PageReference('Page.TPO_RoofDesignTab')); 
            
            ApexPages.currentPage().getParameters().put('qid',newQuote.id); 
            ApexPages.currentPage().getParameters().put('aID',newAccount.Id);
            ApexPages.currentPage().getParameters().put('sesid',session);
            ApexPages.currentPage().getParameters().put('oppid',newOpportunity.id);
              
            TPO_RoofDetailsQuotenew TPO_rdqn2 = new TPO_RoofDetailsQuotenew();
            TPO_rdqn2.irregularCheck = true;
            TPO_rdqn2.ShowDesignReview();
         Test.stopTest(); //JAJA 9.23.15       
        
        }
    }
   
    static testMethod void TPO_RoofDetailsQuotenew3(){
        SFDCSpecialUtilities.isRunningTest = True; 
        
        Account newAccount;
        Contact newContact;
        Opportunity newOpportunity;
        Quote newQuote;

        
        User u = TestUtils.createUser('System Administrator', false); //MAM 22.MAY.2015 Use TestUtils.createUser for the user creation
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
       
        
        insert newQuote;    
        
       
        List<Roof_Details__c> rfList = new List<Roof_Details__c>();
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
        List<Lease_Schedule__c> leaseList = TestUtils.createLeaseSchedules(quoteID, true);  
        
        Quote_Line__c newQuoteLine  = new Quote_Line__c();
        newQuoteLine.Item__c = newItem.Id;
        newQuoteLine.Roof__c = 'Roof 2';
        newQuoteLine.Quote__c = newQuote.id;
        //newQuoteLine.Item__c = '';
        insert newQuoteLine;
        
        System_Production__c sysPro = new System_Production__c();
        
        sysPro.PV_AnnualNetEnergy_Year1__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year2__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year3__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year4__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year5__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year6__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year7__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year8__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year9__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year10__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year11__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year12__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year13__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year14__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year15__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year16__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year17__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year18__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year19__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year20__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year21__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year22__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year23__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year24__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year25__c = 9774.3820366188540;
        
        sysPro.Quote__c = newQuote.id;
        insert sysPro;
        
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
        
        Rental_Schedule__c newRenSch = new Rental_Schedule__c ();
        newRenSch.Quote__c = newQuote.id;
        newRenSch.Year__c = 1.0;
        newRenSch.TVs_1__c = 0.0;
        newRenSch.TVs_2__c = 0.0;
        newRenSch.Payments_to_the_customer_1__c = 0.0;
        newRenSch.Payments_to_the_customer_2__c = 0.0;
        
        insert newRenSch ;
        
        List<Global_Variable__c > gvList = new List<Global_Variable__c >();
         Date dt = date.today()+2;
         for(integer i = 0; i < 10; i ++){
            Global_Variable__c gv= new Global_Variable__c ();
            gv.Start_Date__c = date.today();
            gv.End_Date__c = dt;
            gv.Variable_Type__c = 'TPO France';
            gv.Variable_Value__c = '0';
            
            if(i == 0)
                gv.Name = 'Leadclosefee' ;
                
            if(i == 1)
                gv.Name = 'PermitFee' ;
                
            if(i == 2)
                gv.Name = 'ConformityCertificationFee' ;
                
            if(i == 3)
                gv.Name = 'FITCertificationFee' ;
                
            if(i == 4)
                gv.Name = 'BaseDealerFee'  ;
            
            if(i == 5)
                gv.Name = 'TrenchFee' ;
            
            if(i == 6)
                gv.Name = 'TrenchFee_25meters_greater';
            
            if(i == 7)
                gv.Name = 'IrregularRoofFee'  ;
            
            if(i == 8)
                gv.Name = 'MultiroofFee'  ;
            
            if(i == 9)
                gv.Name = 'LeadGenerationFee'  ;
            
           
            gvList.add(gv);
        }
        
        upsert gvList ;   
       Test.startTest(); //JAJA 9.23.15
        system.runAs(u){
        
            Test.setCurrentPageReference(new PageReference('Page.TPO_RoofDetailsTab')); 
           
            system.debug('$$$$$$$$$$$$newAccount.ID='+newAccount.ID);
            System.currentPageReference().getParameters().put('aId', newAccount.ID);
            System.currentPageReference().getParameters().put('qId', quoteID);
            System.currentPageReference().getParameters().put('imageId', '1');  
            
            TPO_RoofDetailsQuotenew TPO_rdqn = new TPO_RoofDetailsQuotenew();
            
            //TPO_rdqn.irregularCheck = true;
            TPO_rdqn.bRecordCreated = true;
            TPO_rdqn.ShowRoofDetails();
            TPO_rdqn.prevDesignReview();
            TPO_rdqn.ShowRoofDesign();
            TPO_rdqn.SolrifDesigndocs();
            //TPO_rdqn.ProposalDesigndocs();
           // TPO_rdqn.createQuoteLine();
        Test.stopTest(); //JAJA 9.23.15    
        }
        
    }
    
    static testMethod void TPO_RoofDetailsQuotenew8(){
        SFDCSpecialUtilities.isRunningTest = True; 
        
        Account newAccount;
        Contact newContact;
        Opportunity newOpportunity;
        Quote newQuote;

        User u = TestUtils.createUser('System Administrator', false); //MAM 22.MAY.2015 Use TestUtils.createUser for the user creation
        
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
        newQuote.Wiring_Distance__c = '2.5 meters or less';
        //newQuote.DownPayment_Type__c = '0 Down Payment';
        //newQuote.OracleItemNumber__c = 125565.0;
       
        Test.startTest();
        insert newQuote;    
        Test.StopTest();
       
        List<Roof_Details__c> rfList = new List<Roof_Details__c>();
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
        List<Lease_Schedule__c> leaseList = TestUtils.createLeaseSchedules(quoteID, true);  
        
        Quote_Line__c newQuoteLine  = new Quote_Line__c();
        newQuoteLine.Item__c = newItem.Id;
        newQuoteLine.Roof__c = 'Roof 2';
        newQuoteLine.Quote__c = newQuote.id;
        insert newQuoteLine;
        
        System_Production__c sysPro = new System_Production__c();
        
        sysPro.PV_AnnualNetEnergy_Year1__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year2__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year3__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year4__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year5__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year6__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year7__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year8__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year9__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year10__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year11__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year12__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year13__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year14__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year15__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year16__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year17__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year18__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year19__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year20__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year21__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year22__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year23__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year24__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year25__c = 9774.3820366188540;
        
        sysPro.Quote__c = newQuote.id;
        insert sysPro;
        
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
        
        Rental_Schedule__c newRenSch = new Rental_Schedule__c ();
        newRenSch.Quote__c = newQuote.id;
        newRenSch.Year__c = 1.0;
        newRenSch.TVs_1__c = 0.0;
        newRenSch.TVs_2__c = 0.0;
        newRenSch.Payments_to_the_customer_1__c = 0.0;
        newRenSch.Payments_to_the_customer_2__c = 0.0;
        
        insert newRenSch ;
        
        List<Global_Variable__c > gvList = new List<Global_Variable__c >();
         Date dt = date.today()+2;
         for(integer i = 0; i < 10; i ++){
            Global_Variable__c gv= new Global_Variable__c ();
            gv.Start_Date__c = date.today();
            gv.End_Date__c = dt;
            gv.Variable_Type__c = 'TPO France';
            gv.Variable_Value__c = '0';
            
            if(i == 0)
                gv.Name = 'Leadclosefee' ;
                
            if(i == 1)
                gv.Name = 'PermitFee' ;
                
            if(i == 2)
                gv.Name = 'ConformityCertificationFee' ;
                
            if(i == 3)
                gv.Name = 'FITCertificationFee' ;
                
            if(i == 4)
                gv.Name = 'BaseDealerFee'  ;
            
            if(i == 5)
                gv.Name = 'TrenchFee' ;
            
            if(i == 6)
                gv.Name = 'TrenchFee_25meters_greater';
            
            if(i == 7)
                gv.Name = 'IrregularRoofFee'  ;
            
            if(i == 8)
                gv.Name = 'MultiroofFee'  ;
            
            if(i == 9)
                gv.Name = 'LeadGenerationFee'  ;
            
           
            gvList.add(gv);
        }
        
        upsert gvList ;   
        
        system.runAs(u){
        
            Test.setCurrentPageReference(new PageReference('Page.TPO_RoofDetailsTab')); 
           
            system.debug('$$$$$$$$$$$$newAccount.ID='+newAccount.ID);
            System.currentPageReference().getParameters().put('aId', newAccount.ID);
            System.currentPageReference().getParameters().put('qId', quoteID);
            System.currentPageReference().getParameters().put('imageId', '1');  
            
            TPO_RoofDetailsQuotenew TPO_rdqn = new TPO_RoofDetailsQuotenew();
            
           
            TPO_rdqn.createQuoteLine();
            
            
        }
    }
    
    static testMethod void TPO_RoofDetailsQuotenew6(){
        SFDCSpecialUtilities.isRunningTest = True; 
        
        Account newAccount;
        Contact newContact;
        Opportunity newOpportunity;
        Quote newQuote;
        
        User u = TestUtils.createUser('System Administrator', false); //MAM 22.MAY.2015 Use TestUtils.createUser for the user creation
        
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
       
        List<Roof_Details__c> rfList = new List<Roof_Details__c>();
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
        List<Lease_Schedule__c> leaseList = TestUtils.createLeaseSchedules(quoteID, true);  
        
        Quote_Line__c newQuoteLine  = new Quote_Line__c();
        newQuoteLine.Item__c = newItem.Id;
        newQuoteLine.Roof__c = 'Roof 2';
        newQuoteLine.Quote__c = newQuote.id;
         newQuoteLine.Quantity__c =1;
        insert newQuoteLine;
        
        System_Production__c sysPro = new System_Production__c();
        
        sysPro.PV_AnnualNetEnergy_Year1__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year2__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year3__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year4__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year5__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year6__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year7__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year8__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year9__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year10__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year11__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year12__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year13__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year14__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year15__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year16__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year17__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year18__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year19__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year20__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year21__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year22__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year23__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year24__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year25__c = 9774.3820366188540;
        
        sysPro.Quote__c = newQuote.id;
        insert sysPro;
        
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
        
        Rental_Schedule__c newRenSch = new Rental_Schedule__c ();
        newRenSch.Quote__c = newQuote.id;
        newRenSch.Year__c = 1.0;
        newRenSch.TVs_1__c = 0.0;
        newRenSch.TVs_2__c = 0.0;
        newRenSch.Payments_to_the_customer_1__c = 0.0;
        newRenSch.Payments_to_the_customer_2__c = 0.0;
        
        insert newRenSch ;
        
        List<Global_Variable__c > gvList = new List<Global_Variable__c >();
         Date dt = date.today()+2;
         for(integer i = 0; i < 10; i ++){
            Global_Variable__c gv= new Global_Variable__c ();
            gv.Start_Date__c = date.today();
            gv.End_Date__c = dt;
            gv.Variable_Type__c = 'TPO France';
            gv.Variable_Value__c = '0';
            
            if(i == 0)
                gv.Name = 'Leadclosefee' ;
                
            if(i == 1)
                gv.Name = 'PermitFee' ;
                
            if(i == 2)
                gv.Name = 'ConformityCertificationFee' ;
                
            if(i == 3)
                gv.Name = 'FITCertificationFee' ;
                
            if(i == 4)
                gv.Name = 'BaseDealerFee'  ;
            
            if(i == 5)
                gv.Name = 'TrenchFee' ;
            
            if(i == 6)
                gv.Name = 'TrenchFee_25meters_greater';
            
            if(i == 7)
                gv.Name = 'IrregularRoofFee'  ;
            
            if(i == 8)
                gv.Name = 'MultiroofFee'  ;
            
            if(i == 9)
                gv.Name = 'LeadGenerationFee'  ;
            
           
            gvList.add(gv);
        }
        
        upsert gvList ;   
        
        system.runAs(u){
        
            Test.setCurrentPageReference(new PageReference('Page.TPO_RoofDetailsTab')); 
           
            system.debug('$$$$$$$$$$$$newAccount.ID='+newAccount.ID);
            System.currentPageReference().getParameters().put('aId', newAccount.ID);
            System.currentPageReference().getParameters().put('qId', quoteID);
            System.currentPageReference().getParameters().put('imageId', '1');  
            
            TPO_RoofDetailsQuotenew TPO_rdqn = new TPO_RoofDetailsQuotenew();
            
            //TPO_rdqn.irregularCheck = true;
            
            TPO_rdqn.returnAccount();
            TPO_rdqn.DisplayErrorRFD('Roof Details@');
            TPO_rdqn.ShowErrorMsg();
            //TPO_rdqn.callPVSIM();
            TPO_rdqn.redirDesignreview();
            //TPO_rdqn.callPVSIMLock(); 
        }
    }
    
    static testMethod void TPO_RoofDetailsQuotenew4(){
        Account newAccount;
        Contact newContact;
        
        Quote newQuote;
        
        User u = TestUtils.createUser('System Administrator', false); //MAM 22.MAY.2015 Use TestUtils.createUser for the user creation
        
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
        
        Price_List_Item__c newPriceListItem = new Price_List_Item__c();
        newPriceListItem.Item_ID__c= newItem.id;
        newPriceListItem.Category__c='Module';
        //newPriceListItem.Is_Active__c= 'true';
        newPriceListItem.Price_List__c=priceItem.id;
        newPriceListItem.Name='230W (Model SPR-230E-WHT-D)';
        insert newPriceListItem;
        
        newContact = TestUtils.createContact('QuickQuote TEST CONTACT 1', newAccount.Id, true );
        Opportunity newOpportunity = new Opportunity();
        newOpportunity.AccountId = newAccount.id;
        newOpportunity.Lead_Manufacturer__c = 'Partner';
        newOpportunity.Name = 'test oppty';
        newOpportunity.StageName = '12% Qualified Opportunity';
        newOpportunity.CloseDate = Date.today();
        //newOpportunity.Primary_Contact__c = newContact.id;
        insert newOpportunity;
        
        //newOpportunity = TestUtils.createOpportunities(1, newAccount.id, newContact.Id, true).get(0);
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
            rf.Pitch__c = '15';
            rf.Roof_Pitches__c = true;
            rf.Shading_Notes__c = 'notes';
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
        List<Lease_Schedule__c> leaseList = TestUtils.createLeaseSchedules(quoteID, true);    
        
        System_Production__c sysPro = new System_Production__c();
        
        sysPro.PV_AnnualNetEnergy_Year1__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year2__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year3__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year4__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year5__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year6__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year7__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year8__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year9__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year10__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year11__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year12__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year13__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year14__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year15__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year16__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year17__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year18__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year19__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year20__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year21__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year22__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year23__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year24__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year25__c = 9774.3820366188540;
        sysPro.Quote__c = newQuote.id;
        insert sysPro;
        system.runAs(u){
            Test.startTest(); //JAJA 9.23.15
            Test.setCurrentPageReference(new PageReference('Page.TPO_RoofDetailsTab')); 
            system.debug('$$$$$$$$$$$$newAccount.ID='+newAccount.ID);
            System.currentPageReference().getParameters().put('aId', newAccount.ID);
            System.currentPageReference().getParameters().put('qId', quoteID);
            System.currentPageReference().getParameters().put('imageId', '1'); 
            
            TPO_RoofDetailsQuotenew TPO_rdqn1 = new TPO_RoofDetailsQuotenew();
            TPO_rdqn1.bRecordCreated = false;
            TPO_rdqn1.addTab();
            TPO_rdqn1.getTabCount();
            TPO_rdqn1.tabCount =0;
            TPO_rdqn1.getTabCount();
            TPO_rdqn1.tabCount =1;
            TPO_rdqn1.getTabCount();
            TPO_rdqn1.tabCount =2;
            TPO_rdqn1.getTabCount();
            TPO_rdqn1.tabCount =3;
            TPO_rdqn1.getTabCount();
            TPO_rdqn1.getMyTabs();
            TPO_rdqn1.ShowDesignTool(); 
            TPO_rdqn1.lockqinputs();
            TPO_rdqn1.ShowQuote();
            TPO_rdqn1.sysPrdCheck();
            //TPO_rdqn.CreateQuote();
            TPO_rdqn1.getsprecords();
            TPO_rdqn1.SaveroofDesign();
            TPO_RoofDetailsQuotenew.customeroption cc = new TPO_RoofDetailsQuotenew.customeroption(sysPro);
            Test.stopTest(); //JAJA 9.23.15
            //TPO_rdqn1.validatesavelock();
           
       }
    }
    
    
    
     static testMethod void TPO_RoofDetailsQuotenew9(){
        Account newAccount;
        Contact newContact;
        
        Quote newQuote;
        
        User u = TestUtils.createUser('System Administrator', false); //MAM 22.MAY.2015 Use TestUtils.createUser for the user creation
        
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
        
        Price_List_Item__c newPriceListItem = new Price_List_Item__c();
        newPriceListItem.Item_ID__c= newItem.id;
        newPriceListItem.Category__c='Module';
        //newPriceListItem.Is_Active__c= 'true';
        newPriceListItem.Price_List__c=priceItem.id;
        newPriceListItem.Name='230W (Model SPR-230E-WHT-D)';
        insert newPriceListItem;
        
        newContact = TestUtils.createContact('QuickQuote TEST CONTACT 1', newAccount.Id, true );
        Opportunity newOpportunity = new Opportunity();
        newOpportunity.AccountId = newAccount.id;
        newOpportunity.Lead_Manufacturer__c = 'Partner';
        newOpportunity.Name = 'test oppty';
        newOpportunity.StageName = '12% Qualified Opportunity';
        newOpportunity.CloseDate = Date.today();
        //newOpportunity.Primary_Contact__c = newContact.id;
        insert newOpportunity;
        
        //newOpportunity = TestUtils.createOpportunities(1, newAccount.id, newContact.Id, true).get(0);
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
        
       
        Test.startTest();
        insert newQuote;    
        Test.StopTest();
       
       List<Roof_Details__c> rfList = new List<Roof_Details__c>();
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
            rf.Pitch__c = '15';
            rf.Roof_Pitches__c = true;
            rf.Shading_Notes__c = 'notes';
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
        List<Lease_Schedule__c> leaseList = TestUtils.createLeaseSchedules(quoteID, true);    
        
        System_Production__c sysPro = new System_Production__c();
        
        sysPro.PV_AnnualNetEnergy_Year1__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year2__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year3__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year4__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year5__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year6__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year7__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year8__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year9__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year10__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year11__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year12__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year13__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year14__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year15__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year16__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year17__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year18__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year19__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year20__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year21__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year22__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year23__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year24__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year25__c = 9774.3820366188540;
        
        sysPro.Quote__c = newQuote.id;
        insert sysPro;
        
        system.runAs(u){
            Test.setCurrentPageReference(new PageReference('Page.TPO_RoofDetailsTab')); 
            system.debug('$$$$$$$$$$$$newAccount.ID='+newAccount.ID);
            System.currentPageReference().getParameters().put('aId', newAccount.ID);
           System.currentPageReference().getParameters().put('qId', quoteID);
            System.currentPageReference().getParameters().put('imageId', '1'); 
            
            TPO_RoofDetailsQuotenew TPO_rdqn1 = new TPO_RoofDetailsQuotenew();
            TPO_rdqn1.bRecordCreated = false;
            TPO_rdqn1.prevRoofDesign(); 
            TPO_rdqn1.prevRoofDetails();
            TPO_rdqn1.chkrdesfields();
            //TPO_rdqn1.CreateQuote();
            TPO_rdqn1.CalcDealerFee();
            TPO_rdqn1.isFranceRUser=true;
            TPO_rdqn1.isFranceRUser=false;
            TPO_rdqn1.getInitPage();
          
          
          
             
            
            
            
      
           
            TPO_RoofDetailsQuotenew.customeroption cc = new TPO_RoofDetailsQuotenew.customeroption(sysPro);
            //TPO_rdqn1.validatesavelock();
            
       }
    }
    
     static testMethod void TPO_RoofDetailsQuotenew10(){
        Account newAccount;
        Contact newContact;
        
        Quote newQuote;
        
        User u = TestUtils.createUser('System Administrator', false); //MAM 22.MAY.2015 Use TestUtils.createUser for the user creation
        
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
        
        Price_List_Item__c newPriceListItem = new Price_List_Item__c();
        newPriceListItem.Item_ID__c= newItem.id;
        newPriceListItem.Category__c='Module';
        //newPriceListItem.Is_Active__c= 'true';
        newPriceListItem.Price_List__c=priceItem.id;
        newPriceListItem.Name='230W (Model SPR-230E-WHT-D)';
        insert newPriceListItem;
        
        newContact = TestUtils.createContact('QuickQuote TEST CONTACT 1', newAccount.Id, true );
        Opportunity newOpportunity = new Opportunity();
        newOpportunity.AccountId = newAccount.id;
        newOpportunity.Lead_Manufacturer__c = 'Partner';
        newOpportunity.Name = 'test oppty';
        newOpportunity.StageName = '12% Qualified Opportunity';
        newOpportunity.CloseDate = Date.today();
        //newOpportunity.Primary_Contact__c = newContact.id;
        insert newOpportunity;
        
        //newOpportunity = TestUtils.createOpportunities(1, newAccount.id, newContact.Id, true).get(0);
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
        
       
        Test.startTest();
        insert newQuote;    
        Test.StopTest();
       
       List<Roof_Details__c> rfList = new List<Roof_Details__c>();
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
            rf.Pitch__c = '15';
            rf.Roof_Pitches__c = true;
            rf.Shading_Notes__c = 'notes';
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
        List<Lease_Schedule__c> leaseList = TestUtils.createLeaseSchedules(quoteID, true);    
        
        System_Production__c sysPro = new System_Production__c();
        
        sysPro.PV_AnnualNetEnergy_Year1__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year2__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year3__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year4__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year5__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year6__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year7__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year8__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year9__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year10__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year11__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year12__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year13__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year14__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year15__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year16__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year17__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year18__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year19__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year20__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year21__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year22__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year23__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year24__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year25__c = 9774.3820366188540;
        
        sysPro.Quote__c = newQuote.id;
        insert sysPro;
        
        system.runAs(u){
            Test.setCurrentPageReference(new PageReference('Page.TPO_RoofDetailsTab')); 
            system.debug('$$$$$$$$$$$$newAccount.ID='+newAccount.ID);
            System.currentPageReference().getParameters().put('aId', newAccount.ID);
            System.currentPageReference().getParameters().put('oppid',newOpportunity.id);
            System.currentPageReference().getParameters().put('imageId', '1'); 
            
            TPO_RoofDetailsQuotenew TPO_rdqn1 = new TPO_RoofDetailsQuotenew();
            TPO_rdqn1.bRecordCreated = false;
            
            TPO_rdqn1.CreateQuote();
            //TPO_rdqn1.createCase();
            
             // TPO_rdqn1.createCase();
           // Opportunity.Name = 'test oppty';
                  
            TPO_RoofDetailsQuotenew.customeroption cc = new TPO_RoofDetailsQuotenew.customeroption(sysPro);
            //TPO_rdqn1.validatesavelock();
            
       }
    }
    static testMethod void TPO_RoofDetailsQuotenew7(){
        Account newAccount;
        Contact newContact;
        
        Quote newQuote;
        
        User u = TestUtils.createUser('System Administrator', false); //MAM 22.MAY.2015 Use TestUtils.createUser for the user creation
        
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
        
        Price_List_Item__c newPriceListItem = new Price_List_Item__c();
        newPriceListItem.Item_ID__c= newItem.id;
        newPriceListItem.Category__c='Module';
        //newPriceListItem.Is_Active__c= 'true';
        newPriceListItem.Price_List__c=priceItem.id;
        newPriceListItem.Name='230W (Model SPR-230E-WHT-D)';
        insert newPriceListItem;
        
        newContact = TestUtils.createContact('QuickQuote TEST CONTACT 1', newAccount.Id, true );
        Opportunity newOpportunity = new Opportunity();
        newOpportunity.AccountId = newAccount.id;
        newOpportunity.Lead_Manufacturer__c = 'Partner';
        newOpportunity.Name = 'test oppty';
        newOpportunity.StageName = '12% Qualified Opportunity';
        newOpportunity.CloseDate = Date.today();
        //newOpportunity.Primary_Contact__c = newContact.id;
        insert newOpportunity;
        
        //newOpportunity = TestUtils.createOpportunities(1, newAccount.id, newContact.Id, true).get(0);
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
       
        Test.startTest();
        insert newQuote;    
        Test.StopTest();
       
       List<Roof_Details__c> rfList = new List<Roof_Details__c>();
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
            rf.Pitch__c = '15';
            rf.Roof_Pitches__c = true;
            rf.Shading_Notes__c = 'notes';
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
        List<Lease_Schedule__c> leaseList = TestUtils.createLeaseSchedules(quoteID, true);    
        
        System_Production__c sysPro = new System_Production__c();
        
        sysPro.PV_AnnualNetEnergy_Year1__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year2__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year3__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year4__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year5__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year6__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year7__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year8__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year9__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year10__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year11__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year12__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year13__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year14__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year15__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year16__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year17__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year18__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year19__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year20__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year21__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year22__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year23__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year24__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year25__c = 9774.3820366188540;
        
        sysPro.Quote__c = newQuote.id;
        insert sysPro;
        
        system.runAs(u){
            Test.setCurrentPageReference(new PageReference('Page.TPO_RoofDetailsTab')); 
            system.debug('$$$$$$$$$$$$newAccount.ID='+newAccount.ID);
            System.currentPageReference().getParameters().put('aId', newAccount.ID);
            System.currentPageReference().getParameters().put('qId', quoteID);
            System.currentPageReference().getParameters().put('imageId', '1'); 
            
            TPO_RoofDetailsQuotenew TPO_rdqn1 = new TPO_RoofDetailsQuotenew();
            TPO_rdqn1.bRecordCreated = false;
            TPO_rdqn1.roofdetialmainfields = 'Roof';
            TPO_rdqn1.roofdetialfields = 'Roof';
            TPO_rdqn1.validataDataRFD();
            TPO_rdqn1.viewPropBtnClk();
            TPO_rdqn1.LockQuoteBttnClk();
            //TPO_rdqn.CreateRentalSchedule();
       }
    }
    
      static testMethod void TPO_RoofDetailsQuotenew5(){
        Account newAccount;
        Contact newContact;
        Quote newQuote;
        
        User u = TestUtils.createUser('System Administrator', false); //MAM 22.MAY.2015 Use TestUtils.createUser for the user creation
        
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
        
        Price_List_Item__c newPriceListItem = new Price_List_Item__c();
        newPriceListItem.Item_ID__c= newItem.id;
        newPriceListItem.Category__c='Module';
        //newPriceListItem.Is_Active__c= 'true';
        newPriceListItem.Price_List__c=priceItem.id;
        newPriceListItem.Name='230W (Model SPR-230E-WHT-D)';
        insert newPriceListItem;
        
        newContact = TestUtils.createContact('QuickQuote TEST CONTACT 1', newAccount.Id, true );
          
        Opportunity newOpportunity = new Opportunity();
        newOpportunity.AccountId = newAccount.id;
        newOpportunity.Lead_Manufacturer__c = 'Partner';
        newOpportunity.Name = 'test oppty';
        newOpportunity.StageName = '12% Qualified Opportunity';
        newOpportunity.CloseDate = Date.today();
        //newOpportunity.Primary_Contact__c = newContact.id;
        insert newOpportunity;
        
        //newOpportunity = TestUtils.createOpportunities(1, newAccount.id, newContact.Id, true).get(0);
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
       
        Test.startTest();
        insert newQuote;    
        Test.StopTest();
       
       List<Roof_Details__c> rfList = new List<Roof_Details__c>();
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
            rf.Pitch__c = '15';
            rf.Roof_Pitches__c = true;
            rf.Shading_Notes__c = 'notes';
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
        List<Lease_Schedule__c> leaseList = TestUtils.createLeaseSchedules(quoteID, true);    
        
        System_Production__c sysPro = new System_Production__c();
        
        sysPro.PV_AnnualNetEnergy_Year1__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year2__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year3__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year4__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year5__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year6__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year7__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year8__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year9__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year10__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year11__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year12__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year13__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year14__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year15__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year16__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year17__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year18__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year19__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year20__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year21__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year22__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year23__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year24__c = 9774.3820366188540;
        sysPro.PV_AnnualNetEnergy_Year25__c = 9774.3820366188540;
        
        sysPro.Quote__c = newQuote.id;
        insert sysPro;
        
          TPO_MPPT__c  newMppt = new TPO_MPPT__c ();
        newMppt.Module_Name__c = '245W (Model SPR-245NE-WHT-D)';
        newMppt.MPPT_1_String_Qty__c = 1.0;
        newMppt.Module_Quantity__c = 1.0;
        newMppt.Item_ID__c = 125565.0 ;
        newMppt.Inverter_Name_1__c = 'SPR-3600P-TL1-EU';
        newMppt.Inverter_Quantity__c = 1.0;
        newMppt.Surface__c = 18.81;
        newMppt.Wats_Power__c = 4000.0;
        newMppt.Document_Link__c ='';
        insert newMppt;
        
        Rental_Schedule__c newRenSch = new Rental_Schedule__c ();
        newRenSch.Quote__c = newQuote.id;
        newRenSch.Year__c = 1.0;
        newRenSch.TVs_1__c = 0.0;
        newRenSch.TVs_2__c = 0.0;
        newRenSch.Payments_to_the_customer_1__c = 0.0;
        newRenSch.Payments_to_the_customer_2__c = 0.0;
        
        insert newRenSch ;
          
        system.runAs(u){
            Test.setCurrentPageReference(new PageReference('Page.TPO_RoofDetailsTab')); 
            system.debug('$$$$$$$$$$$$newAccount.ID='+newAccount.ID);
            System.currentPageReference().getParameters().put('aId', newAccount.ID);
            System.currentPageReference().getParameters().put('qId', quoteID);
            System.currentPageReference().getParameters().put('imageId', '1'); 
            
            TPO_RoofDetailsQuotenew TPO_rdqn5 = new TPO_RoofDetailsQuotenew();
            TPO_rdqn5.bRecordCreated = false;
            //TPO_rdqn5.CreateRentalSchedule();
            //TPO_rdqn5.DisplayErrorRFD('@!');
        }
      } 
      
      
   /* static testMethod void TPO_RoofDetailsQuotenew4(){
        Account newAccount;
        Contact newContact;
        Opportunity newOpportunity;
        Quote newQuote;
        User newUser;
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
        //Profile p = [SELECT Id FROM Profile WHERE Name='system administrator']; 
        //User u = [select id from User where ProfileId =: p.Id and IsActive=true and Country_Domain__c='rvar-fr' limit 1];
        newUser = TestUtils.createPartnerPortalUser( newContact, true);
       
        
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
       
        Test.startTest();
        insert newQuote;    
        Test.StopTest();
       
       List<Roof_Details__c> rfList = new List<Roof_Details__c>();
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
        List<Lease_Schedule__c> leaseList = TestUtils.createLeaseSchedules(quoteID, true);    
        
        System_Production__c sysPro = new System_Production__c();
        sysPro.Quote__c = newQuote.id;
        insert sysPro;
        
        system.runAs(newUser){
            Test.setCurrentPageReference(new PageReference('Page.TPO_RoofDetailsTab')); 
            system.debug('$$$$$$$$$$$$newAccount.ID='+newAccount.ID);
            System.currentPageReference().getParameters().put('aId', newAccount.ID);
            System.currentPageReference().getParameters().put('qId', quoteID);
            System.currentPageReference().getParameters().put('imageId', '1'); 
            
            TPO_RoofDetailsQuotenew TPO_rdqn1 = new TPO_RoofDetailsQuotenew();
            TPO_rdqn1.bRecordCreated = false;
            TPO_rdqn1.createCase();
           
           
       }
    }*/
}