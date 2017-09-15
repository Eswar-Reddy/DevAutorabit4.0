public without sharing class CancellationHandler {
    public echosign_dev1__SIGN_Agreement__c agmt;
    public echosign_dev1__SIGN_Agreement__c newAgg {get;set;}
    public string agmtId {get;set;}
    private List<sObject> sObjectList;
    public Boolean isInternal {get;set;}
    public Boolean showError {get;set;}
    public String miscErrorMsg {get;set;}
    public Boolean showPage {get;set;}
    public Boolean nocStatic {get;set;}

    private Id cancellationId;
    private DocGenContractRequest  docGenObj;
    public CancellationHandler() {

        showError = FALSE;
        showPage = TRUE;
        nocStatic = FALSE;

        

        newAgg = new echosign_dev1__SIGN_Agreement__c();
        agmtId = ApexPages.currentPage().getParameters().get('id');
        agmt= [SELECT Id, Name, Quote__c, Opportunity__c, Account__c,Quote__r.Consolidated_Lease_Number__c,Quote__r.Account__r.Name,echosign_dev1__DateSignedDate__c FROM echosign_dev1__SIGN_Agreement__c WHERE Id =: agmtid];
        cancellationId = Schema.SObjectType.echosign_dev1__SIGN_Agreement__c.getRecordTypeInfosByName().get('Cancelled').getRecordTypeId();
        newAgg.RecordTypeId = cancellationId;

        

        isInternal = UserInfo.getUserType() == 'Standard' ? TRUE : FALSE ;
        if(!isInternal) newAgg.Change_Order_Type__c = 'Cancellation';
        if(isInternal) newAgg.Change_Order_Type__c = '';

        List<echosign_dev1__SIGN_Agreement__c> currentAggs = [SELECT Id, Name, Status__c, Change_Order_Type__c FROM echosign_dev1__SIGN_Agreement__c WHERE RecordType.Name = 'Cancelled' AND Account__c =: agmt.Account__c AND Quote__c =: agmt.Quote__c ORDER BY Change_Order_Type__c DESC];
        Boolean signedC = FALSE;
        Boolean activeC = FALSE;
        for(echosign_dev1__SIGN_Agreement__c e : currentAggs){
          if(e.Status__c == 'Signed') signedC = TRUE;
          if(e.Status__c != 'Signed') activeC = TRUE;
        }

        if(signedC == TRUE ){
          miscErrorMsg = 'There is already a signed Cancellation Agreement record on file for this Quote.';
          showPage = FALSE;
          showError = TRUE;
        }
        else if(activeC == TRUE){
          showError = TRUE;
          if(currentAggs[0].Change_Order_Type__c == 'Notice of Cancellation'){
            miscErrorMsg = 'An open Notice of Cancellation Agreement record exists for this Account \''+currentAggs[0].Name+'\'.';
            showPage = FALSE;
          }else{
            miscErrorMsg = (!isInternal) ? 'An open Cancellation Agreement exists for this Account \''+currentAggs[0].Name+'\'' : 'An open Cancellation Agreement exists for this Account, please complete Agreement \''+currentAggs[0].Name+'\' or create a Notice of Cancellation.';
            if(!isInternal) showPage = FALSE;
            if(isInternal) {
              nocStatic = TRUE;
              newAgg.Change_Order_Type__c = 'Notice of Cancellation';
            }
          }
        }

    }
    
    Public pagereference Cancel(){
        PageReference pg1= new PageReference('/'+agmt.Id);
        return pg1;
    }
    
    Public pagereference applyCancellation(){
        // Calling methods to send request to DocGen
         system.debug('Called Funtion');
          docGenObj = new DocGenContractRequest ();
          string agreementName = ''; 
           if(newAgg.Change_Order_Type__c == 'Notice of Cancellation'){
                //Id quoteId,Id recordTypeId,String waterMark,String agreementName,String addnlRecipient,string changeOrderType,string documentType
                system.debug('Called Funtion NOC');
                agreementName = agmt.Quote__r.Account__r.Name + '-NOC Document-' + agmt.Quote__r.Consolidated_Lease_Number__c + '-' + String.valueOf(System.now()) + '.pdf';
                sObjectList = docGenObj.sendDataToDocGen(agmt,agmt.Quote__c,cancellationId,'',agreementName,null,'Notice of Cancellation','NOC');    
            }
           else{
                system.debug('Called Funtion without NOc');
                agreementName = agmt.Quote__r.Account__r.Name + '-Cancellation Document-' + agmt.Quote__r.Consolidated_Lease_Number__c + '-' + String.valueOf(System.now()) + '.pdf';
                sObjectList= docGenObj.sendDataToDocGen(agmt,agmt.Quote__c,cancellationId,'',agreementName,Label.SunPowerCounterSign,'Cancellation','ContractCancellation');  
             }
          Sunpower_Spectrum_Debug_Log__c spectrumDebugLog = (Sunpower_Spectrum_Debug_Log__c)sObjectList.get(1);
          if(spectrumDebugLog.Name <> 'error'){
              newAgg.Id = spectrumDebugLog.Name;
              update newAgg;
              return new PageReference('/'+ spectrumDebugLog.Name);
          }else{
            miscErrorMsg = 'An error has occured during the the DocGen callout. Please contact your system administrator for more information';
            showError = TRUE;
            return null;
          }
          return null;   
    }
    
}