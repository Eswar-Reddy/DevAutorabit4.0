/*****
MODIFICATION HISTORY:

BY:       Crystal - Redpoint - 4/8/2015
COMMENTS: Added qualifying logic for autoconversion for SPD Leads with appt. confirmed and all populated appointment fields
          **Remove skip on ln 290 after initial testing!

----------------------------

version: KCM_05052016
author: Kane Chelster Macaspac
last modified date/time: 05-10-2016 6:37PM Pacific
details:
1. added code to save in the lead record the very first dealer assigned to it.
2. change has not been approved for deployment and is commented out entirely to provent execution
3. use the version name KCM_05052016 as a search term in order to jump to the code segments specific to this version.

----------------------------

*****/

public with sharing class LeadBeforeUpdateHandler extends TriggerHandlerBase
{    
  // -------- Constants --------
  
  // -------- Constructor --------
  public LeadBeforeUpdateHandler(){}
  
  // -------- Variables --------
  private static String DEFAULT_PROJECT_STAGE;
  private static String staticDefaultHomeOwnerStage = null;
  private static String staticDefaultCommercialStage = null;
  private static User currentUser = Util.currentUser;
    private static Set<String> spdids = Utility_Lead.getSpdIds();
    
  // -------- Properties --------
  // Qualified records for actions
  private List<Lead> qualifiedLeads;
  private Set<Id> scoreUpdateLeads; 
  private Set<Id> autoConvertLeads;
  private Set<Id> eventLead;
  private Set<Id> teamLead;
  //  additions for new logic - 4/8/2015 - SPD
  private Set<Id> apptConfirmedLeads;
  private Set<Lead> resendToALR;
  private List<Lead> spdConvertableLeads = new List<Lead>();
  private List<Exception_Log__c> logs = new List<Exception_Log__c>();  
    //collections used for opp assignment & account, contact, opp field updates
  private List<Lead> qualConvertedLeads;
  private Map<Id, Account> accounts;
  private Map<Id, Opportunity> opportunities;
  private List<Account> acctRecords;
  private List<Opportunity> oppRecords;
  private List<Contact> conRecords;
    //Record type collections
  private Map<String, ID> accountRecordTypes;  
  private Map<String, ID> opportunityRecordTypes; 
  private Map<String, ID> contactRecordTypes; 
  private Map<String, String> leadRecordTypes; 
    //collection of owner/queues for autoConvert
  private Set<String> leadEventContactUser; 
  private Set<String> leadEventContactQueue; 
  private Set<Id> leadOwnerIdSet;  
  private Set<Id> leadOwnerIdQueueSet; 
    //Dupe check map
  private Map<String, Id> dupCheckByEmail;
    //Code Changes Related to Warm Transfer DealerOppRes Email Mapping  
    private Set<String>leadDealerLocationSelectionsIds=new Set<String>();// Instantiated to avoid null pointer
    private Map<Id,Account> dealerLocatorOppsEMailCollection=new Map<Id,Account>();// Instantiated to avoid null pointer
    public static DealerGeneral__c DEALERGENERAL = DealerGeneral__c.getInstance(UserInfo.getOrganizationId());//To Get Default Opportunity Owner id
    private static Set<String> spNhids = new Set<String>();//Set to contains all SunPower New Home Ids
  //begin qualifying
  public override void qualifyStartingRecords(List<sObject> newList, 
    List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap){
    Diagnostics.push('qualifyStartingRecords LBU');
    //trigger new and trigger old
    Map<ID, Lead> originalLeads = (Map<ID, Lead>)oldMap;
    Map<ID, Lead> modifiedLeads = (Map<ID, Lead>)newMap;
    //collections to hold qualified records
    qualifiedLeads = new List<Lead>();
    scoreUpdateLeads = new Set<Id>();
    eventLead = new Set<Id>();
    teamLead = new Set<Id>();
    autoConvertLeads = new Set<Id>();
    qualConvertedLeads = new List<Lead>();
    //autoConvert 
    leadEventContactUser = new Set<String>();  
    leadEventContactQueue = new Set<String>();  
    leadOwnerIdSet = new Set<Id>();
    leadOwnerIdQueueSet = new Set<Id>();
    //dupe map
    dupCheckByEmail = new Map<String, Id>();
    //collections for spd leads
    apptConfirmedLeads = new Set<Id>();
    
        
    //starting qualification process
    for(Lead l : modifiedLeads.values()){

        Utility_Lead.setFieldsBasedOnLeadValues(l, originalLeads.get(l.Id));
        
        if(doUpdateScore(l, originalLeads)){
            qualifiedLeads.add(l);
            scoreUpdateLeads.add(l.id);
        }
        
        System.debug('LBUH-------------l2.isConverted='+l.isConverted);
        System.debug('LBUH-------------l2.Status='+l.Status);
        System.debug('LBUH-------------l2.isAutoConvert='+l.IsAutoConvert__c);
        System.debug('LBUH-------------l2.RecordTypeId='+l.RecordTypeId);
        System.debug('LBUH-------------l2.Theater__c='+l.Theater__c);
        System.debug('LBUH-------------l2.FirstName='+l.FirstName);
        System.debug('LBUH-------------l2.Source_System__c='+l.Source_System__c);
        System.debug('LBUH-------------l2.Status='+l.Status);
        System.debug('LBUH-------------l2.Reason='+l.Reason__c);

        //setLeadAutoConvert qualifier
        if((!l.isConverted && l.Status != 'Ready for Conversion')
            && (l.Status=='Open' || l.Status == 'Marketing Qualified')
            && l.RecordTypeId == Utility_Lead.ResidentialRecordTypeId
            && l.FirstName != Utility_Lead.dealerGeneral.Lead_Test_First_Name__c
            && (l.Theater__c == 'North America' || l.Theater__c == 'Central America and the Caribbean')
            && l.Lead_Manufacturer__c == 'SunPower'
            &&((originalLeads.get(l.Id).Status !='Open' || originalLeads.get(l.Id).Status != 'Marketing Qualified' )
                || originalLeads.get(l.Id).RecordTypeId != Utility_Lead.ResidentialRecordTypeId
                || (originalLeads.get(l.Id).Theater__c != 'North America' && originalLeads.get(l.Id).Theater__c != 'Central America')
              )) {
                  
                  //set status field if lead meets initial qualification
                  //Utility_Lead.setAutoConvertLeadFields(l); - Only necessary on insert as determined 4/15/2015 - SPD
                  
                  if(util.isSkipTrigger('isLeadALR', Utility_Lead.ResidentialRecordTypeId)) {
                      if((l.Source_System__c == 'Eloqua' && (l.Status == 'Qualified' || l.Status == 'Marketing Qualified')) || (l.Source_System__c != 'Eloqua' && l.Status == 'Open')){
                          qualifiedLeads.add(l);
                          autoConvertLeads.add(l.Id);
                      }
                  }
                  if(l.Email != null && l.Status != 'Disqualified') {
                      dupCheckByEmail.put(l.Email, l.Id);
                  }
                  
              }

        if(!l.isConverted && l.RecordTypeId == Utility_Lead.ResidentialRecordTypeId && 
           (l.Status == 'Appointment Confirmed' || l.Status == 'Warm Transfer' )){
               apptConfirmedLeads.add(l.Id);
               System.debug('spd flow lead added for conversion');
               qualifiedLeads.add(l);
                                                               //Code Changes Related to Warm Transfer DealerOppRes Email Mapping  
                                                               if(null != l.Dealer_Locator_Selection__c && !String.isBlank(l.Dealer_Locator_Selection__c)){
                                                                   leadDealerLocationSelectionsIds.add(String.valueOf(l.Dealer_Locator_Selection__c));
           }        
           }        
        
        //gather newly converted leads with related accs and opps for opp assignment and field updates
        if(l.isConverted && (!originalLeads.get(l.Id).isConverted) && l.ConvertedAccountID != null && l.convertedOpportunityId != null){
            qualConvertedLeads.add(l);
        }
    
        //determine owner/queue based on LeadSource
        if(l.Event_Contact__c != null && l.Event_Contact__c != '' && (l.LeadSource != originalLeads.get(l.id).LeadSource || l.Event_Contact__c != originalLeads.get(l.Id).Event_Contact__c)){
            if(l.LeadSource=='Event' || l.LeadSource=='Event/Seminar/Webinar'){
                eventLead.add(l.Id);
                qualifiedLeads.add(l);
                if(l.Event_Contact__c.contains('Queue')){
                    leadEventContactQueue.add(l.Event_Contact__c);
                }
                else{
                    leadEventContactUser.add(l.Event_Contact__c);
                }
            }
            if(l.Lead_Team__c==null){
                teamLead.add(l.Id);
                if(l.OwnerId != null && String.valueOf(l.OwnerId).startsWith('005')){
                    leadOwnerIdSet.add(l.OwnerId);
                    qualifiedLeads.add(l);
                }
                else{
                    leadOwnerIdQueueSet.add(l.OwnerId);
                    qualifiedLeads.add(l);
                }
            }
      }
    } 
    Diagnostics.pop();
  }
  
  // Start processing records
  public override void start(){
    Diagnostics.push('start LBU');
      
    Set<String> existingAccountNames = new Set<String>();
    Set<Id> accIds = new Set<Id>();
    Set<Id> oppIds = new Set<Id>();
    accounts = new Map<Id, Account>();
    opportunities = new Map<Id, Opportunity>();
        spNhids.addAll(Label.SP_NH_Ids.split(',')); // Populate Set with Label values
    //fill accIds and oppIds for comparison in opportunity assignment  
    if(qualConvertedLeads != null && !qualConvertedLeads.isEmpty()){
      for(Lead lead : qualConvertedLeads){
          accIDs.add(lead.ConvertedAccountID);
          oppIDs.add(lead.ConvertedopportunityID);
      }
    }
        
    //build map of accounts/opportunities
        if(accIDs.size() > 0 || leadDealerLocationSelectionsIds.size()>0){
            //Query Modified Related to Warm Transfer DealerOppRes Email Mapping to get Additional_Opportunity_Email_Recipient__c and Opportunity_Recipient__r
            accounts  =  new Map<ID,Account>([SELECT id ,IsPersonAccount,Name,Additional_Opportunity_Email_Recipient__c,Opportunity_Recipient__r.Email  FROM Account WHERE id IN: accIDs OR id IN :leadDealerLocationSelectionsIds]); 
      for(Account acc:accounts.values()){
            existingAccountNames.add(acc.Name);
                //Code Modified Related to Warm Transfer DealerOppRes Email Mapping Will Create a Collection for Account Id and Account  
                if(leadDealerLocationSelectionsIds!=null && leadDealerLocationSelectionsIds.contains(acc.Id)){
                    dealerLocatorOppsEMailCollection.put(acc.id,acc);
      }
      }
    }
    if(oppIDs.size() > 0){
        opportunities  =  new Map<ID,Opportunity>([SELECT id ,RecordTypeId, Facility_Address1__c, Facility_State1__c, Facility_City1__c
                                                   FROM Opportunity WHERE id IN: oppIDs]);
    } 
    
    if(!(qualifiedLeads == null || qualifiedLeads.size() == 0  )){
      //set record type names/id's to use in LeadManagement.updateLeadScore
      for(ID recordTypeId: LeadManagement.idToLeadRecordTypeInfoMap.keySet()){
        LeadManagement.mapRecordTypeIDName.put(recordTypeId, LeadManagement.idToLeadRecordTypeInfoMap.get(recordTypeId).getName());
        if (LeadManagement.idToLeadRecordTypeInfoMap.get(recordTypeId).getName() == 'Systems') {  //unneccesary?
          LeadManagement.systemsRecordTypeId = recordTypeId;
        }
      }

      Map<String,ID> userEventContact = new Map<String,ID>();
      Map<ID, String> userTeamMap = new Map<ID, String>();
      for(User u : [select id,name,Lead_Team__c,isactive from User where isActive = true AND (id IN: leadOwnerIdSet or name in :leadEventContactUser)]){
        if(leadEventContactUser.size()>0){
          userEventContact.put(u.name,u.id);
        }
        userTeamMap.put(u.id, u.Lead_Team__c);
      }

      Map<String,ID> queueEventContact = new Map<String,ID>();
      Map<Id, String> queueNameMap = new Map<ID, String>();
      for(Group g : [select id, Name from Group where id IN: leadOwnerIdQueueSet or name in :leadEventContactQueue]){
        if(leadEventContactQueue.size()>0){
          queueEventContact.put(g.name,g.id);
        }
        queueNameMap.put(g.id, g.Name);
      }
        
      Set<Id> duplicateEmailLeads = new set<Id>();
      if(dupCheckByEmail != null && dupCheckByEmail.keyset().size() > 0){
        duplicateEmailLeads = Utility_Lead.findDuplicateLeads(dupCheckByEmail);
      }

      //Loop through all qualified leads and then through each subset to make changes
      for(Lead l : qualifiedLeads){
         
          //match for spd partner acct - send to conversion
          if(apptConfirmedLeads.contains(l.Id)) {
               
                    //Code Change Related to Warm Transfer If l.Dealer_Locator_Selection__c present in leadDealerLocationSelectionsIds then assign ResOppEMails to Lead Fields
                    if(leadDealerLocationSelectionsIds.contains(l.Dealer_Locator_Selection__c) && dealerLocatorOppsEMailCollection.get(l.Dealer_Locator_Selection__c) !=null && l.Dealer_Locator_Selection__c !=null){
                 
                        l.Res_Opp_Recip_Email__c=String.valueOf(dealerLocatorOppsEMailCollection.get(l.Dealer_Locator_Selection__c).Opportunity_Recipient__r.Email);
                        l.Res_Opp_Recip_CC_Email__c=String.valueOf(dealerLocatorOppsEMailCollection.get(l.Dealer_Locator_Selection__c).Additional_Opportunity_Email_Recipient__c);
                        //Code Related to Change lead Owner to Account opp Recepient with Condition check Dealer_Locator_Selection__c should not be in spdids list
                        if(spNhids!=null && !spNhids.contains(String.valueOf(l.Dealer_Locator_Selection__c)) && spdids != null && !spdids.contains(String.valueOf(l.Dealer_Locator_Selection__c))){
                            
                   l.OwnerId=dealerLocatorOppsEMailCollection.get(l.Dealer_Locator_Selection__c).Opportunity_Recipient__c;
                        }
                    }
                    if( l.Dealer_Locator_Selection__c !=null && spNhids!=null && !spNhids.contains(String.valueOf(l.Dealer_Locator_Selection__c)) && (DEALERGENERAL !=null && dealerLocatorOppsEMailCollection!=null && spdids !=null  && String.isBlank(String.valueOf(dealerLocatorOppsEMailCollection.get(l.Dealer_Locator_Selection__c).Opportunity_Recipient__r.Email)) && !spdids.contains(String.valueOf(l.Dealer_Locator_Selection__c))) ) {
                        
                        l.OwnerId=Id.valueOf(DEALERGENERAL.Default_Owner_of_Opportunities_Id__c);
			
                    }
                    
             if(l.Status == 'Appointment Confirmed' && l.Appointment_Date__c != null && l.Appointment_Time__c != null && !l.isConverted &&
                ( (l.Consultation_Type__c == 'Online' && l.Meeting_Link__c != null && l.Meeting_Link__c != '' ) 
                 || l.Consultation_Type__c == 'In-Person')) {                              
                    l.IsAutoConvert__c = true;
                    l.Status = 'Ready for Conversion';
                    if(existingAccountNames.contains(l.Company)){
                        l.Company = l.Company + string.valueOf(system.today());
                    }  
                    System.debug('Found SPD LEAD Ready for Conversion!');
                }
              else if(l.Status == 'Warm Transfer') {
                  l.IsAutoConvert__c = true;
                  l.Status = 'Ready for Conversion';
                  if(existingAccountNames.contains(l.Company)){
                      l.Company = l.Company + string.valueOf(system.today());
                  }  
                  System.debug('Found Warm Transfer Lead Ready for Conversion!');
              }
              else if(!l.IsConverted) {
                  l.Status = 'Failed Conversion';
                  l.IsAutoConvert__c = false;
                  Exception_Log__c log = new Exception_Log__c();
                  log.Error_Message__c = 'Lead marked as Appointment Confirmed or Warm Transfer but unable to convert';
                  log.Lead_Id__c = l.Id;
                  logs.add(log);
              }
          }
          
        //update lead score/rating using LeadManagement class
        if(scoreUpdateLeads.contains(l.Id)){
          LeadManagement.updateLeadScore(l);
        }
        //update event leads and lead teams
        if(eventLead.contains(l.Id)){
          if(userEventContact.containsKey(l.Event_Contact__c)){
            l.OwnerID = userEventContact.get(l.Event_Contact__c);
          }
          if(queueEventContact.containsKey(l.Event_Contact__c)){
            l.OwnerID = queueEventContact.get(l.Event_Contact__c);
          }
        }
        if(teamLead.contains(l.Id)){
          if(l.OwnerId != null && String.valueOf(l.OwnerId).startsWith('005') && userTeamMap.containsKey(l.ownerId)){                
              l.Lead_Team__c = userTeamMap.get(l.OwnerId);
          }else if(l.OwnerId != null && queueNameMap.containsKey(l.OwnerId)){  
            if(queueNameMap.get(l.OwnerId).contains('NA Commercial Marketing Queue')){             
                l.Lead_Team__c = 'Marketing';
            }else if(queueNameMap.get(l.OwnerId).contains('NA Commercial ISR Queue')){
              l.Lead_Team__c = 'ISR';
            }
          }
        }
        //Remove dupes for review before auto-convert
        if(duplicateEmailLeads.contains(l.Id)){
            autoConvertLeads.remove(l.Id);//not ready for conversion so remove from auto-convert set
            //l.Status = 'Awaiting Duplicate Review';
            l.Status = 'Disqualified';
            l.Reason__c = 'Awaiting Duplicate Review';
            l.IsAutoConvert__c = false;
        }
        //update status and set autoConvert to true, ready for conversion process
        //checks for existing account and timestamps if already exists  
          if(util.isSkipTrigger('isLeadALR', Utility_Lead.ResidentialRecordTypeId)) {
              if(autoConvertLeads.contains(l.Id)){ 
                  l.Status = 'Ready for Conversion';
                  l.IsAutoConvert__c = true;
                  if(existingAccountNames.contains(l.Company)){
                      l.Company = l.Company + string.valueOf(system.today());
                  }   
              }
          }
          
          /*KCM_05052016: added code segment to save the first dealer assigned to the lead
          if ((l.dealer_locator_selection__c != null || l.dealer_locator_selection__c != '') &&
              (l.Original_Assigned_Dealer_Opportunity__c == Null || l.Original_Assigned_Dealer_Opportunity__c == '')) {
              l.Original_Assigned_Dealer_Opportunity__c = l.dealer_locator_selection__c;
          }*/
      }
    }

      //process opportunity assignment & account/contact/opportunity field updates
    if(qualConvertedLeads != null && !qualConvertedLeads.isEmpty()){
        fetchSchemas();
        oppAssignment();
    }
  }
    
  // -------- Internal Classes --------
  //qualifier for if lead score should be updated
  private boolean doUpdateScore(Lead l, Map<Id, Lead> originalLeads){
    return (originalLeads.get(l.Id).Theater__c != l.Theater__c
          || originalLeads.get(l.Id).Business_Unit__c != l.Business_Unit__c
          || originalLeads.get(l.Id).Ground_Roof_Space__c != l.Ground_Roof_Space__c 
          || originalLeads.get(l.Id).Roof_Material__c != l.Roof_Material__c
          || originalLeads.get(l.Id).Age_Of_Roof__c != l.Age_Of_Roof__c
          || originalLeads.get(l.Id).Time_Of_Installation__c != l.Time_Of_Installation__c
          || originalLeads.get(l.Id).Average_Monthly_Electricity_Bill__c != l.Average_Monthly_Electricity_Bill__c
          || originalLeads.get(l.Id).Installation_Type__c != l.Installation_Type__c
          || originalLeads.get(l.Id).Did_you_apply_for_financing__c != l.Did_you_apply_for_financing__c
          || originalLeads.get(l.Id).Roof_Orientation__c != l.Roof_Orientation__c
          || originalLeads.get(l.Id).State != l.State
          || originalLeads.get(l.Id).Homes_Built_per_year__c != l.Homes_Built_per_year__c
          || originalLeads.get(l.Id).Number_Of_States__c != l.Number_Of_States__c
          || originalLeads.get(l.Id).Number_of_Sites_to_Install_Solar__c != l.Number_of_Sites_to_Install_Solar__c
          || originalLeads.get(l.Id).Country != l.Country
          || originalLeads.get(l.Id).Does_Company_Install_PV_Distribute__c != l.Does_Company_Install_PV_Distribute__c
          || originalLeads.get(l.Id).Registry_Presence__c != l.Registry_Presence__c
          || originalLeads.get(l.Id).Immediate_Interest_in_Pricing__c != l.Immediate_Interest_in_Pricing__c
          || originalLeads.get(l.Id).Focused_on_Ground_Mounted_Systems__c != l.Focused_on_Ground_Mounted_Systems__c
          || originalLeads.get(l.Id).With_a_master_electrician__c != l.With_a_master_electrician__c
          || originalLeads.get(l.Id).Has_Engineering_and_Sales_Resources__c != l.Has_Engineering_and_Sales_Resources__c
          || originalLeads.get(l.Id).Total_Experience_in_Solar_Business__c != l.Total_Experience_in_Solar_Business__c
          || originalLeads.get(l.Id).Proposal_Partner_Type__c != l.Proposal_Partner_Type__c
          || originalLeads.get(l.Id).Size_of_Projects__c != l.Size_of_Projects__c
          || originalLeads.get(l.Id).Has_Rooftop_Experience__c != l.Has_Rooftop_Experience__c
          || originalLeads.get(l.Id).Cored_Business__c != l.Cored_Business__c
          || originalLeads.get(l.Id).Want_to_buy_kits__c != l.Want_to_buy_kits__c
          || originalLeads.get(l.Id).Installations_Realized_Previous_Year__c != l.Installations_Realized_Previous_Year__c
          || originalLeads.get(l.Id).NumberOfEmployees != l.NumberOfEmployees
          || originalLeads.get(l.Id).Website != l.Website
          || originalLeads.get(l.Id).Commercial_Residential_Business_Split__c != l.Commercial_Residential_Business_Split__c
          || originalLeads.get(l.Id).MCS_certification__c != l.MCS_certification__c
          || originalLeads.get(l.Id).Anticipated_Demand__c != l.Anticipated_Demand__c);
          //|| originalLeads.get(l.Id).Dealer_Locator_Selection__c != l.Dealer_Locator_Selection__c); //KCM_05052016: added check for change in dealer location field
  }
 
  //gather related record types for opp assignment & account/contact/opportunity field updates
  private void fetchSchemas(){
    accountRecordTypes = new Map<String,ID>(); 
    opportunityRecordTypes = new Map<String,ID>();
    contactRecordTypes = new Map<String,ID>(); 
    leadRecordTypes = new Map<String,String>();
    //FETCH RECORDTYPES             
    Set<String> objTypes = new Set<String>();
    objTypes.add('Account');
    objTypes.add('Opportunity');
    objTypes.add('Contact');
      
      //Account record type
    Schema.DescribeSObjectResult da = Schema.SObjectType.Account;
    Map<Id, Schema.RecordTypeInfo> acctMapById = da.getRecordTypeInfosById();
    for(ID i : acctMapById.keySet()){
        accountRecordTypes.put(acctMapById.get(i).name,string.valueOf(i));
    }
    
    //Contact record type
    Schema.DescribeSObjectResult dc = Schema.SObjectType.Contact;
    Map<Id,Schema.RecordTypeInfo> contMapById = dc.getRecordTypeInfosById();
    for(ID i : contMapById.keySet()){
        contactRecordTypes.put(contMapById.get(i).name,string.valueOf(i));
    }
    //Opportunity record type
    Schema.DescribeSObjectResult dOpp = Schema.SObjectType.Opportunity;
    Map<Id,Schema.RecordTypeInfo> oppMapById = dOpp.getRecordTypeInfosById();
    for(ID i : oppMapById.keySet()){
        opportunityRecordTypes.put(oppMapById.get(i).name,string.valueOf(i));
    }
    //Lead record type
    Map<Id,Schema.RecordTypeInfo> leadMapById = LeadManagement.idToLeadRecordTypeInfoMap;
    for(ID i : leadMapById.keySet()){
        leadRecordTypes.put(i,leadMapById.get(i).name);
    }
      
    //Opp Default Project Stage
    List<Schema.Picklistentry> projectStages = Opportunity.Project_Stage__c.getDescribe().getPicklistValues();   
    for (Schema.Picklistentry picklistentry : projectStages) {
        if (picklistentry.isActive() == true && picklistentry.isDefaultValue() == true) {
            DEFAULT_PROJECT_STAGE = picklistentry.getValue();
            break;
        }
        else
            DEFAULT_PROJECT_STAGE = '';
    }
  }
  
    //process oppAssignments & account/contact/opportunity field updates/custom mapping
  private void oppAssignment(){

    acctRecords = new List<Account>();
    oppRecords = new List<Opportunity>();
    conRecords = new List<Contact>();
    
    for(Lead lead : qualConvertedLeads){
      Account acct = accounts.get(lead.ConvertedAccountID);
      Opportunity opp = new Opportunity (id =lead.convertedopportunityID);
      Contact con = new Contact(id=lead.convertedContactID);
      //custom field mapping from lead        
      if(lead.description!=null && lead.description!=''){
        acct.description = lead.description;
          opp.description = lead.description;                     
      }        
      if (lead.Lead_Qualification_Notes__c !=null && lead.Lead_Qualification_Notes__c!=''){                    
          opp.Lead_Qualification_Notes__c = lead.Lead_Qualification_Notes__c;
      }        
      if(lead.Referral_Program_Status__c!=null){
          acct.Referral_Program_Status__c = lead.Referral_Program_Status__c;
          opp.Referral_Program_Status__c = lead.Referral_Program_Status__c;                   
          con.Referral_Program_Status__c = lead.Referral_Program_Status__c;                   
      }       
      if(lead.Transmission_Capacity__c!=null){
          acct.Transmission_Capacity__c = lead.Transmission_Capacity__c;
      }        
      if(lead.business_unit__c=='NA Commercial' || lead.business_unit__c=='UPP Americas'){
          opp.closeDate = Date.Today().addDays(270);
      }else if(lead.business_unit__c=='RLC' && opportunities != null && opportunities.get(opp.Id) != null && opportunities.get(opp.Id).RecordTypeId == SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Opportunity.SobjectType).get('Commercial') && lead.Theater__c == 'North America'){
          opp.closeDate = Date.Today().addDays(635);
      }        
      if(lead.Primary_Contact__c){
          opp.Primary_Contact__c = lead.convertedContactID;                   
      }        
      if(lead.Business_Unit__c =='UPP Intl' && currentUser!=null && !currentUser.Web_User__c && opportunityRecordTypes.get('Components')!=null){
          opp.recordtypeID = opportunityRecordTypes.get('Components');
      }        
      opp.Lead_Type__c = leadRecordTypes.get(lead.recordTypeID);
      con.Contact_Language__c = lead.Contact_Language__c;
      acct.Contact_Language__c = lead.Contact_Language__c;
      
      //set acct record types for New Homes leads
      if(leadRecordTypes.get(lead.recordTypeID) == 'New Homes'){
        if (lead.Business_Unit__c == 'UPP Intl'){
          if(accountRecordTypes.get('Standard') != null)
            acct.RecordTypeId = accountRecordTypes.get('Standard');
        }else if((lead.Business_Unit__c == 'RLC' && lead.RLC_Type__c=='New Homes') || lead.Business_Unit__c == 'UPP Intl'){
          if(accountRecordTypes.get('Residential Customer') != null && ! acct.IsPersonAccount)
            acct.RecordTypeId = accountRecordTypes.get('Residential Customer');          
        }else if(lead.Business_Unit__c == 'NA Commercial' || lead.Business_Unit__c == 'UPP Americas'){
          if(accountRecordTypes.get('Standard') != null && ! acct.IsPersonAccount)
            acct.RecordTypeId = accountRecordTypes.get('Standard');
        }
      }
              
      if(leadRecordTypes.get(lead.recordTypeID) == 'Systems'){
        if (lead.Business_Unit__c == 'UPP Americas' || lead.Business_Unit__c == 'UPP Intl'){
          if(accountRecordTypes.get('Standard') != null)
              acct.RecordTypeId = accountRecordTypes.get('Standard'); 
        }else if(lead.Business_Unit__c == 'RLC' && lead.RLC_Type__c=='Light Commercial'){
          if(accountRecordTypes.get('Commercial Customer') != null)
            acct.RecordTypeId = accountRecordTypes.get('Commercial Customer');
        }else if(lead.Business_Unit__c == 'NA Commercial' || lead.Business_Unit__c == 'UPP Intl'){
          if(accountRecordTypes.get('Standard') != null && ! acct.IsPersonAccount)
            acct.RecordTypeId = accountRecordTypes.get('Standard');
        }
      }
        
        //more field mapping for commercial leads     
      if(leadRecordTypes.get(lead.recordTypeID) != 'Residential'){
        acctRecords.add(acct);
        conRecords.add(con);
        if(opp.Id != null){
            if(opportunities.get(opp.Id).RecordTypeId == SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Opportunity.SobjectType).get('Commercial')){
            if(opp.Projected_Delivery_Date__c == null) {
              Integer monthToAdd;
              if(lead.Time_Of_Installation__c == '< 1 month'){
                monthToAdd = 1;
              }else if(lead.Time_Of_Installation__c == '< 2 months'){
                monthToAdd = 2;
              } else if(lead.Time_Of_Installation__c == '> 3 months'){
                monthToAdd = 3;
              } else if(lead.Time_Of_Installation__c == '> 5 months'){
                monthToAdd = 5;
              } else if(lead.Time_Of_Installation__c == '> 6 months'){
                monthToAdd = 6;
              } else if(lead.Time_Of_Installation__c == '> 12 months'){
                monthToAdd = 12;
              } else{
                monthToAdd = 0;
              }    
              opp.Projected_Delivery_Date__c = opp.Delivery_Date__c = Date.Today().addMonths(monthToAdd);         
            }            
            setDefaultStageName('Commercial', opp);
            opp.Facility_Address1__c = lead.Facility_Address__c;
          }
          opp.Project_Stage__c = DEFAULT_PROJECT_STAGE;
           //field validations for commercial opps     
          if (opportunities.get(opp.Id).RecordTypeId == SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Opportunity.SobjectType).get('Commercial')){
            if (opp.Facility_Address1__c == null || opp.Facility_Address1__c == ''){
              lead.addError('Facility Address is required for Commercial Opportunities/Leads.');
              continue;
            } 
            opp.Facility_State1__c = lead.Facility_State__c;
            opp.Facility_City1__c = lead.Facility_City__c;
            if (opp.Facility_City1__c == null || opp.Facility_City1__c == ''){
              lead.addError('Facility City is required for Commercial Opportunities/Leads.');
              continue;
            }
            if (opp.Facility_State1__c == null || opp.Facility_State1__c == ''){
              lead.addError('Facility State is required for Commercial Opportunities/Leads.');
              continue;
            }   
          }
            oppRecords.add(opp); 
        }                      
        continue;
      }
        //set acct record type for residential leads
      if(leadRecordTypes.get(lead.recordTypeID) == 'Residential'){
        if (lead.Business_Unit__c == 'UPP Intl' || lead.Business_Unit__c == 'NA Commercial'  || lead.Business_Unit__c == 'UPP Americas'){
          if(accountRecordTypes.get('Standard') != null && ! acct.IsPersonAccount)
            acct.RecordTypeId = accountRecordTypes.get('Standard');
        }else if(lead.Business_Unit__c == 'RLC' && lead.RLC_Type__c=='Residential'){
          if(accountRecordTypes.get('Residential Customer') != null && ! acct.IsPersonAccount)
            acct.RecordTypeId = accountRecordTypes.get('Residential Customer');
            if(lead.Dealer_Locator_Selection__c != null) {
                acct.Partner_Account__c = lead.Dealer_Locator_Selection__c;
            }
            acct.OwnerId = lead.OwnerId;
            acct.x_Account_Owner__c = lead.OwnerId;
        }else{
          if(accountRecordTypes.get('Residential Customer') != null && ! acct.IsPersonAccount)
            acct.RecordTypeId = accountRecordTypes.get('Residential Customer');
            acct.Partner_Account__c = lead.Dealer_Locator_Selection__c;
            acct.OwnerId = lead.OwnerId;
            acct.x_Account_Owner__c = lead.OwnerId;
        } 
        if(opportunityRecordTypes.get('Home Owner') != null){
          opp.RecordTypeID = opportunityRecordTypes.get('Home Owner');
          opp.Type = leadRecordTypes.get(lead.recordTypeID);
          setDefaultStageName('Home Owner',opp); 
          setAccountFacilityValue(lead, acct);
        }
        if(contactRecordTypes.get('Customer')!=null && ! acct.IsPersonAccount)
          con.RecordTypeId = contactRecordTypes.get('Customer'); 
        acctRecords.add(acct);
        conRecords.add(con);  
        if(opp.Id != null) 
          oppRecords.add(opp);
        else
          continue; 
      }                               
    }
    Diagnostics.pop();
  }
  
    //perform dml for acct/contact/opp records
  public override void finish(boolean fromStart){
      if(fromStart){
          //dml
          try{
          if(Util.isInContextOfLeadConversion()!=null){  //dml moved to account handler when lead converted from Batch_ConvertLead
              
              if(acctRecords != null && acctRecords.size()>0)
                  update acctRecords;     
                  
          }  
          if(conRecords != null && conRecords.size()>0)
              update conRecords;
          if(oppRecords != null && oppRecords.size()>0){
              update oppRecords;
          }
          if(logs != null && logs.size() > 0) {
              insert logs;
          }
              }Catch(Exception e){
                  
              } 
      }
  }
    
    //get/set default stage name for commercial and home owner opps used for custom field mapping
  private void setDefaultStageName(String strType,Opportunity opp){
    if(strType =='Home Owner' && staticDefaultHomeOwnerStage != null){
        opp.StageName = staticDefaultHomeOwnerStage; 
        return; 
    }
    else if(strType =='Commercial' && staticDefaultCommercialStage != null){
        opp.StageName = staticDefaultCommercialStage;
        return ;    
    }
    Schema.DescribeFieldResult F;
    List<Schema.PicklistEntry> P;
    F = Opportunity.StageName.getDescribe();  
    P = F.getPicklistValues();  
    for(Schema.PicklistEntry entry : P){
        if(strType =='Home Owner' && entry.getLabel().startsWith('10%')){
            staticDefaultHomeOwnerStage = entry.getLabel(); 
            opp.StageName = entry.getLabel();
            break;
        }else if(strType =='Commercial'&& entry.getLabel().startsWith('12%')){
            staticDefaultCommercialStage = entry.getLabel();
            opp.StageName = entry.getLabel();
            break;
        }   
    }
    return;
  }
 
  //custom mapping for account facility location
  private static void setAccountFacilityValue(Lead ld, Account acc) {       
      if(ld.Facility_Address__c == null && ld.Facility_Address_2__c == null && ld.facility_City__c == null && ld.Facility_Zip__c == null && ld.Facility_State__c == null){
            return;
    } else {
        acc.Facility_Address__c = ld.Facility_Address__c; 
        acc.Facility_Address_2__c = ld.Facility_Address_2__c; 
        acc.Facility_City__c = ld.Facility_City__c; 
        acc.Facility_Zip__c = ld.Facility_Zip__c; 
        acc.Facility_State__c =ld.Facility_State__c; 
        }
    return;           
  }     
}