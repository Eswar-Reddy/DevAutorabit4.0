/*
 * Account Management Utility Classes
 */ 
public class AccountOwnerUpdate
{

  /* Function to assign Accocunt --> OwnerId to x_Account_Owner__c
   * Also, Populates the Customer Account's Partner Account Field.
   * This method is being used by Account --> Trigger --> accountOwnerUpdate
   * @param1 : Value of trigger.new/List of accounts comming for insert/update
   */
  public static void ownerUpdate(List<Account> accountList)
  {
    List<Id> lstOwnerId = new List<Id>();  
    for(Account acc: accountList)
    {
      acc.x_Account_Owner__c = acc.OwnerId;
      lstOwnerId.add(acc.OwnerId);
    }  
     
    Map<Id, User> mUser = new Map<Id, User>([SELECT Id, ContactId, Contact.Email, 
                                                    ProfileId, AccountId 
                                             FROM User 
                                             WHERE Id IN: lstOwnerId]);     
      
    for(Account acc : accountList)
      if(mUser.containsKey(acc.OwnerId) && mUser.get(acc.OwnerId).ContactId != null)
        acc.Partner_Account__c = mUser.get(acc.OwnerId).AccountId;        
  }//End Func ownerUpdate
}