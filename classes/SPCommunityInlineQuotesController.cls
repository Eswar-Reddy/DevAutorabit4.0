public with sharing class SPCommunityInlineQuotesController {
    private final Opportunity oppty;
    public List<Quote> quotes {get;set;}
    public boolean ppaUser {get;set;}
    public boolean ppaPartnerAcct {get;set;}
    public Boolean isSalesConfigActive {get; private set;}

    public SPCommunityInlineQuotesController(ApexPages.StandardController controller) {
        // init
        ppaUser = false;
        ppaPartnerAcct = false;
        isSalesConfigActive = false;
        quotes = new List <Quote>();
        
        oppty = getOpportunity(controller.getId());
        
        if (schema.sobjecttype.Quote.isAccessible()){
            quotes = getQuoteList(controller.getId());
        }
        
        User u = getUser(UserInfo.getUserId());
        if (u.Business_Function__c != null && u.Business_Function__c.containsIgnoreCase('Create PPA Quote')) {
            ppaUser = true;
        }
        Account a = getAccount(u.AccountId);
        if (a.Special_Programs__c != null && a.Special_Programs__c.containsIgnoreCase('Helix PPA Program')) {
            ppaPartnerAcct = true;
        }

        List <Cost_Matrix__c> cmList = getCostMatrixList(oppty.Facility_State1__c);
        if (cmList.size() > 0) {
            isSalesConfigActive = true;
        }
    }
    
    private static Opportunity getOpportunity(String opptyId) {
        Opportunity o = new Opportunity();
        if (String.IsNotBlank(opptyId)) {
            List <Opportunity> oList = [SELECT Id, Name, Facility_State1__c FROM Opportunity WHERE Id = :opptyId];
            if (oList.size() > 0) {
                o = oList[0];
            }
        }
        return o;
    }

    private static List <Quote> getQuoteList(String opptyId) {
        List <Quote> qList = new List <Quote>();
        
        String recordTypeId;
        Map<String, Schema.RecordTypeInfo> rtiMap = Schema.SObjectType.Quote.getRecordTypeInfosByName();
        if (rtiMap.containsKey('Commercial Quote')) {
            recordTypeId = rtiMap.get('Commercial Quote').getRecordTypeId();
        }
        if (String.IsNotBlank(opptyId) && String.IsNotBlank(recordTypeId)) {
            qList = [SELECT Id,
                         Name,
                         LastModifiedDate,
                         System_Size_kWp__c,
                         System_Production_Year_1__c,
                         Year_1_PPA_Price__c,
                         Escalator__c,
                         ExpirationDate
                  FROM Quote
                  WHERE OpportunityId = :opptyId
                        AND RecordTypeId =: recordTypeId];
        }
        return qList;
    }
        
    private static User getUser(String userId) {
        User u = new User();
        if (String.IsNotBlank(userId)) {
            List <User> uList = [SELECT Id, Business_Function__c, AccountId, UserType FROM User WHERE Id = :userId];
            if (uList.size() > 0) {
                u = uList[0];
            }
        }          
        return u;
    }
    
    private static Account getAccount(String accountId) {
        Account a = new Account();
        if (String.IsNotBlank(accountId)) {
            List <Account> aList = [SELECT Id, Name, Special_Programs__c FROM Account WHERE Id = :accountId];
            if (aList.size() > 0) {
                a = aList[0];
            }
        }
        return a;
    }
    
    private static List <Cost_Matrix__c> getCostMatrixList(String state) {
        List <Cost_Matrix__c> cmList = new List <Cost_Matrix__c>();
        if (String.IsNotBlank(state)) {
            cmList = [SELECT Id, Sales_Configuration__r.Active__c 
                    FROM Cost_Matrix__c 
                    WHERE State__c = :state AND Sales_Configuration__r.Active__c = true];
        }
        return cmList;
    }
    
}