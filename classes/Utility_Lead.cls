public without sharing class Utility_Lead {

    //constants
    public static ID ResidentialRecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Lead.SobjectType).get('Residential');
    public static DealerGeneral__c dealerGeneral = DealerGeneral__c.getInstance();
    public static String STATES = 'AL:AK:AZ:AR:CA:CO:CT:DE:DC:FL:GA:HI:ID:IL:IN:IA:KS:KY:LA:ME:MD:MA:MI:MN:MS:MO:MT:NE:NV:NH:NJ:NM:NY:'
            + 'NC:ND:OH:OK:OR:PA:RI:SC:SD:TN:TX:UT:VT:VA:WA:WV:WI:WY';
    public static String VALIDCOUNTRIES = system.label.ALR_Lead_VALIDCOUNTRIES;  
    
    
    //methods
    public static void qualifyLeadForShare(Lead lead, Map<Id, Lead> leadMapOld,
                                           Set<Id> leadIdSetToInsertLS, Set<Id> leadIdToDeleteLS,
                                           Set<Id> leadIdToDeleteNALS, Set<Id> leadIDSetToInsertNALS,
                                           List<Lead> leadListToInsertLS) {

        if (leadMapOld != null && (lead.Business_Unit__c == 'RLC' && lead.RLC_Type__c == 'Light Commercial')
                && leadMapOld.get(lead.Id).Business_Unit__c == 'NA Commercial') {
            leadIDSetToInsertNALS.add(lead.Id);
        } else if (leadMapOld != null && lead.Business_Unit__c == 'NA Commercial'
                   && (leadMapOld.get(lead.Id).Business_Unit__c == 'RLC' && leadMapOld.get(lead.Id).RLC_Type__c == 'Light Commercial') ) {
            leadIdToDeleteNALS.add(lead.Id);
        } else if ( (lead.Business_Unit__c == 'RLC' && lead.RLC_Type__c == 'Light Commercial')
                    || lead.Business_Unit__c == 'NA Commercial' ) {
            leadListToInsertLS.add(lead);
            leadIdSetToInsertLS.add(lead.Id);
        } else if ( leadMapOld != null
                    && ( lead.Business_Unit__c != 'RLC' || lead.Business_Unit__c != 'NA Commercial' || (lead.Business_Unit__c == 'RLC' && lead.RLC_Type__c != 'Light Commercial'))
                    && ( (leadMapOld.get(lead.Id).Business_Unit__c == 'RLC' && leadMapOld.get(lead.Id).RLC_Type__c == 'Light Commercial') || leadMapOld.get(lead.Id).Business_Unit__c == 'NA Commercial' )) {
            leadIdToDeleteLS.add(lead.Id);
        }

    }

    public static void processLeadForShare(List<Lead> leadListNew, Set<Id> leadIdSetToInsertLS, Set<Id> leadIdToDeleteLS,
                                           Set<Id> leadIdToDeleteNALS, Set<Id> leadIDSetToInsertNALS,
                                           List<Lead> leadListToInsertLS, List<LeadShare> leadShareToBeDeleted, List<LeadShare> leadShareToBeInserted) {

        // Set of lead ids having lead share record
        Set<Id> existingLeadSet = new Set<Id>();

        /*for(LeadShare ls : [select LeadId from LeadShare where LeadId In : leadListToInsertLS
                                AND UserOrGroupId in :roleNameGroupIdMap.values()
                                AND RowCause = 'Manual']){
          existingLeadSet.add(ls.LeadId);
        }*/

        if (leadIDSetToInsertNALS.size() == 0 && leadIdToDeleteNALS.size() == 0 && leadIdSetToInsertLS.size() == 0 && leadIdToDeleteLS.size() == 0) {
            return;
        }

        leadShareToBeInserted = new List<LeadShare>();
        leadShareToBeDeleted = new List<LeadShare>();

        //Get RoleID
        Map<ID, UserRole> mapUserRole = new Map<ID, UserRole>([select Id , name from UserRole where name IN ('NA Commercial', 'Commercial Regional Sales Manager NA')]);

        // Get GroupID
        Set<ID> setGroup = new Set<ID>();
        Map<String, Id> roleNameGroupIdMap = new Map<String, Id>();

        for (Group g : [select id, relatedID from Group where relatedid in :mapUserRole.keySet() and type = 'Role']) {
            setGroup.Add(g.ID);
            if (mapUserRole.get(g.relatedID) != null)
                roleNameGroupIdMap.put(mapUserRole.get(g.relatedID).name, g.ID);
        }
        System.debug('*********shareLeadRecordsAfterInsertAndUpdate in map******* list size ' + leadListNew.size());
        // Preparing Map of LeadShare for Leads
        Map<Id, LeadShare> leadShareMap = new Map<Id, LeadShare> ([select id, LeadId, UserOrGroupId, RowCause from LeadShare where LeadId In :leadListNew AND UserOrGroupId IN:setGroup ]);

        for (Id leadId : leadIDSetToInsertNALS) {
            leadShareToBeInserted.add(getLeadShare(leadId , roleNameGroupIdMap.get('NA Commercial')));
        }
        for (LeadShare ls : leadShareMap.values()) {
            if (leadIdSetToInsertLS.contains(ls.LeadId) && setGroup.contains(ls.UserOrGroupId) && ls.RowCause == 'Manual')
                existingLeadSet.add(ls.LeadId);
            else if ( ((leadIdToDeleteNALS.contains(ls.LeadID) && ls.UserOrGroupId == roleNameGroupIdMap.get('NA Commercial'))
                       || (leadIdToDeleteLS.contains(ls.LeadID) && setGroup.contains(ls.UserOrGroupId)) )
                      && ls.RowCause == 'Manual') {
                leadShareToBeDeleted.add(ls);
            }
        }

        for (Lead lead : leadListToInsertLS) {
            if (!existingLeadSet.contains(lead.Id)) {
                // RLC Commercial Leads shared with roles : "NA Commercial",
                //    "Commercial Regional Sales Manager NA" and read only access
                //  Also NA Commercial Leads shared with role : "Commercial Regional Sales Manager NA" and read only access
                if ( (lead.Business_Unit__c == 'RLC' && lead.RLC_Type__c == 'Light Commercial')
                        || lead.Business_Unit__c == 'NA Commercial' ) {
                    if (lead.Business_Unit__c == 'RLC' && lead.RLC_Type__c == 'Light Commercial') {
                        leadShareToBeInserted.add(getLeadShare(lead.Id , roleNameGroupIdMap.get('NA Commercial')));
                    }
                    leadShareToBeInserted.add(getLeadShare(lead.Id , roleNameGroupIdMap.get('Commercial Regional Sales Manager NA')));
                }
            }
        }

    }

    private static LeadShare getLeadShare(Id leadId , Id userOrGroupId) {
        LeadShare ls = new LeadShare();
        ls.LeadId = leadId;
        ls.UserOrGroupId = userOrGroupId;
        ls.LeadAccessLevel = 'read';
        return ls;
    }


    public static void AfterLeadStatusUpdate(Map<Id, Lead> leadMap, List<Site_Information_Form__c> UpdatedSite) {

        List<Site_Information_Form__c> Sitelst = new List<Site_Information_Form__c>();
        ID siteRecordTypeId;
        if (leadMap.size() == 0) {
            return;
        }

        //Site RecordTypeId
        Map <String, ID> siteRecordTypes = new Map<String, ID>();
        Schema.DescribeSObjectResult dc = Schema.SObjectType.Site_Information_Form__c;
        Map<Id, Schema.RecordTypeInfo> siteMapById = dc.getRecordTypeInfosById();
        for (ID i : siteMapById.keySet()) {
            siteRecordTypes.put(siteMapById.get(i).name, string.valueOf(i));
        }

        if (siteRecordTypes.get('Lead Sites') != null)
            siteRecordTypeId = siteRecordTypes.get('Lead Sites');

        Set<String> leadsWithSite = new Set<String>();
        for (Site_Information_Form__c site : [Select Id, Lead__c, RecordType.Name, RecordTypeId, Site_Address__c, Site_City__c, Site_Zip_Postal_Code__c, Site_State__c
                                              from Site_Information_Form__c where Lead__c in :leadMap.keySet() and RecordType.Name = 'Lead Sites']) {
            leadsWithSite.add(site.Lead__c);
            if (leadMap.get(site.Lead__c).Facility_Address__c == null && leadMap.get(site.Lead__c).Facility_Address_2__c == null && leadMap.get(site.Lead__c).facility_City__c == null && leadMap.get(site.Lead__c).Facility_Zip__c == null && leadMap.get(site.Lead__c).Facility_State__c == null) {
                continue;
            }
            site.Site_Address__c = leadMap.get(site.Lead__c).Facility_Address__c + ' ' + leadMap.get(site.Lead__c).Facility_Address_2__c;
            site.Site_City__c = leadMap.get(site.Lead__c).Facility_City__c;
            site.Site_Zip_Postal_Code__c = leadMap.get(site.Lead__c).Facility_Zip__c;
            site.Site_State__c = leadMap.get(site.Lead__c).Facility_State__c;
            UpdatedSite.add(site);
        }

        for (Lead newlead : leadMap.values()) {
            if (leadMap.get(newlead.Id).Facility_Address__c == null && leadMap.get(newlead.Id).Facility_Address_2__c == null && leadMap.get(newlead.Id).facility_City__c == null && leadMap.get(newlead.Id).Facility_Zip__c == null && leadMap.get(newlead.Id).Facility_State__c == null) {
                continue;
            }
            if (!leadsWithSite.contains(newlead.id)) {
                Site_Information_Form__c Newsite = new Site_Information_Form__c();
                Newsite.Site_Status__c = 'Active';
                Newsite.RecordTypeId = siteRecordTypeId;
                Newsite.Site_Name__c = leadMap.get(newlead.Id).Company + ' Site';
                Newsite.Lead__c = newlead.Id;
                Newsite.Site_Address__c = leadMap.get(newlead.Id).Facility_Address__c + ' ' + leadMap.get(newlead.Id).Facility_Address_2__c;
                Newsite.Site_City__c = leadMap.get(newlead.Id).Facility_City__c;
                Newsite.Site_Zip_Postal_Code__c = leadMap.get(newlead.Id).Facility_Zip__c;
                Newsite.Site_State__c = leadMap.get(newlead.Id).Facility_State__c;
                UpdatedSite.add(Newsite);
            }
        }
        // upsert UpdatedSite;

    }

    //Moving method after_Lead_Update from LeadConversion.cls
    /**
    trg_Lead_Convert
          Description:Its an after update trigger
          Created date:4/23/10
          Created By: Accenture
          Last Updated Date: 11/05/10
          Last Updated By:Accenture
          Modification History:  ******

                    4/23/10 -Intial Design Framed for trigger-Creating initial version of code which has to be modified  in order to follow
                    4/26/10 - Review comment given Review comment for this suggests to add proper documentation, Follow  proper naming Standrads, and clearly depicts each and every method with an user friendly documentation
                    4/28/10 - Incorporating those review comments All the review comments have been incorporated as   suggested in the build review document.
                    4/28/10 - Creating Apex clases and calling trigger from that Based on the review comments, we are  invoking the apex trigger form inside a trigger.
                    6/12/2012- Amit Saha Birlasoft- Case 00132012- if the customer is related to USA/United States and Record type = 'Residential Lease', then in the converted contact need to check 2 fields- Primary and 'Include in Lease Doc ', Also need to update the PrimaryContact field on Converted Opportunity so that it shows the id of the contact which was made primary.This changes is only going to affect
                    where country(Standard Field) = USA/United States.

    Updated on 25 Nov 2013 by Amit Saha Birlasoft
    We have removed the condition that Primary_contact__c on Opportunity shoudl only be assigned value WHEN Lease country is USA.
    Now it should be assigned value even for Europe

    ***/
    
    public static void after_Lead_Update (List<Lead> leadLst){
        User userStatus = Util.currentUser;
        
        if(userStatus.Web_User__c != True) {
            Set<id> leadid = new Set<id>();
            Set<id> accAffid = new Set<id>();
            Set<id> accCompId = new Set<id>();
            Set<id> oppId = new Set<id>();
            Set<id> ContactId = new Set<id>();
            Set<Date> datId = new Set<Date>();
            Set<Date> dat1Id = new Set<Date>();
            Set<string> accAffMan = new Set<string>();
            Set<string> accAggStat = new Set<string>();
            Id IdContact ;
            Id record = Schema.SObjectType.Opportunity_Role__c.RecordTypeInfosByName.get('Affiliate').RecordTypeId;
            Id record1 = Schema.SObjectType.Opportunity_Role__c.RecordTypeInfosByName.get('Competitor').RecordTypeId;
            Id record2 = Schema.SObjectType.Site_Information_Form__c.RecordTypeInfosByName.get('Standard Site').RecordTypeId;
            
            List<Lead> leadList = new List<Lead>();
            List<Site_Information_Form__c> siteL = new List<Site_Information_Form__c>();
            List<Opportunity_Role__c> oppRList = new List<Opportunity_Role__c>();
            List<Opportunity_Role__c> oppRList1 = new List<Opportunity_Role__c>();
            List<Contact> ContList = new List<Contact>();
            Set<String> convertedOpp = new Set<String>();
            List<Opportunity> primaryContactOppsToUpdate = new List<Opportunity>();    
            
            for(Lead led: leadLst) {
                if(led.IsConverted == True) {
                    leadid.add(led.Id);
                    accAffid.add(led.Affiliate_Account__c);
                    accCompId.add(led.Competitor_Account__c);
                    oppId.add(led.ConvertedOpportunityId);
                    datId.add(led.Affiliate_Lead_Registered_Date__c);
                    dat1Id.add(led.Affiliate_Lead_Expired_Date__c);
                    accAffMan.add(led.Affiliate_Account_Manager__c);
                    accAggStat.add(led.Affiliate_Agreement_Status__c);
                    ContactId.add(led.ConvertedContactId);
                    convertedOpp.add(led.ConvertedOpportunityId);
                }
            }
            
            if(!leadid.isEmpty()) {
                //Run queries as needed
                List <Contact> ContactList = new List<Contact>([SELECT Id, Primary__c, Include_in_Lease_Doc__c FROM Contact WHERE Id IN: ContactId]);
                List<Opportunity> opplstToUpdate = new  List<Opportunity>([SELECT Id, Primary_Contact__c FROM Opportunity 
                                                                           WHERE Id IN: convertedOpp AND Primary_Contact__c = null]);
                List <Site_Information_Form__c> siteList = new List<Site_Information_Form__c>([SELECT Id, Name, Lead__r.ConvertedAccountId, Lead__r.ConvertedOpportunityId
                                                                                               FROM Site_Information_Form__c WHERE Lead__c IN: leadid]);
                
                //To update the Primary__c and Include_in_Lease_Doc__c to true for the converted contact.
                if(ContactList != null && !ContactList.isEmpty()) {
                    for(Contact c : ContactList) {
                        c.Primary__c = True;
                        c.Include_in_Lease_Doc__c = True;
                        IdContact = c.id;
                        ContList.add(c);
                    }
                }
                if(!ContList.isEmpty()) {
                    update ContList;
                }
                //Update Primary Contact on Opportunity (is this right??)
                if(!opplstToUpdate.isEmpty()) {
                    for(Opportunity nextOpp : opplstToUpdate ) {
                        if(nextOpp.Primary_Contact__c == null) {
                            nextOpp.Primary_Contact__c = IdContact;//Updating with Contact Id whcih has Primary field True
                            primaryContactOppsToUpdate.add(nextOpp);
                        }
                    }
                }
                if(!primaryContactOppsToUpdate.isEmpty()) {
                    update primaryContactOppsToUpdate ;
                }       
                //site creation and Update
                if(siteList != null && !siteList.isEmpty()){
                    for(Site_Information_Form__c s : siteList){
                        s.Account__c = s.Lead__r.ConvertedAccountId;
                        s.Opportunity_del__c = s.Lead__r.ConvertedOpportunityId;
                        s.RecordTypeId = record2;
                        siteL.add(s);
                    }
                }
                if(!siteL.isEmpty()) {
                    update siteL;
                }
                
                for(Lead l : leadLst){
                    if(l.Affiliate_Account__c != null && l.Competitor_Account__c == null){
                        Opportunity_Role__c oppRole = new Opportunity_Role__c();
                        oppRole.RecordTypeId = record;
                        oppRole.Opp_Name__c = l.ConvertedOpportunityId;
                        oppRole.Affiliate_Registration_Date__c = l.Affiliate_Lead_Registered_Date__c;
                        oppRole.Affiliate_Expiration_Date__c = l.Affiliate_Lead_Expired_Date__c;
                        oppRole.Affiliate_Account_Manager__c =l.Affiliate_Account_Manager__c;
                        oppRole.Affiliate_Agreement_Status__c =l.Affiliate_Agreement_Status__c;
                        oppRole.Account__c = l.Affiliate_Account__c;
                        oppRList.add(oppRole);
                    } else if(l.Affiliate_Account__c == null && l.Competitor_Account__c != null){
                        Opportunity_Role__c oppRole = new Opportunity_Role__c();
                        oppRole.RecordTypeId = record1;
                        oppRole.Opp_Name__c = l.ConvertedOpportunityId;
                        oppRole.Affiliate_Registration_Date__c = l.Affiliate_Lead_Registered_Date__c;
                        oppRole.Account__c = l.Competitor_Account__c;
                        oppRList.add(oppRole);
                    } else if(l.Affiliate_Account__c != null && l.Competitor_Account__c != null){
                        Opportunity_Role__c oppRole = new Opportunity_Role__c();
                        oppRole.RecordTypeId = record;
                        oppRole.Opp_Name__c = l.ConvertedOpportunityId;
                        oppRole.Affiliate_Registration_Date__c = l.Affiliate_Lead_Registered_Date__c;
                        oppRole.Affiliate_Expiration_Date__c = l.Affiliate_Lead_Expired_Date__c;
                        oppRole.Affiliate_Account_Manager__c =l.Affiliate_Account_Manager__c;
                        oppRole.Affiliate_Agreement_Status__c =l.Affiliate_Agreement_Status__c;
                        oppRole.Account__c = l.Affiliate_Account__c;
                        oppRList.add(oppRole);
                        
                        Opportunity_Role__c oppRole1 = new Opportunity_Role__c();
                        oppRole1.RecordTypeId = record1;
                        oppRole1.Opp_Name__c = l.ConvertedOpportunityId;
                        oppRole1.Affiliate_Registration_Date__c = l.Affiliate_Lead_Registered_Date__c;
                        oppRole1.Account__c = l.Competitor_Account__c;
                        oppRList.add(oppRole1);
                    }
                }
                if(!oppRList.isEmpty()){
                    Insert oppRList;
                }
            }
        }
    }
    

    public static boolean setAutoConvertLeadFields(Lead l){
        boolean statusUpdated = false;
        if (l.Source_System__c == 'Eloqua'){
            if (l.Lead_Inferred_Quality__c == 'Reject')
                l.Status = 'SPAM';//not valid scenario anymore DOTS - retire?
            else if (l.Lead_Inferred_Quality__c == 'Accept' && l.Lead_Data_Quality__c == 'Qualified')
                //l.Status = 'Qualified';
                l.Status = 'Marketing Qualified';
            else if ((l.Lead_Inferred_Quality__c == 'Accept' || l.Lead_Inferred_Quality__c == 'Review') && l.Lead_Data_Quality__c == 'Disqualified') {
                System.debug('Should be disualified here');
                l.Status = 'Disqualified';
                //l.Reason__c = 'Dynaform';
            }
            //Need to add reason here
            else if ((l.Lead_Inferred_Quality__C == 'Accept' || l.Lead_Inferred_Quality__c == 'Review') && l.Lead_Data_Quality__c == 'Undetermined'){
                System.debug('Awaiting Qualification Review');
                l.Status = 'Awaiting Qualification Review';
            }
            //change to disqualified and add reason
            else if (l.Lead_Inferred_Quality__c == 'Review' && l.Lead_Data_Quality__c == 'Qualified')
                l.Status = 'Awaiting Qualification Review';//not valid scenario anymore DOTS - retire?
            else if(l.Lead_Data_Quality__c == 'Qualified')
                l.Status = 'Marketing Qualified'; 
            else {
                l.Status = 'Awaiting Qualification Review'; 
                System.debug('No matching criteria');
            }
            statusUpdated = true;
            return statusUpdated;
        }
        
        l.IsAutoConvert__c = false;
        if (l.Country == 'United States of America' || l.Country == 'USA'){ 
            l.Country = 'United States';
        }
        return statusUpdated;
    } 
    
    //new method with removal of dots - for testing issues with new spd alr process
    public static boolean setAutoConvertLeadFieldsSPD(Lead l){
        boolean statusUpdated = false;
        if (l.Source_System__c == 'Eloqua'){
            if (l.Lead_Data_Quality__c == 'Qualified')
                l.Status = 'Marketing Qualified';
            else if (l.Lead_Data_Quality__c == 'Disqualified') {
                l.Status = 'Disqualified';
                //l.Reason__c = 'Dynaform';
            }
            else if (l.Lead_Data_Quality__c == 'Undetermined') {
                l.Status = 'Disqualified';
                l.Reason__c = 'Awaiting Qualification Review';
            }
            else { 
                l.Status = 'Disqualified';
                l.Reason__c = 'Awaiting Qualification Review';
            }
            statusUpdated = true;
        }
        
        l.IsAutoConvert__c = false;
        if (l.Country == 'United States of America' || l.Country == 'USA'){ 
            l.Country = 'United States';
        }
        return statusUpdated;
    } 

    public static void setFieldsBasedOnLeadValues(lead l, Lead oldLead)
    {
        
        system.debug(' == Rec   ===>'+l.RecordTypeId);
        system.debug(' === Status==>'+l.Status);
        
        // Added to handle Lead with null record TYpe
        if(l.RecordTypeId == null && l.Status == 'Open')
        {
            l.RecordTypeId = ResidentialRecordTypeId;
            l.Status = 'Marketing Qualified';
        }
        
        if(l.LeadSource!=null&&l.LeadSource.containsIgnoreCase('Jigsaw')){
            if(oldLead==null){
                l.LeadSource = 'Data.Com - Sales';
            }
            else if(oldLead.leadSource!=l.LeadSource){
                l.LeadSource = 'Data.Com - Sales';
            }
        }
        //workflow rule "Update Primary Contact"
        if(l.RecordTypeId == ResidentialRecordTypeId){//lead is a residential record type
            if(oldLead==null){
                l.RLC_Type__c = 'Residential';//moved from autoconvert logic so this would be set on residential leads on insert regardless of their status
                l.Primary_Contact__c = true;
            }
            else if(oldLead.recordTypeId!=l.RecordTypeId){
                l.RLC_Type__c = 'Residential';//moved from autoconvert logic so this would be set on residential leads on insert regardless of their status
                l.Primary_Contact__c = true;
            }
        }
        
        if (l.Street == null && l.State == null && l.PostalCode == null && l.City == null) {
            if(oldLead==null)
               l.Country = null;
            else if(oldLead.Country != l.Country)
                l.Country = null;
        }
        if (l.Country == null && l.State != null && STATES.containsIgnoreCase(l.State)){
            if(oldLead==null)
               l.Country = 'United States';         
            else if((l.State != oldLead.State) && l.Country == null && l.State != null && STATES.containsIgnoreCase(l.State))
                l.Country = 'United States';
        }
        if(l.SPWR_Industry_Type__c!=null){
            if(oldLead==null)
              l.SPWR_Industry_Type_Hidden__c = l.SPWR_Industry_Type__c;
            else if(l.SPWR_Industry_Type__c != null && l.SPWR_Industry_Type__c != oldLead.SPWR_Industry_Type__c)
          l.SPWR_Industry_Type_Hidden__c = l.SPWR_Industry_Type__c;
        }
        if (l.Owner.Type == 'User'){
            if(oldLead==null)
              l.Lead_Owner_Mapping__c = l.OwnerId;//for case # 00060281
            else if(l.Owner.Type == 'User' && l.Owner.Type != oldLead.Owner.Type)
          l.Lead_Owner_Mapping__c = l.OwnerId;
        }
        if (l.Theater__c == 'NA'){
            if(oldLead==null)
               l.Theater__c='';
            else if(l.Theater__c == 'NA' && l.Theater__c != oldLead.Theater__c)
          l.Theater__c=''; 
        }
      //no leads since 2011 have a promo code that matches these values. Depricated - 11/11/2014
        //if(l.Promo_Code__c!=null && (l.Promo_Code__c=='2011_NA_RLC_KeywordC' || l.Promo_Code__c=='2011_NA_RLC_NJRadio' || l.Promo_Code__c=='2011_NA_RLC_Sdtv') ){ 
      //      l.Status='Qualified';
      //  }
        if(l.First_follow_up__c){
            if(oldLead==null)
              l.Date_Time_First_follow_up__c = Datetime.now();
            else if(l.First_Follow_up__c && l.First_Follow_up__c != oldLead.First_follow_up__c)
          l.Date_Time_First_follow_up__c = Datetime.now();  
        }
        if(l.Second_follow_up__c){
            if(oldLead==null)
              l.Date_Time_Second_follow_up__c = Datetime.now();
            else if(l.Second_Follow_up__c && l.Second_Follow_up__c != oldLead.Second_follow_up__c)
          l.Date_Time_Second_follow_up__c = Datetime.now();
        }
        if(l.Third_follow_up__c){
            if(oldLead==null)
              l.Date_Time_Third_follow_up__c = Datetime.now();
            else if(l.Third_Follow_up__c && l.Third_Follow_up__c != oldLead.Third_follow_up__c)
          l.Date_Time_Third_follow_up__c = Datetime.now();       
        }
        if(l.Fourth_follow_up__c){
            if(oldLead==null)
              l.Date_Time_Fourth_follow_up__c = Datetime.now();
            else if(l.Fourth_Follow_up__c && l.Fourth_Follow_up__c != oldLead.Fourth_follow_up__c)
          l.Date_Time_Fourth_follow_up__c = Datetime.now();   
        }
        if(l.Fifth_follow_up__c){
            if(oldLead==null)
              l.Date_Time_Fifth_follow_up__c = Datetime.now();
            else if(l.Fifth_Follow_up__c && l.Fifth_Follow_up__c != oldLead.Fifth_follow_up__c)
             l.Date_Time_Fifth_follow_up__c = Datetime.now(); 
        }
        if (l.Status == 'Ready for Conversion' && !l.IsConverted){//from setleadautoconvert
            if(oldLead==null)
                l.IsAutoConvert__c = true;
            else if((l.Status != oldLead.Status) && l.Status == 'Ready for Conversion' && oldLead.Status != 'Ready for Conversion' && !l.IsConverted) 
              l.IsAutoConvert__c = true;
        }
        if(!Util.byPassValidation()){
            if(oldLead==null){
              l.HD_Business_Unit__c = l.Business_Unit__c;
              l.HD_Lead_Status__c   = l.Status;
            }
            //else if(l.Business_Unit__c != oldLead.Business_Unit__c){
            else if(l.Business_Unit__c != oldLead.Business_Unit__c || l.Status != oldLead.Status){//added status 1/6/15
                l.HD_Business_Unit__c = l.Business_Unit__c;
                l.HD_Lead_Status__c   = l.Status;
            }
        }
    }

    public static Set<Id> findDuplicateLeads(Map<String, Id> dupCheckMap){
        Set<Id> dupLeads = new set<Id>();
        for(Lead plResult : [SELECT Id, Email FROM Lead WHERE Email IN :dupCheckMap.keySet() AND ID NOT IN : dupCheckMap.values()]){
            if(plResult.Email != null && dupCheckMap.containsKey(plResult.Email)){
               dupLeads.add(dupCheckMap.get(plResult.Email));
            }
        }    

        for(Contact pcResult : [SELECT ID, Email FROM Contact WHERE Email IN : dupCheckMap.keySet()]){
          if(pcResult.Email!=null && dupCheckMap.containsKey(pcResult.Email)){
            dupLeads.add(dupCheckMap.get(pcResult.Email));
          }
        } 
        return dupLeads;
    }
    
    public static Set<String> getSpdIds() {
        Set<String> spdIDSet = new Set<String>();
         spdIDSet.addAll(Label.SPDIds.split(','));
        return spdIDSet;
    }
   
    //new autoconvert method for after lead dealer assignment for partner leads and after appointment confirmed for spd leads
     public static void BulkConvert(List<Lead> leadList) {
         
        Util.setInContextOfLeadConversion();
        //Collections and variables
        String partner_qualified = 'Partner Qualified';
        String appt_confirmed = 'Appointment Confirmed';
        Set<String> spdIds = getSpdIds();
        List<Lead> exceptionLeads = new List<Lead>();
        Map<Id, String> lcrErrors = new Map<Id, String>();
        List<Lead> failedLeads = new List<Lead>();
        List<Exception_Log__c> logsToInsert = new List<Exception_Log__c>();
        Map<Id, Id> convertedOppIds = new Map<Id, Id>(); //Map<LeadId, ConvertedOppId>
        Map<Id, Id> oppKeysMap = new Map<Id, Id>();
        List<Dealer_Assignment_Audit__c> daaList = new List<Dealer_Assignment_Audit__c>();
        List<Eligible_Dealer__c> edList = new List<Eligible_Dealer__c>();       
        
        // Added for Lead bulk conversion 
        list<Database.LeadConvert> lstLeadConvert = new list<Database.LeadConvert>();
        map<Id,Lead> mapLead = new map<Id,Lead>(leadList);
        map<Id,list<Lead>> mapDealerCount = new map<Id,list<Lead>>();
        
        //collect lead Ids
        Map<Id, Id> leadIds = new Map<Id, Id>();
        for(Lead l : leadList) {
            leadIds.put(l.Id, l.Dealer_Locator_Selection__r.Opportunity_Recipient__c);
        }        
        
        List<LeadStatus> convertStatus = new List<LeadStatus>([SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true AND (MasterLabel =: partner_qualified OR MasterLabel =: appt_confirmed)]);
        Map<String, String> statusMap = new Map<String, String>();
        for(LeadStatus ls : convertStatus) {
            if(ls.MasterLabel == partner_qualified) {
                statusMap.put(partner_qualified, ls.MasterLabel);
            } else if(ls.MasterLabel == appt_confirmed) {
                statusMap.put(appt_confirmed, ls.MasterLabel);
            }
        }
                                                     
        //Collect Lead Dealer Audits and Eligible Dealers from leads before conversion
        List<Lead_Dealer_Assignment_Audit__c> auditList = new List<Lead_Dealer_Assignment_Audit__c>();
        Map<Id, List<Lead_Eligible_Dealers__c>> ldaaMap = new Map<Id, List<Lead_Eligible_Dealers__c>>();
        auditList = [SELECT Id, Name, Lead__c, Lead__r.Id, ALR_Rule_Applied__c, Assignment_Date__c, Campaign__c, 
                     Dealer_Assigned__c, Reason__c, LeadCreatedDate__c, (SELECT Id, Name, Dealer__c, Dealer__r.Name, Score__c, Distance__c, Selected__c
                                                                         FROM Lead_Eligible_Dealers__r)
                     FROM Lead_Dealer_Assignment_Audit__c WHERE Lead__c IN: leadids.keyset()];

        //loop through list and convert, gather converted opp Ids to create new audits/dealer records
        //Create exception logs for all leads that weren't converted
        for(Lead l : leadList)
        {
            //Lead l = new Lead(id = ld.Id);
            if(l.IsConverted || !l.IsAutoConvert__c || l.RecordType.Name == 'Partner' || l.Dealer_Locator_Selection__c == null) 
            {
                Lead objLead = new Lead(Id = l.id);
                failedLeads.add(objLead);   
                //failedLeads.add(l); 
                
                    Exception_Log__c log = new Exception_Log__c();
                    log.Lead_Id__c = l.Id;
                    log.Error_Message__c = 'Error Msg Values: ' + l.IsConverted + ' - converted, ' + l.IsAutoConvert__c + ' - isAutoConvert, ' + l.RecordType.Name + ' - rec type name';//'Unqualified lead sent to residential conversion process with either a partner record type or missing dealer.';
                    logsToInsert.add(log);

            } else {
                
                Database.LeadConvert lc = new Database.LeadConvert();
                lc.setLeadId(l.Id);
                lc.setOpportunityName(l.Company);

                if(spdIds.contains(l.Dealer_Locator_Selection__c)) {
                    lc.setConvertedStatus(statusMap.get(appt_confirmed));
                } else {
                    lc.setConvertedStatus(statusMap.get(partner_qualified));
                }
                lc.setOwnerId(leadIds.get(l.Id));
                lc.overwriteLeadSource = TRUE;              
                
                // Bulk Lead Convert List
                lstLeadConvert.add(lc);
            }
        }
        
        /***************** Lead Bulk Conversion ********************/
        if(!lstLeadConvert.isEmpty()){
            try{
                list<Database.LeadConvertResult> listLcr = Database.convertLead(lstLeadConvert);
                
                // Lead Conversion Result
                for(Database.LeadConvertResult lcr : listLcr){
                    if (lcr.isSuccess() == false) {
                        exceptionLeads.add(mapLead.get(lcr.getLeadId()));
                        lcrErrors.put(lcr.getLeadId(), String.valueOf(lcr.getErrors()));
                    } else 
                    {
                        /*Created Dealer and Assigned Lead map to update the Dealer Count in Dealer Object*/
                        Lead objLead = mapLead.get(lcr.getLeadId());
                        if(objLead.Dealer_Locator_Selection__c != null){
                            if(mapDealerCount.ContainsKey(objLead.Dealer_Locator_Selection__c))
                                mapDealerCount.get(objLead.Dealer_Locator_Selection__c).add(objLead);
                            else{
                                list<Lead> tempLead = new list<Lead>();
                                tempLead.add(objLead);
                                mapDealerCount.put(objLead.Dealer_Locator_Selection__c,tempLead);
                            }
                        }
                        convertedOppIds.put(lcr.getLeadId(), lcr.getOpportunityId());
                        oppKeysMap.put(lcr.getOpportunityId(), lcr.getLeadId());
                    }
                }
            } catch (Exception ex){
                exceptionLeads.add(mapLead.get(lstLeadConvert[0].getLeadID()));
                Exception_Log__c log = new Exception_Log__c();
                log.Lead_Id__c = lstLeadConvert[0].getLeadID();
                log.Error_Message__c = ex.getMessage();
                log.Stack_Trace__c = ex.getStackTraceString();
                logsToInsert.add(log); 
            }
        }
        
        // Updated Dealer Count 
        UpdateDealerLeadCountonLead(mapDealerCount);

        //Recreate Dealer Assignments and Eligible Dealers
        for(Lead_Dealer_Assignment_Audit__c ldaa1 : auditList) {
            ldaaMap.put(ldaa1.Lead__r.Id, ldaa1.Lead_Eligible_Dealers__r);
        }
        
        Map<Id, List<Lead_Eligible_Dealers__c>> oppToLEDDMap = new Map<Id, List<Lead_Eligible_Dealers__c>>();
        
        if(auditList != null && !auditList.isEmpty()){
            for(Lead_Dealer_Assignment_Audit__c ldaa : auditList) {
                for(Id lId : convertedOppIds.keyset()){
                    if(ldaa.Lead__c == lid) {
                        List<Lead_Eligible_Dealers__c> ledTempList = new List<Lead_Eligible_Dealers__c>();
                        Dealer_Assignment_Audit__c newDAA = new Dealer_Assignment_Audit__c();
                        newDAA.Name = ldaa.Name;
                        newDAA.ALR_Rule_Applied__c = ldaa.ALR_Rule_Applied__c;
                        newDAA.Assignment_Date__c = ldaa.Assignment_Date__c;
                        newDAA.Campaign__c = ldaa.Campaign__c;
                        newDAA.Reason__c = ldaa.Reason__c;          
                        newDAA.Dealer_Assigned__c = ldaa.Dealer_Assigned__c;
                        newDAA.Opportunity__c = convertedOppIds.get(lId);
                        daaList.add(newDAA);
                        if(ldaa.Lead_Eligible_Dealers__r != null) {
                            for(Lead_Eligible_Dealers__c leds :  ldaa.Lead_Eligible_Dealers__r) {
                                ledTempList.add(leds);
                            }
                        }
                        oppToLEDDMap.put(convertedOppIds.get(lID), ledTempList);//opp id with list of transferrable eligible dealers
                    }
                }
            }
        }
        //finds leads that failed, check to make sure they are in fact not converted
        //update failed leads and create exception logging
         List<Lead> leads = new List<Lead>();
         List<Lead_Dealer_Assignment_Audit__c> failedAssignments = new List<Lead_Dealer_Assignment_Audit__c>();
         if(exceptionLeads != null && !exceptionLeads.isEmpty()) {
             leads = [SELECT l.Id, l.isConverted, l.Status, l.isAutoConvert__c, Dealer_Assignment_Date__c, Reason__c,
                      (SELECT Id FROM Lead_Dealer_Assignment_Audits__r ORDER BY CreatedDate Desc LIMIT 1)
                      FROM Lead l WHERE l.Id IN: exceptionLeads];
             
             for(Lead fld : leads) { 
                 if(!fld.isConverted){
                     //Update Failed Conversion status for failed leads 
                     Lead objlead = new Lead(Id =fld.Id,Status='Failed Conversion',isAutoConvert__c=false,Dealer_Assignment_Date__c = null, Reason__c = null);
                     failedLeads.add(objlead);
                     //remove dealer assignment audit from last conversion attempt so dealer can be assigned again
                     for(Lead_Dealer_Assignment_Audit__c lda : fld.Lead_Dealer_Assignment_Audits__r) {
                         failedAssignments.add(lda);
                     }
                     
                 }
                 for(Id i : lcrErrors.keySet()) {
                     if(fld.Id == i) {
                         Exception_Log__c log = new Exception_Log__c();
                         log.Lead_Id__c = fld.Id;
                         log.Error_Message__c = lcrErrors.get(i);
                         logsToInsert.add(log); 
                     }
                 }
             }
         }
        
        if(!failedLeads.isEmpty()){
            update failedLeads;
        }
         if(!failedAssignments.isEmpty()) {
             delete failedAssignments;
         }
        if(!logsToInsert.isEmpty()){
            try {
                insert logsToInsert;
            } catch(Exception e){}
        }
        if(!daaList.isEmpty()) {
            insert daaList;
                    
            List<Eligible_Dealer__c> eligibleDealerRecords = new List<Eligible_Dealer__c>(); //for dml
            
            List<Dealer_Assignment_Audit__c> oppAuditList = new List<Dealer_Assignment_Audit__c>();
            oppAuditList = [SELECT Id, Opportunity__c, Name, ALR_Rule_Applied__c, Assignment_Date__c, Campaign__c, 
                                 Dealer_Assigned__c, Dealer_Assigned__r.Name, Reason__c, OpportunityCreatedDate__c
                         FROM Dealer_Assignment_Audit__c WHERE Opportunity__c IN: convertedOppIds.values()];            

            for(Dealer_Assignment_Audit__c odaa : oppAuditList) {
                for(Id oid : oppToLEDDMap.keySet()) {
                    if(oid == odaa.Opportunity__c) {
                        if(oppToLEDDMap.get(oid) != null) {
                            for(Lead_Eligible_Dealers__c leds : oppToLEDDMap.get(oid)) {
                                Eligible_Dealer__c newED = new Eligible_Dealer__c();
                                newED.Dealer_Assignment_Audit__c = odaa.Id;
                                newED.Name = leds.Dealer__r.Name;
                                newED.Dealer__c = leds.Dealer__c;
                                newEd.Score__c = leds.Score__c;
                                newED.Distance__c = leds.Distance__c;
                                newED.Selected__c = leds.Selected__c;
                                eligibleDealerRecords.add(newED);
                            }
                        }
                    }
                }
            }
            if(eligibleDealerRecords != null && !eligibleDealerRecords.isEmpty()) {
                insert eligibleDealerRecords;
            }
        }      
    }
    
    /*
        Method      : UpdateDealerLeadCountonLead
        Parameters  : map<Id,list<Lead>>
        Summary     : After Successful Lead assignement Dealer Lead Assignement Count updated
    */
    public static void UpdateDealerLeadCountonLead(map<Id,list<Lead>> mapDealerCount){
        if(mapDealerCount == null || mapDealerCount.isEmpty()) return;
        list<Account> lstAccount = new list<Account>();
        map<Id,Account> mapIdAccount = new map<Id,Account>([Select id,Lead_Assignment_Count__c,Last_Assigned_Date__c from Account where Id in : mapDealerCount.keySet()]);
        System.debug(mapIdAccount.size());
        if(mapIdAccount.isEmpty()) return;
        
       /*Dealer assignment count not counting, updated
        *  for(String strAccId : mapDealerCount.keySet())
        {
            
            Account objAccount = new Account(Id = strAccId);
            if(objAccount.Lead_Assignment_Count__c == null)
                objAccount.Lead_Assignment_Count__c = 0;
            
            objAccount.Lead_Assignment_Count__c = objAccount.Lead_Assignment_Count__c + mapDealerCount.get(strAccId).size();
            objAccount.Last_Assigned_Date__c = system.today();
            lstAccount.add(objAccount); 
        } */
        for(Id i : mapDealerCount.keySet()) {
            Account a = mapIdAccount.get(i);
            if(a == null) continue;
            if(a.Lead_Assignment_Count__c == null)
                a.Lead_Assignment_Count__c = 0;
            if(a.Last_Assigned_Date__c != null && a.Last_Assigned_Date__c != system.today()) {
                a.Lead_Assignment_Count__c = 0;
            }
            a.Lead_Assignment_Count__c = a.Lead_Assignment_Count__c + mapDealerCount.get(i).size();
            a.Last_Assigned_Date__c = System.today();
            lstAccount.add(a);
        }
            
        
        if(lstAccount.isEmpty()) return;
        
        list<Database.Saveresult> lstdbSaveResult = Database.update(lstAccount);
    }
 
}