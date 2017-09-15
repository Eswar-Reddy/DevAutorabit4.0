public without sharing class DesignDetailsController {
    
    private final Roof_Design__c roofDesign;
    
    
    public static RoofDesignUtility.RoofDesignWrapper rDesignWrapper{get;set;}
    
    public static List<RoofDesignUtility.RoofDetailWrapper> rDetailWrapperList{get;set;}
    
    public static Map<String,RoofDesignUtility.RoofDetailWrapper> rDetailWrapperMap{get;set;}
    
    public DesignDetailsController(ApexPages.StandardController controller) {
        this.roofDesign = (Roof_Design__c)controller.getRecord();
        getDesignDetails(roofDesign.Id);
    }
    
    public static void getDesignDetails(String roofDesignId){
        
        Roof_Design__c roofDesign = [select Account_Name__c, Account_Name__r.Name, Active__c, Design_DesignId__c, Details__c, Id, Latitude__c,
                                     Launch_Design__c, Longitude__c, MaxFit_Master__c, Name, OwnerId, Paired__c, Quote__c, RecordTypeId, Status__c,
                                      System_Size__c, Type__c,(select Id, Name, Direction__c, Pitch__c, Jan__c,
                                        Feb__c,Mar__c,Apr__c,May__c,Jun__c,Jul__c,Aug__c,Sep__c,Oct__c,Nov__c,Dec__c
                                      from Roof_Details__r order by Direction__c,Pitch__c asc), (select Annual__c, Jan__c, Feb__c, Mar__c, Apr__c, 
                                      May__c, Jun__c, Jul__c, Aug__c, Sep__c, Oct__c, Nov__c, Dec__c from Energy_Productions_Year1__r where Hourly__c=false)
                                       from Roof_Design__c where Id=:roofDesignId];
        
        System.debug('roofDesign.Roof_Details__r----->'+roofDesign.Roof_Details__r);
        System.debug('roofDesign.Energy_Productions_Year1__r----->'+roofDesign.Energy_Productions_Year1__r);
        
        EnergyProductionYr1__c enerPrdYr1 = new EnergyProductionYr1__c();
        if(!roofDesign.Energy_Productions_Year1__r.isEmpty())
            enerPrdYr1 = roofDesign.Energy_Productions_Year1__r[0];
            
        Set<Id> roofDetailIdSet = new Set<Id>();
        
        Map<Id,RoofDetailInverterJunction__c> rDetInvJunMap = new Map<Id,RoofDetailInverterJunction__c>([select Inverter_List__c, InverterName__c, Roof_Detail__c, Inverter_List__r.InverterConfiguration__c,Inverter_List__r.InverterConfiguration__r.Name from RoofDetailInverterJunction__c where Roof_Detail__c in :roofDesign.Roof_Details__r]);
        
        
        
        Map<Id,InverterList__c> ilMap = new Map<Id,InverterList__c>([select Id, RoofDesign__c, InverterConfiguration__c, InverterConfiguration__r.Name from InverterList__c where RoofDesign__c = :roofDesign.Id]);
        System.debug('ilMap----->'+ilMap);
        
        Map<Id,List<InverterList__c>> rDetIdInvListMap = new Map<Id,List<InverterList__c>>();
        
        if(!rDetInvJunMap.isEmpty()){
            for(RoofDetailInverterJunction__c rdInvJnc : rDetInvJunMap.values()){
                if(rDetIdInvListMap.containsKey(rdInvJnc.Roof_Detail__c) && ilMap.containsKey(rdInvJnc.Inverter_List__c)){
                    rDetIdInvListMap.get(rdInvJnc.Roof_Detail__c).add(ilMap.get(rdInvJnc.Roof_Detail__c));
                }
                else{
                    if(ilMap.containsKey(rdInvJnc.Inverter_List__c))
                        rDetIdInvListMap.put(rdInvJnc.Roof_Detail__c,new List<InverterList__c>{ilMap.get(rdInvJnc.Inverter_List__c)});
                }
            }
        }
        
        String inverters = '';
        
        if(!ilMap.isEmpty()){
            inverters = concatInvNames(ilMap.values());
        }
        
        
        //Map of RoofDeatailId and List of RoofDetailInverterJunction
        Map<Id,Set<InverterList__c>> mapRoofDetailIdInverList = new Map<Id,Set<InverterList__c>>();
        
        if(!rDetInvJunMap.isEmpty()){
            for(RoofDetailInverterJunction__c rDetInvJun : rDetInvJunMap.values()){
                if(mapRoofDetailIdInverList.containsKey(rDetInvJun.Inverter_List__c) && ilMap.containsKey(rDetInvJun.Inverter_List__c)){
                    mapRoofDetailIdInverList.get(rDetInvJun.Roof_Detail__c).add(ilMap.get(rDetInvJun.Inverter_List__c));
                }
                else{
                    mapRoofDetailIdInverList.put(rDetInvJun.Roof_Detail__c,new Set<InverterList__c>{ilMap.get(rDetInvJun.Inverter_List__c)});
                }
            }
        }
        
        
        Map<Id,Roof_Details__c> mapofRoofDetails = new Map<Id,Roof_Details__c>([select Id,(select Module__c,Module__r.Name,Quantity__c, Racking__c from RoofDetailItems__r) from Roof_Details__c where Id in :roofDesign.Roof_Details__r]);
        System.debug('mapofRoofDetails----->'+mapofRoofDetails);
        
        Integer TotalmodCount = 0;
        
        rDetailWrapperList = new List<RoofDesignUtility.RoofDetailWrapper>();
        
        //looping through Roof Details(Arrays) to prepare RoofDetail Wrappers
        for(Roof_Details__c rDetail : roofDesign.Roof_Details__r){
            
            Integer rDModCount=0;
            String rDModuleName = '';
            
            System.debug('mapofRoofDetails.get(rDetail.Id).RoofDetailItems__r----->'+mapofRoofDetails.get(rDetail.Id).RoofDetailItems__r);
            if(mapofRoofDetails.get(rDetail.Id).RoofDetailItems__r!=null){
                for(Roof_Detail_Item__c rDetItem : mapofRoofDetails.get(rDetail.Id).RoofDetailItems__r){
                    if(rDetItem.Quantity__c!=null){
                        rDModCount += Integer.valueOf(rDetItem.Quantity__c);
                    }
                    if(rDetItem.Module__c!=null){
                       rDModuleName = rDetItem.Module__r.Name;
                    }
                }
            System.debug('rDModCount----->'+rDModCount);
            }
            
            
            TotalmodCount += rDModCount;
            
            String inverter = '';
            
            if(rDetIdInvListMap.containsKey(rDetail.Id)){
                inverter = concatInvNames(rDetIdInvListMap.get(rDetail.Id));
            }
            
            //----------------------------------------Constructing Roof Detail Wrapper----------------------------------------//
            rDetailWrapperList.add(new RoofDesignUtility.RoofDetailWrapper(rDetail,inverter, rDModuleName, String.valueOf(rDModCount)));
            
        }//End of for loop
        
        
        rDetailWrapperMap = new Map<String,RoofDesignUtility.RoofDetailWrapper>();
        
        for(RoofDesignUtility.RoofDetailWrapper rdet:rDetailWrapperList){
            rDetailWrapperMap.put(rdet.RoofDetail.Id,rdet);
        }
        
        //----------------------------------------Constructing Roof Design Wrapper----------------------------------------//
        rDesignWrapper = new RoofDesignUtility.RoofDesignWrapper(roofDesign,enerPrdYr1,String.valueOf(TotalmodCount),inverters);
        
        System.debug('rDesingWrapper----->'+rDesignWrapper);
        System.debug('rDetailWrapperList----->'+rDetailWrapperList);
    }
    
    public static String concatInvNames(List<InverterList__c> ilList){
    
        Map<String,Integer> mapofInvNameandCount = new Map<String,Integer>();
        
        for(InverterList__c il:ilList){
            if(il.InverterConfiguration__r.Name!=null){
                if(mapofInvNameandCount.containsKey(il.InverterConfiguration__r.Name)){
                    Integer count = 0;
                    count = mapofInvNameandCount.get(il.InverterConfiguration__r.Name)+1;
                    mapofInvNameandCount.put(il.InverterConfiguration__r.Name,count);
                }
                else{
                    mapofInvNameandCount.put(il.InverterConfiguration__r.Name,1);
                }
            }
        }
        System.debug('mapofInvNameandCount----->'+mapofInvNameandCount);
        
        String inverterName='';
        Integer count = 0;
        for(String invName : mapofInvNameandCount.keySet()){
            if(count>0)
                inverterName = inverterName+', ';
            if(mapofInvNameandCount.get(invName)>1){
                inverterName = inverterName + invName+' ('+String.valueOf(mapofInvNameandCount.get(invName))+')';
            }
            else{
                inverterName = inverterName + invName;
            }
            count++;
        }
        
        return inverterName;
    }
}