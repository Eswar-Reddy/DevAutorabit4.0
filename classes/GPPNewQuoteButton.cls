//Last working code before updating the url for GPP
/*Changes Made-
1.Date - 18 March,2014
  GPP URL-http://gpp.cloudapp.net:8180/dealers-portal/auth/authentication-ui.html?session_id={session_id}&quote_id={quote_id}&copy_from_id={copy_from_id}
  Example-Example:http://gpp.cloudapp.net:8180/dealers-portal/auth/authentication-ui.html?session_id=1ff5df41d28aef398bd36c835348&quote_id=1&copy_from_id=2
2. Date - 17-04-2014
  Retrieved GPP URL from Custom Setting
  GPP URL -  http://devgppweb.us.sunpowermonitor.com/auth/authentication-ui.html
  
*/
public class GPPNewQuoteButton
{
   Public String QuoteInsertError {get;set;}
   public List<Quote> loQuote = new List<Quote>();
   public String sAccountId {get; set;}
   public String sOpportunityId {get; set;}
   public String sQuoteId {get; set;}
   public String strGPPUrl { get; set; }
   public String sOwnerId{ get; set; }
   public Quote qt {get; set;}
  public List<Partner> installerPartners {get; set; }
  public String installer { get; set; }
  public List<Id> InstallerIds = new List<Id>();
  public List<Account> accList {get; set;}
  List<InstallerWrapper> wrapperList = new List<InstallerWrapper>();
  public String propSelectedRecord { get; set; }
  public string propValue { get; set; }
    public boolean redirectNow {get;set;}
   public String gppUrl{get;set;} 

/******* Constructor: start *******/
    public GPPNewQuoteButton(ApexPages.StandardController controller) {
          strGPPUrl=GPP_Settings__c.getInstance('Settings').BaseURL__c;
          sAccountId= ApexPages.currentPage().getParameters().get('acc');
          sOpportunityId= ApexPages.currentPage().getParameters().get('opp');
          sQuoteid = ApexPages.currentPage().getParameters().get('quoteid');
//          if(sQuoteid != null)
          sOwnerId= UserInfo.getUserId();  
          System.debug(logginglevel.error,'sAccountId : '+sAccountId);
          System.debug(logginglevel.error,'sOpportunityId: '+sOpportunityId);
    
    }
/******** Constructor: end ********/

/******* Init Function: start *******/    
    public PageReference NewQuoteInit()
    {
//        PageReference reference= null;
//        String strGPPUrl = 'http://gpp.cloudapp.net:8180/dealers-portal/auth/authentication-ui.html';
            qt = CreateQuoteHeader(sAccountId, sOpportunityId, sOwnerId);
            PageReference reference = new PageReference('/apex/GPPNewInstallerSelection?acc='+sAccountId +'&opp='+sOpportunityId+'&quoteid='+qt.id);
            reference.setRedirect(true);       
            
/*        if(String.isNotBlank(sAccountId) && String.isNotBlank(sOpportunityId) && String.isNotBlank(sOwnerId))
        {
//            sQuoteId = CreateQuoteHeader(sAccountId, sOpportunityId, sOwnerId);
            if(String.isNotBlank(sQuoteId))
            {
                reference= new PageReference(strGPPUrl);
                reference.getParameters().put('quote_id', sQuoteId);
                reference.getParameters().put('session_id', UserInfo.getSessionId());
                reference.getParameters().put('owner_id', sOwnerId);  
                reference.getParameters().put('copy_from_id', '');           
                reference.setRedirect(true);
            }
            else
            {          
            }      
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Incorrect Parameters! Please try again.'));        
        }      */
        return reference;
    }
/******** Init Function: end ********/  
/******* Function: start *******/
    public Quote CreateQuoteHeader(String sAccountId, String sOpportunityId, String sOwnerId)
    {
        System.debug(logginglevel.error,'CreateQuoteHeader: ');
        Quote q= new Quote(Name='Quote-'+ String.valueOf(DateTime.now().getTime()),
                           OpportunityId= sOpportunityId);
        
        try
        {
            insert q;
         
        }
        catch(DMLException e)
        {
            ApexPages.Message QuoteInsertErrMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Insert Failed on new Quote due to the following error :' + e.getMessage());
            ApexPages.addMessage(QuoteInsertErrMsg);
        }//END TRY-CATH 
        system.debug('sangita-'+q.id);
       
/*         loQuote = [SELECT account__r.Partner_Account__c, Opportunityid, Opportunity.installer__c, QuoteNumber FROM Quote WHERE id=:q.id LIMIT 1];  
   //          System.debug('sangita2-'+ QuoteNumber);  
        qt = loQuote[0];*/
        return q;
    }//End Func CreateQuoteHeader
    
    Public PageReference GPPInstallerSelectionInit()
    {
      loQuote = [SELECT account__r.Partner_Account__c, Opportunityid, installer__c, QuoteNumber FROM Quote WHERE id=:sQuoteid LIMIT 1];  
      qt = loQuote[0];
        System.debug(logginglevel.error,'qot.account__C : ' + saccountid);
        System.debug('qot.account__C : ' + qt.account__r.Partner_Account__c);
        installerPartners = [select id, role, AccountToId, AccountFromId from partner  where AccountFromId =: qt.account__r.Partner_Account__c and role = 'Installer'];
        InstallerIds.add(qt.account__r.Partner_Account__c); 
        for(Partner p : installerPartners )
               InstallerIds.add(p.AccountToId);
        System.debug('----------------InstallerIds='+InstallerIds);      
    accList = [select id, name, Certified__c,BillingStreet, Billingcity,BillingState, BillingPostalCOde,BillingCOuntry, Dealer_Tier__c from account where id in: InstallerIds and Certified__c = true];
        System.debug('----------------accList='+accList);      
        System.debug(Logginglevel.error,'accList.size() : ' + accList.size());
        
        for(Account acc : accList)
      {
        if(qt.installer__c == acc.id)
              wrapperList.add(new InstallerWrapper(acc,true));
            else
              wrapperList.add(new InstallerWrapper(acc,false));
            
      }
                  
        if(accList.size() > 1)
        {       
                redirectNow = false;
                return null;
            }
            else if(accList.size() == 1)
            {
              qt.installer__c  = accList[0].id;
              
            }
            else
            {
              qt.installer__c  = qt.account__r.Partner_Account__c;
            }
            update qt;
                redirectNow = true;

                PageReference reference= new PageReference(strGPPUrl);
                reference.getParameters().put('quote_id', qt.QuoteNumber);
                reference.getParameters().put('session_id', UserInfo.getSessionId());
                reference.getParameters().put('owner_id', sOwnerId);  
                reference.getParameters().put('copy_from_id', '');           
                gppUrl =   reference.getUrl(); 
                reference.setRedirect(true);
            
            return null;
    }
    
    public List<InstallerWrapper> getInstallPartners()
    {
    return wrapperList;
    }   
    
    public pageReference submit()
    {
        System.debug('In submit');
        if(propSelectedRecord != null && propSelectedRecord !=''){
        qt.installer__c  = propSelectedRecord ;
        try{
        update qt;
        redirectNow = true;
                PageReference reference= new PageReference(strGPPUrl);
                reference.getParameters().put('quote_id', qt.QuoteNumber);
                reference.getParameters().put('session_id', UserInfo.getSessionId());
                reference.getParameters().put('owner_id', sOwnerId);  
                reference.getParameters().put('copy_from_id', '');
                gppUrl =   reference.getUrl();         
                reference.setRedirect(true);
                System.debug('------------------reference='+reference);
                return null;
           }catch (System.DmlException e) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,e.getDmlMessage(0)));
                return null;
        }       
              
        }
        else{
          System.debug('In submit null');
          redirectNow = false;
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Must select  an installer'));
           return null;
        }
    }     
    
    public pageReference cancel()
    {
        System.debug('In cancel');
        PageReference p = new PageReference('/'+saccountid);
        p.setRedirect(true);
        return p;
    }
    
/******** Function: end ********/  

 public void ChangeSelection()
    {
         System.debug('---------------------propSelectedRecord='+propSelectedRecord);
        System.debug('---------------------propValue='+propValue);
        System.debug('---------------------wrapperList='+wrapperList);

        boolean blnAtleastoneInstallerSelected = false;
        if(propSelectedRecord != null && propValue != null && (new Set<String>{'true','false'}).contains(propValue)){
            
            Boolean bUsrInput = (propValue == 'true' ? true : false);
            for(InstallerWrapper iw: wrapperList)
                {
                    iw.propSelected= (iw.insAcc.Id == propSelectedRecord) ? bUsrInput : false;
                    

                }
            }  

            for(InstallerWrapper iw: wrapperList){
                  if(!blnAtleastoneInstallerSelected && iw.propSelected == true)
                        blnAtleastoneInstallerSelected= true;
              }  

              if(!blnAtleastoneInstallerSelected)  
                 propSelectedRecord = null;
               System.debug('---------------------------------propSelectedRecord='+propSelectedRecord); 
    }//End Func ChangeSelection
    
/******** Function: end ********/   

//Wrapper Class

  

}//End Class NewQuote