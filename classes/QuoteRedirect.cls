public with sharing class QuoteRedirect {
    private final Quote quote;
    private final Set<String> portalLicenseNames = new Set<String>{'Gold Partner'};
    private final User currentUser = [Select Profile.Name, UserType from User where ID = : userInfo.getUserId()];
    private Id oppId, oppRecId, oppAccId;
    //private String oppTheater;
    
    public QuoteRedirect(ApexPages.StandardController stdController) {
        if(!Test.isRunningTest()) {stdController.addFields(new List<String>{'Opportunity.Id', 'Opportunity.RecordTypeId', 'Opportunity.Theater__c', 'Opportunity.AccountId'});}
        this.quote = (Quote)stdController.getRecord();        
    }
    
    public PageReference redirect(){
        PageReference p;
        oppId = quote.Opportunity.Id;
        oppRecId = quote.Opportunity.RecordTypeId;
        oppAccId = quote.Opportunity.AccountId;
        //oppTheater = quote.Opportunity.Theater__c;
        
        String commercialRecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Opportunity.SObjectType).get('Commercial');
        
        if(SPCommunityUtility.isPartnerUser()){            
             if (SPCommunityUtility.isNewUIUser(UserInfo.getUserId())) { 
                 if(oppRecId == commercialRecordTypeId /*&& oppTheater.equalsIgnoreCase('North America')*/) {             
                     p = new PageReference('/apex/HelixPPA?opportunityId=' + oppId + '&quoteId=' + quote.Id);
                 } else {
                     p = Page.SPCommunityCustomer;                     
                     p.setAnchor ('/account/commercial/'+oppAccId+'/opportunity/'+oppId+'/quotes');
                 }
            }
            else{
                //usual quote page for all other partner users
                p = new PageReference('/apex/SPCommunityQuoteDetails?id='+quote.Id);                
                //Partner Community Global permission set
            }
            p.setRedirect(true);
        }
        else{
            p = new PageReference('/'+quote.Id + '?nooverride=1');
            p.setRedirect(true);
        }
        
        return p.setRedirect(true);
    }
}