/*========================================================================================================================================================
Date                Last Modified By                Comment         
========================================================================================================================================================
3-24-2015             Niket C                         Class contains methods for ALR custom Setting. 
*/
public with sharing class ALRConfiguration{
    
    public static DealerGeneral__c DEALERGENERAL = DealerGeneral__c.getInstance(UserInfo.getOrganizationId());
    public static String SUNPOWER = system.label.ALR_Lead_SunPower;
    public static String VALIDCOUNTRIES = system.label.ALR_Lead_VALIDCOUNTRIES;
    public static String CAMPAIGNPARTNERS = 'Campaign Partners';
    public static String ALLIANCEPARTNERS = 'Alliance Partners';
    public static String MASTERDEALERS = 'Master Dealers';
    public static Five9WebserviceCalloutSettings__c FIVE9WEBSERVICE = Five9WebserviceCalloutSettings__c.getInstance(system.label.ALR_Five9);
    public static List<Five9CampaignDelaySettings__c> allFive9SettingValues=new List<Five9CampaignDelaySettings__c>();
    public static Map<String,Five9CampaignDelaySettings__c> mapResponse=new Map<String,Five9CampaignDelaySettings__c>();//To store Campaign Id and its corresponding delay
    
    public static final String AUTHORIZED_PARTNER_COMBO = 'Authorized-Partner-Combo';
    public static final String AUTHORIZED_PARTNER_RESIDENTIAL = 'Authorized-Partner-Residential';
    public static final String PREMIER_PARTNER_COMBO = 'Premier-Partner-Combo';
    public static final String PREMIER_PARTNER_RESIDENTIAL = 'Premier-Partner-Residential';
    public static final String ELITE_PARTNER_COMBO = 'Elite-Partner-Combo';
    public static final String ELITE_PARTNER_RESIDENTIAL = 'Elite-Partner-Residential';
    public static final String MASTER_PARTNER_RESIDENTIAL = 'Master-Partner-Residential';
    public static final String MASTER_PARTNER_COMBO = 'Master-Partner-Combo';
    /*
Function     : isALREnabled
Parameter    : 
Returen Type : DealerGeneral__c
Summary      : checks the ALR flag from custom setting.
*/
    public static boolean isALREnabled(){
        try{
            if (Test.isRunningTest() == true) return true;
            return DEALERGENERAL.Enable_ALR_Process__c;
        }Catch(Exception ex){
            return false;
        }
    }
    
    /*
Function     : getDealerGeneral
Parameter    : 
Returen Type : DealerGeneral__c
Summary      : returns DealerGeneral__c custom setting instance
*/
    public static DealerGeneral__c getDealerGeneral(){
        return DEALERGENERAL;
    }
    
    /*
Function     : isLeadValidforALR
Parameter    : LeadDealerUtility.LeadInfo
Returen Type : LeadDealerUtility.LeadInfo 
Summary      : Function validate the Lead information is valid for ALR (Automated Lead Routing) or not 
If No its update the lead information as false and update the Dealer Assignment Status
*/
    public static list<LeadAssignmentWrapper> isLeadValidforALR(list<LeadAssignmentWrapper> lstLeadInfo){
        
        if(lstLeadInfo == null || lstLeadInfo.isEmpty()) return lstLeadInfo;
        
        else{
            
            for(LeadAssignmentWrapper objLeadInfo : lstLeadInfo)
            {
                if(objLeadInfo.lead.FirstName == DEALERGENERAL.Lead_Test_First_Name__c) continue;
                
                //CHECK LEAD MANUFACTURE VALUE IS NOT SUNPOWER 
                if( objLeadInfo.lead.Lead_Manufacturer__c == null 
                   || !String.valueOf(objLeadInfo.lead.Lead_Manufacturer__c).equalsIgnoreCase(SUNPOWER))
                {
                    objLeadInfo.lead.Dealer_Assignment_Status__c = '';
                    objLeadInfo.isValid = false;
                }
                
                //MUST BE FOR A SPECIFIC COUNTRY
                else if(objLeadInfo.lead.Theater__c == null 
                        || !VALIDCOUNTRIES.contains(objLeadInfo.lead.Theater__c))
                {
                    objLeadInfo.lead.Dealer_Assignment_Status__c = 'Theater not valid';
                    objLeadInfo.isValid = false;
                }
                
                // Check Geolocation__Latitude values checking all custom and standard fields
                else if( objLeadInfo.lead.Longitude__c == null &&  objLeadInfo.lead.Latitude__c == null
                        && objLeadInfo.lead.Longitude == null &&  objLeadInfo.lead.Latitude == null)
                {
                    objLeadInfo.lead.Dealer_Assignment_Status__c = 'Failed Assignment - Invalid Geolocation';
                    objLeadInfo.isValid = false;
                }
            }
        }
        return lstLeadInfo;
    }
    
    /*
Function     : SendEmailAlert
Parameter    : String theSubject, String theBody
Returen Type : Messaging.SingleEmailMessage
Summary      : Function send and email ALR team if any exception occures 
*/
    public static Messaging.SingleEmailMessage SendEmailAlert(String theSubject, String theBody) 
    {
        DealerGeneral__c c = DealerGeneral__c.getInstance();
        
        List<String> toList = new List<String>();
        toList.add(c.Email_Address_For_ALR_Alerts__c);
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();     
        mail.setSaveAsActivity(false);            
        mail.setToAddresses(toList);  
        mail.setSenderDisplayName('SunPower');
        mail.setReplyTo('noreply@SunPowerCorp.com');
        mail.setSubject(theSubject); 
        mail.setPlainTextBody(theBody);
        
        return mail;
        
        
    }
    /*
Function     : getRandomNumber
Parameter    : Integer size
Returen Type : Integer
Summary      : retrurns the RandomNumber
*/
    public static Integer getRandomNumber(Integer size){
        Integer sz = size + 1;
        Double d = math.random() * sz;
        return d.intValue();
    }
    
    public static String auditUpdate(String audit) {
        String result = audit;
        result += '\r\n';
        return result;
    }
    
    public static List<DealerResult> buildNewHomesDealerList(Map<Id, Account> dealerMap, LeadAssignmentWrapper objLead, String foundCampaignId, List<Campaign_Partner__c> campPartners) {
        List <DealerResult> result = new List <DealerResult>();
        
        //for(Account dealer : dealerMap.values()){
        for(Campaign_Partner__c cp : campPartners) {
            
            // check the signed agreements and set flag to true, and exit the loop if one is found
            if(dealerMap.containsKey(cp.Partner__c)) {
                Account dealer = new Account();
                dealer = dealerMap.get(cp.Partner__c);
                
                DealerResult r = new DealerResult(
                    dealer.Id, 
                    dealer.Name,                    
                    dealer.Type, 
                    null, 
                    null, 
                    null,
                    dealer.Dealer_Score_Total__c,
                    dealer.Dealer_Locator_Phone__c, 
                    dealer.Phone, 
                    dealer.BillingStreet, 
                    dealer.BillingCity, 
                    dealer.BillingState, 
                    dealer.BillingCountry, 
                    dealer.BillingPostalCode, 
                    dealer.Website, 
                    dealer.Oracle_Account_Number__c, 
                    dealer.Description, 
                    dealer.Partner_Facts__c,
                    dealer.Alliance_Program_Partner__c,
                    dealer.Opportunity_Recipient__c,
                    dealer.Dealer_Locator_Opt_Out__c,
                    dealer.Lead_Flow_Opt_Out__c 
                );
                r.isCampaignPartner = true;
                r.isAllianceCampaignPartner = false;
                r.AccountDisplayName = dealer.Account_Display_Name__c;
                r.PartnerLogo  = dealer.Partner_Logo__c;
                
                result.add(r);
            }
        }
        
        result.sort();
        return result;  
    }
    
    public static List <DealerResult> buildCoreDealerList(Map <Id, Account> dealerMap, 
                                                          LeadAssignmentWrapper objLead, 
                                                          DealerGeneral__c c, 
                                                          String foundCampaignId, 
                                                          String dealerPriority, 
                                                          Boolean useDealerMin, 
                                                          Boolean useDealerMax, 
                                                          Boolean omitFinancePartners){
                                                              
                                                              List <DealerResult> result = new List <DealerResult>();
                                                              Set <Id> dealersAlreadyIncluded = new Set <Id>();
                                                              
                                                              objLead.lead.ALR_Assignment_Audit_Trail__c += auditUpdate('dealerPriority: ' + dealerPriority);
                                                              for(Account dealer : dealerMap.values()){
                                                                  Boolean isCampaignPartner = FALSE;
                                                                  Boolean isAllianceCampaignPartner = FALSE;
                                                                  Boolean signedAgreement = FALSE;
                                                                  Boolean hasValidCoverageAreas = FALSE;
                                                                  Boolean isRegistered = FALSE;
                                                                  Boolean isPriorityDealer = FALSE;
                                                                  Boolean isFinancePartner = TRUE; // By default, this is set to TRUE
                                                                  Boolean isWarmTransferPartner = FALSE;
                                                                  
                                                                  useDealerMin = (useDealerMin == NULL) ? FALSE : useDealerMin;
                                                                  useDealerMax = (useDealerMax == NULL) ? FALSE : useDealerMax;
                                                                  
                                                                  if(dealerPriority == NULL || dealerPriority == '' || dealerPriority == dealer.Priority_Assignment__c)
                                                                      isPriorityDealer = TRUE;
                                                                  
                                                                  //CRYSTAL ADDED 11/4/2015
                                                                  else if(dealerPriority != null && dealerPriority.equalsIgnoreCase('Master')) {
                                                                      if(dealer.Dealer_Tier__c != null && dealer.Dealer_Tier__c.equalsIgnoreCase('Master'))
                                                                          isPriorityDealer = TRUE;
                                                                  }
                                                                  // remove them from the prioritized list if they already hit their minimum
                                                                  if(isPriorityDealer && useDealerMin){
                                                                      
                                                                      Decimal dealerAssignmentCount = 0;
                                                                      if(dealer.Last_Assigned_Date__c == system.today() && dealer.Lead_Assignment_Count__c != NULL) dealerAssignmentCount = dealer.Lead_Assignment_Count__c;
                                                                      
                                                                      if(dealer.Lead_Priority_Minimum__c == NULL || dealerAssignmentCount >= dealer.Lead_Priority_Minimum__c) isPriorityDealer = FALSE;
                                                                  }
                                                                  
                                                                  // remove them from the prioritized list if they already hit their maximum
                                                                  if(isPriorityDealer && useDealerMax){
                                                                      Decimal dealerAssignmentCount = 0;
                                                                      if(dealer.Last_Assigned_Date__c == system.today() && dealer.Lead_Assignment_Count__c != NULL) dealerAssignmentCount = dealer.Lead_Assignment_Count__c;
                                                                      
                                                                      if(dealer.Lead_Priority_Maximum__c == NULL || dealerAssignmentCount >= dealer.Lead_Priority_Maximum__c) isPriorityDealer = FALSE;
                                                                  }
                                                                  
                                                                  if(isPriorityDealer){
                                                                      for(Campaign_Partner__c cp : dealer.Campaign_Partners__r){
                                                                          if(foundCampaignId == NULL || (cp.Enabled__c && cp.Campaign__c == foundCampaignId)){
                                                                              isCampaignPartner = TRUE;
                                                                              isAllianceCampaignPartner = (cp.Campaign__r.Type == 'Alliance');
                                                                              isWarmTransferPartner = (cp.Partner_Type__c == 'Warm Transfer');
                                                                          }
                                                                      }
                                                                      
                                                                      // check the signed agreements and set flag to true, and exit the loop if one is found
                                                                      for(echosign_dev1__SIGN_Agreement__c agreement : dealer.Agreements__r){
                                                                          signedAgreement = TRUE;
                                                                          break;
                                                                      }
                                                                      
                                                                      if(dealer.Coverage_Areas__r != null 
                                                                         && !dealer.Coverage_Areas__r.Isempty()){
                                                                             if(c.Enforce_Agreement_Check_Dealer_Search__c && signedAgreement)
                                                                                 hasValidCoverageAreas = true;
                                                                             else
                                                                                 hasValidCoverageAreas = true;
                                                                         }
                                                                      
                                                                      if(hasValidCoverageAreas){
                                                                          // check to make sure dealer is registered in state/country of opportunity
                                                                          for(Business_Registration__c br : dealer.Business_Registrations__r){
                                                                              if(objLead.lead.State != NULL && objLead.lead.State != '' && objLead.lead.Country == 'United States'){
                                                                                  if(objLead.lead.State == br.State__c && objLead.lead.Country == br.Country__c){
                                                                                      isRegistered = TRUE;
                                                                                      break;
                                                                                  }
                                                                              }
                                                                              else if(objLead.lead.Country != 'United States'){
                                                                                  if(objLead.lead.Country == br.Country__c){
                                                                                      isRegistered = TRUE;
                                                                                      break;
                                                                                  }
                                                                              }
                                                                          }
                                                                      }
                                                                      
                                                                      if(isRegistered){
                                                                          for(CoverageArea__c coverageArea : dealer.Coverage_Areas__r)
                                                                          {
                                                                              if(dealersAlreadyIncluded.contains(coverageArea.Account__c)){
                                                                                  continue;
                                                                              }
                                                                              else{
                                                                                  
                                                                                  if(coverageArea.Geolocation__Latitude__s == null || coverageArea.Geolocation__Longitude__s == null)
                                                                                      continue;
                                                                                  
                                                                                  //Calculate the distance 
                                                                                  Decimal distance = DealerUtility.getDistance(objLead.lead.Latitude,objLead.lead.Longitude, 
                                                                                                                               coverageArea.Geolocation__Latitude__s, coverageArea.Geolocation__Longitude__s, 'mi');
                                                                                  
                                                                                  if(distance <= coverageArea.Radius__c){
                                                                                      DealerResult r = new DealerResult(
                                                                                          dealer.Id, 
                                                                                          dealer.Name,                                    
                                                                                          dealer.Type, 
                                                                                          coverageArea.Geolocation__Latitude__s, 
                                                                                          coverageArea.Geolocation__Longitude__s, 
                                                                                          distance,
                                                                                          dealer.Dealer_Score_Total__c,
                                                                                          dealer.Dealer_Locator_Phone__c, 
                                                                                          dealer.Phone, 
                                                                                          dealer.BillingStreet, 
                                                                                          dealer.BillingCity, 
                                                                                          dealer.BillingState, 
                                                                                          dealer.BillingCountry, 
                                                                                          dealer.BillingPostalCode, 
                                                                                          dealer.Website, 
                                                                                          dealer.Oracle_Account_Number__c, 
                                                                                          dealer.Description, 
                                                                                          dealer.Partner_Facts__c,
                                                                                          dealer.Alliance_Program_Partner__c,
                                                                                          dealer.Opportunity_Recipient__c,
                                                                                          dealer.Dealer_Locator_Opt_Out__c,
                                                                                          dealer.Lead_Flow_Opt_Out__c 
                                                                                      );
                                                                                      r.isCampaignPartner = isCampaignPartner;
                                                                                      r.isAllianceCampaignPartner = isAllianceCampaignPartner;
                                                                                      r.isWarmTransferPartner = isWarmTransferPartner;
                                                                                      r.AccountDisplayName = dealer.Account_Display_Name__c;
                                                                                      r.PartnerLogo  = dealer.Partner_Logo__c;
                                                                                      dealersAlreadyIncluded.add(dealer.Id);
                                                                                      result.add(r);
                                                                                  }
                                                                              }
                                                                          }
                                                                          result.sort();
                                                                      }
                                                                      
                                                                  }        
                                                              }
                                                              
                                                              objLead.lead.ALR_Assignment_Audit_Trail__c += auditUpdate(result.size() + ' Dealers found.');
                                                              for(DealerResult dr : result) {
                                                                  objLead.lead.ALR_Assignment_Audit_Trail__c += auditUpdate(dr.AccountName + ' isCampaignPartner: ' + dr.isCampaignPartner);
                                                              }
                                                              return result;
                                                          }
    
    /****************************************************************************************************************************************************************************************************
function    : cleanDealerList
Parameters  : String , List <DealerResult>
Sumary      : This method will return a dealer list based on the following arguments/types of dealers:
1. Campaign Partners
2. Alliance Partners
3. Master Dealers
4. All (NULL)
*****************************************************************************************************************************************************************************************************/
    public static List <DealerResult> cleanDealerList(String resultType, List <DealerResult> listDealersRaw){
        
        list <DealerResult> result = new list <DealerResult>();
        
        for(DealerResult dr : listDealersRaw){
            if(resultType != null && resultType.equalsIgnoreCase(CAMPAIGNPARTNERS)) {
                if(dr.isCampaignPartner) result.add(dr);
            }
            else if(resultType != null && resultType.equalsIgnoreCase(ALLIANCEPARTNERS)) {
                if(dr.isAllianceCampaignPartner) result.add(dr);
            }
            //CRYSTAL - added 11/4/2015
            else if(resultType != null && resultType.equalsIgnoreCase(MASTERDEALERS)) {
                if(dr.Type != null && dr.Type.startsWithIgnoreCase('Master')) result.add(dr);
            }
            
            else result.add(dr);
        }
        
        System.debug(LoggingLevel.INFO, 'DealerUtility.cleanDealerList: there are ' + result.size() + ' ' + resultType + ' dealers after cleaning list.');
        
        return result;
    }
    
    public static Id GetSingleDealerBasedOnWeightedScore(list<DealerResult> listDealers, Lead_Dealer_Assignment_Audit__c daa ) {
        
        if(listDealers == null || listDealers.isEmpty()) return null;
        
        if(listDealers.size() == 1) 
            return listDealers[0].AccountId;
        list<Id> listDealerPool = new list<id>();
        
        for(DealerResult d : listDealers){
            if (d.score != null && d.score != 0){
                for(Integer i = 0; i < integer.valueOf(d.score)-1; i++)
                    listDealerPool.add(d.AccountId);
            }
        }
        
        //TODO Possibly look at shuffling the POOL before selcting from it. I suggest this because I know RANDOM tends to act in predictable ways (at least on other systems)
        integer randomInt = getRandomNumber(listDealerPool.size()-1);
        
        if (listDealerPool.size() == 0) {
            return null;
        }
        
        return listDealerPool[randomInt];
    }
    
    public static LeadAssignmentWrapper failedAssignment(LeadAssignmentWrapper objLeadInfo, String DAAName){
        objLeadInfo.lead.Requires_Manual_Assignment__c = true;
        objLeadInfo.lead.Dealer_Assignment_Status__c = 'Failed Assignment - No Dealers Found';
        objLeadInfo.lead.Status = 'Disqualified';
        objLeadInfo.objAuditAssign = LeadDealerUtility.configureLeadDealerAssignmentAudit(DAAName, null, objLeadInfo.lead.Id, 'Requires Manual Assignment','', null);
        return objLeadInfo;
    }
    
    public static LeadAssignmentWrapper successfulAssignment(LeadAssignmentWrapper objLeadInfo){
        objLeadInfo.lead.Dealer_Assignment_Status__c = 'Dealer Assigned';
        
        //Create Dealer Notification for Text on OpportunityAssignment
        Dealer_Notification__c dealerNotification = new Dealer_Notification__c(RelatedObjectId__c = objLeadInfo.lead.Id, Type__c = 'Text', Activity__c = 'OpportunityAssignment', isSent__c = false, sendTo__c = objLeadInfo.lead.OwnerId);
        objLeadInfo.lstDealerNotification.add(dealerNotification);
        
        return objLeadInfo;
    }
    
    public static List<LeadAssignmentWrapper> calculateCompetition(List<LeadAssignmentWrapper> wrappers) 
    {
        List<Opportunity> competingOpps = new List<Opportunity>();
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        Set<String> ldStates = new Set<String>();
        Set<String> ldStreets = new Set<String>();
        Set<String> ldPhones = new Set<String>();
        Set<String> ldMobiles = new Set<String>();
        Set<String> ldEmails = new Set<String>();
        map<Id,Id> mapLeadId = new map<Id,Id>();
        
        //KCM_10142016: set of accounttypes to improve query by removing LIKE % filters
        Set<String> accountTypes = new Set<String>{AUTHORIZED_PARTNER_COMBO, AUTHORIZED_PARTNER_RESIDENTIAL, 
                                                   PREMIER_PARTNER_COMBO, PREMIER_PARTNER_RESIDENTIAL, ELITE_PARTNER_COMBO, 
                                                   ELITE_PARTNER_RESIDENTIAL,MASTER_PARTNER_RESIDENTIAL, MASTER_PARTNER_COMBO}; 
        //use SFDCSpecialUtilities to get partner record ID and use this instead of record type name in query                          
        Id hoRecTypeId = SFDCSpecialUtilities.getRecordTypeIdsByDeveloperName(Opportunity.SObjectType).get('Home_Owner');
        
        for(LeadAssignmentWrapper law : wrappers) 
        {
            law.lead.HD_Competing_Partner_Indicator__c = 3;
            law.CompetingColour = 3;
            
            //if(!law.isSPD) continue;
            
            ldStates.add(law.lead.State);
            ldStreets.add(law.lead.Street);
            if(law.lead.Phone != null && law.lead.Phone != '') {
                ldPhones.add(law.lead.Phone);
            }
            if(law.lead.MobilePhone != null && law.lead.MobilePhone != '') {
                ldMobiles.add(law.lead.MobilePhone);
            }
            if(law.lead.Email != null && law.lead.Email != '') {
                ldEmails.add(law.lead.Email);
            }
        }
        
        if(ldStates.isEmpty()) return wrappers;
        /**KCM_10142016: commented out original query
        String queryString = 'Select Id, Name, StageName, CreatedDate, Partner_Account_Id__r.Type, ' +
            'Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.Email__c, Account.Phone, ' +
            '(Select a.CreatedDate, a.Id From Agreements__r a WHERE a.CreatedDate <= LAST_N_DAYS:30 ' + 
            'OR a.echosign_dev1__DateSent__c >= LAST_N_DAYS:30 OR a.echosign_dev1__DateSigned__c >= LAST_N_DAYS:30), ' +
            '(Select q.Id, q.CreatedDate, q.Account__c, q.Name, q.Status From Quotes q WHERE q.CreatedDate >= LAST_N_DAYS:30) ' +
            'FROM Opportunity WHERE RecordType.Name = \'Home Owner\' AND (Partner_Account_Id__r.Type LIKE \'Premier%\' ' + 
            'OR Partner_Account_Id__r.Type LIKE \'Elite%\' OR Partner_Account_Id__r.Type LIKE \'Master%\') ' +
            'AND ((Account.BillingState IN: ldStates AND Account.BillingStreet IN: ldStreets) ';*/
        
        
        //KCM_10142016: new query replacing the one commented out above
        //put Last_N_Days in a custom setting so users can adjust on the fly
        String queryString = 'Select Id, Name, StageName, CreatedDate, Partner_Account_Id__r.Type,' +
            'Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.Email__c, Account.Phone, ' +
            '(Select a.CreatedDate, a.Id From Agreements__r a WHERE a.CreatedDate <= LAST_N_DAYS:30 ' + 
            'OR a.echosign_dev1__DateSent__c >= LAST_N_DAYS:30 OR a.echosign_dev1__DateSigned__c >= LAST_N_DAYS:30), ' +
            '(Select q.Id, q.CreatedDate, q.Account__c, q.Name, q.Status From Quotes q WHERE q.CreatedDate >= LAST_N_DAYS:30) ' +
            'FROM Opportunity WHERE RecordTypeId =:hoRecTypeId AND Partner_Account_Id__r.Type in :accounttypes' +
            ' AND CreatedDate >= LAST_N_DAYS:DEALERGENERAL.LAST_N_DAYS '+
            'AND ((Account.BillingState IN: ldStates AND Account.BillingStreet IN: ldStreets) ';
        //KCM_10142016: end of new query
        
        if(!ldPhones.isEmpty()) {
            queryString += 'OR Account.Phone IN: ldPhones ';
        }
        if(!ldMobiles.isEmpty()) {
            queryString += 'OR Account.Phone IN: ldMobiles ';
        }
        
        if(!ldEmails.isEmpty()) {
            queryString += 'OR Account.Email__c IN: ldEmails';
        }
        
        queryString += ')';
        
        System.debug('queryString' + querystring);
        try {
            competingOpps = Database.query(queryString);
            System.debug('Size: ' + competingOpps.size());
        } catch(Exception e) {
            /*  Exception_Log__c log = new Exception_Log__c();
log.Error_Message__c = e.getMessage();
log.Stack_Trace__c = e.getStackTraceString();
try{ insert log; } catch(Exception e2) {} */ //Commented as was causing callout/dml exception if encountered soql error
        }
        
        List<LeadAssignmentWrapper> wrappersWithCompetition = new List<LeadAssignmentWrapper>();
        Integer competitionVal = 3;
        
        if(!competingOpps.isEmpty() && competingOpps != null) 
        {
            for(Opportunity o : competingOpps) 
            {
                for(LeadAssignmentWrapper l : wrappers) 
                {
                    if((o.Account.BillingStreet == l.lead.Street && o.Account.BillingState == l.lead.State) 
                       || o.Account.Phone == l.lead.Phone || o.Account.Phone == l.lead.MobilePhone || o.Account.Email__c == l.lead.Email) {
                           if(o.Agreements__r.size() > 0) {
                               competitionVal = 1;
                           } else if(o.Quotes.size() > 0) {
                               competitionVal = 1;
                           } else if(o.CreatedDate >= Date.today() - 30) { 
                               competitionVal = 1;
                           } else if(o.CreatedDate <= Date.today() - 30) {
                               competitionVal = 2;
                           }
                       }
                    l.CompetingColour = competitionVal;
                    l.lead.HD_Competing_Partner_Indicator__c = competitionVal;
                    
                    if(!mapLeadId.ContainsKey(l.lead.Id))
                        wrappersWithCompetition.add(l);
                    
                    mapLeadId.put(l.lead.Id,l.lead.Id);
                }
            }
        }
        else if (competingOpps.isEmpty() && wrappersWithCompetition.size() == 0)
        {
            for(LeadAssignmentWrapper l : wrappers)
            {
                l.lead.HD_Competing_Partner_Indicator__c = 3;
                l.CompetingColour = competitionVal;
                wrappersWithCompetition.add(l);
            }
        }
        return wrappersWithCompetition;
    }
    
    /****************************************************************************************************************************************************************************************************
function    : Call Five 9 
Parameters  : Lead 
Sumary      : This method will do http callout and send the list of result of the request
*****************************************************************************************************************************************************************************************************/
    
    
    public static Map<Lead,F9Web2CampaignResult> callfive9forSPDLead(List<LeadAssignmentWrapper> lstLead) 
        //public static map<Lead,F9Web2CampaignResult> callfive9forSPDLead(list<Lead> lstLead)
    {
        
        getListOfAllParentCampaignIdForDelay();
        map<Lead,F9Web2CampaignResult> mapF9Web2CampaignResult = new map<Lead,F9Web2CampaignResult>();
        
        if(lstLead.isEmpty()) return mapF9Web2CampaignResult;
        
        List<SpectrumDebugUtility.debugLog> spExlogs = new List<SpectrumDebugUtility.debugLog>();
        
        try
        {
            for(LeadAssignmentWrapper objLead : lstLead){
                
                Map<String, String> f9lead = new Map<String, String>();
                f9lead.put('F9domain', FIVE9WEBSERVICE.Domain_Name__c);         //required
                if(objLead.five9ListName != null) {
                    f9lead.put('F9list', objLead.five9ListName);
                } else {
                    f9lead.put('F9list', FIVE9WEBSERVICE.SPDF9list__c);             //required
                }
                f9lead.put('F9key', FIVE9WEBSERVICE.F9key__c);                  //typical use case
                
                f9lead.put('salesforce_id', objLead.Lead.Id);                   //lead Id
                f9lead.put('first_name', objLead.Lead.FirstName);                       //Lead First Name
                f9lead.put('last_name', objLead.Lead.LastName);
                if(objLead.Lead.MobilePhone != null)                            //Lead Last Name
                    f9lead.put('number1', objLead.Lead.MobilePhone);            //required
                else 
                    f9lead.put('number1', objLead.Lead.Phone);
                //f9lead.put('sfdc_campaign', objLead.Lead.Most_Recent_Campaign__c);    //Lead campaign Name      
                if(objLead.campaign != null)
                    f9lead.put('sfdc_campaign', objLead.campaign.name);
                // Code to put delay based on Campaign ParentID
                
                if(mapResponse.containsKey(String.valueOf(objLead.campaign.ParentId))){
                    
                    // need to put key and value in specific format
                    f9lead.put('F9CallASAP','false');//To avaoid Immediate call back
                    integer delayedTime=(mapResponse.get(String.valueOf(objLead.campaign.ParentId)).Delay_in_mins__c).intValue();
                    f9lead.put('F9TimeToCall',getDelayedFive9Time(delayedTime));//Put the delayed time in String Format
                    f9lead.put('F9TimeFormat','yyyy-MM-dd HH:mm:ss.SSS');//Time Format to Send
                    f9lead.put('F9list',(mapResponse.get(objLead.campaign.ParentId).ListName__c)); //Delay List Name 
                }  
                
                //Instantiate a new F9Web2Campaign object
                F9Web2Campaign f9 = new F9Web2Campaign();             
                
                //Call the doPost method with the lead
                F9Web2CampaignResult res = f9.doPost(f9lead);
                
                
                //build log of ob msg and response
                SpectrumDebugUtility.debugLog spExLog = new SpectrumDebugUtility.debugLog();
                spExlog.LeadId = objLead.Lead.Id;
                spExLog.Service = ('SPD Lead/Five9 Web2Campaign');
                spExLog.Response = F9Web2Campaign.resBody; 
                spExLog.responseCode = F9Web2Campaign.stCode;
                spExLog.JSONPayload = F9Web2Campaign.obmsg;
                
                spExLogs.add(spExLog);
                
                mapF9Web2CampaignResult.put(objLead.Lead,res);
                
            }
            
        }catch(Exception ex){
            system.debug('******** five 9 SPD exceptions====>'+ex.getMessage());
            Exception_Log__c log = new Exception_Log__c();
            log.Error_Message__c = ex.getMessage();
            log.Stack_Trace__c = ex.getStackTraceString();
            try{ insert log; } catch(Exception e2) {}
        }
        
        try {
            if(spExLogs != null && !spExLogs.isEmpty()) {
                SpectrumDebugUtility.generateDebugLog(spExlogs);
            } 
        } catch(Exception e) {}
        return mapF9Web2CampaignResult;
    }
    
    public static list<DealerResult> findCampaignDealers(list<DealerResult> dealerResults, Id CampaignId){
        list<DealerLocatorService.ResultRow> resultRows = new List<DealerLocatorService.ResultRow>();
        list<Campaign_Partner__c> listCampaignResults = new list<Campaign_Partner__c>();
        set<Id> setFoundDealerIds = new set<Id>();
        
        for(DealerResult dr : dealerResults)
            setFoundDealerIds.add(dr.AccountId);
        
        if(setFoundDealerIds.size() > 0)
            listCampaignResults = DealerSOQLUtil.getCampaignPartnerByCampIdandPartner(setFoundDealerIds,CampaignId);
        
        list<DealerResult> listFinalResults = new list<DealerResult>();
        for (Campaign_Partner__c cp : listCampaignResults) {
            for (DealerResult dr2 : dealerResults){
                if (dr2.AccountId == cp.Partner__c){
                    if (cp.Enabled__c == true)    
                        listFinalResults.add(dr2);
                }
            }
        }
        
        return listFinalResults;
    }
    
    
    public static Id GetSingleDealerBasedOnRandomEvenDistribution(list<DealerResult> listDealers, string CampaignId )
    {
        if (listDealers.size() == 0) {
            return null;
        }
        
        list<Id> listDealerPool = new list<id>();
        boolean bFound = false;
        integer randomInt = 0;
        
        AggregateResult[] listAlreadyAssigned = [SELECT Dealer_Assigned__c, count(Id) FROM Lead_Dealer_Assignment_Audit__c 
                                                 WHERE Campaign__c =: campaignId AND Dealer_Assigned__c != null
                                                 GROUP BY Dealer_Assigned__c ORDER BY count(Id) DESC];
        if(listAlreadyAssigned == null) return null;
        
        if(listAlreadyAssigned.size() == 0) {
            
            for (DealerResult d : listDealers){ //Load the Pool based on the Dealer List Passed IN
                listDealerPool.add(d.AccountId);
            }
            randomInt = getRandomNumber(listDealerPool.size()-1);
            return listDealerPool[randomInt]; 
            
        }
        else
        {
            //===========================================================================
            //====  Indicates some have more than other so we remove the top one and randomly select from remaining
            //========================================= ==================================
            if(listDealers.size() == 1) 
                return listDealers[0].AccountId; 
            
            Integer mostAssigned = 0;
            
            for(AggregateResult leadAssignment3 : listAlreadyAssigned) 
                if (integer.valueOf(leadAssignment3.get('expr0')) > mostAssigned) mostAssigned = integer.valueOf(leadAssignment3.get('expr0'));
            
            list<Id> listTOEXCLUDEDealerPool = new list<Id>();
            
            for (AggregateResult leadAssignment4 : listAlreadyAssigned) {
                if (integer.valueOf(leadAssignment4.get('expr0')) == mostAssigned) {
                    listTOEXCLUDEDealerPool.add((ID)leadAssignment4.get('Dealer_Assigned__c'));
                }
            }
            
            //So we found the biggest - now populate the POOL and omitt any that have the biggest
            for (DealerResult d : listDealers) 
            { //Load the Pool based on the Dealer List Passed IN
                bFound = false;
                for(Id leadAssignment5 : listTOEXCLUDEDealerPool) 
                {
                    if (leadAssignment5 == d.AccountId) {
                        bFound = true;
                    }
                }
                
                if(!bFound)
                    listDealerPool.add(d.AccountId);
            }
            
            if(listDealerPool.size() == 1)
                return listDealerPool[0]; 
            else if(listDealerPool.size() == 0) {
                randomInt = getRandomNumber(listDealers.size()-1);
                return listDealers[randomInt].AccountId; 
            }
            else {
                randomInt = getRandomNumber(listDealerPool.size()-1);
                return listDealerPool[randomInt]; 
            }
        }
    }
    
    /*******************************************************************************************************************************************************************************
Method      : getDealermappingbyDealerResult
Parameters  : list<DealerResult> lstDealerResult
Return Type : map<Id,Account>
Summary     : Method accepts list of dealer result and returns back dealermap   
********************************************************************************************************************************************************************************/
    public static map<Id,Account> getDealermappingbyDealerResult(list<DealerResult> lstDealerResult){
        map<Id,Account> dealerMap = new map<Id,Account>();
        set<String> setAccId = new Set<String>();
        if(lstDealerResult == null || lstDealerResult.isEmpty()) return dealerMap;
        
        for(DealerResult dealer : lstDealerResult){
            setAccId.add(dealer.AccountId);
        }
        
        dealerMap = DealerSOQLUtil.buildAllDealersMapReassignMent(setAccId);
        
        return dealerMap;
    }
    
    /*******************************************************************************************************************************************************************************
Method      : validateLeadQualificationCampaign
Parameters  : LeadAssignmentWrapper leadInfo
Return Type : LeadAssignmentWrapper
Summary     : Function Accepts LeadAssignmenrWrapper and check value of "bIsLeadQualificationCampaign" if its true we check that assigned 
dealer for lead is part of Campaign Partner or not
********************************************************************************************************************************************************************************/
  //Warm HandOff Replacing leadprequalification concept with is Exclusive
    public static LeadAssignmentWrapper validateLeadQualificationCampaign(LeadAssignmentWrapper leadInfo)
    {
       if(leadInfo == null || leadInfo.lead == null || leadInfo.bIsExclusiveCampaign == null || !leadInfo.bIsExclusiveCampaign ) {
            return leadInfo;
        }
        /*if(leadInfo == null || leadInfo.lead == null || leadInfo.bIsLeadQualificationCampaign == null || !leadInfo.bIsLeadQualificationCampaign) {
            return leadInfo;
        }
        */
        else{
            if(!isDealerfromCampaignPartner(leadInfo.campaign,leadInfo.lead.Dealer_Locator_Selection__c))
            {
                leadInfo.lead.Dealer_Locator_Selection__c = null;
                leadInfo.lead.Requires_Manual_Assignment__c = true;
                leadInfo.lead.Dealer_Assignment_Date__c = null;
                
                leadInfo.lead.ALR_Assignment_Audit_Trail__c += ALRConfiguration.auditUpdate('Eligible Dealer(s) cannot be assigned because of Campaign');
            }
            
            return leadInfo;    
        }
    }
    
    
    /*******************************************************************************************************************************************************************************
Method      : isDealerfromCampaignPartner
Parameters  : Campaign objCampaign, String strDealerId
Return Type : Boolean
Summary     : Function checks the assigned Dealer is from Campaign Partner or not.
********************************************************************************************************************************************************************************/
    private static Boolean isDealerfromCampaignPartner(Campaign objCampaign, String strDealerId){
        if(strDealerId == '' || strDealerId == null || objCampaign.Campaign_Partners__r.isEmpty()) return false;
        
        Boolean bIsDealerCampPartner = false;
        map<Id,Campaign_Partner__c> mapCampaignPartners = new map<Id,Campaign_Partner__c>();
        mapCampaignPartners.putAll(objCampaign.Campaign_Partners__r);
        for(Id strCampPartnerid : mapCampaignPartners.keySet()){
            if(strDealerId.equals(mapCampaignPartners.get(strCampPartnerid).Partner__c)){
                bIsDealerCampPartner = true;
                break;
            }
        }
        
        return bIsDealerCampPartner;
    }
    
    /*******************************************************************************************************************************************************************************
Method      : getListOfAllParentCampaignIdForDelay
Parameters  : 
Return Type : Void
Summary     : Function checks the assigned Dealer is from Campaign Partner or not  and return the Map having campaignParent Id and Five9Delay Setting Object
********************************************************************************************************************************************************************************/
    private static void getListOfAllParentCampaignIdForDelay(){
        allFive9SettingValues = Five9CampaignDelaySettings__c.getAll().values();// Get All records Value from Custom Settings Five9CampaignDelaySettings
        if(allFive9SettingValues !=null && allFive9SettingValues.size() > 0){ 
            for(Five9CampaignDelaySettings__c five9CampaignSetting : allFive9SettingValues){
                mapResponse.put(String.valueOf(five9CampaignSetting.CampaignId__c),five9CampaignSetting);
                
            }
        }
       
    }
    
    /*******************************************************************************************************************************************************************************
Method      : getDelayedFive9Time
Parameters  : String minutes
Return Type : String
Summary     : Function accept delayed time in minutes and return the modified time based on User Time zone
********************************************************************************************************************************************************************************/
    
    private static String getDelayedFive9Time(Integer minutes) {
        Date today = System.today();
        Datetime myTodayDate = System.Now();
        myTodayDate=myTodayDate.addMinutes(minutes);
        String myDate = myTodayDate.format('yyyy-MM-dd HH:mm:ss.SSS');
        return myDate;
        
    }
    
    
    
}