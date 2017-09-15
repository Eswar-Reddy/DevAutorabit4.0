public with sharing class InvoiceDocumentServices {

    public static final String APPROVED = 'Approved';
    public static final String PENDING = 'Pending';
    public static final String REJECTED = 'Rejected';
    public static final String NOT_SUBMITTED = 'Not Submitted';
    public static final String LEGACY_REJECTED = 'Legacy Rejected';
    public static final String INSTALL_TYPE = 'Install';
    public static final String INTERCONNECT_TYPE = 'Interconnect';
    public static final String ORIGINATION_TYPE = 'Origination';
    //cdevarapalli TPS Phase 2
    public static final String PERMIT_RECEIVED_TYPE = 'Permit Received';
    //Added for New SREC document type case number :00455272
    public static final String SREC_TYPE='SREC';
    public static final String APPROVAL_TYPE = 'Approval';
    public static final String STATUS_FIELD = 'Status__c';
    public static final String NH_FinancingType = 'NH Lease';
    public static final String COUNTRY_STATE_KEY_DELIMITER = ',';
    //Constant for default notes to dealer
    public static final String DEFAULT_NOTES_TO_DEALER = null;
    //Constant using in trigger to make sure function only execute once
    public static Boolean firstRunBefore = true;
    public static Boolean firstRunAfter = true;
    public static Set<String> ACCEPTED_STATUS {
        get {
            if (ACCEPTED_STATUS == null) {
                ACCEPTED_STATUS = new Set<String>{APPROVED, PENDING};
            }
            return ACCEPTED_STATUS;
        }
        private set;

    }

    public static Map<String, String> typeToField {
        get
        {
            if(typeToField == null)
            {
                typeToField = new Map<String, String>();
                typeToField.put(INSTALL_TYPE, 'Install_Pymnt_Apprvd__c');
                typeToField.put(INTERCONNECT_TYPE, 'Intrcnct_Pymnt_Apprvd__c');
                typeToField.put(ORIGINATION_TYPE, 'Origination_Payment_Approved__c');
                
            }
            return typeToField;
        }
        private set;
    }

    public static final Map<String, Schema.SObjectField> TYPE_TO_FIELD =
        new Map<String, Schema.SObjectField>{ INSTALL_TYPE => LeasePayment__c.Install_Pymnt_Apprvd__c,
                                                INTERCONNECT_TYPE => LeasePayment__c.Intrcnct_Pymnt_Apprvd__c,
                                                ORIGINATION_TYPE => LeasePayment__c.Origination_Payment_Approved__c};


    public static String getCountryStateKey(String country, String state)
    {
        return String.join(new List<String>{ country, state}, InvoiceDocumentServices.COUNTRY_STATE_KEY_DELIMITER);
    }

    public static Map<Id, Set<String>> getParentIdToExistingDocTypes(List<SObject> records)
    {
        Map<Id, Set<String>> parentIdToExistingDocTypes = new Map<Id, Set<String>>();
        String sObjectType;
        String childRelationship;
        if(!records.isEmpty())
        {
            if(records[0] instanceof LeasePayment__c)
            {
                sObjectType = 'LeasePayment__c';
                childRelationship = 'Invoice_Documents__r';
            }
            else
            {
                sObjectType = 'Account';
                childRelationship = 'Origination_Documents__r';
            }

            String subQuery = String.format('(SELECT Id, Documents_in_File__c, Status__c, Invoice_Type__c FROM {0} WHERE Status__c != :LEGACY_REJECTED)', new List<String> { childRelationship });
            List<SObject> recordsWithInvoiceDocs = Database.query(String.format('SELECT Id, {0} FROM {1} WHERE Id IN :records', new List<String> { subQuery, sObjectType }));

            for(SObject record : recordsWithInvoiceDocs)
            {
                Set<String> existingDocTypes = new Set<String>();
                for(SObject existingDoc : record.getSObjects(childRelationship))
                {
                    existingDocTypes.add((String)existingDoc.get('Documents_in_File__c'));
                }

                parentIdToExistingDocTypes.put(record.Id, existingDocTypes);
            }
        }

        return parentIdToExistingDocTypes;
    }
    
    public static void safeInsert(List<SObject> recordsToInsert, Map<Id, SObject> newParentMap)
    {
        try
        {
            insert recordsToInsert;
        }
        catch(DMLException dmx)
        {
            String parentId = (recordsToInsert[0] instanceof Invoice_Documents__c) ? 'Lease_Payment__c' : 'Account__c';
            for(Integer i = 0;i<dmx.getNumDml();i++)
            {
                Integer failedIndex = dmx.getDmlIndex(i);
                SObject failedRecord = recordsToInsert[failedIndex];
                SObject parentToAddError = newParentMap.get((Id)failedRecord.get(parentId));
                parentToAddError.addError(dmx.getDmlMessage(i));
            }
        }
    }
    

    public static void setApprovedField(List<Invoice_Documents__c> approvedDocs) {
        Map<Id, List<Invoice_Documents__c>> leaseIdToInvoiceDocs = GroupBy.ids('Lease_Payment__c', approvedDocs);

        Set<Id> leaseIds = leaseIdToInvoiceDocs.keySet();
        String query = 'SELECT {0} , {1} FROM LeasePayment__c WHERE Id IN :leaseIds';

        String leaseFields = String.join(typeToField.values(), ', ');
        String subQuery = '(SELECT Invoice_Type__c, Status__c FROM Invoice_Documents__r WHERE Not_Required_for_Approval__c = false)';

        query = String.format(query, new List<String>{leaseFields, subQuery});
        List<LeasePayment__c> leasePayments = Database.query(query);
        Map<Id, LeasePayment__c> leasesToUpdate = new Map<Id, LeasePayment__c>();

        for( LeasePayment__c leasePayment : leasePayments )
        {
            Map<String, Boolean> typeToAllApproved = new Map<String, Boolean>();
            for( Invoice_Documents__c aDocument : leasePayment.Invoice_Documents__r )
            {
                Boolean previousApproved = (typeToAllApproved.containsKey(aDocument.Invoice_Type__c)) ? typeToAllApproved.get(aDocument.Invoice_Type__c) : true;
                System.debug('--------------previousApproved'+previousApproved);
                typeToAllApproved.put(aDocument.Invoice_Type__c, aDocument.Status__c == InvoiceDocumentServices.APPROVED && previousApproved);
            }
            
            System.debug('--------------typeToAllApproved='+typeToAllApproved);
            if(!leasesToUpdate.containsKey(leasePayment.Id)) {
                leasesToUpdate.put(leasePayment.Id, leasePayment);
            }
            leasePayment = leasesToUpdate.get(leasePayment.Id);
            System.debug('--------------leasePayment='+leasePayment);
            for( String invoiceType : typeToField.keySet() )
            {
                if( leasePayment.get(typeToField.get(invoiceType)) == null)
                {
                    if(typeToAllApproved.containsKey(invoiceType) && typeToAllApproved.get(invoiceType))
                    {
                        leasePayment.put( typeToField.get( invoiceType ), Date.today() );
                        //leasesToUpdate.put(leasePayment.Id, leasePayment);
                    }
                }
            }
        }        
        
        if(!leasesToUpdate.isEmpty())
        {
            List<LeasePayment__c> leasesToUpdateList = leasesToUpdate.values();
            System.debug('--------------leasesToUpdateList='+leasesToUpdateList);
            System.debug('--------------leaseIdToInvoiceDocs='+leaseIdToInvoiceDocs);
            SafeDml.SafeDML2.safeUpdate(leasesToUpdateList, createSafeDmlRelationship(leaseIdToInvoiceDocs, leasesToUpdateList));
            System.debug('-----objResult'+SafeDml.SafeDML2.safeUpdate(leasesToUpdateList, createSafeDmlRelationship(leaseIdToInvoiceDocs, leasesToUpdateList)));
            
        }
    }

    public static void removeApprovedField(List<Invoice_Documents__c> unApprovedDocs)
    {
        Map<Id, LeasePayment__c> leasePaymentsToUpdateMap = new Map<Id, LeasePayment__c>();
        for(Invoice_Documents__c unApprovedDoc : unApprovedDocs) {
            if(!leasePaymentsToUpdateMap.containsKey(unApprovedDoc.Lease_Payment__c)) {
                leasePaymentsToUpdateMap.put(unApprovedDoc.Lease_Payment__c, new LeasePayment__c(Id = unApprovedDoc.Lease_Payment__c));
            }
            LeasePayment__c leasePayment = leasePaymentsToUpdateMap.get(unApprovedDoc.Lease_Payment__c);
            if(typeToField.containsKey(unApprovedDoc.Invoice_Type__c))
            leasePayment.put(typeToField.get(unApprovedDoc.Invoice_Type__c), null);
        }
        Map<Id, List<Invoice_Documents__c>> leaseIdToInvoiceDocs = GroupBy.ids('Lease_Payment__c', unApprovedDocs);
        if(!leasePaymentsToUpdateMap.isEmpty())
        {
            List<LeasePayment__c> leasesToUpdateList = leasePaymentsToUpdateMap.values();
            SafeDml.SafeDML2.safeUpdate(leasesToUpdateList, createSafeDmlRelationship(leaseIdToInvoiceDocs, leasesToUpdateList));
        }
    }

    private static List<List<Invoice_Documents__c>> createSafeDmlRelationship (Map<Id, List<Invoice_Documents__c>> leaseIdToInvoiceDocs, List<LeasePayment__c> leasePayments)
    {
        List<List<Invoice_Documents__c>> invoiceDocumentsToAddError = new List<List<Invoice_Documents__c>>();
        for(LeasePayment__c leasePayment : leasePayments) {
            invoiceDocumentsToAddError.add(leaseIdToInvoiceDocs.get(leasePayment.Id));
        }
        return invoiceDocumentsToAddError;
    }
    
    //Function to create rejection reasons
    public static void createRejectionReasons(List<Invoice_Documents__c> rejectedInvoiceDocs){
        //Create a empty list for insert
        List<Invoice_Document_Changed__c> newRejectedReasons = new List<Invoice_Document_Changed__c>();
        //Set each field of rejectedReason
        for(Invoice_Documents__c rejectedInvoiceDoc : rejectedInvoiceDocs){
            Invoice_Document_Changed__c rejectedReason = new Invoice_Document_Changed__c();
            rejectedReason.Invoice_Documents__c = rejectedInvoiceDoc.Id;
            //This name field could be changed depending on the requirements
            rejectedReason.Name = (rejectedInvoiceDoc.Number_of_Times_Rejected__c + 1).format();
            rejectedReason.Document_Submitted__c = rejectedInvoiceDoc.Document_Submitted__c;
            rejectedReason.Notes_to_Dealer__c = rejectedInvoiceDoc.Notes_to_Dealer__c;
            rejectedReason.Response_Date__c = Date.today();
            
            newRejectedReasons.add(rejectedReason);
        }
        try{
            insert newRejectedReasons;
        }
        catch (DMLException e){
            //process DMLException;
        }
    }
    //Function to null out the notes to dealer
    public static void removeNotesToDealer(List<Invoice_Documents__c> pendingInvoiceDocs){
        //for each pending invoice documents. set notes to dealer field to default value (null)
        for(Invoice_Documents__c pendingInvoiceDoc: pendingInvoiceDocs){
            pendingInvoiceDoc.Notes_to_Dealer__c = DEFAULT_NOTES_TO_DEALER;
        }
    }
   
}