public class purchaseOrderManagement{

    //Called before PO insert and update
    public static void beforeInsertUpdate(List<Purchase_Order__c> lstPONew){
        //Update SP week according to PO submit date
        updateSPWeek(lstPONew);
        if(System.isFuture() || System.isBatch() || System.isScheduled())
            updateAccountTerritory(lstPONew);//for case # 00048868
        else {
            Set<id> poIdsForFuture = new Set<Id>();
            for(Purchase_Order__c poc : lstPONew) {
                poIdsForFuture.add(poc.Id);
            }
            futureTerritorySharing(poIdsForFuture);
        }
    }
    
    @future
    public static void futureTerritorySharing(Set<Id> poIDs) {
        
        if(poIDs == null || poIds.isEmpty()) return;
        
        List<Purchase_Order__c> poList = new List<Purchase_Order__c>();
        poList = [SELECT Id, Dealer_Account__c, Account_Territory__c FROM Purchase_Order__c WHERE Id IN: poIds];
        
        if(poList == null || poList.isempty()) return;
        
        updateAccountTerritory(poList);
        
    }
    
    //Called before PO Delete
    //Updated 4/25/2016: PT #116006205 - Processed Orders Should not be deleted/edited
    public static void beforeDelete(List<Purchase_Order__c> lstPOOld){
        //Partner User is not allowed delete the PO after submitting to SunPower
        if(UserInfo.getUserType()=='PowerPartner'){
            for(Purchase_Order__c p : lstPOOld){
                if(p.Order_Status__c != 'New'){ //Updated From status of 'Submitted' to any status that is not 'New' per PT #116006205
                    p.Order_Status__c.AddError(System.Label.PODeleteError);
                }
            }
        }
    }
    //for case # 00053239
    //Called after PO Insert
    public static void afterInsert(List<Purchase_Order__c> listPO){
        //Start for Case# 00084238
        //insertSharing(listPO);
        Set<Id> poIdsForFuture = new Set<Id>();
        if(!System.isBatch() && !System.isFuture() && !System.isScheduled()) {
            for(Purchase_Order__c po: listPO) {
                poIdsForFuture.add(po.Id);
            }
            futurePOSharing(poIdsForFuture);
        }
        else
            insertSharing(listPO, false);
        //End for Case# 00084238
    }
    
	@Future	
    public static void futurePOSharing(Set<Id> poIds) {
        List<Purchase_Order__c> listPO = new List<Purchase_Order__c>([SELECT Id, Dealer_Account__c FROM Purchase_Order__c WHERE Id IN: poIds]);
        if(!listPO.isEmpty())
            insertSharing(listPO, true);
    }
    //for inserting sharing for all partner contact for particular account
    //Start for Case# 00084238  
    public static void insertSharing(List<Purchase_Order__c> listPO, Boolean isFuture){
        //List<Purchase_Order__c> listPO = [SELECT Id, Dealer_Account__c FROM Purchase_Order__c];
        System.debug('Debug: POList ' + listPO.size()); 
        Set<String> accountsIdSet = new Set<String>();
        Set<String> poIdSet = new Set<String>();
        for (Purchase_Order__c po : listPO) {
            if (po.Dealer_Account__c != null){
                accountsIdSet.add(po.Dealer_Account__c);
                poIdSet.add(po.Id);
            }            
        }
            
        Map<ID, Account> idToAccountMap = new Map<ID, Account>([SELECT Id, Name FROM Account WHERE Id IN :accountsIdSet]);
        Set<String> partnerRolesName = new Set<String>();
            
        for (Account acc : idToAccountMap.values())
                partnerRolesName.add(acc.Name + ' Partner User');        
            
        Map<ID, UserRole> idToRoleMap = new Map<ID, UserRole>([SELECT Id, PortalAccountId
                    FROM UserRole WHERE Name IN :partnerRolesName AND PortalAccountId IN :idToAccountMap.keySet()
                    AND PortalType = 'Partner']);
        Map<ID, ID> accountIdToRoleIdMap = new Map<ID, ID>();
        
        for (UserRole role : idToRoleMap.values())
            accountIdToRoleIdMap.put(role.PortalAccountId, role.Id);    
            
        List<Group> groupsList = [SELECT Id, RelatedId FROM Group WHERE RelatedId IN :idToRoleMap.keySet()];
        Map<ID, ID> roleIdToGroupIdMap = new Map<ID, ID>();
        
        for (Group g : groupsList)
            roleIdToGroupIdMap.put(g.RelatedId, g.Id);
            
        List<Purchase_Order__Share> sharingsList = new List<Purchase_Order__Share>();
            
        for (Purchase_Order__c po : listPO) {
            if (po.Dealer_Account__c != null && accountIdToRoleIdMap.get(po.Dealer_Account__c) != null
                && roleIdToGroupIdMap.get(accountIdToRoleIdMap.get(po.Dealer_Account__c)) != null) {
                
                Purchase_Order__Share sharing = new Purchase_Order__Share();
                sharing.ParentId = po.Id;
                sharing.UserOrGroupId = roleIdToGroupIdMap.get(accountIdToRoleIdMap.get(po.Dealer_Account__c));
                sharing.AccessLevel = 'Edit';
                sharing.RowCause = 'Manual';
                sharingsList.add(sharing);
            }
        }
        try{    
            insert sharingsList;
        }catch(DmlException ex){
            if(!isFuture)
                insertSharingFuture(poIdSet);
        }
        System.debug('Debug: sharingsList ' + sharingsList.size());
    }
    @future
    public static void insertSharingFuture (Set<String> poIdSet){
        insertSharing([Select Id,Dealer_Account__c from Purchase_Order__c where Id in :poIdSet], true);
    }
    //End for Case# 00084238
    //for case # 00053239
    //Update SP week according to PO submit date
    public static void updateSPWeek(List<Purchase_Order__c> lstPONew){       
          Date POSubmitDate;
          
          Set<String> setDates = new Set<String>();                        
          //for each purchase order
          for(Purchase_Order__c po : lstPONew){
          	
            //populate value in the field PO_Submit_Date_Text__c
            if(po.PO_Submit_Date__c != null && po.PO_Submit_SP_WW__c == null){//CRYSTAL - added check to see if null before processing
                
              POSubmitDate = Date.newInstance(po.PO_Submit_Date__c.year(), po.PO_Submit_Date__c.month(), po.PO_Submit_Date__c.day());
              po.PO_Submit_Date_Text__c = String.valueOf(POSubmitDate).replace('-', '');
                System.debug(po.PO_Submit_Date_Text__c);
            }               
            
            //create a set of PO submit dates      
            if(!setDates.contains(po.PO_Submit_Date_Text__c) && po.PO_Submit_Date_Text__c != null){
              setDates.add(po.PO_Submit_Date_Text__c);   
            }               
          }//end for loop

          if(setDates == null || setDates.isEmpty()) return;
              
          //query SP_Week__c for Text_Date__c and SP_week__c fields    
          List<SP_Week_Lookup__c> lstSPWeeks = new List<SP_Week_Lookup__c>();          
          lstSPWeeks = [select Id, Name, SP_Week__c, Text_Date__c from SP_Week_Lookup__c where Text_Date__c in :setDates];
          
          //create a map Map<String, String> with key as Text_Date__c and value as SP_Week__c
          Map<String, Double> mapSPWeeks = new Map<String, Double>();
          for(SP_Week_Lookup__c spWeekObj : lstSPWeeks){
            if(!mapSPWeeks.containsKey(spWeekObj.Text_Date__c)){
              mapSPWeeks.put(spWeekObj.Text_Date__c, spWeekObj.SP_Week__c);  
            }   
          }
          
          //for each purchase order get week number from the Map      
          for(Purchase_Order__c po : lstPONew){
            if(mapSPWeeks.containsKey(po.PO_Submit_Date_Text__c)){
              po.PO_Submit_SP_WW__c = mapSPWeeks.get(po.PO_Submit_Date_Text__c);           
            }
            else{
              po.PO_Submit_SP_WW__c = 0;   
            }       
          }//end for loop            
    
    }
    //for case # 00048868
    public static void updateAccountTerritory(List<Purchase_Order__c> listPO){
        Set<ID> accountsIdSet = new Set<ID>();
        Set<ID> userGroupSet = new Set<ID>();
        Set<ID> territorySet = new Set<ID>();
        List<AccountShare> accList = new List<AccountShare>();
        Map<Id, Group> grpList = new Map<Id, Group>();
        Map<Id, Territory> territoryList = new Map<Id, Territory>();        
        for(Purchase_Order__c po : listPO){
            if (po.Dealer_Account__c != null && po.Account_Territory__c == null)
                accountsIdSet.add(po.Dealer_Account__c);                
        }
        System.debug(loggingLevel.INFO, 'Account Set->'+accountsIdSet);     
        if(accountsIdSet.size()>0)
            accList = [SELECT AccountId, UserOrGroupId from AccountShare where AccountId in :accountsIdSet and RowCause in ('Territory','TerritoryManual') and IsDeleted = false];
        
        for(AccountShare ashare : accList){
            if (ashare.UserOrGroupId != null)
                userGroupSet.add(ashare.UserOrGroupId);
        }       
        System.debug(loggingLevel.INFO, 'Group Set->'+userGroupSet);
        if(userGroupSet.size()>0)
            grpList = new Map<Id, Group>([SELECT Id, RelatedId from Group where Id in :userGroupSet]);      
        for(Group grp : grpList.values()){
            if (grp.RelatedId != null)
                territorySet.add(grp.RelatedId);
        }
        System.debug(loggingLevel.INFO, 'Territory Set->'+territorySet);
        if(territorySet.size()>0)
            territoryList = new Map<Id, Territory>([SELECT Id, Name from Territory where Id in :territorySet]);
        System.debug(loggingLevel.INFO, 'Territory List->'+territoryList);
        for(Purchase_Order__c po : listPO){
            userGroupSet.clear();
            territorySet.clear();
            if (po.Dealer_Account__c != null && po.Account_Territory__c == null){
                for(AccountShare ashare : accList){
                    if (ashare.AccountId == po.Dealer_Account__c)
                        userGroupSet.add(ashare.UserOrGroupId);                 
                }
                for(Group grp : grpList.values()){
                    if (userGroupSet.contains(grp.Id))
                        territorySet.add(grp.RelatedId);
                }
                for(Territory tr : territoryList.values()){
                    if (territorySet.contains(tr.Id)){
                       
                       //START-Case # 00163040 - updated the condition to check if Contains instead of exact territoy name
                        //if(tr.Name == 'Bavaria Mid-Germany region')
                        if(tr.Name.contains('Mid Bavaria')){
                            po.Account_Territory__c = 'Bavaria Mid-Germany region';
                            break;
                        //START-Case # 00163040 - updated the condition to check if Contains instead of exact territoy name
                        //else if(tr.Name == 'North Germany region')
                        }else if(tr.Name.contains('North Germany')){
                            po.Account_Territory__c = 'North Germany region';                           
                            break;
                        }else{
                            po.Account_Territory__c = 'Other region';
                        }
                    }
                }                  
            }
        }
    }
    //for case # 00048868
  public static boolean fIsPurchaseOrderExistNewHomes(Id POID){
        List<Purchase_Order__c> po = [select Id,Opportunity__r.Plan_type__c,Opportunity__r.Lot_Number__c,Opportunity__r.Campaign.NH_Community__r.Id from Purchase_Order__c where Id = : POID Limit 1];
         system.debug('--debug 1--' + po);
         if( po <> Null && po.size() >0){
                system.debug('--debug 1.1--' + po[0].Opportunity__r.Campaign.NH_Community__r.Id); 
                List<Residential_Project__c> rp = [ select Id,Community__c,Plan_Type__c,Lot_Number__c,Purchase_Order__c 
                                              from Residential_Project__c where Lot_Number__c =:po[0].Opportunity__r.Lot_Number__c AND Community__c =: po[0].Opportunity__r.Campaign.NH_Community__r.Id];
                if(rp <> Null && rp.size() > 0 && rp[0].Purchase_Order__c <> null)
                   return true;  
             }
          return false;   
        }  
  // Calling agreement notification after PO Inserted for amended quote 
  public static void sendAmendedQuoteNotification(List<Purchase_Order__c> listPO){
       List<quote> listQuote = [ select Id,amended_Lease__c,
                     (select Id,change_Order_Type__c,echosign_dev1__Status__c from Agreements__r where change_Order_Type__c = 'Economic Amendment' AND echosign_dev1__Status__c = 'Signed')
                      from Quote where Id =:listPO[0].quote__c];
            if(!listQuote.isEmpty() && listQuote[0].amended_Lease__c <> null && listQuote[0].Agreements__r <> null && listQuote[0].Agreements__r.size()>0)
               agreementUtility.sendAgreementStatusNotification(new List<Id>{listQuote[0].Agreements__r[0].Id},listPO[0].Id);       
    }       
}