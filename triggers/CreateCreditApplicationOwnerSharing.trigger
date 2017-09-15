/*
Name    : CreateCreditApplicationOwnerSharing
Author  : Appirio Offshore
Date    : 2/2/2011
Case    : Sunpower 00045173

Requirement : This trigger is fired when a credit application is updated. In case of an update (when the application is Submitted) the owner
              of the application is changed from the current owner to the Credit Application Queue. So when the current owner submits the 
              credit application since he/she is nor more the current owner, so an Insufficient Privileges error is displayed after the Submit.
              To overcome this, the trigger creates a manual sharing on the credit application submitted to the 
              original owner of the credit application.
              
Usage   : Create a new Credit Application and Submit it.


*/
trigger CreateCreditApplicationOwnerSharing on Credit_Application__c (after update) {
    
    List<Credit_Application__Share> sharingsList = new List<Credit_Application__Share>();
    List<Group> queueList = [select id from Group where type='Queue' and name='Credit Application Queue'];
    
    if (queueList.size() == 0){
        return;
    }
    Id queueId = queueList.get(0).id;
    for (Credit_Application__c creditApp : Trigger.new){
        Id origOwnerId = Trigger.oldMap.get(creditApp.id).ownerId;
        if (creditApp.OwnerId == queueId && creditApp.OwnerId != origOwnerId){
            Credit_Application__Share sharing = new Credit_Application__Share();
            sharing.ParentId = creditApp.Id;
            sharing.UserOrGroupId = origOwnerId;
            sharing.AccessLevel = 'Edit';
            sharing.RowCause = 'Manual';
            sharingsList.add(sharing);
        }
        
    }
    
    insert sharingsList;
    

}