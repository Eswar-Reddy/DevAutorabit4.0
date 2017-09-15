/*
* @auther : Cloud Sherpas Inc.
* @date : 03/12/2014
* @description : Apex class for handling operations from Opportunity Trigger
*/ 
public class OpportunityTriggerHandler {
    
    //Fetching Home Owner RT using Metadata API
    // private static Id idHomeOwnerRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Home Owner').getRecordTypeId();
    //private static Id idHomeOwnerRT='0128000000037dm';
    private static Id idHomeOwnerRT = Label.Opportunity_Home_Owner_RD_Id;
    
    //Checks if Trigger has already executed once
    public static Boolean isExecuted = false;
    
    //Apex method checks if Owner AND Partner has been changed on Opportunity record
    public static Boolean hadOppOwnerAndParterChanged(Opportunity newOpp, Opportunity oldOpp) {
        return (hadOppOwnerChanged(newOpp, oldOpp) && hadOppParterChanged(newOpp, oldOpp));
    }
    
    //Apex method checks if Owner has been changed but Parter is SAME on Opportunity record
    /*public static Boolean hadOppOwnerChangedAndSameParter(Opportunity newOpp, Opportunity oldOpp) {
        return (hadOppOwnerChanged(newOpp, oldOpp) && (!hadOppParterChanged(newOpp, oldOpp)));
    }*/
    
    //Apex method checks if Owner has been changed on Opportunity record
    private static Boolean hadOppOwnerChanged(Opportunity newOpp, Opportunity oldOpp) {        
        return (newOpp.OwnerId != null && newOpp.OwnerId != oldOpp.OwnerId);
    }
    
    //Apex method checks if Partner has been changed on Opportunity record
    private static Boolean hadOppParterChanged(Opportunity newOpp, Opportunity oldOpp) {        
        return (newOpp.PartnerAccountID != null && newOpp.PartnerAccountID != oldOpp.PartnerAccountID);
    }
    
    //Apex method checks if Opportunity is valid for sending notifications to it's Owner
/*    public static Boolean isValidOppForNotification(Opportunity opp) {
        return ((opp.Lead_Manufacturer__c == 'SunPower') && (opp.StageName == 'New Opportunity') && (opp.RecordTypeId == idHomeOwnerRT));
    }
*/     
}