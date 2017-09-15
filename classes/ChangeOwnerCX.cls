/*
* @auther : Cloud Sherpas Inc.
* @date : 03/11/2014
* @description : Apex class for ChangeOwner VF Page
*/
public class ChangeOwnerCX {
    
    public Opportunity opp {get; set;}
    public String SelectedUser {get; set;}
    public Boolean error {get; set;}
    public Boolean isSelectedUserNull {get;set;}
    
    private Map<Id, User> mUsers;
    
    //Constructor
    public ChangeOwnerCX(ApexPages.StandardController controller) {
        this.SelectedUser = '';
        error = false;
        isSelectedUserNull = true;
        opp = (Opportunity) controller.getRecord();
        System.debug(LoggingLevel.INFO, '== in CS_ChangeOwnerCX original opp ==' + opp);
                
        opp = [SELECT Id, Name, StageName, OwnerId, AccountId, Account.OwnerId, 
            Owner.Name, Primary_Contact__c, Primary_Contact__r.OwnerId, PartnerAccountId 
            FROM Opportunity 
            WHERE Id =: opp.Id 
            LIMIT 1 FOR UPDATE];        
        
        mUsers = new Map<Id, User>([SELECT Id, Name, FirstName, MobilePhone 
            FROM User 
            WHERE Contact.AccountId =: opp.PartnerAccountId 
            AND isActive = true 
            AND Id !=: opp.OwnerId 
            AND (UserType = 'Partner' OR UserType = 'PowerPartner')
            ORDER BY Name ASC LIMIT 999]);
    }
    
    /*
    * @auther : Cloud Sherpas Inc. - Sumit Shingavi
    * @date : 03/11/2014
    * @description : Apex getter method which returns List of Users for Partner Account of Opp
    * @parameters : Nothing
    * @returns : List<SelectOption>
    */   
    public List<SelectOption> getAvailableUsers() {    
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--Select--'));
        if(!mUsers.isEmpty()) {
            List<User> lUsers = new List<User>();
            lUsers.addAll(mUsers.values());
            lUsers.sort();
            for(User usr : lUsers) {                
                options.add(new SelectOption(usr.Id, usr.Name));
            }
        }    
        return options;
    }
    
    /*
    * @auther : Cloud Sherpas Inc. - Sumit Shingavi
    * @date : 03/11/2014
    * @description : Apex method for updating owner on Opportunity
    * @parameters : Nothing
    * @returns : Nothing
    */   
    public void updateOwner() {
        if(!String.isBlank(this.SelectedUser)) {
            try {
                //Intentionally not to execute Opp Notification trigger as it is creating 
                //duplicate notifications
                OpportunityTriggerHandler.isExecuted = true;
            
                Id oldOwner = opp.OwnerId;
                
                error = false;
                isSelectedUserNull = false;
                opp.OwnerId = this.SelectedUser;
                update opp;
                System.debug(LoggingLevel.INFO, '== in ChangeOwnerCX opp updates done ==');
                
                //Update Account Owner
                if(opp.AccountId != null) {
                    Account acc = new Account(Id = opp.AccountId, 
                        OwnerId = this.SelectedUser);
                    update acc;
                    System.debug(LoggingLevel.INFO, '== in ChangeOwnerCX account updates done ==');
                }
                
                //Update Primary Contact Owner
                if(opp.Primary_Contact__c != null) {
                    Contact con = new contact(Id = opp.Primary_Contact__c, 
                        OwnerId = this.SelectedUser);
                    update con;
                    System.debug(LoggingLevel.INFO, '== in ChangeOwnerCX contact updates done ==');
                }
                
                //Send out the notification to new Owner
                String strActivity = 'ChangeOwner';
                
                User usr = mUsers.get(this.SelectedUser);
                ChatterNotificationUtility.createOppAssignmentPost(opp, strActivity, oldOwner);                
                System.debug(LoggingLevel.INFO, '== in ChangeOwnerCX updated opp ==' + opp);
                
                //Create Dealer Notification for Text on ChangeOwner
                Dealer_Notification__c dealerNotification = new Dealer_Notification__c(
                    RelatedObjectId__c = opp.Id, Type__c = 'Text', Activity__c = strActivity,
                    isSent__c = false, sendTo__c = opp.OwnerId);
                insert dealerNotification;
                System.Debug(LoggingLevel.INFO, '== In Delaer Utility Text logged ==');
                
            }catch(Exception e) { System.debug(LoggingLevel.Error, '==Error=='+e.getMessage()); }
            
        } else {
            isSelectedUserNull = true;
            error = true;
        }
        System.debug(LoggingLevel.INFO, '== in ChangeOwner error flag ==' + error);
    }    
}