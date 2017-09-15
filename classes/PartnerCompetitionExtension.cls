public with sharing class PartnerCompetitionExtension {

    private final Lead leadRecord;
    public static boolean isQuotes {get;set;}
    public static boolean isAgreements {get;set;}
    public static Lead ld {get;set;}

    public PartnerCompetitionExtension(ApexPages.StandardController controller) {
    
         this.leadRecord = (Lead)controller.getRecord();
        
    }
    
    public Lead getLeadDetails() {
        ld = [Select Id, Name, State, Street, Country, PostalCode, Phone, MobilePhone, Email FROM Lead WHERE Id =: leadRecord.Id LIMIT 1];
        return ld;
        
    }
    
    public List<Opportunity> getPartnerResults() {
    
        isQuotes = false;
        isAgreements = false;
    
        Lead l = getLeadDetails();
        
        List<Opportunity> competingOpps = new List<Opportunity>();
        String leadState = l.State;
        String leadStreet = l.Street;
        String leadPhone = '';
        String leadMobile = '';
        String leadEmail = '';
        
        String queryString = 'Select o.Name, o.StageName, o.CreatedDate, o.Customer_Street__c, o.Customer_City__c, o.Customer_State__c, o.Account.Phone, o.Id, o.Partner_Account_Id__r.Type,' + 
            ' o.Partner_Account_Id__c, o.Account.Email__c, (Select a.CreatedDate, a.Id, a.Name, a.echosign_dev1__Status__c From Agreements__r a WHERE a.CreatedDate >= LAST_N_DAYS:30' +  
            ' OR a.echosign_dev1__DateSent__c >= LAST_N_DAYS:30 OR a.echosign_dev1__DateSigned__c >= LAST_N_DAYS:30), ' +
            '(Select q.Id, q.CreatedDate, q.Account__c, q.Name, q.Status From Quotes q WHERE q.CreatedDate >= LAST_N_DAYS:30) From Opportunity o ' +
            'Where o.RecordType.Name = \'Home Owner\' AND (o.Partner_Account_Id__r.Type LIKE \'Premier%\' OR o.Partner_Account_Id__r.Type LIKE \'Elite%\' OR ' +
            'o.Partner_Account_Id__r.Type LIKE \'Master%\') AND ((o.Customer_State__c =: leadState AND o.Customer_Street__c =: leadStreet) ';
        
        if(l.Phone != null) {
            System.debug('l.Phone: ' + l.Phone);
            leadPhone = l.Phone;
            queryString += 'OR o.Account.Phone =: leadPhone ';
        }
        if(l.MobilePhone != null) {
            System.debug('l.MobilePhone: ' + l.MobilePhone);
            leadMobile = l.MobilePhone;
            queryString += 'OR o.Account.Phone =: leadMobile ';
        }
        
        if(l.Email != null) {
            System.debug('l.Email: ' + l.Email);
            leadEmail = l.Email;
            queryString += 'OR o.Account.Email__c =: leadEmail';
        }
        
        queryString += ')';
        
        competingOpps = Database.query(queryString);
        
        for(Opportunity o : competingOpps) {
            if(o.Quotes.size() > 0) {
                isQuotes = true;
            }    
            if(o.Agreements__r.size() > 0) {
                  isAgreements = true;
            }
        }    
        return competingOpps;
    }

}