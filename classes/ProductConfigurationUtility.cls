/**
 * ProductConfigurationUtility
 * Used across classes to retrieve product configuration data for ordering/quoting 
 * This class is only used for configuration specific logic across all regions
 * Please put and non-general or specific logic in you respective classes/controllers 
 * This is a shared resource!
 * 
 * @Author Crystal - RedPoint 
 * @version 1.0
 * @since 2016-05-06
 * 
 * Modification History:
 * PT #115634041 - SolarEdge inverter availability - Hawaii 6/17/2016
 * PT #124934431, #123866151 - Remove Monitoring Opt Out for AC & SolarEdge - 07/10/2016
 * #131120319 - Racking calculation logic cash ordering controller - 10/27/16
 * 
 */


public without sharing class ProductConfigurationUtility {
    

    //Constants
    private final static Date todayDate = Date.Today();
    private final static String equinox = 'Equinox';


    //Constructor
    public ProductConfigurationUtility() { }

    /* OVERLOAD 1 - ALL PARAMS
    *  fetchMasterIDs
    *  returns a set of Master Configurator Ids based on specific set of arguements specified below
    * DOES NOT RETURN EQUINOX CONFIGURATIONS - please use equinox specific method below 
    * @params:
    * state: the shipping state of the end customer
    * opUnit: the operating unit of the ordering partner account
    * financialOffering: What type of offering the config is for (Cash, Lease, Loan) 
    * salesMethod: How you are selling the config (Quote, Order)
    * sector: The business sector in which the config is being sold (Residential, Commercial, New Homes)
    * channel: Sales channel (Direct, Indirect, TPS)
    * partnerId: The dealer partner Id, used to determine pilot/limited authorized sales objects (aka Powerwall, CVPP, etc.)
    * 
    * Calling Classes/Methods: OrderAppController;
    * 
    * TODO: 
    * 
    */

    public static Set<Id> fetchMasterIds(String state, String opUnit, String financialOffering, String salesMethod, String sector, String channel, String partnerId) {

      Set<Id> masterIds = new Set<Id>();
      Set<Id> partnerNullMasterIds = new Set<Id>();
      Set<Id> partnerMasterIds = new Set<Id>();
      if(String.isBlank(state) || String.isBlank(opUnit) || String.isBlank(financialOffering) 
          || String.isBlank(salesMethod) || String.isBlank(sector) || String.isBlank(channel))
              return masterIds;

      for(SalesConfiguration__c salesConfig : [SELECT Configurator__c, Partner__c
                                               FROM SalesConfiguration__c
                                               WHERE Active__c = TRUE
                                               AND Configurator__c != null
                                               AND Configurator__r.Configuration_Model__c !=: equinox                                                      
                                               AND ((Operating_Unit__c =: opUnit
                                                     AND State__c =: state 
                                                     AND Financial_Offering__c =: financialOffering
                                                     AND SalesMethodology__c =: salesMethod
                                                     AND Sector__c =: sector
                                                     AND Channel__c =: channel)
                                                     AND (Partner__c=null OR (Partner__c != null
                                                     AND Partner__c =: partnerId)))
                                              ]) {
             if(salesConfig.Partner__c==null)
                  partnerNullMasterIds.add(salesConfig.Configurator__c);                                   
             else
                 partnerMasterIds.add(salesConfig.Configurator__c);
      }
  
      if(!partnerMasterIds.isEmpty())
          masterIds.addAll(partnerMasterIds);
      else
          masterIds.addAll(partnerNullMasterIds);
      return masterIds;
    }

    /*
    *  fetchEquinoxMasterIDs
    *  returns a set of Master Configurator Ids based on specific set of arguements specified below
    * ONLY RETURNS EQUINOX CONFIGURATIONS   
    * @params:
    * state: the shipping state of the end customer
    * opUnit: the operating unit of the ordering partner
    * financialOffering: What type of offering the config is for (Cash, Lease, Loan) 
    * salesMethod: How you are selling the config (Quote, Order)
    * sector: The business sector in which the config is being sold (Residential, Commercial, New Homes)
    * channel: Sales channel (Direct, Indirect, TPS)
    * partnerId: The dealer partner Id, used to determine pilot/limited authorized sales objects (aka Powerwall, CVPP, etc.)
    * 
    * Calling Classes/Methods: OrderAppController;
    * 
    * TODO: 
    * 
    */

    public static Set<Id> fetchEquinoxMasterIDs(String state, String opUnit, String financialOffering, String salesMethod, String sector, String channel, String partnerId) {

        Set<Id> masterIds = new Set<Id>();
        if(String.isBlank(state) || String.isBlank(opUnit) || String.isBlank(financialOffering) 
            || String.isBlank(salesMethod) || String.isBlank(sector) || String.isBlank(channel))
                return masterIds;

        for(SalesConfiguration__c salesConfig : [SELECT Configurator__c, Partner__c
                                                 FROM SalesConfiguration__c
                                                 WHERE Active__c = TRUE
                                                 AND Configurator__c != null
                                                 AND Configurator__r.Configuration_Model__c =: equinox                                                      
                                                 AND ((Operating_Unit__c =: opUnit
                                                       AND State__c =: state 
                                                       AND Financial_Offering__c =: financialOffering
                                                       AND SalesMethodology__c =: salesMethod
                                                       AND Sector__c =: sector
                                                       AND Channel__c =: channel)
                                                     OR (Partner__c != null
                                                       AND Partner__c =: partnerId))
                                                ]) {
            masterIds.add(salesConfig.Configurator__c);
        }
        return masterIds;
    }

    /*
    * fetchModules
    * This method returns a Map<Id, Module_Configuration__c>  
    * In this map are Modules and related Item information
    * @params: Set<ID> of Master_Configuration__c records for the selling configuration
    * 
    * Calling Classes/Methods: OrderAppUtility;
    *
    * TODO: 
    */
    public static Map<Id, Module_Configuration__c> fetchModules(Set<Id> masterIDs) {
        Map<Id, Module_Configuration__c> moduleMap = new Map<Id, Module_Configuration__c>();

        if(masterIds == null || masterIds.isEmpty())
            return moduleMap;

        Set<Id> junctionIds = new Set<Id>();

        for(ModuleInverterJunction__c m : [SELECT Module_Configuration__c, Module_Configuration__r.Name, Module_Configuration__r.Item__c,
                                                  Module_Configuration__r.Item__r.Item_ID__c, Module_Configuration__r.Current_Type__c,
                                                  Module_Configuration__r.Item__r.Item_Category_3__c,
                                                  Module_Configuration__r.Item__r.Module_Width__c,
                                                  Module_Configuration__r.Item__r.PV_Cell_Count__c
                                                  FROM ModuleInverterJunction__c
                                                  WHERE ID IN (SELECT ModuleInverterJunction__c
                                                         FROM MasterModuleInverterJunction__c
                                                         WHERE Master_Configuration__c IN: masterIds)
                                                  Order By Module_Configuration__r.Current_Type__c ASC,
                                                           Module_Configuration__r.Item__r.Item_Category_3__c ASC]) {
            moduleMap.put(m.Module_Configuration__c, m.Module_Configuration__r);
        }

        return moduleMap;
    }

    /*
    * fetchModuleIdToMasterId
    * This method returns a Map<Id, Id>  [ModuleId, MasterId]
    * @params: Set<ID> of Master_Configuration__c records for the selling configuration
    * 
    * Calling Classes/Methods: QuickquoteCTRL;
    *
    * TODO: 
    */
    public static Map<Id, Id> fetchModuleIdToMasterId(Set<Id> masterIDs) {
        Map<Id, Id> mapModuleIdToMasterId = new Map<Id, Id>();

        if(masterIds == null || masterIds.isEmpty())
            return mapModuleIdToMasterId;

        Set<Id> junctionIds = new Set<Id>();

        for(MasterModuleInverterJunction__c m : [SELECT Master_Configuration__c, ModuleInverterJunction__r.Module_Configuration__c
                                                         FROM MasterModuleInverterJunction__c
                                                         WHERE Master_Configuration__c IN: masterIds
                                                         Order By ModuleInverterJunction__r.Module_Configuration__c]) {
            mapModuleIdToMasterId.put(m.ModuleInverterJunction__r.Module_Configuration__c, m.Master_Configuration__c);
        }

        return mapModuleIdToMasterId;
    }

    /*
    * fetchAllInverters
    * This method returns a Map<Id, Inverter_Configuration__c>
    * @params: Set<ID> of Master_Configuration__c records for the selling configuration
    * 
    * Calling Classes/Methods: OrderAppUtility;
    *
    * TODO: 
    *
    */

    public static Map<Id, Inverter_Configuration__c> fetchAllInverters(Set<Id> masterIds) {

        Map<Id, Inverter_Configuration__c> invertersMap = new Map<Id, Inverter_Configuration__c>(); 

        if(masterIds == null || masterIds.isEmpty())
            return invertersMap;

        for(ModuleInverterJunction__c i : [SELECT Id, Inverter_Configuration__c, Inverter_Configuration__r.Name, 
                                                  Inverter_Configuration__r.Storage_Ready_Inverter__c,
                                                  Inverter_Configuration__r.On_Board_Monitoring__c, 
                                                  Inverter_Configuration__r.Item__c, Module_Configuration__c,
                                                  Inverter_Configuration__r.Inverter_Manufacturer__c, Inverter_Configuration__r.Item__r.Item_ID__c,
                                                  Inverter_Configuration__r.Item__r.Description__c, Inverter_Configuration__r.Item__r.Item_Category_3__c
                                           FROM ModuleInverterJunction__c
                                           WHERE ID IN (SELECT ModuleInverterJunction__c
                                                    FROM MasterModuleInverterJunction__c
                                                    WHERE Master_Configuration__c IN: masterIds)
                                           AND Inverter_Configuration__c != null
                                           AND Inverter_Configuration__r.Start_Date__c <=: todayDate
                                           AND Inverter_Configuration__r.End_Date__c >=: todayDate
                                           AND Inverter_Configuration__r.Inverter_Manufacturer__c != null
                                           Order By Inverter_Configuration__r.Item__r.Item_Category_3__c ASC]) {
            invertersMap.put(i.Inverter_Configuration__c, i.Inverter_Configuration__r);
        }
        
        return invertersMap;
    }

    /*
    * fetchInvertersByModule
    * This method returns a Map<Id, Inverter_Configuration__c>
    * In the map are all the available Inverters and their Item specific information
    * @params: Id of a specific Module Configuration
    * 
    * Calling Classes/Methods: OrderAppUtility;
    *
    * TODO: 
    *
    */

    public static Map<Id, Inverter_Configuration__c> fetchInvertersByModule(Id moduleId, Set<Id> masterIds) {
        
        Map<Id, Inverter_Configuration__c> invertersMap = new Map<Id, Inverter_Configuration__c>(); 

        if(String.isBlank(moduleId))
            return invertersMap;

        for(ModuleInverterJunction__c i : [SELECT Id, Module_Configuration__c, Inverter_Configuration__c, Inverter_Configuration__r.Name, 
                                                  Inverter_Configuration__r.Storage_Ready_Inverter__c,
                                                  Inverter_Configuration__r.On_Board_Monitoring__c, 
                                                  Inverter_Configuration__r.Item__c, Inverter_Configuration__r.Monitoring__c,
                                                  Inverter_Configuration__r.Inverter_Manufacturer__c, Inverter_Configuration__r.Item__r.Item_ID__c,
                                                  Inverter_Configuration__r.Item__r.Description__c, Inverter_Configuration__r.Item__r.Item_Category_3__c
                                           FROM ModuleInverterJunction__c
                                           WHERE Module_Configuration__c =: moduleId
                                           AND ID IN (SELECT ModuleInverterJunction__c
                                                    FROM MasterModuleInverterJunction__c
                                                    WHERE Master_Configuration__c IN: masterIds)
                                           AND Inverter_Configuration__c != null
                                           AND Inverter_Configuration__r.Start_Date__c <=: todayDate
                                           AND Inverter_Configuration__r.End_Date__c >=: todayDate
                                           AND Inverter_Configuration__r.Inverter_Manufacturer__c != null
                                           Order By Inverter_Configuration__r.Item__r.Item_Category_3__c ASC]) {
            invertersMap.put(i.Inverter_Configuration__c, i.Inverter_Configuration__r);
        }
        
        return invertersMap;
    }

    /*
    * fetchInvertersGroupedByModule
    * This method returns a Map<Id, Inverter_Configuration__c>
    * In the map are all the available Inverters and their Item specific information
    * @params: Id of a specific Module Configuration
    * 
    * Calling Classes/Methods: OrderAppUtility;
    *
    * TODO: 
    *
    */

    public static Map<Id, Map<Id, Inverter_Configuration__c>> fetchInvertersGroupedByModule(Set<Id> moduleIds, Set<Id> masterIds) {
        
        Map<Id, Map<Id, Inverter_Configuration__c>> modInvertersMap = new Map<Id, Map<Id, Inverter_Configuration__c>>(); 

        if(moduleIds == null || moduleIds.isEmpty())
            return modInvertersMap;

        for(Id i : moduleIds) {
            modInvertersMap.put(i, new Map<Id, Inverter_Configuration__c>());
        }

        for(ModuleInverterJunction__c junction : [SELECT Id, Inverter_Configuration__c, Inverter_Configuration__r.Item__c, Module_Configuration__c,
                                                         Inverter_Configuration__r.Name, Inverter_Configuration__r.Storage_Ready_Inverter__c, 
                                                         Inverter_Configuration__r.On_Board_Monitoring__c,  
                                                         Inverter_Configuration__r.Monitoring__c, Inverter_Configuration__r.Inverter_Manufacturer__c,
                                                         Inverter_Configuration__r.Item__r.Item_ID__c, Inverter_Configuration__r.Item__r.Description__c, 
                                                         Inverter_Configuration__r.Item__r.Item_Category_3__c
                                                  FROM ModuleInverterJunction__c
                                                  WHERE Module_Configuration__c IN: moduleIds
                                                  AND ID IN (SELECT ModuleInverterJunction__c
                                                         FROM MasterModuleInverterJunction__c
                                                         WHERE Master_Configuration__c IN: masterIds)
                                                  AND Inverter_Configuration__c != null
                                                  AND Inverter_Configuration__r.Start_Date__c <=: todayDate
                                                  AND Inverter_Configuration__r.End_Date__c >=: todayDate
                                                  AND Inverter_Configuration__r.Inverter_Manufacturer__c != null
                                                  Order By Inverter_Configuration__r.Item__r.Item_Category_3__c ASC]) {
            modInvertersMap.get(junction.Module_Configuration__c).put(junction.Inverter_Configuration__c, junction.Inverter_Configuration__r);
        }
        
        return modInvertersMap;
    }

    /*
    * fetchMonitoringByInverter
    * This method returns a Map<Id, Monitoring_Configuration__c>
    * In the map are all the available Monitoring Items for a specific Inverter 
    * and their Item specific information retrievable via Monitoring_Item_Junction__c junction object
    * @params: Id of a specific Inverter Configuration (Monitoring__c of inverter_configuration__c record)
    * 
    * Calling Classes/Methods: OrderAppUtility;
    *
    * TODO: 
    *
    */
    public static Map<Id, Monitoring_Configuration__c> fetchMonitoringByInverter(Id monitoringId) {

        Map<Id, Monitoring_Configuration__c> monitoringMap = new Map<Id, Monitoring_Configuration__c>();

        if(String.isBlank(monitoringId))
            return monitoringMap;

        for(Monitoring_Configuration__c monitoring : [SELECT Id, (Select Id, Item__c, Item__r.Item_Id__c 
                                                                  FROM Monitoring_Item_Junction__r) 
                                                      FROM Monitoring_Configuration__c 
                                                      WHERE Id =: monitoringId]) {
            monitoringMap.put(monitoring.Id, monitoring);
        }

        return monitoringMap;
    }

    /*
    * fetchMonitoringByInverterList
    * This method returns a Map<Id, Monitoring_Configuration__c>
    * In the map are all the available Monitoring Items for a set of Inverter Ids 
    * and their Item specific information retrievable via Monitoring_Item_Junction__c junction object
    * @params: Ids of a Monitoring Configurations (Monitoring__c of inverter_configuration__c record)
    * 
    * Calling Classes/Methods: OrderAppUtility;
    *
    *
    */
    public static Map<Id, Monitoring_Configuration__c> fetchMonitoringByInverterList(Set<Id> monitoringIds) {

        Map<Id, Monitoring_Configuration__c> monitoringMap = new Map<Id, Monitoring_Configuration__c>();

        if(monitoringIds == null || monitoringIds.isEmpty())
            return monitoringMap;

        for(Monitoring_Configuration__c monitoring : [SELECT Id, Name, (Select Id, Item__c, Item__r.Item_Id__c 
                                                                  FROM Monitoring_Item_Junction__r) 
                                                      FROM Monitoring_Configuration__c 
                                                      WHERE Id IN: monitoringIds]) {
            monitoringMap.put(monitoring.Id, monitoring);
        }

        return monitoringMap;
    }

    /*
    * fetchRackingByModule
    * This method returns a Map<Id, Inverter_Configuration__c>
    * In the map are all the available Inverters and their Item specific information
    * @params: Id of a specific Module Configuration
    * 
    * Calling Classes/Methods: OrderAppUtility;
    *
    * TODO: 
    *
    */

    public static Map<Id, Racking_Item_Junction__c> fetchRackingByModule(Id moduleId, Set<Id> masterIds) {
        
        Map<Id, Racking_Item_Junction__c> rackingMap = new Map<Id, Racking_Item_Junction__c>(); 

        if(String.isBlank(moduleId) || masterIds == null || masterIds.isEmpty())
            return rackingMap;

        Set<Id> junctionIDs = new Set<Id>();
        for(ModuleRackingJunction__c junction : [SELECT Racking_Configuration__c
                                                FROM ModuleRackingJunction__c 
                                                WHERE ID IN (SELECT ModuleRackingJunction__c
                                                             FROM MasterModuleRacking_Junction__c
                                                             WHERE Master_Configurator__c IN: masterIds)
                                                AND Module_Configuration__c =: moduleId]) {
          junctionIDs.add(junction.Racking_Configuration__c);
        }
        if(junctionIDs.isEmpty())
          return rackingMap;

        for(Racking_Item_Junction__c item : [SELECT Id, Item__c, Item__r.Item_Id__c, Item__r.Description__c,
                                                         Racking_Configuration__r.Kit_Size__c, Racking_Configuration__r.Type__c,
                                                         Racking_Configuration__r.Name, Racking_Configuration__c, Quantity__c,Racking_Configuration__r.Usage__c                                                   
                                            FROM Racking_Item_Junction__c
                                            WHERE Racking_Configuration__c IN: junctionIDs]) {
          rackingMap.put(item.Id, item);          
        }
        
        return rackingMap;
    }	

    /*
    * fetchRackingByModule
    * This method returns a Map<Id, Racking_Item_Junction__c>
    * In the map are all Racking Items
    * @params: Id of a specific Module Configuration, Mounting type (Invisimount, SolarMount, etc...)
    *
    * Calling Classes/Methods: ResidentialProjectUtility;
    *
    * TODO:
    *
    */

    public static Map<Id, Racking_Item_Junction__c> fetchRackingByModule(Id moduleId, String mountingType) {
        Map<Id, Racking_Item_Junction__c> rackingMap = new Map<Id, Racking_Item_Junction__c>();

        if(String.isBlank(moduleId))
            return rackingMap;

        Set<Id> junctionIDs = new Set<Id>();
        for(ModuleRackingJunction__c junction : [SELECT Racking_Configuration__c FROM ModuleRackingJunction__c WHERE Module_Configuration__c =: moduleId AND Racking_Configuration__r.Type__c =: mountingType]) {
          junctionIDs.add(junction.Racking_Configuration__c);
        }
        if(junctionIDs.isEmpty())
          return rackingMap;

        for(Racking_Item_Junction__c item : [SELECT Id, Item__c, Item__r.Item_Id__c, Item__r.Description__c, Racking_Configuration__r.Kit_Size__c, Racking_Configuration__r.Type__c, Racking_Configuration__r.Name, Racking_Configuration__c, Quantity__c, Racking_Configuration__r.Usage__c FROM Racking_Item_Junction__c WHERE Racking_Configuration__c IN: junctionIDs]) {
          rackingMap.put(item.Id, item);
        }
        return rackingMap;
    }
	


    /*
    * fetchRackingConfiguration (don't go to Racking Item juction level)
    * This method returns a Map<Id, Racking_Configuration__c>
    * In the map are all the available Racking configuration and their Item specific information
    * @params: Id of a specific Module Configuration
    * 
    * Calling Classes/Methods: QuickquoteCTRL;
    *
    * TODO: 
    *
    */

    public static Map<Id, Racking_Configuration__c> fetchRackingConfigByModule(Id moduleId, Set<Id> masterIds) {
        
        Map<Id, Racking_Configuration__c> rackingMap = new Map<Id, Racking_Configuration__c>(); 

        if(String.isBlank(moduleId) || masterIds == null || masterIds.isEmpty())
            return rackingMap;

        System.debug('moduleId: ' + moduleId);
        System.debug('masterIds: ' + masterIds);

        Set<Id> junctionIDs = new Set<Id>();
        for(ModuleRackingJunction__c junction : [SELECT Racking_Configuration__c
                                                FROM ModuleRackingJunction__c 
                                                WHERE ID IN (SELECT ModuleRackingJunction__c
                                                             FROM MasterModuleRacking_Junction__c
                                                             WHERE Master_Configurator__c IN: masterIds)
                                                AND Module_Configuration__c =: moduleId]) {
          junctionIDs.add(junction.Racking_Configuration__c);
          
        }
        if(junctionIDs.isEmpty())
          return rackingMap;

        for(Racking_Configuration__c rackConfig : [SELECT Id, Name, Kit_Size__c, Type__c                                                         
                                            FROM Racking_Configuration__c
                                            WHERE ID IN: junctionIDs]) {
          rackingMap.put(rackConfig.Id, rackConfig);          
        }
        
        return rackingMap;
    }


    /*
    * fetchModulesInvertersByConfigurationModel - requirement for CVAR since state by state not implemented
    * This method returns a Map<String, ModuleInverterJunction__c> where key = HelixDesignType__c of design object
    * In the map are all the module and inverter configurations and their Item specific information
    * @params: name of a specific master configuration record
    * 
    * Calling Classes/Methods: CommercialDataUtility;
    *
    * TODO: 
    *
    */
    public static Map<String, List<ModuleInverterJunction__c>> fetchModulesInvertersByConfigurationModel(Set<String> cvarInstallTypes) {

        Map<String, List<ModuleInverterJunction__c>> results = new Map<String, List<ModuleInverterJunction__c>>();
        if(cvarInstallTypes == null || cvarInstallTypes.isEmpty())
            return results;


        for(MasterModuleInverterJunction__c mmij : [SELECT Id, ModuleInverterJunction__c,  
                                                           Master_Configuration__r.Configuration_Model__c,
                                                           ModuleInverterJunction__r.Inverter_Configuration__c, 
                                                           ModuleInverterJunction__r.Inverter_Configuration__r.Item__c, 
                                                           ModuleInverterJunction__r.Inverter_Configuration__r.Name, 
                                                           ModuleInverterJunction__r.Inverter_Configuration__r.Inverter_Manufacturer__c,
                                                           ModuleInverterJunction__r.Inverter_Configuration__r.Item__r.Item_ID__c, 
                                                           ModuleInverterJunction__r.Inverter_Configuration__r.Item__r.Description__c, 
                                                           ModuleInverterJunction__r.Inverter_Configuration__r.Item__r.Item_Category_3__c,
                                                           ModuleInverterJunction__r.Module_Configuration__c, 
                                                           ModuleInverterJunction__r.Module_Configuration__r.Name, 
                                                           ModuleInverterJunction__r.Module_Configuration__r.Item__c,
                                                           ModuleInverterJunction__r.Module_Configuration__r.Item__r.Item_Id__c, 
                                                           ModuleInverterJunction__r.Module_Configuration__r.Item__r.Description__c,
                                                           ModuleInverterJunction__r.Module_Configuration__r.Item__r.PV_SIM_no__c, 
                                                           ModuleInverterJunction__r.Module_Configuration__r.Item__r.Item_Category_3__c
                                                    FROM MasterModuleInverterJunction__c
                                                    WHERE Master_Configuration__c != null
                                                    AND ModuleInverterJunction__c != null 
                                                    AND Master_Configuration__r.Configuration_Model__c IN: cvarInstallTypes]) {
            if(results.containsKey(mmij.Master_Configuration__r.Configuration_Model__c))
                results.get(mmij.Master_Configuration__r.Configuration_Model__c).add(mmij.ModuleInverterJunction__r);
            else {
                results.put(mmij.Master_Configuration__r.Configuration_Model__c, new List<ModuleInverterJunction__c>{mmij.ModuleInverterJunction__r});
            }                                            
        }
        return results;
    }  
}