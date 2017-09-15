public class ContactManagement {

     static Set<String> setMarketingBulletin = new Set<String>{'Owner/President','Sales Manager','Field Sales Person','Marketing Manager','Finance Manager','Operations/Business Administrator'};
     static Set<String> setTechnicalBulletin =  new Set<String>{'Design/Engineering Manager','Installation Manager/Foreman/Crew Chief','Installation Crew Member'};
     
        
    public static void afterContactInsert(List<Contact> contactList){
        //populateSupervisorForLMSFunctionInsert(contactList);
        
        //Set Campaign for the Contact according to Promo Code
        setCampaign(contactList);
    }
    
    public static void afterContactUpdate (List<Contact> contactList, List<Contact> oldContactList)
    {
        //KCM_11092016: put the trigger.new and trigger.old lists into maps for easier manipulation later on
        Map<Id, Contact> newIdxContact_map = new Map<Id, Contact>(contactList);
        Map<id, Contact> oldIdxContact_map = new Map<Id, Contact>(OldContactList);
        List<Id> accountIDShortlist = new List<Id>();
        List<Post_Visit_Follow_Up_Survey__c> survey_list = new List<Post_Visit_Follow_Up_Survey__c>();
        List<Case> case_list = new List<Case>();
        
        //KCM_11092016: go through the list of Trigger.new and compare with Trigger.old records
        for (Contact c: contactList) {
            //KCM_11092016: check if the Email_Opt_Out__c field has been recently checked
            if (newIdxContact_map.get(c.Id).Email_Opt_Out__c == TRUE && 
                oldIdxContact_map.get(c.Id).Email_Opt_Out__c == FALSE) {
                accountIDShortlist.add(c.AccountId);
            }
        }
        
        //KCM_11092016: query list of surveys and cases related to shortlist of contacts 
        if (accountIDShortlist.size() > 0) {                      
            for (Post_Visit_Follow_Up_Survey__c s: [SELECT Id 
                                                    FROM Post_Visit_Follow_Up_Survey__c
                                                    WHERE Customer_Account__c IN :accountIDshortlist]) {      
                survey_list.add(s);
            }
            
            for (Case c: [SELECT Id 
                          FROM Case
                          WHERE AccountId IN :accountIDshortlist]) {      
                case_list.add(c);
            }
        }
        
        //KCM_11092016: if there are Post Visit Follow Up Survey records to be updated, do a dummy update on the records
        //so that the workflow rules for the object would re-evaluate
        if (survey_list.size() > 0) {
            update survey_list;
        }
        
        if (case_list.size() > 0) {
            update case_list;
        }
    
        //Populate LMS Supervisor Id
        populateSupervisorForLMSFunction(contactList,oldContactList);
        
        //Set Campaign for the Contact according to Promo Code
        setCampaign(contactList);
        
      //if the contact status is 'Terminated' 
      //delete all associated certifications
      Set<Id> setContactIds = new Set<Id>();
      
      for(Contact contactObj : contactList){
        if(contactObj.Terminated__c == true){
          setContactIds.add(contactObj.Id);                
        }
      }
      
      if(setContactIds.size() == 0){
        return;
      } 
    /*  
      List<Certification__c> lstCertifications = new List<Certification__c>();
      
      lstCertifications = [select Id, Name from Certification__c 
        where Contact__c in :setContactIds];
      
      if(lstCertifications.size() > 0){
        delete lstCertifications;
      }
     */ 
    }
    
    public static void beforeContactUpdate (Map<Id,Contact> contactMap, List<Contact> contactList)
    {
        //updateSubscription(contactMap,contactList);//temperory commented
        //Validate LMS Function
        //validateLMSFunction(contactList);
        setContactCountryDomain(contactMap,contactList);
    }
    
    public static void beforeContactInsert (Map<Id,Contact> contactMap,List<Contact> contactList)
    {
        //Validate LMS Function
        //validateLMSFunction(contactList);
        setContactCountryDomain(contactMap,contactList);
    }
    
    //Done for the case-00013120
    //Set Contact's country domain same as their Account's country domain
    public static void setContactCountryDomain(Map<Id,Contact> contactMap,List<Contact> contactList)
    {
        //Preapare set of Contact's Account IDs
        Set<ID> setAccountIDs = new Set<ID>();
        for(Contact c:contactList){
            setAccountIDs.Add(c.AccountID);
        }
        //Get all Accounts
        Map<ID,Account> mapAccount = new Map<ID,Account>([Select id,country_domain__c, Contact_Language__c from Account where ID in :setAccountIDs]);
        //Set Contact's country domain same as their Account's country domain
        for(Contact c:contactList){
            if(mapAccount.containsKey(c.AccountID) && c.country_domain__c != mapAccount.get(c.AccountID).country_domain__c){
                c.country_domain__c = mapAccount.get(c.AccountID).country_domain__c;
            }
            //Case 00767367 : if Contact's Contact_Language__c is empty and Account Contact_Language__c is not empty then save Account's contact language 
            if(mapAccount.containsKey(c.AccountID) && String.isEmpty(c.Contact_Language__c) && String.isNotEmpty(mapAccount.get(c.AccountID).Contact_Language__c)){ 
                c.Contact_Language__c= mapAccount.get(c.AccountID).Contact_Language__c; 
            }
        }
    }
    
    //Validate LMS Function
    public static void validateLMSFunction(List<Contact> contactList){
        //Prepare a set of Account
        Set<String> setAccount = new Set<String>();
        for(Contact c:contactList){
            if(c.LMS_Role__c=='B-Owner/Training Liaison' || c.LMS_Role__c=='TL-Training Liason'){
                setAccount.Add(c.AccountID);
            }
        }
        
        for(Account acc:[Select id,name,(Select id,LMS_Role__c from Contacts where LMS_Role__c='B-Owner/Training Liaison' or LMS_Role__c='TL-Training Liason') from Account where id in :SetAccount and isPartner=true]){
            List<Contact> lstC = new List<Contact>();
            lstC = acc.Contacts;
            if(lstC.size()>0){              
                lstC[0].LMS_Role__c.AddError('Only 1 contact may have have a B or TL LMS Function. You already have a contact with a B or TL LMS Function assigned to this account');
            }
        }
    }
    
    //Populate LMS Supervisor Id
   
    public static void populateSupervisorForLMSFunction(List<Contact> contactList,List<Contact> oldContactList){
        //prepare a set of ContactIDs
        Set<String> setContactIDs =new Set<String>();
        Map<ID, Contact> oldContactMap = new Map<ID, Contact>();
        for(Contact c:contactList){
            setContactIDs.Add(c.ID);
        }
        for (Contact c : oldContactList) {
           oldContactMap.put(c.Id, c);
        }
        
        //Prepare a map of ContactID with UserID and a map of ContactID with user's Plateau_Id
        map<String,String> mapContactUser = new map<String,String>();
        map<String,String> mapContactPlateau = new map<String,String>();
        for(User u:[Select id,ContactID,Plateau_Id__c from User where ContactID!=null and ContactID in :setContactIDs]){
            mapContactUser.put(u.ContactID,u.ID);
            mapContactPlateau.put(u.ContactID,u.Plateau_Id__c);
        }
        
        //map of Account with SuperUser and map of Account with Super user's Plateau_Id__c
        map<String,String> mapAccSuperUser = new map<String,String>(); 
        map<String,String> mapAccPlateau = new map<String,String>(); 
        //case#00087597
        List<Account> accountToUpdate = new List<Account>();
        //Contact record type
        String customerRecordTypeID = null;
        Schema.DescribeSObjectResult dc = Schema.SObjectType.Contact;
        Map<Id,Schema.RecordTypeInfo> contMapById = dc.getRecordTypeInfosById();
        for(ID i:contMapById.keySet()){
            if(contMapById.get(i).name=='Customer'){
                customerRecordTypeID = string.valueOf(i);
            }
        }
        
        for(Contact c:contactList){
            /*
            //Start of case#00087597
            //Update Account's address/Email/Phone same as customer contact address 
            if(c.RecordTypeId == customerRecordTypeID){
                Boolean isChange = false;
                Account acc = new Account(id=c.AccountID);
                //If address changed
                if(c.MailingCity != oldContactMap.get(c.ID).MailingCity 
                    || c.MailingCountry != oldContactMap.get(c.ID).MailingCountry
                    || c.MailingPostalCode != oldContactMap.get(c.ID).MailingPostalCode
                    || c.MailingState != oldContactMap.get(c.ID).MailingState
                    || c.MailingStreet != oldContactMap.get(c.ID).MailingStreet
                    ){
                    acc.billingCity=c.MailingCity;
                    acc.billingCountry=c.MailingCountry;
                    acc.billingPostalCode=c.MailingPostalCode;
                    acc.billingState=c.MailingState;
                    acc.billingStreet=c.MailingStreet;
                    isChange = true;
                }
                //If Email changed
                if(c.Email != oldContactMap.get(c.ID).Email){
                    acc.Email__c = c.Email;
                    isChange = true;
                }
                //If Phone changed
                if(c.Phone != oldContactMap.get(c.ID).Phone){
                    acc.Phone = c.Phone ;
                    isChange = true;
                }
                
                if(isChange){
                    accountToUpdate.add(acc);
                }
            }
            //End of case#00087597*/
            
            //for(Contact cOld:oldContactList){             
            Contact cOld = oldContactMap.get(c.Id);
                //if LMS function changed to B or TL
                if((c.LMS_Role__c=='B-Owner/Training Liaison' || c.LMS_Role__c=='TL-Training Liason') && (cOld.LMS_Role__c!='B-Owner/Training Liaison' && cOld.LMS_Role__c!='TL-Training Liason')){
                    if(mapContactUser.containskey(c.ID)){
                        mapAccSuperUser.put(c.AccountID,mapContactUser.get(c.ID));
                        mapAccPlateau.put(c.AccountID,mapContactPlateau.get(c.ID));
                    }
                }
                //if LMS function changed from B or TL to any other
                if((cOld.LMS_Role__c=='B-Owner/Training Liaison' || cOld.LMS_Role__c=='TL-Training Liason') && (c.LMS_Role__c!='B-Owner/Training Liaison' && c.LMS_Role__c!='TL-Training Liason')){
                    if(mapContactUser.containskey(c.ID) && !mapAccSuperUser.containskey(c.AccountID)){
                        mapAccSuperUser.put(c.AccountID,'');
                        mapAccPlateau.put(c.AccountID,'');
                    }
                }
            //}
        }
        
        //case#00087597
        if(accountToUpdate.size()>0){
            update accountToUpdate;         
        }
        
        if(mapAccSuperUser.size()==0){
            return;
        }
        Set<String> mapAccSuperUserID = new Set<String>();
        mapAccSuperUserID=mapAccSuperUser.keySet();
                
        updateAccSuperUser(mapAccSuperUserID,mapAccPlateau,mapAccSuperUser);
                        
    }
    
     @future
    public static void updateAccSuperUser(set <String> mapAccSuperUserID,map <String,String> mapAccPlateau,map <String,String> mapAccSuperUser){
         
        //Prepare list of users which needs to be updated
        List<User> lstUserToUpdate = new List<User>();
        //Get all Users of above Account
        //map<String,List<User>> mapAccUsers = new map<String,List<User>>();
        for(List<User> lst:[Select id,LMS_Supervisor_ID__c,Contact.AccountID from User where Contact.AccountID in :mapAccSuperUserID]){
            for(User u:lst){
                if(mapAccPlateau.get(u.Contact.AccountID)==''){
                    u.LMS_Supervisor_ID__c = '';
                    lstUserToUpdate.Add(u);
                }
                if(mapAccPlateau.get(u.Contact.AccountID)!='' && u.id != mapAccSuperUser.get(u.Contact.AccountID)){
                    u.LMS_Supervisor_ID__c = mapAccPlateau.get(u.Contact.AccountID);
                    lstUserToUpdate.Add(u);
                }
                else if(mapAccPlateau.get(u.Contact.AccountID)!='' && u.id == mapAccSuperUser.get(u.Contact.AccountID)){
                    u.LMS_Supervisor_ID__c = '';
                    lstUserToUpdate.Add(u);
                }
                if(lstUserToUpdate.size()>200){
                    
                    update lstUserToUpdate;
                    lstUserToUpdate.clear();
                }
            }
        }
                
        if(lstUserToUpdate.size()>0){
            
            update lstUserToUpdate;                 
        }   
    }
    
    //update contact subscription on the basis on contact user role
    //Marketing Bulletin Subscription to be set for these roles:
    //          Owner/President,Portal delegated Administrator;Sales Manager;
    //          Field Salesperson;Marketing Manager; Finance Manager, Operations Manager
    //Technical Bulletin Sunscription set to these roles:
    //          Design / Engineering Manager;Installation Manager / Foreman / Crew Chief;
    //          Installation Crew Members;
    /**************************
    public static void afterContactInsert(List<Contact> contactList){
        Set<Id> setMap = new Set<Id>();
        for(Contact con:contactList){
            System.debug('TEST@@@ : ' + con.Subscription__c +'  ' + con);
            if(con.Subscription__c == null){
                setMap.add(con.Id);
            }
        }
        if(setMap.Size()>0){
            updateSubscriptionOnInsertion(setMap,contactList);
        }   
    } 
     public static void updateSubscriptionOnInsertion(Set<Id> setMap, List<Contact> contactList){
            Boolean isMarketingBulletin = false;
            Boolean isTechnicalBulletin = false;
            List<Contact> newListContact = new List<Contact>();
            System.debug('TEST@@@@ 123 :: ' + setMap);
            Map<Id,String> mapContactRole = null;
            List<AccountContactRole> listContactRoles = new List<AccountContactRole>([Select Role, Id, ContactId From AccountContactRole where ContactId in:setMap]);
            if(listContactRoles.Size()>0){
                mapContactRole = new Map<Id,String>();
                for(AccountContactRole acr:listContactRoles){
                    String strSubscription ='';
                    if(setMarketingBulletin.contains(acr.Role) == true && isMarketingBulletin == false){
                        isMarketingBulletin = true;
                        
                    }
                    
                    if(setTechnicalBulletin.contains(acr.Role) && isTechnicalBulletin == false){
                        isTechnicalBulletin = true;
                    }
                    
                    System.debug('isMarketingBulletin TEST @@@@@ ' + isMarketingBulletin);
                    System.debug('isMarketingBulletin TEST @@@@@ ' + isTechnicalBulletin);
                    
                    if(isMarketingBulletin && isTechnicalBulletin){
                        mapContactRole.put(acr.ContactId, 'Technical Bulletin;Marketing Bulletin');
                    }
                    else if(isMarketingBulletin){
                        mapContactRole.put(acr.ContactId, 'Marketing Bulletin');
                    } 
                    else if(isTechnicalBulletin){
                        mapContactRole.put(acr.ContactId, 'Technical Bulletin');
                    }
                    
                }//for end
                System.debug('TEST@@@@ ::: ' + mapContactRole);
                
                if(mapContactRole.size()>0){
                    for(Contact con:contactList){
                        Contact conNew = new Contact(Id=con.Id); 
                        conNew.Subscription__c = mapContactRole.get(con.Id);
                        newListContact.add(conNew);
                        System.debug('TEST@@@@123 ::: ' + con.Subscription__c);
                    }
                }
                
                if(newListContact.Size()>0){
                    update newListContact;
                }
            }//if end
    }

    *******/
    public static void updateSubscription(Map<Id, Contact> contactMap, List<Contact> contactList){
            
            Boolean isMarketingBulletin = false;
            Boolean isTechnicalBulletin = false;
        
            System.debug('TEST@@@@ 123 :: ' + contactMap.keySet());
            Map<Id,String> mapContactRole = null;
            List<AccountContactRole> listContactRoles = new List<AccountContactRole>([Select Role, Id, ContactId From AccountContactRole where ContactId in:contactMap.keySet()]);
            if(listContactRoles.Size()>0){
                mapContactRole = new Map<Id,String>();
                for(AccountContactRole acr:listContactRoles){
                    String strSubscription ='';
                    if(setMarketingBulletin.contains(acr.Role) == true && isMarketingBulletin == false){
                        isMarketingBulletin = true;
                        
                    }
                    
                    if(setTechnicalBulletin.contains(acr.Role) && isTechnicalBulletin == false){
                        isTechnicalBulletin = true;
                    }
                    
                    System.debug('isMarketingBulletin TEST @@@@@ ' + isMarketingBulletin);
                    System.debug('isMarketingBulletin TEST @@@@@ ' + isTechnicalBulletin);
                    
                    if(isMarketingBulletin && isTechnicalBulletin){
                        mapContactRole.put(acr.ContactId, 'Technical Bulletin;Marketing Bulletin');
                    }
                    else if(isMarketingBulletin){
                        mapContactRole.put(acr.ContactId, 'Marketing Bulletin');
                    } 
                    else if(isTechnicalBulletin){
                        mapContactRole.put(acr.ContactId, 'Technical Bulletin');
                    }
                    
                }//for end
                System.debug('TEST@@@@ ::: ' + mapContactRole);
                
                if(mapContactRole.size()>0){
                    for(Contact con:contactList){
                        con.Subscription__c = mapContactRole.get(con.Id);
                        System.debug('TEST@@@@123 ::: ' + con.Subscription__c);
                    }
                }
            }//if end
    }
    
    //Set Campaign for the Contact according to Promo Code
    public static void setCampaign(List<Contact> ContactList){
        //Prepare set of promocdes of Contact and set of ContactIDs
        Set<String> setPromoCode = new Set<String>();        
        Set<String> setContactID = new Set<String>();
        for(Contact con:ContactList){            
            setContactID.Add(con.id);  
            if(con.Promo_Code__c!=null && con.Promo_Code__c!=''){
                setPromoCode.Add(con.Promo_Code__c);
            }                  
        }                               
        
        //Prepare map of promocode with campaigns 
        map<String,String> mapPromoCampaign = new map<String,String>();
        for(Campaign camp : [Select id,Promo_Code__c from Campaign where Promo_Code__c in :setPromoCode ]){
            mapPromoCampaign.put(camp.Promo_Code__c,camp.id);
        }  
        
        //Prepare set of Contact which already has campaign
        Set<String> setContactWithCampaign = new Set<String>();
        for(CampaignMember camp : [Select id,ContactID from CampaignMember where ContactID in :setContactID ]){
            setContactWithCampaign.Add(camp.ContactID);
        } 
        
        //list of CampaignMember to insert
        List<CampaignMember> lstCampaignMember = new List<CampaignMember>();
        
        //Traverse through each Contact record
        for(Contact ContactObj : ContactList){
            //Add campaign according to promo code of Contact if Contact does not have campaign assigned
            if(!setContactWithCampaign.contains(ContactObj.ID) && ContactObj.ID!=null){
                //If Campaign exist for promo code
                if(mapPromoCampaign.containskey(ContactObj.Promo_code__c)){
                    CampaignMember m = new CampaignMember(ContactID=ContactObj.ID,CampaignID=mapPromoCampaign.get(ContactObj.Promo_code__c));
                    lstCampaignMember.Add(m);
                }
            } 
            
            if(lstCampaignMember.size()>200){
                insert lstCampaignMember; 
                lstCampaignMember.clear();
            }
        } 
        
        //Insert CampaingnMembers
        if(lstCampaignMember.size()>0){
            insert lstCampaignMember; 
        }
    }
}