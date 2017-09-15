/********************************************************************************************
Name   : CreditApplicationEditController
Author : Aashish Mathur
Date   : May 13, 2010
Usage  : Controller of VF page CreditApplicationEdit which is used to redirect user to
         standard edit page if CA can be edited.
********************************************************************************************/

public class CreditApplicationEditController {
    public Boolean isCAEditable {get; private set;}
    private PageReference standardEditPage;
    
    public CreditApplicationEditController(ApexPages.StandardController stdCont) {
        Credit_Application__c creApp = [SELECT Id, RecordTypeId, Status__c, OwnerId FROM Credit_Application__c
                WHERE Id = :stdCont.getId()];//for case #00045173 
        
        Set<String> nonEditableStatus = new Set<String>();
        nonEditableStatus.add('Approved');
        nonEditableStatus.add('Closed');
        nonEditableStatus.add('Declined');
        nonEditableStatus.add('In Progress');
        nonEditableStatus.add('Withdrawn');
        
        isCAEditable = !(nonEditableStatus.contains(creApp.Status__c));
        
        //Credit team should be able to modify the 'In Progress' credit application
        User currentUser = [Select Id, Profile.Name, UserRole.Name from user where Id =: userInfo.getUserID()];        
        
        isCAEditable = checkCAEdit(creApp, currentUser);//for Case#00082046
        if(currentUser.Profile.Name == 'System Administrator'){
            isCAEditable = true;
        }
        //for case #00045173
        if (isCAEditable) {
            standardEditPage = new PageReference('/' + creApp.Id + '/e?nooverride=1&retURL='
                    + ApexPages.currentPage().getParameters().get('retURL'));
        }
    }
    
    public PageReference redirectUser() {
        return standardEditPage;
    }
    //for case #00045173
    public boolean checkCAEdit(Credit_Application__c creApp, User currentUser){
        if(creApp.OwnerId == currentUser.Id 
            &&(currentUser.UserRole.Name == 'Credit Analyst' || currentUser.UserRole.Name == 'Credit Manager'
            ||currentUser.Profile.Name == 'SunPower Credit')            
            &&(creApp.Status__c == 'Ready For Review' || creApp.Status__c == 'In Progress' 
            ||creApp.Status__c == 'Approved' ||creApp.Status__c == 'Declined' || creApp.Status__c == 'Submitted for Approval')){
                return true;
        }else if(creApp.OwnerId == currentUser.Id 
            &&(currentUser.Profile.Name == 'EU Partner Delegated Administrator' || currentUser.Profile.Name == 'EU Partner Executive' || currentUser.Profile.Name == 'EU Residential Installer' ||//for Case#00082046//Case#00107344-Added profile 'EU Residential Installer'
                currentUser.Profile.Name == 'Partner Delegated Administrator' || currentUser.Profile.Name == 'Partner Executive')//for Case#00082046            
            &&(creApp.Status__c == 'New' || creApp.Status__c == 'Evaluation On Hold - Missing Documentation')){
                return true;
        }else{
            return false;
        }
    }
    //for case #00045173    
}