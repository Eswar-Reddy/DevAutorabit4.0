/* Updates:
 * 4/10/2016 - Chakra : Updated to select Coverage Area based on BU
 * PT #116798891, #116576617 - Commercial Dealer Locator, Cover Area obj reorganization
 * 
 * 
 * 
 * 
 * 
 */


public without sharing class DealerUtility {

 public static boolean IsBatchRunning = false;
 public static Boolean bulkLeadTest = false;
 
/*public static final RecordType RECORD_TYPE_OPPORTUNITY;
    static
    {
        RECORD_TYPE_OPPORTUNITY = [Select  r.Id, r.SobjectType, r.Name From RecordType r 
                                                where sobjecttype ='Opportunity' and Name = 'Home Owner' LIMIT 1];
    }*/

//===================================================================  

//===================================================================  
    public static DealerResult[] getTopDealers(decimal lat, decimal lon, GeocodeAsyncHandler.GeoInfo info, string Country, integer dealerCount)
    {
        DealerGeneral__c c = DealerGeneral__c.getInstance();
        DealerResult[] results = new DealerResult[]{};
        DealerResult[] resultsMaster = new DealerResult[]{}; // Updated by Chakri to sorting MAster Dealer First
        DealerResult[] resultsNonMaster = new DealerResult[]{}; // Updated by Chakri to sorting MAster Dealer First
        DealerResult[] topDealers = new DealerResult[]{};
        list<CoverageArea__c> listCoverageAreaAfterAgreements = new list<CoverageArea__c>();
        list<CoverageArea__c> listFinalCoverageArea = new list<CoverageArea__c>();
        set<Id> setAccountIds = new set<id>();
        set<Id> uniqueIds = new set<id>();
        
        //System.debug(('@@@@@DealerUtility (SOQL); getTopDealers; SOQL getting CoverageArea__c');
        
        string  sQuery = 'select Account__c, Account__r.Name,Account__r.Account_Display_Name__c,Account__r.Partner_Logo__c, Account__r.Type, Account__r.Dealer_Score_Total__c, Account__r.Dealer_Locator_Phone__c,Account__r.RSM__c, Account__r.RSM__r.Name,'+
                                    'Account__r.Phone, Account__r.BillingStreet, Account__r.BillingCity, Account__r.BillingState, Account__r.BillingCountry, Account__r.BillingPostalCode, '+
                                    'Account__r.Opportunity_Recipient__c, Account__r.website, Account__r.Oracle_Account_Number__c, Account__r.Description, '+
                                    'Account__r.Partner_Facts__c, Geolocation__Latitude__s, Geolocation__Longitude__s, Radius__c, Account__r.Alliance_Program_Partner__c, Account__r.Dealer_Locator_Opt_Out__c, Account__r.Lead_Flow_Opt_Out__c  '+
                                    //'from CoverageArea__c where Account__r.Status__c = \'Active\' and Radius__c > 0 '+ //Update: #116798891
                                    'from CoverageArea__c WHERE Sector__c = \'Residential\' AND Account__r.Status__c = \'Active\' and Radius__c > 0 ' +
                                    'and DISTANCE(Geolocation__c,GEOLOCATION(' + lat + ',' + lon + '), \'mi\')<300 ' +
                                    'and (Account__r.Type like \'%Partner-Residential%\' OR Account__r.Type like \'%Partner-Combo%\' )';
        
        ////System.debug((('@@@@@getTopDealers; SOQL:'+sQuery);
        
        //GET THE MAIN LIST SANS AGREEMENT CHECK
        list<CoverageArea__c> listCoverageAreas = database.query(sQuery);
        
        //BUILD A SET OF ID'S SO WE CAN CHECK FOR AGREEMENTS
        for (CoverageArea__c ca : listCoverageAreas)
            setAccountIds.add(ca.Account__c);
        
        //09.20.13 Since we now need to make sure an Agreement is in effect I need to do additional work. Would be nice IF I could Account__r.Agreements__r
        //CHECK TO SEE WHO HAS AN AGREEMENT
        //System.debug(('@@@@@DealerUtility (SOQL); getTopDealers; SOQL getting echosign_dev1__SIGN_Agreement__c');
        
        list<echosign_dev1__SIGN_Agreement__c> listAgreementMatches =[select Account__c from  echosign_dev1__SIGN_Agreement__c 
                                                                                                where Account__c IN :setAccountIds and echosign_dev1__Status__c = 'Signed' 
                                                                                                and Agreement_Type_2__c = 'Partner Agreement' and Name like '%Lead Handling Policy Agreement'];
                                                                                                
        map<id, echosign_dev1__SIGN_Agreement__c> mapAgreements = new map<id, echosign_dev1__SIGN_Agreement__c>();
        
        //Loading a Map to help reduce the number of iterations below
        for (echosign_dev1__SIGN_Agreement__c a : listAgreementMatches) 
            mapAgreements.put(a.Account__c, a);
                                                                                        
        //System.debug(('@@@@@getTopDealers; Check to see who has an agreement in :'+setAccountIds);                   
        //System.debug(('@@@@@getTopDealers; Found agreement matches :'+mapAgreements.size());     
       
        setAccountIds.clear();
                                                            
        //CYCLE THRU AGREEMENTS FOUND AND ONLY RETURN THOSE THAT MATCH FROM FIRST QUERY 
        for (CoverageArea__c ca : listCoverageAreas)    
        {     
            if (c.Enforce_Agreement_Check_Dealer_Search__c == true) 
            {                                                                                  
                if (mapAgreements.containskey(ca.Account__c)==true) {
                    listCoverageAreaAfterAgreements.add(ca);
                    setAccountIds.add(ca.Account__c);
                }
            }
            else
            {
                    listCoverageAreaAfterAgreements.add(ca);
                    setAccountIds.add(ca.Account__c);
            }
        }
        
        //CHECK TO SEE IF THE FINAL LIST OF DEALER HAS SOME SORT OF LICENSE IN THE STATE OF THE CUSTOMER.
        //NO NEED TO CHECK IS ITS VALID AT THIS TIME.
        //System.debug(('@@@@@getTopDealers; Check to see who has Registrations in: '+info);  
        
        //System.debug(('@@@@@DealerUtility (SOQL); getTopDealers; SOQL getting Business_Registration__c');
        
        list<Business_Registration__c> listRegs = new list<Business_Registration__c>();
        
        //Many times the State abbrev. in the United States will match a State abbrev. in another country (esp. Italy)
        //This justifies that we always include Country in the query. In addition, in production, all Bus. Reg. have a Country
        
        if (info.State != null && info.State != '' && Country == 'United States')
        {
            
         listRegs = [select Account__c from  Business_Registration__c where Account__c IN :setAccountIds and ( State__c = :info.State AND Country__c = :Country )];
         //System.debug(('@@@@@DealerUtility; getTopDealers; Business_Registration__c Query included State: ' + info.State + ' Country: ' + Country);
        }
        else if (Country != 'United States')
        { 
         listRegs = [select Account__c from  Business_Registration__c where Account__c IN :setAccountIds and Country__c = :Country ];
         //System.debug(('@@@@@DealerUtility; getTopDealers; Business_Registration__c Query included Country: ' + Country);
        }
        
        
        
        map<id, Business_Registration__c> mapRegistrations = new map<id, Business_Registration__c>();
        
        //System.debug(('@@@@@getTopDealers;  Found Registration matches: '+ listRegs.size());
        
        //Loading a Map to help reduce the number of iterations below
        for (Business_Registration__c br : listRegs)    
            mapRegistrations.put(br.Account__c, br);
        
        //CYCLE THRU LICENSES FOUND AND ONLY RETURN THOSE THAT HAD MATCHED  
        for (CoverageArea__c ca : listCoverageAreaAfterAgreements)                                                                                          
            if (mapRegistrations.containskey(ca.Account__c)==true) {
                //System.debug(('@@@@@getTopDealers;  Final entry: '+ ca.Account__c);
                listFinalCoverageArea.add(ca);
            }
        
        for (CoverageArea__c ca :  listFinalCoverageArea)
        {
            decimal distance = DealerUtility.getDistance(lat, lon, ca.Geolocation__Latitude__s, ca.Geolocation__Longitude__s, 'mi');
            
            if (ca.Radius__c >= distance)
            { 
            
                if (!uniqueIds.contains(ca.Account__c))
                {
                    DealerResult r = new DealerResult(
                                            ca.Account__c, 
                                            ca.Account__r.Name,
                                            
                                            ca.Account__r.Type, 
                                            ca.Geolocation__Latitude__s, 
                                            ca.Geolocation__Longitude__s, 
                                            distance,
                                            ca.Account__r.Dealer_Score_Total__c,
                                            ca.Account__r.Dealer_Locator_Phone__c, 
                                            ca.Account__r.Phone, 
                                            ca.Account__r.BillingStreet, 
                                            ca.Account__r.BillingCity, 
                                            ca.Account__r.BillingState, 
                                            ca.Account__r.BillingCountry, 
                                            ca.Account__r.BillingPostalCode, 
                                            ca.Account__r.Website, 
                                            ca.Account__r.Oracle_Account_Number__c, 
                                            ca.Account__r.Description, 
                                            ca.Account__r.Partner_Facts__c,
                                            ca.Account__r.Alliance_Program_Partner__c,
                                            ca.Account__r.Opportunity_Recipient__c,
                                            ca.Account__r.Dealer_Locator_Opt_Out__c,
                                            ca.Account__r.Lead_Flow_Opt_Out__c 
                                         );
                                         
                    r.AccountDisplayName = ca.Account__r.Account_Display_Name__c;  
                    r.PartnerLogo  = ca.Account__r.Partner_Logo__c;
                    r.rsmID = ca.Account__r.RSM__c;  //Added by Chakri 00664359
                    r.rsmName = ca.Account__r.RSM__r.Name;  //Added by Chakri 00664359

                    ////System.debug(('@@@@@getTopDealers NEW ROW:'+r);
                    if( ca.Account__r.Type.contains('Master')){   // Updated by Chakri to sorting MAster Dealer First.
                    resultsMaster.add(r);
                    }else{
                    resultsNonMaster.add(r);    
                    }
                
                    //results.add(r);
                    uniqueIds.add(ca.Account__c);
                }
            }
        }
        
        resultsMaster.sort();
        resultsNonMaster.sort();
        
        results.addAll(resultsMaster); // Updated by Chakri to sorting MAster Dealer First.
        results.addAll(resultsNonMaster); // Updated by Chakri to sorting MAster Dealer First.
        system.debug('***********results'+results);
        if (dealerCount >= results.size())
        {
            //System.debug(('@@@@@getTopDealers .. Results (Dealer records) size: '+results.size());
            return results;
        } else {
            for (Integer i=0; i<dealerCount; i++) topDealers.add(results[i]);
            //System.debug(('@@@@@getTopDealers ... Results (Dealer records) size: '+topDealers.size());
            return topDealers;
        }
    }
//===================================================================

//===================================================================   
    public static decimal getDistance(decimal lat1, decimal lon1, decimal lat2, decimal lon2, string uom)
    {
        Integer RADIUS;
        if (uom=='km') RADIUS = 6373; else RADIUS = 3961;   //The values used for the radius of the Earth (3961 miles & 6373 km)
                                                            //are optimized for locations around 39 degrees from the equator 
                                                            //(roughly the Latitude of Washington, DC, USA)
        lat1 = deg2rad(lat1);
        lon1 = deg2rad(lon1);
        lat2 = deg2rad(lat2);
        lon2 = deg2rad(lon2);
        decimal dlon = lon2 - lon1; 
        decimal dlat = lat2 - lat1;
        
        
        decimal a = ( math.sin(dlat/2)*math.sin(dlat/2) ) + math.cos(lat1) * math.cos(lat2) * ( math.sin(dlon/2)*math.sin(dlon/2));
        decimal c = 2 * math.atan2( math.sqrt(a), math.sqrt(1-a) );      
        return RADIUS * c;      
    }
    
    // convert degrees to radians
    private static decimal deg2rad(decimal deg)
    {
        decimal rad = deg * (3.1415926)/180; // radians = degrees * pi/180
        return rad;
    }
//===================================================================

//===================================================================
public static void CalculateTimelyUpdateOnOpportunity (List<Opportunity> newOpportunityList) {

    List <BusinessHours> businessHoursList = new List <BusinessHours>([SELECT Id, Name FROM BusinessHours]);
    
    Map <Id, BusinessHours> businessHoursMap = new Map <Id, BusinessHours>();
    Map <Id, String> campaignSLAMap = new Map <Id, String>();

    Id defaultBusinessHours;
    for (BusinessHours bh : businessHoursList) 
    {
        if (bh.Name == 'SLA Contact Hours') 
        {
            defaultBusinessHours = bh.id;
            break;  
        }
    }
    
    Set <Id> oppAccountIds = new Set <Id>();
    List <Account> oppAccountList = new List <Account>();
    Map <Id, Id> oppAccountHoursMap = new Map <Id, Id>();
    Set <Id> oppIdsToQuery = new Set <Id>();
    Set <Id> campaignIdsToQuery = new Set <Id>();
    Set <Id> oppIdsAddedToMap = new Set <Id>();
    Map<Id, Datetime> contactDateTime = new Map<Id, Datetime>();
    
    for(BusinessHours busHours : businessHoursList)
    {
        businessHoursMap.put(busHours.Id, busHours);
    }
    
    for(Opportunity oNew : newOpportunityList)
    {
        if (oNew.Lead_Manufacturer__c == 'SunPower') 
        {
            oppAccountIds.add(oNew.Partner_Account_Id__c);
            oppIdsToQuery.add(oNew.Id);
            campaignIdsToQuery.add(oNew.CampaignId);
        }
    }
    
    oppAccountList = [SELECT Id, Business_Hours__c FROM Account WHERE Id IN :oppAccountIds];

    Map <Id, Campaign> campaignMap = new Map <Id, Campaign>([SELECT Id, SLA_Type__c FROM Campaign WHERE Id IN :campaignIdsToQuery]);
    
    for(Account a : oppAccountList)
    {
        if(a.Business_Hours__c != null)
        {
            oppAccountHoursMap.put(a.Id, a.Business_Hours__c);
        } 
        else 
        {
            oppAccountHoursMap.put(a.Id, defaultBusinessHours);
        }
    }
        
    List <OpportunityHistory> oppsHistory = new List <OpportunityHistory>([SELECT OpportunityId, StageName, CreatedDate, Opportunity.Dealer_Assignment_Date__c, Opportunity.CreatedDate, Opportunity.CampaignId, Opportunity.Campaign.SLA_Type__c FROM OpportunityHistory WHERE OpportunityId IN :oppIdsToQuery ORDER BY CreatedDate ASC]);
    
    for(OpportunityHistory ofh : oppsHistory)
    {
        Datetime assignDate = ofh.Opportunity.Dealer_Assignment_Date__c;
        if(assignDate == null)
        {
            assignDate = ofh.Opportunity.CreatedDate;
            if(assignDate == null)
            {
                assignDate = datetime.now();
            }
        }
        
        if(ofh.Opportunity.Campaign.SLA_Type__c == '1 Business Day')
        {
            if(!contactDatetime.containsKey(ofh.OpportunityId) && ofh.Stagename != 'New Opportunity' && ofh.CreatedDate >= assignDate)
            {
                contactDatetime.put(ofh.OpportunityId, ofh.CreatedDate);
            }     
        }   
        else // Change by Niket for case #00428005
        if(!contactDatetime.containsKey(ofh.OpportunityId) && (ofh.Stagename.Contains('Contacted') || ofh.Stagename.Contains('contacted')) && ofh.CreatedDate >= assignDate)
        {
            contactDatetime.put(ofh.OpportunityId, ofh.CreatedDate);
        }
    }
    
    BusinessHours bh;
    for (BusinessHours j : businessHoursList) 
    {
        if (j.Name == 'SLA Contact Hours') 
        {
            bh = j;
            break;  
        }
    }
    
    for (Opportunity oNew : newOpportunityList)
    {
        if (oNew.Lead_Manufacturer__c != 'SunPower') continue;
        
        Datetime dSLAStartDatetime                  = oNew.Dealer_Assignment_Date__c;
        Datetime dSLAEndDatetime                        = contactDatetime.get(oNew.Id);
        Datetime dSLADueDatetime                        = null;
        Datetime dQualDatetime                      = system.now().addDays(-180);
        String sPassSLAResult                               = 'Fail'; 
        Decimal score = 0;
        String campaignSLAType = (oNew.CampaignId != NULL) ? campaignMap.get(oNew.CampaignId).SLA_Type__c : NULL;
        
        if(campaignSLAType == '1 Business Day' && dSLAEndDatetime == null && oNew.StageName != 'New Opportunity')
        {
            dSLAEndDatetime = datetime.now();
        }
        else // Change by Niket for case #00428005
        if(dSLAEndDatetime == null && (oNew.StageName.contains('Contacted') || oNew.StageName.contains('contacted')))
        {
            dSLAEndDatetime = datetime.now();
        }
         
        if(businessHoursMap.get(oppAccountHoursMap.get(oNew.Partner_Account_Id__c)) != null) bh = businessHoursMap.get(oppAccountHoursMap.get(oNew.Partner_Account_Id__c));
        
        if(dSLAStartDatetime == null)
        {
            dSLAStartDatetime = oNew.CreatedDate;
            if(dSLAStartDatetime == null)
            {
                dSLAStartDatetime = system.now();
            }
        }
                
        if(dSLAStartDatetime != null)
        {
            dSLADueDatetime = (campaignSLAType == '1 Business Day') ? BusinessHours.addGmt(bh.Id, dSLAStartDatetime, 10 * 60 * 60 * 1000L) : BusinessHours.addGmt(bh.Id, dSLAStartDatetime, 46 * 60 * 1000L);            

            if(dSLAEndDatetime != null)
            {
                if(dSLAEndDatetime < dSLADueDatetime)
                {
                    sPassSLAResult = 'Pass';
                }
                else sPassSLAResult = 'Fail';
            }
            else sPassSLAResult = 'Fail';
        }
        
        if(oNew.SFDC_Timely_Update_Stages__c == null)
        {
            oNew.SFDC_Timely_Update_Stages__c = '';
        }
        
        Datetime createdDate;
        
        if(oNew.CreatedDate != null)
        {
            createdDate = oNew.createdDate;
        }
        else createdDate = system.now();
        
        if(!oNew.SFDC_Timely_Update_Stages__c.contains(oNew.StageName) && createdDate >= dQualDatetime)
        {
            oNew.SFDC_Timely_Update_Stages__c += ';'+oNew.StageName;    
        }
        
        // Change by Niket for case #00428005
        if(oNew.SFDC_Timely_Update_Stages__c.contains('Contacted')  || oNew.SFDC_Timely_Update_Stages__c.contains('contacted'))
        {
            score += 40;
        }
        
        if(oNew.SFDC_Timely_Update_Stages__c.contains('Visit Completed'))
        {
            score += 30;
        }
        
        if(oNew.SFDC_Timely_Update_Stages__c.contains('Contract Signed') || oNew.SFDC_Timely_Update_Stages__c.contains('Installation Completed') || oNew.SFDC_Timely_Update_Stages__c.contains('Opportunity Lost'))
        {
            score += 30;
        }   
        
        oNew.SFDC_Timely_Updates__c = score;
        oNew.Pass_SLA__c = sPassSLAResult;
    }
}
//===================================================================

//===================================================================

public static void updateDealerLastAssignedDate(Map <Id, Account> newMap, Map <Id, Account> oldMap)
{
    if(Trigger.isBefore)
    {
        if(Trigger.isUpdate)
        {
            for(Account a : newMap.values())
            {
                if((oldMap.get(a.Id).Lead_Assignment_Count__c == NULL && a.Lead_Assignment_Count__c != NULL) || (oldMap.get(a.Id).Lead_Assignment_Count__c < a.Lead_Assignment_Count__c))
                {
                    
                }
            }
        }
    }
}

//===================================================================

//===================================================================
public static Id GetResidentialRecordType() {
    return SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Lead.SobjectType).get('Residential');
}
//===================================================================

    
    public static void SetLeadAutoConvert(List<Lead> listNewLeads) {

    Id ResidentailRecordTypeId = GetResidentialRecordType(); 
    
    Set<String> emailDupCheck = new Set<String>();
    Set<String> phoneDupCheck = new Set<String>();
    Set<ID> idDupCheck = new Set<ID>();
    Map<String, Lead> dupCheckByEmail = new Map<String, Lead>();
    Map<String, Lead> dupCheckByPhone = new Map<String, Lead>();
    
    for (Lead l: listNewLeads) {
        
          System.debug('----------l'+l);
            System.debug('----------l.isConverted'+l.isConverted);
            System.debug('----------l.Status'+l.Status);
            System.debug('----------l.RecordTypeId'+l.RecordTypeId);
            System.debug('----------ResidentailRecordTypeId='+ResidentailRecordTypeId);
            System.debug('----------l.Theater__c'+l.Theater__c);
            System.debug('----------l.Lead_Manufacturer__c'+l.Lead_Manufacturer__c);
            System.debug('----------l.Source_System__c'+l.Source_System__c);
       
        if (l.isConverted == true) continue;
        
        if (l.Status == 'Ready for Conversion') {
            l.IsAutoConvert__c = true;
            l.RLC_Type__c = 'Residential';
            continue;
        }
        
        if (l.Status != 'Open') continue;

        if (shouldWeProcessAutoConvert(l, ResidentailRecordTypeId) == false) continue;
        
        if (l.Source_System__c == 'Eloqua') {
            if (l.Lead_Inferred_Quality__c == 'Reject')
                l.Status = 'SPAM';
            else if (l.Lead_Inferred_Quality__c == 'Accept' && l.Lead_Data_Quality__c == 'Qualified')
                l.Status = 'Qualified';
            else if ((l.Lead_Inferred_Quality__c == 'Accept' || l.Lead_Inferred_Quality__c == 'Review') && l.Lead_Data_Quality__c == 'Disqualified')
                l.Status = 'Disqualified';
            else if ((l.Lead_Inferred_Quality__c == 'Accept' || l.Lead_Inferred_Quality__c == 'Review') && l.Lead_Data_Quality__c == 'Undetermined')
                l.Status = 'Awaiting Qualification Review';
            else if (l.Lead_Inferred_Quality__c == 'Review' && l.Lead_Data_Quality__c == 'Qualified')
                l.Status = 'Awaiting Qualification Review';
            else
                l.Status = 'Awaiting Qualification Review';
                
        }

        l.IsAutoConvert__c = false;
        
        if ( (l.Source_System__c == 'Eloqua' && l.Status == 'Qualified') || (l.Source_System__c != 'Eloqua' && l.Status == 'Open') ){
            
            if(l.Email != null)
            {
                emailDupCheck.add(l.Email);
                dupCheckByEmail.put(l.Email, l);
            }
            
            if(l.ID != null)
            {
                idDupCheck.add(l.ID);
            }
        }

        if (l.Country == 'United States of America' || l.Country == 'USA') l.Country = 'United States';

    }
    
    // Run the dup check for qualified leads
    if(!dupCheckByEmail.isEmpty())
    {
        Map<String, Lead> possibleDupLeads = retrievePossibleDupLeads(emailDupCheck, phoneDupCheck, idDupCheck);
        Map<String, Contact> possibleDupContacts = retrievePossibleDupContacts(emailDupCheck);
        
        for(String key: dupCheckByEmail.keySet())
        {
            if(possibleDupLeads.containsKey(key))
            {
                dupCheckByEmail.get(key).Status = 'Awaiting Duplicate Review'; 
                dupCheckByEmail.get(key).IsAutoConvert__c = false;
            }
            else if(possibleDupContacts.containsKey(key))
            {
                dupCheckByEmail.get(key).Status = 'Awaiting Duplicate Review'; 
                dupCheckByEmail.get(key).IsAutoConvert__c = false;
            }
            else
            {
                dupCheckByEmail.get(key).Status = 'Ready for Conversion';
                dupCheckByEmail.get(key).IsAutoConvert__c = true;
            }
        }
    }
    
    //This is house keeping to change the Company Name if there is a downstream conflict raised by CheckAccountDuplicate trigger.
    
    Set<Id> LeadIds = new Set<Id>();
    Set<String> LeadNames = new Set<String>();
    
    //Look at each Lead that is about to be processed
    for (Lead l: listNewLeads) {
        if (l.IsAutoConvert__c == true && l.isConverted == false) {
            LeadIds.add(l.id);
            
            //Do we need to adjust the company name?
            if (String.isEmpty(l.Company)) 
                LeadNames.add(l.FirstName + ' ' + l.LastName);
            else 
                LeadNames.add(l.Company);
            
        }
    }

    if (LeadNames.size() > 0) {
        AggregateResult[] listDuplicateAccounts = [select count(Id), Name from Account where Name IN :LeadNames group by Name];
        for (AggregateResult ar :listDuplicateAccounts) {
                for (Lead l: listNewLeads) {
                    if (l.Company == ar.get('Name')) {
                        l.Company  = l.company + string.valueOf(system.today());
                        //System.debug(('@@@@@DealerUtility.SetLeadAutoConvert; Renamed Account to ' + l.Company);
                    }
                }
        }
    }
    
}

    // Load leads that match critera in checking for dups
    private static Map<String, Lead> retrievePossibleDupLeads(Set<String> emails, Set<String> phone, Set<ID> ids)
    {
        Map<String, Lead> result = new Map<String, Lead>();
        
        try
        {
            List<Lead> possibleLeads = [SELECT Id, Email, Phone, MobilePhone FROM Lead WHERE 
                ID !=:ids AND Email =:emails];
            
            for(Lead plResult : possibleLeads)
            {
                if(plResult.Email != null)
                {
                    result.put(plResult.Email, plResult);
                }
            }
        }
        catch(QueryException error)
        {
            result = new Map<String, Lead>();
        }
        
        return result;
    }
    
    // As above but for contacts
    private static Map<String, Contact> retrievePossibleDupContacts(Set<String> emails)
    {
        Map<String, Contact> result = new Map<String, Contact>();
        
        if(!emails.isEmpty())
        {
            try
            {
                List<Contact> possibleContacts = [SELECT ID, Email FROM Contact WHERE Email =: emails];
                
                for(Contact pcResult : possibleContacts)
                {
                    result.put(pcResult.Email, pcResult);
                }
            }
            catch(QueryException error)
            {
                result = new Map<String, Contact>();
            }
        }
        
        return result;
    }


//===================================================================
public static boolean shouldWeProcessAutoConvert(Lead l, Id ResidentailRecordTypeId) {
    DealerGeneral__c c = DealerGeneral__c.getInstance();
    //RecordType ResidentailRecordType = GetResidentialRecordType(); //[Select  r.Id, r.SobjectType, r.Name From RecordType r where sobjecttype ='Lead'  and Name= 'Residential' LIMIT 1];
    
    if (l.RecordTypeId != ResidentailRecordTypeId) return false;
    System.debug('c.Lead_Test_First_Name__c'+c.Lead_Test_First_Name__c);
    System.debug('l.FirstName'+l.FirstName);
    
    //10.29.13 Paul if (l.FirstName  == c.Lead_Test_First_Name__c && l.LastName == c.Lead_Test_Last_Name__c) return false;
    if (l.FirstName  == c.Lead_Test_First_Name__c) return false;
    
    if (l.Theater__c != 'North America' && l.Theater__c != 'Central America and the Caribbean') return false;
    if (l.Lead_Manufacturer__c != 'SunPower') return false;
    
    l.RLC_Type__c = 'Residential';
    
    return true;
} 
//===================================================================

//===================================================================
public static void ScheduleLeadAutoAssgn() {
        //string ClassId = [Select Id, Name From ApexClass where Name = 'Batch_AutoAssign'].Id;
        
        //AsyncApexJob[] openJobs = [Select Id From AsyncApexJob where ApexClassId = :ClassId and Status in ('Queued', 'Processing') and JobType!='BatchApexWorker'];
        AsyncApexJob[] openJobs = [Select Id From AsyncApexJob where ApexClass.Name = 'Batch_AutoAssign' and Status in ('Queued', 'Processing') and JobType!='BatchApexWorker'];
    
        //system.debug('--------- jobId: ' + ClassId);
        //system.debug('--------- openJobs: ' + openJobs.size());
        
        if (openJobs.size()==0)
        {
            Batch_AutoAssign startBatch = new Batch_AutoAssign();
            Database.executeBatch(startBatch);
        }  
}
//===================================================================
@Future(callout=true)
public static void futureScheduleLeadAutoConvert(String LeadId) {
//Temp method to diagnosis @future issue downstream. 
    
    Lead l = [SELECT Id, Status, FirstName, Lastname, Company, street, city, state, postalCode, 
             country, Email, isConverted, OwnerId, Campaign_ID__c, IsAutoConvert__c , Dealer_Locator_Selection__c 
             FROM Lead where isConverted = false and IsAutoConvert__c = true and Id = :LeadId];
            
    String cleanAddress = GeocodeAsyncHandler.cleanAddress(l.Street, l.City, l.State, l.PostalCode, l.Country);
                
    GeocodeAsyncHandler.GeoInfo info = GeocodeAsyncHandler.GeoCode(cleanAddress);
                    
    DealerUtility.ConvertLead(l, info); 
}
//===================================================================
public static void ScheduleLeadAutoConvert(List<Lead> listNewLeads) {
    
    if (isALREnabled() == false) return;
        
    //System.debug(('@@@@@DealerUtiltiy.ScheduleLeadAutoConvert;');
    
    //string ClassId = [Select Id, Name From ApexClass where Name = 'Batch_ConvertLead'].Id;

    //AsyncApexJob[] openJobs = [Select Id From AsyncApexJob where ApexClassId = :ClassId and Status in ('Queued', 'Processing') and JobType!='BatchApexWorker'];
    AsyncApexJob[] openJobs = [Select Id From AsyncApexJob where ApexClass.Name = 'Batch_ConvertLead' and Status in ('Queued', 'Processing', 'Preparing')];

    //system.debug('--------- jobId: ' + ClassId);
    //system.debug('--------- openJobs: ' + openJobs.size());
    
    if (openJobs.size()==0 && IsBatchRunning == FALSE)
    {
        Batch_ConvertLead startBatch = new Batch_ConvertLead();
        if(!bulkLeadTest) Database.executeBatch(startBatch,1);
        IsBatchRunning = TRUE;
    }
    
    
}
//===================================================================

//===================================================================
 public static void SendEmailAlert(String theSubject, String theBody) 
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
      
      Try {
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
      } 
      Catch (system.Emailexception error) {}      
                     
   }
//===================================================================

//===================================================================   
public static boolean isDuplicateLead(Lead l) {
    //System.debug(('@@@@@DealerUtility (SOQL); isDuplicateLead; SOQL from Lead');
    list<Lead> listDuplicateLeads = [select Id from Lead where LastName = :l.LastName and FirstName = :l.FirstName and Email = :l.Email and id != :l.id LIMIT 1];
    if (listDuplicateLeads.size() != 0) return true;
    
    if (l.Email != null && l.Email != '') {
        //System.debug(('@@@@@DealerUtility (SOQL); isDuplicateLead; SOQL from Contact');
        list<Contact> listDuplicateContacts = [select Id from Contact where Email = :l.Email LIMIT 1];
        if (listDuplicateContacts.size() != 0) return true;
    }
    
    return false;
}  
//===================================================================

//=================================================================== 

    public static Set <Id> ConvertLeadBulk(Map<Lead, GeocodeAsyncHandler.GeoInfo> leadGeoMap)
    {
        // exit method if ALR is not enabled.
        if(!isALREnabled()) return NULL;

        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        List <Lead> leadsToUpdate = new List <Lead>();
        Map <Id, GeocodeAsyncHandler.GeoInfo> leadIdGeomap = new Map <Id, GeocodeAsyncHandler.GeoInfo>();
        Map <Id, Id> leadOwnerMap = new Map <Id, Id>();
        Map <Id, Id> acctLeadConvertMap = new Map <Id, Id>();
        Set <Id> oppIdsToAssign = new Set <Id>();
        List <Account> accountsToUpdate = new List <Account>();

        for(Lead l : leadGeoMap.keySet())
        {
            if(l.IsConverted || !l.IsAutoConvert__c || l.RecordType.Name == 'Partner') {
                System.debug(LoggingLevel.INFO, 'DealerUtility.ConvertLeadBulk: Lead is converted, not set to auto-convert, or has partner record type.');
                continue;
            }
            else
            {
                leadIdGeomap.put(l.Id, leadGeoMap.get(l));
                leadOwnerMap.put(l.Id, l.OwnerId);
                Util.setInContextOfLeadConversion();  //Old conversion method
                //Util.setInContextOfLeadConversion2(l);  //New conversion method

                Database.LeadConvert lc = new Database.LeadConvert();
                lc.setLeadId(l.Id);
                lc.setOpportunityName(l.Company);
                lc.setConvertedStatus(convertStatus.MasterLabel);
                lc.overwriteLeadSource = TRUE;
                
                try
                {
                    Database.LeadConvertResult lcr = Database.convertLead(lc);
                    if(lcr.isSuccess())
                    {
                        acctLeadConvertMap.put(lcr.getAccountId(), lcr.getLeadId());
                        oppIdsToAssign.add(lcr.getOpportunityId());            
                    }
                    else
                    {
                        System.debug(LoggingLevel.INFO, 'DealerUtility.ConvertLeadBulk: Conversion failed on creation for : ' + lcr.getErrors());
                        l.Status = 'Failed Conversion';
                        l.Lead_Conversion_Status__c = 'Failed while creating records';
                        l.IsAutoConvert__c = false;
                        leadsToUpdate.add(l);
                    }
                }
                catch(Exception error)
                {
                    System.debug(LoggingLevel.INFO, 'DealerUtility.ConvertLeadBulk: Exception thrown while converting lead: ' + error.getMessage());
                    l.Status = 'Failed Conversion';
                    l.Lead_Conversion_Status__c = 'Error when converting';
                    l.IsAutoConvert__c = false;
                    leadsToUpdate.add(l);
                }
            }
        }
        
        try {
            update leadsToUpdate;            
        }
        catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'DealerUtility.ConvertLeadBulk: Error thrown when updating failed leads.' + e.getMessage());
        }

        for(Account a : [SELECT Id, Name, OwnerId, IsAddressUpdated__c, Geolocation__Longitude__s, Geolocation__Latitude__s FROM Account WHERE id IN :acctLeadConvertMap.keySet()])
        {
            a.Geolocation__Latitude__s = leadIdGeomap.get(acctLeadConvertMap.get(a.Id)).Lat;
            a.Geolocation__Longitude__s = leadIdGeomap.get(acctLeadConvertMap.get(a.Id)).Lon;
            a.IsAddressUpdated__c = FALSE;        
            String cleanName = a.Name;
            cleanName = cleanName.Replace(string.valueOf(system.today()), '');
            a.Name = cleanName;
            a.OwnerId = leadOwnerMap.get(acctLeadConvertMap.get(a.Id));
            accountsToUpdate.add(a);  
        }

        try {  
            update accountsToUpdate;

            AutoAssignBulk(oppIdsToAssign);
        }
        catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'DealerUtility.ConvertLeadBulk: Error thrown while updating accounts and assigning opportunities. ' + e.getMessage());
        }
        return oppIdsToAssign;
    }
    
    public Static void updateContactRole(Set <Id> oppIds){
        list<OpportunityContactRole> listOpportunityContactRole = new list<OpportunityContactRole>();
        for(OpportunityContactRole objOpportunityContactRole :[Select id from OpportunityContactRole where OpportunityId in: oppIds]){
            objOpportunityContactRole.IsPrimary= true;
            objOpportunityContactRole.Role= 'Borrower';
            listOpportunityContactRole.add(objOpportunityContactRole);
        }
        update listOpportunityContactRole;
    }
    
public static void ConvertLead(Lead l, GeocodeAsyncHandler.GeoInfo info) 
{
            
            //Is the ALR process active?
            if (isALREnabled() == false) return;
            
            String companyName = '';
            String originalLeadId = l.Id;
            String originalLeadOwnerId = l.OwnerId;
            
            //System.debug(('@@@@@ConvertLead ' + l);
            //System.debug(('@@@@@ConvertLead; Processing: ' + originalLeadId);
            //System.debug(('@@@@@ConvertLead; isConverted: ' + l.isConverted);
            
            if (l.isConverted == true) return;

            try {
            
                   if ( l.IsAutoConvert__c == false ) return;
        
                    //System.debug(('@@@@@ConvertLead; Performing conversion');
                    Database.LeadConvert lc = new Database.LeadConvert();
                    lc.setLeadId(l.Id);          
                    
                    
                    lc.setOpportunityName(l.Company);
                    //System.debug(('@@@@@DealerUtility (SOQL); ConvertLead; SOQL from LeadStatus');
                    LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
                    lc.setConvertedStatus(convertStatus.MasterLabel);
                    lc.overwriteLeadSource = true;

                    Database.LeadConvertResult lcr = Database.convertLead(lc);
                    //System.debug(('@@@@@ConvertLead; STATUS: ' + lcr.isSuccess());
                    
                    if (lcr.isSuccess() == false) {
                            //SendEmailAlert('Failed Lead Convert Status', 'Failed ' + lcr.getErrors());
                            //System.debug(('@@@@@ConvertLead;  Failed without exception');
                            l.Status = 'Failed Conversion';
                            l.IsAutoConvert__c = false;
                            update l;
                     }
                    else
                    {
                        string s = ' Created Account ' + lcr.getAccountId() + '\r\n Created Contact ' + lcr.getContactId() + '\r\n Created Opportunity ' + lcr.getOpportunityId() + '\r\n Errors ' + lcr.getErrors();
                         
                        //System.debug(('@@@@@ConvertLead;  ' + s);
                        //System.debug(('@@@@@DealerUtility (SOQL); ConvertLead; SOQL from Account');
                        
                        Account a = [select id, Name, Geolocation__Longitude__s, Geolocation__Latitude__s from Account where id = :lcr.getAccountId() LIMIT 1];                        
                        a.Geolocation__Latitude__s = info.Lat;
                        a.Geolocation__Longitude__s = info.Lon;
                        a.IsAddressUpdated__c = false;
                        
                        String cleanName = a.Name;
                        cleanName = cleanName.Replace(string.valueOf(system.today()), '');
                        a.Name = cleanName;
                        a.OwnerId = originalLeadOwnerId;                        
                        update a;

                        AutoAssign(lcr.getOpportunityId());
 
                     }
            }
            catch (Exception ex)
            {
                //System.debug(('== Error =='+ex.getMessage());
                l = [Select id, IsConverted, IsAutoConvert__c from Lead where Id = :l.id LIMIT 1];
                
                if ( l.IsConverted == false ){
                    l.Status = 'Failed Conversion';
                    l.IsAutoConvert__c = false;
                    update l;
                }
              //System.debug(('@@@@@ConvertLead;  Failed with exception');
              /*
              try {
                    //Wrapped in a Try-Catch because the logic directly above needs to shut the Lead OFF and must succeed
                    //Long term use of this Exception Logging should be abstracted into a separate class              
                    Exception_log__c eLog = new Exception_Log__c();
                    eLog.Lead_Id__c = l.id;
                    eLog.Error_Message__c = ex.getMessage();
                    eLog.Stack_Trace__c = ex.getStackTraceString();
                    insert eLog;
              }
              catch(Exception ex2){}
              */
            }
            finally {
                //IsBatchRunning = false;
            }


}
//===================================================================

//===================================================================
public static void FixOpportunityName(list<Opportunity> listFromOpportunityBeforeInsertTrigger) {
    //RecordType RecordTypeOpportunity = [Select  r.Id, r.SobjectType, r.Name From RecordType r where sobjecttype ='Opportunity' and Name = 'Home Owner' LIMIT 1];
    Id HomeOwnerRecTypeId = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('Home Owner').RecordTypeId;
    //System.debug(('@@@@@DealerUtility.FixOpportunityName start ' + RecordTypeOpportunity);
    for (Opportunity o : listFromOpportunityBeforeInsertTrigger){
        if (o.RecordTypeId == HomeOwnerRecTypeId) {
            //System.debug(('@@@@@DealerUtility.FixOpportunityName Name Start: ' + o.Name);
            String currentName = o.Name;
            o.Name = currentName.Replace(String.valueOf(System.today()),'');
            //System.debug(('@@@@@DealerUtility.FixOpportunityName Name End: ' + o.Name);
        }
    }
}
//===================================================================

    // August 2014 - New Auto Assignment Methods

//===================================================================

    private static Map <Id, Account> buildAllDealersMap()
    {
        //This method returns a map of all Sunpower Dealers and the child objects needed for opportunity assignment

        Map <Id, Account> result = new Map <Id, Account>();

        for(Account a : [SELECT Name, Type,Account_Display_Name__c,Partner_Logo__c, Dealer_Score_Total__c, Dealer_Locator_Phone__c, Phone, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode, Opportunity_Recipient__c, Website, Oracle_Account_Number__c, Description, Partner_Facts__c, Alliance_Program_Partner__c, Dealer_Locator_Opt_Out__c, Lead_Flow_Opt_Out__c, Lead_Assignment_Count__c, Lead_Priority_Minimum__c, Lead_Priority_Maximum__c, Last_Assigned_Date__c, Priority_Assignment__c, Business_Function__c, (SELECT Geolocation__Latitude__s, Geolocation__Longitude__s, Radius__c, Account__c FROM Coverage_Areas__r WHERE Radius__c > 0), (SELECT Id FROM  Agreements__r WHERE Echosign_dev1__Status__c = 'Signed' AND Agreement_Type_2__c = 'Partner Agreement' AND Name LIKE '%Lead Handling Policy Agreement'), (SELECT Id, State__c, Country__c FROM Business_Registrations__r), (SELECT Partner__c, Enabled__c, Enable_Date__c, Disable_Date__c, Campaign__r.Type FROM Campaign_Partners__r), (SELECT Campaign__c FROM Dealer_Assignment_Audit__r WHERE Campaign__c != NULL) FROM Account WHERE Status__c = 'Active' AND (Type like '%Partner-Residential%' OR Type like '%Partner-Combo%') AND Lead_Flow_Opt_Out__c = FALSE])
        {
            result.put(a.Id, a);
        }

        System.debug(LoggingLevel.INFO, 'DealerUtility.buildAllDealersMap: '+result.size()+' dealers in dealer map.');

        return result;
    }

    private static Map <Id, Opportunity> buildOpportunityMap(Set <Id> oppIds)
    {
        Map <Id, Opportunity> result = new Map <Id, Opportunity>();

        for(Opportunity o : [SELECT id, Name, CreatedDate, AccountId, CampaignId, Dealer_Selection__c, Theater__c, OwnerId, Partner_Account_Id__c, Partner_Account_Id__r.Opportunity_Recipient__c, Account.Geolocation__Latitude__s, Account.Geolocation__Longitude__s, Lead_Manufacturer__c, Account.Partner_Account__c, Account.OwnerId, Account.BillingState, Account.BillingCountry, Account.Theater__c, RecordTypeId, Requires_Manual_Assignment__c, Campaign.Type, Campaign.AssignRandomPartner__c, Financing2__c, ALR_Assignment_Audit_Trail__c, (SELECT Dealer_Assigned__c From Dealer_Assignment_Audit__r) FROM Opportunity WHERE Id IN :oppIds AND RecordType.Name = 'Home Owner' AND Lead_Manufacturer__c = 'SunPower'])
        {
            result.put(o.Id, o);
        }

        System.debug(LoggingLevel.INFO, 'DealerUtility.buildOpportunityMap: '+result.size()+' opportunities in opportunity map.');

        return result;
    }

    private static Map <Id, Map<Id, Integer>> buildCampaignAssignmentCountMap(Map <Id, Account> dealerMap)
    {
        // This method builds a map of Campaign Ids that return a Map of Account (Dealer) IDs and the count of assignments for the campaign
        // Needs a map of Accounts and their Dealer Assignment Audit child records (Dealer_Assignment_Audit__r)

        Map <Id, Map<Id, Integer>> result = new Map <Id, Map <Id, Integer>>();

        for(Account d : dealerMap.values())
        {
            for(Dealer_Assignment_Audit__c aa : d.Dealer_Assignment_Audit__r)
            {                
                if(result.containsKey(aa.Campaign__c))
                {
                    if(result.get(aa.Campaign__c).containsKey(d.Id))
                    {
                        result.get(aa.Campaign__c).put(d.Id, result.get(aa.Campaign__c).get(d.Id)+1);
                    }
                    else
                    {
                        result.get(aa.Campaign__c).put(d.Id, 1);
                    }
                }
                else
                {
                    result.put(aa.Campaign__c, new Map <Id, Integer>());
                    result.get(aa.Campaign__c).put(d.Id, 1);
                }
            }
        }

        return result;
    }

    private static List <DealerResult> buildDealerListRaw(Map <Id, Account> dealerMap, Opportunity o, DealerGeneral__c c, String foundCampaignId, String resultType)
    {
        List <DealerResult> result = new List <DealerResult>();

        // Build the raw list, prioritize SunPower Direct Dealers first.
        //o.ALR_Assignment_Audit_Trail__c += auditUpdate('Searching Sunpower Direct Dealers below minimum.');
        result = DealerUtility.buildDealerListRawBase(dealerMap, o, c, foundCampaignId, 'SunPower Direct', TRUE, FALSE, TRUE);
        result = cleanDealerList(resultType, result);

        // If there are no SunPower Direct Dealers, prioritize the Prioritized Dealers next
        if(result.isEmpty()) 
        {
            o.ALR_Assignment_Audit_Trail__c += auditUpdate('No Sunpower Direct Dealers below minimum found.');
            result = DealerUtility.buildDealerListRawBase(dealerMap, o, c, foundCampaignId, 'Prioritized Dealer', TRUE, FALSE, TRUE);
            result = cleanDealerList(resultType, result);
        }

        // If there are no prioritized dealers still, build the raw list with all dealers that have not hit their maximum yet
        if(result.isEmpty()) 
        {
            o.ALR_Assignment_Audit_Trail__c += auditUpdate('No Prioritized Dealers below minimum found.');
            result = DealerUtility.buildDealerListRawBase(dealerMap, o, c, foundCampaignId, NULL, FALSE, TRUE, TRUE);
            result = cleanDealerList(resultType, result);
        }

        // If there are no prioritized dealers still, build the raw list with all dealers, even the ones that hit their maximum
        if(result.isEmpty()) 
        {
            o.ALR_Assignment_Audit_Trail__c += auditUpdate('All priority dealers reached their maximum.');
            result = DealerUtility.buildDealerListRawBase(dealerMap, o, c, foundCampaignId, NULL, FALSE, FALSE, TRUE);
            result = cleanDealerList(resultType, result);
        }

        // For Finance Opportunities in Australia, they can be assigned to any dealer if the dealer list is still empty, so we must attempt to populate the list with any/all dealers
        //if(o.Theater__c == 'Australia' && o.Financing2__c == 'Loan' && result.isEmpty())
        //{
        //    // Build the raw list, prioritize SunPower Direct Dealers first.
        //    result = DealerUtility.buildDealerListRawBase(dealerMap, o, c, foundCampaignId, 'SunPower Direct', TRUE, TRUE, FALSE);

        //    // If there are no SunPower Direct Dealers, prioritize the Prioritized Dealers next
        //    if(result.isEmpty()) 
        //    {
        //        result = DealerUtility.buildDealerListRawBase(dealerMap, o, c, foundCampaignId, 'Prioritized Dealer', TRUE, TRUE, FALSE);
        //    }

        //    // If there are no prioritized dealers still, build the raw list with all dealers that have not hit their maximum yet
        //    if(result.isEmpty()) 
        //    {
        //        result = DealerUtility.buildDealerListRawBase(dealerMap, o, c, foundCampaignId, NULL, FALSE, TRUE, FALSE);
        //    }

        //    // If there are no prioritized dealers still, build the raw list with all dealers, even the ones that hit their maximum
        //    if(result.isEmpty()) 
        //    {
        //        result = DealerUtility.buildDealerListRawBase(dealerMap, o, c, foundCampaignId, NULL, FALSE, FALSE, FALSE);
        //    }
        //}

        return result;
    }


    private static List <DealerResult> buildDealerListRawBase(Map <Id, Account> dealerMap, Opportunity o, DealerGeneral__c c, String foundCampaignId, String dealerPriority, Boolean useDealerMin, Boolean useDealerMax, Boolean omitFinancePartners)
    {
        List <DealerResult> result = new List <DealerResult>();
        Set <Id> dealersAlreadyIncluded = new Set <Id>();

        for(Account dealer : dealerMap.values())
        {
            Boolean isCampaignPartner = FALSE;
            Boolean isAllianceCampaignPartner = FALSE;
            Boolean signedAgreement = FALSE;
            Boolean hasValidCoverageAreas = FALSE;
            Boolean isRegistered = FALSE;
            Boolean isPriorityDealer = FALSE;
            Boolean isFinancePartner = TRUE; // By default, this is set to TRUE
            useDealerMin = (useDealerMin == NULL) ? FALSE : useDealerMin;
            useDealerMax = (useDealerMax == NULL) ? FALSE : useDealerMax;

            //// If this opportunity is for lease or loan, omit the dealer if they do not offer the appropriate finance options - Australia ONLY
            //if(omitFinancePartners)
            //{
            //    if(o.Theater__c == 'Australia' && dealer.Business_Function__c != NULL && (o.Financing2__c == 'Lease' && !dealer.Business_Function__c.contains('Lease') || o.Financing2__c == 'Loan' && !dealer.Business_Function__c.contains('Loan'))) isFinancePartner = FALSE;
            //}

            //if(isFinancePartner)
            //{
                // Mark this dealer as a prioritized dealer by default, or if they have a matching priority assignment
                if(dealerPriority == NULL || dealerPriority == '' || dealerPriority == dealer.Priority_Assignment__c)
                {
                    isPriorityDealer = TRUE;
                } 

                // remove them from the prioritized list if they already hit their minimum
                if(isPriorityDealer)
                {
                    if(useDealerMin)
                    {
                        Decimal dealerAssignmentCount = 0;
                        if(dealer.Last_Assigned_Date__c == system.today() && dealer.Lead_Assignment_Count__c != NULL) dealerAssignmentCount = dealer.Lead_Assignment_Count__c;
                        
                        if(dealer.Lead_Priority_Minimum__c == NULL || dealerAssignmentCount >= dealer.Lead_Priority_Minimum__c) {
                            isPriorityDealer = FALSE;
                        }
                    }
                }

                // remove them from the prioritized list if they already hit their maximum
                if(isPriorityDealer)
                {
                    if(useDealerMax)
                    {
                        Decimal dealerAssignmentCount = 0;
                        if(dealer.Last_Assigned_Date__c == system.today() && dealer.Lead_Assignment_Count__c != NULL) dealerAssignmentCount = dealer.Lead_Assignment_Count__c;
                        
                        if(dealer.Lead_Priority_Maximum__c == NULL || dealerAssignmentCount >= dealer.Lead_Priority_Maximum__c) isPriorityDealer = FALSE;
                    }
                }

                if(isPriorityDealer)
                {
                    for(Campaign_Partner__c cp : dealer.Campaign_Partners__r)
                    {
                        if(foundCampaignId == NULL || (cp.Enabled__c && cp.Campaign__c == foundCampaignId))
                        {
                            isCampaignPartner = TRUE;
                            isAllianceCampaignPartner = (cp.Campaign__r.Type == 'Alliance');
                        }
                    }

                    // check the signed agreements and set flag to true, and exit the loop if one is found
                    for(echosign_dev1__SIGN_Agreement__c agreement : dealer.Agreements__r)
                    {
                        signedAgreement = TRUE;
                        break;
                    }
                    
                    // check for valid coverage areas based on signed agreement enforcements
                    for(CoverageArea__c coverageArea : dealer.Coverage_Areas__r)
                    {
                        if(c.Enforce_Agreement_Check_Dealer_Search__c)
                        {
                            if(signedAgreement)
                            {
                                hasValidCoverageAreas = TRUE;
                                break;
                            }
                        }
                        else 
                        {
                            hasValidCoverageAreas = TRUE;
                            break;
                        }
                    }

                    if(hasValidCoverageAreas)
                    {                    
                        // check to make sure dealer is registered in state/country of opportunity
                        for(Business_Registration__c br : dealer.Business_Registrations__r)
                        {
                            if(o.Account.BillingState != NULL && o.Account.BillingState != '' && o.Account.BillingCountry == 'United States')
                            {
                                if(o.Account.BillingState == br.State__c && o.Account.BillingCountry == br.Country__c)
                                {
                                    isRegistered = TRUE;
                                    break;
                                }
                            }
                            else if(o.Account.BillingCountry != 'United States')
                            {
                                if(o.Account.BillingCountry == br.Country__c)
                                {
                                    isRegistered = TRUE;
                                    break;
                                }
                            }
                        }
                    }

                    if(isRegistered)
                    {
                        for(CoverageArea__c coverageArea : dealer.Coverage_Areas__r)
                        {
                            if(dealersAlreadyIncluded.contains(coverageArea.Account__c))
                            {
                                continue;
                            }
                            else
                            {
                                Decimal distance = DealerUtility.getDistance(o.Account.Geolocation__Latitude__s, o.Account.Geolocation__Longitude__s, coverageArea.Geolocation__Latitude__s, coverageArea.Geolocation__Longitude__s, 'mi');
                                if(distance <= coverageArea.Radius__c)
                                {
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
            //}        
        }
        o.ALR_Assignment_Audit_Trail__c += auditUpdate(result.size() + ' Dealers found.');
        for(DealerResult dr : result) {
            o.ALR_Assignment_Audit_Trail__c += auditUpdate(dr.AccountName + ' isCampaignPartner: ' + dr.isCampaignPartner);
        }
        return result;
    }

    private static void buildDealerAssignmentAudit(Dealer_Assignment_Audit__c daa, string Name, Id AccountId, Id OpportunityId, String Reason, String RuleApplied)
    {
        daa.Name                                = Name;
        daa.Dealer_Assigned__c              = AccountId;
        daa.Opportunity__c                  = OpportunityId;
        daa.Reason__c                           = Reason;
        daa.ALR_Rule_Applied__c         = RuleApplied;
        daa.Assignment_Date__c          = System.today();
    }

    private static List <DealerResult> cleanDealerList(String resultType, List <DealerResult> listDealersRaw)
    {
        // This method will return a dealer list based on the following arguments/types of dealers:
        // Campaign Partners
        // Alliance Partners
        // All (NULL)

        List <DealerResult> result = new List <DealerResult>();

        for(DealerResult dr : listDealersRaw)
        {
            System.debug('dr: ' + dr + ' resultType: ' + resultType);
            if(resultType == 'Campaign Partners') {
                if(dr.isCampaignPartner) result.add(dr);
            }
            else
            if(resultType == 'Alliance Partners') {
                if(dr.isAllianceCampaignPartner) result.add(dr);
            }
            else result.add(dr);
        }

        System.debug(LoggingLevel.INFO, 'DealerUtility.cleanDealerList: there are ' + result.size() + ' ' + resultType + ' dealers after cleaning list.');

        return result;
    }

    private static void dealerSelectionAssignment(Opportunity o, Account a, Dealer_Assignment_Audit__c daa, String DAAName, Map <Id, Account> dealerMap, DealerGeneral__c c, Map <Id, Account> accountsToUpdate)
    {
        buildDealerAssignmentAudit(daa, DAAName, NULL, o.Id, 'Dealer Locator','Dealer Locator');
        o.Partner_Account_Id__c = o.Dealer_Selection__c;
        a.Partner_Account__c = o.Partner_Account_Id__c;
        o.Dealer_Assignment_Date__c = system.now();

        // Assign Owner Id
        AssignOwnerBulk(dealerMap, c, o, a, accountsToUpdate);

        daa.Dealer_Assigned__c = o.Partner_Account_Id__c;
    }

    private static void paidCampaignAssignment(Opportunity o, Account a, Dealer_Assignment_Audit__c daa, String foundCampaignId, Map <Id, Map<Id, Integer>> assignCountMap, Map <Id, Account> dealerMap, DealerGeneral__c c, Map <Id, Account> accountsToUpdate)
    {
        daa.Reason__c = 'Round Robin Distribution';
        daa.ALR_Rule_Applied__c = 'Paid Campaign';
        daa.Campaign__c = foundCampaignId;
        List <DealerResult> listDealers = DealerUtility.buildDealerListRaw(dealerMap, o, c, foundCampaignId, 'Campaign Partners');
        o.ALR_Assignment_Audit_Trail__c += auditUpdate('listDealers size: ' + listDealers.size());
        
        if(listDealers.size() == 0) {
            o.ALR_Assignment_Audit_Trail__c += auditUpdate('list Dealers has 0 dealers. Looking for all partners.');
            listDealers = DealerUtility.buildDealerListRaw(dealerMap, o, c, foundCampaignId, NULL);
        }        
        else
        // If no dealers assigned to this campaign yet, assign at random (see ELSE statement)
        if(assignCountMap.containskey(foundCampaignId))
        {
            //If only one dealer to assign to, then they get it
            if(listDealers.size() == 1)
            {
                o.ALR_Assignment_Audit_Trail__c += auditUpdate('dealer list only has 1 dealer. Random assignment not needed.');
                o.Partner_Account_Id__c = listDealers[0].AccountId;
            }
            else // proceed to random assignment
            {
                o.ALR_Assignment_Audit_Trail__c += auditUpdate('dealer list has multiple dealers. Removing highest-assigned dealer next.');
                Set <Id> mostAssignedIds = new Set <Id>();
                Integer mostAssigned = 0;

                for(DealerResult dr : listDealers) {
                    o.ALR_Assignment_Audit_Trail__c += auditUpdate('dealer ' + dr.AccountName + ' has ' + assignCountMap.get(foundCampaignId).get(dr.AccountId) + ' assigned for campaign.');
                    if(assignCountMap.get(foundCampaignId).get(dr.AccountId) > mostAssigned)
                    {
                        mostAssigned = assignCountMap.get(foundCampaignId).get(dr.AccountId);
                    }
                }

                o.ALR_Assignment_Audit_Trail__c += auditUpdate('highest assigned was ' + mostAssigned);

                // Find out what the highest assignment count is for campaign
                for(DealerResult dr : listDealers) {
                    if(mostAssigned == assignCountMap.get(foundCampaignId).get(dr.AccountId)) {
                        o.ALR_Assignment_Audit_Trail__c += auditUpdate('' + dr.AccountName + ' has the most assigned at ' + assignCountMap.get(foundCampaignId).get(dr.AccountId) + '.');
                        mostAssignedIds.add(dr.AccountId);
                    }
                }

                // Remove dealers who match highest assignment count
                List <DealerResult> originalList = new List <DealerResult>(listDealers);
                Integer i = 0;
                while(i < listDealers.size())
                {
                    if(mostAssignedIds.contains(listDealers[i].AccountId))
                    {
                        o.ALR_Assignment_Audit_Trail__c += auditUpdate('removing ' + listDealers[i].AccountName);
                        listDealers.remove(i);
                    }
                    else {
                        i++;
                    }
                }

                if(listDealers.size() == 1)
                {
                    o.ALR_Assignment_Audit_Trail__c += auditUpdate('clean dealer list has 1 dealer. Random assignment not needed.');
                    o.Partner_Account_Id__c = listDealers[0].AccountId;
                }
                else
                if(listDealers.size() != 0)
                {
                    o.ALR_Assignment_Audit_Trail__c += auditUpdate('clean dealer list has multiple dealers. Random assignment needed.');
                    Integer randomInt = getRandomNumber(listDealers.size()-1);
                    o.Partner_Account_Id__c = listDealers[randomInt].AccountId;
                }
                else            
                if(originalList.size() != 0)
                {   
                    o.ALR_Assignment_Audit_Trail__c += auditUpdate('clean dealer list has 0 dealers. Using original list.');
                    Integer randomInt = getRandomNumber(listDealers.size()-1);
                    o.Partner_Account_Id__c = originalList[randomInt].AccountId;
                }
            }
        }
        else
        {
            o.ALR_Assignment_Audit_Trail__c += auditUpdate('Campaign Id ' + foundCampaignId + ' has not been assigned yet.');
            Integer randomInt = getRandomNumber(listDealers.size()-1);
            o.Partner_Account_Id__c = listDealers[randomInt].AccountId;
        }

        a.Partner_Account__c = o.Partner_Account_Id__c;
        o.Dealer_Assignment_Date__c = system.now();

        if (o.Partner_Account_Id__c == null) {
            o.ALR_Assignment_Audit_Trail__c += auditUpdate('Opportunity Id ' + o.Id + ' requires manual assignment.');
            o.Requires_Manual_Assignment__c = true;
        }

        AssignOwnerBulk(dealerMap, c, o, a, accountsToUpdate);
            
        daa.Dealer_Assigned__c = o.Partner_Account_Id__c;
    }

    private static void allianceCampaignAssignment(Opportunity o, Account a, Dealer_Assignment_Audit__c daa, String foundCampaignId, Map <Id, Account> dealerMap, DealerGeneral__c c, Map <Id, Account> accountsToUpdate)
    {
        List <DealerResult> listDealers = DealerUtility.buildDealerListRaw(dealerMap, o, c, foundCampaignId, 'Alliance Partners');
        if(listDealers.size() == 0) listDealers = DealerUtility.buildDealerListRaw(dealerMap, o, c, foundCampaignId, NULL);

        daa.Reason__c = 'Weighted Score Distribution';
        daa.ALR_Rule_Applied__c = 'Alliance Campaign';
        daa.Campaign__c = foundCampaignId;
        o.Partner_Account_Id__c = GetSingleDealerBasedOnWeightedScore(listDealers, daa);
        a.Partner_Account__c = o.Partner_Account_Id__c;
        o.Alliance_Program_Lead__c = true;
        o.Dealer_Assignment_Date__c = system.now();

        if(o.Partner_Account_Id__c == NULL) o.Requires_Manual_Assignment__c = true;
          
        // Assign Owner Id                  
        AssignOwnerBulk(dealerMap, c, o, a, accountsToUpdate);

        daa.Dealer_Assigned__c = o.Partner_Account_Id__c;  
    }

    private static void nonPaidCampaignAssignment(Opportunity o, Account a, Dealer_Assignment_Audit__c daa, String foundCampaignId, Map <Id, Account> dealerMap, DealerGeneral__c c, Map <Id, Account> accountsToUpdate)
    {
        List <DealerResult> listDealers = DealerUtility.buildDealerListRaw(dealerMap, o, c, foundCampaignId, 'Campaign Partners');
        if(listDealers.size() == 0) listDealers = DealerUtility.buildDealerListRaw(dealerMap, o, c, foundCampaignId, NULL);
          
        daa.Reason__c                           = 'Weighted Score Distribution';
        daa.ALR_Rule_Applied__c         = 'Non-Paid Campaign';
        daa.Campaign__c                     = foundCampaignId;
        o.Partner_Account_Id__c             = GetSingleDealerBasedOnWeightedScore(listDealers, daa);
        a.Partner_Account__c                = o.Partner_Account_Id__c;
        o.Dealer_Assignment_Date__c = system.now();

        // Assign Owner Id
        AssignOwnerBulk(dealerMap, c, o, a, accountsToUpdate);
                                
        daa.Dealer_Assigned__c = o.Partner_Account_Id__c;   
    }

    private static void reassignmentTry(Opportunity o, Account a, Dealer_Assignment_Audit__c daa, String DAAName, List <DealerResult> listDealers, Map <Id, Account> dealerMap, DealerGeneral__c c, Map <Id, Account> accountsToUpdate)
    {  
        o.Partner_Account_Id__c = GetSingleDealerBasedOnWeightedScore(listDealers, daa);
        a.Partner_Account__c = o.Partner_Account_Id__c;
        o.Dealer_Assignment_Date__c = system.now();

        if (o.CampaignId != null) buildDealerAssignmentAudit(daa, DAAName, null, o.Id,  'Weighted Score Distribution','All Partners' );
        else buildDealerAssignmentAudit(daa, DAAName, null, o.Id,  'Weighted Score Distribution','Generic Lead');

        // Assign Owner Id
        AssignOwnerBulk(dealerMap, c, o, a, accountsToUpdate);
        
        daa.Dealer_Assigned__c = o.Partner_Account_Id__c;
    }

    private static void failedAssignment(Opportunity o, Dealer_Assignment_Audit__c daa, String DAAName)
    {
        o.Requires_Manual_Assignment__c = true;
        o.Dealer_Assignment_Status__c = 'Failed Assignment - No Dealers Found';

        buildDealerAssignmentAudit(daa, DAAName, null, o.Id, 'Requires Manual Assignment','');
    }

    private static void successfulAssignment(Opportunity o, List <Dealer_Notification__c> dealerNotificationList)
    {
        o.Dealer_Assignment_Status__c = 'Dealer Assigned';

        //Create Dealer Notification for Text on OpportunityAssignment
        Dealer_Notification__c dealerNotification = new Dealer_Notification__c(RelatedObjectId__c = o.Id, Type__c = 'Text', Activity__c = 'OpportunityAssignment', isSent__c = false, sendTo__c = o.OwnerId);
        dealerNotificationList.add(dealerNotification);
    }

    private static void finalizeAssignment(Opportunity o, Account a, Dealer_Assignment_Audit__c daa, Map <Id, Account> accountsToUpdate, Map <Id, Dealer_Assignment_Audit__c> oppDaaMap, List <DealerResult> listDealers, Map <Id, List<Eligible_Dealer__c>> oppEligibleDealersMap)
    {
        if (a.Partner_Account__c != null) accountsToUpdate.put(a.Id, a);

        oppDaaMap.put(o.Id, daa);                          
            
        for (DealerResult r : listDealers) 
        {
            Eligible_Dealer__c ed                       = new Eligible_Dealer__c();
            ed.Name                                         = r.AccountName.left(80);
            ed.Dealer__c                                    = r.AccountId;
            ed.Score__c                                     = (r.Score != null ? r.Score : 0);
            ed.Distance__c                                  = r.Distance;
            ed.Selected__c                                  = (r.AccountId ==daa.Dealer_Assigned__c ? true : false);

            List <Eligible_Dealer__c> nList = (oppEligibleDealersMap.containsKey(o.Id)) ? oppEligibleDealersMap.get(o.Id) : new List <Eligible_Dealer__c>();

            nList.add(ed);

            oppEligibleDealersMap.put(o.Id, nList);
        }    
    }

    private static void updateEligibleDealerList(Map <Id, Opportunity> opportunityMap, Map <Id, Dealer_Assignment_Audit__c> oppDaaMap, Map <Id, List<Eligible_Dealer__c>> oppEligibleDealersMap, List <Eligible_Dealer__c> elligibleDealerList)
    {
        for(Opportunity o : opportunityMap.values())
        {
            if(oppDaaMap.containsKey(o.Id) && oppEligibleDealersMap.containsKey(o.Id))
            {
                for(Eligible_Dealer__c ed : oppEligibleDealersMap.get(o.Id))
                {
                    Id daaId = oppDaaMap.get(o.Id).Id;
                    ed.Dealer_Assignment_Audit__c = daaId;
                    elligibleDealerList.add(ed);
                }
            }
        }
    }

    public static void AutoAssignBulk(Set <Id> oppIds)
    {
        if(!isALREnabled())
        {
            return;
        }
        else
        {
            Map <Id, Opportunity> opportunityMap = buildOpportunityMap(oppIds);
            List <Opportunity> oppsToUpdate = new List <Opportunity>();
            DealerGeneral__c c = DealerGeneral__c.getInstance();
            Map <Id, Account> dealerMap = buildAllDealersMap();
            Map <Id, Map<Id, Integer>> assignCountMap = buildCampaignAssignmentCountMap(dealerMap);
            List <Dealer_Notification__c> dealerNotificationList = new List <Dealer_Notification__c>();
            List <Eligible_Dealer__c> elligibleDealerList = new List <Eligible_Dealer__c>();
            Map <Id, Dealer_Assignment_Audit__c> oppDaaMap = new Map <Id, Dealer_Assignment_Audit__c>();
            Map <Id, List<Eligible_Dealer__c>> oppEligibleDealersMap = new Map <Id, List<Eligible_Dealer__c>>();
            Map <Id, Account> accountsToUpdate = new Map <Id, Account>();        

            for(Opportunity o : opportunityMap.values())
            { 
                system.debug(LoggingLevel.INFO,'OPP DEALER SELECTION FIELD: ' + o.Dealer_Selection__c);
                o.ALR_Assignment_Audit_Trail__c = '';
                if (ALR_Theaters__c.getInstance(o.Account.Theater__c) == NULL) 
                {
                    System.debug(LoggingLevel.INFO, 'DealerUtility.AutoAssignBulk: Invalid Theater for Opportunity');
                    o.ALR_Assignment_Audit_Trail__c += auditUpdate('Invalid Theater for ALR.');
                    continue;
                }
                else
                {
                    List <DealerResult> listDealers = new List <DealerResult>();
                    List <DealerResult> listDealersRaw = new List <DealerResult>();
                    List <Dealer_Assignment_Audit__c> listPrevious = new List <Dealer_Assignment_Audit__c>();
                    Dealer_Assignment_Audit__c daa = new Dealer_Assignment_Audit__c();
                    String additionalInfo = ''; 
                    Boolean bREASSIGN = (o.Partner_Account_Id__c != null);
                    Integer DAACount = 1;   
                    String DAAName = '';
                    Account a = new Account(Id=o.AccountId);       

                    o.IsAutoAssign__c = FALSE;
                    
                    if (o.Account.Geolocation__Latitude__s == null) 
                    {
                        System.debug(LoggingLevel.INFO, 'DealerUtility.AutoAssignBulk: No geolocation on Account');
                        o.ALR_Assignment_Audit_Trail__c += auditUpdate('No geolocation on Account.');
                        o.Dealer_Assignment_Status__c = 'Failed Assignment - Invalid Geolocation';
                        oppsToUpdate.add(o);                
                        if (!Test.isRunningTest()) continue;
                    }
                    
                    if (bREASSIGN) 
                    {
                        System.debug(LoggingLevel.INFO, 'DealerUtility.AutoAssignBulk: Is Reassign Opportunity');
                        o.ALR_Assignment_Audit_Trail__c += auditUpdate('Is Reassign Opportunity.');
                        listPrevious = o.Dealer_Assignment_Audit__r;
                        o.Requires_Manual_Assignment__c = false;     
                        DAACount += listPrevious.Size();
                    }

                    DAAName = 'Dealer Assignment ' +  String.valueOf(DAACount);

                    if(o.Dealer_Selection__c != NULL && !bREASSIGN) 
                    {                    
                        o.ALR_Assignment_Audit_Trail__c += auditUpdate('Dealer selection - ' + o.Dealer_Selection__c);
                        dealerSelectionAssignment(o, a, daa, DAAName, dealerMap, c, accountsToUpdate);
                    }
                    else 
                    if(o.CampaignId != NULL) 
                    {        
                        o.ALR_Assignment_Audit_Trail__c += auditUpdate('Campaign Assignment - ' + o.Id);
                        Id foundCampaignId = o.CampaignId;
                        buildDealerAssignmentAudit(daa, DAAName, NULL, o.Id, '','');
                         
                        // If it's a paid campaign
                        if(o.Campaign.AssignRandomPartner__c == TRUE)   
                        {                    
                            o.ALR_Assignment_Audit_Trail__c += auditUpdate('Is Paid Campaign');
                            additionalInfo = 'Paid Campaign';
                            paidCampaignAssignment(o, a, daa, foundCampaignId, assignCountMap, dealerMap, c, accountsToUpdate);
                        } 
                        else
                        // If it's an Alliance Campaign 
                        if(o.Campaign.Type == 'Alliance') 
                        {   
                            o.ALR_Assignment_Audit_Trail__c += auditUpdate('Is Alliance Campaign');
                            //First we try to use one of the Campaign Partners on the Campaign
                            //Second we use some who can service the Lead and has Alliance Partner checked.
                            
                            additionalInfo = 'Alliance Campaign';
                            
                            allianceCampaignAssignment(o, a, daa, foundCampaignId, dealerMap, c, accountsToUpdate); 
                        }
                        else 
                        {                                              
                            o.ALR_Assignment_Audit_Trail__c += auditUpdate('Is Non-Paid Campaign');
                            additionalInfo = 'Non-Paid Campaign';

                            nonPaidCampaignAssignment(o, a, daa, foundCampaignId, dealerMap, c, accountsToUpdate);             
                        }             
                    }

                    // Try to reassign the dealer with a less restrictive dealer list
                    if((o.Partner_Account_Id__c == null || bREASSIGN) && o.Requires_Manual_Assignment__c == false) 
                    {                                       
                        o.ALR_Assignment_Audit_Trail__c += auditUpdate('Dealer not assigned. Attempting to retry.');
                        // Build the raw list again
                        listDealers = DealerUtility.buildDealerListRaw(dealerMap, o, c, NULL, NULL);                   
                        reassignmentTry(o, a, daa, DAAName, listDealers, dealerMap, c, accountsToUpdate);
                    }
                
                    if (o.Partner_Account_Id__c == null) 
                    {
                        o.ALR_Assignment_Audit_Trail__c += auditUpdate('Dealer not assigned. Failed.');
                        // Mark as failed assignment if a dealer is not assigned by now
                        failedAssignment(o, daa, DAAName);
                    }  
                    else 
                    {
                        successfulAssignment(o, dealerNotificationList);
                    }

                    finalizeAssignment(o, a, daa, accountsToUpdate, oppDaaMap, listDealers, oppEligibleDealersMap);   
                }
            }

            if (dealerNotificationList.size() > 0) insert dealerNotificationList;
            if (opportunityMap.size() > 0) update opportunityMap.values();
            if (accountsToUpdate.size() > 0) update accountsToUpdate.values();
            if (oppDaaMap.values().size() > 0) insert oppDaaMap.values();
            
            // update the Eligible Dealer parent ids before inserting 
            updateEligibleDealerList(opportunityMap, oppDaaMap, oppEligibleDealersMap, elligibleDealerList);

            if (elligibleDealerList.size() > 0) insert elligibleDealerList;
        }
    }

    public static void AssignOwnerBulk(Map <Id, Account> dealerMap, DealerGeneral__c dealerSetting, Opportunity opp, Account acct, Map <Id, Account> dealersToUpdate)
    {
        if(opp.Partner_Account_Id__c == NULL)
        {
            if (dealerSetting.Default_Owner_of_Opportunities_Id__c != NULL && dealerSetting.Default_Owner_of_Opportunities_Id__c != '') 
            {
                opp.OwnerId = dealerSetting.Default_Owner_of_Opportunities_Id__c;
                acct.OwnerId = dealerSetting.Default_Owner_of_Opportunities_Id__c;
            }
            else 
            {
                try 
                {
                    SendEmailAlert('ALR - Dealer missing Opportunity Recipient ', 'During the Automatic conversion of a Lead an Opportunity (' + opp.Id + ') and an ' +
                       ' Account (' + acct.Id + ') were created. This Opportunity and Account need to have is Owner set to the Opportunity Recipient of the Dealer (' + opp.Partner_Account_Id__c+ ') however it was blank.');
                } 
                catch(Exception e)
                {

                }
            }

        }
        else
        {
            if(dealerMap.containsKey(opp.Partner_Account_Id__c) && dealerMap.get(opp.Partner_Account_Id__c).Opportunity_Recipient__c != NULL)
            {
                Account dealer = dealerMap.get(opp.Partner_Account_Id__c);
                opp.OwnerId = dealer.Opportunity_Recipient__c;
                acct.OwnerId = dealer.Opportunity_Recipient__c;

                if(dealersToUpdate.containskey(opp.Partner_Account_Id__c))
                {
                    dealer = dealersToUpdate.get(opp.Partner_Account_Id__c);
                }
                else dealer = dealerMap.get(opp.Partner_Account_Id__c);

                if(dealer.Last_Assigned_Date__c == system.today())
                {
                    if(dealer.Lead_Assignment_Count__c == NULL)
                    {
                        dealer.Lead_Assignment_Count__c = 1;
                    }
                    else dealer.Lead_Assignment_Count__c += 1;

                    dealer.Last_Assigned_Date__c = system.today();
                }
                else
                {
                    dealer.Lead_Assignment_Count__c = 1;
                    dealer.Last_Assigned_Date__c = system.today();
                }

                dealersToUpdate.put(opp.Partner_Account_Id__c, dealer);
            }
            else
            {
                if (dealerSetting.Default_Owner_of_Opportunities_Id__c != NULL && dealerSetting.Default_Owner_of_Opportunities_Id__c != '')
                {
                    Account dealer = dealerMap.get(opp.Partner_Account_Id__c);
                    opp.OwnerId = dealerSetting.Default_Owner_of_Opportunities_Id__c;
                    acct.OwnerId = dealerSetting.Default_Owner_of_Opportunities_Id__c;

                    if(dealersToUpdate.containskey(opp.Partner_Account_Id__c))
                    {
                        dealer = dealersToUpdate.get(opp.Partner_Account_Id__c);
                    }
                    else dealer = dealerMap.get(opp.Partner_Account_Id__c);
                    
                    //MAM 09.DEC.2014 case 00407201 - check if the dealer is null to avoid getting Attempt to de-reference a null object error
                    if(dealer != null) //ensure that the dealer Account has a reference value before performing any changes
                    {
                        dealer.Lead_Assignment_Count__c = dealer.Lead_Assignment_Count__c == NULL ? 1 : dealer.Lead_Assignment_Count__c++ ;
                        dealer.Last_Assigned_Date__c = system.today();
                        dealersToUpdate.put(opp.Partner_Account_Id__c, dealer);
                    }
                    //MAM 09.DEC.2014 end
                }
                else 
                {
                    try 
                    {
                        SendEmailAlert('ALR - Dealer missing Opportunity Recipient ', 'During the Automatic conversion of a Lead an Opportunity (' + opp.Id + ') and an ' +
                           ' Account (' + acct.Id + ') were created. This Opportunity and Account need to have is Owner set to the Opportunity Recipient of the Dealer (' + opp.Partner_Account_Id__c+ ') however it was blank.');
                    } 
                    catch(Exception e)
                    {

                    }
                }
            }
        }
    }

    private static String auditUpdate(String audit) {
        String result = audit;
        result += '\r\n';
        return result;
    }


//===================================================================

//===================================================================

public static void AutoAssign(list<Opportunity> listOpportunityIds) {

/*
    if (listOpportunityIds.size() == 1) {
        if (o.Lead_Manufacturer__c == 'SunPower') AutoAssign(o.id);
    }
    else (listOpportunityIds.size() > 1) {
        
    }
*/      
/*
    if (listOpportunityIds.size() == 1) 
            if (listOpportunityIds[0].Lead_Manufacturer__c == 'SunPower') AutoAssign(listOpportunityIds[0].id);
*/

    for (Opportunity o : listOpportunityIds)        
        if (o.Lead_Manufacturer__c == 'SunPower') AutoAssign(o.id);
}
//===================================================================

//===================================================================
public static void AutoAssign(Id OpportunityId) {
       String additionalInfo = '';
       
        //Is the ALR process active?
        if (isALREnabled() == false) return;
               
        list<DealerResult> listDealers                  = new list<DealerResult>();
        list<DealerResult> listDealersRaw           = new list<DealerResult>();
        Dealer_Assignment_Audit__c daa          = new Dealer_Assignment_Audit__c();

        Id newOwnerId;
        
        Opportunity oFailUpdateOpportunity = new Opportunity(id=OpportunityId);
        
        System.debug('@@@@@AutoAssign  Request to process Opportunity Id: ' + OpportunityId);               
        System.debug('@@@@@DealerUtility (SOQL) AutoAssign SOQL from Opportunity');
        
        //Using a list now because the RecordType.Name = 'Home Owner' could end up not getting a match on OpportunityId
        list<Opportunity> listOpps = [select id, Name, CreatedDate, AccountId, CampaignId, Dealer_Selection__c, OwnerId, Partner_Account_Id__c, 
                         Account.Geolocation__Latitude__s, Account.Geolocation__Longitude__s, Lead_Manufacturer__c,
                         Account.Partner_Account__c, Account.OwnerId,
                         Account.BillingState, Account.BillingCountry, Account.Theater__c, RecordTypeId, Requires_Manual_Assignment__c 
                         from Opportunity where id = :OpportunityId 
                         and RecordType.Name = 'Home Owner' LIMIT 1];

        if (listOpps.size() == 0) return;
        
        Opportunity o = listOpps[0];
        
        //System.debug('@@@@@AutoAssign  Opportunity: ' + o);

       if (o.Lead_Manufacturer__c != 'SunPower') {
            System.debug('@@@@@AutoAssign  Lead Manufacturer is not set to SunPower.');
            return;
        }
        System.debug('@@@@@AutoAssign  Opportunity Id: ' + OpportunityId + '; Checking Lead Manufacturer PASSED');
        
        System.debug('@@@@@DealerUtility (SOQL) AutoAssign SOQL from Account');  
        
        //Account a = [select id, Partner_Account__c, OwnerId from Account where id = :o.AccountId Limit 1];
        Account a = new Account(Id=o.AccountId);            
            
        try {
            o.IsAutoAssign__c = false; 
            
            System.debug('@@@@@DealerUtility (SOQL) AutoAssign SOQL from RecordType');
            
            //MUST BE FOR A SPECIFIC COUNTRY
            String validCountries = 'Europe,North America,Central America and the Caribbean';
            
            if ( !validCountries.contains(o.Account.Theater__c) ) return;  
            //System.debug(('@@@@@AutoAssign;  Opportunity Id: ' + OpportunityId + '; Checking Country PASSED');
            
           //MUST NOT HAVE A DEALER ASSIGNED ALREADY
           //REASSIGN if (o.Partner_Account_Id__c != null) return;
           //REASSIGN system.debug('@@@@@AutoAssign;  Opportunity Id: ' + OpportunityId + '; Checking a Dealer was not assigned already PASSED');
          
 
           
            
            if (o.Account.Geolocation__Latitude__s == null) {
                //System.debug(('@@@@@AutoAssign;  GeoLocation information has not been set on the Account. Unable to Assign Dealer.');
                o.Dealer_Assignment_Status__c = 'Failed Assignment - Invalid Geolocation';
                update o;
                if (!Test.isRunningTest()) return;
            }
            
            boolean bREASSIGN = (o.Partner_Account_Id__c != null);  
            integer DAACount = 1;   
            String DAAName = '';       
            list<Dealer_Assignment_Audit__c> listPrevious = new list<Dealer_Assignment_Audit__c>();
            
            if (bREASSIGN) {
                listPrevious = GetPreviouslyAssignedDealers(OpportunityId);
                o.Requires_Manual_Assignment__c = false;     
                DAACount += listPrevious.Size();
            }
            
            DAAName = 'Dealer Assignment ' +  String.valueOf(DAACount);
            
            System.debug('@@@@@AutoAssig  Opportunity Id: ' + OpportunityId + ' Checking latitude PASSED');
             
            if (o.Dealer_Selection__c != null && !bREASSIGN) {        //***Dealer Selection Lead***
                daa = ConfigureDealerAssignmentAudit(DAAName, null, o.Id, 'Dealer Locator','Dealer Locator');
                o.Partner_Account_Id__c = o.Dealer_Selection__c;
                a.Partner_Account__c = o.Partner_Account_Id__c;
                o.Dealer_Assignment_Date__c = system.now();
                     
                AssignOwner(listDealersRaw, a, o);
                daa.Dealer_Assigned__c = o.Partner_Account_Id__c;
            }
            else if (o.CampaignId != null) {
        
                    Id foundCampaignId = o.CampaignId;
                    //System.debug(('@@@@@AutoAssign;  Using CampaingId: ' + foundCampaignId );
                    //System.debug(('@@@@@DealerUtility (SOQL); AutoAssign; SOQL from Campaign');
                    Campaign c = [select Type, AssignRandomPartner__c,  (select id, name, Partner__c from campaign_partners__r)  from Campaign where id = :foundCampaignId LIMIT 1];
                    
                    boolean bisPaidCampaign         = isPaidCampaign(c);
                    boolean bisAllianceCampaign = isAllianceCampaign(c);
                    daa                                     = ConfigureDealerAssignmentAudit(DAAName, null, o.Id, '','');

                    listDealersRaw                      = getDealersForAssignmentWithoutGeoCode(o.Account.Geolocation__Latitude__s, o.Account.Geolocation__Longitude__s,
                                                                                                                                     o.Account.BillingState, o.Account.BillingCountry);
                    
                    system.debug('## 1 ## listDealersRaw '+listDealersRaw.size());
                    
                    //Remove previously assigned IF this is a reassignment
                    if (bREASSIGN) listDealersRaw = RemovePreviousDealers(listDealersRaw, listPrevious);

                    //System.debug(('@@@@@AutoAssign;  Campaign logic. Dealers found that could possibly service the lead: ' + listDealersRaw.size());
                     
                    if (bisPaidCampaign == true)   {          //***Paid Campaign***           
                        //System.debug(('@@@@@AutoAssign;  Paid Campaign');
                        additionalInfo                          =    'Paid Campaign';
                        listDealers                                 = findCampaignDealers(listDealersRaw, foundCampaignId);
                        
                        system.debug('## 2 ## listDealers '+listDealers.size());
                        daa.Reason__c                           = 'Round Robin Distribution';
                        daa.ALR_Rule_Applied__c         = 'Paid Campaign';
                        daa.Campaign__c                     = foundCampaignId;
                        o.Partner_Account_Id__c             = GetSingleDealerBasedOnRandomEvenDistribution(listDealers, daa, foundCampaignId);
                        a.Partner_Account__c                = o.Partner_Account_Id__c;
                        o.Dealer_Assignment_Date__c = system.now();
                        
                        if (o.Partner_Account_Id__c == null) {
                            o.Requires_Manual_Assignment__c = true;
                        }
                        else {
                            AssignOwner(listDealersRaw, a, o);
                            daa.Dealer_Assigned__c = o.Partner_Account_Id__c;
                        }
                    } 
                    else if (bisAllianceCampaign == true) {    //***Alliance Campaign***
                        //System.debug(('@@@@@AutoAssign;  Alliance Campaign');
                        //First we try to use one of the Campaign Partners on the Campaign
                        //Second we use some who can service the Lead and has Alliance Partner checked.
                        
                        additionalInfo                              =    'Alliance Campaign';
                        
                        listDealers                                 =  findAllianceCampaignDealers(listDealersRaw, c);
                        
                        if (listDealers.size()  == 0 )
                            listDealers                            = findAllianceDealers(listDealersRaw);
                            
                        daa.Reason__c                               = 'Weighted Score Distribution';
                        daa.ALR_Rule_Applied__c             = 'Alliance Campaign';
                        daa.Campaign__c                         = foundCampaignId;
                        o.Partner_Account_Id__c                 = GetSingleDealerBasedOnWeightedScore(listDealers, daa);
                        a.Partner_Account__c                    = o.Partner_Account_Id__c;
                        o.Alliance_Program_Lead__c          = true; //10.03.13 per Paul and Dia
                        o.Dealer_Assignment_Date__c = system.now();
                            
                        if (o.Partner_Account_Id__c == null) {
                            o.Requires_Manual_Assignment__c = true;                
                        }
                        else {
                            AssignOwner(listDealersRaw, a, o);
                            daa.Dealer_Assigned__c = o.Partner_Account_Id__c;
                        }
                        
                    }
                    else {                                              //***Non-Paid Campaign*** 
                        //System.debug(('@@@@@AutoAssign;  Non-Paid Campaign');
                        listDealers                                     = findCampaignDealers(listDealersRaw, foundCampaignId);
                        if (listDealers.size() > 0) {
                            additionalInfo                          =    'Non-Paid Campaign';
                            daa.Reason__c                           = 'Weighted Score Distribution';
                            daa.ALR_Rule_Applied__c         = 'Non-Paid Campaign';
                            daa.Campaign__c                     = foundCampaignId;
                            o.Partner_Account_Id__c             = GetSingleDealerBasedOnWeightedScore(listDealers, daa);
                            a.Partner_Account__c                = o.Partner_Account_Id__c;
                            o.Dealer_Assignment_Date__c = system.now();
                            
                            AssignOwner(listDealersRaw, a, o);
                            
                            daa.Dealer_Assigned__c = o.Partner_Account_Id__c;
                        }
                        
                    }
                                        
                                    
            }
            
            system.debug('#### 1. ####o.Partner_Account_Id__c  ====>'+o.Partner_Account_Id__c);
            system.debug('#### 2. ####bREASSIGN                ====>'+bREASSIGN);
            system.debug('#### 3.Requires_Manual_Assignment__c ====>'+o.Requires_Manual_Assignment__c);
            
           //if ( (o.Partner_Account_Id__c == null || bREASSIGN) && o.Requires_Manual_Assignment__c == false )
           if ((o.Partner_Account_Id__c == null || bREASSIGN)) 
           {  //***Generic Lead***
                //System.debug(('@@@@@AutoAssign;  Generic Lead');
                listDealers = getDealersForAssignmentWithoutGeoCode(o.Account.Geolocation__Latitude__s, o.Account.Geolocation__Longitude__s,
                                                                                                                                      o.Account.BillingState, o.Account.BillingCountry);
                
                system.debug('## 3 ## listDealers ===>'+listDealers.size()+' == bREASSIGN =='+bREASSIGN);
                
                //Remove previously assigned IF this is a reassignment
                if (bREASSIGN) listDealers = RemovePreviousDealers(listDealers, listPrevious);
                
                if (o.CampaignId != null) 
                    daa = ConfigureDealerAssignmentAudit(DAAName, null, o.Id,  'Weighted Score Distribution','All Partners' );
                else
                    daa = ConfigureDealerAssignmentAudit(DAAName, null, o.Id,  'Weighted Score Distribution','Generic Lead');
                    
                o.Partner_Account_Id__c = GetSingleDealerBasedOnWeightedScore(listDealers, daa);
                a.Partner_Account__c = o.Partner_Account_Id__c;
                o.Dealer_Assignment_Date__c = system.now();
                
                AssignOwner(listDealers, a, o);
                
                daa.Dealer_Assigned__c = o.Partner_Account_Id__c;
                
           }
            
             if (o.Partner_Account_Id__c == null) {
                daa = ConfigureDealerAssignmentAudit(DAAName, null, o.Id, 'Requires Manual Assignment','');
                o.Requires_Manual_Assignment__c = true;
                o.Dealer_Assignment_Status__c = 'Failed Assignment - No Dealers Found';
             }  
             else 
             {
                 o.Dealer_Assignment_Status__c = 'Dealer Assigned';
                 o.Dealer_Selection__c =  o.Partner_Account_Id__c;

                 //Create Dealer Notification for Text on OpportunityAssignment
                 Dealer_Notification__c dealerNotification = new Dealer_Notification__c(
                     RelatedObjectId__c = o.Id, Type__c = 'Text', Activity__c = 'OpportunityAssignment',
                     isSent__c = false, sendTo__c = o.OwnerId);
                 insert dealerNotification;
                 //System.debug((LoggingLevel.INFO, '== In DealerUtility Text logged ==');
             }
             
             
             update o;
             
            if (a.Partner_Account__c!=null)
            {
                update a;
            }
            insert daa; 
            
            list<Eligible_Dealer__c> listEligibleDealers = new list<Eligible_Dealer__c>();
            
            for (DealerResult r : listDealers) {
                Eligible_Dealer__c ed                       = new Eligible_Dealer__c();
                ed.Name                                         = r.AccountName.left(80);
                ed.Dealer__c                                    = r.AccountId;
                ed.Dealer_Assignment_Audit__c           = daa.id;
                ed.Score__c                                     = (r.Score != null ? r.Score : 0);
                ed.Distance__c                                  = r.Distance;
                ed.Selected__c                                  = (r.AccountId ==daa.Dealer_Assigned__c ? true : false);
                listEligibleDealers.add(ed);
             }
            
           if (listEligibleDealers.size() > 0) insert listEligibleDealers;
             
             
                
        }
        catch (Exception ex) {
            //sangita-Dave added on 12/20
            //Long term use of this Exception Logging should be abstracted into a separate class
            /*
            try {
              Exception_log__c eLog = new Exception_Log__c();
              eLog.Account_Id__c = o.AccountId;
              eLog.Opportunity_Id__c = o.Id;
              eLog.Error_Message__c = ex.getMessage();
              eLog.Stack_Trace__c = ex.getStackTraceString();
              system.Debug('@@@@@ Failed Auto Assignment: '+ ex.getMessage() + ',' + ex.getStackTraceString());
              insert eLog;
            }
            catch(Exception ex2){}
            */
            oFailUpdateOpportunity.Requires_Manual_Assignment__c    = true;
            oFailUpdateOpportunity.IsAutoAssign__c                          = false; 
            oFailUpdateOpportunity.Dealer_Assignment_Status__c      = 'Failed Assignment';    
            update oFailUpdateOpportunity;
            
        }
               
         
}
//===================================================================

//===================================================================
public static void AssignOwner(list<DealerResult> listDealersRaw, Account a, Opportunity o) {
    //System.debug(('@@@@@AssignOwner;  start');
    
    if (Test.isRunningTest()) return;
    
    DealerGeneral__c c = DealerGeneral__c.getInstance();
    //11.09.2013
    if (o.Partner_Account_Id__c == null) 
    {
        if (c.Default_Owner_of_Opportunities_Id__c != null && c.Default_Owner_of_Opportunities_Id__c != '') 
        {
            //System.debug(('@@@@@AssignOwner;  Partner Account is Null. Using Custom Settings to Assign owner');
            o.OwnerId = c.Default_Owner_of_Opportunities_Id__c;
            a.OwnerId = c.Default_Owner_of_Opportunities_Id__c;
        }
        return;
    }
    
    Id newOwnerId = FindOpportunityRecipient(listDealersRaw, o.Partner_Account_Id__c);

    //System.debug(('@@@@@AssignOwner;  FindOpportunityRecipient returned: ' + newOwnerId);
    if (newOwnerId != null ) {
        o.OwnerId = newOwnerId;
        a.OwnerId = newOwnerId;
    }
    else if (c.Default_Owner_of_Opportunities_Id__c != null && c.Default_Owner_of_Opportunities_Id__c != '') {
        o.OwnerId = c.Default_Owner_of_Opportunities_Id__c;
        a.OwnerId = c.Default_Owner_of_Opportunities_Id__c;
    }
    else {
         try {
            //Wrapping this because SunPower Admins are shutting off emailing which raises an exception here
            SendEmailAlert('ALR - Dealer missing Opportunity Recipient ', 'During the Automatic conversion of a Lead an Opportunity (' + o.id + ') and an ' +
               ' Account (' + a.id + ') were created. This Opportunity and Account need to have is Owner set to the Opportunity Recipient of the Dealer (' + o.Partner_Account_Id__c+ ') however it was blank.');
         } catch(Exception e){}
    }
}

public static Id FindOpportunityRecipient(list<DealerResult> listDealersRaw, Id AccountId) {
    for (DealerResult dr : listDealersRaw) {
        if (AccountId == dr.AccountId) {
                return dr.OpportunityRecipient;
        }
    }
    return FindOpportunityRecipient(AccountId);
}

public static Id FindOpportunityRecipient(Id AccountId) {
    //System.debug(('@@@@@DealerUtility (SOQL); FindOpportunityRecipient; SOQL from Account');
    Account a = [Select id, Opportunity_Recipient__c from Account where Id = :AccountId LIMIT 1];
    return a.Opportunity_Recipient__c;
}

//===================================================================

//===================================================================
public static Dealer_Assignment_Audit__c ConfigureDealerAssignmentAudit(string Name, Id AccountId, Id OpportunityId, String Reason, String RuleApplied) {
    Dealer_Assignment_Audit__c daa = new Dealer_Assignment_Audit__c();
    daa.Name                                = Name;
    daa.Dealer_Assigned__c              = AccountId;
    daa.Opportunity__c                  = OpportunityId;
    daa.Reason__c                           = Reason;
    daa.ALR_Rule_Applied__c         = RuleApplied;
    daa.Assignment_Date__c          = System.today();
    return daa;
}
//===================================================================

//===================================================================
public static list<Dealer_Assignment_Audit__c> GetPreviouslyAssignedDealers(Id oppId) {
    list<Dealer_Assignment_Audit__c> listPrevious = new list<Dealer_Assignment_Audit__c>();
    listPrevious = [Select Dealer_Assigned__c From Dealer_Assignment_Audit__c Where Opportunity__c = :oppId];
    return listPrevious;
}
//===================================================================

//===================================================================
public static list<DealerResult> RemovePreviousDealers(list<DealerResult> listDealersRaw, list<Dealer_Assignment_Audit__c> listPrevious) {
    list<DealerResult> listDealersToReturn           = new list<DealerResult>();
    boolean bFound = false;
    
    for (DealerResult dr : listDealersRaw) {
        
        bFound = false;
        
        for (Dealer_Assignment_Audit__c da : listPrevious) {

            if (dr.AccountId == da.Dealer_Assigned__c) bFound = true;
            
        }
        
        if (bFound == false) listDealersToReturn.add(dr);
        
    }
    
    return listDealersToReturn;
}
//===================================================================

//===================================================================
public static Id GetSingleDealerBasedOnRandomEvenDistribution(list<DealerResult> listDealers, Dealer_Assignment_Audit__c daa, string CampaignId ) {

//System.debug(('@@@@@GetSingleDealerBasedOnRandomEvenDistribution; Start');

    if (listDealers.size() == 0) {
        //leadAssignment.Notes__c += ' \r\n' + ' No Dealers were found ' + '\r\n';    
        //System.debug(('@@@@@GetSingleDealerBasedOnRandomEvenDistribution; No Dealers were found');
        return null;
    }
    
    list<Id> listDealerPool = new list<id>();
    boolean bFound = false;
    integer randomInt = 0;

    //list<Lead_Assignment__c> listAlreadyAssigned = [Select AccountId__c, count(Id) from Lead_Assignment__c where CreatedDate >= LAST_N_DAYS:30  group by AccountId__c Order by count(Id) ASC];

    //AggregateResult[] listAlreadyAssigned = [Select AccountId__c, count(Id) from Lead_Assignment__c where CampaignId__c = :CampaignId  
    //                                                        and CreatedDate >= LAST_N_DAYS:30  group by AccountId__c Order by count(Id) DESC];

    //System.debug(('@@@@@DealerUtility (SOQL); GetSingleDealerBasedOnRandomEvenDistribution; SOQL from Lead_Assignment__c');
    AggregateResult[] listAlreadyAssigned = [Select Dealer_Assigned__c, count(Id) from Dealer_Assignment_Audit__c where Campaign__c = :CampaignId and Dealer_Assigned__c != null 
                                                               group by Dealer_Assigned__c Order by count(Id) DESC];

    if (listAlreadyAssigned.size() == 0) {
        //leadAssignment.Notes__c += ' \r\n' + ' No dealers have been assigned yet. ' + '\r\n';   
        //System.debug(('@@@@@GetSingleDealerBasedOnRandomEvenDistribution; No dealers have been assigned yet');
        
        for (DealerResult d : listDealers) {//Load the Pool based on the Dealer List Passed IN
            listDealerPool.add(d.AccountId);
            //leadAssignment.Notes__c += ' \r\n' + ' Adding 1 chance for ' + d.AccountName + ' \r\n'; 
            //System.debug(('@@@@@GetSingleDealerBasedOnRandomEvenDistribution; Adding 1 chance for ' + d.AccountName);
        }
        
        randomInt = getRandomNumber(listDealerPool.size()-1);
        //System.debug(('@@@@@GetSingleDealerBasedOnRandomEvenDistribution; Final pool size ' + listDealerPool.size() + '; selecting ' + randomInt + ' (' + listDealerPool[randomInt] + ') \r\n');
        //leadAssignment.Notes__c += ' Final pool size ' + listDealerPool.size() + '; selecting ' + randomInt + ' (' + listDealerPool[randomInt] + ') \r\n';
        return listDealerPool[randomInt]; 
        
    }
    else {
            //===========================================================================
            //====  Indicates some have more than other so we remove the top one and randomly select from remaining
            //========================================= ==================================
            
            //Do we only have a single Dealer to select from? If Yes then just return that Dealer.
            if (listDealers.size() == 1) {
                //System.debug(('@@@@@GetSingleDealerBasedOnRandomEvenDistribution;  Final pool size ' + listDealers.size() + '; selecting 1 (' + listDealers[0] + ')');
                return listDealers[0].AccountId; 
            }
            
            
            Integer mostAssigned = 0;
            //System.debug(('@@@@@GetSingleDealerBasedOnRandomEvenDistribution; mostAssigned: ' + mostAssigned);
            
            for (AggregateResult leadAssignment3 : listAlreadyAssigned) {
                if (integer.valueOf(leadAssignment3.get('expr0')) > mostAssigned) mostAssigned = integer.valueOf(leadAssignment3.get('expr0'));
            }
            
            //System.debug(('@@@@@GetSingleDealerBasedOnRandomEvenDistribution; mostAssigned: ' + mostAssigned);
            
            list<Id> listTOEXCLUDEDealerPool = new list<Id>();
            
            for (AggregateResult leadAssignment4 : listAlreadyAssigned) {
                if (integer.valueOf(leadAssignment4.get('expr0')) == mostAssigned) {
                     listTOEXCLUDEDealerPool.add((ID)leadAssignment4.get('Dealer_Assigned__c'));
                     //System.debug(('@@@@@GetSingleDealerBasedOnRandomEvenDistribution; Excluded: ' + leadAssignment4.get('Dealer_Assigned__c'));
                }
            }
            
            //So we found the biggest - now populate the POOL and omitt any that have the biggest
            
            for (DealerResult d : listDealers) { //Load the Pool based on the Dealer List Passed IN
                bFound = false;
                for(Id leadAssignment5 : listTOEXCLUDEDealerPool) {
                    if (leadAssignment5 == d.AccountId) {
                        bFound = true;
                        //leadAssignment.Notes__c += ' EXCLUDING 1 chance for ' + d.AccountName + ' \r\n';
                    }
                }
                
                if (!bFound ) {
                    //leadAssignment.Notes__c += ' Adding 1 chance for ' + d.AccountName + ' \r\n';
                    listDealerPool.add(d.AccountId);
                    //System.debug(('@@@@@GetSingleDealerBasedOnRandomEvenDistribution;  Adding 1 chance for ' + d.AccountName);
                }
                
            }
            
            if (listDealerPool.size() == 1) {
                //leadAssignment.Notes__c += ' Final pool size ' + listDealerPool.size() + '; selecting 1 (' + listDealerPool[0] + ') \r\n';
                //System.debug(('@@@@@GetSingleDealerBasedOnRandomEvenDistribution;  Final pool size ' + listDealerPool.size() + '; selecting 1 (' + listDealerPool[0] + ')');
                return listDealerPool[0]; 
            }
            else if (listDealerPool.size() == 0) {
                //leadAssignment.Notes__c += ' Final pool size 0; Unable to select anything \r\n';
                randomInt = getRandomNumber(listDealers.size()-1);
                //leadAssignment.Notes__c += ' Final pool size ' + listDealers.size() + '; selecting ' + randomInt + ' (' + listDealers[randomInt].AccountId + ') \r\n';
                //System.debug(('@@@@@GetSingleDealerBasedOnRandomEvenDistribution;  Final pool size ' + listDealers.size() + '; selecting ' + randomInt + '(' + listDealers[randomInt].AccountId + ')');
                return listDealers[randomInt].AccountId; 

            }
            else {
                randomInt = getRandomNumber(listDealerPool.size()-1);
                //leadAssignment.Notes__c += ' Final pool size ' + listDealerPool.size() + '; selecting ' + randomInt + ' (' + listDealerPool[randomInt] + ') \r\n';
                //System.debug(('@@@@@GetSingleDealerBasedOnRandomEvenDistribution;  Final pool size ' + listDealerPool.size() + '; selecting ' + randomInt + '(' + listDealerPool[randomInt] + ')');
                return listDealerPool[randomInt]; 
            }
        
        }

}
//===================================================================

//===================================================================
public static Id GetSingleDealerBasedOnWeightedScore(list<DealerResult> listDealers, Dealer_Assignment_Audit__c daa ) {
    //We can accomplish a first pass at this by creating a list filled with entries that represent Dealers. The entry count per Dealer is based on the score thus
    //the higher the score, the more entries in the list. We then get a random number based on the sixe of the list. This should come close to getting a weighted selection
   //System.debug(('@@@@@GetSingleDealerBasedOnWeightedScore; Start');
    if (listDealers.size() == 0) {
        //System.debug(('@@@@@GetSingleDealerBasedOnWeightedScore; Exiting - No Dealers Found') ;
        return null;
    }

   if (listDealers.size() == 1) {
        //System.debug(('@@@@@GetSingleDealerBasedOnWeightedScore; Exiting - ONE Dealers Found') ;
        return listDealers[0].AccountId;
    }


    list<Id> listDealerPool = new list<id>();
    //leadAssignment.Notes__c += ' Pool of Dealers for random selection is ' + listDealers.size() + ' \r\n';
    for (DealerResult d : listDealers){
        //leadAssignment.Notes__c += ' Adding ' + integer.valueOf(d.score) + ' chances for ' + d.AccountName + ' \r\n';
        if (d.score != null) {
            if (d.score != 0) {
                for(Integer i = 0; i < integer.valueOf(d.score)-1; i++)
                    listDealerPool.add(d.AccountId);
            }
        }
        else {
            //System.debug(('@@@@@GetSingleDealerBasedOnWeightedScore; Warning Score on Account is NOT set. Account: ' + d.AccountId);
        }
    }
    //TODO Possibly look at shuffling the POOL before selcting from it. I suggest this because I know RANDOM tends to act in predictable ways (at least on other systems)
    integer randomInt = getRandomNumber(listDealerPool.size()-1);

    //System.debug(('@@@@@GetSingleDealerBasedOnWeightedScore; Dealer Pool Size: ' + listDealerPool.size());
    
    if (listDealerPool.size() == 0) {
        //System.debug(('@@@@@GetSingleDealerBasedOnWeightedScore; Dealer Pool Size is empty, returning no assignment. Suspect missing scoring values');
        return null;
    }
    
    return listDealerPool[randomInt];

}
//===================================================================

//===================================================================
/*
public static void CleanseLeadAddressAndUpdate(Lead l) {

    String sData = l.street + ', ' + l.city + ', ' + l.state + ', ' + l.postalCode + ', ' + l.country;
    
    PostcodeAnywhereService.PostcodeAnywhere_Soap  pcaService = new PostcodeAnywhereService.PostcodeAnywhere_Soap ();
    PostcodeAnywhereService.PostcodeAnywhereInternational_InteractiveUSA_RetrieveByAddress_v1_10_ArrayOfResults  r;
    
    try 
    {
        //Call the PostCodeAnywhere service
        r = pcaService.PostcodeAnywhereInternational_InteractiveUSA_RetrieveByAddress_v1_10('YH97-FE76-NA95-YM91', sData, null);
        if (r.PostcodeAnywhereInternational_InteractiveUSA_RetrieveByAddress_v1_10_Results.size() == 1) {
            if (r.PostcodeAnywhereInternational_InteractiveUSA_RetrieveByAddress_v1_10_Results[0].Confidence > 0.50) {
                l.street = r.PostcodeAnywhereInternational_InteractiveUSA_RetrieveByAddress_v1_10_Results[0].Line1;
                l.city = r.PostcodeAnywhereInternational_InteractiveUSA_RetrieveByAddress_v1_10_Results[0].City;
                l.state = r.PostcodeAnywhereInternational_InteractiveUSA_RetrieveByAddress_v1_10_Results[0].StateCode;
                l.postalCode = r.PostcodeAnywhereInternational_InteractiveUSA_RetrieveByAddress_v1_10_Results[0].Zip;
                l.country = r.PostcodeAnywhereInternational_InteractiveUSA_RetrieveByAddress_v1_10_Results[0].CountryIso3;
                update l;
            }
        }
        
    }
    catch (Exception e) 
    {
        //TODO - Does SunPower want to be alerted to issues?
    }

}
*/
//===================================================================

//===================================================================
public static Integer getRandomNumber(Integer size){
        Double d = math.random() * size;
        return d.intValue();
    }
//===================================================================
    
//===================================================================
/*
    private integer DurationBetweenInMinutes(dateTime startDT, dateTime endDT) {
        long finalHours = 0;
        try {
            //getTime -> Returns the number of milliseconds since January 1, 1970, 00:00:00 GMT represented by this DateTime object
            if (!Test.isRunningTest())
                finalHours = (endDT.getTime() - startDT.getTime()) * 1000 * 60;
            else
                finalHours = (endDT.getTime() - startDT.getTime()) * 1000; //During testing we return seconds so we actually get some values back
        }
        catch (Exception ex) {
            return 0; //For now
        }       
        return integer.valueOf(finalHours);         
    }
*/
//===================================================================                           

//===================================================================
    public static List<DealerResult> getDealersForAssignmentWithoutGeoCode(Decimal lat, Decimal lon, String State, String Country)
    {
    
        list<DealerResult> dealerRawResults = new list<DealerResult>();
        list<DealerResult> dealerResults = new list<DealerResult>();
          
        if (lat != null) 
        {
            GeocodeAsyncHandler.GeoInfo info = new GeocodeAsyncHandler.GeoInfo();
            info.State = State;
            //info.Country = Country;
            info.Lat = lat;
            info.Lon = lon;
            dealerRawResults = getTopDealers(lat, lon, info, Country, 1000);
        }
        
        if (Test.isRunningTest()) 
        {
            GeocodeAsyncHandler.GeoInfo info = new GeocodeAsyncHandler.GeoInfo();
            info.State = 'CO';
            //info.Country = 'United States';
            info.Lat = 39.721956;
            info.Lon = -104.974382;
            
            dealerRawResults = getTopDealers(39.721956, -104.974382, info, 'United States', 1000);
        }
        
        for (DealerResult dr :dealerRawResults) 
        {
            //System.debug(('@@@@@getDealersForAssignmentWithoutGeoCode;' + dr.AccountName + dr.AccountId + dr.LeadFlowOptOut);
            if (dr.LeadFlowOptOut == false ) 
            {
                dealerResults.add(dr);
            }
        }
        
        return dealerResults;
    }
//===================================================================

//===================================================================
    public static List<DealerResult> getDealersForDealerLocator(String street, String city, String state, String postalCode, String country, Integer ExtraRadius){
    
        System.debug('inside the getDealersForDealerLocator ==============street ====>'+street+'==city =='+city+'==state =='+state+'===postalCode=='+postalCode+'==country=='+country+'== ExtraRadius =='+ExtraRadius);
        
        list<DealerResult> dealerResults = new list<DealerResult>();
        DealerResult[] resultsFinal     = new DealerResult[]{};

        //System.debug(('@@@@@getDealers; Using Google: ');
        //Step 1 - Clean the address
        String cleanAddress = GeocodeAsyncHandler.cleanAddress( Street,  City,  State,  PostalCode,  Country);
        //System.debug(('@@@@@getDealers; Address Cleaned: '+cleanAddress); 
    
        //Step 2 - GeoCode the address
        GeocodeAsyncHandler.GeoInfo info = GeocodeAsyncHandler.GeoCodeWithZipCodeFilter(cleanAddress, postalCode);
        
        System.debug('info =====================> '+info);
    
        if (info.lat != null) {
            dealerResults = getTopDealers(info.lat, info.lon, info, country, 1000);
        
        System.debug(' dealerResults =====================> '+dealerResults);
            
            for(DealerResult dr : dealerResults) 
            {
                if (dr.DealerLocatorOptOut == false) resultsFinal.add(dr);
            }            
        }

         
        return resultsFinal;
    }
//===================================================================

    //MAM 02/03/2014 Separate Method for Internal Dealer Locator Start
    public static List<DealerResult> getDealersForDealerLocatorInternal(String street, String city, String state, String postalCode, String country, Integer ExtraRadius){
    
        //System.debug(('@@@@@getDealers; Enter: ');
        
        list<DealerResult> dealerResults = new list<DealerResult>();
        DealerResult[] resultsFinal     = new DealerResult[]{};

        //System.debug(('@@@@@getDealers; Using Google: ');
        //Step 1 - Clean the address
        String cleanAddress = GeocodeAsyncHandler.cleanAddress( Street,  City,  State,  PostalCode,  Country);
        //System.debug(('@@@@@getDealers; Address Cleaned: '+cleanAddress); 
    
        //Step 2 - GeoCode the address
        GeocodeAsyncHandler.GeoInfo info = GeocodeAsyncHandler.GeoCodeWithZipCodeFilter(cleanAddress, postalCode);
        //System.debug(('@@@@@getDealers; Geocode: '+info);
    
        if (info.lat != null) {
            dealerResults = getTopDealers(info.lat, info.lon, info, country, 1000);
            
            for(DealerResult dr : dealerResults) 
            {
                resultsFinal.add(dr); //MAM 01/28/2014
            }            
        }

         
        return resultsFinal;
    }
      //MAM 02/03/2014 end
    
//=================================================================== 
    public static list<DealerResult> findCampaignDealers(list<DealerResult> dealerResults, Id CampaignId){
        //System.debug(('@@@@@findCampaignDealers;  Enter');
                    
        List<DealerLocatorService.ResultRow> resultRows = new List<DealerLocatorService.ResultRow>();

        list<Campaign_Partner__c> listCampaignResults = new list<Campaign_Partner__c>();
        
        set<Id> setFoundDealerIds = new set<Id>();

        for (DealerResult dr : dealerResults)
            setFoundDealerIds.add(dr.AccountId);
             
        map<id, Campaign_Partner__c> mapCampaignPartners = new map<id, Campaign_Partner__c>();
        
        //System.debug(('@@@@@findCampaignDealers Number of Dealers within the area: '+setFoundDealerIds.size());
        //System.debug(('@@@@@findCampaignDealers SOQL: select Partner__c from Campaign_Partner__c where Campaign__c  = ' + CampaignId + ' and Partner__c IN ' + setFoundDealerIds);
        
        if (setFoundDealerIds.size() > 0) {
            //System.debug(('@@@@@DealerUtility (SOQL); findCampaignDealers; SOQL from Campaign_Partner__c');
            listCampaignResults = [select Partner__c, Enabled__c, Enable_Date__c, Disable_Date__c from Campaign_Partner__c where Campaign__c  = :CampaignId and Partner__c IN :setFoundDealerIds];
        }
        
        list<DealerResult> listFinalResults = new list<DealerResult>();
        
        //System.debug(('@@@@@findCampaignDealers Size: '+listCampaignResults.size());
        
        for (Campaign_Partner__c cp : listCampaignResults) {
            //System.debug(('@@@@@findCampaignDealers Looking at Campaign Partner: '+cp.Partner__c);
            for (DealerResult dr2 : dealerResults) {
                //System.debug(('@@@@@findCampaignDealers Looking at: '+dr2.AccountName+' '+dr2.AccountId);
                if (dr2.AccountId == cp.Partner__c) {
                    
                   // if (System.Today() >= cp.Enable_Date__c) {
                   //     if (System.Today() < cp.Disable_Date__c) {
                    
                            if (cp.Enabled__c==true)    listFinalResults.add(dr2);
                
                   //     }
                   // }
                    
                }
            }
        }

        return listFinalResults;
            
    }
//=================================================================== 

//=================================================================== 
    public static list<DealerResult> findAllianceDealers(list<DealerResult> dealerResults){
        List<DealerLocatorService.ResultRow> resultRows = new List<DealerLocatorService.ResultRow>();
        
        list<DealerResult> listFinalResults = new list<DealerResult>();
         
        for (DealerResult dr : dealerResults) {
            if (dr.AllianceProgramPartner == true) {
                listFinalResults.add(dr);
            }
        }
        
        return listFinalResults;
            
    }
//===================================================================

//=================================================================== 
    public static list<DealerResult> findAllianceCampaignDealers(list<DealerResult> dealerResults, Campaign c){
        List<DealerLocatorService.ResultRow> resultRows = new List<DealerLocatorService.ResultRow>();
        
        list<DealerResult> listFinalResults = new list<DealerResult>();
         
        for (DealerResult dr : dealerResults) {
           for (Campaign_Partner__c cp : c.campaign_partners__r) {
                 if (cp.Partner__c  == dr.AccountId) {
                    listFinalResults.add(dr);
                }
           }

        }
       
        return listFinalResults;
            
    }
//===================================================================

//===================================================================
    public static boolean isPaidCampaign(Campaign c) {
        return c.AssignRandomPartner__c;   
    }       
//===================================================================

//===================================================================
    public static boolean isAllianceCampaign(Campaign c) {
        return (c.Type == 'Alliance');   
    }  
//===================================================================

//===================================================================
    public static boolean isALREnabled() {
        DealerGeneral__c dg = DealerGeneral__c.getInstance(UserInfo.getOrganizationId());
        
        if (Test.isRunningTest() == true) return true;
        
        return dg.Enable_ALR_Process__c;
    }
//===================================================================

}