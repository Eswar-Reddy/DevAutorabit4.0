public with sharing class partner360Controller {
    
    Apexpages.StandardController p360Ctrl;
    public Account pAcc{get;set;}
    public PageReference pRef;
    public List<Business_Registration__c> brList {get;set;}
    
    public partner360Controller(ApexPages.StandardController controller) {
        this.p360Ctrl=controller;
        this.pAcc = (Account)controller.getRecord();
        pRef = new PageReference('/apex/partner360?Id='+pAcc.Id);
        brList = [select id,State__c,License_Number__c,Expires_On__c from Business_Registration__c where Account__c =:pAcc.Id];
    }
    
    public PageReference Save(){  
        p360Ctrl.save();
        return pRef;
    }
    
    public PageReference Cancel(){
        return pRef;
    }
    
    /*
    public PageReference toEditPage(){
         PageReference editPage = new PageReference('/apex/partner360Edit?Id='+pAcc.Id);
         return editPage;
    }*/
    
    public PageReference toShortDetailPage(){
         PageReference editPage = new PageReference('/'+pAcc.Id);
         return editPage;
    }
}