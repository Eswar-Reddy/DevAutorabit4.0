/* **************************************************************************************
* Class Name     : Dealer_fee_calculation_Utility
* Version        : 1.0
* Created Date   : June 2017
* Function       : Class to cancel the agrerment amendment
* Change Orders - June 2017
* Developer                   Date                Description
* ----------------------------------------------------------------------------
* Ankit                       June 2017          Original Version
*************************************************************************************/

public class CancelAmendmentController {

   private Id accountId;
   public echosign_dev1__SIGN_Agreement__c agreement{get;set;}
   public Boolean isInternalUser {get; private set;}
   public string  comment{get;set;}
   public boolean cancelFailure{get;set;}
   public Boolean errorSubmitSuccess {get; private set;}
   public Boolean errorSubmitFailure {get; private set;}
   public boolean showCancel{get;private set;}
   public string  amendmentType{get;private set;}

   public CancelAmendmentController(ApexPages.StandardController stdController) {
       cancelFailure = false;
       errorSubmitSuccess = false;
       showCancel = true;
       if(!Test.isRunningTest()) 
        stdController.addFields(new List<string>{'Notes__c','Change_Order_Type__c'});
       this.agreement = (echosign_dev1__SIGN_Agreement__c)stdController.getRecord();
       isInternalUser = UserInfo.getUserType() == 'Standard' ? TRUE : FALSE;
       amendmentType = agreement.change_Order_Type__c == 'Economic Amendment' ? 'quote ':'HO info ';
   }

   public PageReference cancelAmendment(){
     try{
         if(agreement.Notes__c <> null){
            integer totalLength = agreement.Notes__c.length() + comment.length();
            if(totalLength > 32768){
               agreement.Notes__c =  agreement.Notes__c.subString(comment.length() + UserInfo.getName().length() + 25).substringAfter(';') + '\n' + UserInfo.getName() +' - ' + System.TODAY().format() + ': ' + comment;
              }
            else {
                agreement.Notes__c =  agreement.Notes__c + ';' + '\n' + UserInfo.getName() + ' - ' + System.TODAY().format() + ': ' +comment;
              }
           }
         else {
            agreement.Notes__c = UserInfo.getName()+ ' - ' + System.now() + ': ' + comment ;
         }
         agreement.echosign_dev1__Status__c = 'Cancelled';
         update agreement;
         return new PageReference('/' + agreement.Id);
      } Catch(Exception E){
            cancelFailure = true;
            showCancel = false;
            return null;
      }
   }

   public PageReference back() {
      PageReference pr = new PageReference('/' + agreement.Id);
      pr.setRedirect(true);
      return pr;
   }

   public PageReference reportError(){
        try{
         system.debug('value in the  comment field ' + comment);
         List<echosign_dev1__SIGN_Agreement__c> agg = [select Lease_Number__c,account__c,account__r.Name,CreatedBy.Name,echosign_dev1__Status__c,change_Order_Type__c,
                                                       account__r.Partner_Account__r.Primary_PSR__c,account__r.Partner_Account__r.Primary_PSR_Email__c,
                                                       account__r.Partner_Account__r.Name
                                                       from echosign_dev1__SIGN_Agreement__c
                                                       where Id =:agreement.Id  Limit 1];

         system.debug(logginglevel.Error + '---mAgrment----' + agg);

         string subject =  agg[0].account__r.Name + ': '  + ' Pending Amendment Cancellation Failure ' + '(' + agg[0].Lease_Number__c + ')';
         string emailBody = '<HTML><body>' +
                            'Request: '  + 'Help with a pending amendment cancellation failure '  + '<br/>'  +
                                            'Requestor: ' + agg[0].account__r.Partner_Account__r.Name + ' - ' + UserInfo.getName()   + '<br/>'  + 'Customer: ' + agg[0].account__r.Name  + '<br/>'  +
                                            'Agreement: ' + URL.getSalesforceBaseUrl().toExternalForm()+'/'+ agg[0].account__c + '<br/>'  +
                                            'Countersigned Agreement: ' + agg[0].Lease_Number__c + '</body></HTML>';


         //adding the email address
         List<string> toaddress = new List<string> {'leasecontrolspsr@sunpowercorp.com','PaymentInquiry@sunpowercorp.com','SunPowerFinancing@sunpowercorp.com'};
         if(agg[0].account__r.Partner_Account__r.Primary_PSR_Email__c <> null)
           toaddress.add(agg[0].account__r.Partner_Account__r.Primary_PSR_Email__c);
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         mail.setSubject(subject);
         mail.setToAddresses(toaddress);
         mail.setHtmlBody( emailBody);
         List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail},false);
         showCancel = false;cancelFailure = false;errorSubmitSuccess = true;
         for(Messaging.SendEmailResult rs : results) {
                  if(!rs.isSuccess()) {
                     errorSubmitFailure = true;
                     errorSubmitSuccess = false;
                      List<Messaging.SendEmailError> errs = rs.getErrors();
                      for(Messaging.SendEmailError er : errs) {
                          System.debug(er.getFields() + ' - ' + er.getMessage() + ' - ' + er.getStatusCode());
                          break;
                      }
                  }
              }
        }
        catch(Exception E){
           errorSubmitSuccess = false;
           errorSubmitFailure = true;
           cancelFailure = false;
           system.debug(LoggingLevel.ERROR, '-- ' + E);
        }
      return null;
   }

}