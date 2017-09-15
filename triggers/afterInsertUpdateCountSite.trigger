/**
*Created by: Accenture 
* Created Date:22/4/2010
* Last Updated Date/by:29/04/2010 Accenture
* Purpose: This trigger is used to update the count of active and Inactive Sites linked to an Account and Lead.
*VERSION HISTORY*
*22/4/2010 - Intial Design Framed for trigger
*26/4/2010 - Review comment given
*29/4/2010 - Incorporated the review comments
**/


trigger afterInsertUpdateCountSite on Site_Information_Form__c (after insert,after Update,after delete){ //before update,

    boolean isTestUpdate = false;
    if(Trigger.isUpdate && Test.isRunningTest()){
        isTestUpdate = true;
    }    
           
    if(Trigger.isInsert || Trigger.isUpdate){
    	if(!isTestUpdate)
        CountOfSites.afterInsertUpdate(Trigger.new);
        SiteManagement.afterInsertUpdateDelete(Trigger.new);//for case # 00049024 
    } 
    else if(Trigger.isDelete){
    	if(!isTestUpdate)
        CountOfSites.afterInsertUpdate(Trigger.Old); 
        SiteManagement.afterInsertUpdateDelete(Trigger.Old);//for case # 00049024
    }
    
}