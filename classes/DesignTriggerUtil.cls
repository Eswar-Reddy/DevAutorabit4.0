public class DesignTriggerUtil {
    private static Id commercialOpptyRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial').getRecordTypeId(); 
    private static Id systemOpptyRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Systems').getRecordTypeId();       
    private static Id proposalRecordType = Schema.SObjectType.Design__c.getRecordTypeInfosByName().get('Proposal Design').getRecordTypeId();
    private static Id projectRecordType = Schema.SObjectType.Design__c.getRecordTypeInfosByName().get('Project Design').getRecordTypeId();
    private static Id systemOnlyRecordType = Schema.SObjectType.Design__c.getRecordTypeInfosByName().get('System Only').getRecordTypeId();
    public static String INDIRECT = 'Indirect';
    public static String REQUEST = 'Request';
    
    public static void setFields(Map<Integer, Design__c> qualifyMap) {
        //Collect additional information
        Set<String> moduleTypes = new Set<String>();
        for(Schema.PicklistEntry p : Design__c.ModuleTypeAndWattage__c.getDescribe().getPicklistValues()) {
            moduleTypes.add(p.getValue());
        }
        
        boolean isInternalUser = false;
        
        Profile userProfile = [SELECT UserType
                               FROM Profile
                               WHERE id =: UserInfo.getProfileId()];
    
        if (userProfile.UserType == 'Standard') {
            isInternalUser = true;
        }

        //Begin processing
        for (Design__c d : qualifyMap.values()) { 
            // after cloning design clear these fields. wf field update cannot set lookup fields.
            if (d.isClone() 
                && d.recordtypeid == projectRecordType 
                && d.Status__c == 'Completed'
                && isInternalUser){
                d.Revision_Of__c = null; 
                d.Status__c = 'Not Started';
            }
            d.Roof_Design__c = null;

            //Set selected module type & wattage if design exported is SPWR module for helix roof
            if(String.isNotBlank(d.Module_Type__c) && !moduleTypes.isEmpty() && moduleTypes.contains(d.Module_Type__c)) {
                d.ModuleTypeandWattage__c = d.Module_Type__c;
            }
            
            //set technology system for exports 
            if(d.Design_Originated_By__c == INDIRECT && d.Technology_System__c == null && d.ModuleTypeandWattage__c != null) {
                d.Technology_System__c = Label.HelixSingleTilt;
            }
        }
    }

    public static void setInitialRevision(List<Design__c> designList) {
        for (Design__c d : designList) {
            if (d.Revision_Letter__c == null) {
                d.Revision_Letter__c = 'A';
            }
        }
    }
    
    public static void validateStatusCompletedFields(Map<Id, Design__c> qualifyMap) {
        Set <String> opptyIdSet = new Set <String>();
        Map <String, Opportunity> opptyMap = new Map <String, Opportunity>();
        Map<Id, Design__c> validDesignsForProductionCheck = new Map<Id, Design__c>();
        for (Design__c d : qualifyMap.values()) {
            if (d.Opportunity__c != null) {
                opptyIdSet.add(d.Opportunity__c);
            }
        } 
        if (opptyIdSet.size() > 0) {
            for (Opportunity o : [SELECT Id, RecordType.DeveloperName, Contract_Type__c, Business_Unit__c FROM Opportunity WHERE Id IN :opptyIdSet]) {
                opptyMap.put(o.Id, o);
            }
        }       
        for (Design__c d : qualifyMap.values()) {
            if (d.Opportunity__c != null && opptyMap.containsKey(d.Opportunity__c)) {
                Opportunity oppty = opptyMap.get(d.Opportunity__c);
                List <String> errorLabels = new List <String>();
                if (d.Technology_System__c == null) {
                    errorLabels.add(Schema.sObjectType.Design__c.fields.Technology_System__c.getLabel());
                }
                if (oppty.RecordType.DeveloperName == 'Commercial') { 
                    if (d.Actual_System_Size__c == null) {
                        errorLabels.add(Schema.sObjectType.Design__c.fields.Actual_System_Size__c.getLabel());
                    }
                    if (d.Actual_Annual_Production__c == null) {
                        errorLabels.add(Schema.sObjectType.Design__c.fields.Actual_Annual_Production__c.getLabel());
                    }
                    if (d.Design_Start_Date__c == null && oppty.Business_Unit__c == 'NA Commercial') {
                        errorLabels.add(Schema.sObjectType.Design__c.fields.Design_Start_Date__c.getLabel());
                    }
                    if (d.Module_Quantity__c == null || d.Module_Quantity__c < 1) {
                        errorLabels.add(Schema.sObjectType.Design__c.fields.Module_Quantity__c.getLabel());
                    }
                    if (d.ModuleTypeandWattage__c == null) {
                        errorLabels.add(Schema.sObjectType.Design__c.fields.ModuleTypeandWattage__c.getLabel());
                    }
                    if (errorLabels.size() == 0) {
                        validDesignsForProductionCheck.put(d.Id, d);
                    }
                }    
                if (errorLabels.size() > 0) {
                    errorLabels.sort();
                    String errMsg = String.join(errorLabels, ', ') + ' required to complete this design.';
                    d.addError(errMsg);
                }
            }
        }
        if(validDesignsForProductionCheck.size() > 0) {
            validateEnergyProduction(validDesignsForProductionCheck);
        }
    }

    public static void validateEnergyProduction(Map<Id, Design__c> qualifyMap) {
        String validationMessage = 'Monthly production data is required to complete this design';
        String productionValidationMsg = 'The sum of the monthly production data is not equal to the annual production. Please correct.';
        Set <String> designIdSet = new Set <String>();
        Set <String> roofDesignIdSet = new Set <String>();
        if (qualifyMap != null) {
            for (Design__c design : qualifyMap.values()) {
                if (design.Id != null) {
                    designIdSet.add(design.Id);
                }
                if (design.Roof_Design__c != null) {
                    roofDesignIdSet.add(design.Roof_Design__c);
                }
            }
        }
        Map <String, EnergyProductionYr1__c> designEnergyProductions = getDesignEnergyProductions(designIdSet);
        Map <String, EnergyProductionYr1__c> roofDesignEnergyProductions = getRoofDesignEnergyProductions(roofDesignIdSet);
        if (qualifyMap != null) {
            for (Design__c design : qualifyMap.values()) {
                EnergyProductionYr1__c ep;
                if (design.Roof_Design__c != null && roofDesignEnergyProductions.containsKey(design.Roof_Design__c)) {
                    ep = roofDesignEnergyProductions.get(design.Roof_Design__c);
                }
                if (ep == null && design.Id != null && designEnergyProductions.containsKey(design.Id)) {
                    ep = designEnergyProductions.get(design.Id);
                }
                if (ep == null) {
                    design.addError(validationMessage);
                } else if (!isFilled(ep.Jan__c) || !isFilled(ep.Feb__c) || !isFilled(ep.Mar__c) || !isFilled(ep.Apr__c) 
                        || !isFilled(ep.May__c) || !isFilled(ep.Jun__c) || !isFilled(ep.Jul__c) || !isFilled(ep.Aug__c)
                        || !isFilled(ep.Sep__c) || !isFilled(ep.Oct__c) || !isFilled(ep.Nov__c) || !isFilled(ep.Dec__c)) {
                    design.addError(validationMessage);
                } else {
                    Decimal variance = getVariance(design, ep);
                    if(variance > 12 || variance < -12) {
                        design.addError(productionValidationMsg);
                    }
                }
            }
        }
    } 
    
    private static Map <String, EnergyProductionYr1__c> getDesignEnergyProductions(Set <String> designIdSet) {
        Map <String, EnergyProductionYr1__c> epMap = new Map <String, EnergyProductionYr1__c>();
        if (designIdSet != null && designIdSet.size() > 0) {
            List <EnergyProductionYr1__c> epList = [SELECT Id, Jan__c, Feb__c, Mar__c, Apr__c, May__c, Jun__c, 
                    Jul__c, Aug__c, Sep__c, Oct__c, Nov__c, Dec__c, Design__c, RoofDesign__c 
                FROM EnergyProductionYr1__c
                WHERE Design__c IN :designIdSet
                ORDER BY LastModifiedDate DESC];
        
            for (EnergyProductionYr1__c ep : epList) {
                if (epMap.containsKey(ep.Design__c) == false) {
                    epMap.put(ep.Design__c, ep);
                }
            }
        }    
        return epMap;    
    }

    private static Map <String, EnergyProductionYr1__c> getRoofDesignEnergyProductions(Set <String> roofDesignIdSet) {
        Map <String, EnergyProductionYr1__c> epMap = new Map <String, EnergyProductionYr1__c>();
        if (roofDesignIdSet != null && roofDesignIdSet.size() > 0) {
            List <EnergyProductionYr1__c> epList = [SELECT Id, Jan__c, Feb__c, Mar__c, Apr__c, May__c, Jun__c, 
                    Jul__c, Aug__c, Sep__c, Oct__c, Nov__c, Dec__c, Design__c, RoofDesign__c 
                FROM EnergyProductionYr1__c
                WHERE RoofDesign__c IN :roofDesignIdSet
                ORDER BY LastModifiedDate DESC];
        
            for (EnergyProductionYr1__c ep : epList) {
                if (epMap.containsKey(ep.RoofDesign__c) == false) {
                    epMap.put(ep.RoofDesign__c, ep);
                }
            }
        }    
        return epMap;    
    }
    
    private static Decimal getVariance(Design__c design, EnergyProductionYr1__c ep) {
        Decimal variance = 0;
        Decimal totalWatts = 0;
        List <String> months = new List <String>{'Jan__c','Feb__c','Mar__c','Apr__c','May__c','Jun__c','Jul__c','Aug__c','Sep__c','Oct__c','Nov__c','Dec__c'};
        for (String month : months) {
            if (ep.get(month) != null) {
                totalWatts += (Decimal)ep.get(month);
            }
        }
        if (design.Actual_Annual_Production__c != null) {
            variance = design.Actual_Annual_Production__c - totalWatts;
        }
        return variance;    
    }
    
    private static Boolean isFilled(Decimal thisValue) {
        if (thisValue == null || thisValue == 0) return false;
        return true;
    }
    
    public static void validateFinalDesign(List<Design__c> designList, Map<Id,Design__c> oldDesignMap){ 
        
        for(Design__c design : designList){                                     
            if(design.RecordTypeId != systemOnlyRecordType) {
                if(design.Final_Design__c  && design.Site__c == null){
                    design.Site__c.addError(System.Label.FinalDesignValidate);
                }           
                if(design.Final_Design__c  && oldDesignMap != null && design.Site__c != oldDesignMap.get(design.Id).Site__c 
                  && design.Opportunity__c != oldDesignMap.get(design.Id).Opportunity__c){
                    design.Site__c.addError(System.Label.FinalDesignSiteOpptyChangeValidate);
                }
            }
        }  
    } 
    
    public static void deleteFinalDesign(List<Design__c> designList) { 
        Map <Id, Design__c> designMap = new Map <Id, Design__c>();
        for(Design__c design : designList){
            if (design.Id != null) {
                designMap.put(design.Id, design);
            }
        }
        if (designMap.size() > 0) {
            for (Design__c design : [SELECT Id, Site__c, Final_Design__c 
                                     FROM Design__c  
                                     WHERE ((Opportunity__r.Business_Unit__c = 'NA Commercial' 
                                             AND Opportunity__r.RecordTypeId =: systemOpptyRecordType) 
                                             OR  Opportunity__r.RecordTypeId =: commercialOpptyRecordType)
                                     AND Final_Design__c = true
                                     AND Id IN :designMap.keySet()]) {  
                designMap.get(design.Id).addError(System.Label.FinalDesignDeleteError);
            }
        }
    } 

    public static void selectFinalDesign(List <Design__c> designList) {

        Set <String> siteIdSet = new Set <String>();
        for (Design__c d : designList) {
            if (d.Final_Design__c == true) {
                if (d.Site__c != null) {
                    siteIdSet.add(d.Site__c);
                }
            }
        }
        List <Design__c> existingDesignList = new LIst <Design__c>();
        if (siteIdSet.size() > 0) {
            existingDesignList = [SELECT Id, Site__c, Technology_System__c, Final_Design__c, RecordTypeId  
                FROM Design__c WHERE Site__c IN :siteIdSet AND Final_Design__c = true];
        }
        
        // group by site -> record type id -> tech sys -> design list
        Map <String, Map <String, Map <String, List <Design__c>>>> siteMap = groupDesigns(designList);
        Map <String, Map <String, Map <String, List <Design__c>>>> existingSiteMap = groupDesigns(existingDesignList);

        List <Design__c> updateList = new List <Design__c>();
        for (String siteId : siteMap.keySet()) {
            Map <String, Map <String, List <Design__c>>> recordTypeMap = siteMap.get(siteId);
            Map <String, Map <String, List <Design__c>>> existingRecordTypeMap = new Map <String, Map <String, List <Design__c>>>();
            if (existingSiteMap.containsKey(siteId)) {
                existingRecordTypeMap = existingSiteMap.get(siteId);
            }
            for (String recordType : recordTypeMap.keySet()) {
                Map <String, List <Design__c>> techSysMap = recordTypeMap.get(recordType);
                Map <String, List <Design__c>> existingTechSysMap = new Map <String, List <Design__c>>();
                if (existingRecordTypeMap.containsKey(recordType)) {
                    existingTechSysMap = existingRecordTypeMap.get(recordType);
                }
                for (String techSys : techSysMap.keySet()) {
                    List <Design__c> designs = techSysMap.get(techSys);
                    List <Design__c> existingDesigns = new List <Design__c>();
                    if (existingTechSysMap.containsKey(techSys)) {
                        existingDesigns = existingTechSysMap.get(techSys);
                    }
                    // trigger records. more than one design with flag set. leave the first and set others to false
                    if (designs.size() > 1) {
                        for (Integer i=1; i<designs.size(); i++) {
                            designs[i].Final_Design__c = false;
                        }
                    }
                    // unset existing designs. trigger first record is already set above.
                    // if the trigger first record is new then unset all existing designs
                    // if the trigger first record is update then unset remaining existing records 
                    if (designs.size() > 0) {
                        for (Design__c ed : existingDesigns) {
                            if (designs[0].Id == null || designs[0].Id != ed.Id) {
                                ed.Final_Design__c = false;
                                updateList.add(ed);
                            }
                        }
                    }
                } 
            }           
        }        
        
        if (updateList.size() > 0) {
            update updateList;
        }        
    }
    
    public static void setOpportunitySystemSize(List <Design__c> designList) {
        Set <String> opptyIdSet = new Set <String>();
        for (Design__c d : designList) {
            if (d.Opportunity__c != null) {
                opptyIdSet.add(d.Opportunity__c);
            }
        }
        
        List <Opportunity> opptyUpdateList = new List <Opportunity>();
        List <Opportunity> opptyList = getOpportunityDesigns(opptyIdSet);
        for (Opportunity oppty : opptyList) {
            Decimal actualSVAmount;
            for (Design__c d : oppty.Design__r) {
                if (d.Final_Design__c == true || (d.RecordTypeId != null && d.RecordTypeId == systemOnlyRecordType)) {
                    if (d.Actual_System_Size__c != null) {
                        actualSVAmount = actualSVAmount == null ? d.Actual_System_Size__c : actualSVAmount + d.Actual_System_Size__c;
                    }
                }
            }
            if (oppty.System_Size_KwP__c != actualSVAmount) {
                oppty.System_Size_KwP__c = actualSVAmount;
                opptyUpdateList.add(oppty);
            }
        }
        if (opptyUpdateList.size() > 0) {
            update opptyUpdateList;
        }
    }
    
    private static Map <String, Map <String, Map <String, List <Design__c>>>> groupDesigns(List <Design__c> designList) {
        Map <String, Map <String, Map <String, List <Design__c>>>> siteMap = new Map <String, Map <String, Map <String, List <Design__c>>>>();
        for (Design__c d : designList) {
            if (d.Final_Design__c == true && d.RecordTypeId != systemOnlyRecordType) {
                if (d.Site__c != null) {
                    Map <String, Map <String, List <Design__c>>> recordTypeMap = new Map <String, Map <String, List <Design__c>>>();
                    Map <String, List <Design__c>> techSysMap = new Map <String, List <Design__c>>();
                    List <Design__c> designs = new List <Design__c>();
                    if (siteMap.containsKey(d.Site__c)) {
                        recordTypeMap = siteMap.get(d.Site__c);
                    }
                    if (d.RecordTypeId != null) {
                        if (recordTypeMap.containsKey(d.RecordTypeId)) {
                            techSysMap = recordTypeMap.get(d.RecordTypeId);
                        }
                        if (d.Technology_System__c != null) {
                            if (techSysMap.containsKey(d.Technology_System__c)) {
                                designs = techSysMap.get(d.Technology_System__c);
                            }
                            designs.add(d);
                            techSysMap.put(d.Technology_System__c, designs);
                        }
                        recordTypeMap.put(d.RecordTypeId, techSysMap);
                    }
                    siteMap.put(d.Site__c, recordTypeMap);
                }
            }
        }
        return siteMap;    
    }
    
    private static List <Opportunity> getOpportunityDesigns(Set <String> opptyIdSet) {
        List <Opportunity> opptyList = new List <Opportunity>();
        if (opptyIdSet.size() > 0) {
            opptyList = [SELECT Id, Override_System_Size__c, System_Size_KwP__c,
                    (SELECT Id, Actual_System_Size__c, Final_Design__c, RecordTypeId FROM Design__r)
                FROM Opportunity 
                WHERE Id IN :opptyIdSet
                    AND RecordTypeId =: commercialOpptyRecordType
                    AND Override_System_Size__c = false
                    ];
        }
        return opptyList;        
    }
    
}