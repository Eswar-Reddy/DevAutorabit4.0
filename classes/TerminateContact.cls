/*
Class Name :- TerminateContact
Purpose:- Terminate the Contact from Account , used in TerminateContact VF.
Related PR:-PR-01633
Author:- Appirio (Prakash G.)
Date:- May 02, 2009
*/

public class TerminateContact{
    public Contact contact {get;set;}
    public Contact contID{get;set;}
    public string message {get;set;}
    public TerminateContact(ApexPages.StandardController stdController){
          contact = (Contact)stdController.getRecord();
          contact = [select FirstName,LastName,Terminated__c,AccountId,Account.Name from  Contact where id =:contact.ID LIMIT 1];
          message = contact.FirstName +' ' + contact.LastName + ' at ' +  contact.Account.Name +' will be terminated.';
    }

    public PageReference Proceed(){
      //
      //  (1) Set the Contact's Terminated field to true.
      //(2) If the Contact is an active Portal User, deactivate the Portal user.
      //(3) If there are error messages during the save, display the errors at the top of the page so the user can resolve them.
      //(4) Return the user to the Detail page of the Contact. 
    
      try {
        User portalUser = getPortalUser();    
        if(portalUser == null) {
          contact.AccountId = null;
        } 
        contact.Terminated__c = true;
        update contact;

        //If portal User is not null. Deactivate the portal user,call the future method.
        if(portalUser != null)
          Async.DeactivatePortalUser(portalUser.Id);  
      }
      catch(DmlException ex) {
        ApexPages.addMessages(ex);
        return null;  
      }
      PageReference pr = new PageReference('/' + contact.Id);
      if(contact.AccountId != null)
        pr = new PageReference('/' + contact.AccountId);
        
      return pr; 
    }

    public PageReference Cancel(){
         return new PageReference('/' + contact.Id);
        //Return the user to the Detail page of the Contact without changing any data 
    }
    //Retrieve the Portal User attached to this contact.
      private User getPortalUser() {
        List<User> lstUser = [select Id,IsActive from User where ContactId = :contact.Id];
        if(lstUser.size() > 0) {
          return lstUser[0];    
        }
    return null;
  }



}