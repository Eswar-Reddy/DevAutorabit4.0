public with sharing class InstallerSharingUtil {


    public static void prepOpportunitySharing(List<Opportunity> newOppList, Map<Id,Opportunity> newOppMap,Map<Id,Opportunity> oldOppMap){

        Set<id> setInstallerid = new Set<id>();
         
        Map<ID,set<ID>> mapAccountInstaller = new Map<ID,set<ID>>();
        Map<ID,set<ID>> mapOppInstaller = new Map<ID,set<ID>>();
         
        Set<id> setAccountShareid = new Set<id>();
        Set<id> setOpportunityShareid = new Set<id>();
        
        Map<String,InstallerSharingCountries__c> iscMap = InstallerSharingCountries__c.getAll();
        
        for(Opportunity opp:newOppList){
            if((opp.Installer__c!=null && opp.Installer__c!=opp.AccountId && opp.Installer__c!=opp.PartnerAccountId && iscMap.containsKey(opp.Theater__c) && newOppMap.get(opp.Id).Installer__c!=oldOppMap.get(opp.Id).Installer__c) || (newOppMap.get(opp.Id).OwnerId!=oldOppMap.get(opp.Id).OwnerId && opp.Installer__c!=null)){

                Id installerID = null;
                if(opp.inStaller__r.Parent != null)
                    installerID = opp.inStaller__r.Parent.id;
                else
                    installerID = opp.Installer__c;

                setInstallerid.add(installerID);

                if(opp.AccountId!= null){ 
                    setAccountShareid.add(opp.AccountId);
                    if(mapAccountInstaller.containsKey(installerID)){
                        //set<ID> setID = mapAccountInstaller.get(installerID);
                        //setID.add(objQuote.Account__c);
                        //mapAccountInstaller.put(installerID,setID);
                        mapAccountInstaller.get(installerID).add(opp.AccountId);
                    }else
                        mapAccountInstaller.put(installerID,new set<id>{opp.AccountId});
                }

                setOpportunityShareid.add(opp.Id);
                if(mapOppInstaller.containsKey(installerID)){
                    //set<ID> setID = mapOppInstaller.get(installerID);
                    //setID.add(objQuote.OpportunityId);
                    //mapOppInstaller.put(installerID,setID);
                    mapOppInstaller.get(installerID).add(opp.Id);
                }else
                    mapOppInstaller.put(installerID,new set<id>{opp.Id});
                

            }
        }
        if(!setInstallerid.isEmpty())
            insertOpportunitySharing(setInstallerid,setOpportunityShareid,setAccountShareid,mapAccountInstaller,mapOppInstaller,false,'Edit');
    }



    public static void insertOpportunitySharing(Set<ID> setInstallerid,Set<Id> setOpportunityShareid,Set<Id> setAccountShareid,Map<ID,set<ID>> mapAccountInstaller, Map<ID,set<ID>> mapOppInstaller, boolean insertAccountShare, String opportunityAccessLevel){


        map<ID,set<ID>> mapAccountIDGroup = new map<ID,set<ID>>();
        Map<ID,UserRole> mapUserRole = new Map<ID,UserRole>([SELECT PortalAccountId,name,id FROM UserRole where PortalAccountId IN :setInstallerid and name like '%Partner User%']);
        //Map<ID,User> mapUser =new Map<ID,User>([Select id,UserRoleID from User where UserRoleID IN : mapUserRole.keySet()]);
        Map<ID,Group>  mapGroup = new Map<ID,Group>([Select g.Id,g.RelatedId From Group g where g.Type='Role' and g.RelatedId= :mapUserRole.keySet()]);
         
        map<ID,list<AccountShare>> mapAccountShare = new map<ID,list<AccountShare>>();

        for(AccountShare objAccountShare : [Select id,accountID,UserorGroupID,AccountAccessLevel from AccountShare where accountID IN:setAccountShareid and UserorGroupID IN:mapGroup.keySet()]){
            if(mapAccountShare.containsKey(objAccountShare.accountID))
            {
                 list<AccountShare> listAccountShare = mapAccountShare.get(objAccountShare.accountID);
                 listAccountShare.add(objAccountShare);
                 mapAccountShare.put(objAccountShare.accountID,listAccountShare);
             }else
                 mapAccountShare.put(objAccountShare.accountID,new list<AccountShare>{objAccountShare});
         }

         map<ID,list<OpportunityShare>> mapOpportunityShare = new map<ID,list<OpportunityShare>>();

         for(OpportunityShare objOpportunityShare : [Select id,OpportunityId,UserorGroupID,OpportunityAccessLevel from OpportunityShare where OpportunityId IN:setOpportunityShareid and UserorGroupID IN:mapGroup.keySet()]){
             if(mapOpportunityShare.containsKey(objOpportunityShare.OpportunityId))
             {
                 list<OpportunityShare> listOpportunityShare = mapOpportunityShare.get(objOpportunityShare.OpportunityId);
                 listOpportunityShare.add(objOpportunityShare);
                 mapOpportunityShare.put(objOpportunityShare.OpportunityId,listOpportunityShare);
             }else
                 mapOpportunityShare.put(objOpportunityShare.OpportunityId,new list<OpportunityShare>{objOpportunityShare});
         }

         for(UserRole objUserRole : mapUserRole.values()){
            for(Group objGroup: mapGroup.values()){
                if(objGroup.RelatedId == objUserRole.Id){
             if(mapAccountIDGroup.containsKey(objuserRole.PortalAccountId))
             {
                 set<ID> setID = mapAccountIDGroup.get(objuserRole.PortalAccountId);
                 setID.add(objGroup.Id);
                 mapAccountIDGroup.put(objuserRole.PortalAccountId,setID);
             }else
                 mapAccountIDGroup.put(objuserRole.PortalAccountId,new set<id>{objGroup.Id});
         }
            }
         }
         System.debug('--------------+mapAccountIDGroup'+mapAccountIDGroup);
         System.debug('--------------+mapAccountInstaller'+mapAccountInstaller);

         List<AccountShare> listAccountShare = new List<AccountShare>();
         List<ContactShare> listContactShare = new List<ContactShare>();
         List<OpportunityShare> listOpportunityShare = new List<OpportunityShare>();

         for(ID idInstaller: mapAccountInstaller.keySet()){
             if(!mapAccountInstaller.isEmpty() && mapAccountInstaller.containsKey(idInstaller)){
             for(ID idAccount : mapAccountInstaller.get(idInstaller)){
                 if(!mapAccountIDGroup.isEmpty() && mapAccountIDGroup.containsKey(idInstaller)){
                 for(ID idGrup : mapAccountIDGroup.get(idInstaller)){
                    boolean isExstingAccountShare = false;
                    if(!mapAccountShare.isEmpty() && mapAccountShare.containsKey(idAccount)){
                        for(AccountShare objAccountShare : mapAccountShare.get(idAccount)){
                            if(!isExstingAccountShare && objAccountShare.accountID == idAccount 
                                    && objAccountShare.UserorGroupID == idGrup
                                        && objAccountShare.AccountAccessLevel == 'Read'){
                                    isExstingAccountShare = true;
                            }
                        }
                        System.debug('----------------------------isExstingAccountShare'+isExstingAccountShare);

                    }
                    System.debug('----------------------------isExstingAccountShare'+isExstingAccountShare);
                    if(!isExstingAccountShare){
                    AccountShare accountShare =  new AccountShare();
                    accountShare.accountID= idAccount;
                    accountShare.AccountAccessLevel ='Read';
                    accountShare.opportunityAccessLevel ='None';
                    accountShare.UserorGroupID =idGrup;
                    listAccountShare.add(accountShare);
                }
            }
        }
                 
                 }
             }
              
             
             if(!mapOppInstaller.isEmpty() && mapOppInstaller.containsKey(idInstaller)){
             for(ID idOpp : mapOppInstaller.get(idInstaller)){
                 if(!mapAccountIDGroup.isEmpty() && mapAccountIDGroup.containsKey(idInstaller)){
                     for(ID idGroup : mapAccountIDGroup.get(idInstaller)){
                        boolean isExstingOppShare = false;
                    if(!mapOpportunityShare.isEmpty() && mapOpportunityShare.containsKey(idOpp)){
                        for(OpportunityShare objOpportunityShare : mapOpportunityShare.get(idOpp)){
                            if(!isExstingOppShare && objOpportunityShare.OpportunityId == idOpp 
                                    && objOpportunityShare.UserorGroupID == idGroup
                                        && objOpportunityShare.OpportunityAccessLevel == opportunityAccessLevel){
                                    isExstingOppShare = true;
                            }
                        }
                        System.debug('----------------------------isExstingOppShare'+isExstingOppShare);

                    }
                    System.debug('----------------------------isExstingOppShare'+isExstingOppShare);
                    if(!isExstingOppShare){
                         OpportunityShare opportunityShare =  new OpportunityShare();
                         opportunityShare.OpportunityId= idOpp;
                         opportunityShare.OpportunityAccessLevel = opportunityAccessLevel;
                         opportunityShare.UserorGroupID =idGroup;
                         listOpportunityShare.add(opportunityShare);
                     }
                 }
             }
             }
         }



         }
         System.debug('------------------------listAccountShare'+listAccountShare);
         if(!listAccountShare.isEmpty() && insertAccountShare == true)
             insert listAccountShare;
         System.debug('------------------------listOpportunityShare'+listOpportunityShare);
         if(!listOpportunityShare.isEmpty())
             insert listOpportunityShare;
         

    }

    public static void deleteOpportunitySharing(List<Opportunity> newOppList, Map<Id,Opportunity> newOppMap,Map<Id,Opportunity> oldOppMap){
        Map<String,InstallerSharingCountries__c> iscMap = InstallerSharingCountries__c.getAll();
        List<Opportunity> delOppList = new List<Opportunity>();
        for(Opportunity opp:newOppList){
            if(newOppMap.get(opp.Id).Installer__c!=oldOppMap.get(opp.Id).Installer__c && oldOppMap.get(opp.Id).Installer__c!=null && iscMap.containsKey(opp.Theater__c))
                delOppList.add(oldOppMap.get(opp.Id));
        }
        
        if(!delOppList.isEmpty()){
        
        Set<id> setInstallerid = new Set<id>();
        Set<Id> oppIdSet = new Set<Id>();

        for(Opportunity opp:delOppList){
            oppIdSet.add(opp.Id);
            
            if(opp.inStaller__r.Parent != null)
                setInstallerid.add(opp.inStaller__r.Parent.id);
            else
                setInstallerId.add(opp.Installer__c);
        }

        map<ID,set<ID>> mapAccountIDGroup = new map<ID,set<ID>>();
        Map<ID,UserRole> mapUserRole = new Map<ID,UserRole>([SELECT PortalAccountId,name,id FROM UserRole where PortalAccountId IN :setInstallerid and name like '%Partner User%']);
        //Map<ID,User> mapUser =new Map<ID,User>([Select id,UserRoleID from User where UserRoleID IN : mapUserRole.keySet()]);
        Map<ID,Group>  mapGroup = new Map<ID,Group>([Select g.Id,g.RelatedId From Group g where g.Type='Role' and g.RelatedId= :mapUserRole.keySet()]);

        for(UserRole objUserRole : mapUserRole.values()){
            for(Group objGroup: mapGroup.values()){
                if(objGroup.RelatedId == objUserRole.Id){
             if(mapAccountIDGroup.containsKey(objuserRole.PortalAccountId))
             {
                 set<ID> setID = mapAccountIDGroup.get(objuserRole.PortalAccountId);
                 setID.add(objGroup.Id);
                 mapAccountIDGroup.put(objuserRole.PortalAccountId,setID);
             }else
                 mapAccountIDGroup.put(objuserRole.PortalAccountId,new set<id>{objGroup.Id});
         }
            }
         }

         
         Set<Id> UserorGroupIDSet = new Set<Id>();
         for(Opportunity opp:delOppList){
             if(mapAccountIDGroup.containsKey(opp.Installer__c))
            UserorGroupIDSet.addAll(mapAccountIDGroup.get(opp.Installer__c));
         }


        List<OpportunityShare> oppShareList = [select UserorGroupId,OpportunityId,RowCause from OpportunityShare where OpportunityId in :oppIdSet and UserorGroupID in :UserorGroupIDSet and RowCause='Manual'];

        List<OpportunityShare> oppSharedelList = new List<OpportunityShare>();

        for(Opportunity opp:delOppList){
            for(OpportunityShare oppShare:oppShareList){
                if(oppShare.OpportunityId==opp.Id && mapAccountIDGroup.containsKey(opp.Installer__c) && mapAccountIDGroup.get(opp.Installer__c).contains(oppShare.UserorGroupID))
                    oppSharedelList.add(oppShare);
            }
        }

        if(!oppSharedelList.isEmpty())
            delete oppSharedelList;
    }
    }

}