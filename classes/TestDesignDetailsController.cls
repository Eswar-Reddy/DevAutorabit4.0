@isTest
public class TestDesignDetailsController {
    
    @testSetup
    public static void createRoofDesignTestData(){
        Account customerAccount = TestUtils.createAccount( 'CustomerAcct', TestUtils.getResidentialRecordTypeId(), false );
        customerAccount.BillingState = 'CA';
        customerAccount.BillingCountry= 'United States';
        insert customerAccount;
        
        Id rdMaxFitRecordTypeId = Schema.SObjectType.Roof_Design__c.getRecordTypeInfosByName().get('Residential MaxFit Designs').getRecordTypeId();
        Roof_Design__c roofDesign = TestUtils.createRoofDesign(customerAccount.Id, rdMaxFitRecordTypeId, 'Request', 'Pending',true);
        
        //Create test data for Module Config data model
        List<Item__c> itemList = new List<Item__c>();
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
        
        
        insert itemList; 
        
        Module_Configuration__c mc = new Module_Configuration__c(Name = '327W (Model SPR-327NE-WHT-D)',Current_Type__c = 'AC',Item__c = itemList.get(0).id);
        insert mc;
        
        Monitoring_Configuration__c mConfig = new Monitoring_Configuration__c(Name = 'PVS5 Production Monitoring');
        insert mConfig;
        
        Inverter_Configuration__c ic = new Inverter_Configuration__c(Name = '7.7 kW (Model SUNNY BOY 7700TL-US-22 - 240v (SPR-7702m))',Item__c = itemList.get(1).id,Monitoring__c = mConfig.Id,Inverter_Manufacturer__c = 'Sunpower',Start_Date__c = Date.today(),End_Date__c = Date.valueOf('2099-12-10'));
        insert ic;
        
        ModuleInverterJunction__c mij = new ModuleInverterJunction__c(Module_Configuration__c = mc.Id,Inverter_Configuration__c = ic.id);
        insert mij;
        
        InverterList__c invl1 = new InverterList__c ( InverterConfiguration__c = ic.Id,RoofDesign__c =roofDesign.Id);
        insert invl1;
        
        //-------------------------------------Insert Roof Details------------------------------------------//
        List<Roof_Details__c> rDetList = new List<Roof_Details__c>();
        Roof_Details__c rd1 = new Roof_Details__c(Name='RoofDetail1',Account__c =customerAccount.Id,Direction__c=272,
                                                  Pitch__c = '19',Jan__c = 90,Feb__c = 86,Mar__c = 90,Apr__c = 95,
                                                  May__c = 98, Jun__c = 99,Jul__c = 99,Aug__c = 97,Sep__c = 92,Oct__c = 88,
                                                  Nov__c = 89, Dec__c = 90,Roof_Design__c=roofDesign.Id);
        rDetList.add(rd1);
        
        Roof_Details__c rd2 = new Roof_Details__c(Name='RoofDetail2',Account__c =customerAccount.Id,Direction__c=272,
                                                  Pitch__c = '19',Jan__c = 90,Feb__c = 86,Mar__c = 90,Apr__c = 95,
                                                  May__c = 98, Jun__c = 99,Jul__c = 99,Aug__c = 97,Sep__c = 92,Oct__c = 88,
                                                  Nov__c = 89, Dec__c = 90,Roof_Design__c=roofDesign.Id);
        rDetList.add(rd2);
        
        insert rDetList;
        //--------------------------------------------------------------------------------------------------//
        
        EnergyProductionYr1__c  enerProdYr1 = new EnergyProductionYr1__c(Annual__c = 6242.8193,Jan__c = 354.9504,
                                                                         Feb__c = 392.1330, Mar__c = 522.0798, 
                                                                         Apr__c = 576.4236, May__c = 607.9115,
                                                                         Jun__c = 611.1107,Jul__c = 661.7857, 
                                                                         Aug__c = 650.1409, Sep__c = 593.9228,
                                                                         Oct__c = 507.7103,Nov__c = 387.5127,
                                                                         Dec__c = 377.1380, RoofDesign__c = roofDesign.Id);
        insert enerProdYr1;
        
        
        //-------------------------------------Insert Roof Detail Inverter Junctions------------------------//
        List<RoofDetailInverterJunction__c> rdInvList = new List<RoofDetailInverterJunction__c>();
        RoofDetailInverterJunction__c rdinvjun1 = new RoofDetailInverterJunction__c(Inverter_List__c = invl1.Id, Roof_Detail__c = rDetList[0].Id);
        rdInvList.add(rdinvjun1);
        
        RoofDetailInverterJunction__c rdinvjun2 = new RoofDetailInverterJunction__c(Inverter_List__c = invl1.Id, Roof_Detail__c = rDetList[1].Id);
        rdInvList.add(rdinvjun2);
        
        insert rdInvList;
        //--------------------------------------------------------------------------------------------------//
        
        Roof_Detail_Item__c rdItem = new Roof_Detail_Item__c(RoofDetails__c = rDetList[0].Id, Module__c = mc.Id, Quantity__c = 6.00);
        insert rdItem;
    }
    
    public static testMethod void testDesignDetails1(){
        Roof_Design__c rfDesign = [select Id from Roof_Design__c limit 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(rfDesign);
        Test.setCurrentPageReference(Page.DesignDetails);
        DesignDetailsController ddCtrl = new DesignDetailsController(sc);
    }
}