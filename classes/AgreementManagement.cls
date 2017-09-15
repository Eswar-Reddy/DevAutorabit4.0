/*
Modified Code -- Sunpower TPO Phase 1 -- 20/10/2013, to update Quote status with Agreement status
Modification:
22-may-2014 : Birlasoft : API Version Changed from 14.0 to 29.0
22-may-2014 : Birlasoft : Added createLeasePayment() method to Create Lease Payment Records For AU Accounts, when Agreement Status is changes to "Wating For Counter-Signature"
02-Jun-2014 : Birlasoft : Added Method to Update Installer Email on Agreement from Primary contact of Installer Account
03-Jun-2014 : Birlasoft : Updated the code to match with Production Copy & with new GPP changes.
20-jun-2014 : Birlasoft : Reduce number of lines in the createLeasePayment() & createLeaseScheduleSummary() methods.
01-jul-2014 : Birlasoft : Modify Code to populate Contact of Leasepayment from PrimaryContact of Quote
*/

public class AgreementManagement 
{
    
    private static Id leaseContractRecTypeId = SFDCSpecialUtilities.getRecordTypeIdsByDeveloperName(echosign_dev1__SIGN_Agreement__c.SobjectType).get('Lease_Contract');
    public static Boolean executeMethod=true;
    public static Boolean isCustomerUpdated = false;
    public static void afterAgreementInsert (List<echosign_dev1__SIGN_Agreement__c> agreementList)
    {
        updateAgreementContract(agreementList);  
              
    }
    public static void afterAgreementUpdate (List<echosign_dev1__SIGN_Agreement__c> agreementList, 
                                             List<echosign_dev1__SIGN_Agreement__c> oldAgreementList)
    {
        updateAgreementContract(agreementList);
        
        //Call updateAccountIsCustomerandCustomerType Method
        if(!isCustomerUpdated)
            updateAccountIsCustomerandCustomerType(agreementList);
    }
    
    
    
    private static void updateAgreementContract(List<echosign_dev1__SIGN_Agreement__c> agreeList)
    {
        List<Contract> conts = new List<Contract>();
        List<Id> contractIds = new List<Id>();
        //New Code -- Sunpower TPO Phase 1 -- 20/10/2013
        List<Quote> quotes = new List<Quote>();
        List<Id> quoteIds = new List<Id>();
        system.Debug('***********AgreeManage1'+agreeList);
        //End New Code -- Sunpower TPO Phase 1 -- 20/10/2013
        
        for(echosign_dev1__SIGN_Agreement__c agree:agreeList){    
            
            if(agree.echosign_dev1__Contract__c!=null){
                contractIds.add(agree.echosign_dev1__Contract__c);
            }
            
            /*CRYSTAL - commented per Sangita Approval 11/3/2015
            //New Code -- Sunpower TPO Phase 1 -- 20/10/2013
            if(agree.Quote__c!=null){
            quoteIds.add(agree.Quote__c);
            }
            system.Debug('***********AgreeManage2'+quoteIds);
            //New Code -- Sunpower TPO Phase 1 -- 20/10/2013
            */
        }
        
        Map<Id,Contract> contractMap = new Map<Id,Contract>(); 
        if(!contractIds.isEmpty())
            contractMap = new Map<Id, Contract>([select Id, Status, Sent_Date__c, Signed_Date__c, Viewed_Date__c from Contract where Id in :contractIds]);
        //New Code -- Sunpower TPO Phase 1 -- 20/10/2013
        //CRYSTAL - commented per Sangita approval 11/3/2015
        //Map<Id,Quote> QuoteMap = new Map<Id,Quote>([select ID, Agreement_Status__c,Account__r.BillingCountry from Quote where ID in :quoteIds and Account__r.BillingCountry = 'France']);
        
        //End New Code -- Sunpower TPO Phase 1 -- 20/10/2013 
        for(echosign_dev1__SIGN_Agreement__c agree:agreeList){    
            //New Code -- Sunpower TPO Phase 1 -- 20/10/2013
            /*if (QuoteMap.containsKey(agree.Quote__c) )
            {            
                Quote qt = QuoteMap.get(agree.Quote__c);
                
                qt.Agreement_Status__c = agree.echosign_dev1__Status__c;
                system.Debug('***********AgreeManage4'+qt);   
                quotes.Add(qt);
            }*/
            //End New Code -- Sunpower TPO Phase 1 -- 20/10/2013         
            if(agree.echosign_dev1__Contract__c==null){
                continue;
            }
            if (contractMap.containsKey(agree.echosign_dev1__Contract__c)){
                
                Contract cont = contractMap.get(agree.echosign_dev1__Contract__c);
                
                if (cont.Status!='Activated'){
                    
                    if(agree.echosign_dev1__Status__c=='Draft')
                        cont.Status = 'New';
                    else                
                        cont.Status = agree.echosign_dev1__Status__c;
                    
                    cont.Sent_Date__c = agree.echosign_dev1__DateSentDate__c;   
                    cont.Signed_Date__c = agree.echosign_dev1__DateSignedDate__c;
                    cont.Viewed_Date__c = agree.echosign_dev1__DateViewedDate__c;                   
                    conts.Add(cont);
                }
            }
        }        
        if (conts.size()>0)
            update conts;
        //New Code -- Sunpower TPO Phase 1 -- 20/10/2013
        if (quotes.size()>0)
            update quotes;
        //End New Code -- Sunpower TPO Phase 1 -- 20/10/2013
    }
    
    //Creates LeasePayment when Agreement Status is Waiting for Counter-Signature for Australia      
    Public static void createLeasePayment(Map<ID,echosign_dev1__SIGN_Agreement__c> mapQIDVsAg)
    {
        List<ID> AccIds=new List<ID>();
        //Map<ID,String> mapQIDvsCon=new Map<ID,String>();
        Map<ID,Quote> mapQuote=new Map<ID,Quote>();
        for(Quote q:[Select Id, Opportunity.AccountId, Opportunity.Account.Name, 
                     OpportunityID, Opportunity.Account.Partner_Account__c,
                     Temp_contact_1__c,PrimaryContact__c,
                     Opportunity.Account.Partner_Account__r.Country_Domain__c ,
                     Account_Billing_Country__c, contactID, Installer__c, Installer__r.Parent.Id,
                     Account__c,Account__r.OwnerId, currencyisocode
                     from Quote where Id IN : mapQIDVsAg.keySet() and (Account_Billing_Country__c='Australia' or Account_Billing_Country__c='australia')                      
                    ])
        {
            mapQuote.put(q.id,q);
        } 
        System.debug('$$$ mapQuote '+((!mapquote.isEmpty())?mapquote.size():null));
        createSharingWithInstaller(mapQuote);
        for(Quote q:mapQuote.values())
        {
            if(q.Account_Billing_Country__c=='Australia')
            {
                AccIds.add(q.Opportunity.AccountId);             
                //mapQIDvsCon.put(q.ID,q.Opportunity.Account.Partner_Account__r.Country_Domain__c.right(2));
            }
        }
        //if(!AccIds.isEmpty() && !mapQIDvsCon.isEmpty())
        System.debug('AAA AccIDs '+AccIds.size());//+' AU Country '+mapQIDvsCon.size());
        Map<Id,LeasePayment__c> mapLeasePmt = new Map<Id,LeasePayment__c>([SELECT id, name, Status__c, Quote__c,Opportunity__c,Account__c,Account__r.Multiple_Meters__c FROM LeasePayment__c WHERE Account__c=:AccIds]);
        List<LeasePayment__c> lstLP=new List<LeasePayment__c>();
        boolean bStatus = false;
        boolean multMetrs = false;
        Set<ID> setAccIds = new Set<ID>();
        Set<String> setLPStatus = new Set<String>();
        Map<Id,Id> mapLP_IdvsLP_Quo = new Map<Id,Id>();
        Map<Id,Id> mapLP_IdvsLP_Opp = new Map<Id,Id>();
        
        if(mapLeasePmt.isEmpty()) // Create LP if there are no existing lease Payments for the Account
        {
            for(Quote q:mapQuote.values())
            {
                if(q.Account_Billing_Country__c == 'Australia')
                {
                    lstLP.add(new LeasePayment__c(Name=q.Opportunity.Account.Name, 
                                                  Agreement__c=mapQIDVsAg.get(q.ID).ID,
                                                  Quote__c= q.ID,
                                                  Opportunity__c= q.OpportunityID,
                                                  Account__c= q.Opportunity.AccountId,
                                                  Partner_Account__c= q.Opportunity.Account.Partner_Account__c,
                                                  End_Customer_Account__c= q.Opportunity.AccountId,
                                                  Contact__c= q.PrimaryContact__c,
                                                  currencyisocode = q.currencyisocode,
                                                  recordtypeid = Label.LeasePaymentRecordTypeID_AU,
                                                  Date_Lease_Document_signed__c = Date.Today() 
                                                 ));  
                }             
            }//End for 
        }
        else
        {
            for(Id LId : mapLeasePmt.keySet())
            {
                setAccIds.add(mapLeasePmt.get(LId).Account__c);
                mapLP_IdvsLP_Quo.put(mapLeasePmt.get(LId).Account__c,mapLeasePmt.get(LId).Quote__c);
                mapLP_IdvsLP_Opp.put(mapLeasePmt.get(LId).Account__c,mapLeasePmt.get(LId).Opportunity__c);
                System.debug('# status '+mapLeasePmt.get(LId).Status__c);
                if(mapLeasePmt.get(LId).Status__c == null)
                    bStatus = true;
                else
                    setLPStatus.add(mapLeasePmt.get(LId).Status__c);// updated by Rashmi on 20/09/2012 to allow duplicate LP when the earlier LP is not active.
                if(mapLeasePmt.get(LId).Account__r.Multiple_Meters__c == true)
                    multMetrs = true;
            }
            for(Quote q : mapQuote.values())
            {
                if(setAccIds.contains(q.Opportunity.AccountId) && ((mapLP_IdvsLP_Quo.get(q.Opportunity.AccountId)!=null && q.ID != mapLP_IdvsLP_Quo.get(q.Opportunity.AccountId) && multMetrs) || (mapLP_IdvsLP_Quo.get(q.Opportunity.AccountId)!=null && q.ID != mapLP_IdvsLP_Quo.get(q.Opportunity.AccountId) &&(setLPStatus.contains('Transferred') ||setLPStatus.contains('Terminated') || setLPStatus.contains('Cancelled') || setLPStatus.contains('Cancellation with RMA') || setLPStatus.contains('Expired') || setLPStatus.contains('Duplicate'))&& !(setLPStatus.contains('Active') ||setLPStatus.contains('Pending Cancellation') || bStatus)))) //Checking for Duplication
                {
                    if(q.Account_Billing_Country__c != null && q.Account_Billing_Country__c == 'Australia')
                    {
                        lstLP.add(new LeasePayment__c(Name=q.Opportunity.Account.Name,
                                                      Agreement__c=mapQIDVsAg.get(q.ID).ID,       
                                                      Quote__c= q.ID,
                                                      Opportunity__c= q.OpportunityID,
                                                      Account__c= q.Opportunity.AccountId,
                                                      Partner_Account__c= q.Opportunity.Account.Partner_Account__c,
                                                      End_Customer_Account__c= q.Opportunity.AccountId,
                                                      Contact__c= q.PrimaryContact__c,
                                                      currencyisocode = q.currencyisocode,
                                                      recordtypeid = Label.LeasePaymentRecordTypeID_AU,
                                                      Date_Lease_Document_signed__c = Date.Today() 
                                                     ));
                    }
                }                       
            }//End for 
        }     
        System.debug('$$$ LeasePayment To be Inserted '+lstLP.size());
        if(!lstLP.isEmpty()) 
            Insert lstLP;
    }//End of Method createLeasePayment
    
    //Called when Agreement Status is updated to Waiting for Counter-Signature and will create LeaseScheduleSummary if Lease Schedule exists for Australia Only.
    Public static void createLeaseScheduleSummary(Set<Id> lstQuote)
    {
        List<LeasePayment__c> lstLPs=[Select Id,Create_Lease_Summary__c,Date_Lease_Document_signed__c from LeasePayment__c where Quote__c=:lstQuote and Site_Country__c='Australia'];
        for(LeasePayment__c lp:lstLPs)
        {
            if(lp.Date_Lease_Document_signed__c==null)
                lp.Date_Lease_Document_signed__c=Date.Today();    lp.Date_Lease_Document_signed__c=lp.Date_Lease_Document_signed__c-1;    lp.Create_Lease_Summary__c=false;
        }
        update lstLPs;
        
        for(LeasePayment__c lp:lstLPs)
        {
            lp.Date_Lease_Document_signed__c=lp.Date_Lease_Document_signed__c+1;    lp.Create_Lease_Summary__c=true;
        }
        update lstLPs;
    }  //End of Method createLeaseScheduleSummary
    
    /*
Sangita added
*/
    
    Public static void createSharingWithInstaller(Map<Id,quote> mapQuote)
    {
        //Create sharing with the installer account in case of self installer or parent account in the case of Service stream type scenario where 
        //contact from the parent should be able to see records
        
        set<id> setInstallerid = new set<id>();
        
        Map<ID,set<ID>> mapAccountInstaller = new Map<ID,set<ID>>();
        Map<ID,set<ID>> mapOppInstaller = new Map<ID,set<ID>>();
        
        set<id> setAccountShareid = new set<id>();
        set<id> setOpportunityShareid = new set<id>();
        for(Quote objQuote : mapQuote.values()){
            //not selft installer
            if(objQuote.Account__c != objQuote.Installer__c){
                
                ID installerID = null;
                if(objQuote.inStaller__r.Parent != null)
                    installerID = objQuote.inStaller__r.Parent.id;
                else
                    installerID = objQuote.Installer__c;
                
                setInstallerid.add(installerID);
                if(objQuote.Account__c!= null){ 
                    setAccountShareid.add(objQuote.Account__c);
                    if(mapAccountInstaller.containsKey(installerID))
                    {
                        set<ID> setID = mapAccountInstaller.get(installerID);
                        setID.add(objQuote.Account__c);
                        mapAccountInstaller.put(installerID,setID);
                    }else
                        mapAccountInstaller.put(installerID,new set<id>{objQuote.Account__c});
                }
                if(objQuote.OpportunityId!= null){
                    setOpportunityShareid.add(objQuote.OpportunityId);
                    if(mapOppInstaller.containsKey(installerID))
                    {
                        set<ID> setID = mapOppInstaller.get(installerID);
                        setID.add(objQuote.OpportunityId);
                        mapOppInstaller.put(installerID,setID);
                    }else
                        mapOppInstaller.put(installerID,new set<id>{objQuote.OpportunityId});
                }   
            }
        }
        //map<ID,Account> mapAccount = new map<ID,Account>([Select id,(Select id from Contacts) from Account where id IN: setAccountShareid]);
        
        
        
        map<ID,set<ID>> mapAccountIDGroup = new map<ID,set<ID>>();
        Map<ID,UserRole> mapUserRole = new Map<ID,UserRole>([SELECT PortalAccountId,name,id FROM UserRole where PortalAccountId IN :setInstallerid and name like '%Partner User%']);
        //Map<ID,User> mapUser =new Map<ID,User>([Select id,UserRoleID from User where UserRoleID IN : mapUserRole.keySet()]);
        Map<ID,Group>  mapGroup = new Map<ID,Group>([Select g.Id,g.RelatedId From Group g where g.Type='Role' and g.RelatedId= :mapUserRole.keySet()]);
        
        map<ID,list<AccountShare>> mapAccountShare = new map<ID,list<AccountShare>>();
        
        for(AccountShare objAccountShare : [Select id,accountID,UserorGroupID,AccountAccessLevel from AccountShare where accountID IN:setAccountShareid and UserorGroupID IN:mapGroup.keySet()]){
            if(mapAccountShare.containsKey(objAccountShare.accountID))
            {
                list<AccountShare> listAccountShare = mapAccountShare.get(objAccountShare.accountID);
                listAccountShare.add(objAccountShare);
                mapAccountShare.put(objAccountShare.accountID,listAccountShare);
            }else
                mapAccountShare.put(objAccountShare.accountID,new list<AccountShare>{objAccountShare});
        }
        
        map<ID,list<OpportunityShare>> mapOpportunityShare = new map<ID,list<OpportunityShare>>();
        
        for(OpportunityShare objOpportunityShare : [Select id,OpportunityId,UserorGroupID,OpportunityAccessLevel from OpportunityShare where OpportunityId IN:setOpportunityShareid and UserorGroupID IN:mapGroup.keySet()]){
            if(mapOpportunityShare.containsKey(objOpportunityShare.OpportunityId))
            {
                list<OpportunityShare> listOpportunityShare = mapOpportunityShare.get(objOpportunityShare.OpportunityId);
                listOpportunityShare.add(objOpportunityShare);
                mapOpportunityShare.put(objOpportunityShare.OpportunityId,listOpportunityShare);
            }else
                mapOpportunityShare.put(objOpportunityShare.OpportunityId,new list<OpportunityShare>{objOpportunityShare});
        }
        
        for(UserRole objUserRole : mapUserRole.values()){
            for(Group objGroup: mapGroup.values()){
                if(objGroup.RelatedId == objUserRole.Id){
                    if(mapAccountIDGroup.containsKey(objuserRole.PortalAccountId))
                    {
                        set<ID> setID = mapAccountIDGroup.get(objuserRole.PortalAccountId);
                        setID.add(objGroup.Id);
                        mapAccountIDGroup.put(objuserRole.PortalAccountId,setID);
                    }else
                        mapAccountIDGroup.put(objuserRole.PortalAccountId,new set<id>{objGroup.Id});
                }
            }
        }
        System.debug('--------------+mapAccountIDGroup'+mapAccountIDGroup);
        System.debug('--------------+mapAccountInstaller'+mapAccountInstaller);
        List<AccountShare> listAccountShare = new List<AccountShare>();
        List<ContactShare> listContactShare = new List<ContactShare>();
        List<OpportunityShare> listOpportunityShare = new List<OpportunityShare>();
        for(ID idInstaller: mapAccountInstaller.keySet()){
            if(!mapAccountInstaller.isEmpty() && mapAccountInstaller.containsKey(idInstaller)){
                for(ID idAccount : mapAccountInstaller.get(idInstaller)){
                    if(!mapAccountIDGroup.isEmpty() && mapAccountIDGroup.containsKey(idInstaller)){
                        for(ID idGrup : mapAccountIDGroup.get(idInstaller)){
                            boolean isExstingAccountShare = false;
                            if(!mapAccountShare.isEmpty() && mapAccountShare.containsKey(idAccount)){
                                for(AccountShare objAccountShare : mapAccountShare.get(idAccount)){
                                    if(!isExstingAccountShare && objAccountShare.accountID == idAccount 
                                       && objAccountShare.UserorGroupID == idGrup
                                       && objAccountShare.AccountAccessLevel == 'Read'){
                                           isExstingAccountShare = true;
                                       }
                                }
                                System.debug('----------------------------isExstingAccountShare'+isExstingAccountShare);
                                
                            }
                            System.debug('----------------------------isExstingAccountShare'+isExstingAccountShare);
                            if(!isExstingAccountShare){
                                AccountShare accountShare =  new AccountShare();
                                accountShare.accountID= idAccount;
                                accountShare.AccountAccessLevel ='Read';
                                accountShare.opportunityAccessLevel ='None';
                                accountShare.UserorGroupID =idGrup;
                                listAccountShare.add(accountShare);
                            }
                        }
                    }
                    
                }
            }
            
            
            if(!mapOppInstaller.isEmpty() && mapOppInstaller.containsKey(idInstaller)){
                for(ID idOpp : mapOppInstaller.get(idInstaller)){
                    if(!mapAccountIDGroup.isEmpty() && mapAccountIDGroup.containsKey(idInstaller)){
                        for(ID idGroup : mapAccountIDGroup.get(idInstaller)){
                            boolean isExstingOppShare = false;
                            if(!mapOpportunityShare.isEmpty() && mapOpportunityShare.containsKey(idOpp)){
                                for(OpportunityShare objOpportunityShare : mapOpportunityShare.get(idOpp)){
                                    if(!isExstingOppShare && objOpportunityShare.OpportunityId == idOpp 
                                       && objOpportunityShare.UserorGroupID == idGroup
                                       && objOpportunityShare.OpportunityAccessLevel == 'Read'){
                                           isExstingOppShare = true;
                                       }
                                }
                                System.debug('----------------------------isExstingOppShare'+isExstingOppShare);
                                
                            }
                            System.debug('----------------------------isExstingOppShare'+isExstingOppShare);
                            if(!isExstingOppShare){
                                OpportunityShare opportunityShare =  new OpportunityShare();
                                opportunityShare.OpportunityId= idOpp;
                                opportunityShare.OpportunityAccessLevel ='Read';
                                opportunityShare.UserorGroupID =idGroup;
                                listOpportunityShare.add(opportunityShare);
                            }
                        }
                    }
                }
            }
            
            
            
        }
        System.debug('------------------------listAccountShare'+listAccountShare);
        if(!listAccountShare.isEmpty())
            insert listAccountShare;
        System.debug('------------------------listOpportunityShare'+listOpportunityShare);
        if(!listOpportunityShare.isEmpty())
            insert listOpportunityShare;
        /*
if(!listContactShare.isEmpty())
insert listContactShare;*/
        
        
        
        
        
    }//end method
    
    //Added By Birlasoft: 2-Jun-2014 : Method to Update Installer Email on Agreement from Primary contact of Installer Account
    ////This method can be eliminated, was part of UpdateInstallerEmail trigger, marked for removal per Sangita recommendation 10/2015
    Public static void UpdateInstallerEmail(List<echosign_dev1__SIGN_Agreement__c> lstAgs)     
    {
        List<ID> qIds=new List<ID>();
        Map<ID,String> mapIDvsEmail=new Map<ID,String>();
        Map<ID,ID> mapInstIDvsQID=new Map<ID,ID>();
        if(executeMethod)
        {
            for(echosign_dev1__SIGN_Agreement__c ag:lstAgs)
            {
                qids.add(ag.Quote__c);
            }
            for(Quote qt:[Select ID, Installer__C, Installer__r.Name,Installer__r.ParentID from Quote where ID=:qids AND Installer__c!=null ])
            {
                if(qt.Installer__r.ParentID!=null)
                    mapInstIDvsQID.put(qt.Installer__r.ParentID,qt.ID);
                else
                    mapInstIDvsQID.put(qt.Installer__c,qt.ID);
            }
            for(Account acc:[Select Id, (Select Id,Primary__c,Email from Contacts) from Account where ID in :mapInstIDvsQID.keySet()])
            {
                for(Contact con: acc.Contacts)
                {
                    if(con.Primary__c)
                        mapIDvsEmail.put(mapInstIDvsQID.get(acc.ID),con.Email);
                }
            }
            for(echosign_dev1__SIGN_Agreement__c ag:lstAgs)
            {
                ag.Installer_Email__c=(!mapIDvsEmail.isEmpty() && mapIDvsEmail.containsKey(ag.Quote__c))?mapIDvsEmail.get(ag.Quote__c):null;
            }
        } 
        executeMethod = false;
    }// Method UpdateInstallerEmail End
    
    
    //Method to update isCustomer flag and Customer Type as Lease when Agreement Status becomes 'Signed'
    public static void updateAccountIsCustomerandCustomerType(List<echosign_dev1__SIGN_Agreement__c> agrmntList){
        
        Set<Id> accountIdSet = new Set<Id>();
        List<Account> acctList = new List<Account>();
        List<Account> acctUpdateList = new List<Account>();
        for(echosign_dev1__SIGN_Agreement__c agrmnt:agrmntList){
            if(agrmnt.Account__c!=null && agrmnt.echosign_dev1__Status__c=='Signed')
                accountIdSet.add(agrmnt.Account__c);
        }
        
        if(!accountIdSet.isEmpty())
            acctList = [select Id,DSE_IsCustomer__c,DSE_CustomerType__c FROM Account where Id in :accountIdSet];
        
        isCustomerUpdated = true;
        
        for(Account acc:acctList){
            if(acc.DSE_IsCustomer__c!=true){
                acc.DSE_IsCustomer__c=true;
                acc.DSE_CustomerType__c='Lease';
                acc.DSE__DS_Synchronize__c=true;
                acctUpdateList.add(acc);
            }
        }
        
        if(!acctUpdateList.isEmpty()){
            update acctUpdateList;
        }
    }
    
    public static void updateDocumnet(list<echosign_dev1__SIGN_Agreement__c> listechosigndevSIGNAgreement){
        map<ID,echosign_dev1__SIGN_Agreement__c> mapAgreement = new map<ID,echosign_dev1__SIGN_Agreement__c>();
        //CRYSTAL - UPDATED TO LOWER SOQL COUNT
        //Recordtype objrecordtype = [Select id from Recordtype where Name='Lease Contract' and SobjectType='echosign_dev1__SIGN_Agreement__c' limit 1];
        
        for(echosign_dev1__SIGN_Agreement__c objAgreement : listechosigndevSIGNAgreement){
            //if(objAgreement.Opportunity__c != null && objAgreement.recordtypeid == objrecordtype.id)
            if(objAgreement.Opportunity__c != null && objAgreement.recordtypeid == leaseContractRecTypeId)
                mapAgreement.put(objAgreement.Opportunity__c , objAgreement);
        }
        
        if(mapAgreement.isEmpty()) return;
        
        list<TPSSF__Document__c> listDocument = new list<TPSSF__Document__c>();
        for(TPSSF__Document__c objDocument: [Select id,Opportunity__c from TPSSF__Document__c where Opportunity__c IN : mapAgreement.keySet()]){
            objDocument.Agreement_Status__c = mapAgreement.get(objDocument.Opportunity__c).echosign_dev1__Status__c;
            listDocument.add(objDocument);
        }
        if(!listDocument.isEmpty())
            update listDocument;
    }
    public static void updateDocumnetDeletedAgreement(list<echosign_dev1__SIGN_Agreement__c> listechosigndevSIGNAgreement){
        set<ID> setOpportunityID = new set<ID>();
        //CRYSTAL - UPDATED TO LOWER SOQL COUNT
        //Recordtype objrecordtype = [Select id from Recordtype where Name='Lease Contract' and SobjectType='echosign_dev1__SIGN_Agreement__c' limit 1];
        for(echosign_dev1__SIGN_Agreement__c objAgreement : listechosigndevSIGNAgreement){
            //if(objAgreement.Opportunity__c != null && objAgreement.recordtypeid == objrecordtype.id)
            if(objAgreement.Opportunity__c != null && objAgreement.RecordTypeId == leaseContractRecTypeId)
                setOpportunityID.add(objAgreement.Opportunity__c);
        }
        list<TPSSF__Document__c> listDocument = new list<TPSSF__Document__c>();
        for(TPSSF__Document__c objDocument: [Select id,Opportunity__c from TPSSF__Document__c where Opportunity__c IN : setOpportunityID]){
            objDocument.Agreement_Status__c = 'Deleted';
            listDocument.add(objDocument);
        }
        if(!listDocument.isEmpty())
            update listDocument;
        
    }
    
    
    
}