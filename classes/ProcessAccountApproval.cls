global class ProcessAccountApproval
{
    //This is the initial method that is used to decide how the account approvals should be processed...
    public static void ProcessAccountApprovalList(List <Account_Approvals__c> acctApprs)
    {
        List <Account_Approvals__c> lsrApprovals = new List <Account_Approvals__c>();
        List <Account_Approvals__c> daApprovals = new List <Account_Approvals__c>();
        
        //Get the approval record type ids, which will be used to define the action needed on the account.
        Id lsrRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Partner_Lead_Routing' AND sObjectType = 'Account_Approvals__c'][0].Id;
        Id daRecTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Dealer_Score_Adjustment' AND sObjectType = 'Account_Approvals__c'][0].Id;
        
        for(Account_Approvals__c aa : acctApprs)
        {
            //If the approval record type id (from above) matches the partner lead routing record type, add this approval to the lsrApprovals list.
            //If the approval record type id (from above) matches the dealer score adjustment record type, add this approval to the daApprovals list.
            if(aa.RecordTypeId == lsrRecTypeId) lsrApprovals.add(aa);
            if(aa.RecordTypeId == daRecTypeId) daApprovals.add(aa);
        }
        
        //Send the lists to the corresponding methods, based on the action needed/record type, to be processed accordingly
        if(!lsrApprovals.isEmpty()) processLeadSuspensionRouting(lsrApprovals);
        if(!daApprovals.isEmpty()) processDiscretionaryAdjustment(daApprovals);
        
    }
    
    public static void ProcessLeadSuspensionRouting(List <Account_Approvals__c> lsrAcctApprs)
    {
        Set <Id> optInAcctIds = new Set <Id>();
        Set <Id> optOutAcctIds = new Set <Id>();
        
        for(Account_Approvals__c aa : lsrAcctApprs)
        {
            //Add the approval's account id to the optInAcctIds if the account is being opted in.
            //Add the approval's account id to the optOutAcctIds if the account is being opted out
            if(aa.Approval_Request__c == 'Lead Flow Opt In') optInAcctIds.add(aa.Account__c);
            if(aa.Approval_Request__c == 'Lead Flow Opt Out') optOutAcctIds.add(aa.Account__c);
        }
        
        List <Account> acctsToUpdate = new List <Account>();
        
        if(!optInAcctIds.isEmpty() || !optOutAcctIds.isEmpty())
        {
            //Populate the acctsToUpdate list with the accounts we want to update
            acctsToUpdate = [SELECT Id, Lead_Flow_opt_out__c FROM Account WHERE Id IN :optInAcctIds OR Id IN :optOutAcctIds];
            
            for(Account a : acctsToUpdate)
            {
                //If the account Id is in the set of ids containing the accounts to be opted in, then opt in the account.
                if(optInAcctIds.contains(a.Id))
                {
                    a.Lead_Flow_Opt_Out__c = FALSE;
                }
                
                //If the account Id is in the set of ids containing the account to be opted out, the opt out the account.
                if(optOutAcctIds.contains(a.Id))
                {
                    a.Lead_Flow_Opt_Out__c = TRUE;
                }
            }
            
            //Update the accounts
            update acctsToUpdate;
        }
        
    }
    
    public static void ProcessDiscretionaryAdjustment(List <Account_Approvals__c> daAcctApprs)
    {
        Set <Id> daAcctIds = new Set <Id>();
        Map <Id, Account> daAccountMap = new Map <Id, Account>();
        List <Account> daAccounts = new List <Account>();
        
        //Add the account ids to the daAcctIds
        for(Account_Approvals__c aa : daAcctApprs)
        {
            daAcctIds.add(aa.Account__c);
        }
        
        if(!daAcctIds.isEmpty())
        {
            //Get the accounts that need to be updated and add them to the daAccountMap.
            daAccounts = [SELECT Id, RSM_Discretionary_Adj__c FROM Account WHERE Id IN :daAcctIds];
            for(Account a : daAccounts)
            {
                daAccountMap.put(a.Id, a);
            }
            
            //Update the account related to the approval with the requested discretionary amount.
            for(Account_Approvals__c aa : daAcctApprs)
            {            
                if(!string.isBlank(aa.Approval_Request__c) && aa.Approval_Request__c.isNumeric())
                {
                    daAccountMap.get(aa.Account__c).RSM_Discretionary_Adj__c = integer.valueOf(aa.Approval_Request__c);
                }
            }
            
            //Update the accounts
            update daAccountMap.values();
        
        }
    }
}