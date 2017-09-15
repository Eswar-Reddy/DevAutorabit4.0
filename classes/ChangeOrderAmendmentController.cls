public class ChangeOrderAmendmentController {
    
    public echosign_dev1__SIGN_Agreement__c agg {get; private set;}
    @TestVisible public AccountInfo acc {get;set;}
    public echosign_dev1__SIGN_Agreement__c newAgg {get;set;}
    public echosign_dev1__SIGN_Agreement__c newagreement; // the agreement that comes back from docgen

    public Boolean showSave         {get; private set;}
    public Boolean showMultiCosign  {get; private set;}
    public Boolean showAdd          {get; private set;}
    public Boolean showErrorMsg     {get; private set;}
    public Boolean showChangeButton {get; private set;}
    public Boolean showOwnership    {get; private set;}

    public String multiCosignMsg    {get; private set;}
    public String coborrowerMsg     {get; private set;}
    public String borrowerMsg       {get; private set;}
    public String miscErrorMsg      {get; private set;}

    public List<Cosignee> removedCos        {get;set;}
    public List<Cosignee> newCos            {get;set;}
    public List<Cosignee> sameCos           {get;set;}
        
    @TestVisible public List<Cosignee> cos       {get;set;}
    public Integer cIdentifier      {get;set;}
    public Cosignee primaryCos      {get;set;}
    public Boolean isInternal       {get;set;}

    private Id pendingAmendmentId;
    public  boolean pendingAgreementExists {get;private set;}
    private Id accountId;


    public ChangeOrderAmendmentController() {
        showSave         = FALSE;
        showOwnership    = FALSE;
        showMultiCosign  = FALSE;
        showErrorMsg     = FALSE;
        showChangeButton = TRUE;
        pendingAgreementExists = FALSE;

        multiCosignMsg   = 'Multiple cosignees have been found. Contracts are limited to one cosignee, please remove additional cosignees.';
        coborrowerMsg    = ' is marked as a Co-Borrower and cannot be removed.';
        borrowerMsg      = ' is marked as a Borrower and cannot be removed.';

        cos = new List<Cosignee>();
        newAgg = new echosign_dev1__SIGN_Agreement__c();

        isInternal = UserInfo.getUserType() == 'Standard' ? TRUE : FALSE ;
        accountId =  ApexPages.currentPage().getParameters().get('accId');
        
        ResultMessage result = QuoteAmendmentUtility.checkPendingAmendment(null,accountId,'HomeOwner Information Change');
        if(result.success) {
            pendingAmendmentId = result.message;
            showErrorMsg = True;
            pendingAgreementExists = true;
        }                    

        try{
            Id aId = ApexPages.currentPage().getParameters().get('aid');
            agg = [SELECT Id, Account__c,echosign_dev1__DateSignedDate__c,Lease_Number__c, Opportunity__c,Quote__c,Quote__r.Consolidated_Lease_Number__c FROM echosign_dev1__SIGN_Agreement__c WHERE Id =: aId];

            Account a = [SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,(SELECT FirstName, LastName FROM Contacts WHERE Primary__c = TRUE) FROM Account WHERE Id =: agg.Account__c];

            acc = new AccountInfo(a);

            // Query for Contacts and Opportunity Contact Roles related to this Account - Turn into Cosignee inner class
            List<Contact> cosignees = [SELECT Id, FirstName, LastName,  Primary__c, Email, Phone, Include_in_lease_doc__c, AccountId, Credit_check_Passed__c, Credit_Customer_Number__c FROM Contact WHERE AccountId =: agg.Account__c ];
            List<OpportunityContactRole> roles = [SELECT Id, ContactId, Role FROM OpportunityContactRole WHERE OpportunityId IN (SELECT OpportunityId FROM Quote WHERE Id =: agg.Quote__c)  ];
            for(Contact c : cosignees){
                String role;
                for(OpportunityContactRole ocr : roles){
                    if(c.Id == ocr.ContactId) role = ocr.Role;
                }
                if(c.Include_in_Lease_Doc__c || role != NULL){
                    Cosignee cs = new Cosignee(c, c.Include_in_Lease_Doc__c, cos.size(), role, c.Primary__c);
                    cos.add(cs);
                }
                if(c.Primary__c && (role == 'Co Borrower' || role == 'Borrower')) showChangeButton = FALSE;
            }

            prepData();

        }catch(Exception e){
            showErrorMsg = TRUE;
            miscErrorMsg = 'An error has occured on page load. Please contact your system administrator for more information. Error Msg: ' +e.getMessage();
        }
    }

    public void prepData(){
        Integer numCos = 0;
        for(Cosignee c : cos){
            if(c.isPrimary) primaryCos = c;
            if(!c.isPrimary && c.onContract) numCos ++;
        }
        showMultiCosign = numCos > 1 ? TRUE : FALSE;
        showAdd = numCos == 0 ? TRUE : FALSE;
    }

    public pageReference addCosignee(){
        Cosignee ncos = new Cosignee(new Contact(), TRUE, cos.size(), NULL, FALSE);
        cos.add(ncos);
        showAdd = FALSE;
        return null;
    }

    public pageReference removeCosignee(){
        Cosignee cn = cos[cIdentifier];
        if(cn.con.Id == NULL) cos.remove(cIdentifier);
        if(cn.con.Id != NULL) cn.onContract = FALSE;

        prepData();

        return null;

    }

    public pageReference proceed(){
        showSave = TRUE;

        removedCos  = new List<Cosignee>();
        newCos      = new List<Cosignee>();
        sameCos     = new List<Cosignee>();

        for(Cosignee c : cos){
            if(!c.isPrimary){
                if(c.con.Include_in_Lease_Doc__c && !c.onContract) removedCOS.add(c);
                if(!c.con.Include_in_Lease_Doc__c && c.onContract)  newCOS.add(c);
                if(c.con.Include_in_Lease_Doc__c && c.onContract)  sameCOS.add(c);
            }
        }
        return null;
    }

    public pageReference back(){
        showSave = FALSE;
        return null;
    }

    public pageReference cancel(){
        Pagereference ref = new Pagereference('/'+agg.Id);
        ref.setRedirect(true);
        return ref;
    }

    public pageReference ownerBack(){
        showOwnership = FALSE;
        return null;
    }
    
    public PageReference backToAccount(){
        PageReference pr = new PageReference('/' + accountId);
        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference viewAmendment() {
        PageReference pr = new PageReference('/' + pendingAmendmentId);
        pr.setRedirect(true);   
        return pr;
    }
    
   //filtering the coSignee List
     Cosignee primaryContact;
     Cosignee cosigneeContact;
     
     public pageReference assignContact(){
         for (Cosignee temp : cos){
           system.debug('--------------' + temp);
            if(temp.isPrimary)
               primaryContact = temp;
            if(!temp.isPrimary && temp.onContract && temp.con.Id == NULL){
                Contact nc = new Contact();
                nc.FirstName = temp.coFirstName;
                nc.LastName = temp.coLastName;
                nc.Email = temp.coEmail;
                nc.Phone = temp.coPhone;
                nc.AccountId = agg.Account__c;
                insert nc;
                temp.con = nc;
               cosigneeContact = temp;
            }
              if(!temp.isPrimary && !temp.onContract && temp.con.Include_in_lease_doc__c && cosigneeContact == NULL){
                 cosigneeContact = temp;
             }
            if(!temp.isPrimary && temp.onContract && temp.con.Include_in_lease_doc__c){
                cosigneeContact = temp;
            }
         }
    
         return null;
    } 

    public pageReference submit(){
        
        // Doc Gen Callout
        // Agreement record Creation
        if(!Test.isRunningTest()) newAgreement = DocGenAmendmentRequest.sendRequestToDocgen(agg,acc,primaryContact,cosigneeContact,'HomeOwner Information Change',newAgg.Notes__c);
        if(Test.isRunningTest()) newAgreement = new echosign_dev1__SIGN_Agreement__c();
    
        if(newagreement <> null){ 
            List<Change_Audit__c> audits = new List<Change_Audit__c>();

            if(acc.a.BillingStreet != acc.aStreet) audits.add(createAudit('Account', acc.a.Id, acc.a.BillingStreet, acc.aStreet, 'BillingStreet'));
            if(acc.a.BillingCity != acc.aCity) audits.add(createAudit('Account', acc.a.Id, acc.a.BillingCity, acc.aCity, 'BillingCity'));
            if(acc.a.BillingPostalCode != acc.aZip) audits.add(createAudit('Account', acc.a.Id, String.valueOf(acc.a.BillingPostalCode), acc.aZip, 'BillingPostalCode'));

            for(Cosignee c : cos){
               
                if(c.con.FirstName != c.coFirstName) audits.add(createAudit('Contact', c.con.Id, c.con.FirstName, c.coFirstName, 'FirstName'));
                if(c.con.LastName != c.coLastName) audits.add(createAudit('Contact', c.con.Id, c.con.LastName, c.coLastName, 'LastName'));
                if(c.con.Email != c.coEmail) audits.add(createAudit('Contact', c.con.Id, c.con.Email, c.coEmail, 'Email'));
                if(c.con.Phone != c.coPhone) audits.add(createAudit('Contact', c.con.Id, c.con.Phone, c.coPhone, 'Phone'));
                if(c.con.Primary__c != c.isPrimary) audits.add(createAudit('Contact', c.con.Id, String.valueOf(c.con.Primary__c), String.valueOf(c.isPrimary), 'Primary__c'));
                if(c.con.Include_in_Lease_Doc__c != c.onContract) audits.add(createAudit('Contact', c.con.Id, String.valueOf(c.con.Include_in_Lease_Doc__c), String.valueOf(c.onContract), 'Include_in_Lease_Doc__c'));
                
            }

            insert audits;
       
            Pagereference ref = new Pagereference('/'+newagreement.Id); // This should be new Agreement, not old agreement
            ref.setRedirect(true);
            return ref;
       }
       else{
             miscErrorMsg = system.Label.amendmentFailed;
             showErrorMsg = true;
       }
       return null;   
    }

    public pageReference ownershipChange(){
        showOwnership = TRUE;
        return null;
    }

    public pageReference saveOwnerChange(){
        showOwnership = FALSE;
        prepData();
        return null;
    }

    public Change_Audit__c createAudit(String oType, Id oId, String oldval, String newval, String fapi){
        Change_Audit__c ca = new Change_Audit__c();
        ca.Agreement__c = newagreement.Id; // new agreement
        ca.Originating_Agreement__c = agg.Id; // original agreement
        ca.Account__c = agg.Account__c;
        ca.Object_Type__c = oType;
        ca.Object_Id__c = oId;
        ca.Old_Value__c = oldval;
        ca.New_Value__c = newval;
        ca.Field_API_Name__c = fapi;
        return ca;

    }

    // CoSignee Inner Class //

    @TestVisible public class Cosignee{
        public Integer identifier       {get;set;}
        public Contact con              {get;set;}
        public String coFirstName       {get;set;}
        public String coLastName        {get;set;}
        public String coEmail           {get;set;}
        public String coPhone           {get;set;}
        public Boolean isBorrower       {get;set;}
        public Boolean onContract       {get;set;}
        public Boolean isPrimary        {get;set;}
        public String role              {get;set;}
        public Boolean hasCreditCheck   {get;set;}

        public Cosignee(Contact c, Boolean onContract, Integer ident, String role, Boolean primary){
            this.identifier = ident;
            this.con = c;
            this.coFirstName = c.FirstName;
            this.coLastName = c.LastName;
            this.coEmail = c.Email;
            this.coPhone = c.Phone;
            this.isPrimary = primary;
            this.role = role;
            this.isBorrower = (role == 'Co Borrower' || role == 'Borrower') ? TRUE : FALSE;
            this.onContract = onContract;
            this.hasCreditCheck = String.isNotBlank(c.Credit_check_Passed__c) || String.isNotBlank(c.Credit_Customer_Number__c);
        }
    }

    // AccountInfo Inner Class //
    @TestVisible public class AccountInfo{
        public Account a        {get;set;}
        public String aStreet   {get;set;}
        public String aCity     {get;set;}
        public String aZip      {get;set;}
        public String firstName {get;set;}
        public String lastName  {get;set;}

        public AccountInfo(Account a){
            this.a = a;
            this.aStreet = a.BillingStreet;
            this.aCity = a.BillingCity;
            this.aZip = a.BillingPostalCode;
            this.firstName = a.Contacts[0].FirstName;
            this.lastName = a.Contacts[0].LastName;
        }
    }
}