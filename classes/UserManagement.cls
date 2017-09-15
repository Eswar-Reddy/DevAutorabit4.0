/*
    Class :        UserManagement
    Created by :   Appirio (Prakash G.)
    Modified Date: 08 May 2009
    Calling :      From User Triggers
    Purpose:       Creating Sharing (Apex Managed Sharing for Contact and Account)
*/


public class UserManagement {
    
    public static Boolean IS_TEST = false; 
    
    //Case#00112468
    public static set<String> partnerStoreProfile = new set<String>{'EU Partner Delegated Administrator',
                                                                    'EU Partner Executive','EU Partner Operations',                                                                    
                                                                    'EU Residential Installer'}; 
    //Start for case #00068206
    public static void sendMailtoPSR (List<User> newUserList, Map<Id, User> oldUserMap){
        Set<Id> userIds = new Set<Id>();
        Set<Id> oppOwnerIds = new Set<ID>(); 
        for(User user : newUserList){
            if(oldUserMap != null && oldUserMap.get(user.Id).IsActive != user.IsActive 
                && user.IsActive == false && user.UserType == 'PowerPartner')
                userIds.add(user.Id);
                
        }
        //Change for Case:00074207
        for(Opportunity opp:[select id,name,OwnerId from Opportunity where OwnerId in :userIds]){
           oppOwnerIds.add(opp.OwnerId);
           
        }
        
        if(userIds.size() == 0 || oppOwnerIds.size() == 0) return;
        
                
        List<Messaging.SingleEmailMessage> lstMail = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail;        
        for(Contact cont : [SELECT id, Account.Name, Account.RSM__r.Email, Account.Primary_PSR__r.Name, Account.Primary_PSR__r.Email, Partner_Portal_User__c, Partner_Portal_User__r.Name  FROM Contact where Partner_Portal_User__c in : userIds and accountId!=null]){            
            //Change for Case:00074207
            if(!oppOwnerIds.contains(cont.Partner_Portal_User__c))
                continue;
            mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[]{cont.Account.RSM__r.Email,cont.Account.Primary_PSR__r.Email}); //Added for case#00200583            
            if(SalesforceOrgUtils.isPRoductionOrg())
             mail.setCcAddresses(new String[]{'raul.gutierrez@sunpowercorp.com', 'Tom.Dowley@sunpowercorp.com'});
                
            else{
               mail.setCcAddresses(new String[]{'raul.gutierrez@sunpowercorp.com', 'Tom.Dowley@sunpowercorp.com'});
//mail.setBccAddresses(new String[]{'jkothari@appirio.com'});//Removed this for case#00200583
           
            }
            mail.setSaveAsActivity(false);
            mail.setSubject('Inactive User Alert!');
            String body = '<HTML><body><table width="100%" cellspacing="0" cellpadding="0"><tr> <td style="background-color:#000;">' +
                            '<img id="Picture 1" alt="SunPower" style="width: 733px; height: 67px" src="http://www.clicktools.com/dashboard/org/sunpower/images/sunpower2.jpg" />' +
                            '</td></tr></table><br/><br/><font face="times, serif">'+ cont.Account.Primary_PSR__r.Name +
                            ',<br/><br/>You are listed as the primary PSR on Dealer account '+ cont.Account.Name +
                            '. ' +cont.Partner_Portal_User__r.Name+
                            ' from the dealer has been de-activated.<br/><br/>'+
                            '<b><font color="Red">Please make sure all the Opportunities and Accounts for '+cont.Partner_Portal_User__r.Name+
                            ' are transferred to an active user at the dealer.</font></b>'+
                            '<br/><br/>Please contact the help desk if you have questions or need help with mass re-assignment.</font></Body></HTML>';
            mail.setHtmlBody(body);
            lstMail.add(mail);
        }
        if(!lstMail.isEmpty()){
               System.debug('******************EMAIL SIZE************' + lstMail.size());
               try{
                   Messaging.sendEmail(lstMail);
               }catch(Exception ex){
                System.debug('******************Exception************' + ex);
               }
          }
    }
    //End for case #00068206
    
    @future
    public static void afterUserInsert (Set<string> userIDs){
        
        /*x get a list of active users */
        List<User> userList = 
            [select ID, UserType,LMS_Id__c, ContactID, Profile.Name, 
                Contact.Account.Name,
                Contact.Account.IsPartner, isActive  
                from User 
                where id in :userIDs];
               
        //SharePartnerContact(userList);
        SharePartnerAccount(userList);        
        updateContact(userList);                                 
    }       
    
    //Change from Plateau_Id__c to LMS_Id__c for CornerStone
    //Set Plateau_Id__c field   
    //@future   
    public static List<User> afterUserInsertSetPlateau(Set<string> userIDs){
        List<User> lstUser = 
            [select ID, UserType,LMS_Id__c, ContactID, Profile.Name, 
                Contact.Account.Name,
                Contact.Account.IsPartner, isActive  
                from User 
                where id in :userIDs];
                
        //List of users to be updated
        List<User> userToUpdate = new List<User>();
        system.debug('++stage1++');
        //Traverse through each User record coming for insertion
        for(User u:lstUser){ 
        system.debug('++stage2++'+u);       
            //If Plateau_Id__c is blank and user is partner user then fill it with user ID
            if(u.userType=='PowerPartner' && (u.LMS_Id__c==null || u.LMS_Id__c=='')){                
                system.debug('++stage3++');
                User newUser = new User(id=u.id);
                //User newUser = lstUser.get(u.id);
                newUser.LMS_Id__c = String.valueOf(u.id);
                userToUpdate.Add(newUser);
            }
            //Update user
            if(userToUpdate.size()>200){            
                update userToUpdate;
                userToUpdate.clear();
            }
        }
        //Update user
        if(userToUpdate.size()>0){  
        system.debug('++stage1++');      
            update userToUpdate;                        
        }
        
        return lstUser;
    }
    
    /* @future
    public static void afterUserUpdate (Set<ID> userIDs){                       
        List<User> userList = 
            [select ID, UserType, ContactID, Profile.Name, 
                Contact.Account.Name,
                Contact.Account.IsPartner, isActive  
                from User 
                where id in :userIDs];                        
        updateContact(userList);        
    }  */ 
    
    public static void beforeUserInsert(List<User> Users){
        //Start 00112468
        populateUserField(Users, null);
        //End 00112468
    }
    
    public static void beforeUserUpdate(List<User> Users, Map<ID,User> mapOldUser){
        //Start 00112468
        populateUserField(Users, mapOldUser);
        //End 00112468
    }
    
    public static void populateUserField(List<User> Users, Map<ID,User> mapOldUser){
        //Start 00112468
        Map<ID,Profile> mapProfile = new Map<ID,Profile>([Select id,name from profile where userType='PowerPartner']);
        for(User u: Users){
            //If user profile is in PartnerStore profiles then set store visibility true
            if(mapProfile.containsKey(u.profileID) && partnerStoreProfile.contains(mapProfile.get(u.profileID).Name)){
                u.Partner_Store_Visible__c = true;
            }   
            //If user profile is chnaged to profile other than PartnerStore profiles then set store visibility false
            else if(mapOldUser!=null && mapProfile.containsKey(u.profileID) && !partnerStoreProfile.contains(mapProfile.get(u.profileID).Name)
            && mapProfile.containsKey(mapOldUser.get(u.ID).profileID) && partnerStoreProfile.contains(mapProfile.get(mapOldUser.get(u.ID).profileID).Name)){
                u.Partner_Store_Visible__c = false;
            }        
        }
        //End 00112468
    }
    
    //Populate LMS Supervisor Id   
    @future 
    public static void populateSupervisorID(Set<string> userIDs){
        List<User> userList = afterUserInsertSetPlateau(userIDs);
        /*List<User> userList = [select ID, UserType,Plateau_Id__c, ContactID, Profile.Name, 
                Contact.Account.Name,
                Contact.Account.IsPartner, isActive  
                from User 
                where id in :userIDs];*/
                        
        //Prepare a map of ContactIDs of partner user
        Set<String> setContact = new Set<String>();
        for(User u:userList){       
            if(u.userType == 'PowerPartner' && u.contactId != null){                
                 setContact.Add(u.contactId);
            }
        }
        //Return if no partner user
        if(setContact.size()==0){       
            return;
        }
        
        //Prepare set of AccountIDs of user contacts
        map<String,String> mapContactAccount = new map<string,String>();
        for(Contact c:[Select id,AccountID from Contact where id in :setContact]){          
            mapContactAccount.put(c.ID,c.AccountID);
        }
                
        //Get all Contacts for a Account and map of Account with Super user's Plateau_Id__c     
        map<String,String> mapAccWithSuperUser = new map<String,String>();
        map<String,String> mapAccPlateau = new map<String,String>();
        List<List<User>> allUsers = new List<List<User>>();     
        for(List<User> uList:[Select id,contact.AccountID,LMS_Id__c,Contact.LMS_Role__c,LMS_Supervisor_ID__c from User where contact.AccountID in :mapContactAccount.values()]){ 
            List<User> lstU = new List<User>();         
            for(User u:uList){
                lstU.Add(u);
                if(u.Contact.LMS_Role__c=='B-Owner/Training Liaison' || u.Contact.LMS_Role__c=='TL-Training Liason'){
                    mapAccWithSuperUser.put(u.contact.AccountID,u.ID);
                    mapAccPlateau.put(u.contact.AccountID,u.LMS_Id__c);
                }
            }
            allUsers.Add(lstU);           
        }
        
        //List of Users to be updated 
        List<User> lstUserToUpdate = new List<User>();
        for(List<User> uList:allUsers){         
            for(User u:uList){
                if(mapAccWithSuperUser.containsKey(u.Contact.AccountID)){
                    if(u.LMS_Supervisor_ID__c != mapAccPlateau.get(u.Contact.AccountID)&& mapAccWithSuperUser.get(u.Contact.AccountID)!=u.ID){
                        u.LMS_Supervisor_ID__c = mapAccPlateau.get(u.Contact.AccountID);
                        lstUserToUpdate.Add(u);                        
                    }
                }
                else if(u.LMS_Supervisor_ID__c != ''){
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
        system.debug('++LMS call++');      
            update lstUserToUpdate;                   
        }
                        
    }
    
    // Allow partner user to edit his own partner account       
    public static void SharePartnerAccount(List<User> userList){
        List <AccountShare> accShares = new List<AccountShare>();
        boolean doUpdate = false;
        Map<String,ID> roleGrpMap = new Map<String,ID>();
        Map<ID,String> acctNames = new Map<ID,String>();
        //// get a map of account id and partner executive roles          
        for(User user:userList){
            if(user.Contact.Account.IsPartner && user.UserType == 'PowerPartner'){
                //acctNames.put(user.Contact.Account.ID, user.Contact.Account.Name + ' Partner Executive');
                String accName = user.Contact.Account.Name.length() > 62? user.Contact.Account.Name.subString(0,62):user.Contact.Account.Name;
                acctNames.put(user.Contact.Account.ID, accName + ' Partner Executive');
            }
        }
        
        //Fetch related UserRoles
        Map<ID,UserRole> userRolesMap  = null;
            userRolesMap = new Map<ID,UserRole>
            ([select ID,Name from UserRole where Name in :acctNames.values() LIMIT 1000]);
        
        Map<String, AccountShare> accountSharesMap = new Map<String,AccountShare>();
        List<AccountShare> newShares = new List<AccountShare>();
        List<AccountShare> deletedShares = new List<AccountShare>();
        //Fetch related Group
        List<Group> grpList = [select ID,RelatedID from Group 
            where Type = 'RoleAndSubordinates' and relatedId in :userRolesMap.keySet()];
         
        //Fill Map with  Role Name and related Group Record 
        for(Group grp:grpList){
              UserRole uRole = (UserRole)userRolesMap.get(grp.relatedID);
              roleGrpMap.put(uRole.Name,grp.Id);
        }
        
        //Fill AccountSharesMap
        for(AccountShare share :[select ID,accountID,
            AccountAccessLevel,UserorGroupID,OpportunityAccessLevel 
            from AccountShare where UserorGroupID in :userRolesMap.keySet() and accountID != null]){
            String name= acctNames.get(share.accountID);
            if(name != null)
                accountSharesMap.put(name,share);
        }
        
        for(ID id:acctNames.keySet()){
               String acctName= acctNames.get(id);
               AccountShare accountShare = accountSharesMap.get(acctName);
               if(accountShare == null){
                   accountShare= new AccountShare();
                   accountShare.accountID= id;
                   accountShare.AccountAccessLevel ='Edit';
                   accountShare.UserorGroupID =roleGrpMap.get(acctName);
                   accountShare.OpportunityAccessLevel = 'None'; 
                   //accountShare.ContactAccessLevel = 'Edit';
                   newShares.add(accountShare);
                   accountSharesMap.put(acctName,accountShare);
               }else{
                    if(accountShare.AccountAccessLevel !='Edit' || accountShare.OpportunityAccessLevel !='Edit'){
                        deletedShares.add(accountShare);
                        doUpdate =true;
                        AccountShare accShare= new AccountShare();
                        accShare.accountID= id;
                        accShare.AccountAccessLevel ='Edit';
                        accShare.UserorGroupID =roleGrpMap.get(acctName);
                        accShare.OpportunityAccessLevel = 'None'; 
                        //accShare.ContactAccessLevel = 'Edit';
                        
                        newShares.add(accShare);        
                    }
               } 
        }
        if(doUpdate && deletedShares.size()>0)
            delete deletedShares;
        //Update Here            
        if(newShares.size() >0){
           //insert newShares;
           newShares = removeDuplicates(newShares);
           if(newShares.size() >0)
                Database.insert(newShares,false);
        }              
        }//Function ends
        
        /*Update Contact Field Partner_Portal_User__c on User Update and Insert*/
        //RoleAndSubordinates
        public static void updateContact(List<User> userList){
            Map<ID,ID> userContacts = new Map<ID,ID>();
            List<Contact> updateConList = new List<Contact>();
            for(User u:userList){
                if(u.userType == 'PowerPartner' && u.contactId != null){
                    userContacts.put(u.contactId,u.id);
                }
            }
            if(userContacts.size()==0) return;
            
            for(Contact c:[select id, Partner_Portal_User__c 
                from Contact 
                where id in  :userContacts.keySet() 
                and Partner_Portal_User__c = null]){
                    
                c.Partner_Portal_User__c = userContacts.get(c.Id);
                
                updateConList.add(c);
                
                if(updateConList.size()>=200){
                    update updateConList;
                    updateConList.clear();  
                }        
                
            }
            
            if(updateConList.size()>0){
                update updateConList;
            }       
        }
        
        private static List<AccountShare>  removeDuplicates(List<AccountShare> accountShares){
            Set<String> existingShares = new Set<String>();
            List<AccountShare> filteredShares = new List<AccountShare>(); 
            String sep ='~';
            List<AccountShare> dups = new List<AccountShare>();
            for(AccountShare share :accountShares){
                System.debug('Here UserID::'+share.UserorGroupId+'::::AccountID:::'+share.AccountId);
                if(existingShares.contains(share.UserorGroupId+sep+share.AccountId)){
                    dups.add(share);
                }else{
                    existingShares.add(share.UserorGroupId+sep+share.AccountId);
                    filteredShares.add(share);
                }
            }

            return filteredShares;
        }
        
}