/* **************************************************************************************
* Class Name     : DocGenAmendmentRequest
* Version        : 1.0
* Created Date   : 13 Oct 2015
* Function       : It's a class to send the request to DocGen for creating the amendment. 

* Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
* Ankit                       13 Oct 2015          Original Version
*************************************************************************************/
public class DocGenAmendmentRequest {

  
   static Id amendmentAgreementId;
   
    /*
    @Name        : createRequest
    @description : It's function to create the body of the request.
    @parameters  :  echosign_dev1__SIGN_Agreement__c agrment,ChangeOrderAmendmentController.AccountInfo accountInfo,ChangeOrderAmendmentController.Cosignee cosignee
    @returns     :   
   */
    
    public static string createRequest (echosign_dev1__SIGN_Agreement__c agrment,ChangeOrderAmendmentController.AccountInfo accountInfo,ChangeOrderAmendmentController.Cosignee primaryContact,ChangeOrderAmendmentController.Cosignee coSignee,Quote objQuote){
        string requestbody = null;
        String sCounterSignDate = null; 
        system.debug('-----agrment------' + agrment);
      if(agrment.echosign_dev1__DateSignedDate__c <> Null){  
            Map<Integer,String> monthMap = new map<Integer,String>();
            monthMap.put(1,'January');
            monthMap.put(2,'February');
            monthMap.put(3,'March');
            monthMap.put(4,'April');
            monthMap.put(5,'May');
            monthMap.put(6,'June');
            monthMap.put(7,'July');
            monthMap.put(8,'August');
            monthMap.put(9,'September');
            monthMap.put(10,'October');
            monthMap.put(11,'November');
            monthMap.put(12,'December');
            String month1 =  monthMap.get(agrment.echosign_dev1__DateSignedDate__c.month());
            Integer day1 = agrment.echosign_dev1__DateSignedDate__c.day();
            Integer year1 = agrment.echosign_dev1__DateSignedDate__c.year();
            sCounterSignDate = month1 + ' '+day1+','+year1;
         }              
        JSONGenerator gen = JSON.createGenerator(true);
                    gen.writeStartObject();
                        gen.writeStringField('apiKey',String.valueOf(DocGen_Callout_Settings__c.getAll().get('DocGen').apiKey__c));
                        gen.writeStringField('templateName','');        
                        gen.writeStringField('watermark','');
                    gen.writeFieldName('nameValuePairs');
          gen.writeStartArray();
                  gen.writeStartObject();
                    gen.writeStringField('name', 'changeOrderType');
                    gen.writeStringField('value', 'Amendment');  
                 gen.writeEndObject(); 
                 gen.writeStartObject();
                    gen.writeStringField('name', 'documentType');
                    gen.writeStringField('value', 'ContractAmendment');  
                 gen.writeEndObject();
              if(primaryContact <> Null && (primaryContact.coFirstName <> null || primaryContact.coLastName <> null)){ 
                 gen.writeStartObject();
                    gen.writeStringField('name', 'customerName');
                    gen.writeStringField('value', primaryContact.coFirstName +' '+primaryContact.coLastName);  
                 gen.writeEndObject(); 
                }  
              if(coSignee <> Null && (coSignee.coFirstName <> null || coSignee.coLastName <> null)){ 
                 gen.writeStartObject();
                    gen.writeStringField('name', 'customerNameCo');
                    gen.writeStringField('value', coSignee.coFirstName +' '+ coSignee.coLastName);  
                 gen.writeEndObject();
               }  
                 gen.writeStartObject();
                    gen.writeStringField('name', 'customerStreetAddress');
                    gen.writeStringField('value', accountInfo.aStreet);  
                 gen.writeEndObject(); 
               gen.writeStartObject();
                    gen.writeStringField('name', 'customerCity');
                    gen.writeStringField('value', accountInfo.acity);  
                 gen.writeEndObject();
                 gen.writeStartObject();
                    gen.writeStringField('name', 'customerState');
                    gen.writeStringField('value', accountInfo.a.billingstate);  
                 gen.writeEndObject(); 
               gen.writeStartObject();
                    gen.writeStringField('name', 'customerPostalCode');
                    gen.writeStringField('value', accountInfo.aZip);  
                 gen.writeEndObject();
                if(sCounterSignDate <> Null){  
                 gen.writeStartObject();
                    gen.writeStringField('name', 'date');
                    gen.writeStringField('value', sCounterSignDate);  
                 gen.writeEndObject();
               }  
                if(primaryContact <> Null && primaryContact.coPhone <> Null ){ 
                 gen.writeStartObject();
                    gen.writeStringField('name', 'customerPhoneNum');
                    gen.writeStringField('value', primaryContact.coPhone);  
                 gen.writeEndObject();
                } 
                if(primaryContact <> Null && primaryContact.coPhone <> Null ){  
                    gen.writeStartObject();
                        gen.writeStringField('name', 'customerEmailAddr');
                        gen.writeStringField('value', primaryContact.coEmail);  
                     gen.writeEndObject(); 
                 }  
               gen.writeStartObject();
                    gen.writeStringField('name', 'contractNum');
                    gen.writeStringField('value',objQuote.Consolidated_Lease_Number__c);  
                 gen.writeEndObject();
                 
               gen.writeStartObject();
                    gen.writeStringField('name', 'dealType');
                    gen.writeStringField('value',objQuote.QuoteType__c);  
                 gen.writeEndObject();
             gen.writeStartObject();
                gen.writeStringField('name', 'dealerContractorsLicense');
                gen.writeStringField('value',objQuote.Partner_Accounts_Contractors_License_Num__c);  
             gen.writeEndObject();
             gen.writeStartObject();
                gen.writeStringField('name', 'dealerInstallerAddress');
                gen.writeStringField('value',objQuote.Partner_Accounts_dealer_address__c);  
             gen.writeEndObject();
            if(objQuote.Account_Phone_Number__c <> null){ 
              gen.writeStartObject();
                  gen.writeStringField('name', 'dealerInstallerPhoneNumber');
                  gen.writeStringField('value',objQuote.Account_Phone_Number__c);  
              gen.writeEndObject();
             } 
             gen.writeStartObject();
                gen.writeStringField('name', 'dealerInstallName');
                gen.writeStringField('value',objQuote.Dealer_Name__c);  
             gen.writeEndObject();   
           gen.writeEndArray();
         gen.writeEndObject();
        gen.close(); 
       system.debug('Request JSON body' + gen.getAsString()); 
       return gen.getAsString();
    }
  /*
    @Name        : sendRequestToDocgen
    @description : It's function to send request to DocGen for HomeOwner Document Creation.
    @parameters  : echosign_dev1__SIGN_Agreement__c agrment,ChangeOrderAmendmentController.AccountInfo accountInfo,ChangeOrderAmendmentController.Cosignee coSignee,string changeOrderType
    @returns     :  echosign_dev1__SIGN_Agreement__c 
   */  
  public static echosign_dev1__SIGN_Agreement__c sendRequestToDocgen(echosign_dev1__SIGN_Agreement__c agrment,ChangeOrderAmendmentController.AccountInfo accountInfo,ChangeOrderAmendmentController.Cosignee primaryContact,ChangeOrderAmendmentController.Cosignee coSignee,string changeOrderType,string Notes){
     try{  
       DocGenContractRequest objDocGen = new DocGenContractRequest();
       objDocGen.quoteId = agrment.Quote__c;
       objDocGen.populateRecords();
        system.debug(LoggingLevel.ERROR, '---objDocGen.quoteRecordToSend----- ' + objDocGen.quoteRecordToSend);
       String requestString = createRequest(agrment,accountInfo,primaryContact,coSignee,objDocGen.quoteRecordToSend);
       amendmentAgreementId = Schema.SObjectType.echosign_dev1__SIGN_Agreement__c.getRecordTypeInfosByName().get('Amendment Agreement').getRecordTypeId(); 
       string agreementName = objDocGen.quoteRecordToSend.Account__r.Name + '-HO Info Amendment-' + objDocGen.quoteRecordToSend.Consolidated_Lease_Number__c + '-' + String.valueOf(System.now()) + '.pdf';
       return objDocGen.handleRequest(requestString,objDocGen.quoteRecordToSend,amendmentAgreementId,agreementName,'',changeOrderType,Notes,CoSignee <> null ? coSignee.con.Id : Null); 
     }
     catch(Exception e){
            system.debug('-----------' + e);
            Exception_Log__c exceptionLog = new Exception_Log__c();
            exceptionLog.Quote__c = agrment.Quote__c;
            exceptionLog.Error_Message__c = e.getMessage();
            exceptionLog.Stack_Trace__c = e.getStackTraceString();
            system.debug('Error is '+e.getMessage()+ ' and stack trace is '+e.getStackTraceString());
     } 
    return null; 
}  

}