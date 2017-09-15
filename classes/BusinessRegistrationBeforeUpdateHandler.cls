public with sharing class BusinessRegistrationBeforeUpdateHandler extends TriggerHandlerBase {
    public BusinessRegistrationBeforeUpdateHandler() {
        
    }

    // -------- Variables --------
    
    
    
    // -------- Properties --------
    // Qualified records for actions
    private Map<Id, Business_Registration__c> qualifiedBusinessRegs;
    private List<Id> partnerAccountIds;
    private List<String> billingStates;
    private List<Id> businessRegIds;
     

    //Begin processing
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('BusinessRegistartionBeforeInsert qualifyStartingRecords');

        Map<ID, Business_Registration__c> newBusinessRegMap = (Map<ID, Business_Registration__c>)newMap;
        Map<ID, Business_Registration__c> oldBusinessRegMap = (Map<ID, Business_Registration__c>)oldMap;
        List<Business_Registration__c> newBusinessRegList = (List<Business_Registration__c>)newList;
        List<Business_Registration__c> oldBusinessRegList = (List<Business_Registration__c>)oldList;

        qualifiedBusinessRegs = new Map<Id, Business_Registration__c>();
        partnerAccountIds = new List<Id>();
        billingStates = new List<String>();
        businessRegIds = new List<Id>();
        //getting the list of Partner Ids and states from incoming Business Registrations
        for(Business_Registration__c br : newBusinessRegList){
            if(br.Account__c != null && br.State__c != null){
                qualifiedBusinessRegs.put(br.Id,br);
                partnerAccountIds.add(br.Account__c);
                billingStates.add(br.State__c);
                businessRegIds.add(br.Id);
            }
        }
    }


    public override void start(){
        
        if(qualifiedBusinessRegs.isEmpty()) return;

        List<Business_Registration__c> businessRegList = new List<Business_Registration__c>();        
        if(partnerAccountIds.size() > 0 && billingStates.size() > 0){
            businessRegList = [select id,Account__c,State__c,License_City__c from Business_Registration__c where Account__c IN : partnerAccountIds AND State__c IN :billingStates AND ID NOT IN :businessRegIds];
        }

        for(Business_Registration__c br : qualifiedBusinessRegs.values()){
               if(!businessRegList.isEmpty()){
                    for(Business_Registration__c b : businessRegList){
                        if(br.Id != b.Id && br.Account__c == b.Account__c && br.State__c == b.State__c && br.License_City__c == b.License_City__c && !Util.currentUser.ByPassValidation__c){
                            system.debug('Business Registration already exists');
                            br.addError(System.Label.Business_Registration_Duplicate_Error);
                            break;
                        }
                    }
               }
        }
        
    }

    public override void finish(Boolean fromStart){
        if(fromStart){

        }
        Diagnostics.pop();
    }
}