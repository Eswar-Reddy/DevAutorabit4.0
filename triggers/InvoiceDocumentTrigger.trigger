trigger InvoiceDocumentTrigger on Invoice_Documents__c (before update, after update) {

    
    //If trigger is in before update invoice documents, then check if the invoice documents is pending, null out the notes to dealer field
    if(Trigger.isBefore && Trigger.isUpdate)
    {
        //Make sure this funciton only execute once
        if(InvoiceDocumentServices.firstRunBefore){
            //Filter out the pending invoice documents without null notes to dealer
            List<Invoice_Documents__c> pendingInvoiceDocs = Select.Field.hasChanged(Invoice_Documents__c.Status__c).
            andx(Select.Field.isEqual(Invoice_Documents__c.Status__c, InvoiceDocumentServices.PENDING)).
            andx(Select.Field.notEqual(Invoice_Documents__c.Notes_to_Dealer__c, InvoiceDocumentServices.DEFAULT_NOTES_TO_DEALER)).filter(Trigger.new, Trigger.oldMap);

            //Execute the real function in Service class
            if(!pendingInvoiceDocs.isEmpty())
            {
                InvoiceDocumentServices.removeNotesToDealer(pendingInvoiceDocs);
            }
            
            InvoiceDocumentServices.firstRunBefore = false;
        }
    }
    
    if(Trigger.isAfter && Trigger.isUpdate)
    {   
        System.debug('Inise After Update----->');
        ////Code to update field that will trigger Submit final review outbound message to Informatica
        Map<String,Mosaic_Upload_Documents__c> mudMap = Mosaic_Upload_Documents__c.getAll();
        System.debug('mudMap----->'+mudMap);
        //fpo Id Set
        Set<Id> fpoIdSet = new Set<Id>();
        
        for(Invoice_Documents__c iDoc:Trigger.new){
            fpoIdSet.add(iDoc.Lease_Payment__c);
        }
        System.debug('fpoIdSet----->'+fpoIdSet);
        
        Map<Id,LeasePayment__c > fpoMap = new Map<Id,LeasePayment__c>([select Id,(select Id,Documents_in_File__c,Mosaic_Status__c from Invoice_Documents__r) from LeasePayment__c where Id in :fpoIdSet and Quote__r.QuoteType__c = 'Loan']);
        List<LeasePayment__c> fpoList = new List<LeasePayment__c>([select Id,(select Id,Documents_in_File__c,Mosaic_Status__c from Invoice_Documents__r) from LeasePayment__c where Id in :fpoIdSet and Quote__r.QuoteType__c = 'Loan']);
        System.debug('fpoList----->'+fpoList);
        
        //Map of (FPO Id and Map of (Inovice Document Name, Invoice Document))
        Map<Id,Map<String,Invoice_Documents__c>> fPOIdIDNameandIDMap = new Map<Id,Map<String,Invoice_Documents__c>>();
        
        for(LeasePayment__c fpo:fpoList){
            System.debug('IDs----->'+fpo.Invoice_Documents__r);
            Map<String,Invoice_Documents__c> tempIDMap = new Map<String,Invoice_Documents__c>();
            
            for(Invoice_Documents__c id:fpo.Invoice_Documents__r){
                if(mudMap.containsKey(id.Documents_in_File__c)){
                    tempIDMap.put(id.Documents_in_File__c,id);
                }
            }
            
            fPOIdIDNameandIDMap.put(fpo.Id,tempIDMap);
        }
        
        System.debug('fPOIdIDNameandIDMap----->'+fPOIdIDNameandIDMap);
        
        List<LeasePayment__c> fpoUpdateList = new List<LeasePayment__c>();
        
        for(LeasePayment__c fpo:fpoList){
            if(fPOIdIDNameandIDMap.get(fpo.Id).containsKey('PTO Letter') && fPOIdIDNameandIDMap.get(fpo.Id).get('PTO Letter').Mosaic_Status__c == 'Upload Success'  
               && fPOIdIDNameandIDMap.get(fpo.Id).containsKey('Final Permit') && fPOIdIDNameandIDMap.get(fpo.Id).get('Final Permit').Mosaic_Status__c == 'Upload Success' 
               && fPOIdIDNameandIDMap.get(fpo.Id).containsKey('Photos') && fPOIdIDNameandIDMap.get(fpo.Id).get('Photos').Mosaic_Status__c == 'Installation confirmed'
              ){
                  fpo.Mosaic_Status__c = 'Submit for Final Review';
                  fpoUpdateList.add(fpo);
              }
        }
        
        if(!fpoUpdateList.isEmpty()){
            update fpoUpdateList;
        }
        
        /*Code to Upload Documents to Mosaic
        Map<Id,Invoice_Documents__c> iDocsMap = new Map<Id,Invoice_Documents__c>([select Id,Documents_in_File__c,Status__c,Lease_Payment__r.Quote__r.QuoteType__c from Invoice_Documents__c where Id in :Trigger.new]);
        Map<String,Mosaic_Upload_Documents__c> mudMap = Mosaic_Upload_Documents__c.getAll();
        Set<Id> iDocsIdSetMosaicUpload = new Set<Id>();
        for(Invoice_Documents__c iDoc:Trigger.new){
            System.debug('----->'+iDocsMap.get(iDoc.Id).Lease_Payment__r.Quote__r.QuoteType__c);
            System.debug('----->'+mudMap.containsKey(iDocsMap.get(iDoc.Id).Documents_in_File__c));
            System.debug('----->'+iDocsMap.get(iDoc.Id).Status__c);
            System.debug('----->'+Trigger.oldMap.get(iDoc.Id).Status__c);
            if(iDocsMap.get(iDoc.Id).Lease_Payment__r.Quote__r.QuoteType__c=='Loan' && mudMap.containsKey(iDocsMap.get(iDoc.Id).Documents_in_File__c) && iDocsMap.get(iDoc.Id).Status__c=='Approved' && Trigger.oldMap.get(iDoc.Id).Status__c!='Approved'){
                iDocsIdSetMosaicUpload.add(iDoc.Id);
                System.debug('----->Inside Loop');
            }
        }
        
        if(!iDocsIdSetMosaicUpload.isEmpty() && MosaicIntegrationUtil.afterUpdateDocUpload==false){
            MosaicIntegrationUtil.afterUpdateDocUpload = true;
            MosaicIntegrationUtil.uploadToMosaic(iDocsIdSetMosaicUpload);
        }*///End of Code to Upload Documents to Mosaic
        
        List<Invoice_Documents__c> approvedInvoiceDocs = Select.Field.hasChanged(Invoice_Documents__c.Status__c).
        andx(Select.Field.isEqual(Invoice_Documents__c.Status__c, InvoiceDocumentServices.APPROVED)).
        andx(Select.Field.isEqual(Invoice_Documents__c.Not_Required_for_Approval__c, false)).filter(Trigger.new, Trigger.oldMap);
        if(!approvedInvoiceDocs.isEmpty())
        {
            InvoiceDocumentServices.setApprovedField(approvedInvoiceDocs);
        }

        List<Invoice_Documents__c> previouslyApprovedInvoiceDocs = Select.Field.isEqual(Invoice_Documents__c.Status__c, InvoiceDocumentServices.APPROVED).filter(Trigger.old);
        List<Id> previouslyApprovedDocIds = new List<Id>(Pluck.ids(previouslyApprovedInvoiceDocs));

        List<Invoice_Documents__c> unApprovedDocs = Select.Field.hasChanged(Invoice_Documents__c.Status__c).
        andx(Select.Field.notEqual(Invoice_Documents__c.Status__c, InvoiceDocumentServices.APPROVED)).
        andx(Select.Field.isEqual(Invoice_Documents__c.Not_Required_for_Approval__c, false)).
        andx(Select.Field.isIn(Invoice_Documents__c.Id, previouslyApprovedDocIds)).filter(Trigger.new, Trigger.oldMap);

        if(!unApprovedDocs.isEmpty())
        {
            InvoiceDocumentServices.removeApprovedField(unApprovedDocs);
        }
        
        //Make sure this part only execute once
        if(InvoiceDocumentServices.firstRunAfter){
            //Filter out the rejected invoice documents
            List<Invoice_Documents__c> rejectedInvoiceDocs = Select.Field.hasChanged(Invoice_Documents__c.Status__c).
            andx(Select.Field.isEqual(Invoice_Documents__c.Status__c, InvoiceDocumentServices.REJECTED)).filter(Trigger.new, Trigger.oldMap);
            
            //Execute the real function for creating the rejection reasons
            if(!rejectedInvoiceDocs.isEmpty())
            {
                InvoiceDocumentServices.createRejectionReasons(rejectedInvoiceDocs);
            }
            InvoiceDocumentServices.firstRunAfter = false;
        }
    }
}