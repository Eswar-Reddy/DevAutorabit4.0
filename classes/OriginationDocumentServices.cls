public with sharing class OriginationDocumentServices {


    public static Map<String, String> typeToField {
        get
        {
            if(typeToField == null)
            {
                typeToField = new Map<String, String>();
                for(Origination_Document_Invoice_Type__c customSetting : Origination_Document_Invoice_Type__c.getAll().values())
                {
                    typeToField.put(customSetting.Invoice_Type__c, customSetting.Approve_Field__c);
                }
            }
            return typeToField;
        }
        private set;
    }

    public static void removeApprovedField(List<Origination_Document__c> unApprovedDocs)
    {
        Map<Id, Account> accountsToUpdateMap = new Map<Id, Account>();
        for(Origination_Document__c unApprovedDoc : unApprovedDocs) {
            if(!accountsToUpdateMap.containsKey(unApprovedDoc.Account__c)) {
                accountsToUpdateMap.put(unApprovedDoc.Account__c, new Account(Id = unApprovedDoc.Account__c));
            }
            Account account = accountsToUpdateMap.get(unApprovedDoc.Account__c);
            account.put(typeToField.get(unApprovedDoc.Invoice_Type__c), null);
        }
        Map<Id, List<Origination_Document__c>> accountIdToOriginationDocs = GroupBy.ids('Account__c', unApprovedDocs);
        if(!accountsToUpdateMap.isEmpty())
        {
            List<Account> accountsToUpdateList = accountsToUpdateMap.values();
            SafeDml.SafeDML2.safeUpdate(accountsToUpdateList, createSafeDmlRelationship(accountIdToOriginationDocs, accountsToUpdateList));
        }
    }

    public static void setApprovedField(List<Origination_Document__c> approvedDocs) {
        Map<Id, List<Origination_Document__c>> accountIdToOriginationDocs = GroupBy.ids('Account__c', approvedDocs);

        Set<Id> accountIds = accountIdToOriginationDocs.keySet();
        String query = 'SELECT {0} , {1} FROM Account WHERE Id IN :accountIds';

        Set<String> accountFieldsList = Pluck.strings('Approve_Field__c', Origination_Document_Invoice_Type__c.getAll().values());
        accountFieldsList.add('Id');

        String accountFields = String.join(new List<String>(accountFieldsList), ', ');
        String subQuery = '(SELECT Invoice_Type__c, Status__c FROM Origination_Documents__r WHERE Not_Required_for_Approval__c = false)';

        query = String.format(query, new List<String>{accountFields, subQuery});
        List<Account> accounts = Database.query(query);
        Map<Id, Account> accountsToUpdate = new Map<Id, Account>();

        for( Account account : accounts )
        {
            Map<String, Boolean> typeToAllApproved = new Map<String, Boolean>();
            for( Origination_Document__c aDocument : account.Origination_Documents__r )
            {
                Boolean previousApproved = (typeToAllApproved.containsKey(aDocument.Invoice_Type__c)) ? typeToAllApproved.get(aDocument.Invoice_Type__c) : true;
                typeToAllApproved.put(aDocument.Invoice_Type__c, aDocument.Status__c == InvoiceDocumentServices.APPROVED && previousApproved);
            }

            if(!accountsToUpdate.containsKey(account.Id)) {
                accountsToUpdate.put(account.Id, account);
            }
            account = accountsToUpdate.get(account.Id);

            for( String invoiceType : typeToField.keySet() )
            {
                if( account.get(typeToField.get(invoiceType)) == null)
                {
                    if(typeToAllApproved.containsKey(invoiceType) && typeToAllApproved.get(invoiceType))
                    {
                        account.put( typeToField.get( invoiceType ), Date.today() );
                    }
                }
            }
        }
        if(!accountsToUpdate.isEmpty())
        {
            List<Account> accountsToUpdateList = accountsToUpdate.values();
            SafeDml.SafeDML2.safeUpdate(accountsToUpdateList, createSafeDmlRelationship(accountIdToOriginationDocs, accountsToUpdateList));
        }
    }

    private static List<List<Origination_Document__c>> createSafeDmlRelationship (Map<Id, List<Origination_Document__c>> accountIdToOriginationDocs, List<Account> accounts)
    {
        List<List<Origination_Document__c>> originationDocumentsToAddError = new List<List<Origination_Document__c>>();
        for(Account account : accounts) {
            originationDocumentsToAddError.add(accountIdToOriginationDocs.get(account.Id));
        }
        return originationDocumentsToAddError;
    }
}