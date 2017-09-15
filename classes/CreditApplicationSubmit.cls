/********************************************************************************************
Name   : CreditApplicationSubmit
Author : Aashish Mathur
Date   : May 17, 2010
Usage  : Used by Partner User to submit a CA through "Submit" button.
********************************************************************************************/

global class CreditApplicationSubmit {
	//for case # 00045173	
    public static webservice String submit(ID creAppId) {
        Credit_Application__c creApp = [SELECT Id, Account__c, Account__r.Name, RecordType.Name, (SELECT Id from Attachments where isDeleted = false) 
        		FROM Credit_Application__c WHERE Id = :creAppId];        
        List<Attachment> attachmentList = creApp.Attachments;
        if (attachmentList.size() == 0) {//for Case#00082046        
            return System.Label.CASubmitError;
        }
        
        //for case # 00045173
        creApp.Status__c = 'Ready for Review';
        
        List<Group> creAppQueue = [Select Id From Group where Name = 'Credit Application Queue'
                and Type = 'Queue'];
        if (creAppQueue.size() > 0) {
            creApp.OwnerId = creAppQueue[0].Id;
        }
        
        update creApp;
        
        String partnerRoleName = creApp.Account__r.Name + ' Partner Executive';
        
        List<UserRole> rolesList = [SELECT Id FROM UserRole WHERE Name = :partnerRoleName
                AND PortalAccountId = :creApp.Account__c AND PortalType = 'Partner'];
        if (rolesList.size() == 0) {
            return null;//for case # 00045173	
        }
        
        List<Group> groupsList = [SELECT Id FROM Group WHERE RelatedId = :rolesList[0].Id];
        if (groupsList.size() == 0) {
        	return null;//for case # 00045173	
        }
        
        Credit_Application__Share sharing = new Credit_Application__Share();
        sharing.ParentId = creApp.Id;
        sharing.UserOrGroupId = groupsList[0].Id;
        sharing.AccessLevel = 'Edit';
        sharing.RowCause = 'Manual';
        
        insert sharing;
        return null;//for case # 00045173        
    }
}