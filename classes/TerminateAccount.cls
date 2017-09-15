public class TerminateAccount{
  private Account account;
  public String status{get;set;}  
  public String message{get;set;}  
  public TerminateAccount (ApexPages.StandardController stdController) {
    account = (Account)stdController.getRecord(); 
    account = [select ID,Status__c,Name from Account where Id = :account.ID Limit 1];
    message = account.Name +' will be changed to a status of '; 
  }
  
  //Terminate the Contact
  public PageReference Proceed() {
    try {
      if(status == null){
          ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR,'Please select a status.');
          ApexPages.addMessage(msg);
          return null;  
      }else if(account.Status__c != null && (account.Status__c == status )){
         ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR,'Please select a new status.');
         ApexPages.addMessage(msg);
         return null;  
      }else if(status == 'Terminating'){
        Async.ChangeProfileAllPortalUsersForAccount(account.Id);
      }else if(status == 'Terminated'){
          Async.DeactivateAllPortalUsersForAccount(account.Id);
      }
      account.Status__c = status;
      update account;  
    }
    catch(DmlException ex) {
      ApexPages.addMessages(ex);
      return null;  
    }
    return new PageReference('/' + account.Id); 
  }
  public List<SelectOption> getOptions(){
      List<SelectOption> opts = new List<SelectOption>();
      opts.add(new SelectOption('Terminating','Terminating'));
      opts.add(new SelectOption('Terminated','Terminated'));
      return opts;
  }
  public PageReference Cancel(){
    return new PageReference('/' + account.Id); 
  }
  
}