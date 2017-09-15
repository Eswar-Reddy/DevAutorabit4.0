/*
    Created By: Sita Reeves - Residential Installation Project Mgmt
    Created On: August 2016

    Functions
    -----------------------------
    IM Auto Assignment 
    Template Auto Assignment 
    Alliance Partner Creation
    Alliance Partner Change
    Assing TPS Partner
*/

public with sharing class ResidentialProjectTPSUtility {

    public static Id imtId = Schema.SObjectType.Project_Installation_Setting__c.getRecordTypeInfosByName().get('IM Template').getRecordTypeId();
    public static Id papId = Schema.SObjectType.Alliance_Partner__c.getRecordTypeInfosByName().get('Project Alliance Partner').getRecordTypeId();

    
    // When an installation model gets populated on a project record, create alliance partner records
    // Map that comes in is <project Id, installation model Id>
    public static void createAlliancePartners(Map<Id, Id> allianceMap){

        List<Alliance_Partner__c> newAlliancePartners = new List<Alliance_Partner__c>();
        Map<Id,Installation_Model__c> models = new Map<Id, Installation_Model__c>([SELECT Id, Roles__c FROM Installation_Model__c WHERE Id IN: allianceMap.values()]);
        for(Id rId : allianceMap.keyset()){
            List<String> roles = models.get(allianceMap.get(rId)).Roles__c.split(';');
            for(String r : roles){
                Alliance_Partner__c ap = new Alliance_Partner__c();
                ap.RecordTypeId = papId;
                ap.Residential_Project__c = rId;
                ap.Role__c = r;
                newAlliancePartners.add(ap);
            }
        }
        insert newAlliancePartners;
        
    }

    // If Installation Model is changed, run delta on Alliance Partner records to delete extras or add additional ones
    public static void changeAlliancePartners(Map<Id, Id> newIMMap, Map<Id, Id> oldIMMap){

        List<Alliance_Partner__c> apToInsert = new List<Alliance_Partner__c>();
        List<Alliance_Partner__c> apToDelete = new List<Alliance_Partner__c>();

        Map<Id, Installation_Model__c> oldIMList = new Map<Id, Installation_Model__c>([SELECT Id, Roles__c FROM Installation_Model__c WHERE Id IN: oldIMMap.values()]);
        Map<Id, Installation_Model__c> newIMList = new Map<Id, Installation_Model__c>([SELECT Id, Roles__c FROM Installation_Model__c WHERE Id IN: newIMMap.values()]);
    
        Map<Id, Residential_Project__c> projectList = new Map<Id, Residential_Project__c>([SELECT Id, (SELECT Id, Role__c FROM Alliance_Partners__r) FROM Residential_Project__c WHERE Id IN: newIMMap.keyset()]);
        system.debug('About to start delta process');
        for(Residential_Project__c r : projectList.values()){
            Set<String> newRoles = new Set<String>();
            newRoles.addAll(newIMList.get(newIMMap.get(r.Id)).Roles__c.split(';'));
            Set<String> oldRoles = new Set<String>();
            oldRoles.addAll(oldIMList.get(oldIMMap.get(r.Id)).Roles__c.split(';'));
            for(String s : newRoles){
                if(oldRoles.contains(s)){
                    oldRoles.remove(s);
                }else{
                    Alliance_Partner__c ap = new Alliance_Partner__c();
                    ap.RecordTypeId = papId;
                    ap.Residential_Project__c = r.Id;
                    ap.Role__c = s;
                    apToInsert.add(ap);
                }
                
            }
            if(oldRoles.size() > 0){
                for(String s : oldRoles){
                    for(Alliance_Partner__c ap : r.Alliance_Partners__r){
                        if(s == ap.Role__c) apToDelete.add(ap);
                    }
                }
            }
        }
        delete apToDelete;
        insert apToInsert;

    }

    // When a TPS project is created, create an Alliance Partner - TPS Role from TPS partner on Opportunity
    public static void assignTPSPartner(Map<Id, Id> projOppMap){
        Map<Id, Id>                     oppMap = new Map<Id, Id>();
        List<Alliance_Partner__c>   apToInsert = new List<Alliance_Partner__c>();

        for(Opportunity o : [SELECT Id, Partner_Account_Id__c FROM Opportunity WHERE Id IN: projOppMap.values()]){
            oppMap.put(o.Id, o.Partner_Account_Id__c);
        }
        system.debug('in assign map'+oppMap);
        for(Id pId : projOppMap.keyset()){
            if(oppMap.get(projOppMap.get(pId))!= NULL){
                Alliance_Partner__c ap = new Alliance_Partner__c();
                ap.RecordTypeId = papId;
                ap.Residential_Project__c = pId;
                ap.Partner_Account__c = oppMap.get(projOppMap.get(pId));
                ap.Role__c = 'TPS';
                apToInsert.add(ap);
            }
        }

        insert apToInsert;
    }

    public static void findTPSTemplate(Map<Residential_Project__c, Id> projects){
        Map<String, Id> tempMap     = new Map<String, Id>();
        Map<String, Id> regionsMap  = new Map<String, Id>();
        Map<Id, Id> templateMap     = new Map<Id, Id>();

        for(Residential_Project__c temp : [SELECT Id, Name FROM Residential_Project__c WHERE RecordType.Name = 'Project Template' AND Name LIKE 'TPS%']){
            tempMap.put(temp.Name, temp.Id);
        }
        // Create maps to cross reference project zip with IP Regions. If SPRI office is found, assign template related to that office
        for(Project_Installation_Setting__c pis : [SELECT Id, Installation_Partner__c, Zip_Code__c, Project_Template__c, RecordType.Name FROM Project_Installation_Setting__c WHERE RecordType.Name = 'IP Regions' OR RecordType.Name = 'IP Template']){
            if(pis.RecordType.Name == 'IP Regions') regionsMap.put(pis.Zip_Code__c, pis.Installation_Partner__c);
            if(pis.RecordType.Name == 'IP Template') templateMap.put(pis.Installation_Partner__c, pis.Project_Template__c);
        }

        for(Residential_Project__c rp : projects.keyset()){ 
            if(regionsMap.containsKey(rp.Customer_Zip__c)){
                if(templateMap.containsKey(regionsMap.get(rp.Customer_Zip__c))) rp.Project_Template__c = templateMap.get(regionsMap.get(rp.Customer_Zip__c));
            }else{
                String tempName = 'TPS '+ rp.Customer_State__c + ' Template';
                if(tempMap.containsKey(tempName)) rp.Project_Template__c = tempMap.get(tempName);
            }
        }
    }

    // Try to auto assign Installation Model if only one match is found
    public static List<Residential_Project__c> findInstallationModel(List<Residential_Project__c> projects){

        List<Installation_Model__c>     models    = [SELECT Id, Name, State__c, Roles__c, Financing_Option__c FROM Installation_Model__c WHERE Type__c = 'Auto' AND Partner__c = 'TPS' AND State__c != NULL];
        List<Residential_Project__c>  returnProjects   = new List<Residential_Project__c>();

        for(Residential_Project__c r : projects){
            for(Installation_Model__c im : models){
                List<String> states = im.State__c.split(';');
                Set<String> stateSet = new Set<String>(states);
                if(stateSet.contains(r.Customer_State__c) && im.Financing_Option__c == r.SPWR_Deal_Type__c){
                    r.Installation_Model__c = im.Id;
                    returnProjects.add(r);
                }
            }
            
        }
        return returnProjects;
    }
}