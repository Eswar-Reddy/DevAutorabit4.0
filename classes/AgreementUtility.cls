public class AgreementUtility {
    
    public static Id draftRecTypeId = SFDCSpecialUtilities.getRecordTypeIdsByDeveloperName(echosign_dev1__SIGN_Agreement__c.sObjectType).get('Draft_Lease_Contract');
    public static Id leaseRecTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(echosign_dev1__SIGN_Agreement__c.sobjectType).get('Lease_Contract');
    public static Id hicContractRecTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(echosign_dev1__SIGN_Agreement__c.sobjectType).get('HIC_Contract');    
    public static Id lendingAgreementRecTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(echosign_dev1__SIGN_Agreement__c.sobjectType).get('Lending_Agreement');    
    public static Id cancelledRecTypeId = Schema.SObjectType.echosign_dev1__SIGN_Agreement__c.getRecordTypeInfosByName().get('Cancelled').getRecordTypeId();
    public static Id amendmentRecTypeId = Schema.SObjectType.echosign_dev1__SIGN_Agreement__c.getRecordTypeInfosByName().get('Amendment Agreement').getRecordTypeId();

    public static Lease_2_1_PO_Creation__c LeaseValsSettings = Lease_2_1_PO_Creation__c.getValues('Counter Signature Info');
 //   public static FR_Record_Type__c FR_Rec_Type = FR_Record_Type__c.getValues('FR RecordType Id');
    
    public Static Boolean lendingAgreementDeleted = false;
    
    public static Set<String> statusForFutureCall = new Set<String> {
      'Signed', 'Out for Signature', 'Draft'  
    };

    public static void setMessageFields(echosign_dev1__SIGN_Agreement__c agg, String fieldType) {
        
        if(agg == null || fieldType == null) return;
        
        if(fieldType == 'Draft')
            agg.echosign_dev1__Message__c = System.Label.Draft_Agreement_Message;
        if(fieldType == 'Lease') {
            DateTime cd = agg.CreatedDate == null ? System.now() : agg.CreatedDate;
            DateTime expDate = cd.addDays(15);
            String formattedDate = expDate.format('yyyy-mm-dd');
            agg.echosign_dev1__Message__c = 'This document should be signed by all parties on or before ' + formattedDate;
        }
    }

    public static void setAdobeSignFields(echosign_dev1__SIGN_Agreement__c agg){
        if(agg == null) return;
        agg.echosign_dev1__Sender_User__c = Label.Sunpower_Esign_UserId;
        agg.echosign_dev1__Cc__c = [SELECT Email from User where Id = :agg.OwnerId].Email;
    }

    public static void updateCancellationStatus(List<echosign_dev1__SIGN_Agreement__c> aggs, String cancellationStatus ){

        Set<Id> quoteSet            = new Set<Id>();
        Map<Id, String> reasonMap   = new Map<Id, String>();

        Boolean cancelled = cancellationStatus == 'Cancelled';

        for(echosign_dev1__SIGN_Agreement__c agg : aggs){
            quoteSet.add(agg.Quote__c);
            if(cancelled) reasonMap.put(agg.Quote__c, agg.Cancellation_Reason__c);
        }

        List<LeasePayment__c> payments = [SELECT Id, Status__c,Oracle_Cancellation_Status__c, Quote__c FROM LeasePayment__c WHERE Quote__c IN: quoteSet AND Status__c != 'Cancelled'];
        for(LeasePayment__c pay : payments){
            if(cancelled && pay.Oracle_Cancellation_Status__c == 'Cannot Hold.Shipped already')
              pay.Status__c = 'Cancelled with RMA';
            else
            pay.Status__c = cancellationStatus;
            if(cancelled) pay.Reason_for_Cancellation__c = reasonMap.get(pay.Quote__c);
        }
        update payments;

        List<Residential_Project__c> projects = [SELECT Id, Status__c,Quote__c FROM Residential_Project__c WHERE Quote__c IN: quoteSet AND Status__c != 'Cancelled'];
        for(Residential_Project__c proj : projects){
              proj.Status__c = cancellationStatus;
            if(cancelled) proj.Cancellation_Justification__c = reasonMap.get(proj.Quote__c);
        }
        update projects;

    }

    // If Amendment Agreement is 'Signed' affect all Change Audit record changes
    public static void applyChangeAudits(List<Id> aggs){
        Map<String, Map<Id,SObject>> changeMap = new Map<String, Map<Id,SObject>>();
        List<Change_Audit__c> audits = [SELECT Id, Date_of_Change__c, Field_API_Name__c, New_Value__c, Object_Type__c, Object_Id__c FROM Change_Audit__c WHERE Agreement__c IN: aggs];
        if(audits.size() > 0 ){
            for(Change_Audit__c ca : audits){
                sObject sObj;
                Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                Schema.SObjectType soSchema = schemaMap.get(ca.Object_Type__c);
                Map<String, Schema.SObjectField> fieldMap = soSchema.getDescribe().fields.getMap();
                Schema.DisplayType fieldDataType = fieldMap.get(ca.Field_API_Name__c).getDescribe().getType();

                if(changeMap.containsKey(ca.Object_Type__c)){
                    if(changeMap.get(ca.Object_Type__c).containsKey(ca.Object_Id__c)){
                        sObj = changeMap.get(ca.Object_Type__c).get(ca.Object_Id__c);
                        transformType(sObj, fieldDataType, ca);

                    }else{
                        sObj = Schema.getGlobalDescribe().get(ca.Object_Type__c).newSObject(ca.Object_Id__c);
                        transformType(sObj, fieldDataType, ca);
                        changeMap.put(ca.Object_Type__c, new Map<Id, SObject>{ca.Object_Id__c => sObj});
                    }
                }else{
                    sObj = Schema.getGlobalDescribe().get(ca.Object_Type__c).newSObject(ca.Object_Id__c);
                    transformType(sObj, fieldDataType, ca);
                    changeMap.put(ca.Object_Type__c, new Map<Id, SObject>{ca.Object_Id__c => sObj});
                }
                ca.Date_of_Change__c = system.today();
            }
            for(String sType : changeMap.keyset()){
                // For each Object Type, cast records and update
                List<SObject> sObjs = changeMap.get(sType).values();
                String listType = 'List<' + sType + '>';
                List<SObject> castRecords = (List<SObject>)Type.forName(listType).newInstance();
                castRecords.addAll(sObjs);
                system.debug('Inserting records for object type = '+sType+'. Records = '+castRecords);
                update castRecords;

            }
            // If everything goes well, update the change audit record with date stamp to know it has been affected
            update audits;
        }
    }

    private static void transformType(sObject sObj, Schema.DisplayType fieldDataType, Change_Audit__c ca ){
        if(fieldDataType == Schema.DisplayType.Boolean)sObj.put(ca.Field_API_Name__c, Boolean.valueOf(ca.New_Value__c));
        if(fieldDataType == Schema.DisplayType.Integer)sObj.put(ca.Field_API_Name__c, Integer.valueOf(ca.New_Value__c));
        if(fieldDataType == Schema.DisplayType.Double)sObj.put(ca.Field_API_Name__c, Double.valueOf(ca.New_Value__c));
        if(fieldDataType == Schema.DisplayType.Date)sObj.put(ca.Field_API_Name__c, Date.valueOf(ca.New_Value__c));
        if(fieldDataType == Schema.DisplayType.Id)sObj.put(ca.Field_API_Name__c, Id.valueOf(ca.New_Value__c));
        if(fieldDataType == Schema.DisplayType.Phone ||fieldDataType == Schema.DisplayType.String || fieldDataType == Schema.DisplayType.Email || fieldDataType == Schema.DisplayType.Picklist || fieldDataType == Schema.DisplayType.TextArea ) sObj.put(ca.Field_API_Name__c, ca.New_Value__c);
        system.debug('Assigned field = '+ca.Field_API_Name__c+' to new value = '+ca.New_Value__c);
    }

   /*
        @Name        : SendNoticeofCancellationEmail
        @description : Send email to Contact for notice of Cancellation once the agreement is signed.
        @parameters  : list<echosign_dev1__SIGN_Agreement__c> SendNoticeofCancellationEmail
        @returns     : Null
    */
    
     public static void SendNoticeofCancellationEmail (List<attachment> lAttachements){
           // map of NoticeOfCancellation agreement and actual Contract agreement 
           Attachment attch;
           system.debug('lAttachements[0].ParentId.getSobjectType()   ' + lAttachements[0].ParentId.getSobjectType());
           if(lAttachements <> null){
              if(string.valueOf(lAttachements[0].ParentId.getSobjectType()) == 'echosign_dev1__SIGN_Agreement__c')
               attch = lAttachements[0];
             }
           system.debug(logginglevel.Error + '---attch----' + attch);  
           if(attch <> null){
 
               echosign_dev1__SIGN_Agreement__c agg = [select Lease_Number__c,account__c,echosign_dev1__Status__c,change_Order_Type__c from echosign_dev1__SIGN_Agreement__c where Id =: attch.ParentId limit 1]; 
               system.debug(logginglevel.Error + '---agg----' + agg);
               if(agg.echosign_dev1__Status__c == 'Signed' && agg.change_order_Type__c == 'Notice Of Cancellation') { 
                   Map<Id,echosign_dev1__SIGN_Agreement__c> mAgrment = new Map <Id,echosign_dev1__SIGN_Agreement__c> ([select Id,Lease_Number__c,echosign_dev1__Status__c,echosign_dev1__Recipient__c,echosign_dev1__Recipient__r.email, echosign_dev1__Recipient2__r.email,echosign_dev1__Recipient3__c from echosign_dev1__SIGN_Agreement__c 
                                                                                                                where echosign_dev1__Status__c = 'Signed'
                                                                                                                AND account__c =: agg.account__c     
                                                                                                                AND Lease_Number__c =: agg.Lease_Number__c 
                                                                                                                AND ( Id =: attch.ParentId 
                                                                                                                     OR Agreement_Type_2__c = 'Lease Contract'
                                                                                                                     OR Agreement_Type_2__c = 'HIC Contract' 
                                                                                                                     OR Agreement_Type_2__c = 'Cash Contract')]);
                   
                   
                   
                  system.debug(logginglevel.Error + '---mAgrment----' + mAgrment);
                 // Querying the template. 
                   Emailtemplate email = [select Id from Emailtemplate where DeveloperName = 'Notice_of_Cancellation'];
                   
                   //adding the email address from NoticeOfCancellation agreement.
                   List<string> toaddress = new List<string>();
                   if(mAgrment.containskey(attch.ParentId) && mAgrment.get(attch.ParentId).echosign_dev1__Recipient__r.email <> Null)
                      toaddress.add(mAgrment.get(attch.ParentId).echosign_dev1__Recipient__r.email);
                   if(mAgrment.containskey(attch.ParentId) && mAgrment.get(attch.ParentId).echosign_dev1__Recipient2__r.email <> Null)
                      toaddress.add(mAgrment.get(attch.ParentId).echosign_dev1__Recipient2__r.email);
                   
                   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                       system.debug('----toaddress-----' + toaddress);
                   mail.setToAddresses(toaddress);
                   mail.SetTemplateId(email.Id);
                   if(mAgrment.containskey(attch.ParentId))
                      mail.setTargetObjectId(mAgrment.get(attch.ParentId).echosign_dev1__Recipient__c);
                   mail.setSaveAsActivity(false); 
                  // assinging the Id of the actual agreemnt. 
                   for(Id agrId : mAgrment.keyset()){
                        if(agrId <> attch.ParentId )
                            mail.setwhatId(agrId);  
                     }
                   List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                   Messaging.Emailfileattachment attchFile = new Messaging.Emailfileattachment();
                    attchFile.setFileName(attch.Name);
                    attchFile.setBody(attch.Body);
                    fileAttachments.add(attchFile);
                  mail.setFileAttachments(fileAttachments);
                  Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
                } 
           }

      }
  /*
    @Name        : sendAgreementStatusNotification
    @description : Send email to Contact for notice of Cancellation once the agreement is signed.
    @parameters  : list<echosign_dev1__SIGN_Agreement__c> SendNoticeofCancellationEmail
    @returns     :    Null
    Change Orders - June 2017 
   */
    public static void sendAgreementStatusNotification (List<Id> aggLst, Id newPOId){

        string quoteType = 'Quote';
        string subject;
        string quoteComparison = '';
       // map of NoticeOfCancellation agreement and actual Contract agreement
        if(aggLst <> null && aggLst.size() > 0){
         List<echosign_dev1__SIGN_Agreement__c> agg = [select Lease_Number__c,account__c,account__r.Name,CreatedBy.Name,echosign_dev1__Status__c,change_Order_Type__c,
                                                       account__r.Partner_Account__r.Primary_PSR__c,account__r.Partner_Account__r.Primary_PSR_Email__c,
                                                       account__r.Partner_Account__r.Name,quote__c,quote__r.Amended_Lease__r.Id
                                                       from echosign_dev1__SIGN_Agreement__c
                                                       where Id =:aggLst[0]  Limit 1];

        // returning from class if economic and signed aggrement ; these greement are being sent in PO after insert trigger
        if(agg[0].echosign_dev1__Status__c == 'Signed' && agg[0].change_Order_Type__c == 'Economic Amendment' && newPOId == Null)
           return;

        String orgURL = Url.getSalesforceBaseUrl().toExternalForm();

        // assigning dynamic variable to chagne text based on agreement type
        if(agg[0].change_order_Type__c == 'HomeOwner Information Change')
             quoteType = 'HO Info';
        // different subject based on different status
        if(agg[0].echosign_dev1__Status__c == 'Out for Signature'){
            subject = agg[0].account__r.Name  + ': ' + quoteType +' Amendment Sent for Signature ' + '(' + agg[0].Lease_Number__c + ')' ;
        }
        else if(agg[0].echosign_dev1__Status__c == 'Waiting for Counter-Signature') {
            subject = agg[0].account__r.Name  + ': ' + quoteType +' Amendment Signed ' + '(' + agg[0].Lease_Number__c + ')' ;
          if(quoteType == 'Quote')
             quoteComparison = '<br/>'  + 'Quote Comparison: ' + orgURL + QuoteAmendmentUtility.getQuoteDeltaURL(agg[0].quote__c,agg[0].quote__r.Amended_Lease__r.Id);
        }
        else if(agg[0].echosign_dev1__Status__c == 'Signed'){
            subject = agg[0].account__r.Name  + ': ' + quoteType +' Amendment Countersigned ' + '(' + agg[0].Lease_Number__c + ')' ;
            if(quoteType == 'Quote'){
                quoteComparison = '<br/>'  + 'Quote Comparison: ' + orgURL + QuoteAmendmentUtility.getQuoteDeltaURL(agg[0].quote__c,agg[0].quote__r.Amended_Lease__r.Id);
                string poComparison = PurchaseOrderUtility.getPODeltaURL(newPOId,agg[0].quote__r.Amended_Lease__r.Id);
                if(!String.isEmpty(poComparison))
                  quoteComparison = quoteComparison + + '<br/>' + 'PO Comparison: ' +  orgURL + poComparison;
            }
          }
        else if(agg[0].echosign_dev1__Status__c == 'Cancelled') {
            quoteType = 'Pending ' +  quoteType;
            subject = agg[0].account__r.Name  + ': ' +  quoteType +' Amendment Cancelled ' + '(' + agg[0].Lease_Number__c + ')' ;
        }
        else{
            subject = agg[0].account__r.Name  + ': ' + quoteType +' amendment ' + agg[0].echosign_dev1__Status__c + ' (' + agg[0].Lease_Number__c + ')' ;
        }

        Id requestorId = [select contactId from User where Id =: UserInfo.getUserId() Limit 1].ContactId;

        if(requestorId == null)
          requestorId = UserInfo.getUserId();

        string emailBody = '<HTML><body>' +
                            'Activity: '  + quoteType + ' amendment is ' + agg [0].echosign_dev1__Status__c + '<br/>'  +
                                            'Requestor: ' + agg [0].account__r.Partner_Account__r.Name + ' - ' + UserInfo.getName() + '  (' + orgURL + '/' + requestorId + ') <br/>'  +
                                            'Customer: ' + agg[0].account__r.Name  + '  (' + orgURL + '/' + agg[0].account__c + ') <br/>'  +
                                            'Agreement: ' + URL.getSalesforceBaseUrl().toExternalForm()+'/'+ agg[0].Id + '<br/>'  +
                                            'Countersigned Agreement: ' + agg[0].Lease_Number__c + 
                                            quoteComparison + '</body></HTML>';


         //adding the email address from NoticeOfCancellation agreement.
        List<string> toaddress = new List<string> {'leasecontrolspsr@sunpowercorp.com','paymentInquiry@sunpowercorp.com'};
        if(agg[0].account__r.Partner_Account__r.Primary_PSR_Email__c <> null)
           toaddress.add(agg[0].account__r.Partner_Account__r.Primary_PSR_Email__c);
        if(agg[0].echosign_dev1__Status__c == 'Waiting for Counter-Signature')
           toaddress.add('SunPowerFinancing@sunpowercorp.com');
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject(subject);
        mail.setToAddresses(toaddress);
        mail.setHtmlBody( emailBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
       }
   }
    /*
    @Name        : updateAmendmentNotesOnLeasePayment
    @description : Update the notes on Lease Payment for signed Amendment.
    @parameters  : List<echosign_dev1__SIGN_Agreement__c> 
    @returns     : null
    Change Orders - June 2017 
   */

   public static void updateAmendmentNotesOnLeasePayment(List<echosign_dev1__SIGN_Agreement__c> lstagg){
       Map<Id,string> notesMap = new Map<Id,string>();
       Set<Id> accountSet            = new Set<Id>();
       for(echosign_dev1__SIGN_Agreement__c agg : lstagg){
            accountSet.add(agg.Account__c);
            notesMap.put(agg.Account__c, agg.Notes__c);
        }
      List<LeasePayment__c> payments = [SELECT Id, Status__c,End_Customer_Account__c,Oracle_Cancellation_Status__c,Lease_Change_Notes__c,LPS_Notes__c,Quote__c FROM LeasePayment__c WHERE End_Customer_Account__c IN: accountSet];
      for(LeasePayment__c pay : payments){
            if (pay.LPS_Notes__c == null) 
                  pay.LPS_Notes__c = notesMap.get(pay.End_Customer_Account__c);
            else 
                  pay.LPS_Notes__c += notesMap.get(pay.End_Customer_Account__c);   
        }
      if(payments <> null)  
         update payments; 
    }
	
    //Update Opportunity Deal type to 'NH-Lease' on agreement status is 'Waiting for Counter-Signature' or 'Signed'
    Public static void UpdateOppurtunutyDealType(Set<Id> fpos){
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();

        try{
            for(echosign_dev1__SIGN_Agreement__c agg: [SELECT RecordType.Name, Quote__r.OpportunityId, Quote__r.Opportunity.Contract_Type__c FROM echosign_dev1__SIGN_Agreement__c WHERE Id IN: fpos AND Quote__r.Opportunity.Partner_Account_text__c = 'SunPower New Homes']){
                String contractType = agg.RecordType.Name == 'Cash Contract' ? 'NH - Cash' : agg.RecordType.Name == 'Lease Contract' ? 'NH - Lease' : NULL;
                if(contractType != NULL && agg.Quote__r.Opportunity.Contract_Type__c != contractType){
                    Opportunity opp = new Opportunity();
                    opp.Id = agg.Quote__r.OpportunityId;
                    opp.Contract_Type__c = contractType;
                    oppMap.put(opp.Id, opp);
                }
            }
            update oppMap.values();

        } catch(Exception e) {
            ExLog.log(e);
        }  
    }
}