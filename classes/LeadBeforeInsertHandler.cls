public with sharing class LeadBeforeInsertHandler extends TriggerHandlerBase
{  
  // -------- Constants --------
  // 
  //private static String STATES = 'AL:AK:AZ:AR:CA:CO:CT:DE:DC:FL:GA:HI:ID:IL:IN:IA:KS:KY:LA:ME:MD:MA:MI:MN:MS:MO:MT:NE:NV:NH:NJ:NM:NY:'
  //          + 'NC:ND:OH:OK:OR:PA:RI:SC:SD:TN:TX:UT:VT:VA:WA:WV:WI:WY';
  
  // -------- Constructor --------
  public LeadBeforeInsertHandler(){}
  
  // -------- Variables --------
  //private ID ResidentialRecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Lead.SobjectType).get('Residential');
  //private DealerGeneral__c dealerGeneral = DealerGeneral__c.getInstance();
  
  // -------- Properties --------
  // Qualified records for actions
  private Map<Integer, Lead> qualifiedLeads;
  private Set<Integer> setDealerName;
  private set<Integer> theaterAssignment;
  private Set<Integer>eventLead;
  private Set<Integer>teamLead;
  private Set<Integer>    autoconvertLeads;
  private Set<Integer>  eloquaStatusSet;
 private Set<Integer>     leadCalculateCalendarWeekSet;

  
  //---------Sets for queries----
  private Set<ID> accountDealers;
  private Set<String> countries;
  private Set<String> leadEventContactUser;
  private Set<String> leadEventContactQueue;
  private Set<ID>     leadOwnerIdSet;
  private Set<ID>     leadOwnerIdQueueSet;


  private Set<String> emailDupeCheck;
  
  //Dupe check maps
  private Map<String, Integer> dupCheckByEmail;
  
  
  
  // -------- Methods --------
  // Cast and determine qualified records for various field updates
  public override void qualifyStartingRecords(List<sObject> newList, 
    List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap)
  {
    Diagnostics.push('LBI qualifyStartingRecords');

   qualifiedLeads       = new Map<Integer, Lead>();
   setDealerName        = new Set<Integer>();
   theaterAssignment    = new Set<integer>();
   eventLead      = new Set<Integer>();
   teamLead        = new Set<Integer>();
   autoconvertLeads    = new Set<Integer>();
   leadCalculateCalendarWeekSet = new Set<Integer>();   
   eloquaStatusSet = new Set<Integer>();//to help with status change inconsistencies
   
   //query sets
   accountDealers       = new Set<ID>();
   countries            = new Set<String>();
   leadEventContactUser = new Set<String>();
   leadEventContactQueue= new Set<String>();
   leadOwnerIdSet       = new Set<ID>();
   leadOwnerIdQueueSet  = new Set<ID>();
   //leadCalculateCalendarWeekSet  = new Set<ID>();   
   
   //dupe map
   dupCheckByEmail = new Map<String, Integer>();
   
    List<Lead> newLeads = (List<Lead>)newList;
    
    //for leadScore

    for(Integer i = 0; i < newLeads.size(); i++)
    {
       Lead l = newLeads[i];
      //qualify leads for business logic
       //if(!(UserInfo.getUserId()=='00580000003XrG4AAK' || UserInfo.getUserId()=='00580000003XtZwAAK' ||UserInfo.getUserId()=='00580000003Xtm2AAC')){
        if(!Util.isSkipTrigger('LeadUpdateLeadScore',null)){    

            Utility_Lead.setFieldsBasedOnLeadValues(l, null);//set fields that do not need queries to other objects
            
            if(l.Dealer_Name__c!=null){
                setDealerName.add(i);
                accountDealers.add(l.Dealer_Name__c);
                qualifiedLeads.put(i, l);
            }
            if(l.Country != null && !l.Override_Theater_Assigned__c){                          
                theaterAssignment.add(i);
                countries.add(l.Country);
                qualifiedLeads.put(i, l);
            } 
            //set team qualification - all leads qualify...TODO - make more efficient    
            /*
            below is the "setTeam" functionality
            if the lead source is an event, we want to set the owner as the event_contact
            event_contact is just a picklist of names so we have to query the user/group table to make the assignment
            */  
            
            /*KCM_02242017: Commented out code and replaced with the line of code that immediately follows; Pivotal #140449385
            if((l.LeadSource=='Event' || l.LeadSource=='Event/Seminar/Webinar')&& l.Event_Contact__c != null && l.Event_Contact__c != ''){
            */            
            if((l.LeadSource == 'Events / Tradeshow' || l.LeadSource == 'Event/Seminar/Webinar') && l.Event_Contact__c != null && l.Event_Contact__c != ''){
                eventLead.add(i);
                qualifiedLeads.put(i, l);
                if(l.Event_Contact__c.contains('Queue')){
                    leadEventContactQueue.add(l.Event_Contact__c);
                }
                else{
                    leadEventContactUser.add(l.Event_Contact__c);
                }
            }
            if(l.Lead_Team__c==null){//need to set the lead team in the trigger. most all leads will qualify
                if(l.OwnerId != null && String.valueOf(l.OwnerId).startsWith('005')){
                    leadOwnerIdSet.add(l.OwnerId);
                    qualifiedLeads.put(i, l);
                }
                else{
                    leadOwnerIdQueueSet.add(l.OwnerId);
                    qualifiedLeads.put(i, l);
                }
            }

            System.debug('----------l.isConverted'+l.isConverted);
            System.debug('----------l.Status'+l.Status);
            System.debug('----------l.RecordTypeId'+l.RecordTypeId);
            System.debug('----------l.Theater__c'+l.Theater__c);
            System.debug('----------l.Source_System__c'+l.Source_System__c);
            //setLead Status qualifiers
            if(((!l.isConverted && l.Status !='Ready for Conversion') 
              && (l.Status == 'Open' || l.Status == 'Marketing Qualified')
              && l.RecordTypeId == utility_Lead.ResidentialRecordTypeId
              && l.FirstName != utility_Lead.dealerGeneral.Lead_Test_First_Name__c
              && (l.Theater__c == 'North America' || l.Theater__c == 'Central America and the Caribbean')
              && l.Lead_Manufacturer__c == 'SunPower'
              ) || (l.RecordTypeId == Utility_Lead.ResidentialRecordTypeId && l.Theater__c == null && l.Source_System__c == 'Eloqua')) {
                 if(util.isSkipTrigger('isLeadALR', null)) {
                     if(Utility_Lead.setAutoConvertLeadFields(l)){
                         eloquaStatusSet.add(i);//will still set status based on eloqua matrix, but if is new Lead ALR, won't automatically convert anymore
                     }
                 } else if(!util.isSkipTrigger('isLeadALR', null)) {
                     if(Utility_Lead.setAutoConvertLeadFieldsSPD(l)) {
                         eloquaStatusSet.add(i);
                     }
                 }
                  if(util.isSkipTrigger('isLeadALR', Utility_Lead.ResidentialRecordTypeId)) {
                      if ( (l.Source_System__c == 'Eloqua' && l.Status == 'Qualified') || (l.Source_System__c != 'Eloqua' && (l.Status == 'Open' || l.Status == 'Marketing Qualified'))){
                          qualifiedLeads.put(i, l);
                          autoConvertLeads.add(i);
                      }
                  }
                    
                  if(l.Email != null && l.Status != 'Disqualified'){
                      if(dupCheckByEmail.ContainsKey(l.Email)){
                          l.Status = 'Disqualified';
                          l.Reason__c = 'Awaiting Duplicate Review';
                      } else {
                          dupCheckByEmail.put(l.Email, i);
                      }
                  }
              }
    //if(l.SSO_First_Contact_Date_Time__c != null){
              qualifiedLeads.put(i, l);
                leadCalculateCalendarWeekSet.add(i);
          //}
        }
    }
  
    Diagnostics.pop();
  }
  // Start processing field changes and assignments
  public override void start()
  {
    if(qualifiedLeads.size()>0){
      for(ID recordTypeId: LeadManagement.idToLeadRecordTypeInfoMap.keySet()){
        LeadManagement.mapRecordTypeIDName.put(recordTypeId, LeadManagement.idToLeadRecordTypeInfoMap.get(recordTypeId).getName());
        if (LeadManagement.idToLeadRecordTypeInfoMap.get(recordTypeId).getName() == 'Systems') {
          LeadManagement.systemsRecordTypeId = recordTypeId;
        }
      }
    }
    //build maps and perform necessary soql queries for business logic
    Map<ID, Account> mapAccount = new Map<ID, Account>();
    Set<String> existingAccountNames = new Set<String>();
    for(Account a : [Select id, Name from Account where id in :accountDealers OR Name IN :existingAccountNames]){
        mapAccount.put(a.id, a);
        existingAccountNames.add(a.Name);
    }

    
    Map<String,String> countryTheaterMap = new Map<String,String>();
    if(countries.size()>0){
        for(Country_Reference__c cr : [select Country__c, Theater__c from Country_Reference__c where Country__c in : countries]){
            countryTheaterMap.put(cr.country__c, cr.theater__c);
        }
    }
    
    //lead event owner/team setting queries
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
    //checking for duplicates on email via contacts and leads
    set<Integer> duplicateEmailLeads = new set<Integer>();
    if(dupCheckByEmail!=null&&dupCheckByEmail.keyset().size()>0){
        
        for(Lead plResult : [SELECT Id, Email FROM Lead WHERE Email IN :dupCheckByEmail.keySet()])
        {
            if(plResult.Email != null && dupCheckByEmail.containsKey(plResult.Email)){
                duplicateEmailLeads.add(dupCheckByEmail.get(plResult.Email));
                System.debug(dupCheckByEmail.get(plResult.Email));
            }
        }    
        for(Contact pcResult : [SELECT ID, Email FROM Contact WHERE Email IN : dupCheckByEmail.keySet()])
        {
            if(pcResult.Email!=null && dupCheckByEmail.containsKey(pcResult.Email)){
                duplicateEmailLeads.add(dupCheckByEmail.get(pcResult.Email));
                System.debug(dupCheckByEmail.get(pcResult.Email));
            }
        } 
    }
    list<Lead> calculateCalendarWeekLead = new list<Lead>();
    for(Integer i : qualifiedLeads.keySet())
    {
        lead l = qualifiedLeads.get(i);     
        LeadManagement.updateLeadScore(l);
        if(setDealerName.contains(i)&&mapAccount.containsKey(l.Dealer_Name__c)){//set the Dealer_Locator_Selection to the account id
            l.Dealer_Locator_Selection__c = mapAccount.get(l.Dealer_Name__c).id;  
        }
        /*if(!eloquaStatusSet.contains(i)) {//added condition to not set status to open when it is set to something else
            l.Status = 'Marketing Qualified';
        }*/
        if(theaterAssignment.contains(i)&&countryTheaterMap.containsKey(l.Country)){
            l.Theater__c = countryTheaterMap.get(l.Country);
        }
        //set the the owner for the lead event
        if(eventLead.contains(i)){
            if(userEventContact.containsKey(l.Event_Contact__c)){
                l.OwnerID = userEventContact.get(l.Event_Contact__c);
            }
            if(queueEventContact.containsKey(l.Event_Contact__c)){
                l.OwnerID = queueEventContact.get(l.Event_Contact__c);
            }
        }
        //set the Lead Team based on the user or the queue name
        if(teamLead.contains(i)){
            if(l.OwnerId!=null && String.valueOf(l.OwnerId).startsWith('005') && userTeamMap.containsKey(l.ownerId)){                
                l.Lead_Team__c = userTeamMap.get(l.OwnerId);
            }
            else if(l.OwnerId!=null && queueNameMap.containsKey(l.OwnerId)){  
                if(queueNameMap.get(l.OwnerId).contains('NA Commercial Marketing Queue')){             
                    l.Lead_Team__c = 'Marketing';
                }
                else if(queueNameMap.get(l.OwnerId).contains('NA Commercial ISR Queue')){
                    l.Lead_Team__c = 'ISR';
                }
            }
        }
        if(duplicateEmailLeads.contains(i)){
            autoConvertLeads.remove(i);//not ready for conversion so remove from auto-convert set
            //l.Status = 'Awaiting Duplicate Review';
            System.debug(l.Company + ' was flagged as a duplicate!');
            l.Status = 'Disqualified';
            l.Reason__c = 'Awaiting Duplicate Review';
            l.IsAutoConvert__c = false;
        }
        if(autoConvertLeads.contains(i)){
            l.Status = 'Ready for Conversion';
            l.IsAutoConvert__c = true;
            if(existingAccountNames.contains(l.Company)){
                l.Company = l.Company + string.valueOf(system.today());
            }
            
        }
    if(leadCalculateCalendarWeekSet.contains(i))
          calculateCalendarWeekLead.add(l);
    }
    if(calculateCalendarWeekLead.size()>0)
        LeadManagement.CalculateCalendarWeek(calculateCalendarWeekLead);  
    Diagnostics.pop();
  }
  
  // -------- Internal Classes --------
  // None

  
}