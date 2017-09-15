public with sharing class DealerSOQLUtil {
    
    public static String REC_RESIDENTIAL    = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Residential').getRecordTypeId();
    public static final String AUTHORIZED_PARTNER_COMBO = 'Authorized-Partner-Combo';
    public static final String AUTHORIZED_PARTNER_RESIDENTIAL = 'Authorized-Partner-Residential';
    public static final String PREMIER_PARTNER_COMBO = 'Premier-Partner-Combo';
    public static final String PREMIER_PARTNER_RESIDENTIAL = 'Premier-Partner-Residential';
    public static final String ELITE_PARTNER_COMBO = 'Elite-Partner-Combo';
    public static final String ELITE_PARTNER_RESIDENTIAL = 'Elite-Partner-Residential';
    public static final String MASTER_PARTNER_RESIDENTIAL = 'Master-Partner-Residential';
    public static final String MASTER_PARTNER_COMBO = 'Master-Partner-Combo';
    
    public static Map <Id, Account> buildAllDealersMap()
    {
        //This method returns a map of all Sunpower Dealers and the child objects needed for opportunity assignment
        Map <Id, Account> result = new Map <Id, Account>();
        //KCM_10182016: set of Account Types for use in query to remove the LIKE% statements
        Set<String> accountTypes = new Set<String>{AUTHORIZED_PARTNER_COMBO, AUTHORIZED_PARTNER_RESIDENTIAL, 
                                                   PREMIER_PARTNER_COMBO, PREMIER_PARTNER_RESIDENTIAL, ELITE_PARTNER_COMBO, 
                                                   ELITE_PARTNER_RESIDENTIAL,MASTER_PARTNER_RESIDENTIAL, MASTER_PARTNER_COMBO}; 
        //KCM_10182016: use the special utilities to obtain record type instead of using recordtypeid.name in query
        Id partnerRecTypeId = SFDCSpecialUtilities.getRecordTypeIdsByDeveloperName(Account.SObjectType).get('Partner');
        
        List<String> validCountries_list = Label.ALR_Lead_VALIDCOUNTRIES.split(',');

        /*KCM_10182016: commented out query and replaced with the one directly below
        for(Account a : [SELECT Name, 
                            Type, Account_Display_Name__c,Partner_Logo__c,Dealer_Score_Total__c, Dealer_Locator_Phone__c, Phone, 
                            BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode, 
                            Opportunity_Recipient__c, Website, Oracle_Account_Number__c, Description, Opportunity_Recipient__r.Email,
                            Partner_Facts__c, Alliance_Program_Partner__c, Dealer_Locator_Opt_Out__c, Additional_Opportunity_Email_Recipient__c,
                            Lead_Flow_Opt_Out__c, Lead_Assignment_Count__c, Lead_Priority_Minimum__c, 
                            Lead_Priority_Maximum__c, Last_Assigned_Date__c, Priority_Assignment__c, Dealer_Tier__c,
                            Business_Function__c, 
                                (SELECT Geolocation__Latitude__s, 
                                        Geolocation__Longitude__s, Radius__c, Account__c 
                                    FROM Coverage_Areas__r 
                                    WHERE Radius__c > 0
                                    AND Sector__c = 'Residential'), //Crystal added conditional for BU per req PT #116798891 - Re-Org Coverage Area Object
                                (SELECT Id 
                                    FROM  Agreements__r 
                                    WHERE Echosign_dev1__Status__c = 'Signed' 
                                    AND Agreement_Type_2__c = 'Partner Agreement' 
                                    AND Name LIKE '%Lead Handling Policy Agreement'), 
                                 (SELECT Id, State__c, Country__c 
                                    FROM Business_Registrations__r), 
                                 (SELECT Partner__c, Enabled__c, 
                                    Enable_Date__c, Disable_Date__c, 
                                    Partner_Type__c, Campaign__r.Type 
                                    FROM Campaign_Partners__r), 
                                 (SELECT Campaign__c 
                                    //FROM Dealer_Assignment_Audit__r 
                                    FROM Lead_Dealer_Assignment_Audit__r
                                    WHERE Campaign__c != NULL AND Active_Assignment__c = 1) 
                                FROM Account WHERE Status__c = 'Active' 
                            AND (Type like '%Partner-Residential' OR Type like '%Partner-Combo') 
                            ]){*/
        //KCM_10182016: updated query                    
        for (Account a: [SELECT Name, Type, Account_Display_Name__c,Partner_Logo__c,Dealer_Score_Total__c, Dealer_Locator_Phone__c, 
                                Phone, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode, 
                                Opportunity_Recipient__c, Website, Oracle_Account_Number__c, Description, Opportunity_Recipient__r.Email,
                                Partner_Facts__c, Alliance_Program_Partner__c, Dealer_Locator_Opt_Out__c, 
                                Additional_Opportunity_Email_Recipient__c,Lead_Flow_Opt_Out__c, Lead_Assignment_Count__c, 
                                Lead_Priority_Minimum__c, Lead_Priority_Maximum__c, Last_Assigned_Date__c, Priority_Assignment__c, 
                                Dealer_Tier__c, Business_Function__c, 
                                (SELECT Geolocation__Latitude__s, 
                                        Geolocation__Longitude__s, Radius__c, Account__c 
                                 FROM Coverage_Areas__r 
                                 WHERE Radius__c > 0
                                 AND Sector__c = 'Residential'), //Crystal added conditional for BU per req PT #116798891 - Re-Org Coverage Area Object
                                (SELECT Id 
                                 FROM  Agreements__r 
                                 WHERE Echosign_dev1__Status__c = 'Signed' 
                                 AND Agreement_Type_2__c = 'Partner Agreement' 
                                 AND Name LIKE '%Lead Handling Policy Agreement'), 
                                (SELECT Id, State__c, Country__c 
                                 FROM Business_Registrations__r), 
                                (SELECT Partner__c, Enabled__c, 
                                        Enable_Date__c, Disable_Date__c, 
                                        Partner_Type__c, Campaign__r.Type 
                                 FROM Campaign_Partners__r), 
                                (SELECT Campaign__c 
                                 //FROM Dealer_Assignment_Audit__r 
                                 FROM Lead_Dealer_Assignment_Audit__r
                                 WHERE Campaign__c != NULL AND Active_Assignment__c = 1) 
                         FROM Account 
                         WHERE RecordTypeId =: partnerRecTypeId 
                         AND Status__c = 'Active'
                         AND Theater__c IN: validCountries_list
                         AND Type IN: accountTypes]) {
            result.put(a.Id, a);
        }

       return result;
    }
    
    public static Map <Id, Account> buildAllDealersMapReassignMent(Set<String> setId){
        //This method returns a map of all Sunpower Dealers and the child objects needed for opportunity assignment
        Map <Id, Account> result = new Map <Id, Account>();

        for(Account a : [SELECT Name, 
                            Type,Account_Display_Name__c,Partner_Logo__c, Dealer_Score_Total__c, Dealer_Locator_Phone__c, Phone, 
                            BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode, 
                            Opportunity_Recipient__c, Website, Oracle_Account_Number__c, Description, Opportunity_Recipient__r.Email,
                            Partner_Facts__c, Alliance_Program_Partner__c, Dealer_Locator_Opt_Out__c, Additional_Opportunity_Email_Recipient__c,
                            Lead_Flow_Opt_Out__c, Lead_Assignment_Count__c, Lead_Priority_Minimum__c, 
                            Lead_Priority_Maximum__c, Last_Assigned_Date__c, Priority_Assignment__c, 
                            Business_Function__c
                                FROM Account where Id in : setId])
                            {
                    result.put(a.Id, a);
                }
       return result;
    }
    
    public static List<Lead> getLeadbyId(Set<Id> SetleadId)
    {
        list<Lead> lstLead = [Select Theater__c, Longitude__c, Latitude__c, Log__c,
                    Lat__c, Partner_Type__c, OwnerId, Status, Email, MobilePhone, 
                    Phone, Longitude, Latitude, Country, PostalCode, State, 
                    City, Street, Company, Title, Lead_Manufacturer__c, RecordTypeId, 
                    FirstName, LastName, Id, Dealer_Name__c, Dealer_Assignment_Status__c,
                    Dealer_Locator_Selection__c, Requires_Manual_Assignment__c,
                    Dealer_Assignment_Date__c, Dealer_Locator_Selection__r.OwnerId,
                    Dealer_Locator_Selection__r.Name, Dealer_Locator_Selection__r.Opportunity_Recipient__r.Email,
                    ALR_Assignment_Audit_Trail__c, IsAutoConvert__c, HD_Competing_Partner_Indicator__c,
                    Sent_to_Five9__c, Reason__c, Consultation_Type__c,Most_Recent_Campaign__c
                from lead 
                where (Status in ('Ready for Assignment - EU Only','Ready for Conversion','Marketing Qualified', 'Failed Conversion')
                and Id in : SetleadId
                and RecordTypeId = : REC_RESIDENTIAL
                and Lead_Manufacturer__c = 'SunPower')
                
                OR  (Id in : SetleadId 
                and RecordTypeId = : REC_RESIDENTIAL
                and Lead_Manufacturer__c = 'SunPower'
                and Reason__c in ('Assign New  Dealer','Other - Misc or Test Leads','Assign New Dealer')
                and Status in ('Disqualified'))];
                
            /*   */
        
        return lstLead;
    }
    
    public static list<Lead_Dealer_Assignment_Audit__c> GetPreviouslyAssignedDealers(Id leadId) {
        list<Lead_Dealer_Assignment_Audit__c> listPrevious = new list<Lead_Dealer_Assignment_Audit__c>();
        listPrevious = [Select Dealer_Assigned__c From Lead_Dealer_Assignment_Audit__c Where Lead__c = :leadId];
        return listPrevious;
    }
    
    public static Campaign getCampaignById (Id foundCampaignId){
        Campaign campaign = [select ParentId,Type, RLC_Type__c, AssignRandomPartner__c, NH_Community__c, Name,
                             Requires_Lead_Pre_Qualification__c,isExclusive__c, Five9__Five9list__c,
                     (select id, name, Partner__c, Partner_Type__c from campaign_partners__r) 
                     from Campaign where id = :foundCampaignId LIMIT 1];
        
        return campaign;             
    }
    
    public static map<Id,Campaign> getCampaignById (Set<String> setCampId){
    
    //Added ParentId and Id in SOQL query to Five 9 delay requirement
        map<Id,Campaign> mapCamp = new map<Id,Campaign>([select ParentId,Type, RLC_Type__c, AssignRandomPartner__c, NH_Community__c, Name,
                                                         Requires_Lead_Pre_Qualification__c,isExclusive__c,Five9__Five9list__c, 
                     (select id, name, Partner__c, Partner_Type__c from campaign_partners__r) 
                     from Campaign where id in : setCampId]);
        return mapCamp;          
    }
    
    /*
        method      : getLeadbyIdforReassignment(Set<Id> SetleadId)
        Summary     : Method to get lead by ID only
    */
    public static list<Lead> getLeadbyIdforReassignment(Set<Id> SetleadId)
    {
        list<Lead> lstLead = [Select Theater__c, Longitude__c, Latitude__c, Log__c,
                    Lat__c, Partner_Type__c, OwnerId, Status, Email, MobilePhone, 
                    Phone, Longitude, Latitude, Country, PostalCode, State, City, 
                    Street, Company, Title, Lead_Manufacturer__c, RecordTypeId, FirstName, 
                    LastName, Id, Dealer_Name__c, Dealer_Assignment_Status__c, Dealer_Locator_Selection__c,
                    Requires_Manual_Assignment__c, Dealer_Assignment_Date__c, Dealer_Locator_Selection__r.OwnerId,
                    Dealer_Locator_Selection__r.Name, Dealer_Locator_Selection__r.Opportunity_Recipient__r.Email,
                    Res_Opp_Recip_CC_Email__c, Res_Opp_Recip_Email__c, ALR_Assignment_Audit_Trail__c,
                    IsAutoConvert__c, HD_Competing_Partner_Indicator__c, Sent_to_Five9__c,
                    Reason__c, Consultation_Type__c,Most_Recent_Campaign__c
                from lead where Id In : SetleadId];
        
        return lstLead;
    }
    
    /*
        Method  : GetPreviouslyAssignedDealersCount
        return  : Integer
        Summary : Method returns the lead dealer assignment audit 
                    total record count for respective lead
    */
    public static map<Id,Integer> GetPreviouslyAssignedDealersCount(Set<Id> setleadId){
        
    map<Id,Integer> mapLeadDealerAssignment = new map<Id,Integer>();
        
     for(Lead objLead : [Select Id, (Select Id From Lead_Dealer_Assignment_Audits__r) From Lead where Id in : setleadId]){
        mapLeadDealerAssignment.put(objLead.Id,objLead.Lead_Dealer_Assignment_Audits__r.size());
     }
     
     return mapLeadDealerAssignment;
    }
    
    /*
        Method  : getDealerByNameOrId
        return  : map<Id,Account> mapAccount
        Summary : Method returns accepts the Dealer Id or Name and returns the 
                    respective Account (Dealer). 
    */
    public static map<Id,Account> getDealerByNameOrId(Set<String> setDealerId){
        try{
            
            if(setDealerId == null && setDealerId.isEmpty()) return new map<Id,Account>();
            
            map<Id,Account> mapAccount = new map<Id,Account>([Select OwnerId,Id,name,Opportunity_Recipient__c, Account_Display_Name__c,Partner_Logo__c,
                                                                    Opportunity_Recipient__r.Email, Additional_Opportunity_Email_Recipient__c 
                                                              from Account where Id In : setDealerId or Name In : setDealerId]); 
            return mapAccount;
        }catch(Exception ex){
            system.debug('ex ==>'+ex.getMessage());
            return new map<Id,Account>();
        }
    }
    
    public static map<Id,CampaignMember> getCampaignMemberByLeadId(Set<Id> SetleadId ){
        map<Id,CampaignMember> mapCampaignMember = new map<Id,CampaignMember>();
        try{
            list<CampaignMember> lstCampaignMember = new list<CampaignMember>();
            lstCampaignMember = [Select c.LeadId, c.Campaign.Type, c.Campaign.AssignRandomPartner__c,
                                        c.Campaign.Requires_Lead_Pre_Qualification__c,c.Campaign.isExclusive__c,c.Campaign.Five9__Five9list__c,
                                        c.Campaign.RLC_Type__c, c.Campaign.NH_Community__c, c.CampaignId, c.Campaign.Name,
                                        c.Campaign.id, c.Lead.Theater__c, c.Lead.Longitude__c, c.Lead.Latitude__c, c.Lead.Partner_Type__c, 
                                        c.Lead.OwnerId, c.Lead.Status, c.Lead.Email, c.Lead.MobilePhone, 
                                        c.Lead.Phone, c.Lead.Longitude, c.Lead.Latitude, c.Lead.Country, 
                                        c.Lead.PostalCode, c.Lead.State, c.Lead.City, c.Lead.Street, 
                                        c.Lead.Company, c.Lead.Title, c.Lead.RecordTypeId, c.Lead.FirstName,
                                        c.Lead.LastName, c.Lead.Dealer_Assignment_Date__c, c.Lead.Consultation_Type__c,c.Lead.Most_Recent_Campaign__c,c.Campaign.ParentId
                                From CampaignMember c 
                                where c.LeadId in : SetleadId];
        
        if(!lstCampaignMember.IsEmpty()){
            for(CampaignMember objCampaignMember : lstCampaignMember){
                if(!mapCampaignMember.ContainsKey(objCampaignMember.LeadId))
                    mapCampaignMember.put(objCampaignMember.LeadId,objCampaignMember);
            }
        }
                                
        return mapCampaignMember;
        }catch(exception ex){
            return mapCampaignMember;
        }
    }
    
    /*
        Function    : buildCampaignAssignmentCountMap
        Parameters  : Map <Id, Account> dealerMap
        
        // This method builds a map of Campaign Ids that return a Map of Account (Dealer) IDs and the count of assignments for the campaign
        // Needs a map of Accounts and their Dealer Assignment Audit child records (Dealer_Assignment_Audit__r)
    */
    public static map <Id, map<Id, Integer>> buildCampaignAssignmentCountMap(Map <Id, Account> dealerMap){
       map <Id, map<Id, Integer>> result = new map <Id, Map <Id, Integer>>();
        
        if(dealerMap.isEmpty()) return result;

        for(Account d : dealerMap.values()){
            //for(Dealer_Assignment_Audit__c aa : d.Dealer_Assignment_Audit__r){                
            for(Lead_Dealer_Assignment_Audit__c aa: d.Lead_Dealer_Assignment_Audit__r) {
                if(result.containsKey(aa.Campaign__c)){
                    if(result.get(aa.Campaign__c).containsKey(d.Id)){
                        result.get(aa.Campaign__c).put(d.Id, result.get(aa.Campaign__c).get(d.Id)+1);
                    }
                    else{
                        result.get(aa.Campaign__c).put(d.Id, 1);
                    }
                }
                else{
                    result.put(aa.Campaign__c, new Map <Id, Integer>());
                    result.get(aa.Campaign__c).put(d.Id, 1);
                }
            }
        }

        return result;
    }
    
    public static map<Id,Lead_Dealer_Assignment_Audit__c> getLeadDealerAssAudit(Set<Id> setId){
        
        map<Id,Lead_Dealer_Assignment_Audit__c> mapLeadVsDealerAssign = new map<Id,Lead_Dealer_Assignment_Audit__c>();
        
        for(Lead_Dealer_Assignment_Audit__c objleadAudit : [Select l.Lead__c, l.Id From Lead_Dealer_Assignment_Audit__c l where l.id in : setId]){
            mapLeadVsDealerAssign.put(objleadAudit.lead__c,objleadAudit);
        }
        
        return mapLeadVsDealerAssign;
    }
    
    public static list<Campaign_Partner__c> getCampaignPartnerByCampIdandPartner(set<Id> setFoundDealerIds,Id CampaignId){
        list<Campaign_Partner__c> listCampaignResults = new list<Campaign_Partner__c>();
        listCampaignResults = [select 
                                    Partner__c, 
                                    Enabled__c, 
                                    Enable_Date__c, 
                                    Disable_Date__c,
                                    Partner_Type__c
                                from Campaign_Partner__c 
                                where Campaign__c = :CampaignId 
                                and Partner__c IN :setFoundDealerIds];
        
        return listCampaignResults;
    }
}