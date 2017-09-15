/* **************************************************************************************
* Class Name     : CreateCashNTS
* Version        : 1.0
* Created Date   : 02 feb 2017
* Function       : It's a class to send the request to DocGen for creating the Cash NTS Document.

* Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
* Ankit                      02 feb 2017          Original Version
*************************************************************************************/
public class CreateCashNTS {

    public static Account acc;
    public static string formatteddate;

    public CreateCashNTS (){

        acc = [ select Id,name,billingStreet,billingCity,billingState,billingCountry,billingPostalCode,
                        (select Id,Name,Email from Contacts where Include_in_Lease_Doc__c = true),
                        (select Id,Plan_Type__c,System_Size_KwP__c,Lot_Number__c,Campaign.NH_Community__r.Name,Campaign.NH_Community__r.Builder__r.Name from Opportunities limit 1),
                        (select Id,name,Agreement_Type_2__c,echosign_dev1__Status__c from Agreements__r where echosign_dev1__Status__c = 'Signed' AND Agreement_Type_2__c = 'Cash Contract' Limit 1),
                        (select Id,System_Size__c,Is_Locked__c,Consolidated_Lease_Number__c,Maximum_Rated_Capacity__c from Quotes__r where Id =:ApexPages.currentPage().getParameters().get('Id'))
                        from Account where Id =: ApexPages.currentPage().getParameters().get('accId')];

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

            String month1 = monthMap.get(Date.today().month());
            Integer day1 = Date.today().day();
            Integer year1 = Date.today().year();
            formatteddate = month1 + ' '+day1+','+year1;

          }

   /*
    @Name        : createNTSRequest
    @description : It's function to create the body of the request.
    @parameters  :
   */
   public static string createNTSRequest (string documentType){

        if(acc == Null)
           return null;

        if(acc.Agreements__r.size()>0){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Signed NTS Agreement already exists !!'));
           return null;
         }

        JSONGenerator gen = JSON.createGenerator(true);
                    gen.writeStartObject();
                        gen.writeStringField('apiKey',String.valueOf(DocGen_Callout_Settings__c.getAll().get('DocGen').apiKey__c));
                        gen.writeStringField('templateName','');
                        gen.writeStringField('watermark','');
                    gen.writeFieldName('nameValuePairs');
          gen.writeStartArray();
              gen.writeStartObject();
                gen.writeStringField('name', 'documentType');
                gen.writeStringField('value', documentType);
              gen.writeEndObject();

              gen.writeStartObject();
                gen.writeStringField('name', 'date');
                gen.writeStringField('value', formatteddate);
              gen.writeEndObject();

              if(acc.Name <> Null){
                 gen.writeStartObject();
                    gen.writeStringField('name', 'customerName');
                    gen.writeStringField('value', acc.Name);
                 gen.writeEndObject();
                }
                gen.writeStartObject();
                    gen.writeStringField('name', 'customerStreetAddress');
                    gen.writeStringField('value', acc.billingStreet);
                 gen.writeEndObject();
               gen.writeStartObject();
                    gen.writeStringField('name', 'customerCity');
                    gen.writeStringField('value', acc.billingCity);
                 gen.writeEndObject();
                 gen.writeStartObject();
                    gen.writeStringField('name', 'customerState');
                    gen.writeStringField('value', acc.billingState);
                 gen.writeEndObject();
               gen.writeStartObject();
                    gen.writeStringField('name', 'customerPostalCode');
                    gen.writeStringField('value', acc.billingPostalCode);
                 gen.writeEndObject();

                if(acc.Opportunities[0].Lot_Number__c == null){
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Please provide lot Number on related Opportunity'));
                   return null;
               }
              else{
                 gen.writeStartObject();
                    gen.writeStringField('name', 'lotNumber');
                    gen.writeStringField('value', acc.Opportunities[0].Lot_Number__c);
                 gen.writeEndObject();
               }


               if(acc.Opportunities[0].Campaign.NH_Community__r.Name == null){
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Please provide Community on related Opportunity Campaign Source'));
                   return null;
               }
              else{
                 gen.writeStartObject();
                    gen.writeStringField('name', 'communityName');
                    gen.writeStringField('value', acc.Opportunities[0].Campaign.NH_Community__r.Name);
                 gen.writeEndObject();
               }


               if(acc.Opportunities[0].Plan_Type__c == null){
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Please provide plan type on related Opportunity'));
                   return null;
               }
              else{
                 gen.writeStartObject();
                    gen.writeStringField('name', 'planType');
                    gen.writeStringField('value', acc.Opportunities[0].Plan_Type__c);
                 gen.writeEndObject();
               }

              if(acc.Opportunities[0].Campaign.NH_Community__r.Builder__r.Name == null){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Please provide Campaign source or builder name on Community'));
                    return null;
                 }
               else{
                 gen.writeStartObject();
                    gen.writeStringField('name', 'builder');
                    gen.writeStringField('value', acc.Opportunities[0].Campaign.NH_Community__r.Builder__r.Name);
                 gen.writeEndObject();
                }
               if(acc.Quotes__r[0].Maximum_Rated_Capacity__c == null){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Please provide maximum rated capcity on Quote'));
                    return null;
               }
               else{
                gen.writeStartObject();
                    gen.writeStringField('name', 'systemSize');
                    gen.writeStringField('value', string.valueOf(acc.Quotes__r[0].Maximum_Rated_Capacity__c));
                 gen.writeEndObject();
               }
           gen.writeEndArray();
         gen.writeEndObject();
        gen.close();
       system.debug('Request JSON body' + gen.getAsString());
       return gen.getAsString();
    }

    /*
    @Name        : sendNTSRequestToDocgen
    @description : It's function to send request to DocGen for HomeOwner Document Creation.
    @parameters  : echosign_dev1__SIGN_Agreement__c agrment,ChangeOrderAmendmentController.AccountInfo accountInfo,ChangeOrderAmendmentController.Cosignee coSignee,string changeOrderType
    @returns     :  echosign_dev1__SIGN_Agreement__c
   */
  public static PageReference sendNTSRequestToDocgen(){
     try{

        HttpRequest request = new HttpRequest();
        request.setEndpoint(DocGen_Callout_Settings__c.getAll().get('DocGen').EndPoint_Contract__c);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setTimeout(60000);
        string requestBody = createNTSRequest('NTS');
        system.debug('--requestBody--' +requestBody);
       if(requestBody <> Null){
            request.setBody(requestBody);
            Http httpReq = new Http();
            HttpResponse res;
           if(!Test.isRunningTest()){
               res = httpReq.send(request);
               system.debug('----res----' + res);
            }
            if((res != null && res.getStatusCode() == 200) || Test.isRunningTest()){
               // Creating the Agreement record
                echosign_dev1__SIGN_Agreement__c newAgreement = new echosign_dev1__SIGN_Agreement__c();
                newAgreement.recordTypeId = Schema.SObjectType.echosign_dev1__SIGN_Agreement__c.getRecordTypeInfosByName().get('Cash Contract').getRecordTypeId();
                newAgreement.Quote__c = acc.Quotes__r[0].Id;
                newAgreement.Account__c = acc.Id;
                if(acc.Opportunities[0] <> null){
                  newAgreement.Opportunity__c = acc.Opportunities[0].Id;
                }  
                newAgreement.Name = acc.Name + '-Cash Document-' + acc.Quotes__r[0].Consolidated_Lease_Number__c + '-' + String.valueOf(System.today())+ '.pdf';
                newAgreement.echosign_dev1__Status__c = 'Draft';
                if(acc.Contacts[0] <> null && acc.Contacts[0].Email <> null)
                  newAgreement.echosign_dev1__Recipient__c = acc.Contacts[0].Id;
                newAgreement.Agreement_Name__c = acc.Name + '-Cash Document-' + acc.Quotes__r[0].Consolidated_Lease_Number__c + '-' + String.valueOf(System.today())+ '.pdf';
               insert newAgreement;

              // creating the attachment and attaching it to the agreement record and also creating the request as an attachment to Quote
                List<Attachment> attachmentList = new List<Attachment>();

                // Attachment of the response to the agreement record
                Attachment newAttachment = new Attachment();
                newAttachment.ParentId = newAgreement.Id;
                newAttachment.Body = Test.isRunningTest()? Blob.valueOf(requestBody) : res.getBodyAsBlob();
                newAttachment.Name = acc.Name + '-Cash Document-' + acc.Quotes__r[0].Consolidated_Lease_Number__c + '-' + String.valueOf(System.today())+ '.pdf';
                attachmentList.add(newAttachment);

                // adding the attachment of response to the Quote record
                newAttachment = new Attachment();
                newAttachment.ParentId = acc.Quotes__r[0].Id;
                newAttachment.Body = Test.isRunningTest()? Blob.valueOf(requestBody) : res.getBodyAsBlob();
                newAttachment.Name = 'DocGen NTS Cash Contract Response.pdf';
                attachmentList.add(newAttachment);

                // adding the attachment of request to the Quote record
                newAttachment = new Attachment();
                newAttachment.ParentId = acc.Quotes__r[0].Id;
                newAttachment.Body = Blob.valueOf(requestBody);
                newAttachment.Name = 'DocGen NTS Cash Contract Request.txt';
                attachmentList.add(newAttachment);
                insert attachmentList;

                PageReference pageRef = new PageReference('/' + newagreement.Id);

                return pageRef;
            }
         }
      }
     catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, E.getMessage() + e.getLineNumber()));
            Exception_Log__c exceptionLog = new Exception_Log__c();
            exceptionLog.Quote__c = acc.Quotes__r[0].Id;
            exceptionLog.Error_Message__c = e.getMessage();
            exceptionLog.Stack_Trace__c = e.getStackTraceString();
            system.debug('Error is '+e.getMessage()+ ' and stack trace is '+e.getStackTraceString() + 'Line Number' + e.getLineNumber());
     }
    return null;
}

}