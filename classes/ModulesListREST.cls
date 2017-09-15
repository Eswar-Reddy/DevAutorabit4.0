@RestResource(urlMapping='/getModulesList/*')
//Usage - /services/apexrest/getModulesList?Id=00580000003Z0MS&State=CA&sector=Residential&channel=Direct
global with sharing class ModulesListREST {

    @HttpGet
    global static Response doGet() {
        return getResponse(RestContext.request);
    }
    
    public static Response getResponse(RestRequest req) {
        Response r = new Response();    

        SalesConfiguratorParam scp = new SalesConfiguratorParam();
        
        Map <String, String> params = req.params;
        if (params != null) {
            for (String param : params.keySet()) {
                String value = params.get(param); 
                r.requestParams.add(new RequestParam(param, value));
                if (param == 'operatingUnit') {
                    scp.operatingUnit = value;
                } else if (param == 'state') {
                    scp.state = value;
                } else if (param == 'quoteTypes') {
                    scp.quoteTypes = value;
                } else if (param == 'salesMethodology') {
                    scp.salesMethodology = value;
                } else if (param == 'sector') {
                    scp.sector = value;
                } else if (param == 'channel') {
                    scp.channel = value;
                } else if (param == 'partnerAccountId') {
                    scp.partnerAccountId = value;
                } else if (param == 'includeDiscontinuedModules'){
                    scp.includeDiscontinuedModules = value=='true'?true:false;
                } else if (param == 'showinDynamicModeItemsOnly'){
                    scp.showinDynamicModeItemsOnly = value=='true'?true:false;
                }
            }
        }
        
        // validate
        if (String.IsBlank(scp.state)) {
            r.errors.add(ProdConfigurationError.getError(801));
        }  
        if (String.IsBlank(scp.sector)) {
            r.errors.add(ProdConfigurationError.getError(802));
        }  
        if (String.IsBlank(scp.channel)) {
            r.errors.add(ProdConfigurationError.getError(803));
        }  
        if (r.errors.size() > 0) {
            return r;
        } else {
            r.success = true;
        }
        
        List <SalesConfiguration__c> salesConfigurations = getSalesConfigurations(scp);
        r.salesConfigurationCount = salesConfigurations.size();
        
        // get MasterModuleInverterJunction__c, MasterModuleRacking_Junction__c
        Set <String> mcIdSet = new Set <String>();
        for (SalesConfiguration__c sc : salesConfigurations) {
            if (sc.Configurator__c != null) {
                mcIdSet.add(sc.Configurator__c);
            }
        } 
        List <MasterModuleInverterJunction__c> masterModuleInverterJunctions = getMasterModuleInverterJunction(mcIdSet);
        r.masterModuleInverterJunctionCount = masterModuleInverterJunctions.size();
        List <MasterModuleRacking_Junction__c> masterModuleRackingJunctions = getMasterModuleRackingJunction(mcIdSet);
        r.masterModuleRackingJunctionCount = masterModuleRackingJunctions.size();
        
        // get ModuleInverterJunction__c
        Set <String> mijIdSet = new Set <String>();
        for (MasterModuleInverterJunction__c mmij : masterModuleInverterJunctions) {
            if (mmij.ModuleInverterJunction__c != null) {
                mijIdSet.add(mmij.ModuleInverterJunction__c);
            }
        }
        List <ModuleInverterJunction__c> moduleInverterJunctions = getModuleInverterJunction(mijIdSet);
        r.moduleInverterJunctionCount = moduleInverterJunctions.size();
        
        // get ModuleRackingJunction__c
        /*
        Set <String> mrjIdSet = new Set <String>();
        for (MasterModuleRacking_Junction__c mmrj : masterModuleRackingJunctions) {
            if (mmrj.ModuleRackingJunction__c != null) {
                mrjIdSet.add(mmrj.ModuleRackingJunction__c);
            }
        }
        List <ModuleRackingJunction__c> moduleRackingJunctions = getModuleRackingJunction(mrjIdSet);
        r.moduleRackingJunctionCount = moduleRackingJunctions.size();
        */
        
        // get Module_Configuration__c
        Set <String> modConfIdSet = new Set <String>();
        for (ModuleInverterJunction__c mij : moduleInverterJunctions) {
            if (mij.Module_Configuration__c != null) {
                modConfIdSet.add(mij.Module_Configuration__c);
            }
        }
        /*
        for (ModuleRackingJunction__c mrj : moduleRackingJunctions) {
            if (mrj.Module_Configuration__c != null) {
                modConfIdSet.add(mrj.Module_Configuration__c);
            }
        }
        */
        List <Module_Configuration__c> moduleConfigurations = getModuleConfiguration(modConfIdSet);
        r.moduleConfigurationCount = moduleConfigurations.size();
        
        ObjectRelation objRelation = getObjectRelation(
            moduleConfigurations,
            moduleInverterJunctions,
            masterModuleInverterJunctions,
            salesConfigurations
        );
        
        for (Module_Configuration__c mc : moduleConfigurations) {
            if((scp.showinDynamicModeItemsOnly && mc.Item__r.Show_In_Dynamic_Proposal__c) || !scp.showinDynamicModeItemsOnly){
                Module m = new Module();
                m.moduleId = mc.Id;
                m.moduleDescription = mc.Name;
                m.moduleItemId = mc.Item__r.Item_ID__c;
                m.moduleCurrent = mc.Current_Type__c;
                m.itemCategory3 = mc.Item__r.Item_Category_3__c;
                if (objRelation.financialOfferingsMap.containsKey(mc.Id)) {
                    m.financialOfferings = new List <String>(objRelation.financialOfferingsMap.get(mc.Id));
                    m.financialOfferingsMap = new Map<String, String>(objRelation.mfinancialOfferingsMap.get(mc.Id));
                }
                if (objRelation.masterConfigIdsMap.containsKey(mc.Id)) {
                    m.masterConfigIds = new List <String>(objRelation.masterConfigIdsMap.get(mc.Id));
                }
                r.modules.add(m);
            }
        }
         
        return r;    
    }
    
    private static ObjectRelation getObjectRelation(
        List <Module_Configuration__c> moduleConfigurations,
        List <ModuleInverterJunction__c> moduleInverterJunctions,
        List <MasterModuleInverterJunction__c> masterModuleInverterJunctions,
        List <SalesConfiguration__c> salesConfigurations
        ) {
        
        ObjectRelation objRelation = new ObjectRelation();
        
        Map <String, Set <String>> financialOfferingsMap = new Map <String, Set <String>>();
        Map <String, Set <String>> masterConfigIdsMap = new Map <String, Set <String>>();
        Map<String, Map<String, String>> mfinancialOfferingsMap = new Map<String, Map<String, String>>();

        Map <String, List <ModuleInverterJunction__c>> modConf_mijList_map = new Map <String, List <ModuleInverterJunction__c>>();
        for (ModuleInverterJunction__c mij : moduleInverterJunctions) {
            if (mij.Module_Configuration__c != null) {
                List <ModuleInverterJunction__c> mijList = new List <ModuleInverterJunction__c>();
                if (modConf_mijList_map.containsKey(mij.Module_Configuration__c)) {
                    mijList = modConf_mijList_map.get(mij.Module_Configuration__c);
                }
                mijList.add(mij);
                modConf_mijList_map.put(mij.Module_Configuration__c, mijList);            
            }
        }
        
        Map <String, Set <String>> mij_masConfSet_map = new Map <String, Set <String>>();
        for (MasterModuleInverterJunction__c mmij : masterModuleInverterJunctions) {
            if (mmij.ModuleInverterJunction__c != null && mmij.Master_Configuration__c != null) {
                Set <String> masConfSet = new Set <String>();
                if (mij_masConfSet_map.containsKey(mmij.ModuleInverterJunction__c)) {
                    masConfSet = mij_masConfSet_map.get(mmij.ModuleInverterJunction__c);
                }
                masConfSet.add(mmij.Master_Configuration__c);
                mij_masConfSet_map.put(mmij.ModuleInverterJunction__c, masConfSet);
            }        
        }
        
        Map <String, List <SalesConfiguration__c>> masConfif_scList_map = new Map <String, List <SalesConfiguration__c>>(); 
        for (SalesConfiguration__c sc : salesConfigurations) {
            if (sc.Configurator__c != null) {
                List <SalesConfiguration__c> scList = new List <SalesConfiguration__c>();
                if (masConfif_scList_map.containsKey(sc.Configurator__c)) {
                    scList = masConfif_scList_map.get(sc.Configurator__c);
                }
                scList.add(sc);
                masConfif_scList_map.put(sc.Configurator__c, scList);
            }
        }
        
        for (String modConfId : modConf_mijList_map.keySet()) {
            Set <String> financialOfferingSet = new Set <String>();
            Map<String, String> mfinancialOfferingMap = new Map<String, String>();
            Set <String> masterConfigIdsSet = new Set <String>();
            for (ModuleInverterJunction__c mij : modConf_mijList_map.get(modConfId)) {
                if (mij_masConfSet_map.containsKey(mij.Id)) {
                    for (String masConfId : mij_masConfSet_map.get(mij.Id)) {
                        masterConfigIdsSet.add(masConfId);
                        if (masConfif_scList_map.containsKey(masConfId)) {
                            for (SalesConfiguration__c sc : masConfif_scList_map.get(masConfId)) {
                                if (sc.Financial_Offering__c != null) {
                                    financialOfferingSet.add(sc.Financial_Offering__c);
                                    mfinancialOfferingMap.put(sc.Financial_Offering__c, sc.Active__c?'Active':'Inactive');
                                }
                            }
                        }
                    }
                }
            }
            financialOfferingsMap.put(modConfId, financialOfferingSet);
            masterConfigIdsMap.put(modConfId, masterConfigIdsSet);
            mfinancialOfferingsMap.put(modConfId, mfinancialOfferingMap);
        }
    
        objRelation.financialOfferingsMap = financialOfferingsMap; 
        objRelation.masterConfigIdsMap = masterConfigIdsMap; 
        objRelation.mfinancialOfferingsMap = mfinancialOfferingsMap;
        return objRelation;   
    }
    
    private class ObjectRelation {
        Map <String, Set <String>> financialOfferingsMap = new Map <String, Set <String>>();
        Map <String, Set <String>> masterConfigIdsMap = new Map <String, Set <String>>();
        Map<String, Map<String, String>> mfinancialOfferingsMap = new Map<String, Map<String, String>>();
    }
    
    private static List <Module_Configuration__c> getModuleConfiguration(Set <String> modConfIdSet) {
        List <Module_Configuration__c> modConfList = [SELECT Id, Name, Current_Type__c, Item__c, Item__r.Item_ID__c,
                Item__r.Item_Category_3__c, Item__r.Show_In_Dynamic_Proposal__c
            FROM Module_Configuration__c WHERE Id IN :modConfIdSet];
    
        return modConfList;
    }
    
    private static List <ModuleRackingJunction__c> getModuleRackingJunction(Set <String> mrjIdSet) {
        List <ModuleRackingJunction__c> mrjList = [SELECT Id, Name, Module_Configuration__c, Racking_Configuration__c
            FROM ModuleRackingJunction__c
            WHERE Id IN :mrjIdSet];
        
        return mrjList;    
    }
    
    private static List <ModuleInverterJunction__c> getModuleInverterJunction(Set <String> mijIdSet) {
        List <ModuleInverterJunction__c> mijList = [SELECT Id, Name, Inverter_Configuration__c, Module_Configuration__c
            FROM ModuleInverterJunction__c WHERE Id IN :mijIdSet];
        return mijList;
    }
    
    private static List <MasterModuleInverterJunction__c> getMasterModuleInverterJunction(Set <String> mcIdSet) {
        List <MasterModuleInverterJunction__c> mmijList = [SELECT Id, Name, Master_Configuration__c, ModuleInverterJunction__c
            FROM MasterModuleInverterJunction__c
            WHERE Master_Configuration__c IN :mcIdSet];
    
        return mmijList;
    }
    
    private static List <MasterModuleRacking_Junction__c> getMasterModuleRackingJunction(Set <String> mcIdSet) {
        List <MasterModuleRacking_Junction__c> mmrj = [SELECT Id, Name, ModuleRackingJunction__c
            FROM MasterModuleRacking_Junction__c
            WHERE Master_Configurator__c IN :mcIdSet];
    
        return mmrj;    
    }
    
    private static List <SalesConfiguration__c> getSalesConfigurations(SalesConfiguratorParam param) {
        List <SalesConfiguration__c> scListReturn = new List <SalesConfiguration__c>();

        String paramState = param.state;
        String paramSector = param.sector;
        String paramChannel = param.channel;
        String scSOQLQueryString = 'SELECT Id, Name,Partner__c,Active__c,Channel__c,Financial_Offering__c,Configurator__c,Operating_Unit__c,SalesMethodology__c,Sector__c,State__c FROM SalesConfiguration__c WHERE State__c = :paramState AND Sector__c = :paramSector AND Channel__c = :paramChannel';

        if((param.includeDiscontinuedModules == null) || (param.includeDiscontinuedModules != null && !param.includeDiscontinuedModules)){
            scSOQLQueryString = scSOQLQueryString + ' AND Active__c=true';
        }

        List <SalesConfiguration__c> scList = new List<SalesConfiguration__c>();
        scList = Database.query(scSOQLQueryString);

        for (SalesConfiguration__c sc : scList) {
            // process optional params matches
            if (String.IsNotBlank(param.quoteTypes)) {
                Boolean qtFound = false;
                for (String qt : param.quoteTypes.split(',')) {
                    if (String.IsNotBlank(qt) && sc.Financial_Offering__c == qt) {
                        qtFound = true;
                        break;
                    }
                }
                if (qtFound == false) {
                    continue;
                }
            }
            if (String.IsNotBlank(param.operatingUnit) && sc.Operating_Unit__c != param.operatingUnit) {
                continue;
            }
            if (String.IsNotBlank(param.salesMethodology) && sc.SalesMethodology__c != param.salesMethodology) {
                continue;
            }
            if (String.IsNotBlank(param.partnerAccountId) && sc.Partner__c != param.partnerAccountId) {
                continue;
            }
            scListReturn.add(sc);
        }    

        return scListReturn;    
    }
    
    global class Response {
        Boolean success = false;
        List <RequestParam> requestParams = new List <RequestParam>();
        Integer salesConfigurationCount;
        Integer masterModuleInverterJunctionCount;
        Integer masterModuleRackingJunctionCount;
        Integer moduleInverterJunctionCount;
        Integer moduleRackingJunctionCount;
        Integer moduleConfigurationCount;
        List <Module> modules = new List <Module>();
        Map <String, List <Map <String, String>>> records = new Map <String, List <Map <String, String>>>();
        List <ProdConfigurationError.Error> errors = new List <ProdConfigurationError.Error>();
    }
    private class RequestParam {
        String name;
        String value;
        RequestParam(String name, String value) {
            this.name = name;
            this.value = value;
        }
    }
    private class Module {
        String moduleId;    
        String moduleItemId;
        String moduleDescription;
        String moduleCurrent;
        String itemCategory3;
        List <String> masterConfigIds = new List <String>();
        List <String> financialOfferings = new List <String>();
        Map<String, String> financialOfferingsMap = new Map<String, String>();
    }
    
    private class SalesConfiguratorParam {
        String operatingUnit = 'SPNA OU';
        String state;     // required
        String quoteTypes; 
        String salesMethodology = 'Quote'; 
        String sector;     // required
        String channel;     // required
        String partnerAccountId;
        boolean includeDiscontinuedModules;
        boolean showinDynamicModeItemsOnly = false;
    }
    
}