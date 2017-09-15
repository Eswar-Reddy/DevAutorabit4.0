//Utily class to get access token for Mosaic API Calls
public class MosaicIntegrationUtil {

    public static boolean afterUpdateDocUpload = false;
    
    //Prepare Spectrum Debug Log from Mosiac request and response
    public static SpectrumDebugUtility.debugLog prepDebugLog(Id contactId,String serviceName,Httprequest request,Httpresponse response){
  
        //build log of ob msg and response
        SpectrumDebugUtility.debugLog spExLog = new SpectrumDebugUtility.debugLog();
        spExlog.ContactId = contactId;
        spExLog.Service = serviceName;
        spExLog.Response = response.getBody(); 
        spExLog.responseCode = response.getStatusCode();
        spExLog.JSONPayload = request.getBody();
        
        return spExLog;
    }
    
    //Future call to upload certain documents to Mosiac once they are approved in salesforce
    @future(callout=true)
    public static void uploadToMosaic(Set<Id> invDocsIdSet){
        Map<Id,Invoice_Documents__c> invDocsMap = new Map<Id,Invoice_Documents__c>([select Id,Documents_in_File__c,Status__c,Lease_Payment__c,Lease_Payment__r.Quote__c,Lease_Payment__r.Quote__r.Credit_Check_Application__r.Application_Id__c,(SELECT Id FROM Attachments ORDER BY CreatedDate DESC limit 1) from Invoice_Documents__c where Id in :invDocsIdSet]);
        Map<Id,Id> iDocIdAttIdMap = new Map<Id,Id>();
        Map<Id,Attachment> iDocIdAttMap = new Map<Id,Attachment>();
        List<Invoice_Documents__c> idocsToUpdateList = new List<Invoice_Documents__c>();
        List<SpectrumDebugUtility.debugLog> spExLogsList = new List<SpectrumDebugUtility.debugLog>();
        
        for(Id idocId:invDocsMap.keySet()){
            if(invDocsMap.get(idocId).Attachments!=null){
                iDocIdAttIdMap.put(idocId, invDocsMap.get(idocId).Attachments[0].Id);
            }
        }
        
        System.debug('iDocIdAttIdMap----->'+iDocIdAttIdMap.values());
        
        Map<Id,Attachment> attMap = new Map<Id,Attachment>([SELECT Id,Name,Body FROM Attachment where Id in :iDocIdAttIdMap.values() ORDER BY CreatedDate DESC]);
        System.debug('attMap----->'+attMap);
        for(Id iDocuId:iDocIdAttIdMap.keySet()){
            iDocIdAttMap.put(iDocuId, attMap.get(iDocIdAttIdMap.get(iDocuId)));
        }
        
        for(Id iDocsId:iDocIdAttMap.keySet()){
            String oppId = invDocsMap.get(iDocsId).Lease_Payment__r.Quote__r.Credit_Check_Application__r.Application_Id__c;
            String documentType = Mosaic_Upload_Documents__c.getInstance(invDocsMap.get(iDocsId).Documents_in_File__c).Document_Type__c;
            Attachment att = iDocIdAttMap.get(iDocsId);
            String qotId = invDocsMap.get(iDocsId).Lease_Payment__r.Quote__c;

            MosaicJSONUtil.MosaicResponse mosResp = new MosaicJSONUtil.MosaicResponse();
            try{
            	mosResp = Mosaic_API_CallHandler.mosaic_Upload_Document(oppId, documentType, att);
                SpectrumDebugUtility.debugLog spExLog = prepDebugLog(null,'Mosaic Updload Document', mosResp.request, mosResp.response);
                spExlog.quoteId = qotId;
                spExLogsList.add(spExlog);
         }catch(Exception e){
                ExLog.log(e);
            }

            if(mosResp.successful==false){
                idocsToUpdateList.add(new Invoice_Documents__c(Id=iDocsId,Mosaic_Status__c='Upload Failed'));
            }
            if(mosResp.successful==true){
                idocsToUpdateList.add(new Invoice_Documents__c(Id=iDocsId,Mosaic_Status__c='Upload Success'));

                if(invDocsMap.get(iDocsId).Documents_in_File__c == 'Photos'){
                    try{
                        MosaicJSONUtil.MosaicResponse photosMosResp = Mosaic_API_CallHandler.mosaic_Submit_Photo_Proof_Installation(oppId);
                        SpectrumDebugUtility.debugLog spExLog = prepDebugLog(null,'Mosaic Submit Photo Proof of Installation', photosMosResp.request, photosMosResp.response);
                        spExlog.quoteId = qotId;
                        spExLogsList.add(spExlog);
                    }catch(Exception e){
                        ExLog.log(e);
                    }
                }

                List<Invoice_Documents__c> successInvDocList = new List<Invoice_Documents__c>();
                String invDocName;
                boolean isPTOLetter = false;
                boolean isFinaPermit = false;
                if(invDocsMap.get(iDocsId).Documents_in_File__c == 'PTO Letter'){
                    isPTOLetter = true;
                    invDocName = 'Final Permit';
                }
                else if(invDocsMap.get(iDocsId).Documents_in_File__c == 'Final Permit'){
                    isFinaPermit = false;
                    invDocName = 'PTO Letter';
                }

                if(isPTOLetter || isFinaPermit){

                    successInvDocList = [Select Mosaic_Status__c from Invoice_Documents__c where Lease_Payment__c = :invDocsMap.get(iDocsId).Lease_Payment__c and Documents_in_File__c=:invDocName and Mosaic_Status__c='Upload Success'];

                    if(!successInvDocList.isEmpty() && successInvDocList.size()>1){
                        try{
                            MosaicJSONUtil.MosaicResponse finalReviewMosResp = Mosaic_API_CallHandler.mosaic_Submit_Final_Review(oppId);
                            SpectrumDebugUtility.debugLog spExLog = prepDebugLog(null,'Mosaic Submit for Final Review', finalReviewMosResp.request, finalReviewMosResp.response);
                            spExlog.quoteId = qotId;
                            spExLogsList.add(spExlog);
                        }catch(Exception e){
                            ExLog.log(e);
                        }
                        
                    }
                }
            }
        }
        
        try{
            if(idocsToUpdateList != null && !idocsToUpdateList.isEmpty()){
                update idocsToUpdateList;
            }
        }catch(Exception e){ExLog.log(e);}

        try {
            if(spExLogsList != null && !spExLogsList.isEmpty()) {
                SpectrumDebugUtility.generateDebugLog(spExlogsList);
            } 
        } catch(Exception e){ExLog.log(e);}
    }

    //Future call to upload certain documents to Mosiac once they are approved in salesforce
    @future(callout=true)
    public static void uploadICDToMosaic(Set<Id> invDocsIdSet) {
        List<Invoice_Compliance_Document__c> idocsToUpdateList = new List<Invoice_Compliance_Document__c>();
        List<SpectrumDebugUtility.debugLog> spExLogsList = new List<SpectrumDebugUtility.debugLog>();

        if(!invDocsIdSet.isEmpty()) {
            Map<Id, Invoice_Compliance_Document__c> invDocsMap = new Map<Id, Invoice_Compliance_Document__c>();
            Map<Id, Attachment> iDocIdAttMap = new Map<Id, Attachment>();
            Set<Id> attachmentIds = new Set<Id>();

            // get the docs and their attachment id cuz can't get the whole thing in this one for loop due to the body being binary in the sub select
            for(Invoice_Compliance_Document__c icd : [SELECT Id, Documents_in_File__c, Status__c, Financial_Payment__c, Financial_Payment__r.Quote__c, Financial_Payment__r.Quote__r.Credit_Check_Application__r.Application_Id__c, (SELECT Id FROM Attachments ORDER BY CreatedDate DESC LIMIT 1) FROM Invoice_Compliance_Document__c WHERE Id IN : invDocsIdSet]) {
                invDocsMap.put(icd.Id, icd);
                if(icd.Attachments != null) attachmentIds.add(icd.Attachments[0].Id);
            }
            // get the attachments
            if(!attachmentIds.isEmpty()) {
                for(Attachment a : [SELECT ParentId, Name, Body FROM Attachment WHERE Id IN : attachmentIds ORDER BY CreatedDate DESC]) {
                    iDocIdAttMap.put(a.ParentId, a);
                }
            }
            // send data to Mosaic
            for(Id iDocsId : iDocIdAttMap.keySet()) {
                Invoice_Compliance_Document__c icd = invDocsMap.get(iDocsId);

                String oppId = icd.Financial_Payment__r.Quote__r.Credit_Check_Application__r.Application_Id__c;
                String documentType = Mosaic_Upload_Documents__c.getInstance(icd.Documents_in_File__c).Document_Type__c;
                Attachment att = iDocIdAttMap.get(iDocsId);
                String qotId = icd.Financial_Payment__r.Quote__c;

                MosaicJSONUtil.MosaicResponse mosResp;
                try {
                    mosResp = Mosaic_API_CallHandler.mosaic_Upload_Document(oppId, documentType, att);
                    SpectrumDebugUtility.debugLog spExLog = prepDebugLog(null, 'Mosaic Updload Document', mosResp.request, mosResp.response);
                    spExlog.quoteId = qotId;
                    spExLogsList.add(spExlog);
                }
                catch(Exception e){
                    ExLog.log(e);
                }

                if(mosResp != null) {
                    if(!mosResp.successful) {
                        idocsToUpdateList.add(new Invoice_Compliance_Document__c(Id = iDocsId, Mosaic_Status__c = 'Upload Failed'));
                    }
                    if(mosResp.successful) {
                        idocsToUpdateList.add(new Invoice_Compliance_Document__c(Id = iDocsId, Mosaic_Status__c = 'Upload Success'));
                        String docName = icd.Documents_in_File__c;

                        if(docName == 'Photos') {
                            try {
                                MosaicJSONUtil.MosaicResponse photosMosResp = Mosaic_API_CallHandler.mosaic_Submit_Photo_Proof_Installation(oppId);
                                SpectrumDebugUtility.debugLog spExLog = prepDebugLog(null, 'Mosaic Submit Photo Proof of Installation', photosMosResp.request, photosMosResp.response);
                                spExlog.quoteId = qotId;
                                spExLogsList.add(spExlog);
                            }
                            catch(Exception e){
                                ExLog.log(e);
                            }
                        }
                        if(docName == 'PTO Letter' || docName == 'Final Permit') {
                            try {
                                MosaicJSONUtil.MosaicResponse finalReviewMosResp = Mosaic_API_CallHandler.mosaic_Submit_Final_Review(oppId);
                                SpectrumDebugUtility.debugLog spExLog = prepDebugLog(null, 'Mosaic Submit for Final Review', finalReviewMosResp.request, finalReviewMosResp.response);
                                spExlog.quoteId = qotId;
                                spExLogsList.add(spExlog);
                            }
                            catch(Exception e){
                                ExLog.log(e);
                            }
                        }
                    }
                }
            }
            try {
                if(!idocsToUpdateList.isEmpty()){
                    update idocsToUpdateList;
                }
            }
            catch(Exception e) {
                ExLog.log(e);
            }
            try {
                if(!spExLogsList.isEmpty()) {
                    SpectrumDebugUtility.generateDebugLog(spExlogsList);
                }
            }
            catch(Exception e) {
                ExLog.log(e);
            }
        }
    }
}