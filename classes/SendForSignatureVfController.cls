/*Controller Class to Avoid S Control Implementtaion For Send For Signature Flow */
public without sharing class SendForSignatureVfController {
    public String aggId{get;set;} // AggId For Mapping
    public String level {get; set;}// Apex Page Error Level
    public String message {get; set;}// Apex Page Error Message
    public static Id aggreementId; // Agreement Id
    public String recipientMail{get; set;}
    public String recipient1Mail{get; set;}
    public String recipient2Mail{get; set;}
    public String addEmail{get; set;}
    public echosign_dev1__SIGN_Agreement__c agreement;
    
    public PageReference showPageMessage() {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, message));
        return null;
        
    }
    
    
    public SendForSignatureVfController(ApexPages.StandardController stdController) {
        aggreementId=ApexPages.currentPage().getParameters().get('id'); // to get Url Param
        agreement=[SELECT change_order_type__c,echosign_dev1__Recipient__r.Email,echosign_dev1__Recipient2__r.Email,echosign_dev1__Recipient3__r.Email,echosign_dev1__More_Recipients__c FROM echosign_dev1__SIGN_Agreement__c WHERE Id =: aggreementId LIMIT 1];
          if(agreement <> Null){
            if(agreement.change_order_type__c == 'Notice Of Cancellation'){
                recipientMail= Label.SunPowerCounterSign;
                system.debug('---Sending mail---' + recipientMail);
                recipient1Mail= Null;
                recipient2Mail= Null;
                addEmail=Null;
                
            } 
            else{    
                recipientMail=String.valueOf(agreement.echosign_dev1__Recipient__r.Email);
                recipient1Mail=String.valueOf(agreement.echosign_dev1__Recipient2__r.Email);
                recipient2Mail=String.valueOf(agreement.echosign_dev1__Recipient3__r.Email);
                addEmail=String.valueOf(agreement.echosign_dev1__More_Recipients__c); 
            }  
        }
       
    }
    
   
    
}