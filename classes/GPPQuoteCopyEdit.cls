//Controller Class for GPPQuoteCopyEdit VF Page
/*Changes Made-
1. Date - 17-04-2014
  Retrieved GPP URL from Custom Setting
  GPP URL -  http://devgppweb.us.sunpowermonitor.com/auth/authentication-ui.html
  
*/

public class GPPQuoteCopyEdit {
    private final Quote qot;
    
/***** PROPERTY *****/
public String propQId { get; set; }

public List<Partner> installerPartners {get; set; }

public String installer { get; set; }

public List<Id> InstallerIds = new List<Id>();

public List<Account> accList {get; set;}

List<InstallerWrapper> wrapperList = new List<InstallerWrapper>();

public String propSelectedRecord { get; set; }

public string propValue { get; set; }

public Boolean isLocked { get; set;}

/*** END PROPERTY ***/  
    
/******* Constructor: start *******/    
    public GPPQuoteCopyEdit(ApexPages.StandardController controller) 
    {
        if(ApexPages.currentpage().getParameters().get('act') == null)
            ApexPages.currentpage().getParameters().put('act','e');
            
        String strWhereClause= 'WHERE id=\'' + controller.getId() + '\'';    
        List<Quote> lstQot= GPPQueryHelper.GetQuotes(strWhereClause); 
        
        if(lstQot != null && !lstQot.isEmpty()){
            this.qot = lstQot[0];
            propQId = qot.Id;
            isLocked = qot.is_locked__c;
            System.debug('isLocked  : ' + isLocked );
        }
    }
/******* Constructor: end *******/

/******* Init Function: start *******/    
    public Pagereference GPPQuoteCopyEditInit()
    {
        PageReference reference= null;
        String strGPPUrl= GPP_Settings__c.getInstance('Settings').BaseURL__c;
        String sOwnerId= UserInfo.getUserId();          
        String sAction= ApexPages.currentpage().getParameters().get('act');
        
        if(String.isNotBlank(sAction) && sAction=='e')
        {
            //Edit Scenario
            //Set the GPP URL with parameters
            reference= new PageReference(strGPPUrl);
                reference.getParameters().put('quote_id',qot.QuoteNumber );
                reference.getParameters().put('session_id', UserInfo.getSessionId());
                reference.getParameters().put('owner_id', sOwnerId);  
                reference.getParameters().put('copy_from_id', '');          
            reference.setRedirect(true);
            return reference;
        }
        else if(String.isNotBlank(sAction) && sAction=='c')
        {
            //Copy Scenario,
            //Set the GPP URL with parameters 
            String sQuoteId = CreateQuoteHeader(qot.Account__c,qot.OpportunityId, sOwnerId);       
            if(String.isNotBlank(sQuoteId))
            {           
                reference= new PageReference(strGPPUrl);
                    reference.getParameters().put('quote_id', sQuoteId );
                    reference.getParameters().put('session_id', UserInfo.getSessionId());
                    reference.getParameters().put('owner_id', sOwnerId);  
                    reference.getParameters().put('copy_from_id', qot.QuoteNumber);          
                reference.setRedirect(true);
                return reference; 
            }          
        }
        return null;
    } 
/******* Init Function: start *******/    

/******* Function: start *******/
    public String CreateQuoteHeader(String sAccountId, String sOpportunityId, String sOwnerId)
    {
        Quote q= new Quote();
        q.Name= 'Quote-'+ String.valueOf(DateTime.now().getTime());
        q.OpportunityId= sOpportunityId;  
        
        try{
            insert q;         
        }
        catch(DMLException e){
            ApexPages.Message QuoteInsertErrMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Insert Failed on new Quote due to the following error :' + e.getMessage());
            ApexPages.addMessage(QuoteInsertErrMsg);
        }//END TRY-CATH 

        String strWhereClause= 'WHERE id=\'' + q.id + '\'';  
        List<Quote> lstQot= GPPQueryHelper.GetQuotes(strWhereClause); 

        if(lstQot != null && !lstQot.isEmpty()){ 
            return lstQot[0].QuoteNumber;
        }
        return null;
    }//End Func CreateQuoteHeader
    
    Public PageReference GPPInstallerSelectionInit()
    {
        String accId = qot.account__c;
//        List<Account> installerAccts = [select id,name,NH_SSE_Type__c, (select id from account where 
        System.debug('qot.account__C : ' + qot.account__C);
        System.debug('qot.account__C : ' + qot.account__r.Partner_Account__c);
        installerPartners = [select id, role, AccountToId, AccountFromId from partner where AccountFromId =: qot.account__r.Partner_Account__c and role = 'Installer'];
        InstallerIds.add(qot.account__r.Partner_Account__c); 
        isLocked = qot.is_locked__c; 
        for(Partner p : installerPartners )
               InstallerIds.add(p.AccountToId);
              
        accList = [select id, name, Certified__c,BillingStreet, Billingcity,BillingState, BillingPostalCOde,BillingCOuntry,Dealer_Tier__c from account where id in: InstallerIds and Certified__c = true];
        System.debug(Logginglevel.error,'accList.size() : ' + accList.size());
        
        for(Account acc : accList)
        {
            if(qot.installer__c == acc.id){
                wrapperList.add(new InstallerWrapper(acc,true));
                propSelectedRecord = qot.installer__c;
            }
            else
                wrapperList.add(new InstallerWrapper(acc,false));
            
        }
                       
        if(accList.size() > 1)
        {
                return null;
            }
            else if(accList.size() == 1)
            {
                qot.installer__c  = accList[0].id;
                
            }
            else
            {
                qot.installer__c  = qot.account__r.Partner_Account__c;
            }
            update qot;
             PageReference p = new PageReference('/apex/GPPQuoteCopyEdit?Id='+qot.id +'&acc='+ accId +'&act=e');
             p.setRedirect(true);
            
            return p;
    }
    
    public List<InstallerWrapper> getInstallPartners()
    {
        

/*        System.debug(InstallerIds);
        List<SelectOption> options = new List<SelectOption>();
        for(Account acc : accList)
            options.add(new SelectOption(acc.id,acc.name));
            
            return options;*/
            
            return wrapperList;
    }   
    
    public pageReference submit()
    {
        System.debug('In submit propSelectedRecord'+propSelectedRecord);
        if(propSelectedRecord != null && propSelectedRecord !=''){
                qot.installer__c  = propSelectedRecord ;
        
          try{
            update qot;
            PageReference p = new PageReference('/apex/GPPQuoteCopyEdit?Id='+qot.id +'&acc='+ qot.account__c +'&act=e');
            p.setRedirect(true);
            return p;

        }catch (System.DmlException e) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,e.getDmlMessage(0)));
                return null;
        } 
            
        }else{
            System.debug('In submit null');
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Must select  an installer'));
           return null;
        }
    }     
    
    public pageReference cancel()
    {
        System.debug('In cancel');
        PageReference p = new PageReference('/'+qot.account__c);
        p.setRedirect(true);
        return p;
    }      
    
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

/*
public class InstallerWrapper{

public Boolean bSelected;
public Account insAcc{ get { return insAcc;} set {insAcc = value;} }
public Boolean propSelected { get { return bSelected; } set { bSelected= value; } }
public String propBillingAddress {get; set;}

    public InstallerWrapper(Account installerAcc, Boolean installerSelected)
    {
        bSelected = installerSelected;
        insAcc = installerAcc;
        if(installerAcc.BillingStreet != null)
            propBillingAddress = installerAcc.BillingStreet;
        if(installerAcc.BillingCity != null)
            propBillingAddress +=  ', ' + installerAcc.BillingCity;
        if(installerAcc.BillingState != null)
            propBillingAddress +=  ', ' + installerAcc.BillingState;
        if(installerAcc.BillingPostalCode != null)
            propBillingAddress += '  ' +installerAcc.BillingPostalCode;
    }
 }   */
}