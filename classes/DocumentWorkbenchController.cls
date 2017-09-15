/* **************************************************************************************
* Class Name     : DocumentWorkbenchController
* Version        : 1.0
* Created Date   : 13 Aug 2015
* Function       : Controller class for Documentworkbench for Program TPS

* Modification Log    :
* Developer                   Date                   Description
* ----------------------------------------------------------------------------
* Chaitanya Devarapalli       13 Aug 2015          Original Version
*************************************************************************************/
public class DocumentWorkbenchController{

    private static final Integer MAX_FILE_SIZE = 10485760;
    public static final String PENDING_STATUS = 'Pending';
    public static final String ID_URL_PARAM = 'Id';
    public static final String TYPE_URL_PARAM = 'invoiceType';

    public List<InvoiceDocumentRow> invoiceDocumentRows {get; set;}
    public String parentId {get; set;}
    public String invoiceType {get; set;}
    public static final String baseURL = URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.FileDownload?file=';
    public static Set<String> ACCEPTED_STATUSES = new Set<String>{'Approved', PENDING_STATUS};
        transient public static Map<Id,Map<String,Id>> lpDocLocTypeComboSetMap = new Map<Id,Map<String,Id>>();
    transient public static Map<Id,LeasePayment__c> lpMap = new Map<Id,LeasePayment__c>();
    public String partnerRole{get; set;}
    transient static Map<Id,List<Attachment>> docIdAttchmtListMap = new Map<Id,List<Attachment>>();
    public static Set<String> invoiceTypeSet = new set<String>();//cdevarapalli Loan Backend

    public DocumentWorkbenchController(ApexPages.StandardController controller) {
        parentId = ApexPages.currentPage().getParameters().get(ID_URL_PARAM);
        this.invoiceType = ApexPages.currentPage().getParameters().get(TYPE_URL_PARAM);
        invoiceDocumentRows = queryDocuments();
    }

    public List<InvoiceDocumentRow> queryDocuments(){

        if(parentId!=null){
            lpMap=new Map<Id,LeasePayment__c>([select Id,Quote__r.Quote_Type__c,Quote__c,Quote__r.OpportunityId,Quote__r.Opportunity.AccountId, Residential_Project__c from LeasePayment__c where Id =:parentId and Quote__c!=null]);
        }

        if(!lpMap.isEmpty()){
            lpDocLocTypeComboSetMap=LeasePaymentService.getexistingDocuments(new List<LeasePayment__c>{lpMap.get(parentId)},lpMap);
        }

        docIdAttchmtListMap=LeasePaymentService.docIdAttListMap;

        System.debug('docIdAttchmtListMap----->'+docIdAttchmtListMap);

        Set<String> documentFields = new Set<String>{
            'Id', 'Notes_to_approver__c', 'Notes_To_Dealer__c', 'Status__c', 'Documents_in_File__c', 'Response_Date__c', 'Invoice_Type__c', 'Document_Submitted__c',
                'Partner_Comments__c', 'Type__c', 'Document_Owner__c', 'Responsible_Partner__c', 'Sharing_Type__c', 'Shared_With__c', 'Lease_Payment__c', 'Location__c'
                };

                    String legacyRejected = InvoiceDocumentServices.LEGACY_REJECTED;
        String subQuery = ', (SELECT Id, Name, CreatedDate FROM Attachments ORDER BY CreatedDate DESC)';
        String fromWhere = '';
        String orderByClause = ' ORDER BY Type__c,Documents_in_File__c DESC';
        String invoiceTypeClause = '';
        String sharingClause='';


        If(Userinfo.getUserType()=='PowerPartner'){
            partnerRole=FPOOrderLinesExt.fIdentifyCurrentUserRole();
            sharingClause = ' AND (((Sharing_Type__c = \'Secure\' OR (Type__c=\'Task\')) AND Document_Owner__c = :partnerRole) OR (Sharing_Type__c = \'Shared\' AND (Document_Owner__c = :partnerRole OR Shared_With__c  includes (:partnerRole))))';
        }

        fromWhere = ' FROM Invoice_Documents__c WHERE Lease_Payment__c = :parentId AND Status__c != :legacyRejected';

        if(invoiceType!=null && invoiceType!='' && invoiceType!='All'){
            invoiceTypeClause=' AND Invoice_Type__c = :invoiceType';
        }

        String query = 'SELECT ' + String.join(new List<String>(documentFields), ', ') + subQuery + fromWhere+invoiceTypeClause+sharingClause+orderByClause;

        //cdevarapalli Loan Backend
        String allquery = 'SELECT ' + String.join(new List<String>(documentFields), ', ') + subQuery + fromWhere+sharingClause+orderByClause;
        System.debug('query:'+ query);

        List<Sobject> docs = Database.query(query);

        //cdevarapalli Loan Backend
         system.debug('-----ParentId---------' + ParentId + '-----allquery---------' + allquery + '----partnerRole----' + partnerRole);
        List<SObject> alldocs = Database.query(allquery);
         system.debug('-----alldocs------' + alldocs);

        List<InvoiceDocumentRow> rowsToReturn = new List<InvoiceDocumentRow>();

        for(Sobject doc : docs){
            rowsToReturn.add(new InvoiceDocumentRow( doc ));
        }
        //cdevarapalli Loan Backend
        for(Sobject alldoc : alldocs){
            invoiceTypeSet.add(((Invoice_Documents__c)alldoc).Invoice_Type__c);
        }
        return rowsToReturn;
    }



    public class InvoiceDocumentRow
    {
        public Attachment att {get; set;}
        public Sobject invoiceDocument {get; set;}
        transient public String attName {get; set;}
        public Id attId {get; set;}

        public InvoiceDocumentRow( Sobject theDoc )
        {
            invoiceDocument = theDoc;
            // pull document if existing
            if(theDoc.getSObjects('Attachments') != null && !theDoc.getSObjects('Attachments').isEmpty()){
                att = (Attachment)theDoc.getSObjects('Attachments')[0];
                attName = att.Name;
                attId = att.Id;
                System.debug('AttId ----->'+att.Id);
                if(theDoc.get('Status__c') == InvoiceDocumentServices.REJECTED) {
                    att = new Attachment();
                }

            }

            // otherwise default to new
            else{
                att = new Attachment();
            }

            if(theDoc.get('Sharing_Type__c')=='Shared'){

                String lpmntId = String.valueof(theDoc.get('Lease_Payment__c'));
                System.debug('Lease_Payment__c----->'+lpmntId);
                String parentIdDocNameCombo = '';

                if(lpMap.containsKey(lpmntId) && String.valueof(theDoc.get('Location__c'))=='Opportunity')
                    parentIdDocNameCombo = String.valueOf(lpMap.get(lpmntId).Quote__r.OpportunityId) + String.valueOf(lpMap.get(lpmntId).Quote__c) + String.valueof(theDoc.get('Documents_in_File__c'));

                if(lpMap.containsKey(lpmntId) && String.valueof(theDoc.get('Location__c'))=='Account')
                    parentIdDocNameCombo = lpMap.get(lpmntId).Quote__r.Opportunity.AccountId+String.valueof(theDoc.get('Documents_in_File__c'));

                if(lpMap.containsKey(lpmntId) && String.valueof(theDoc.get('Location__c'))=='Residential Project')
                    parentIdDocNameCombo = lpMap.get(lpmntId).Residential_Project__c+String.valueof(theDoc.get('Documents_in_File__c'));

                if(lpDocLocTypeComboSetMap.containsKey(lpmntId) && lpDocLocTypeComboSetMap.get(lpmntId).containsKey(parentIdDocNameCombo)){
                    Id docId = lpDocLocTypeComboSetMap.get(lpmntId).get(parentIdDocNameCombo);
                    if(docIdAttchmtListMap.containsKey(docId)){
                        List<Attachment> attchmntList = new List<Attachment>();
                        attchmntList=docIdAttchmtListMap.get(docId);
                        if(!attchmntList.isEmpty()){
                            att=attchmntList[0];
                            attName=attchmntList[0].Name;
                            attId=attchmntList[0].Id;
                        }
                    }
                }

                if(theDoc.get('Status__c') == InvoiceDocumentServices.REJECTED) {
                    att = new Attachment();
                }
            }

        }

        public Boolean isPending{
            get{
                return invoiceDocument.get('Status__c') == PENDING_STATUS;
            }
        }

        public PageReference deleteDocument(){
            Savepoint sp = Database.setSavepoint();
            try{
                delete att;
            }
            catch(DMLException dmx){
                ApexPages.addMessages(dmx);
                return null;
            }

            String status=null;
            String linkToAttachment=null;

            String lpId = ApexPages.currentPage().getParameters().get(ID_URL_PARAM);
            String invoiceType = ApexPages.currentPage().getParameters().get(TYPE_URL_PARAM);
            lpMap=new Map<Id,LeasePayment__c>([select Id,Quote__r.Quote_Type__c,Quote__c,Quote__r.OpportunityId,Quote__r.Opportunity.AccountId, Residential_Project__c from LeasePayment__c where Id =:lpId and Quote__c!=null]);
            System.debug('lpId ----->'+lpId);
            if(!lpMap.isEmpty()){
                lpDocLocTypeComboSetMap=LeasePaymentService.getexistingDocuments(new List<LeasePayment__c>{lpMap.get(lpId)},lpMap);
            }
            System.debug('lpDocLocTypeComboSetMap----->'+lpDocLocTypeComboSetMap);
            docIdAttchmtListMap=LeasePaymentService.docIdAttListMap;
            System.debug('docIdAttchmtListMap----->'+docIdAttchmtListMap);
            if(invoiceDocument.get('Response_Date__c') == null) {
                status = InvoiceDocumentServices.NOT_SUBMITTED;
                attName = null;
                attId = null;
            } else{
                InvoiceDocumentServices.firstRunAfter=false;
                status = InvoiceDocumentServices.REJECTED;
                List<Attachment> previousAttList = new List<Attachment>();

                if(invoiceDocument.get('Sharing_Type__c')=='Secure'){
                    previousAttList = [SELECT Id, Name FROM Attachment WHERE ParentId = :invoiceDocument.Id ORDER BY CreatedDate DESC LIMIT 1];
                }

                if(invoiceDocument.get('Sharing_Type__c')=='Shared'){

                    String parentIdDocNameCombo = '';

                    if(invoiceDocument.get('Location__c')=='Opportunity')
                        parentIdDocNameCombo = String.valueOf(lpMap.get(lpId).Quote__r.OpportunityId) + String.valueOf(lpMap.get(lpId).Quote__c) +String.valueOf(invoiceDocument.get('Documents_in_File__c'));

                    if(invoiceDocument.get('Location__c')=='Account')
                        parentIdDocNameCombo = lpMap.get(lpId).Quote__r.Opportunity.AccountId+String.valueOf(invoiceDocument.get('Documents_in_File__c'));

                    if(invoiceDocument.get('Location__c')=='Residential_Project__c')
                        parentIdDocNameCombo = lpMap.get(lpId).Residential_Project__c+String.valueOf(invoiceDocument.get('Documents_in_File__c'));


                    if(lpDocLocTypeComboSetMap.containsKey(lpId) && lpDocLocTypeComboSetMap.get(lpId).containsKey(parentIdDocNameCombo) ){
                        Id docId = lpDocLocTypeComboSetMap.get(lpId).get(parentIdDocNameCombo);
                        if(docIdAttchmtListMap.containsKey(docId)){
                            previousAttList=docIdAttchmtListMap.get(docId);
                        }
                    }
                }

                if(!previousAttList.isEmpty()){
                    linkToAttachment = baseURL + previousAttList[0].Id;
                    attName = previousAttList[0].Name;
                    attId = previousAttList[0].Id;
                }
            }
            try{

                transient List<Invoice_Document_Changed__c> idcList = [select Notes_to_Dealer__c,Document_Submitted__c ,Response_Date__c from Invoice_Document_Changed__c where Invoice_Documents__c = :invoiceDocument.Id order by createddate desc];
                if(!idcList.isEmpty()){
                    invoiceDocument.put('Notes_To_Dealer__c',idcList[0].Notes_to_Dealer__c);
                    invoiceDocument.put('Document_Submitted__c',idcList[0].Document_Submitted__c);
                }
                else
                    invoiceDocument.put('Document_Submitted__c', null);
                invoiceDocument.put('Link_to_Attachment__c', linkToAttachment);
                invoiceDocument.put('Status__c', status);
                invoiceDocument.put('Partner_Comments__c', null); //MAM 07/18/2014 added new field Partner_Comments__c start case 00361572
                update invoiceDocument;
                att = new Attachment();
            }
            catch(DMLException dmx){
                Database.rollback(sp);
                ApexPages.addMessages(dmx);
                return null;
            }

            pageReference pageRef = ApexPages.currentPage();
            pageRef.getParameters().clear();
            pageRef.getParameters().put('Id', lpid);
            pageRef.getParameters().put('invoiceType', invoiceType);
            pageRef.setRedirect(true);
            return pageRef;
        }

        public Boolean validUpload(){
            //TODO: optimize this to be more clear and also enable use in triggers
            if(invoiceDocument != null && att.Body != null){
                if(att.BodyLength > MAX_FILE_SIZE){
                    ApexPages.Message pMessage = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Submit_size_too_large);
                    ApexPages.addMessage(pMessage);
                    return false;
                }
                return true;
            }

            return false;
        }

        public Boolean isArchived{
            get{
                return invoiceDocument.get('Status__c') == InvoiceDocumentServices.APPROVED && att.Id == null;
            }
        }

        public Boolean isNew{
            get{
                //need to check date too for dataloads
                return ( (invoiceDocument.get('Sharing_Type__c') == 'Secure' && att.Id == null && (invoiceDocument.get('Document_Submitted__c') == null || invoiceDocument.get('Status__c') == InvoiceDocumentServices.REJECTED)) || (invoiceDocument.get('Sharing_Type__c') == 'Shared' && (invoiceDocument.get('Document_Submitted__c') == null || invoiceDocument.get('Status__c') == InvoiceDocumentServices.REJECTED)));
            }
        }

        public Attachment getNewAttachment(){
            Id lpId = String.valueOf(invoiceDocument.get('Lease_Payment__c'));

            if(invoiceDocument.get('Sharing_Type__c')=='Shared' && invoiceDocument.get('Location__c')=='Account'){
                att.ParentId = lpDocLocTypeComboSetMap.get(lpId).get(lpMap.get(lpId).Quote__r.Opportunity.AccountId+String.valueOf(invoiceDocument.get('Documents_in_File__c')));
            }
            else if(invoiceDocument.get('Sharing_Type__c')=='Shared' && invoiceDocument.get('Location__c')=='Opportunity'){
                att.ParentId = lpDocLocTypeComboSetMap.get(lpId).get(String.valueOf(lpMap.get(lpId).Quote__r.OpportunityId) + String.valueOf(lpMap.get(lpId).Quote__c) + String.valueOf(invoiceDocument.get('Documents_in_File__c')));
            }
            else if(invoiceDocument.get('Sharing_Type__c')=='Shared' && invoiceDocument.get('Location__c')=='Residential Project'){
                att.ParentId = lpDocLocTypeComboSetMap.get(lpId).get(String.valueOf(lpMap.get(lpId).Residential_Project__c) + String.valueOf(invoiceDocument.get('Documents_in_File__c')));
            }
            else
                att.ParentId = invoiceDocument.Id;

            return att;
        }

        public Attachment clearAttachmentBody(){
            att.body=null;
            return att;
        }

        public Sobject getAttachmentData(){
            //R.Alega - Provided a condition that will provide attachment IDs for both "Shared" and "Secure" Sharing Type of Invoice Documents
            //Fix for Case
            if(invoiceDocument.get('Sharing_Type__c')=='Shared'){
                invoiceDocument.put('Link_to_Attachment__c', baseURL + att.Id);
            }else{
                List<Attachment> attachmentSecureList = [SELECT Id FROM Attachment WHERE ParentId = :invoiceDocument.Id ORDER BY CreatedDate DESC LIMIT 1];
                invoiceDocument.put('Link_to_Attachment__c', baseURL + attachmentSecureList[0].Id);
            }


            return invoiceDocument;
        }

    }


    public String googleAnalyticsProfileId{
        get{
            Google_Analytics__c analytics = Google_Analytics__c.getInstance('analytics id');
            if(analytics != null){
                return analytics.Profile_Id__c;
            }
            else{
                return null;
            }

        }
    }


    public void submit(){

        transient List<Attachment> attsToUpload = new List<Attachment>();
        //To keep track of which invoice document needs to be updated with attachment Id
        transient List<InvoiceDocumentRow> rowsToUpdate = new List<InvoiceDocumentRow>();
        transient List<Invoice_Documents__c> tocheckandCreateIDList = new List<Invoice_Documents__c>();

        for(InvoiceDocumentRow invoiceDocumentRow : invoiceDocumentRows){
            System.debug('invoiceDocumentRow Name ----->'+invoiceDocumentRow.invoiceDocument.get('Documents_in_File__c'));
            System.debug('isNew ----->'+invoiceDocumentRow.isNew);
            if( invoiceDocumentRow.isNew && invoiceDocumentRow.validUpload() && invoiceDocumentRow.invoiceDocument.get('Sharing_Type__c')=='Shared'){
                if((Invoice_Documents__c)invoiceDocumentRow.invoicedocument!=null)
                    tocheckandCreateIDList.add((Invoice_Documents__c)invoiceDocumentRow.invoicedocument);
            }
        }

        checkandCreateDocs(tocheckandCreateIDList);

        System.debug('lpDocLocTypeComboSetMap -----> '+lpDocLocTypeComboSetMap);

        for(InvoiceDocumentRow invoiceDocumentRow : invoiceDocumentRows){
            if( invoiceDocumentRow.isNew && invoiceDocumentRow.validUpload()){
                Attachment tempclAtt = invoiceDocumentRow.getNewAttachment().clone(false, true, false, false);
                tempclAtt.ParentId=invoiceDocumentRow.att.ParentId;
                attsToUpload.add(tempclAtt);
                invoiceDocumentRow.clearAttachmentBody();
                if(invoiceDocumentRow.invoiceDocument.get('Sharing_Type__c')=='Secure'){
                    rowsToUpdate.add(invoiceDocumentRow);
                }
            }
        }

        if(attsToUpload.isEmpty()){
            ApexPages.Message pMessage = new ApexPages.Message(ApexPages.Severity.ERROR, Label.Submit_without_attachments);
            ApexPages.addMessage(pMessage);
            return;
        }

        Savepoint sp = Database.setSavepoint();
        try{
            system.debug('---' + attsToUpload);
            insert attsToUpload;
        }
        catch( System.DmlException ex ){
            ApexPages.addMessages(ex);
            return;
        }


        transient Map<Id, Attachment> attMap = new Map<Id,Attachment>();
        transient List<Attachment> atts = [SELECT Id, CreatedDate, ParentId FROM Attachment WHERE Id IN :attsToUpload];
        for(Attachment att : atts){
            attMap.put(att.ParentId, att);
        }

        List<Sobject> docsToUpdate = updateDocuments(rowsToUpdate, attMap);
        try{
            update docsToUpdate;
        }
        catch( System.DmlException ex ){
            Database.rollback(sp);
            ApexPages.addMessages(ex);
            return;
        }

        this.invoiceDocumentRows = queryDocuments();
    }

    public List<Sobject> updateDocuments(List<InvoiceDocumentRow> rowsToUpdate, Map<Id, Attachment> attMap){
        List<Sobject> documentsToUpdate = new List<Sobject>();
        for(InvoiceDocumentRow invoiceDocumentRow : rowsToUpdate){
            Sobject invoiceDocToUpdate = invoiceDocumentRow.getAttachmentData();
            invoiceDocToUpdate.put('Document_Submitted__c', attMap.get(invoiceDocToUpdate.Id).CreatedDate.date());
            invoiceDocToUpdate.put('Status__c', InvoiceDocumentServices.PENDING);
            documentsToUpdate.add( invoiceDocToUpdate );
        }
        return documentsToUpdate;
    }

    public PageReference filterRedirect(){
        String pageRedirect = '/apex/DocumentWorkbench?Id='+parentId+'&invoiceType='+invoiceType;
        PageReference pageRef = new PageReference(pageRedirect);
        pageRef.setRedirect(true);
        return pageRef;
    }

    public void checkandCreateDocs(List<Invoice_Documents__c> checkandcreateIDList){

        lpMap=new Map<Id,LeasePayment__c>([select Id,Quote__r.Quote_Type__c,Quote__c,Quote__r.OpportunityId,Quote__r.Opportunity.AccountId, Residential_Project__c from LeasePayment__c where Id =:parentId and Quote__c!=null]);

        if(!lpMap.isEmpty()){
            lpDocLocTypeComboSetMap=LeasePaymentService.getexistingDocuments(new List<LeasePayment__c>{lpMap.get(parentId)},lpMap);
        }

        System.debug('lpDocLocTypeComboSetMap----->'+lpDocLocTypeComboSetMap);

        List<Document__c> docsToInsert = new List<Document__c>();
        List<Document__c> accdocsToInsert = new List<Document__c>();
        List<Document__c> oppdocsToInsert = new List<Document__c>();
        List<Document__c> rpdocsToInsert = new List<Document__c>();

        for(Invoice_Documents__c invDoc:checkandcreateIDList){
            System.debug('invDoc---->'+invDoc);
            System.debug('lpMap---->'+lpMap);
            System.debug('invDoc---->'+lpDocLocTypeComboSetMap);
            if(invDoc.Location__c=='Account'){
                if(lpDocLocTypeComboSetMap.containsKey(invDoc.Lease_Payment__c) && lpDocLocTypeComboSetMap.get(invDoc.Lease_Payment__c).containsKey(lpMap.get(invDoc.Lease_Payment__c).Quote__r.Opportunity.AccountId+invDoc.Documents_in_File__c)){
                }
                else{
                    accdocsToInsert.add(new Document__c(Account__c=lpMap.get(invDoc.Lease_Payment__c).Quote__r.Opportunity.AccountId, Document_Type__c=invDoc.Documents_in_File__c, Name=invDoc.Documents_in_File__c));
                }
            }
            System.debug('accdocsToInsert----->'+accdocsToInsert);
            if(invDoc.Location__c=='Residential Project'){
                if(lpDocLocTypeComboSetMap.containsKey(invDoc.Lease_Payment__c) && lpDocLocTypeComboSetMap.get(invDoc.Lease_Payment__c).containsKey(lpMap.get(invDoc.Lease_Payment__c).Residential_Project__c+invDoc.Documents_in_File__c)){
                }
                else{
                    rpdocsToInsert.add(new Document__c(Residential_Project__c=lpMap.get(invDoc.Lease_Payment__c).Residential_Project__c, Document_Type__c=invDoc.Documents_in_File__c, Name=invDoc.Documents_in_File__c));
                }
            }
            System.debug('rpdocsToInsert----->'+rpdocsToInsert);

            if(invDoc.Location__c=='Opportunity'){
                if(lpDocLocTypeComboSetMap.containsKey(invDoc.Lease_Payment__c) && lpDocLocTypeComboSetMap.get(invDoc.Lease_Payment__c).containsKey(String.valueOf(lpMap.get(invDoc.Lease_Payment__c).Quote__r.OpportunityId) + String.valueOf(lpMap.get(invDoc.Lease_Payment__c).Quote__c) + invDoc.Documents_in_File__c)){
                }
                else{
                    oppdocsToInsert.add(new Document__c(Opportunity__c=lpMap.get(invDoc.Lease_Payment__c).Quote__r.OpportunityId, Quote__c=lpMap.get(invDoc.Lease_Payment__c).Quote__c , Document_Type__c=invDoc.Documents_in_File__c, Name=invDoc.Documents_in_File__c));
                }
            }
            System.debug('oppdocsToInsert----->'+oppdocsToInsert);
        }

        docsToInsert.addAll(accdocsToInsert);
        docsToInsert.addAll(oppdocsToInsert);
        docsToInsert.addAll(rpdocsToInsert);

        System.debug('docsToInsert----->'+docsToInsert);

        if(!docsToInsert.isEmpty()){
            insert docsToInsert;
        }

        for(Document__c doc:accdocsToInsert){
            if(!lpDocLocTypeComboSetMap.containsKey(parentId))
                lpDocLocTypeComboSetMap.put(parentId, new Map<String,Id>{doc.Account__c+doc.Document_Type__c => doc.Id});
            else
                lpDocLocTypeComboSetMap.get(parentId).put(doc.Account__c+doc.Document_Type__c,doc.Id);
        }

        for(Document__c doc:rpdocsToInsert){
            if(!lpDocLocTypeComboSetMap.containsKey(parentId))
                lpDocLocTypeComboSetMap.put(parentId, new Map<String,Id>{doc.Residential_Project__c+doc.Document_Type__c => doc.Id});
            else
                lpDocLocTypeComboSetMap.get(parentId).put(doc.Residential_Project__c+doc.Document_Type__c,doc.Id);
        }

        for(Document__c doc:oppdocsToInsert){
            if(!lpDocLocTypeComboSetMap.containsKey(parentId))
                lpDocLocTypeComboSetMap.put(parentId, new Map<String,Id>{String.valueOf(doc.Opportunity__c)+String.valueOf(doc.Quote__c)+doc.Document_Type__c => doc.Id});
            else
                lpDocLocTypeComboSetMap.get(parentId).put(String.valueOf(doc.Opportunity__c)+String.valueOf(doc.Quote__c)+doc.Document_Type__c,doc.Id);
        }

        System.debug('lpDocLocTypeComboSetMap -----> '+lpDocLocTypeComboSetMap);
    }

    //cdevarapalli Loan Backend
    public List<SelectOption> options{
        get{
            if(options == null){
                options = new List<SelectOption>();
                system.debug('---options---' + options);
                options.add(new SelectOption('All','All'));
                system.debug('---invoiceTypeSet---' + invoiceTypeSet);
                for(String opt:invoiceTypeSet){
                    options.add(new SelectOption(opt,opt));
                }
            }
            return options;
        }
        set;
    }
}