@isTest
public class TestQuoteReadOnly{

    private static Contact newContact;
    private static Contact customerContact;
    private static Opportunity newOpportunity;
    private static Account partnerAccount;
    private static Contact partnerContact;
    private static User partnerPortalUser;
    private static User sysAdmin;
    private static Account customerAccount;
  
    private static Module_Configuration__c mc;
    private static Monitoring_Configuration__c mConfig;
    private static Inverter_Configuration__c ic;
    private static ModuleInverterJunction__c mij;
    private static Master_Configurator__c masterConfig; 
    private static Racking_Configuration__c rc;
    private static Racking_Item_Junction__c rij;    
    private static Monitoring_Item_junction__c mijj;
    private static ModuleRackingJunction__c mrj;
    private static MasterModuleInverterJunction__c mmij;
    private static MasterModuleRacking_Junction__c mmrj;
    private static List<Item__c> itemList;  
    private static List<SalesConfiguration__c> listSalesConfigs = new List<SalesConfiguration__c>();

	private static void init() {
       UserManagement.IS_TEST = true;
        
        // Code to create the Partner Account 
        Id partnerAccountRecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.sobjectType).get('Partner');
        Id customerAccountRecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.sobjectType).get('Home_Owner');
        
        /*partnerAccount = TestUtils.createAccount('Gabi Solar Test Class',partnerAccountRecordTypeId,false);          
        partnerAccount.Cash_Partner__c = true;
        partnerAccount.Loan_Partner__c = true;
        partnerAccount.Lease2_0_Program_Partner__c = true;
        partnerAccount.Sector_Cash__c = 'Residential';
        partnerAccount.Sector_Lease__c = 'Residential';
        partnerAccount.Sector_Loan__c = 'Residential';
        partnerAccount.Channel__c = 'Indirect';
        insert partnerAccount;
        
        // Code to create the Contact for the Partner Account . and creating the contact for the above Account
        Id partnerContactRecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Contact.sobjectType).get('Partner'); 
        partnerContact = TestUtils.createContact('Tom Dowley Test Class',partnerAccount.Id,false);
        partnerContact.RecordTypeId = partnerContactRecordTypeId;
        insert partnerContact;
        
        partnerPortalUser = TestUtils.createPartnerPortalUser(partnerContact,false);
        partnerPortalUser.Quote_Creation_Allowed__c = true;
        partnerPortalUser.Business_Function__c = 'Create Lease Quote;Create Cash Quote;Create Loan Quote;';
        insert partnerPortalUser; */     
        
        //Create test data for Module Config data model
        itemList = new List<Item__c>();
        Item__c moduleItem = new Item__c();
        moduleItem.Name = '474999';
        moduleItem.Item_ID__c = '474999';
        moduleItem.CEC_PTC_Rating__c = 96.50;
        moduleItem.PV_SIM_no__c = 888;
        moduleItem.PV_Cell_Count__c = 96;
        moduleItem.Manufacturing_Cost__c = 899.98;
        moduleItem.Module_Width__c = 38.90;
        moduleItem.Item_Category_3__c = '327';
        itemList.add(moduleItem);
        
        Item__c inverterItem = new Item__c();
        inverterItem.Name = '899990';
        inverterItem.Item_ID__c = '899990';
        inverterItem.CEC_PTC_Rating__c = 96.50;
        inverterItem.PV_SIM_no__c = 393;
        inverterItem.PV_Cell_Count__c = 96;
        inverterItem.Manufacturing_Cost__c = 899.98;
        inverterItem.Module_Width__c = 38.90;
        itemList.add(inverterItem);
        
        Item__c monitoringItem = new Item__c();       
        monitoringItem.Name = '833309';
        monitoringItem.Item_ID__c = '833309';
        monitoringItem.CEC_PTC_Rating__c = 96.50;
        monitoringItem.PV_SIM_no__c = 292;
        monitoringItem.PV_Cell_Count__c = 96;
        monitoringItem.Manufacturing_Cost__c = 899.98;
        monitoringItem.Module_Width__c = 38.90;
        itemList.add(monitoringItem);
        
        Item__c rackingItem = new Item__c();
        rackingItem.Name = '844009';
        rackingItem.Item_ID__c = '844009';
        rackingItem.CEC_PTC_Rating__c = 96.50;
        rackingItem.PV_SIM_no__c = 123;
        rackingItem.PV_Cell_Count__c = 96;
        rackingItem.Manufacturing_Cost__c = 899.98;
        rackingItem.Module_Width__c = 38.90;
        itemList.add(rackingItem);
        
        insert itemList; 
        mc = new Module_Configuration__c(Name = '327W (Model SPR-327NE-WHT-D)',Current_Type__c = 'AC',Item__c = itemList.get(0).id);
        insert mc;
        
         mConfig = new Monitoring_Configuration__c(Name = 'PVS5 Production Monitoring');
        
         insert mConfig;
        
         ic = new Inverter_Configuration__c(Name = '7.7 kW (Model SUNNY BOY 7700TL-US-22 - 240v (SPR-7702m))',Item__c = itemList.get(1).id,Monitoring__c = mConfig.Id,Inverter_Manufacturer__c = 'Sunpower',Start_Date__c = Date.today(),End_Date__c = Date.valueOf('2099-12-10'));
        
        insert ic;
        
         mij = new ModuleInverterJunction__c(Module_Configuration__c = mc.Id,Inverter_Configuration__c = ic.id);
         insert mij;
        
         masterConfig = new Master_Configurator__c(Name = '327 DC Master',Configuration_Model__c = 'DC');
        insert masterConfig;
        
         rc = new Racking_Configuration__c(Name = 'Test Racking',Kit_Size__c = 3,Type__c = 'Invisimount');
        
        insert rc;
        
         rij = new Racking_Item_Junction__c(Name = 'test junction',Racking_Configuration__c = rc.Id,Item__c = itemList.get(3).id);
        
        insert rij;
        
         mijj = new Monitoring_Item_junction__c(Name = 'test M junction',Monitoring_Configuration__c = mConfig.Id,Item__c = itemList.get(2).id,Type__c = 'Kit');
        
        insert mijj;
        
         mrj = new ModuleRackingJunction__c(Module_Configuration__c = mc.Id,Racking_Configuration__c = rc.Id);
        
        insert mrj;
        
         mmij = new MasterModuleInverterJunction__c(Master_Configuration__c = masterConfig.Id, ModuleInverterJunction__c = mij.Id);
        insert mmij;
        
         mmrj = new MasterModuleRacking_Junction__c(Master_Configurator__c = masterConfig.Id,ModuleRackingJunction__c = mrj.Id);
        insert mmrj;
        
        SalesConfiguration__c salesConfig1
            = new SalesConfiguration__c(Active__c = true,
                          Channel__c = 'Indirect',
                          Financial_Offering__c = 'Lease',
                          Configurator__c = masterConfig.Id,
                          Operating_Unit__c = 'SPNA OU',
                          SalesMethodology__c = 'Quote',
                          Sector__c = 'Residential',
                          State__c = 'CA');
                          
          SalesConfiguration__c salesConfig2
            = new SalesConfiguration__c(Active__c = true,
                          Channel__c = 'Indirect',
                          Financial_Offering__c = 'Cash',
                          Configurator__c = masterConfig.Id,
                          Operating_Unit__c = 'SPNA OU',
                          SalesMethodology__c = 'Quote',
                          Sector__c = 'Residential',
                          State__c = 'CA'); 
        
          SalesConfiguration__c salesConfig3
            = new SalesConfiguration__c(Active__c = true,
                          Channel__c = 'Indirect',
                          Financial_Offering__c = 'Loan',
                          Configurator__c = masterConfig.Id,
                          Operating_Unit__c = 'SPNA OU',
                          SalesMethodology__c = 'Quote',
                          Sector__c = 'Residential',
                          State__c = 'CA');                                               
        
        listSalesConfigs.add(salesConfig1);
        listSalesConfigs.add(salesConfig2);
        listSalesConfigs.add(salesConfig3);
        insert listSalesConfigs;
        
        //System.runAs(partnerPortalUser){  
            customerAccount = TestUtils.createAccount('Test Lease Quickquote',customerAccountRecordTypeId,false);
            customerAccount.ShippingCity = 'San Jose';
            customerAccount.ShippingStreet = 'Rio Robles';
            customerAccount.ShippingCountry = 'United States';
            customerAccount.ShippingState='CA';
            customerAccount.ShippingPostalCode ='95134';
            customerAccount.BillingCity = 'San Jose';
            customerAccount.BillingStreet = 'Rio Robles';
            customerAccount.BillingCountry = 'United States';
            customerAccount.BillingState='CA';
            customerAccount.BillingPostalCode ='95134';
            customerAccount.Sales_Tax_Rate__c = 2;
            customerAccount.Filing_Status__c = 'Single';
            customerAccount.Income__c = 100000.00;
            insert customerAccount;
            Attachment a = new Attachment(Name ='test attachment',Body = Blob.valueOf('test'),ParentId = customerAccount.Id);
            insert a;
            customerContact = TestUtils.createContact('Test Lease', customerAccount.Id, false );       
            customerContact.MailingCity = 'San Jose';
            customerContact.MailingStreet = 'Rio Robles';
            customerContact.MailingCountry = 'United States';
            customerContact.MailingState='CA';
            customerContact.MailingPostalCode ='95134';
            customerContact.MailingCountry = 'United States';
            insert customerContact;
            newOpportunity = TestUtils.createOpportunities(1, customerAccount.id, customerContact.Id, true).get(0); 
        //}  
  }
  
  
  private static testMethod void TestQuoteReadOnlyExtnsn(){
          init();
          
        //System.runAs(partnerPortalUser){   
            Id rdMaxFitRecordTypeId = Schema.SObjectType.Roof_Design__c.getRecordTypeInfosByName().get('Residential Actual Design').getRecordTypeId();
                
            Quote newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test ', newOpportunity.Id, false).get(0);
            newQuote.Account__c = customerAccount.Id;
            newQuote.Name = 'Test';
            newQuote.Sector__c = 'Residential';
            newQuote.QuoteType__c = 'Lease';
            newQuote.installDate__c = 'December 2017';
            newQuote.Description__c = 'dec Test';
            newQuote.Optional_Incentives__c = 'Use All';
            newQuote.Design_Factor__c = 'Automatic';


            newQuote.System_Cost__c =30000;
            newQuote.System_Price__c = 22000.00;
            newQuote.Modules_Per_String_Roof2__c = 8;
            newQuote.Total_Parallel_Strings_Roof2__c = 2;
            newQuote.Inverter_Quantity__c = 2;   
            newQuote.Inverter_Model__c = ic.Name;
            newQuote.Inverter_Manufacturer_Roof1__c = ic.Inverter_Manufacturer__c;
        
       
        newQuote.Modules_Per_String_Roof2__c = 8;
        newQuote.Total_Parallel_Strings_Roof2__c = 2;
        newQuote.Inverter_Model_2__c = ic.Name;
        newQuote.Inverter_Manufacturer_Roof2__c = ic.Inverter_Manufacturer__c;
        newQuote.Inverter_Quantity_2__c = 2;
        
        newQuote.Modules_Per_String_Roof3__c = 8;
        newQuote.Total_Parallel_Strings_Roof3__c = 2;
        newQuote.Inverter_Model_3__c = ic.Name;
        newQuote.Inverter_Manufacturer_Roof3__c = ic.Inverter_Manufacturer__c;
        newQuote.Inverter_Quantity_3__c = 2;
        
        newQuote.Modules_Per_String_Roof4__c = 8;
        newQuote.Total_Parallel_Strings_Roof4__c = 2;
        newQuote.Inverter_Model_4__c = ic.Name;
        newQuote.Inverter_Manufacturer_Roof4__c = ic.Inverter_Manufacturer__c;
        newQuote.Inverter_Quantity_4__c = 2;
        newQuote.Monitoring_System__c = 'PVS5 production Monitoring';
        newQuote.Mounting_Description__c = 'InvisiMount';
        newQuote.System_Model__c = mc.Name;
        newQuote.Customer_Electric_Utility__c = 'Pacific Gas and Electric Company (PG&E)';
        newQuote.Sector__c = 'New Homes';    
            Insert newQuote; 

            Electric_Rate_Usage_Input__c erui = new Electric_Rate_Usage_Input__c();
            erui.Annual_Bill__c = 22000.00;
            erui.Account__c = customerAccount.Id;
            erui.Quote__c = newQuote.Id;
            erui.Usage__c = 'AB';
            erui.Current_rate_code__c = '_NM_CA_PGE_E1_X_B';
            erui.Current_Rate__c = '_NM_CA_PGE_E1_X_B';
            erui.Proposed_rate_code__c = '_NM_CA_PGE_E1_X_B';
            insert erui;
             List<Electric_Rate_Usage_Input__c> electricListInput = new List<Electric_Rate_Usage_Input__c>();
             electricListInput.add(erui);
            Quote_Summary__c objQSummary = new Quote_Summary__c();
            objQSummary.Interconnection_Count__c = '0';
            objQSummary.Locked_Scenario__c = newQuote.Id;
            objQSummary.Account_Name__c = customerAccount.Id;
            objQSummary.Inv1_pvsim_no__c = '393';
            objQSummary.Inv2_pvsim_no__c = '393';
            objQSummary.Inv3_pvsim_no__c = '393';
            objQSummary.Inv4_pvsim_no__c = '393';
            objQSummary.modole_pvsim_no__c = '888';
            objQSummary.Module1_AC_rating__c = 0;
            objQSummary.Module2_AC_rating__c = 0;
            objQSummary.Module3_AC_rating__c = 0;    
            objQSummary.Module4_AC_rating__c = 0;
            objQSummary.Module1_DC_rating__c = 0;
            objQSummary.Module2_DC_rating__c = 0;
            objQSummary.Module3_DC_rating__c = 0;
            objQSummary.Module4_DC_rating__c = 0;
            objQSummary.Production_Monitoring_Kit__c = 766.46;
            objQSummary.Racking_Non_Smart_Amount__c = 38.87;
            objQSummary.System_Cost__c = 38830;

            Insert objQSummary; 
            
            Roof_Design__c rd = new Roof_Design__c(Account_Name__c=customerAccount.Id, Quote__c=newQuote.Id, Active__c=true, Status__c='Pending',RecordTypeId=rdMaxFitRecordTypeId,Origin__c='Self Service',Notes_for_Design_Team__c='notes');
            insert rd;
            
          List<Roof_Details__c> rfList = new List<Roof_Details__c>();
          for(integer i = 1; i < =4; i ++){
                Roof_Details__c rf = new Roof_Details__c();
                rf.Shading_Measurement_Date__c = date.today();
                rf.Jan__c = 95;rf.Feb__c = 95;rf.Mar__c = 95;rf.Apr__c = 95;rf.May__c = 95;rf.Jun__c = 95;rf.Jul__c = 95;rf.Aug__c = 95;rf.Sep__c = 95;rf.Oct__c = 95;rf.Nov__c = 95;rf.Dec__c = 95;
                rf.Direction__c = 180;
                rf.Account__c = customerAccount.Id;
                rf.Roof_Design__c = rd.Id;
                rf.Name = 'Roof '+i;
                rf.Pitch__c = '5:12(23)';    
                rfList.add(rf);
          }
          insert rfList; 

             //System Production Dummy data
        System_Production__c newSystemProd = new System_Production__c();
         newSystemProd.System_Size_DC__c = 5.232;
        newSystemProd.Total_Energy__c = 8284.271;
        newSystemProd.System_Size_AC__c = 4.6;
        newSystemProd.Upfront_Incentives__c = 852.5718;
        newSystemProd.Monthly_Lease_Payment__c =5120.0;
        newSystemProd.Upfront_Lease_Payment__c = 20.0;
        newSystemProd.Incentive_Design_Factor__c =   '92%';
        //newSystemProd.Monthly_Electric_Bill_saving_year1__c = 1254;
        newSystemProd.Monthly_Electric_Bill_Without_PV_year1__c =166.679166666666666666666666666667;
        newSystemProd.Monthly_Electric_Bill_With_PV_year1__c =   4.70916666666666666666666666666667;
        newSystemProd.Monthly_Electric_Bill_Without_PV_year5__c = 187.599166666666666666666666666667;
        newSystemProd.Monthly_Electric_Bill_With_PV_year5__c  =  7.11583333333333333333333333333333;
        newSystemProd.Quote__c  = newQuote.Id;
        Insert newSystemProd;

           
       PageReference p = Page.QuoteReadOnly;  
        Test.setCurrentPage(p); 
        System.currentPageReference().getParameters().put('qId', newQuote.id); 
        ApexPages.StandardController sc = new ApexPages.StandardController(newQuote);
        //newAccountPlan testAccPlan = new newAccountPlan(sc);
        QuoteReadOnlyExtension crtrl = new QuoteReadOnlyExtension(sc);
        //crtrl.populateRoofDetails();
        
       //}      
   } 
   
    private static testMethod void TestQuoteReadOnlyExtnsn2(){
          init();
          
        //System.runAs(partnerPortalUser){   
            Quote newQuote = TestUtils.createQuotes( 1, 'Quick Quote Test ', newOpportunity.Id, false).get(0);
            newQuote.Account__c = customerAccount.Id;
            newQuote.Name = 'Test';
            newQuote.Sector__c = 'Residential';
            newQuote.QuoteType__c = 'Lease';
            newQuote.installDate__c = 'December 2017';
            newQuote.Description__c = 'dec Test';
            newQuote.Optional_Incentives__c = 'Use All';
            newQuote.Design_Factor__c = 'Automatic';


            newQuote.System_Cost__c =30000;
            newQuote.System_Price__c = 22000.00;
            newQuote.Modules_Per_String_Roof2__c = 8;
            newQuote.Total_Parallel_Strings_Roof2__c = 2;
            newQuote.Inverter_Quantity__c = 2;   
            newQuote.Inverter_Model__c = ic.Name;
            newQuote.Inverter_Manufacturer_Roof1__c = ic.Inverter_Manufacturer__c;
        
       
        newQuote.Modules_Per_String_Roof2__c = 8;
        newQuote.Total_Parallel_Strings_Roof2__c = 2;
        newQuote.Inverter_Model_2__c = ic.Name;
        newQuote.Inverter_Manufacturer_Roof2__c = ic.Inverter_Manufacturer__c;
        newQuote.Inverter_Quantity_2__c = 2;
        
        newQuote.Modules_Per_String_Roof3__c = 8;
        newQuote.Total_Parallel_Strings_Roof3__c = 2;
        newQuote.Inverter_Model_3__c = ic.Name;
        newQuote.Inverter_Manufacturer_Roof3__c = ic.Inverter_Manufacturer__c;
        newQuote.Inverter_Quantity_3__c = 2;
        
        newQuote.Modules_Per_String_Roof4__c = 8;
        newQuote.Total_Parallel_Strings_Roof4__c = 2;
        newQuote.Inverter_Model_4__c = ic.Name;
        newQuote.Inverter_Manufacturer_Roof4__c = ic.Inverter_Manufacturer__c;
        newQuote.Inverter_Quantity_4__c = 2;
        newQuote.Monitoring_System__c = 'PVS5 production Monitoring';
        newQuote.Mounting_Description__c = 'InvisiMount';
        newQuote.System_Model__c = mc.Name;
        newQuote.Customer_Electric_Utility__c = 'Pacific Gas and Electric Company (PG&E)';
        newQuote.Sector__c = 'New Homes';    
            Insert newQuote; 

            Electric_Rate_Usage_Input__c erui = new Electric_Rate_Usage_Input__c();
            erui.Annual_Bill__c = 22000.00;
            erui.Account__c = customerAccount.Id;
            erui.Quote__c = newQuote.Id;
            erui.Usage__c = 'AB';
            erui.Current_rate_code__c = '_NM_CA_PGE_E1_X_B';
            erui.Current_Rate__c = '_NM_CA_PGE_E1_X_B';
            erui.Proposed_rate_code__c = '_NM_CA_PGE_E1_X_B';
            insert erui;
             List<Electric_Rate_Usage_Input__c> electricListInput = new List<Electric_Rate_Usage_Input__c>();
             electricListInput.add(erui);
            Quote_Summary__c objQSummary = new Quote_Summary__c();
            objQSummary.Interconnection_Count__c = '0';
            objQSummary.Locked_Scenario__c = newQuote.Id;
            objQSummary.Account_Name__c = customerAccount.Id;
            objQSummary.Inv1_pvsim_no__c = '393';
            objQSummary.Inv2_pvsim_no__c = '393';
            objQSummary.Inv3_pvsim_no__c = '393';
            objQSummary.Inv4_pvsim_no__c = '393';
            objQSummary.modole_pvsim_no__c = '888';
            objQSummary.Module1_AC_rating__c = 0;
            objQSummary.Module2_AC_rating__c = 0;
            objQSummary.Module3_AC_rating__c = 0;    
            objQSummary.Module4_AC_rating__c = 0;
            objQSummary.Module1_DC_rating__c = 0;
            objQSummary.Module2_DC_rating__c = 0;
            objQSummary.Module3_DC_rating__c = 0;
            objQSummary.Module4_DC_rating__c = 0;
            objQSummary.Production_Monitoring_Kit__c = 766.46;
            objQSummary.Racking_Non_Smart_Amount__c = 38.87;
            objQSummary.System_Cost__c = 38830;

            Insert objQSummary; 
            
            
          List<Roof_Details__c> rfList = new List<Roof_Details__c>();
          for(integer i = 1; i < =4; i ++){
                Roof_Details__c rf = new Roof_Details__c();
                rf.Shading_Measurement_Date__c = date.today();
                rf.Jan__c = 95;rf.Feb__c = 95;rf.Mar__c = 95;rf.Apr__c = 95;rf.May__c = 95;rf.Jun__c = 95;rf.Jul__c = 95;rf.Aug__c = 95;rf.Sep__c = 95;rf.Oct__c = 95;rf.Nov__c = 95;rf.Dec__c = 95;
                rf.Direction__c = 180;
                rf.Account__c = customerAccount.Id;
                rf.Name = 'Roof '+i;
                rf.Pitch__c = '5:12(23)';    
                rfList.add(rf);
          }
          insert rfList; 

             //System Production Dummy data
        System_Production__c newSystemProd = new System_Production__c();
         newSystemProd.System_Size_DC__c = 5.232;
        newSystemProd.Total_Energy__c = 8284.271;
        newSystemProd.System_Size_AC__c = 4.6;
        newSystemProd.Upfront_Incentives__c = 852.5718;
        newSystemProd.Monthly_Lease_Payment__c =5120.0;
        newSystemProd.Upfront_Lease_Payment__c = 20.0;
        newSystemProd.Incentive_Design_Factor__c =   '92%';
        //newSystemProd.Monthly_Electric_Bill_saving_year1__c = 1254;
        newSystemProd.Monthly_Electric_Bill_Without_PV_year1__c =166.679166666666666666666666666667;
        newSystemProd.Monthly_Electric_Bill_With_PV_year1__c =   4.70916666666666666666666666666667;
        newSystemProd.Monthly_Electric_Bill_Without_PV_year5__c = 187.599166666666666666666666666667;
        newSystemProd.Monthly_Electric_Bill_With_PV_year5__c  =  7.11583333333333333333333333333333;
        newSystemProd.Quote__c  = newQuote.Id;
        Insert newSystemProd;

           
       PageReference p = Page.QuoteReadOnly;  
        Test.setCurrentPage(p); 
        System.currentPageReference().getParameters().put('qId', newQuote.id); 
        ApexPages.StandardController sc = new ApexPages.StandardController(newQuote);
        //newAccountPlan testAccPlan = new newAccountPlan(sc);
        QuoteReadOnlyExtension crtrl = new QuoteReadOnlyExtension(sc);
        //crtrl.populateRoofDetails();
        
       //}      
   }
  
  
}