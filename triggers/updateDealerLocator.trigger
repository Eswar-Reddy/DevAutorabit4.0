trigger updateDealerLocator on Account_Approvals__c (after insert, after update){

   Set <Id> acctIdToQuery = new Set <Id>{}; 
   public List<Account> lstAccount = new List<Account>();
   
    
        for (Account_Approvals__c acct : Trigger.new){ // Get Account Id
            acctIdToQuery.add(acct.Account__c);
        }
        
         //Get all Account_Approval
         Map<Id, Account_Approvals__c> acctApprovalMap = new Map<Id, Account_Approvals__c>();
          for(Account_Approvals__c acctAppObj : [SELECT Id,
                                                        Account__c, 
                                                        Approval_Request__c, 
                                                        Account__r.Dealer_Locator_Opt_Out__c 
                                                        FROM Account_Approvals__c
                                                        WHERE RecordType.developerName = 'Partner_Promotion'
                                                        AND Account__c in : acctIdToQuery
                                                        ORDER BY CreatedDate DESC Limit 1 ]){
               
                acctApprovalMap.put(acctAppObj.Account__c,acctAppObj);
          }
          
          //List of Account to Update
          List<Account> parentAccountRecToUpdate = new List<Account>();
          
          //Loop on the Account where Id contains the accountApprovalMap key
          for(Account acct: [SELECT Id, Dealer_Locator_Opt_Out__c
                             FROM Account
                             WHERE Id IN: acctApprovalMap.KeySet()]){
              if(acctApprovalMap.get(acct.Id).Approval_Request__c == 'Dealer Locator Opt Out'){
                  acct.Dealer_Locator_Opt_Out__c = true;
              }else{
                  acct.Dealer_Locator_Opt_Out__c = false;
              }

                  parentAccountRecToUpdate.add(acct);
           }

         //Update the parent account if the list is not empty
         if(!parentAccountRecToUpdate.isEmpty()){
             update parentAccountRecToUpdate;
         }
}