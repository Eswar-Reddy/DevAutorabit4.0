public class TPSDocumentUtility {

   private static final String attachUrl = 'https://' + URL.getSalesforceBaseUrl().getHost() + '/servlet/servlet.FileDownload?file=';
   private static final String sHOLayoutApproval = 'HO Layout Approval';
   private static final String sStatus = 'Approved';
   private static final String sCustomerAcceptanceForm = 'Customer Acceptance Form';
   private static final String sDesignLayout = 'Design Layout';
   private static final string sSignedStatus = 'Signed';

    /*
    @Name        : updateInvoiceDocumentWithUploaded
    @description : It's function to check uploaded on Invoice Document record when shared document is uploaded.
    @parameters  : (Trigger.New)
    @returns     :  Void.
    */

    public static void updateInvoiceDocumentWithUploaded (map<Id,attachment> TriggerNewMap){

         Set<Id> documentIds = new set<Id> ();
         Set<Id> invdocumentIds = new set<Id> ();
         Map<Id,List<Document__c>> mOppIdsWithDocuments = new Map<Id,List<Document__c>>();
         List<Invoice_Documents__c> lInvoiceDocuments = new List<Invoice_Documents__c> ();
         Id attachId;


         for( Attachment A : TriggerNewMap.values()){
              if(string.valueof(A.ParentId.getSobjectType()) == 'Document__c')
                 documentIds.add(A.ParentId);
                 attachId = A.Id;
               
              if(string.valueof(A.ParentId.getSobjectType()) == 'Invoice_Documents__c')
                 invdocumentIds.add(A.ParentId);
                 attachId = A.Id;
               
              }

      if(documentIds.size()>0)
        for (Document__c doc : [select Id,Document_Type__c,Account__c,
                                                Agreement__c,Extension__c,Quote__c,
                                                URL__c,Type__c,Opportunity__c, Residential_Project__c
                                                from Document__c  where Id IN : documentIds]){
                    if(doc.Opportunity__c <> Null){
                         if(!mOppIdsWithDocuments.Containskey(doc.Opportunity__c))
                                mOppIdsWithDocuments.put(doc.Opportunity__c,new list<document__c>());
                           mOppIdsWithDocuments.get(doc.Opportunity__c).add(doc);
                     }

                   if(doc.Account__c <> Null){
                      if(!mOppIdsWithDocuments.Containskey(doc.Account__c))
                            mOppIdsWithDocuments.put(doc.Account__c,new list<document__c>());
                       mOppIdsWithDocuments.get(doc.Account__c).add(doc);
                     }

                   if(doc.Residential_Project__c <> Null){
                      if(!mOppIdsWithDocuments.Containskey(doc.Residential_Project__c))
                            mOppIdsWithDocuments.put(doc.Residential_Project__c,new list<document__c>());
                       mOppIdsWithDocuments.get(doc.Residential_Project__c).add(doc);
                     }

          }
        system.debug('********' + mOppIdsWithDocuments);
        if(!mOppIdsWithDocuments.isEmpty() || !invdocumentIds.isEmpty())
        for( Invoice_Documents__c oInvDoc : [Select Id,Name,Documents_in_File__c,Lease_Payment__r.Opportunity__c,Lease_Payment__r.End_Customer_Account__c, Lease_Payment__r.Residential_Project__c from Invoice_Documents__c where Lease_Payment__r.Opportunity__c IN :mOppIdsWithDocuments.keyset() OR Lease_Payment__r.End_Customer_Account__c IN : mOppIdsWithDocuments.keyset() OR Lease_Payment__r.Residential_Project__c IN : mOppIdsWithDocuments.keyset() OR Id IN : invdocumentIds]){
                      List<Document__c> tempLstDoc = new List<Document__c> ();
                       if (mOppIdsWithDocuments.Containskey(oInvDoc.Lease_Payment__r.Opportunity__c))
                            tempLstDoc.addall(mOppIdsWithDocuments.get(oInvDoc.Lease_Payment__r.Opportunity__c));
                       if(mOppIdsWithDocuments.Containskey(oInvDoc.Lease_Payment__r.End_Customer_Account__c))
                            tempLstDoc.addall(mOppIdsWithDocuments.get(oInvDoc.Lease_Payment__r.End_Customer_Account__c));
                      if(mOppIdsWithDocuments.Containskey(oInvDoc.Lease_Payment__r.Residential_Project__c))
                            tempLstDoc.addall(mOppIdsWithDocuments.get(oInvDoc.Lease_Payment__r.Residential_Project__c));
                      if(invdocumentIds.contains(oInvDoc.Id)){
                          oInvDoc.Status__c = 'Pending';
                          oInvDoc.Link_to_Attachment__c = attachUrl + attachId;
                          oInvDoc.Document_Submitted__c = Date.today();
                          lInvoiceDocuments.add(oInvDoc);
                      }

                      for( Document__c tempDoc : tempLstDoc) {
                                 if(oInvDoc.Documents_in_File__c == tempDoc.Document_Type__c){
                                      oInvDoc.Status__c = 'Pending';
                                      oInvDoc.Link_to_Attachment__c = attachUrl + attachId;
                                      oInvDoc.Document_Submitted__c = Date.today();
                                      lInvoiceDocuments.add(oInvDoc);
                                 }
                              }

                 }

                if(lInvoiceDocuments.size()>0)
                  update lInvoiceDocuments;
          }

   /*
    @Name        : fUpdateHomeOwnerApproval
    @description : It's function to check update the Invoice Document after the agreement is Signed and HO approval layout approved.
    @parameters  : (TriggerOldMap and TriggerNewMap)
    @returns     :  Void.
    */
     public static  void fUpdateHomeOwnerApproval ( Map<Id, echosign_dev1__SIGN_Agreement__c> TriggerOldMap , Map<Id,echosign_dev1__SIGN_Agreement__c> TriggerNewMap){
                  
                  Map<Id,Map<string,string>> mAccIdWithDocumentLink = new Map<Id,Map<string,string>>();
                  List<Invoice_Documents__c> lInvoiceDocuments = new List<Invoice_Documents__c> ();
                  Map<Id,Id> mAgreementWithContractAccoount = new map<Id,Id> ();
                  Map<Id,echosign_dev1__SIGN_Agreement__c> mAgreementIdsToProcess = new map<Id,echosign_dev1__SIGN_Agreement__c>();
                  Map<Id,set<string>> mEndCostomerwithDocumentType = new Map<Id,set<string>>();
       
                 for(echosign_dev1__SIGN_Agreement__c A : TriggerNewMap.values()) {
                     if ((A.contract_Type__c ==  sDesignLayout || A.contract_Type__c == sCustomerAcceptanceForm) && A.echosign_dev1__Status__c == sSignedStatus && TriggerOldMap.get(A.Id).echosign_dev1__Status__c <> sSignedStatus) 
                         mAgreementIdsToProcess.put(a.Id,A);
                 }
                 
                 if(mAgreementIdsToProcess.isEmpty()) return;
                 
                 for ( echosign_dev1__SIGN_Agreement__c oAgreement : [select Id,echosign_dev1__Contract__r.accountId,echosign_dev1__Contract__r.account.Multiple_Meters__c,Contract_Type__c from echosign_dev1__SIGN_Agreement__c where Id IN : mAgreementIdsToProcess.keyset()]){
                                  
                     if(!oAgreement.echosign_dev1__Contract__r.account.Multiple_Meters__c){
                                mAgreementWithContractAccoount.put(oAgreement.Id,oAgreement.echosign_dev1__Contract__r.accountId);
                                if(!mEndCostomerwithDocumentType.containskey(oAgreement.echosign_dev1__Contract__r.accountId))
                                         mEndCostomerwithDocumentType.put(oAgreement.echosign_dev1__Contract__r.accountId,new set<string>());
                                     mEndCostomerwithDocumentType.get(oAgreement.echosign_dev1__Contract__r.accountId).add(oAgreement.Contract_Type__c);
                     			}
                            }

		    system.debug('==1==' + mAgreementWithContractAccoount)	;	 
         if(!mAgreementWithContractAccoount.isEmpty())	
                 for( echosign_dev1__SIGN_Agreement__c A : mAgreementIdsToProcess.values()){
                           if(!mAccIdWithDocumentLink.Containskey(mAgreementWithContractAccoount.get(A.Id)))
                                        mAccIdWithDocumentLink.put(mAgreementWithContractAccoount.get(A.Id),new map<string,string> ());
                              mAccIdWithDocumentLink.get(mAgreementWithContractAccoount.get(A.Id)).put(A.contract_Type__c,A.echosign_dev1__SignedPDF__c);
                              
                               
                            }
                  
                 system.debug('==2===='+ mEndCostomerwithDocumentType);      
                 if(!mAccIdWithDocumentLink.isEmpty() )
                          for(Invoice_Documents__c Inv : [ Select Id,Name,Documents_in_File__c,Lease_Payment__r.Opportunity__c,
                                                                            Lease_Payment__r.End_Customer_Account__c from Invoice_Documents__c
                                                                            where Lease_Payment__r.End_Customer_Account__c  IN : mAccIdWithDocumentLink.keyset()  AND (Documents_in_File__c = : sHOLayoutApproval OR Documents_in_File__c = : sCustomerAcceptanceForm)]) {

                          if(Inv.Documents_in_File__c == sHOLayoutApproval && mEndCostomerwithDocumentType.get(Inv.Lease_Payment__r.End_Customer_Account__c).contains(sDesignLayout)) {
                               Inv.Status__c = sStatus;
                               Inv.Link_to_Attachment__c = mAccIdWithDocumentLink.get(Inv.Lease_Payment__r.End_Customer_Account__c).get(sDesignLayout);
                               Inv.Document_Submitted__c = Date.today();
                               lInvoiceDocuments.add(Inv);
                              }
                          if(Inv.Documents_in_File__c == sCustomerAcceptanceForm && mEndCostomerwithDocumentType.get(Inv.Lease_Payment__r.End_Customer_Account__c).contains(sCustomerAcceptanceForm)){
                               Inv.Status__c = sStatus;
                               Inv.Link_to_Attachment__c = mAccIdWithDocumentLink.get(Inv.Lease_Payment__r.End_Customer_Account__c).get(sCustomerAcceptanceForm);
                               Inv.Document_Submitted__c = Date.today();
                               lInvoiceDocuments.add(Inv);

                              }
                        }

                   if(lInvoiceDocuments.size()>0)
                      update lInvoiceDocuments;
   }
   
   /*
    @Name        : fApproveLeaseContractCreation
    @description : It's function to check whether Partner uploaded all the required documents. InvoiceDocumentData will have list of the required document. 
                   To make the document required for create lease Contract check "required for Lease Creation" on InvoiceDocumentData object. 
    @parameters  : (TriggerOldMap and TriggerNewMap)
    @returns     :  Void.
    */
    public static void fApproveLeaseContractCreation(map<Id,attachment> TriggerNewMap){
          system.debug('Function Called');
          Set<Id> sDocumentIds = new Set<Id> ();
          Set<Id> sQuoteIds = new set<Id> ();
          Map<Id,Map<string,List<attachment>>> mQutoteDocumentTypeWithAttachment = new Map<Id,Map<string,List<attachment>>>();
          List<String> lRequiredDocuments = new List<string> ();
          boolean bUpdateQuote;
          list<Quote> lQuoteToUpdate = new list<Quote> ();

         for( Attachment A : TriggerNewMap.values()){
              if(string.valueof(A.ParentId.getSobjectType()) == 'Document__c')
                    sDocumentIds.add(A.ParentId);
              }
         
         if(sDocumentIds.isEmpty()) return;
         
         for(Document__c D : [select Id,Quote__C,Quote__r.Ok_to_Create_Lease_Contract__c,Quote__r.Quote_type__c from Document__c where Id IN :sDocumentIds]){
                  if(!(D.Quote__r.Ok_to_Create_Lease_Contract__c) && D.Quote__r.Quote_type__c == 'TPS Quote')
                      sQuoteIds.add(D.Quote__c);
          }

         if(sQuoteIds.isEmpty()) return;
          
         for(Document__c D : [Select Id,Quote__c,Document_Type__c,(Select Id,name from attachments) from Document__c where Quote__c IN :sQuoteIds]){
                      system.debug('=======' + D);
                      if(!mQutoteDocumentTypeWithAttachment.Containskey(D.Quote__c)) 
                             mQutoteDocumentTypeWithAttachment.put(D.Quote__c,new Map<string,List<attachment>>());
                       if(!mQutoteDocumentTypeWithAttachment.get(D.Quote__c).Containskey(D.Document_Type__c))
                            mQutoteDocumentTypeWithAttachment.get(D.Quote__c).put(D.Document_Type__c,new list<attachment>());
                         mQutoteDocumentTypeWithAttachment.get(D.Quote__c).get(D.Document_Type__c).addall(D.attachments); 
                       
                 }      

         system.debug('----Map Output----' + mQutoteDocumentTypeWithAttachment);
         
         for ( Id QId : mQutoteDocumentTypeWithAttachment.keyset()){
             bUpdateQuote = true;  
             for ( Invoice_Document_Data__c oIDD : [select Id,Name from Invoice_Document_Data__c where Required_for_Lease_Contract_Creation__c = true]){
                     if(!(mQutoteDocumentTypeWithAttachment.get(QId).Containskey(oIDD.Name) && mQutoteDocumentTypeWithAttachment.get(QId).get(oIDD.Name).size() > 0)){
                          bUpdateQuote = false;
                          break;
                      }
              }
              
         
              if(bUpdateQuote)
                  lQuoteToUpdate.add(new Quote ( Id = QId,Ok_to_Create_Lease_Contract__c = true));
              }

              if(lQuoteToUpdate.size()>0)
                 update lQuoteToUpdate;                  
                  
          }   
   
}