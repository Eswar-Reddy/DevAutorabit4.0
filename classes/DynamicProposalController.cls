public class DynamicProposalController {
    
    private static string SECRET_KEY = Label.DynamicProposalSecretKey;
    public static String equinoxURL;
    public static String quoteWizard = null;
	public static boolean isManualMode = false;
    
    public DynamicProposalController(ApexPages.StandardController controller){
        quoteWizard = apexpages.currentpage().getparameters().get('quoteWizard');
        System.debug('quoteWizard----->'+quoteWizard);
        if(quoteWizard=='Manual Mode')
            isManualMode = true;
        if(!OrgUtil.runningInASandbox()){
            equinoxURL = Label.equinoxproposalURL_Production;
            if(isManualMode)
                equinoxURL = Label.manualmodeProductionURL ;
        }
            
        else{
            equinoxURL = Label.equinoxproposalURL_Sandbox;
            if(isManualMode)
                equinoxURL = Label.manualmodeSandboxURL;
        }
            
    }
    
    public static PageReference forwardToEquinox(){
        Id oppId = apexpages.currentpage().getparameters().get('oppId');
        Id qotId = apexpages.currentpage().getparameters().get('quoteId');
        String action = apexpages.currentpage().getparameters().get('action');
        System.debug('oppId----->'+oppId);
        if(oppId!=null && action=='insert'){
            System.debug('Inside----->');
            Opportunity opp = [SELECT Id,Name,AccountId from Opportunity WHERE Id=:oppId];
            Quote qt = new Quote();
            qt.Name = opp.Name;
            qt.OpportunityId = opp.Id;
            qt.Account__c = opp.AccountId;
            qt.Quote_Wizard__c = quoteWizard;
            
            try{
                insert qt;
                Quote_Summary__c qtSum = new Quote_Summary__c();
                qtSum.Locked_Scenario__c=qt.id;
                qtSum.Account_Name__c=opp.AccountId;
                insert qtSum;
                
                return getEquinoxQuotePage(qt);
            }
            catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
                return null;
            }
        }
        else if(qotId!=null && action=='edit'){
            Quote qt = [Select Id,Account__c from Quote where Id = :qotId];
            return getEquinoxQuotePage(qt);
        }
        else if(qotId != null && action == 'copy'){
            Quote newQt = new Quote();
            for(Quote oq : [SELECT Name, OpportunityId, Account__c, RecordTypeId, Lease_Doc_Signed__c, QuoteType__c FROM Quote WHERE Id = :qotId]) {
                newQt.Name = oq.Name;
                newQt.OpportunityId = oq.OpportunityId;
                newQt.Account__c = oq.Account__c;
                newQt.RecordTypeId = oq.RecordTypeId;
                newQt.QuoteType__c = oq.QuoteType__c;
                newQt.Quote_Wizard__c = quoteWizard;
            }

            try{
                insert newQt;
                Quote_Summary__c qtSum = new Quote_Summary__c();
                qtSum.Locked_Scenario__c = newQt.id;
                qtSum.Account_Name__c = newQt.Account__c;
                insert qtSum;

                return getEDDiECloneQuotePage(newQt.Id, qotId, newQt.Account__c);
            }
            catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
                return null;
            }
        }
        else{
            return null;
        }   
    }
    
    public static PageReference getEquinoxQuotePage(Quote qt){
        String pageURL = equinoxURL + '/quote/' + qt.Id + '#id_token=' + getIdToken(qt.Id, qt.Account__c);
        PageReference pageRef = new PageReference(pageURL);
        System.debug('pageRef----->'+pageRef);
        return pageRef;
    }

    public static PageReference getEDDiECloneQuotePage(Id newQuoteId, Id oldQuoteId, Id accountId){
        String eddieURL;
        if(OrgUtil.runningInASandbox()){
            eddieURL = Label.manualmodeSandboxURL;
        } else {
            eddieURL = Label.manualmodeProductionURL;
        }
        String pageURL = eddieURL + '/quote/' + newQuoteId + '?cloneQuoteSFID=' + oldQuoteId +/* '&returnURL=' + sfReturnURL +*/ '#id_token=' + getIdToken(newQuoteId, accountId);

        PageReference pageRef = new PageReference(pageURL);
        System.debug('pageRef----->'+pageRef);
        return pageRef;
    }

    public static String getIdToken(Id quoteId, Id accountId){
        String quoteIdEncoded = EncodingUtil.urlEncode(quoteId, 'UTF-8');
        String timeStampEncoded = EncodingUtil.urlEncode(String.valueOf(System.now().getTime()), 'UTF-8');
        String userIdEncoded = EncodingUtil.urlEncode(Userinfo.getUserId(), 'UTF-8');
        String accountIdEncoded = EncodingUtil.urlEncode(accountId, 'UTF-8');

        String quoteIdtimeStampEncoded = 'quote_id='+quoteIdEncoded+'&timestamp='+timeStampEncoded+'&user_id='+userIdEncoded+'&account_id='+accountIdEncoded;

        Blob cryptoKey = EncodingUtil.base64Decode(SECRET_KEY);
        Blob encryptedSignature = Crypto.encryptWithManagedIV('AES128',cryptoKey, Blob.valueOf(quoteIdtimeStampEncoded));

        String base64EncodedQidTmStmp = EncodingUtil.base64Encode(encryptedSignature);

        return base64EncodedQidTmStmp;
    }
}