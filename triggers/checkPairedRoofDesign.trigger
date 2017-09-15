//trigger to populate Paired_Design_Exists__c to true or false based on whether an active paired desgin exists for this account
trigger checkPairedRoofDesign on Roof_Design__c (after insert, after update, after delete) {
    
    Set<Id> accountIdSet = new Set<Id>();
    Map<Id,Account> accountMap;
    
    List<Account> accUpdateList = new List<Account>();
    
    
    Id rdMaxFitRecordTypeId = Schema.SObjectType.Roof_Design__c.getRecordTypeInfosByName().get('Residential MaxFit Designs').getRecordTypeId();
    
    
    if(Trigger.isInsert || Trigger.isUpdate){
        
        for(Roof_Design__c rd : Trigger.New){
            if(rd.Account_Name__c!=null)
                accountIdSet.add(rd.Account_Name__c);
        }
    }
    if(Trigger.isUpdate || Trigger.isDelete){
        for(Roof_Design__c rd : Trigger.Old){
            if(rd.Account_Name__c!=null)
                accountIdSet.add(rd.Account_Name__c);
        }
        
    }
    
    if(!accountIdSet.isEmpty()){
        accountMap = new Map<Id,Account>([Select Id,Paired_Design_Exists__c,(select Id,Active__c,Status__c,Account_Name__c from Designs__r where RecordTypeId=:rdMaxFitRecordTypeId and Status__c='Completed' and Active__c=true) from Account where Id in :accountIdSet]);
        System.debug('accountMap----->'+accountMap);
        
        if(!accountMap.isEmpty()){
            for(Id accId:accountMap.keySet()){
                if(!accountMap.get(accId).Designs__r.isEmpty() && accountMap.get(accId).Paired_Design_Exists__c==false){
                    accountMap.get(accId).Paired_Design_Exists__c=true;
                    accUpdateList.add(accountMap.get(accId)); 
                }
                else if(accountMap.get(accId).Designs__r.isEmpty() && accountMap.get(accId).Paired_Design_Exists__c==true){
                    accountMap.get(accId).Paired_Design_Exists__c=false;
                    accUpdateList.add(accountMap.get(accId));
                }
                
            }
        }
    }

    if(!accUpdateList.isEmpty()){
        update accUpdateList;
    }
    
    
}