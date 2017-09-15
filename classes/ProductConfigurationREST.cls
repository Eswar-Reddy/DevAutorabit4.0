/**
 * Created by cdevarapalli on 2/16/17.
 * REST API Class to get all the Product Configuration for the given Master Ids
 */
@RestResource(urlMapping='/getProductConfiguration/*')
global without sharing class ProductConfigurationREST {

    //Constants
    private final static Date todayDate = Date.Today();

    @HttpPost
    global static Response doPost(List<Id> masterIds){
        Response resp = new Response();
        resp.receivedMasterIds = String.valueOf(masterIds);
        Set<Id> allModuleInverterJunctionIds = new Set<Id>();
        Set<Id> allModuleRackingJunctionIds = new Set<Id>();
        Set<id> allItemIdsSet = new Set<Id>();
        Set<Id> allInverterConfigIds = new Set<Id>();
        Set<Id> allMonitoringConfigIds = new Set<id>();
        Set<Id> allRackingConfigIds = new Set<Id>();


        Set<Id> masterIdsSet = new Set<Id>();
        masterIdsSet.addAll(masterIds);

        Map<Id,Master_Configurator__c> master_configuratorMap = new Map<Id,Master_Configurator__c>([SELECT Name,
                (Select Id, Name, Inverter__c, Master_Configuration__c, ModuleInverterJunction__c, Module__c
                    From MasterModuleInverterJunctions__r where
                ModuleInverterJunction__r.Inverter_Configuration__r.Start_Date__c <=: todayDate AND
                ModuleInverterJunction__r.Inverter_Configuration__r.End_Date__c >=: todayDate),
                (Select Id, Name, Master_Configurator__c, ModuleRackingJunction__c, Module__c, Racking__c
                    From MasterModuleRacking_Junctions__r),
                (Select Id, Name, Item__c, Master_Configurator__c
                    From MiscellaneousItemJunctions__r)
            From Master_Configurator__c where Id in :masterIdsSet]);

        for(Master_Configurator__c mc : master_configuratorMap.values()){
            for(MasterModuleInverterJunction__c mmij : mc.MasterModuleInverterJunctions__r){
                if(mmij.ModuleInverterJunction__c != null)
                    allModuleInverterJunctionIds.add(mmij.ModuleInverterJunction__c);
            }
            for(MasterModuleRacking_Junction__c mmrj : mc.MasterModuleRacking_Junctions__r ){
                if(mmrj.ModuleRackingJunction__c != null)
                    allModuleRackingJunctionIds.add(mmrj.ModuleRackingJunction__c);
            }
            for(MasterItemMiscJunction__c mimj : mc.MiscellaneousItemJunctions__r){
                if(mimj.Item__c != null)
                    allItemIdsSet.add(mimj.Item__c);
            }
        }

        System.debug('allModuleInverterJunctionIds Size ----->'+allModuleInverterJunctionIds.size());
        System.debug('allModuleInverterJunctionIds----->'+allModuleInverterJunctionIds);

        System.debug('allModuleRackingJunctionIds Size ----->'+allModuleRackingJunctionIds.size());
        System.debug('allModuleRackingJunctionIds----->'+allModuleRackingJunctionIds);

        System.debug('allItemIdsSet Size ----->'+allItemIdsSet.size());
        System.debug('allItemIdsSet----->'+allItemIdsSet);

        resp.masterConfigurators = master_configuratorMap.values();

        if(!allModuleInverterJunctionIds.isEmpty())
            resp.moduleInverterJunctions = [
                    SELECT
                            Id,
                            Name,
                            Inverter_Configuration__c,
                            Inverter_Name__c,
                            Module_Configuration__c,
                            Module_Name__c,
                            Inverter_Configuration__r.Monitoring__c,
                            Inverter_Configuration__r.Monitoring__r.Name
                    FROM ModuleInverterJunction__c where Id in :allModuleInverterJunctionIds
                    AND Inverter_Configuration__r.Start_Date__c <=: todayDate
                    AND Inverter_Configuration__r.End_Date__c >=: todayDate];

        for(ModuleInverterJunction__c mij : resp.moduleInverterJunctions){
            if(mij.Inverter_Configuration__c != null){
                allInverterConfigIds.add(mij.Inverter_Configuration__c);
                if(mij.Inverter_Configuration__r.Monitoring__c!=null)
                    allMonitoringConfigIds.add(mij.Inverter_Configuration__r.Monitoring__c);
            }
        }


        System.debug('allInverterConfigIds size----->'+allInverterConfigIds.size());
        System.debug('allInverterConfigIds----->'+allInverterConfigIds);


        System.debug('allMonitoringConfigIds size----->'+allMonitoringConfigIds.size());
        System.debug('allMonitoringConfigIds----->'+allMonitoringConfigIds);

        if(!allModuleRackingJunctionIds.isEmpty())
            resp.moduleRackingJunctions = [
                    SELECT
                            Id,
                            Name,
                            Module_Configuration__c,
                            Module_Name__c,
                            Racking_Configuration__c,
                            Racking_Name__c
                    FROM ModuleRackingJunction__c where Id in :allModuleRackingJunctionIds];

        for(ModuleRackingJunction__c mrj: resp.moduleRackingJunctions){
            if(mrj.Racking_Configuration__c!=null)
                allRackingConfigIds.add(mrj.Racking_Configuration__c);
        }

        //Query for List of Inverter Configurations
        if(!allInverterConfigIds.isEmpty())
            resp.inverterConfigurations = [
                    SELECT
                            Id,
                            Name,
                            End_Date__c,
                            Inverter_Manufacturer__c,
                            Item__c,
                            Monitoring__c,
                            On_Board_Monitoring__c,
                            Start_Date__c,
                            Storage_Ready_Inverter__c
                    FROM Inverter_Configuration__c where Id in :allInverterConfigIds
                    AND Start_Date__c <=: todayDate AND End_Date__c >=: todayDate];

        System.debug('resp.inverterConfigurations size----->'+resp.inverterConfigurations.size());

        if(!allRackingConfigIds.isEmpty()){
            //Query for List of Racking Configurations
            resp.rackingConfigurations = [
                    SELECT
                            Id,
                            Name,
                            Kit_Size__c,
                            Type__c,
                            Usage__c
                    FROM Racking_Configuration__c where Id in :allRackingConfigIds ];

            //Query for List of Racking Junctions
            resp.rackingItemJunctions = [
                    SELECT
                            Id,
                            Item__c,
                            Name,
                            Quantity__c,
                            Racking_Configuration__c
                    FROM Racking_Item_Junction__c where Racking_Configuration__c in :allRackingConfigIds ];
        }

        System.debug('resp.rackingConfigurations size----->'+resp.rackingConfigurations.size());
        System.debug('resp.rackingItemJunctions size----->'+resp.rackingItemJunctions.size());

        if(!allMonitoringConfigIds.isEmpty()){
            //Query for List of Monitoring Configurations
            resp.monitoringConfigurations = [
                    SELECT
                            Id,
                            Name
                    FROM Monitoring_Configuration__c where Id in :allMonitoringConfigIds ];

            //Query for List of Monitoring Junctions
            resp.monitoringItemJunctions = [
                    SELECT
                            Id,
                            Item__c,
                            Monitoring_Configuration__c,
                            Name,
                            Type__c
                    FROM Monitoring_Item_junction__c where Monitoring_Configuration__c in :allMonitoringConfigIds ];

        }

        System.debug('resp.monitoringConfigurations size----->'+resp.monitoringConfigurations.size());
        System.debug('resp.monitoringItemJunctions size----->'+resp.monitoringItemJunctions.size());

        //Items from Inverter Configurations
        for(Inverter_Configuration__c ic : resp.inverterConfigurations){
            if(ic.Item__c!=null)
                allItemIdsSet.add(ic.Item__c);
        }

        //Items from Racking Item Junctions
        for(Racking_Item_Junction__c rij: resp.rackingItemJunctions){
            if(rij.Item__c!=null)
                allItemIdsSet.add(rij.Item__c);
        }

        //Items from Monitoring Item Junctions
        for(Monitoring_Item_junction__c mij: resp.monitoringItemJunctions){
            if(mij.Item__c!=null){
                allItemIdsSet.add(mij.Item__c);
            }
        }

        System.debug('allItemIdsSet size----->'+allItemIdsSet.size());
        System.debug('allItemIdsSet ----->'+allItemIdsSet);

        //Query for List of Items
        if(!allItemIdsSet.isEmpty())
            resp.items = [
                    SELECT
                            Active__c,
                            CEC_PTC_Rating__c,
                            Description__c,
                            Disconnect_Item_Id__c,
                            Display_Name__c,
                            Display_Order__c,
                            Ext_Id__c,
                            Id,
                            Inverter_Oracle_ID__c,
                            Item_Category_1__c,
                            Item_Category_2__c,
                            Item_Category_3__c,
                            Item_ID__c,
                            Line_Type__c,
                            Long_Description__c,
                            Manufacturing_Cost__c,
                            Model__c,
                            Module_Width__c,
                            Monitoring_Oracle_ID__c,
                            Name,
                            Not_Shippable__c,
                            OraclePVSimId__c,
                            Product_Family__c,
                            Product_Line__c,
                            Product_Type__c,
                            PV_Cell_Count__c,
                            PV_SIM_no__c,
                            Show_In_Dynamic_Proposal__c,
                            Status__c,
                            Summary_Description__c,
                            Tag_Line__c
                    FROM Item__c where Id in :allItemIdsSet ];

        System.debug('resp----->'+resp);
        resp.success = true;
        return resp;
    }

    global class Response {
        Boolean success = false;
        String receivedMasterIds = null;
        List<Master_Configurator__c> masterConfigurators = new List<Master_Configurator__c>();
        List<ModuleInverterJunction__c> moduleInverterJunctions = new  List<ModuleInverterJunction__c>();
        List<ModuleRackingJunction__c> moduleRackingJunctions = new List<ModuleRackingJunction__c>();
        List<Inverter_Configuration__c> inverterConfigurations = new List<Inverter_Configuration__c>();
        List<Racking_Configuration__c> rackingConfigurations = new List<Racking_Configuration__c>();
        List<Monitoring_Configuration__c> monitoringConfigurations = new List<Monitoring_Configuration__c>();
        List<Racking_Item_Junction__c> rackingItemJunctions = new List<Racking_Item_Junction__c>();
        List<Monitoring_Item_junction__c> monitoringItemJunctions = new List<Monitoring_Item_junction__c>();
        List<Item__c> items = new List<Item__c>();
    }

}