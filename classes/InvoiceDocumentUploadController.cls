public class InvoiceDocumentUploadController {
    private static final Integer MAX_FILE_SIZE = 10485760;
    public static final String SETTINGS_DELIMITER = '; ';
    public static final String SETTINGS_NAME_DELIMITER = '|';
    public static final String PENDING_STATUS = 'Pending';
    public static final String ID_URL_PARAM = 'id';
    public static final String TYPE_URL_PARAM = 'type';
    public static final String LEASE_PAYMENT_PREFIX = LeasePayment__c.sObjectType.getDescribe().getKeyPrefix();
    public List<InvoiceDocumentRow> invoiceDocumentRows {get; set;}
    public String parentId {get; set;}
    public String invoiceType {get; private set;}
    public static final String baseURL = 'https://' + URL.getSalesforceBaseUrl().getHost() + '/servlet/servlet.FileDownload?file=';
    public static Set<String> ACCEPTED_STATUSES = new Set<String>{'Approved', PENDING_STATUS};

    public String googleAnalyticsProfileId
    {
        get
        {
            Google_Analytics__c analytics = Google_Analytics__c.getInstance('analytics id');
            if(analytics != null)
            {
                return analytics.Profile_Id__c;
            }
            else
            {
                return null;
            }

        }
     }

    public InvoiceDocumentUploadController()
    {
        parentId = ApexPages.currentPage().getParameters().get(ID_URL_PARAM);
        this.invoiceType = ApexPages.currentPage().getParameters().get(TYPE_URL_PARAM);

        invoiceDocumentRows = queryDocuments();
    }

    public List<InvoiceDocumentRow> queryDocuments()
    {
        String sObjectType;
        String parentIdField;
        String orderByClause;
        Set<String> documentFields = new Set<String>
        {
            //MAM 07/18/2014 added new field Partner_Comments__c start case 00361572
            'Name', 'Id', 'Notes_to_approver__c', 'Notes_To_Dealer__c', 'Status__c', 'Documents_in_File__c', 'Response_Date__c', 'Invoice_Type__c', 'Document_Submitted__c',
            'Partner_Comments__c' 
            //MAM 07/18/2014 end 
        };

        if(parentId.startsWith(LEASE_PAYMENT_PREFIX))
        {
            documentFields.add('Lease_Payment__c');
            parentIdField = 'Lease_Payment__c';
            sObjectType = 'Invoice_Documents__c';
            orderByClause = 'CreatedDate DESC';
        }
        else
        {
            documentFields.add('Account__c');
            parentIdField = 'Account__c';
            sObjectType = 'Origination_Document__c';
            orderByClause = 'Order__c ASC NULLS LAST';
        }
        String legacyRejected = InvoiceDocumentServices.LEGACY_REJECTED;
        String subQuery = ', (SELECT Id, Name, CreatedDate FROM Attachments ORDER BY CreatedDate DESC)';
        String fromWhere = String.format(' FROM {0} WHERE {1} = :parentId AND Invoice_Type__c = :invoiceType AND Status__c != :legacyRejected ORDER BY {2}',
                             new List<String>{sObjectType, parentIdField, orderByClause});
        String query = 'SELECT ' + String.join(new List<String>(documentFields), ', ') + subQuery + fromWhere;

        System.debug('query:'+ query);
        
        List<Sobject> docs = Database.query(query);
        List<InvoiceDocumentRow> rowsToReturn = new List<InvoiceDocumentRow>();

        for(Sobject doc : docs)
        {
            rowsToReturn.add(new InvoiceDocumentRow( doc ));
        }

        return rowsToReturn;
    }

    public void submit()
    {
        List<Attachment> attsToUpload = new List<Attachment>();
        //To keep track of which invoice document needs to be updated with attachment Id
        List<InvoiceDocumentRow> rowsToUpdate = new List<InvoiceDocumentRow>();

        for(InvoiceDocumentRow invoiceDocumentRow : invoiceDocumentRows)
        {
            if( invoiceDocumentRow.isNew && invoiceDocumentRow.validUpload())
            {
                attsToUpload.add( invoiceDocumentRow.getNewAttachment() );
                rowsToUpdate.add(invoiceDocumentRow);
            }
        }

        if(attsToUpload.isEmpty())
        {
            ApexPages.Message pMessage = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Submit_without_attachments);
            ApexPages.addMessage(pMessage);
            return;
        }

        Savepoint sp = Database.setSavepoint();
        try
        {
            insert attsToUpload;
        }
        catch( System.DmlException ex )
        {
            ApexPages.addMessages(ex);
            return;
        }


        Map<Id, Attachment> attMap = new Map<Id,Attachment>();
        List<Attachment> atts = [SELECT Id, CreatedDate, ParentId FROM Attachment WHERE Id IN :attsToUpload];
        for(Attachment att : atts)
        {
            attMap.put(att.ParentId, att);
        }

        List<Sobject> docsToUpdate = updateDocuments(rowsToUpdate, attMap);
        try
        {
            update docsToUpdate;
        }
        catch( System.DmlException ex )
        {
            Database.rollback(sp);
            ApexPages.addMessages(ex);
            return;
        }


        this.invoiceDocumentRows = queryDocuments();
    }

    public List<Sobject> updateDocuments(List<InvoiceDocumentRow> rowsToUpdate, Map<Id, Attachment> attMap)
    {
        List<Sobject> documentsToUpdate = new List<Sobject>();
        for(InvoiceDocumentRow invoiceDocumentRow : rowsToUpdate)
        {
            Sobject invoiceDocToUpdate = invoiceDocumentRow.getAttachmentData();
            invoiceDocToUpdate.put('Document_Submitted__c', attMap.get(invoiceDocToUpdate.Id).CreatedDate.date());
            invoiceDocToUpdate.put('Status__c', InvoiceDocumentServices.PENDING);
            documentsToUpdate.add( invoiceDocToUpdate );
        }
        return documentsToUpdate;
    }

    public class InvoiceDocumentRow
    {
        public Attachment att {get; set;}
        public Sobject invoiceDocument {get; set;}
        public String attName {get; set;}
        public Id attId {get; set;}

        public InvoiceDocumentRow( Sobject theDoc )
        {
            invoiceDocument = theDoc;
            // pull document if existing
            if ( theDoc.getSObjects('Attachments') != null && !theDoc.getSObjects('Attachments').isEmpty() )
            {
                att = (Attachment)theDoc.getSObjects('Attachments')[0];
                attName = att.Name;
                attId = att.Id;
                if(theDoc.get('Status__c') == InvoiceDocumentServices.REJECTED) {
                    att = new Attachment();
                }
            }
            // otherwise default to new
            else
            {
                att = new Attachment();
            }
        }

        public Boolean isPending
        {
            get
            {
                return invoiceDocument.get('Status__c') == PENDING_STATUS;
            }
        }

        public void deleteDocument()
        {
            Savepoint sp = Database.setSavepoint();
            try
            {
                delete att;
            }
            catch(DMLException dmx)
            {
                ApexPages.addMessages(dmx);
                return;
            }

            String status;
            String linkToAttachment;

            if(invoiceDocument.get('Response_Date__c') == null) {
                status = InvoiceDocumentServices.NOT_SUBMITTED;
                attName = null;
                attId = null;
            } else {
                status = InvoiceDocumentServices.REJECTED;
                Attachment previousAtt = [SELECT Id, Name FROM Attachment WHERE ParentId = :invoiceDocument.Id ORDER BY CreatedDate DESC LIMIT 1];
                linkToAttachment = baseURL + previousAtt.Id;
                attName = previousAtt.Name;
                attId = previousAtt.Id;
            }
            try
            {
                invoiceDocument.put('Document_Submitted__c', null);
                invoiceDocument.put('Link_to_Attachment__c', linkToAttachment);
                invoiceDocument.put('Status__c', status);
                invoiceDocument.put('Partner_Comments__c', null); //MAM 07/18/2014 added new field Partner_Comments__c start case 00361572
                update invoiceDocument;
                att = new Attachment();
            }
            catch(DMLException dmx)
            {
                Database.rollback(sp);
                ApexPages.addMessages(dmx);
                return;
            }
        }

        public Boolean validUpload()
        {
            //TODO: optimize this to be more clear and also enable use in triggers
            if(invoiceDocument != null && att.Body != null)
            {
                if(att.BodyLength > MAX_FILE_SIZE)
                {
                    ApexPages.Message pMessage = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Submit_size_too_large);
                    ApexPages.addMessage(pMessage);
                    return false;
                }
                return true;
            }

            return false;
        }

        public Boolean isArchived
        {
            get
            {
                return invoiceDocument.get('Status__c') == InvoiceDocumentServices.APPROVED && att.Id == null;
            }
        }

        public Boolean isNew
        {
            get{
                //need to check date too for dataloads
                return ( att.Id == null && (invoiceDocument.get('Document_Submitted__c') == null || invoiceDocument.get('Status__c') == InvoiceDocumentServices.REJECTED));
            }
        }

        public Attachment getNewAttachment()
        {
            att.ParentId = invoiceDocument.Id;
            return att;
        }

        public Sobject getAttachmentData()
        {
            invoiceDocument.put('Link_to_Attachment__c', baseURL + att.Id);
            return invoiceDocument;
        }
    }
}