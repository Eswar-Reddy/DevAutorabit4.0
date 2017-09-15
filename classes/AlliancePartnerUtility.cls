public with sharing class AlliancePartnerUtility {

    public static Id imuaId = Schema.SObjectType.Project_Installation_Setting__c.getRecordTypeInfosByName().get('IM User Assignment').getRecordTypeId();
    public static Id ipuaId = Schema.SObjectType.Project_Installation_Setting__c.getRecordTypeInfosByName().get('IP User Assignment').getRecordTypeId();
    public static Id papId = Schema.SObjectType.Alliance_Partner__c.getRecordTypeInfosByName().get('Project Alliance Partner').getRecordTypeId();
	public static Id capId = Schema.SObjectType.Alliance_Partner__c.getRecordTypeInfosByName().get('Community Alliance Partner').getRecordTypeId();
    public static Boolean runFindOppTeamMember = TRUE;
 
    //Check if Partner Account is filled in the last Alliance Partner and Installation Model is populated on Project, check 'OppTeamComplete' flag on Project
    public static void finalPAcheck(List<Alliance_Partner__c> aps){
        List<Quote> qToUpdate = new List<Quote>();
        List<Id> rpList = new List<Id>();
        Map<Id, Residential_Project__c> rpMap = new Map<Id, Residential_Project__c>();
        for(Alliance_Partner__c ap : aps){
            rpList.add(ap.Residential_Project__c);
        }

        List<Residential_Project__c> projects = [SELECT Id, Quote__c, OppTeamComplete__c, Installation_Model__c, Installation_Model__r.Roles__c, (SELECT Id, Role__c, Partner_Account__c FROM Alliance_Partners__r WHERE Partner_Account__c != NULL) FROM Residential_Project__c WHERE Id IN: rpList AND Quote__c != NULL];
        for(Residential_Project__c rp : projects){
            if(rp.Installation_Model__c != NULL) {
                Set<String> roleSet = new Set<String>();  
                roleSet.addAll(rp.Installation_Model__r.Roles__c.split(';'));
                for(Alliance_Partner__c ap : rp.Alliance_Partners__r){
                    if(roleSet.contains(ap.Role__c)) roleSet.remove(ap.Role__c);
                }
                if(roleSet.size() == 0){
                    rp.OppTeamComplete__c = TRUE;
                    rpMap.put(rp.Id, rp);
                }
            }
        }
        update rpMap.values();
    }

    // Update Installation Partner on SPD projects. projectIp = Map<Residential Project Id, Partner Account Id>
    public static void updateSPDIP(Map<Id, Id> projectIP){
        List<Residential_Project__c> rpToUpdate = new List<Residential_Project__c>();

        for(Residential_Project__c rp : [SELECT Id, Installation_Partner__c FROM Residential_Project__c WHERE Id IN: projectIP.keyset()]){
            if(rp.Installation_Partner__c != projectIP.get(rp.Id)){
                rp.Installation_Partner__c = projectIP.get(rp.Id);
                rpToUpdate.add(rp);
            }
        }
        update rpToUpdate;
    }

    // Reassigns user roles when an Alliance Partner record gets deleted
    public static void IMUserAssignment(List<Id> projects){
        List<Residential_Project__c> projectList = [SELECT Id, Installation_Model__c, Customer_State__c, RecordType.Name, (SELECT Id, Role__c, Partner_Account__c FROM Alliance_Partners__r), (SELECT Id, User__c, Role__c FROM Project_Team_Members__r) FROM Residential_Project__c WHERE Id IN: projects];
        
        //List<Id> models   = new List<Id>();
        List<Id> partners   = new List<Id>();

        Map<Id, Map<String, Id>> memberMap         = new Map<Id, Map<String, Id>>();
        Map<Id, Project_Team_Member__c> ptmUpdateMap   = new Map<Id, Project_Team_Member__c>();

        for(Residential_Project__c p : projectList){
          //models.add(p.Installation_Model__c);
            if(p.RecordType.Name == 'TPS'){
                for(Alliance_Partner__c ap : p.Alliance_Partners__r){
                    partners.add(ap.Partner_Account__c);
                }
            }
        }

        List<Project_Installation_Setting__c> pis = [SELECT User__c, Role__c, Installation_Partner__c, Installation_Model__c, Partner_Role__c, State__c FROM Project_Installation_Setting__c WHERE RecordTypeId = : imuaId AND Installation_Partner__c IN: partners ];
        for(Residential_Project__c rp : projectList){
            for(Alliance_Partner__c ap : rp.Alliance_Partners__r){
                for(Project_Installation_Setting__c pi : pis){
                    if(pi.State__c != NULL && rp.Customer_State__c != NULL && pi.State__c.contains(rp.Customer_State__c) ){
                        if(ap.Role__c == 'TPS' && pi.Installation_Partner__c == ap.Partner_Account__c && pi.Partner_Role__c == ap.Role__c){
                            if(memberMap.containsKey(rp.Id)){
                                memberMap.get(rp.Id).put(pi.Role__c, pi.User__c);
                            }else{
                                memberMap.put(rp.Id, new Map<String, Id>{pi.Role__c => pi.User__c});
                            }
                        }else if(pi.Installation_Partner__c == ap.Partner_Account__c && pi.Partner_Role__c == ap.Role__c && pi.Installation_Model__c == rp.Installation_Model__c){
                            if(memberMap.containsKey(rp.Id)){
                                memberMap.get(rp.Id).put(pi.Role__c, pi.User__c);
                            }else{
                                memberMap.put(rp.Id, new Map<String, Id>{pi.Role__c => pi.User__c});
                            }
                        }
                    }
                }
            }
        }
        for(Residential_Project__c project : projectList){
            if(memberMap.containsKey(project.Id)){
                Map<String, Id> userAssignMap = memberMap.get(project.Id);
                for(Project_Team_Member__c ptm : project.Project_Team_Members__r){
                    if(userAssignMap.containsKey(ptm.Role__c) && ptm.User__c != userAssignMap.get(ptm.Role__c)){
                        ptm.User__c = userAssignMap.get(ptm.Role__c);
                        ptmUpdateMap.put(ptm.Id, ptm);
                    }
                }
            }
        }

        update ptmUpdateMap.values();
    }
    /*
    @Name        :  finsertOppTeamMember
    @description :  function to insert the OppTeamMember based on Alliance Partner.
    @parameters  :  Map<Id,Alliance_Partner__c> oldMap,MaP<Id,Alliance_Partner__c> newMap
    @returns     :  void
    */
       public static void finsertOppTeamMember (string TriggerAction,List<Alliance_Partner__c> lstAlliancePartner){
         
         if(runFindOppTeamMember){
           set<String> sTPSPartnerRole = new Set<string> {'IP','DRIP'};
             set<Id> IdAlliancePartner = new set <Id> ();
             Set<Id> lstPartnerAccountID = new set<Id> ();
             Map<Id,Map<Id,string>> mPartnerRoleMap = new Map<Id,Map<Id,string>>();
             List<OpportunityTeamMember> oppTeamMemberToDelete = new List<OpportunityTeamMember>();
             List<OpportunityTeamMember> oppTeamMemberToInsert = new List<OpportunityTeamMember>();
             
             for(Alliance_Partner__c objAP : lstAlliancePartner){
                  if(sTPSPartnerRole.contains(objAP.Role__c)){
                        lstPartnerAccountID.add(objAP.Partner_Account__c);
                     }
              }
             
             map<Id,Id> mPartnerUser  = new Map<Id,Id> ();
             for(Project_Installation_Setting__c mInstallerPartner : [select Id,Installation_Model__c,
                                                                     Installation_Partner__c, Partner_Role__c, Name,
                                                                     Project_Template__c,RecordTypeId, Role__c,User__c,User__r.ContactId
                                                                     from Project_Installation_Setting__c
                                                                     where Installation_Partner__c IN:lstPartnerAccountID
                                                                     AND (RecordTypeId =:imuaId OR RecordTypeId =:ipuaId) AND User__r.ContactId <> Null]){

                    
                     mPartnerUser.put(mInstallerPartner.Installation_Partner__c,mInstallerPartner.User__c);
                   }

            
            system.debug('-------TriggerAction---------' + TriggerAction);   
            if(TriggerAction == 'Delete' || TriggerAction == 'Update'){
            
                 map<Id,Id> mRelatedOpp = new Map<Id,Id>();
                 map<Id,Alliance_Partner__c> mAlliancePartner = new Map<Id,Alliance_Partner__c>(); 
                 
                 for(Alliance_Partner__c objAP1 : [select Id,Partner_Account__c,Residential_Project__c,Role__c,Residential_Project__r.Opportunity__c from Alliance_Partner__c where Id IN:lstAlliancePartner ALL ROWS]) {
                           mRelatedOpp.put(objAP1.Id,ObjAP1.Residential_Project__r.Opportunity__c);
                           mAlliancePartner.put(objAP1.Id,ObjAP1);
                    }
                 
                 map<Id,Opportunity> mOppwithOppTeamMember = new map<Id,Opportunity>([select Id,Name,(select Id,UserId,User.Contact.AccountId,TeamMemberRole from OpportunityTeamMembers) from Opportunity where Id IN:mRelatedOpp.values()]);
                 
                 for(Alliance_Partner__c objAP2 : mAlliancePartner.values()){
                   if(mOppwithOppTeamMember <> null && objAP2.Residential_Project__r <> null && objAP2.Residential_Project__r.Opportunity__c <> Null && mOppwithOppTeamMember.ContainsKey(objAP2.Residential_Project__r.Opportunity__c)){
                      for(OpportunityTeamMember objOppTeamMem : mOppwithOppTeamMember.get(objAP2.Residential_Project__r.Opportunity__c).OpportunityTeamMembers){
                            if(objAP2.Role__c == objOppTeamMem.TeamMemberRole){
                                   oppTeamMemberToDelete.add(objOppTeamMem);
                                }
                           }
                       }    
                    }
                  // Delete the records. 
                    system.debug('---oppTeamMemberToDelete-----' + oppTeamMemberToDelete);  
                    if(oppTeamMemberToDelete <> Null && oppTeamMemberToDelete.size()>0){ 
                       OpportunityTeamMember_Trigger_Utility.bUIcheck = false;
                       Database.delete(oppTeamMemberToDelete);
                    } 
                }
                
              if(TriggerAction == 'Insert' || TriggerAction == 'Update') { 
                   for(Alliance_Partner__c objAP1 : [select Id,Partner_Account__c,Residential_Project__c,Role__c,Residential_Project__r.Opportunity__c from Alliance_Partner__c where Id IN:lstAlliancePartner]) {
                       if(objAP1.Residential_Project__r.Opportunity__c <> Null && mPartnerUser.containsKey(objAP1.Partner_Account__c)){
                       // insert OppTeamMember records.
                          OpportunityTeamMember temp= new OpportunityTeamMember(OpportunityId = objAP1.Residential_Project__r.Opportunity__c,UserId = mPartnerUser.get(objAP1.Partner_Account__c),TeamMemberRole = objAP1.Role__c);
                          oppTeamMemberToInsert.add(temp);
                         }  
                      }    
                 }
               system.debug('------oppTeamMemberToInsert------'+ oppTeamMemberToInsert);
               if(oppTeamMemberToInsert<> null && oppTeamMemberToInsert.size() > 0){
                   insert oppTeamMemberToInsert;
                 }
              

             }

         } 

    /*
    @Name        :  finsertIPPartnerForTPS
    @description :  function to insert the OppTeamMember based on Alliance Partner.
    @parameters  :  List <Alliance_Partner__c> newMap
    @returns     :  void
    */        

    public static void finsertIPPartnerForTPS (Map<Id,List<Alliance_Partner__c>> mPartnerWithResProject){
        Map<String, Id> zipMap = new Map<String, Id>();
        Id iprId = ResidentialProjectUtility.iprId; // RecordTypeId for 'IP Region' on Project Installation Settings
        // Querying all the zip codes mentioned in the Project Installation Setting  
        for(Project_Installation_Setting__c meta : [SELECT Id, Installation_Partner__c, Zip_Code__c FROM Project_Installation_Setting__c WHERE RecordTypeId =: iprId AND Zip_Code__c <> Null]){
            zipMap.put(meta.Zip_Code__c, meta.Installation_Partner__c);
        }
        // Looping through the alliance Partner and assign the IP based on Zip Range. 
        for(Residential_Project__c rp : [select Id,recordtype.Name,Customer_Zip__c from Residential_Project__c where Id IN :mPartnerWithResProject.Keyset()]){
            if(rp.RecordType.Name == 'TPS' && zipMap.containsKey(rp.Customer_Zip__c) && mPartnerWithResProject.get(rp.Id) <> Null){
                for(Alliance_Partner__c ap : mPartnerWithResProject.get(rp.Id)){
                    ap.Partner_Account__c = zipMap.get(rp.Customer_Zip__c);   
                }
            } 
        } 
    }          
}