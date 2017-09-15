public class ScreenPopController {
    public String ani {get; private set;}
    public String dnis {get; private set;}
    public Account selectedAccount {get; private set;}
    public Contact selectedContact {get; private set;}
    public List <Case> caseList {get; private set;} 
    public Opportunity selectedOpportunity {get; private set;}

    public ScreenPopController() {
        // init
        selectedAccount = new Account();
        selectedContact = new Contact();
        caseList = new List <Case>();
        selectedOpportunity = new Opportunity();
        
        URLParams params = loadURLParams();
        ani = params.ani;
        dnis = params.dnis;
        if (String.IsNotBlank(params.ani)) {
            SearchResult sr = getSearchResult(params.ani);
            String accountId = getAccountId(sr);
            selectedContact = getContact(sr);
            if (String.IsNotBlank(accountId)) {
                selectedAccount = getAccount(accountId);
                Case c = getCase(accountId);
                if (c != null && c.Id != null) {
                    caseList.add(c);
                }
                selectedOpportunity = getOpportunity(accountId);
            }
        }
        
    }
    
    private static Opportunity getOpportunity(String accountId) {
        Opportunity oppty = new Opportunity();
        List <Opportunity> opptyList = [SELECT Id, Name, CampaignId, Campaign.Name, Dealer_Selection__c, Dealer_Selection__r.Name 
            FROM Opportunity WHERE AccountId = :accountId ORDER BY CreatedDate DESC];
        if (opptyList.size() > 0) {
            oppty = opptyList[0];
        }
        return oppty;
    }

    private static Case getCase(String accountId) {
        Case c = new Case();
        List <Case> caseList = [SELECT Id, Subject, CaseNumber, CreatedDate, Priority, Status, RecordType.Name, Reason_for_Escalation__c 
            FROM Case WHERE AccountId = :accountId ORDER BY CreatedDate DESC LIMIT 1];
        if (caseList.size() > 0) {
            c = caseList[0];
        }
        return c;
    }
        
    private static Account getAccount(String accountId) {
        Account acc = new Account();
        List <Account> accList = [SELECT Id, Name, Account_Display_Name__c, Phone, RecordType.Name 
            FROM Account WHERE Id = :accountId];
        if (accList.size() > 0) {
            acc = accList[0];
        }
        return acc;    
    }

    private static URLParams loadURLParams() {
        URLParams params = new URLParams();
        params.ani = ApexPages.currentPage().getParameters().get('ANI');    
        params.dnis= ApexPages.currentPage().getParameters().get('DNIS');    
        return params;    
    }
        
    private static SearchResult getSearchResult(String ani) {
        SearchResult sr = new SearchResult();
        List<List<SObject>> searchList = [FIND :ani IN Phone FIELDS 
            RETURNING Contact(Id,Name,Phone,MobilePhone,AccountId,Account.RecordType.Name),
                Account(Id,Name,Phone,RecordType.Name)
            ];    
        if (searchList != null) {
            if (searchList.size() > 0) {
                sr.contactList = (List<Contact>)searchList[0];
            }
            if (searchList.size() > 1) {
                sr.accountList = (List<Account>)searchList[1];
            }
        }
        
        return sr;
    }
    
    private static String getAccountId(SearchResult sr) {
        String accountId;
        
        if (sr.accountList.size() == 1) {
            accountId = sr.accountList[0].Id;
        } else {
            Set <String> accountIdSet = new Set <String>();
            for (Contact con : sr.contactList) {
                if (con.AccountId != null) {
                    accountIdSet.add(con.AccountId);
                }
            }
            if (accountIdSet.size() == 1) {
                List <String> accountIdList = new List <String>(accountIdSet);
                accountId = accountIdList[0];
            }
        }
    
        return accountId;    
    }

    private static Contact getContact(SearchResult sr) {
        Contact c = new Contact();
        
        if (sr.contactList != null && sr.contactList.size() > 0) {
            c = sr.contactList[0];
        }
    
        return c;    
    }
    
    private class URLParams {
        String ani;
        String dnis;
    }
    private class SearchResult {
        List <Account> accountList = new List <Account>();    
        List <Contact> contactList = new List <Contact>();    
    }
    
}