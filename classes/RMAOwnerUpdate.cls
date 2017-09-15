public class RMAOwnerUpdate{

 
 /*
Function     : updateRMAOwnerAsCurrentUser
Parameter    : Map<Integer,RMA__c>
Returen Type : 
Summary      : This Function will update the Running RMA record owner as Current Owner (Please Note RMA Owner field is hiddent on Layout)
Calling Class: RMABeforeInsertHandler  
*/
    
    public static void updateRMAOwnerAsCurrentUser(Map<Integer, RMA__c> updateRMAOwnermap) {
        
        for (RMA__c rmaObject: updateRMAOwnermap.values()) {
            rmaObject.RMA_Owner__c=userinfo.getUserId(); //Assigning current user as RMA Owner
        }
    }
}