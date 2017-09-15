//cdevarapalli ---*Controller Class for Credit Check Page*---
public class creditCheckPageCtrl {
    
    public Contact con;
    public Boolean isNewHomes;
    public List<CreditCheckRow> CreditCheckRows {get; set;}
    public Set<String> permissions;
    public Map<String,String> ccrMap = new Map<String,String>();
    public String oppId=null;
    private String partnerURL=null;
    public Map<String,Credit_Check_Request__c> ccaMap = new Map<String,Credit_Check_Request__c>();
    public boolean isPrimary{get;set;}
    private final String LOAN = 'Loan';
    private final String LEASE = 'Lease';
    public String strActParam = '';
    public List<SpectrumDebugUtility.debugLog> spExLogsList = new List<SpectrumDebugUtility.debugLog>();
    
    public creditCheckPageCtrl(ApexPages.StandardController controller){
        isNewHomes = false;
        CreditCheckRows = new List<CreditCheckRow>();
        Opportunity opp = new Opportunity();
        Campaign camp = new Campaign();
        this.con = (Contact)controller.getRecord();
        con=[select Id,FirstName,LastName,AccountId,Email,Phone,MailingStreet,MailingCity,MailingState,MailingPostalCode,Primary__c from Contact where Id=:con.Id];
        if(con.id != null){
            system.debug('con');
            opp = [select Id,CampaignId from Opportunity where Accountid =: con.AccountId LIMIT 1];
            if(opp.id != null && opp.CampaignId != null){
                system.debug('opp');
                camp = [select Id,NH_Community__c from Campaign where id =: opp.CampaignId];
                if(camp.id != null && camp.NH_Community__c != null){
                    system.debug('camp');
                   isNewHomes = true; 
                }
            }

        }
        
        if(con.Primary__c==true){
            isPrimary=true;
            List<Opportunity> oppList = [select Id from Opportunity where AccountId=:con.AccountId];
            if(!oppList.isEmpty()){
                oppId=oppList[0].Id;
            }
            permissions=CreditCheckUtil.getPartnerPermissions();
            System.debug('permissions----->'+permissions);
            if(UserInfo.getUserType()!='Standard' && permissions.isEmpty()){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Current user does not have required permssions to do a lease or loan type of Quote'));
            }
            populateCreditCheckRows();
        }
        else{
            isPrimary=false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'This is not a primary contact'));
        }
    }
    
    public class CreditCheckRow{
        public String creditCheckName{get;set;}
        public Id creditCheckId{get;set;}
        public boolean selected{get;set;}
        public String status{get;set;}
        public String Action{get;set;}
        public boolean disabled{get;set;}
        public String AppType{get;set;}
    }
    
    public void populateCreditCheckRows(){
        CreditCheckRows.clear();
        ccaMap.clear();
        List<Credit_Check_Request__c> ccaList = [select Id,Application_Id__c,Email_Counter__c, Application_Type__c, Credit_Beureu__c, Status__c, Account__r.Owner.Contact.Account.Name from Credit_Check_Request__c where Contact__c=:con.Id];
        if(!ccaList.isEmpty()){
            for(Credit_Check_Request__c cca:ccaList){
                CreditCheckRow ccr = new CreditCheckRow();
                ccr.selected = false;
                ccr.status=cca.Status__c;
                ccr.creditCheckId=cca.Id;
                if(cca.Status__c=='' || cca.Status__c==null || cca.Status__c=='New'){
                    ccr.Action='New';
                }
                if(cca.Status__c!='' && cca.Status__c!=null && cca.Status__c!='New'){
                    ccr.Action='Resend';
                    ccr.disabled=false;
                    if(cca.Status__c=='Approved' || (cca.Application_Type__c==LEASE && cca.Status__c != 'Pending - Application Opened' && cca.Status__c !=  'Pending - Application Sent')){
                        ccr.Action=null;
                        ccr.disabled=true;
                    }     
                }
                if(cca.Application_Type__c==LEASE){
                    ccr.creditCheckName = 'SunPower Lease';
                    ccr.AppType=cca.Application_Type__c;
                    System.debug('cca Status----->'+cca.Status__c);
                    ccaMap.put(cca.Application_Type__c,cca);
                    CreditCheckRows.add(ccr);
                }
                
                
                if(cca.Application_Type__c==LOAN){
                    system.debug('Application Type Loan and isNewHomes = '+ isNewHomes);
                    //if(!isNewHomes){
                        system.debug('Not New Homes ');
                        ccr.creditCheckName = 'SunPower Loan';
                        ccr.AppType=cca.Application_Type__c;
                        ccaMap.put(cca.Application_Type__c,cca);
                        CreditCheckRows.add(ccr);
                   // }
                }    
                
            }
        }
        System.debug('Line 90----->'+ccaMap.keySet());
        System.debug('Line 90----->'+permissions);
        if(permissions!=null && permissions.contains(LEASE) && !ccaMap.keySet().contains(LEASE)){
            CreditCheckRow ccr = new CreditCheckRow();
            ccr.creditCheckName = 'SunPower Lease';
            ccr.AppType=LEASE;
            ccr.Action='New';
            ccr.disabled=false;
            CreditCheckRows.add(ccr);
        }
        if(permissions!=null && permissions.contains(LOAN) && !ccaMap.keySet().contains(LOAN)){
            //if(!isNewHomes){
                CreditCheckRow ccr = new CreditCheckRow();
                ccr.creditCheckName = 'SunPower Loan';
                ccr.AppType=LOAN;
                ccr.Action='New';
                ccr.disabled=false;
                CreditCheckRows.add(ccr);
            //}    
        }
    }

    
    public void submitCreditCheck(){
        ccrMap.clear();
        for(CreditCheckRow ccr:CreditCheckRows){
            System.debug('ccr----->'+ccr);
            if(ccr.selected==true){
                ccrMap.put(ccr.AppType,ccr.Action);
                ccr.selected=false;
            }
            
        }
        if(!ccrMap.isEmpty()){
            insertCreditCheckRows();
            populateCreditCheckRows();
        }
        System.debug(permissions);
    }
    
    public void insertCreditCheckRows(){
        
        List<Credit_Check_Request__c> ccrInsertList = new List<Credit_Check_Request__c>();
        List<Credit_Check_Request__c> ccrUpdateList = new List<Credit_Check_Request__c>();
        String leaseAppId = null;
        
        if(permissions.contains(LOAN) && ccrMap.containsKey(LOAN) && ccrMap.get(LOAN)=='New'){
            String loanAppId = getLoanApplicationId();
            if(loanAppId!=null){
                mosiacSendCreditCheck(loanAppId);
                ccrInsertList.add(new Credit_Check_Request__c(Account__c = con.AccountId, Application_Type__c = LOAN, Application_Id__c = loanAppId, Contact__c = con.Id, Credit_Beureu__c ='Mosaic', First_Name__c = con.FirstName, Last_Name__c = con.LastName, Opportunity__c =oppId,Status__c ='Submitted',Email__c=con.Email, Credit_Check_Submission_Date__c =Date.today())); 
            } 
        }
        
        if(permissions.contains(LEASE) && ccrMap.containsKey(LEASE) && ccrMap.get(LEASE)=='New'){
            ccrInsertList.add(new Credit_Check_Request__c(Account__c = con.AccountId, Application_Type__c = LEASE, Contact__c = con.Id, Credit_Beureu__c ='LoanPath', First_Name__c = con.FirstName, Last_Name__c = con.LastName, Opportunity__c =oppId, Status__c ='Submitted',Email__c=con.Email, Credit_Check_Submission_Date__c =Date.today()));
            strActParam = 'ncr';
        }
        
        if(!ccrInsertList.isEmpty())
            insert ccrInsertList;
        
        for(Credit_Check_Request__c ccr:ccrInsertList){
            if(ccr.Application_Type__c == 'Lease'){
                leaseAppId=ccr.Id;
            }    
        }
        
        if(permissions.contains(LEASE) && ccrMap.containsKey(LEASE) && ccrMap.get(LEASE)=='Resend'){
            //if(!ccaMap.isEmpty() && ccaMap.containsKey(LEASE) && ccaMap.get(LEASE).Email_Counter__c != null && ccaMap.get(LEASE).Email_Counter__c != 0 && ccaMap.get(LEASE).Email_Counter__c <= 5 && (ccaMap.get(LEASE).Account__r.Owner.Contact.Account.Name != null && ccaMap.get(LEASE).Account__r.Owner.Contact.Account.Name.contains('New Homes'))){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The Selected Customer is part of the workflow and receiving emails every 48 hours. Manual Reminders have been restricted. Thank You'));
            //}else 
            if(!ccaMap.isEmpty() && ccaMap.containsKey(LEASE)){
                Credit_Check_Request__c ccrUpdate = new Credit_Check_Request__c(Id=ccaMap.get(LEASE).Id,Status__c='Resent');
                ccrUpdateList.add(ccrUpdate);
                leaseAppId=ccaMap.get(LEASE).Id;
                strActParam = '';
            }
        }
        
        if(permissions.contains(LOAN) && ccrMap.containsKey(LOAN) && ccrMap.get(LOAN)=='Resend'){
             if(!ccaMap.isEmpty() && ccaMap.containsKey(LOAN)){
                if(ccaMap.get(LOAN).Application_Id__c!=null){
                    mosiacSendCreditCheck(ccaMap.get(LOAN).Application_Id__c);
                    Credit_Check_Request__c ccrUpdate = new Credit_Check_Request__c(Id=ccaMap.get(LOAN).Id,Status__c='Resent');
                    ccrUpdateList.add(ccrUpdate);
                }
            }
        }
        
        if(leaseAppId!=null){
            User user = [SELECT id, country_domain__c, name FROM User WHERE id=:UserInfo.getUserId()];
            partnerUrl = 'https://' + 
                                (ApexPages.currentPage().getHeaders().get('Host') != null ? ApexPages.currentPage().getHeaders().get('Host') : 'login.salesforce.com') +
                                '/services/Soap/u/22.0/' + 
                                UserInfo.getOrganizationId();
            //future call to LoanPath
            CreditCheckUtil.SendCreditRequest_LoanPath(leaseAppId,partnerUrl,UserInfo.getSessionId(),strActParam,isNewHomes);
        }
        
        if(!ccrUpdateList.isEmpty())
            update ccrUpdateList;
        
        try {
            if(spExLogsList != null && !spExLogsList.isEmpty()) {
                SpectrumDebugUtility.generateDebugLog(spExlogsList);
            } 
        } catch(Exception e) {}
                
    }
    
    //Mosaic Create Opportunity and Send Credit Check calls
    public String getLoanApplicationId(){
        String loanApplicationId=null;
        MosaicJSONUtil.MosaicResponse mosResp = Mosaic_API_CallHandler.mosaic_Create_Opportunity(con);
        if(mosResp.opp==null && ! Mosaic_API_CallHandler.isUserCreated){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,String.valueOf(mosResp.responsebody)));
        }
        else if(mosResp.opp != null ){
            loanApplicationId=String.valueOf(mosResp.opp.Id);
            spExLogsList.add(MosaicIntegrationUtil.prepDebugLog(con.Id,'Mosaic Create Opportunity', mosResp.request, mosResp.response));
        }
        
        return loanApplicationId;
    }
    
    public void mosiacSendCreditCheck(String loanApplicationId){
        if(loanApplicationId!=null){
            MosaicJSONUtil.MosaicResponse mosResp = Mosaic_API_CallHandler.mosaic_Send_Credit_Application(loanApplicationId);
            spExLogsList.add(MosaicIntegrationUtil.prepDebugLog(con.Id,'Mosaic Send Credit Application', mosResp.request, mosResp.response));
        }
    }
    
    public PageReference backToContact(){
        PageReference pageRef = new PageReference('/'+con.Id);
        return pageRef;
    }
    
}