public with sharing class AgreementEventTable{

    public Id objectParentId;
    public List<echosign_dev1__SIGN_AgreementEvent__c> events{get;set;}

       public ID getObjectParentId(){
           return objectParentId;
       }
       
       public void setObjectParentId(ID s){
       
           objectParentId=s;
           getEvents();
       }
       
       public void getEvents(){
        System.debug('**** objectParentId: '+objectParentId);
        events = [select Id, echosign_dev1__Date__c,echosign_dev1__Description__c from echosign_dev1__SIGN_AgreementEvent__c where echosign_dev1__SIGN_Agreement__c =: objectParentId];
    
        if(events == null)
        events = new List<echosign_dev1__SIGN_AgreementEvent__c>();
        }
        
    }