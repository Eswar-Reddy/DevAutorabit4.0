@RestResource(urlMapping='/getRackingCalculation/*')
//Usage - /services/apexrest/getRackingCalculation?moduleConfigurationId=a6k340000003zUc&masterConfigurationIds=a6h34000000CcQ5,a6hM0000000Cdvv&ModuleCount=27
global with sharing class RackingCalculationREST {

    @HttpGet
    global static Response doGet() {
        Response r = new Response();
    
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Map <String, String> params = req.params;
        
        Map<String, Integer> ItemMap = new Map<String, Integer>();
        String moduleConfigurationId;
        String masterConfigurationIds;
        String ModuleCount;
        String MountType;
        Integer SolarQuantity;
        List<String> mountStrs = new List<String>();
        
        Set<id> masterConfigurationIdList= new Set<id>();
                
        if (params != null) {
            for (String param : params.keySet()) {
                String value = params.get(param); 
                r.requestParams.add(new RequestParam(param, value));
                if (param == 'moduleConfigurationId') {
                    moduleConfigurationId= value;
                } else if (param == 'masterConfigurationIds') {
                    masterConfigurationIds = value;
                    for(String mc :masterConfigurationIds.split(',')){
                        masterConfigurationIdList.add(mc);
                    }
                } else if (param == 'ModuleCount') {
                    ModuleCount = value;
                }  
                else if (param == 'MountType') {
                    MountType = value;
                }     
            }
        }
        
        // validate
        if (String.IsBlank(moduleConfigurationId)) {
            r.errors.add(ProdConfigurationError.getError(805));
        }
        if (String.IsBlank(masterConfigurationIds)) {
            r.errors.add(ProdConfigurationError.getError(806));
        }
        if (String.IsBlank(ModuleCount)) {
            r.errors.add(ProdConfigurationError.getError(807));
        }
        if (String.IsBlank(MountType)) {
            r.errors.add(ProdConfigurationError.getError(808));
        }
        if (r.errors.size() > 0) {
            return r;
        } else {
            r.success = true;
        }
        
        mountStrs.add(MountType);
        if(MountType=='Solarmount'){
            mountStrs.add('Solar Mount');
        }
        if(MountType=='Solar Mount'){
            mountStrs.add('SolarMount');
        }
        Decimal mcount = Decimal.valueOf(ModuleCount);        
        Map<Id, Racking_Item_Junction__c> rackingMap = new Map<Id, Racking_Item_Junction__c>();

        if(!String.isBlank(moduleConfigurationId) && masterConfigurationIdList!= null && !masterConfigurationIdList.isEmpty() && !String.isBlank(MountType)){
            
            Set<Id> junctionIDs = new Set<Id>();
            for(ModuleRackingJunction__c junction : [SELECT Racking_configuration__c from ModuleRackingJunction__c WHERE ID IN (SELECT ModuleRackingJunction__c FROM MasterModuleRacking_Junction__c WHERE Master_Configurator__c IN :masterConfigurationIdList) AND Module_Configuration__c=:moduleConfigurationId]){
                JunctionIDs.add(junction.Racking_Configuration__c);
            }
            system.debug('==jids=='+JunctionIDs);
            if(!JunctionIDs.isEmpty()){
                for(Racking_Item_Junction__c item : [SELECT Id, Item__c,Item__r.Name, Item__r.Item_Id__c,Item__r.Description__c,Racking_Configuration__r.Kit_Size__c,Racking_Configuration__r.Type__c,Racking_Configuration__r.Name,Racking_Configuration__c,Quantity__c,Racking_Configuration__r.Usage__c FROM Racking_Item_Junction__c WHERE Racking_Configuration__c IN: junctionIDs and Racking_Configuration__r.Type__c=:MountType]){
                    rackingMap.put(item.id,item);
                }
            }
            system.debug('==rackingmap=='+rackingMap);
            if(rackingMap.size()>0){
                if(MountType=='Invisimount'){
                    RackingCalculationUtility rcu = new RackingCalculationUtility();
                    r.raccaldata = rcu.calculateInvisimount(rackingMap,mcount);
                }
                if(MountType=='SolarMount' || MountType=='Solar Mount'){
                    for(Module_Configuration__c mc :[SELECT id,item__r.PV_Cell_Count__c, item__r.Module_Width__c FROM Module_Configuration__c WHERE Id =:moduleConfigurationId]){
                        Decimal temp = (mcount * mc.item__r.Module_Width__c)/132;
                        temp = temp.round(System.RoundingMode.CEILING);
                        SolarQuantity = Integer.valueOf(temp);
                    }
                    
                    for(Id rj:rackingMap.KeySet()){
                        ItemMap.put(rackingmap.get(rj).Item__r.Name, SolarQuantity);
                    }
                    r.raccaldata = ItemMap;
                }
            }
        }
        
        return r;
    }
    
    global class Response {
        Boolean success = false;
        List <RequestParam> requestParams = new List <RequestParam>();
        List <ProdConfigurationError.Error> errors = new List <ProdConfigurationError.Error>();
        Map <String, Integer> raccaldata = new Map<String, Integer>();
        
    }
    
    private class RequestParam {
        String name;
        String value;
        RequestParam(String name, String value) {
            this.name = name;
            this.value = value;
        }
    } 

}