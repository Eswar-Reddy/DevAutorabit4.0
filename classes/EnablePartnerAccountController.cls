/*******************************************
** Created by - Harsh Mathur
** Created On- June 8 2009
** Last Modi by - 
** Last Modi On -  
** Vsrsion - 1.0
** Description- controller class for Enable_Partner_Account page
*************************************/
public class EnablePartnerAccountController{
  //properties    
  public transient List<Account> lstAccounts{get;set;}
  public Id partnerRecordTypeId{get;set;}
  public Boolean recordsToDisplay{get;set;}
  public Boolean isError{get;set;}
  public String selectedAccountIds{get;set;}
  public String errorMessage{get;set;}  
  public String currentAccountPartnerStatus{get;set;}
  public enum DisplayType {None, AllAccounts, PartnerAccounts, NonPartnerAccounts}
  public DisplayType accountDisplayType{get;set;}
  public boolean isDebug = false;  
  public List<Id> lstTestAccountIds=new List<Id>();
  
  
  //new Property for case -11835
   public String selectedViewValue{get;set;}
   public String exculdeContactsString{get;set;}
   public boolean nonPartnerContactExist{get;set;}
  //constructor
  public EnablePartnerAccountController(ApexPages.StandardController controller){    
    this.isError = false;
    this.errorMessage = '';
    this.recordsToDisplay = false;
    this.accountDisplayType = DisplayType.None;
    List<RecordType> lstrecordType = new List<RecordType>();
    
    //get record type
    lstRecordType = [select Id, Name from RecordType where Name = 'Partner' 
      and SobjectType = 'Account' Limit 1];
      
    if(lstRecordType.size() > 0){
      this.partnerRecordTypeId = lstRecordType[0].Id;
    }

  for (Account testAccount : [select Id from Account where Name like '%test%' limit 1000])
  {
      lstTestAccountIds.add(testAccount.Id);
  }
  
    //display all records on page load
    this.displayAllAccounts();    
  }
  
  //Constructor for Test
  public EnablePartnerAccountController(ApexPages.StandardController controller, Boolean isTest){    
    this.isError = false;
    this.errorMessage = '';
    isDebug = isTest;
    this.recordsToDisplay = false;
    this.accountDisplayType = DisplayType.None;
    List<RecordType> lstrecordType = new List<RecordType>();
    
    //get record type
    lstRecordType = [select Id, Name from RecordType where Name = 'Partner' 
      and SobjectType = 'Account' Limit 1];
      
    if(lstRecordType.size() > 0){
      this.partnerRecordTypeId = lstRecordType[0].Id;
    }

  for (Account testAccount : [select Id from Account where Name like '%test%'])
  {
      lstTestAccountIds.add(testAccount.Id);
  }
  
    //display all records on page load
    this.displayAllAccounts();    
  }

  //reloads data based on which option was selected
  public PageReference reloadData(){
    if(this.accountDisplayType == DisplayType.AllAccounts){
      return displayAllAccounts();
    }
    else if(this.accountDisplayType == DisplayType.PartnerAccounts){
      return displayPartnerAccounts();
    }
    else if(this.accountDisplayType == DisplayType.NonPartnerAccounts){
      return displayNonPartnerAccounts();
    }
    else{
      return null;
    }
  }
  
  //displays all accounts 
  public PageReference displayAllAccounts(){
    this.isError = false;    
    this.lstAccounts = new List<Account>(); 
    if(isDebug) {
    //changed for case-11835     
      for(Account a : [select Id, Name, isPartner,(select id,name,RecordType.Name from Contacts) from Account 
        where RecordTypeId = :partnerRecordTypeId and id not in :lstTestAccountIds
        order by Name desc Limit 1000]){
            this.lstAccounts.add(a);
        }
        //not 
   }else
    //changed for case-11835
      for(Account a : [select Id, Name, isPartner,(select id,name,RecordType.Name from Contacts) from Account 
        where RecordTypeId = :partnerRecordTypeId and id not in :lstTestAccountIds
        order by Name desc Limit 1000]){
            this.lstAccounts.add(a);
        }
       
          //not
    if(this.lstAccounts.size() > 0){
      this.recordsToDisplay = true;
    }
    this.accountDisplayType = DisplayType.AllAccounts;
    this.currentAccountPartnerStatus = 'All Accounts';       
    return null;
  }
  
 //displays only the partner accounts
  public PageReference displayPartnerAccounts(){
    this.isError = false;
    this.lstAccounts = new List<Account>();     
      for(Account a :[select Id, Name, isPartner,(select id,name,RecordType.Name from Contacts) from Account 
      where RecordTypeId = :partnerRecordTypeId and isPartner = true
        and id not in :lstTestAccountIds  
        order by Name desc Limit 1000]){
        this.lstAccounts.add(a);
        
      }
    /*this.lstAccounts = [select Id, Name, isPartner,(select id,name,RecordType.Name from Contacts) from Account 
      where RecordTypeId = :partnerRecordTypeId and isPartner = true
        and id not in :lstTestAccountIds  
        order by Name desc Limit 1000];    
     */   
    if(this.lstAccounts.size() > 0){
      this.recordsToDisplay = true;
    }
    
    this.accountDisplayType = DisplayType.PartnerAccounts;
    this.currentAccountPartnerStatus = 'Enabled Partner Accounts';
    return null;
  }
  
  //displays only the non partner accounts
  public PageReference displayNonPartnerAccounts(){
    this.isError = false;
    this.lstAccounts = new List<Account>();       
    this.lstAccounts = [select Id, Name, isPartner,(select id,name,RecordType.Name from Contacts) from Account 
      where RecordTypeId = :partnerRecordTypeId and isPartner = false
        and id not in :lstTestAccountIds 
        order by Name desc Limit 1000];    
    if(this.lstAccounts.size() > 0){
      this.recordsToDisplay = true;
    }
    this.accountDisplayType = DisplayType.NonPartnerAccounts;
    this.currentAccountPartnerStatus = 'Non-Enabled Partner Accounts';
    return null;
  }
  
  //returns a set of selected account ids
  public Set<Id> getSelectedAccountIdSet(){     
    Set<Id> setSelectedAccountIds = new Set<Id>();
    if(this.selectedAccountIds != null && this.selectedAccountIds != ''){
      String[] accountIds = this.selectedAccountIds.split(',', 0);
      for(String accId : accountIds){
        setSelectedAccountIds.add(accId);
      } 
    }
    return setSelectedAccountIds;
  }
  
  //enables account as partner (set isPartner = true)
  public PageReference enableAsPartner(){
    try{
      List<Account> lstSelectedAccounts = new List<Account>();    
      Set<Id> setSelectedAccountIds = new Set<Id>();
      setSelectedAccountIds = getSelectedAccountIdSet();
      if(setSelectedAccountIds.size() <= 0){
        return null;
      }      
      //select all accounts with record type Partner and isPartner = false
      lstSelectedAccounts = [select Id, Name, isPartner from Account 
        where Id in :setSelectedAccountIds and isPartner = false
        and id not in :lstTestAccountIds];
      if(lstSelectedAccounts.size() <= 0){        
        return null;
      }
      //set isPartner = true
      for(Account selAccount : lstSelectedAccounts){
        selAccount.isPartner = true;
      }
      update lstSelectedAccounts;  
      this.reloadData();    
    }
    catch(Exception ex){
      this.errorMessage = ex.getMessage();
      this.isError = true;      
      return null;
    }
    return null;
  }
  
  //create users for all contacts of selected accounts if not already created
  public PageReference enablePartnerPortalLogin(){    
    //list holds all the error messages, later displayed on the page
    List<String> lstErrors = new List<String>(); 
    List<Contact> lstContact = new List<Contact>();    
    List<User> lstUsers = new List<User>();
    Set<Id> setSelectedAccountIds = new Set<Id>();
    Map<Id, String> mapAccounts = new Map<Id, String>();
    List<UserRole> lstUserRole = new List<UserRole>();
    Map<String, Id> mapUserRole = new Map<String, Id>();        
    List<Set<Id>> lstSetUserIds = new List<Set<Id>>();
    lstSetUserIds.add(new Set<Id>());    
    Set<Id> excludedContactIdsSet = new Set<Id>();
    Id profileId = null;
    
    try{  
         
       
      setSelectedAccountIds = getSelectedAccountIdSet();      
      if(setSelectedAccountIds.size() <= 0){
        return null;
      }
      //new for 11835
      excludedContactIdsSet = getExcludedContactIdSet();
      System.Debug('Exculded Id set'+excludedContactIdsSet);
      
           //get profile
      List<Profile> lstProfile = new List<Profile>();
      lstprofile = [select Id, Name from Profile where 
        Name = 'Partner Delegated Administrator' Limit 1];
      if(lstProfile.size() > 0){
        Profile profileObj = lstProfile[0];
        profileId = profileObj.Id;
      }
     
      //get Role
      List<Account> lstAccount = new List<Account>();
      lstAccount = [select Id, Name from Account where Id in :setSelectedAccountIds];
      for(Account accountObj : lstAccount){
        mapAccounts.put(accountObj.Id, accountObj.Name + ' Partner User');
      }      
      
      lstUserRole = [select Id, Name from UserRole where Name in :mapAccounts.values()];
      for(UserRole userRoleObj : lstUserRole){          
        mapUserRole.put(userRoleObj.name, userRoleObj.Id);
      }
      
      Integer lstCount = 0;
      
      //List<id> contactIds = new List<Id>();
      
      for(User userObj : [select Id, ContactId from User 
        where ContactId != null]){         

    //if (contactIds.size()<1000)
    //  contactIds.add(userObj.ContactId);
              
        lstSetUserIds[lstCount].add(userObj.ContactId);
        if(lstSetUserIds[lstCount].size() == 1000){           
          lstSetUserIds.add(new Set<Id>()); 
          lstCount++;
        }        
      }               
      
      Database.DMLOptions dmo = new Database.DMLOptions();
      dmo.EmailHeader.triggerUserEmail = false;
      
    Integer i = 1;
      
      //Loop for creating user 
          
      for(Contact contactObj :[select Id, AccountId, FirstName, LastName, Email ,RecordType.name
        from Contact where Id not in :excludedContactIdsSet and accountId in :setSelectedAccountIds and 
          accountId not in :lstTestAccountIds and  
          FirstName != null and LastName != null and Email!=null
          limit 1000]){
           //delete not 
        //skip the contact whose corresponding user is already created
         
        if(isAlreadyCreated(contactObj.Id, lstSetUserIds)){
          continue;
        }
         
         
        User userObj = getUser(contactObj);
         
        /**
        User userObj = new User();
        
        userObj.FirstName = contactObj.FirstName;
        userObj.LastName = contactObj.LastName;
        userObj.ContactId = contactObj.Id;
        userObj.isActive = false;
        userObj.TimeZoneSidKey = 'America/Los_Angeles';
        userObj.LocaleSidKey = 'en_US';
        userObj.EmailEncodingKey = 'ISO-8859-1';
        userObj.LanguageLocaleKey = 'en_US';
        
        userObj.Email = contactObj.Email;                
        userObj.username = userObj.Email;        
        userObj.Alias = contactObj.FirstName.substring(0, 1) + contactObj.LastName.substring(0, 1);        
        userObj.communityNickname = userObj.username;        
        if(userObj.communityNickname != null && userObj.communityNickname.length() >40){
          userObj.communityNickname = userObj.communityNickname.substring(0,40);
        }
        **/
        //skip the contact if it has null or blank Email 
        if(contactObj.Email == null || contactObj.Email == ''){
          String error = 'Contact having invalid Email, cannot create User. ';
          error = error + 'First name: ' + contactObj.FirstName + ' Last name: ' + contactObj.LastName + ' \n';
          lstErrors.add(error);
          continue;
        }        
        
        
        
        if(profileId != null){
          userObj.profileId = profileId;
        }
         
        if(mapAccounts.containsKey(contactObj.AccountId)){
          String userRoleName = mapAccounts.get(contactObj.AccountId);
          if(mapUserRole.containsKey(userRoleName)){
            Id userRoleId = mapUserRole.get(userRoleName);
            userObj.UserRoleId = userRoleId;
          }
        } 
        lstUsers.add(userObj);
        if(lstUsers.size() == 1000){
      insert lstUsers;
            lstUsers = new List<User>();          
        }        
      }
      if(lstUsers.size() > 0){
        insert lstUsers;
      }
      
      if(lstErrors.size() > 0){
        for(String errorMsg : lstErrors){
          this.errorMessage = this.errorMessage + errorMsg;
        }
        this.isError = true;
        return null;
      }      
      this.reloadData();        
      dmo.EmailHeader.triggerUserEmail = true;  
    }
    catch(Exception ex){
      this.errorMessage = ex.getMessage();
      if(lstErrors.size() > 0){
        for(String errorMsg : lstErrors){
          this.errorMessage = this.errorMessage + errorMsg;
        }
      }
      this.isError = true;
      return null;
    }
    return null;
  }
  
  
  public User getUser(Contact contactObj){
    
        User userObj = new User();
        
        userObj.FirstName = contactObj.FirstName;
        userObj.LastName = contactObj.LastName;
        userObj.ContactId = contactObj.Id;
        userObj.isActive = false;
        userObj.TimeZoneSidKey = 'America/Los_Angeles';
        userObj.LocaleSidKey = 'en_US';
        userObj.EmailEncodingKey = 'ISO-8859-1';
        userObj.LanguageLocaleKey = 'en_US';
        
        userObj.Email = contactObj.Email;                
        //userObj.username = userObj.Email;
        userObj.username = userObj.Email +'.spwr';
        userObj.Alias = contactObj.FirstName.substring(0, 1) + contactObj.LastName.substring(0, 1);        
        userObj.communityNickname = userObj.username;        
        if(userObj.communityNickname != null && userObj.communityNickname.length() >40){
          userObj.communityNickname = userObj.communityNickname.substring(0,40);
        }
        
        return userObj;
  }
  
  public PageReference activatePartnerPortalUsers(){
    try{
      List<Account> lstAccounts = new List<Account>();          
      List<User> lstUser = new List<User>();      
      
      List<User> lstUserUpdate = new List<User>();
      Set<Id> setContactIds = new Set<Id>();
      Set<Id> setSelectedAccountIds = new Set<Id>();
      Set<Id> excludedContactIdsSet  = new Set<Id>();
      setSelectedAccountIds = getSelectedAccountIdSet();
      if(setSelectedAccountIds.size() <= 0){
        return null;
      }
      lstAccounts = [select Id, name from Account 
        where Id in :setSelectedAccountIds and isPartner = true];
        
      setSelectedAccountIds.clear();
      
      for(Account accountObj : lstAccounts){
        setSelectedAccountIds.add(accountObj.Id);
      }
      
       excludedContactIdsSet = getExcludedContactIdSet();
      System.Debug('Exculded Id set'+excludedContactIdsSet);
      
      for(User userObj : [select Id, Name, isActive 
        from User where isActive = false and ContactId != null and ContactId  not in:excludedContactIdsSet 
          and Contact.AccountId in :setSelectedAccountIds]){
            
        userObj.isActive = true;
        lstUserUpdate.add(userObj);
        if(lstUserUpdate.size() == 1000){
          update lstUserUpdate;
          lstUserUpdate = new List<User>();
        }        
      }
      if(lstUserUpdate.size() > 0){
        update lstUserUpdate;
      }      
      this.reloadData();   
    }
    catch(Exception ex){
      this.errorMessage = ex.getMessage();
      this.isError = true;
      return null;
    }
    return null;
  }
  
  
  public Boolean isAlreadyCreated(String contactId, List<Set<Id>> lstSetUserIds){
    Boolean created = false;
    for(Set<Id> setUserIds : lstSetUserIds){
      if(setUserIds.contains(contactId)){
        created = true;
        break;
      } 
    }   
    return created;
  } 
  
    //Function Created on July 27 2009 starts
   //Update Profile and Role of User as per Contact Fields
   //PR-02250 , 
   //Author: Appirio (Prakash G.)
    public PageReference updatePartnerProfilesRoles(){
      Set<Id> setSelectedAccountIds = new Set<Id>();
        setSelectedAccountIds = getSelectedAccountIdSet();
        Set<String> rolesAccount = new Set<String>(); 
        List<User> updatedUsers = new List<User>();
        if(setSelectedAccountIds.size() <= 0){
          return null;
        }
        Map<String,ID> profilesMap = getPartnerProfilesFromContact();
        Set<String> filteredUserIds = new Set<String>();
        for(User u: 
          [select id, UserRoleId, UserRole.Name, ProfileID, Profile.Name, 
            contactID, contact.AccountID,contact.Account.Name,contact.Role_Temp__c, 
            contact.Profile_Temp__c 
            from User u
            where user.contactID != null 
              and contact.AccountId in :setSelectedAccountIds
               and Profile.Name = 'Partner Delegated Administrator'
              
              and (
              
//              contact.Role_Temp__c != null
//              OR  
               contact.Profile_Temp__c != null) limit 1000
            ]){
              
          if(u.Contact.Role_Temp__c == null && u.Contact.Profile_Temp__c == null){
            //skipUserIds.add(u.Id);
            continue;
          }
          else if(u.UserRole.Name != u.Contact.Role_Temp__c || u.Profile.Name != u.Contact.Profile_Temp__c){
        filteredUserIds.add(u.id);
      }

       
      if(u.Contact.Role_Temp__c != null && u.Contact.Role_Temp__c != ''){
        rolesAccount.add(u.contact.Account.Name+' '+u.Contact.Role_Temp__c);  
      }
     
      
        }
        
        if(filteredUserIds.size()==0){
          return null;
        }
        Map<String,String> mapUserRoles = new Map<String,String>();
        
         
        for(UserRole uRole:[select id,name from UserRole where name in:rolesAccount]){
          mapUserRoles.put(uRole.Name,uRole.id);
        }
        
               
    //Now Update Here starts
    
    for(User u: [select id,UserRoleId,UserRole.Name,ProfileID,Profile.Name, 
      contactID,contact.AccountID,contact.Account.Name,contact.Role_Temp__c, 
      contact.Profile_Temp__c from User 
        where user.contactID != null 
          and contact.AccountId in :setSelectedAccountIds 
          and id in :filteredUserIds]){
      boolean modified =false;  
      

       
      if(u.Contact.Role_Temp__c!= null && u.UserRole.Name != u.Contact.Role_Temp__c){
        u.UserRoleId = mapUserRoles.get(u.contact.Account.Name+' '+u.Contact.Role_Temp__c);
        modified = true;
      }
 


      if(u.Contact.Profile_Temp__c!= null && u.Profile.Name != u.Contact.Profile_Temp__c){
        u.ProfileID = profilesMap.get(u.Contact.Profile_Temp__c);
        modified = true;
      }
      if(modified){
        updatedUsers.add(u);  
        modified =false;
      }      
      if(updatedUsers.size() >=999){
        update updatedUsers;
        updatedUsers.clear();
      }              
    }    
    if(updatedUsers.size() >=0){
      if(!isDebug) //For Test Case
        update updatedUsers;
    }
     return null;
    }
    
    //Fetch All Profiles related to PickList Value of Contact
    private Map<String,ID> getPartnerProfilesFromContact(){
      Map<String,ID> profilesMap = new Map<String,ID>(); 
      Set<String>listopt = new Set<String>();
      Schema.DescribeFieldResult F;
      List<Schema.PicklistEntry> P;
      F = Contact.Profile_Temp__c.getDescribe();
      P = F.getPicklistValues();
      for(Schema.PicklistEntry entry : P){   
        listopt.add(entry.getValue());    
      }
      if(listopt != null && listOpt.size()>0){
        for(Profile prof:[select id,Name from Profile where name in :listOpt]){
          profilesMap.put(prof.Name,prof.id);  
        }
      }  
    return profilesMap;
    }
    
  
  /**********Function Created on July 27 2009 **************/
  /********** Function Created on Nov 15 ******************/
  
  
  public PageReference changeSelectedView(){
      return (selectedViewValue == null ||selectedViewValue == '' )? null : (selectedViewValue == '1')? displayAllAccounts():(selectedViewValue == '2')? displayPartnerAccounts() : displayNonPartnerAccounts();
  }  
  
  //return excluded contacts for partner 
   public Set<Id> getExcludedContactIdSet(){     
    Set<Id> setExcludedContactIds = new Set<Id>();
    System.debug('Exculded String'+this.exculdeContactsString);
    if(this.exculdeContactsString!= null && this.exculdeContactsString!= ''){
      String[] contactIds = this.exculdeContactsString.split(';', 0);
      System.Debug('Exculded Contacts '+contactIds);
      for(String conId : contactIds ){
        setExcludedContactIds.add(conId);
      } 
    }
    return setExcludedContactIds;
  }
  
  public void checkPartnerContact(){
  System.Debug('in check method');
  
   Set<Id> setSelectedAccountIds = getSelectedAccountIdSet();      
     
      //new for 11835
     set<Id> excludedContactIdsSet = getExcludedContactIdSet();
      System.Debug('Exculded Id set'+excludedContactIdsSet);
      
  List<Contact> contactList =[select Id, AccountId, FirstName, LastName, Email ,RecordType.name
        from Contact where Id not in :excludedContactIdsSet and accountId in :setSelectedAccountIds and 
          accountId not in :lstTestAccountIds and  
          FirstName != null and LastName != null and Email!=null and RecordType.Name != 'Partner'
          limit 1000];
  if(ContactList.size()>0){
      nonPartnerContactExist = true;
      System.debug('nonPartnerContactExist '+nonPartnerContactExist );
  }else{
      nonPartnerContactExist = false;
  }        
 }         
   
}