/* **************************************************************************************
* Class Name     : InvoiceDocumentSummary
* Version        : 1.0
* Created Date   : 21 Apr 2016
* Function       : Class to calculate the summary of invoice document.
* Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
* Ankit                       21 Apr 2016         Original Version
*************************************************************************************/

public Class InvoiceDocumentSummary {
    
    public static Map<String,Map<String,List<Integer>>> mRoleWithMilestoneSummary {get;set;}
    public static List<invoiceDocumentWrapper> lst_invoiceDocumentWrapper{get;set;}
    public LeasePayment__c oFP;
    public InvoiceDocumentSummary(){
        
    }
    public InvoiceDocumentSummary(apexpages.standardController stdController){
        this.oFP = (LeasePayment__c) stdController.getRecord();
        oFP = [select Id,Name,(SELECT Attachment_Link__c, CreatedById, CreatedDate, CurrencyIsoCode, Date_Delivered__c, IsDeleted, Document_Owner__c,
                                                  Document_Submitted__c, Location__c, Documents_in_File__c, Type__c, FinancingType__c, Re_submitted__c, Install_Payment_Approved__c,
                                                  Interconnect_Payment_Approved__c, Invoice_Admin__c, Invoice_Document_Email__c, Name, Invoice_Type__c, LastActivityDate, LastModifiedById,
                                                  LastModifiedDate, Lease__c, Lease_Payment__c, Lease_Payment_Status__c, Link_to_Attachment__c, Not_Required_for_Approval__c,
                                                  Notes_to_Approver__c, Notes_to_Dealer__c, Number_of_Times_Rejected__c, Oracle_Vendor_Email__c, Oracle_Vendor_Email_Formula__c,
                                                  Oracle_Vendor_Number__c, Partner__c, Partner_Comments__c, Partner_Type__c, Program__c, RSM__c, ConnectionReceivedId, Id, Response_Date__c,
                                                  Responsible_Partner__c, SMS_ID__c, ConnectionSentId, Shared_With__c, Sharing_Type__c, State__c, Status__c, SystemModstamp
                                                  FROM Invoice_Documents__r) from LeasePayment__c where Id = : oFP.Id];
        fQueryInvoiceDocument(oFP);
    }
    
    
    public static List<invoiceDocumentWrapper> fQueryInvoiceDocument(LeasePayment__c fpo){
        mRoleWithMilestoneSummary = new Map<String,Map<String,List<Integer>>> ();
        for (Invoice_Documents__c  oID : fpo.Invoice_Documents__r){
            
            if(!mRoleWithMilestoneSummary.containsKey(oID.Document_Owner__c))
                mRoleWithMilestoneSummary.put(oID.Document_Owner__c,new Map<string,List<Integer>>());
            if(!mRoleWithMilestoneSummary.get(oID.Document_Owner__c).containsKey(oID.Invoice_Type__c))
                mRoleWithMilestoneSummary.get(oID.Document_Owner__c).put(oID.Invoice_Type__c,new List<Integer>{0,0,0});
            mRoleWithMilestoneSummary.get(oID.Document_Owner__c).get(oID.Invoice_Type__c)[0] = mRoleWithMilestoneSummary.get(oID.Document_Owner__c).get(oID.Invoice_Type__c)[0] + 1;
            if(oID.Status__c != null && oID.Status__c != 'Not Submitted')
                mRoleWithMilestoneSummary.get(oID.Document_Owner__c).get(oID.Invoice_Type__c)[1] = mRoleWithMilestoneSummary.get(oID.Document_Owner__c).get(oID.Invoice_Type__c)[1] + 1;
            if(oID.Status__c == 'Approved')
                mRoleWithMilestoneSummary.get(oID.Document_Owner__c).get(oID.Invoice_Type__c)[2] = mRoleWithMilestoneSummary.get(oID.Document_Owner__c).get(oID.Invoice_Type__c)[2] + 1;
            
        }
        system.debug('----------------' + mRoleWithMilestoneSummary);
        fPopulateInvoiceDocumentWrapper();
        return lst_invoiceDocumentWrapper;
    }
    
    public static void fPopulateInvoiceDocumentWrapper(){
        lst_invoiceDocumentWrapper = new List<invoiceDocumentWrapper>();
        for(string sDocOwner : mRoleWithMilestoneSummary.keyset()){
            for(string sInvType : mRoleWithMilestoneSummary.get(sDocOwner).keyset()){
                invoiceDocumentWrapper temp = new invoiceDocumentWrapper(sDocOwner,sInvType);
                temp.iTotalDocsExpected = mRoleWithMilestoneSummary.get(sDocOwner).get(sInvType)[0];
                temp.iTotalDocsSubmitted = mRoleWithMilestoneSummary.get(sDocOwner).get(sInvType)[1];
                temp.iTotalDocsApproved = mRoleWithMilestoneSummary.get(sDocOwner).get(sInvType)[2];
                lst_invoiceDocumentWrapper.add(temp);
            }
        }
        system.debug('======List=========' + lst_invoiceDocumentWrapper);    
    }
    
    public class invoiceDocumentWrapper {
        
        public String  sReponsibleVendor {get;set;}
        public String  sMilestone {get;set;}
        public Integer iTotalDocsExpected {get;set;}
        public Integer iTotalDocsSubmitted {get;set;}
        public Integer iTotalDocsApproved {get;set;}
        
        public invoiceDocumentWrapper (string sReponsibleVendor, string sMilestone) {
            this.sReponsibleVendor = sReponsibleVendor;
            this.sMilestone = sMilestone;
            this.iTotalDocsExpected = 0;
            this.iTotalDocsSubmitted = 0;
            this.iTotalDocsApproved = 0;
            
        }
    }
    
    
}