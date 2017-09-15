@isTest(SeeAllData = true)
private class InstallerSharingUtilTest{
    
    
    static testmethod void testInstallSharingUtil1(){
         
        List<Account> partnerAccounts = new List<Account>([SELECT Id, Opportunity_Recipient__c FROM Account WHERE Status__c = 'Active' AND RecordType.Name = 'Partner' AND Opportunity_Recipient__c != null LIMIT 3]);
        System.assert(partnerAccounts.size() == 3);

        Map<Id, Opportunity> newOppMap = new Map<Id, Opportunity>();
        Map<Id, Opportunity> oldOppMap = new Map<Id, Opportunity>();
        test.startTest();
            Account resAcc = TestClassFactory.testAccount('TestAcctInst', TestClassFactory.retrieveRecordTypeId('Account', 'Residential Customer'));
            insert resAcc;
           
            Opportunity opp = new Opportunity( Name = 'Test BiggSunOpp', 
                StageName = 'New Opportunity',
                Lead_Manufacturer__c = 'Partner',
                Dealer_Assignment_Date__c = System.today()+1,
                CloseDate = System.today(),
                Theater__c='North America',
                Installer__c = partnerAccounts[0].Id,
                AccountId = resAcc.ID);
                if(partnerAccounts[0].Opportunity_Recipient__c != null)
                    opp.ownerId = partnerAccounts[0].Opportunity_Recipient__c;        
                insert opp;

            oldOppMap.put(opp.Id, opp); 
 
            Opportunity opp2 = new Opportunity(Id = opp.Id,
                Installer__c = partnerAccounts[1].Id,
                Lead_Manufacturer__c = 'Partner',
                Theater__c='North America',
                AccountId = resAcc.Id);
            if(partnerAccounts[1].Opportunity_Recipient__c != null)
                    opp.ownerId = partnerAccounts[1].Opportunity_Recipient__c;
            newOppMap.put(opp2.Id, opp2);
            
            InstallerSharingUtil.prepOpportunitySharing(newOppMap.values(), newOppMap, oldOppMap);

            InstallerSharingUtil.deleteOpportunitySharing(newOppMap.values(), newOppMap, oldOppMap);

        test.stopTest();
        
    }
    
}