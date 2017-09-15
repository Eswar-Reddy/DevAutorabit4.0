//*********************************************************************
//Name : ManageContactRoles
//Created On : 1st May, 2009
//Created By : Appirio (Aslam Bari)
//Implementation:
//Provide a quick interface to add multiple contact roles to account
//**********************************************************************

public class ManageContactRoles{
   private final Account account = null; 
  List<SelectOption> lstContactOptions = new List<SelectOption>();
  List<ContactRole> lstContactRole = new List<ContactRole>();
  
  
  //--------------------------------------------------------------------//
  //Constructor,loads the Contacts for the Account and AccountContactRoles
  //-------------------------------------------------------------------//
  public ManageContactRoles(ApexPages.StandardController stdController) {
    account = (Account)stdController.getRecord();
    LoadContacts(); 
    LoadAccountContactRole();
    
    //show blank 5 more rows
    AddMoreRoles(); 
  }

  //--------------------------------------------------------------------//
  //Load All Contact Role associated with the Account and wrap them into our custom wrapper
  //-------------------------------------------------------------------//  
  private void LoadAccountContactRole() {
    for(AccountContactRole actContactRole :[select ContactId,IsPrimary,Role from
                                             AccountContactRole where AccountId = :account.Id]) {
      lstContactRole.add(new ContactRole(actContactRole));  
    }   
  }

  //--------------------------------------------------------------------//
  //Load All Contacts and wrap them into SelectOption object
  //-------------------------------------------------------------------//    
  private void LoadContacts() {
    lstContactOptions.add(new SelectOption('',System.Label.POWizardNonePicklistValue));
    for(List<Contact> lstContact :[select Name from Contact 
                                   where AccountId = :account.Id order by Name]) {
      for(Contact contact :lstContact) {
        lstContactOptions.add(new SelectOption(contact.Id,contact.Name));
      }                                 
    }
  }

  //--------------------------------------------------------------------//
  //All the custom wrapper objects
  //-------------------------------------------------------------------//    
  public List<ContactRole> getAllContactRoles() {
    return lstContactRole;
  }
  
  //--------------------------------------------------------------------//
  //All of the Account Contacts as select List
  //-------------------------------------------------------------------//      
  public List<SelectOption> getContactOptions() {
    return lstContactOptions;
  }
  
  //--------------------------------------------------------------------//
  //Adds 5 rows of AccountContact Role.
  //-------------------------------------------------------------------//        
  public PageReference AddMoreRoles() {
    for(Integer i = 0; i < 5;i++) {
      lstContactRole.add(new ContactRole(new AccountContactRole(AccountId = this.account.Id)));     
    }
    return null;
  }

  //--------------------------------------------------------------------//
  //Insert,Update,Delete the changes.
  //-------------------------------------------------------------------//        \  
  public PageReference SaveRoles() {
    List<AccountContactRole> lstAccountRole = new List<AccountContactRole>();
    List<AccountContactRole> lstDeleteAccountRole = new List<AccountContactRole>();
    Set<string> setContactRoleCombination = new Set<string>();
    
    if(isMultiplePrimary()){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Only one contact role can be the primary.'));
        return null;
    }
    
    
    for(ContactRole role :this.lstContactRole) {
    	system.debug('&&&&&&&&&&&& Contact ID ))))))))))) '+role);
    	role.accountContactRole.contactId = role.CID;
    	//role.accountContactRole.ContactId = selectedContactId;
      //If both ContactId and Role is null,do nothing and proceed.
      if(role.CID == null && role.accountContactRole.Role == null) {
        continue;
      }
        
      //If role is Deleted and this record is coming from db.   
      if(role.IsDeleted && role.AccountContactRole.Id != null) {
        lstDeleteAccountRole.add(role.AccountContactRole);
        continue;
      } 
      
      if(!role.IsDeleted && role.CId == null) {
        //The red border color is shown on the UI using VF code because this is not
        //an input Field won't show the red border.
        role.AccountContactRole.ContactId.addError('Please select a Contact');
        return null;
      } 
      if(!role.IsDeleted && role.AccountContactRole.Role == null) {
        role.AccountContactRole.Role.addError('Please select a Role');
        return null;
      }       
      
      //Role is Not deleted.
      if(!role.IsDeleted) { 
        
        //check if the role and contactId combination already exists.
        //this check is required because Salesforce doesn't allow the same
        //contact with same role added. 
        string key = role.CId + '-' + role.AccountContactRole.Role;
        if(setContactRoleCombination.contains(key)) {   
          //match found 
          role.AccountContactRole.Role.addError('Contact has already been added in that Contact Role');
          return null;  
        }
        //add the key for checking further in the loop.
        setContactRoleCombination.add(key);
        lstAccountRole.add(role.accountContactRole);    
      }  
    }
    
    //Do the delete,insert,update operation after all validation.
    try {
      delete lstDeleteAccountRole;
      upsert lstAccountRole;
    }
    catch(Exception ex) {
      ApexPages.addMessages(ex);
      return null;
    }
    
    return new PageReference('/' + account.Id);
  }
  
  private boolean isMultiplePrimary(){
      Integer count = 0;
      for(ContactRole role :this.lstContactRole) {
          if(role.accountContactRole.IsPrimary){
              count++;
          }
      }
      if(count > 1){
          return true;
      }
      return false;
  }
  
  
  //------------------------------------------------------------------------// 
  //Wrapper class for holding IsDeleted field the Account Contact Role obj.
  //------------------------------------------------------------------------//
  public class ContactRole {
    public Boolean IsDeleted {get;set;}
    public AccountContactRole accountContactRole {get;set;}
    public String CID{get;set;}
    
    public ContactRole(AccountContactRole role) {
      this.IsDeleted = false;   
      this.accountContactRole = role;
      this.CID=role.ContactID;      
    }
  }
  
}