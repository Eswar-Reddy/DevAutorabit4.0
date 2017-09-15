public class LeadManagement {
    private static String STATES = 'AL:AK:AZ:AR:CA:CO:CT:DE:DC:FL:GA:HI:ID:IL:IN:IA:KS:KY:LA:ME:MD:MA:MI:MN:MS:MO:MT:NE:NV:NH:NJ:NM:NY:'
            + 'NC:ND:OH:OK:OR:PA:RI:SC:SD:TN:TX:UT:VT:VA:WA:WV:WI:WY';

    //unsure of placement of this block and first for loop in updateLeadScore
    private static String NA = 'North America';
    private static String EU = 'Europe';
    private static String AU = 'Australia';//for case # 00061964
    //Map<Id, Schema.RecordTypeInfo> idToLeadRecordTypeInfoMap = LeadManagement.idToLeadRecordTypeInfoMap;
    public static ID systemsRecordTypeId = null;
    public static Map<String,String> mapRecordTypeIDName = new Map<String,String>();
  
    
    
    private static User currentUser;
    public static Map<Id, Schema.RecordTypeInfo> idToLeadRecordTypeInfoMap;
    public static Map<String, Schema.RecordTypeInfo> nameToLeadRecordTypeInfoMap;
    
    static {
        currentUser = Util.currentUser;
        idToLeadRecordTypeInfoMap = Schema.SObjectType.Lead.getRecordTypeInfosById();
        nameToLeadRecordTypeInfoMap = Schema.SObjectType.Lead.getRecordTypeInfosByName();
    }
    
    public static void beforeLeadInsert (List<Lead> leadList){
         SetDealerAccountName(leadList);
         setCountryAsBlank(leadList);
         setLeadFields(leadList);
         setLeadStatus(leadList);
         updateFollowUpDateTimeAtInsertion(leadList);   
         // Done for Case # 00084504
         setLeadTeam(leadList,null); 
    }  
    
    //Case#00069690 start
    public static void afterLeadInsert (List<Lead> leadList){
        System.debug('*********Enterd in afterLeadInsert() ******* ');
        validateLeadRating(leadList);//for case # 00064008
        //Set campaign for the Lead        
        setCampaign(leadList);
        doCallAssignmentRule(leadList,new List<Lead>());
    }   

    public static void afterLeadUpdate(List<Lead> leadList, List<Lead> oldLeadList){
        System.debug('********** Entered in afterLeadUpdate() > setcampaign ');
      //Sangita Commented- moved this to the after update handler
      //  validateLeadRating(leadList);//for case # 00064008
     //Sangita Commented- moved this to the after update handler 
        //Set campaign for the Lead        
        setCampaign(leadList);
        doCallAssignmentRule(leadList,oldLeadList); 
    }
    //Case#00069690 end
    
    //Start for case # 00064008
    public static void validateLeadRating(List<Lead> leadList){     
        List<Lead> ldList = new List<Lead>();
        for(Lead l : leadList){         
            //Case#00049329
            //Change for Case#00075371
            if(!util.byPassValidation() && !util.byPassLeadValidation() && (l.RecordTypeId != null && l.RecordTypeId == nameToLeadRecordTypeInfoMap.get('Systems').getRecordTypeId())){
                // Done for case # 00066557 consolidating business units IBD and Components into 'UPP Intl'.
                // if (l.BU__c != null && (l.BU__c == 'NA Commercial' || l.BU__c ==  'IBD' || l.BU__c == 'Components' || l.BU__c == 'RLC') && currentUser.id != '00580000002hsak'){//for case#00067713 //l.BU__c == 'UPP Intl' ||
                if (l.BU__c != null && (l.BU__c == 'NA Commercial' || l.BU__c == 'UPP Intl' || l.BU__c == 'RLC') && (currentUser.id != '00580000002hsak' || currentUser.id != '00580000003Xwxw')){//{for case#00067713 //l.BU__c == 'UPP Intl' ||}  //{for case#00135965 // currentUser.id != '00580000003Xwxw'||}
                    if (l.Rating == null || l.Rating == '')
                        l.Rating.addError('Rating is required');
                }
            }  
        }
    }
    //End for case # 00064008

    public static void beforeLeadUpdate (List<Lead> leadList, List<Lead> oldLeadList){  
        setCountryAsBlank(leadList);
        setLeadFields(leadList); 
        //Set campaign for the Lead 
        //setCampaign(leadList); 
        //New Function Added for populate default values for related Opportunity and Account if lead is came for convert 
        OpportunityAssignmentEngine2.setFieldsOnLeadConvert(leadList); 
        //Map Lead field 'Referral Program Status' to converted Account,Contact,Opportunity
        //MapFieldOnLeadConvert(leadList);  //This functionality is moved to the method OpportunityAssignmentEngine2.setFieldsOnLeadConvert(done for case-00040774 to reduce the queries)   
        updateFollowUpDateTime(leadList, oldLeadList);   
        // Done for Case # 00084504
        setLeadTeam(leadList,oldLeadList);
    }    
    
    /* Added for Sunpower Case # 00030235 */
    private static void setCountryAsBlank(List<Lead> leadList) {
        // Set Country as blank if all other address fields are blank
        for (Lead l : leadList) {
            if (l.Street == null && l.State == null && l.PostalCode == null && l.City == null) {
                l.Country = null;
            }
        }
    }
    /**************************************/

     //for case-#00011255 //tick boxes for follow up
    //purpose- update datetime as per the follow up checked
    public static void updateFollowUpDateTime(List<Lead> leadList, List<Lead> oldLeadList){
        Map<Id, Lead> mapLead = new Map<Id, Lead>();
        if(oldLeadList.size()>0){
            for(Lead l:oldLeadList){ 
               mapLead.put(l.Id, l);
            }
        }
        
        for(Lead led:leadList){
            if(led.First_follow_up__c && mapLead.get(led.Id).First_follow_up__c == false){
                led.Date_Time_First_follow_up__c = Datetime.now();
            }
            if(led.Second_follow_up__c && mapLead.get(led.Id).Second_follow_up__c == false){
                led.Date_Time_Second_follow_up__c = Datetime.now();
            }
            if(led.Third_follow_up__c && mapLead.get(led.Id).Third_follow_up__c == false){
                led.Date_Time_Third_follow_up__c = Datetime.now();
            }
            if(led.Fourth_follow_up__c && mapLead.get(led.Id).Fourth_follow_up__c == false){
                led.Date_Time_Fourth_follow_up__c = Datetime.now();
            }
            if(led.Fifth_follow_up__c && mapLead.get(led.Id).Fifth_follow_up__c == false){
                led.Date_Time_Fifth_follow_up__c = Datetime.now();
            }
        }
            
    }
     //for case-#00011255 //tick boxes for follow up
    //purpose- update datetime as per the follow up checked at the time of insertion
    public static void updateFollowUpDateTimeAtInsertion(List<Lead> leadList){
        for(Lead led:leadList){
            if(led.First_follow_up__c){
                led.Date_Time_First_follow_up__c = Datetime.now();
            }
            if(led.Second_follow_up__c){
                led.Date_Time_Second_follow_up__c = Datetime.now();
            }
            if(led.Third_follow_up__c){
                led.Date_Time_Third_follow_up__c = Datetime.now();
            }
            if(led.Fourth_follow_up__c){
                led.Date_Time_Fourth_follow_up__c = Datetime.now();
            }
            if(led.Fifth_follow_up__c){
                led.Date_Time_Fifth_follow_up__c = Datetime.now();
            }
        }
    }
        
    //Map Lead field 'Referral Program Status' to converted Account,Contact,Opportunity
    /*public static void MapFieldOnLeadConvert(List<Lead> leadList){
        //Preapare list of Account,Contact,Opportunity to update field 'Referral Program Status'
        List<Contact> contactToUpdate = new List<Contact>();
        List<Account> accountToUpdate = new List<Account>();
        List<Opportunity> opportunityToUpdate = new List<Opportunity>();        
       
        //Traverse through each lead coming to convert
        for(Lead ld:leadList){
            if(!ld.isConverted){
                continue;
            }
            //Map Referral_Program_Status__c field to converted Account,Contact,Opportunity
            Contact con = new Contact(ID=ld.convertedContactId);
            con.Referral_Program_Status__c = ld.Referral_Program_Status__c;
            contactToUpdate.Add(con);
            Account acc = new Account(ID=ld.convertedAccountId);
            acc.Referral_Program_Status__c = ld.Referral_Program_Status__c;
            accountToUpdate.Add(acc);            
            if(ld.convertedOpportunityId!=null){                
                Opportunity opp = new Opportunity(ID=ld.convertedOpportunityId);
                opp.Referral_Program_Status__c = ld.Referral_Program_Status__c;              

                  
                
                opportunityToUpdate.Add(opp);
            }
            //Update and clear lists
            if(contactToUpdate.size()>200){
                update contactToUpdate;
                contactToUpdate.clear();
            }
            if(accountToUpdate.size()>200){
                update accountToUpdate;
                accountToUpdate.clear();
            }
            if(opportunityToUpdate.size()>200){
                update opportunityToUpdate;
                opportunityToUpdate.clear();
            }
        }
        //Update all lists
        if(contactToUpdate.size()>0){
            update contactToUpdate;            
        }
        if(accountToUpdate.size()>0){
            update accountToUpdate;            
        }
        if(opportunityToUpdate.size()>0){
            update opportunityToUpdate;            
        }
    }*/
    public static void setLeadStatus(List<Lead> leadList){
         for(Lead leadObj : leadList){
             if(leadObj.Promo_Code__c!=null && (leadObj.Promo_Code__c=='2011_NA_RLC_KeywordC' || leadObj.Promo_Code__c=='2011_NA_RLC_NJRadio' || leadObj.Promo_Code__c=='2011_NA_RLC_Sdtv') ){
                leadObj.Status='Qualified';
             }  
         }
    }
    public static void setLeadFields(List<Lead> leadList){
        
        List<String> countries = new List<String> (); 
        Map<String,String> countryMap =  new Map<String,String> ();
        
        List<Country_Reference__c> countryReferenceList = new List<Country_Reference__c>(); 
                                             
        for(Lead leadObj : leadList){
            //Start 00109049
            leadObj.SPWR_Industry_Type_Hidden__c = leadObj.SPWR_Industry_Type__c;
            //End 00109049
            if (leadObj.Owner.Type == 'User'){
                leadObj.Lead_Owner_Mapping__c = leadObj.OwnerId;//for case # 00060281
                }
            if (leadObj.Country == null && leadObj.State != null){
                
                if (STATES.contains(leadObj.State))
                    leadObj.Country = 'United States';               
            }  
            
            /* Commented for Sunpower Case # 00030235 */
            /*
            if (leadObj.Country == null){
                leadObj.Country = 'United States';               
            }
            */
            /**************************************/

            if (leadObj.Theater__c == 'NA'){
                leadObj.Theater__c = '';               
            }           


            /* Get all countries */
            if(leadObj.Country != null 
                && !countryMap.containsKey(leadObj.Country) && !leadObj.Override_Theater_Assigned__c){     
                             
                countries.add(leadObj.Country);   
                countryMap.put(leadObj.Country, leadObj.Country);                            

  
            }                                                                                

         
        }           
                        
        Map<String,String> countryTheaterMap = new Map<String,String> ();
        
        if(countries.size()>0){
            countryReferenceList = [select Country__c, Theater__c 
                                from Country_Reference__c where Country__c in : countries];
            for(Country_Reference__c countryRef : countryReferenceList)
            {
                    
                countryTheaterMap.put(countryRef.country__c, countryRef.theater__c);        
            }              

        }
        
 
        for(Lead leadObj : leadList){
        
            /* Theater */
            if(leadObj.Country != null 
                && countryTheaterMap.containsKey(leadObj.Country)){
                                   
                leadObj.Theater__c = countryTheaterMap.get(leadObj.Country);
                                    
            }

          }
    }
    
    //Set Campaign for the lead
    public static void setCampaign(List<Lead> leadList){
        System.debug('Entered in setcampaign');
        //Prepare set of promocdes of lead and set of leadIDs
        Set<String> setPromoCode = new Set<String>();        
        Set<String> setLeadID = new Set<String>();
        for(Lead ld:leadList){            
            setLeadID.Add(ld.id);  
            if(ld.Promo_Code__c!=null && ld.Promo_Code__c!=''){
                setPromoCode.Add(ld.Promo_Code__c);
            }                  
        }                               

        if (setPromoCode.size()==0)
            return;
        
        //Prepare map of promocode with campaigns 
        map<String,String> mapPromoCampaign = new map<String,String>();
        for(Campaign camp : [Select id,Promo_Code__c from Campaign where Promo_Code__c in 

:setPromoCode ]){
            mapPromoCampaign.put(camp.Promo_Code__c,camp.id);
        }  
        
        //Prepare set of lead which has campaign
        Set<String> setLeadWithCampaign = new Set<String>();
        for(CampaignMember camp : [Select id,leadID from CampaignMember where LeadID in 

:setLeadID ]){
            setLeadWithCampaign.Add(camp.leadID);
        } 
        
        //list of CampaignMember to insert
        List<CampaignMember> lstCampaignMember = new List<CampaignMember>();
        
        //Traverse through each lead record
        for(Lead leadObj : leadList){

            //Save campaignID according to Campaign_Temp__c of lead
            if(!setLeadWithCampaign.contains(leadObj.ID) && leadObj.ID!=null){
                //If Campaign exist for promo code
                if(mapPromoCampaign.containskey(leadObj.Promo_code__c)){
                    CampaignMember m = new 

CampaignMember(leadID=leadObj.ID,CampaignID=mapPromoCampaign.get(leadObj.Promo_code__c));
                    lstCampaignMember.Add(m);
                }

            } 
            
            if(lstCampaignMember.size()>200){
                insert lstCampaignMember; 
                lstCampaignMember.clear();
            }
        } 
        
        //Insert CampaingnMembers
        if(lstCampaignMember.size()>0){
            insert lstCampaignMember; 
        }
    }
    
    /* Call Assignment Rule Explicitly starts
        Note: We have to update Leads because there is a SF bug when we set it on
        before insert and not update it this thing doesnot works, so we here explicitly 

update it  
    */    
   //Case#00069690 start
   public static void doCallAssignmentRule(List<Lead> leadList, List<Lead> oldLeadList){
        System.debug('Entered in doCallAssignmentRule');            
        Map<Id, Lead> mapOldLeads = new Map<Id, Lead>();
        for(Lead l:oldLeadList){ 
           mapOldLeads.put(l.Id, l);
        }
        
        database.DMLOptions dmo = new database.DMLOptions();
        dmo.AssignmentRuleHeader.UseDefaultRule= true;
        
        //Current UserId Profile; *** Updated as per Connect5 Requirement ***
        User userStatus = currentUser;
        List<Lead> leadsToUpdate = new List<Lead>();
        for(Lead l :leadList){
            if((userStatus.Web_User__c == True && !l.IsRuleRunForWebUser__c) || 
            (l.Status == 'Open' && mapOldLeads.containsKey(l.Id) && (mapOldLeads.get(l.Id).Status == 'Archived' || mapOldLeads.get(l.Id).Status == 'Disqualified' || mapOldLeads.get(l.Id).Status == 'Nurture') )){             
                Lead newLead = new Lead(Id = l.Id);             
                newLead.IsRuleRunForWebUser__c = userStatus.Web_User__c == True? true : l.IsRuleRunForWebUser__c;
                newLead.setOptions(dmo); 
                leadsToUpdate.add(newLead);  
            }
         }
         
         if(leadsToUpdate.size()>0)
            update leadsToUpdate;              
                        
    }
    //Case#00069690 end
    
    
    /* Call Assignment Rule Explicitly ends*/
    
    /**
    Populates values in fields:
      1. Lead_CreatedDate_Text__c
      2. SP_Week__c       
    **/
    public static void CalculateCalendarWeek(List<Lead> lstLeads){ 
      DateTime leadCreatedDateTime;   
      Date leadCreatedDate;
      Date ssoFirstContactDate;
      
      Set<String> setDates;
      List<SP_Week_Lookup__c> lstSPWeeks;
      Map<String, Double> mapSPWeeks;
      
      setDates = new Set<String>();
      
      //for each lead
      for(Lead leadObj : lstLeads){
      
        //populate value in the field SSO_First_Contact_Date_Text__c
        if(leadObj.SSO_First_Contact_Date_Time__c != null){
          ssoFirstContactDate = 

Date.newInstance(leadObj.SSO_First_Contact_Date_Time__c.year(), 

leadObj.SSO_First_Contact_Date_Time__c.month(), 

leadObj.SSO_First_Contact_Date_Time__c.day());
          leadObj.SSO_First_Contact_Date_Text__c = 

String.valueOf(ssoFirstContactDate).replace('-', '');
        }
       
        //populate value in the field Lead_CreatedDate_Text__c
        if(leadObj.Lead_CreatedDate__c == null){
          leadCreatedDateTime = DateTime.now(); 
        }
        else{
          leadCreatedDateTime = leadObj.Lead_CreatedDate__c;
        }        
      
        leadCreatedDate = Date.newInstance(leadCreatedDateTime.year(), 

leadCreatedDateTime.month(), leadCreatedDateTime.day());        
        leadObj.Lead_CreatedDate_Text__c = String.valueOf(leadCreatedDate).replace('-', '');
        
        //create a set of leadCreatedDates      
        if(!setDates.contains(leadObj.Lead_CreatedDate_Text__c)){
          setDates.add(leadObj.Lead_CreatedDate_Text__c);   
        }               
      }//end for loop
      
      
      //query SP_Week__c for Text_Date__c and SP_week__c fields        
      lstSPWeeks = new List<SP_Week_Lookup__c>();
      lstSPWeeks = [select Id, Name, SP_Week__c, Text_Date__c from SP_Week_Lookup__c where Text_Date__c in :setDates];
      
      //create a map Map<String, String> with key as Text_Date__c and value as SP_Week__c
      mapSPWeeks = new Map<String, Double>();
      for(SP_Week_Lookup__c spWeekObj : lstSPWeeks){
        if(!mapSPWeeks.containsKey(spWeekObj.Text_Date__c)){
          mapSPWeeks.put(spWeekObj.Text_Date__c, spWeekObj.SP_Week__c);  
        }   
      }
      
      //for each lead get week number from the Map      
      for(Lead leadObj : lstLeads){
        if(mapSPWeeks.containsKey(leadObj.Lead_CreatedDate_Text__c)){
          leadObj.SP_Week__c = mapSPWeeks.get(leadObj.Lead_CreatedDate_Text__c);           
        }
        else{
          leadObj.SP_Week__c = 0;   
        }       
      }//end for loop        
    }    
    
    public static void SetDealerAccountName(List<Lead> lstLeads) {
        
        Map<Id,Account> mapAccount = new Map<Id,Account>();
        Set<String> setDealername = new Set<String>();
        
        for (Lead led : lstLeads ) {
            
            setDealername.add(led.Dealer_Name__c);
        }
        
        if(setDealername.size() > 0) {
            
            mapAccount = new Map<ID, Account>([Select id, Name from Account where id in :setDealername]);

        }
        
        if(mapAccount.size() > 0)   //Added this condition for case#00155353
        {
        for (Lead objLead :lstLeads ) {
            boolean validDealerId = false;
            validDealerId = Util.isValidId(objLead.Dealer_Name__c);
            
            //if (objLead.Dealer_Name__c != null && objLead.Dealer_Name__c != '' )
            if (validDealerId){    
                System.debug('----- dealer name id--' +objLead.Dealer_Name__c );
                //if (mapAccount.get(objLead.Dealer_Name__c) != null)
                if (mapAccount.containsKey(objLead.Dealer_Name__c)){ 
                    
                    Account acct = mapAccount.get(objLead.Dealer_Name__c);
                    objLead.Dealer_Locator_Selection__c = acct.id;
                    
            // Case : 00045373 ('Lead Status' Field Automatically Populated with 'Contacted - Awaiting Response' for Dealer Locator Leads)
            // Done for Case # 00070429 Changing Dealer Locator Default Lead Status from 'Contacted– Awaiting Response' to 'Open' 
                    //objLead.Status = 'Contacted– Awaiting Response';
                     objLead.Status = 'Open';
                }
                
            }
        }
        }
    }
 
       /**
      1. add old list items to old map Map<Lead Id, lead Object>
      2. for each lead object in new list check for the is converted flag
      3. if the flag is true then check for the old object, if there the flag is false then 

add this object in list and lead id in set
      4. fetch all Lead Site records where leadId in the set
      5. Create new Site Information Form record corresponding to lead site record
      6. Insert Site information records 
      **/
/*
    public static void processLeadSites(List<Lead> leadList, List<Lead> oldLeadList){

      
      //holds key value of Lead Id and Lead objects 
      Map<Id, Lead> mapOldLeads = new Map<Id, Lead>();
      
      //holds Lead ids
      Set<Id> setLeadIds = new Set<Id>();
      
      //holds Lead_Site__c objects
      List<Lead_Site__c> lstLeadSites = new List<Lead_Site__c>();
      
      //holds Site_Information_Form__c objects to insert
      List<Site_Information_Form__c> lstSiteInfoInsert = new 

List<Site_Information_Form__c>(); 
      
      //add old list items to old map
      for(Lead leadObj : oldLeadList){
        if(!mapOldLeads.containsKey(leadObj.Id)){
          mapOldLeads.put(leadObj.Id, leadObj);
        }   
      }
      
      //for each lead object in new list check for the is converted flag
      for(Lead leadObj : leadList){
        //if the flag is true then check for the old object 
        if(leadObj.isConverted == true){
          //if in old object the flag is false then add this lead id in set
          if(mapOldLeads.containsKey(leadObj.Id)){
            Lead leadOldObj = mapOldLeads.get(leadObj.Id);
            if(leadOldObj.isConverted == null || leadOldObj.isConverted == false){
              setLeadIds.add(leadObj.Id);   
            }
          }     
        }   
      }
      //return if the set is empty
      if(setLeadIds.size() <= 0){
        return;
      }
      
      //fetch all Lead Site records where leadId in the set
      lstLeadSites = [select Id, Name, City__c, Country__c, Lead__c, State__c, Street__c, 

PostalCode__c,
                      Lead__r.ConvertedAccountId 
                      from Lead_Site__c 
                      where Lead__c in :setLeadIds Limit 1000];
      
      //Create new Site Information Form record corresponding to lead site record
      for(Lead_Site__c leadSiteObj : lstLeadSites){
        //create new object
        Site_Information_Form__c siteInfoObj = new Site_Information_Form__c();
        
        //map fields
        siteInfoObj.Site_Address__c = leadSiteObj.Street__c;
        siteInfoObj.Site_City__c = leadSiteObj.City__c;
        siteInfoObj.Site_State__c = leadSiteObj.State__c;
        siteInfoObj.Site_Zip_Postal_Code__c = leadSiteObj.PostalCode__c;
        siteInfoObj.Site_Country__c = leadSiteObj.Country__c;
        siteInfoObj.Account__c = leadSiteObj.Lead__r.ConvertedAccountId;        
        
        //add to insert list
        lstSiteInfoInsert.add(siteInfoObj);         
      }
      
      //Insert Site information records 
      if(lstSiteInfoInsert.size() > 0){
        insert lstSiteInfoInsert;
      }    


    }
*/    
 
    //Set duplicate flag if Lead is duplicate   
/*
    public static void checkDuplicateLead(List<Lead> leadList){
        
        // Get the map of Last name with Lead object 
        //  and set of last name,lead type,phone,email which are coming to insert
        //
        
        map<String,Lead> mapLastNameLead = new map<String,Lead>();
        Set<String> setFirstName = new Set<String>();
        Set<String> setLeadType = new Set<String>();
        Set<String> setPhone = new Set<String>();
        Set<String> setEmail = new Set<String>();
        
        for(Lead ld:leadList){
            
            if(mapLastNameLead.containsKey(ld.LastName)){
                //To check if there is any duplicate lead in Leads coming to insert 
                // when bulk insertion occurs
                Lead existingLead = mapLastNameLead.get(ld.LastName);
                if(ld.FirstName==existingLead.FirstName 
                    && ld.Lead_Type__c==existingLead.Lead_Type__c 
                    && (ld.Phone==existingLead.Phone || ld.Email==existingLead.Email)){
                    ld.duplicate__c = true;
                    continue;
                }//end-if
            }//end-if
            
            mapLastNameLead.put(ld.LastName,ld);
            setFirstName.Add(ld.FirstName);
            setLeadType.Add(ld.Lead_Type__c);
            setPhone.Add(ld.Phone);
            setEmail.Add(ld.Email);
        }//end-for
        
        //Get the list of existing Leads which has same first name,lastname,lead 

type,phone,email
        for(List<Lead> lstExistingLeads :
            [Select id,FirstName,LastName,Phone,Email,Lead_Type__c 
                from Lead 
                where LastName in :mapLastNameLead.keySet() 
                    and FirstName in :setFirstName 
                    and Lead_Type__c in :setLeadType 
                    and (phone in :setPhone or email in : setEmail)]){
                        
            for(Lead existingLead:lstExistingLeads){
                
                //Continue if Last Name does not exist in the map
                if(!mapLastNameLead.containsKey(existingLead.LastName)){
                    continue;
                }
                
                //To check if there is any duplicate lead in already inserted Leads 
                Lead currentLead = mapLastNameLead.get(existingLead.LastName);
                if(currentLead.FirstName==existingLead.FirstName 
                    && currentLead.Lead_Type__c==existingLead.Lead_Type__c 
                    && (currentLead.Phone==existingLead.Phone || 

currentLead.Email==existingLead.Email)){
                        
                    currentLead.duplicate__c = true;                   
                }//end-if                
            }//end-for
        }//end-for
    }
    
*/ 
  
  //Lead Status Updated as "Qualified"
  public static void AfetrLeadStatusUpdate(List<Lead> leadList, Map<ID,Lead> mapOldLead)
  {     
    Map<Id, Lead> leadMap = new Map<Id, Lead>();
    List<Site_Information_Form__c> Sitelst = new List<Site_Information_Form__c>();
    List<Site_Information_Form__c> UpdatedSite = new List<Site_Information_Form__c>();
    ID siteRecordTypeId;
    ID leadRecordTypeId;
    
    //Lead RecordTypeId 
    Map <String,ID> leadRecordTypes = new Map<String,ID>(); 
    // Schema.DescribeSObjectResult d = Schema.SObjectType.Lead;
    // Map<Id,Schema.RecordTypeInfo> leadMapById = d.getRecordTypeInfosById();
    Map<Id,Schema.RecordTypeInfo> leadMapById = idToLeadRecordTypeInfoMap;
    for(ID i:leadMapById.keySet()){
      leadRecordTypes.put(leadMapById.get(i).name,string.valueOf(i));
    }
    if(leadRecordTypes.get('Systems')!=null)
         leadRecordTypeId = leadRecordTypes.get('Systems');
 
    
    for(Lead newlead : leadList)
    {
       if(newlead.Status =='Qualified' && newlead.IsConverted == false && (newlead.status != mapOldLead.get(newlead.Id).Status) && newlead.RecordTypeId == leadRecordTypeId)
       {   
          leadMap.put(newLead.id,newLead);
       }   
    }   
    if(leadMap.size()== 0){
     return;
    }
    
    //Site RecordTypeId
    Map <String,ID> siteRecordTypes = new Map<String,ID>(); 
    Schema.DescribeSObjectResult dc = Schema.SObjectType.Site_Information_Form__c;
    Map<Id,Schema.RecordTypeInfo> siteMapById = dc.getRecordTypeInfosById();
    for(ID i:siteMapById.keySet()){
      siteRecordTypes.put(siteMapById.get(i).name,string.valueOf(i));
    }
   
    if(siteRecordTypes.get('Lead Sites')!=null)
         siteRecordTypeId = siteRecordTypes.get('Lead Sites');
    
    Set<String> leadsWithSite = new Set<String>();   
    for(Site_Information_Form__c site: [Select Id,Lead__c,RecordType.Name,RecordTypeId,Site_Address__c,Site_City__c,Site_Zip_Postal_Code__c,Site_State__c 
                                             from Site_Information_Form__c where Lead__c in :leadMap.keySet() and RecordType.Name ='Lead Sites'])   
    {
           leadsWithSite.add(site.Lead__c);
           if(leadMap.get(site.Lead__c).Facility_Address__c ==null && leadMap.get(site.Lead__c).Facility_Address_2__c ==null && leadMap.get(site.Lead__c).facility_City__c == null && leadMap.get(site.Lead__c).Facility_Zip__c == null && leadMap.get(site.Lead__c).Facility_State__c == null)
           {
               continue;
           } 
           site.Site_Address__c = leadMap.get(site.Lead__c).Facility_Address__c + ' '+ leadMap.get(site.Lead__c).Facility_Address_2__c; 
           site.Site_City__c = leadMap.get(site.Lead__c).Facility_City__c; 
           site.Site_Zip_Postal_Code__c = leadMap.get(site.Lead__c).Facility_Zip__c; 
           site.Site_State__c = leadMap.get(site.Lead__c).Facility_State__c; 
           UpdatedSite.add(site);               
    }
    
    for(Lead newlead : leadList)
    {
        if(leadMap.get(newlead.Id).Facility_Address__c ==null && leadMap.get(newlead.Id).Facility_Address_2__c ==null && leadMap.get(newlead.Id).facility_City__c == null && leadMap.get(newlead.Id).Facility_Zip__c == null && leadMap.get(newlead.Id).Facility_State__c == null)
         {
           continue;
         }
       if(!leadsWithSite.contains(newlead.id))
       {              
         Site_Information_Form__c Newsite = new Site_Information_Form__c();
         Newsite.Site_Status__c = 'Active';          
         Newsite.RecordTypeId = siteRecordTypeId;
         Newsite.Site_Name__c = leadMap.get(newlead.Id).Company + ' Site';
         Newsite.Lead__c = newlead.Id;
         Newsite.Site_Address__c = leadMap.get(newlead.Id).Facility_Address__c + ' '+ leadMap.get(newlead.Id).Facility_Address_2__c;           
         Newsite.Site_City__c = leadMap.get(newlead.Id).Facility_City__c; 
         Newsite.Site_Zip_Postal_Code__c = leadMap.get(newlead.Id).Facility_Zip__c; 
         Newsite.Site_State__c = leadMap.get(newlead.Id).Facility_State__c;
         UpdatedSite.add(Newsite);   
       } 
    }
    upsert UpdatedSite;
   
  }
  
  // Done for case # 00059458
  //Share the lead records
  public static void shareLeadRecordsAfterInsertAndUpdate(List<Lead> leadListNew , Map<Id,Lead> leadMapOld){
    
    System.debug('*********shareLeadRecordsAfterInsertAndUpdate ******* list size '+leadListNew.size());
    List<Lead> leadListToInsertLS = new List<Lead>();
    Set<Id> leadIdSetToInsertLS = new Set<Id>();
    List<LeadShare> leadShareToBeDeleted = new List<LeadShare>();
    Set<Id> leadIdToDeleteNALS = new Set<Id>();
    Set<Id> leadIdToDeleteLS = new Set<Id>();
    List<LeadShare> leadShareToBeInserted = new List<LeadShare>();
    
    Set<Id> leadIDSetToInsertNALS = new Set<Id>();
    
    for(Lead lead : leadListNew){
      if(leadMapOld != null && (lead.Business_Unit__c == 'RLC' && lead.RLC_Type__c == 'Light Commercial')
                  && leadMapOld.get(lead.Id).Business_Unit__c == 'NA Commercial'){
        leadIDSetToInsertNALS.add(lead.Id);
      }
      else if(leadMapOld != null && lead.Business_Unit__c == 'NA Commercial' 
              && (leadMapOld.get(lead.Id).Business_Unit__c == 'RLC' && leadMapOld.get(lead.Id).RLC_Type__c == 'Light Commercial') ){
          leadIdToDeleteNALS.add(lead.Id);
      }
      else if( (lead.Business_Unit__c == 'RLC' && lead.RLC_Type__c == 'Light Commercial')
                    || lead.Business_Unit__c == 'NA Commercial' ) {    
          leadListToInsertLS.add(lead);
          leadIdSetToInsertLS.add(lead.Id);
      }
      else if( leadMapOld != null
                &&( lead.Business_Unit__c != 'RLC' || lead.Business_Unit__c != 'NA Commercial' || (lead.Business_Unit__c == 'RLC' && lead.RLC_Type__c != 'Light Commercial')) 
                && ( (leadMapOld.get(lead.Id).Business_Unit__c == 'RLC' && leadMapOld.get(lead.Id).RLC_Type__c == 'Light Commercial') || leadMapOld.get(lead.Id).Business_Unit__c == 'NA Commercial' )){
          leadIdToDeleteLS.add(lead.Id);            
      }
    }
    
    // Set of lead ids having lead share record
    Set<Id> existingLeadSet = new Set<Id>();
    
    /*for(LeadShare ls : [select LeadId from LeadShare where LeadId In : leadListToInsertLS
                            AND UserOrGroupId in :roleNameGroupIdMap.values()
                            AND RowCause = 'Manual']){
      existingLeadSet.add(ls.LeadId);
    }*/
    
    if(leadIDSetToInsertNALS.size() == 0 && leadIdToDeleteNALS.size() == 0 && leadIdSetToInsertLS.size() == 0 && leadIdToDeleteLS.size() == 0){
        return;
    }
    
    
    //Get RoleID
    Map<ID,UserRole> mapUserRole = new Map<ID,UserRole>([select Id ,name from UserRole where name IN ('NA Commercial','Commercial Regional Sales Manager NA')]);

    // Get GroupID
    Set<ID> setGroup = new Set<ID>();
    Map<String,Id> roleNameGroupIdMap = new Map<String,Id>();
    
    for(Group g : [select id,relatedID from Group where relatedid in :mapUserRole.keySet() and type='Role']){
      setGroup.Add(g.ID);
      if(mapUserRole.get(g.relatedID)!=null)
        roleNameGroupIdMap.put(mapUserRole.get(g.relatedID).name,g.ID);
    }                    
    System.debug('*********shareLeadRecordsAfterInsertAndUpdate in map******* list size '+leadListNew.size());
    // Preparing Map of LeadShare for Leads
    Map<Id,LeadShare> leadShareMap = new Map<Id,LeadShare> ([select id,LeadId,UserOrGroupId,RowCause from LeadShare where LeadId In :leadListNew AND UserOrGroupId IN:setGroup ]); 
    
    for(Id leadId : leadIDSetToInsertNALS){              
        leadShareToBeInserted.add(getLeadShare(leadId , roleNameGroupIdMap.get('NA Commercial')));
    }
    for(LeadShare ls : leadShareMap.values()){
        if(leadIdSetToInsertLS.contains(ls.LeadId) && setGroup.contains(ls.UserOrGroupId) && ls.RowCause == 'Manual')
            existingLeadSet.add(ls.LeadId);
        else if( ((leadIdToDeleteNALS.contains(ls.LeadID) && ls.UserOrGroupId == roleNameGroupIdMap.get('NA Commercial')) 
                      ||(leadIdToDeleteLS.contains(ls.LeadID) && setGroup.contains(ls.UserOrGroupId)) )
                  && ls.RowCause == 'Manual'){
            leadShareToBeDeleted.add(ls);       
        }           
    } 

    for(Lead lead : leadListToInsertLS){
      if(!existingLeadSet.contains(lead.Id)){
        // RLC Commercial Leads shared with roles : "NA Commercial",
        //    "Commercial Regional Sales Manager NA" and read only access 
        //  Also NA Commercial Leads shared with role : "Commercial Regional Sales Manager NA" and read only access         
        if( (lead.Business_Unit__c == 'RLC' && lead.RLC_Type__c == 'Light Commercial') 
                || lead.Business_Unit__c == 'NA Commercial' ){
          if(lead.Business_Unit__c == 'RLC' && lead.RLC_Type__c == 'Light Commercial'){
            leadShareToBeInserted.add(getLeadShare(lead.Id , roleNameGroupIdMap.get('NA Commercial')));
          } 
          leadShareToBeInserted.add(getLeadShare(lead.Id , roleNameGroupIdMap.get('Commercial Regional Sales Manager NA')));
        }
      }
    }
     
    /*if(leadIdToDeleteNALS.size()>0 ||leadIdToDeleteLS.size()>0){
      for(LeadShare ls : [select LeadId,RowCause from LeadShare where 
                              ((LeadId IN :leadIdToDeleteNALS AND  UserOrGroupId =:roleNameGroupIdMap.get('NA Commercial')) OR
                              (LeadId IN :leadIdToDeleteLS AND  UserOrGroupId IN :roleNameGroupIdMap.values())) 
                               AND RowCause = 'Manual']){
        leadShareToBeDeleted.add(ls);
      }
    }*/
     
    if(leadShareToBeDeleted.size()>0)
      delete leadShareToBeDeleted;
    
    if(leadShareToBeInserted.size()>0)
      Database.SaveResult[] leadShareInsertResult = Database.insert(leadShareToBeInserted,false);
  }
    
  private static LeadShare getLeadShare(Id leadId , Id userOrGroupId){
    LeadShare ls = new LeadShare();
    ls.LeadId = leadId;
    ls.UserOrGroupId = userOrGroupId;
    ls.LeadAccessLevel = 'read';
    return ls;
  }
  
  // Done for Case # 00084504
   private static void setLeadTeam(List<Lead> leadList, List<Lead> oldLeadList){
        Map<Id, Lead> mapLead = new Map<Id, Lead>();
        if(oldLeadList != null && oldLeadList.size()>0){
            for(Lead l:oldLeadList){ 
               mapLead.put(l.Id, l);
            }
        }
        
        Set<Id> leadOwnerIdSet = new Set<Id>();
        //Start 92576
        Set<Id> leadOwnerIdQueueSet = new Set<Id>();
        //End 92576
        //Start 00094059
        Set<String> leadEventContactUser = new Set<String>();
        Set<String> leadEventContactQueue = new Set<String>();
        //End 00094059
        for(Lead led:leadList){
            //Start 00094059
            if((led.LeadSource=='Event' || led.LeadSource=='Event/Seminar/Webinar')&& led.Event_Contact__c != null && led.Event_Contact__c != '' && oldLeadList==null){
                if(led.Event_Contact__c.contains('Queue'))
                    leadEventContactQueue.add(led.Event_Contact__c);
                else
                    leadEventContactUser.add(led.Event_Contact__c);
            }
            //End 00094059
            if(oldLeadList != null && led.OwnerId == mapLead.get(led.Id).OwnerId){
                continue;
            }
            //System.debug('value->'+led.OwnerId);
            //Start 92576
            if(led.OwnerId != null && String.valueOf(led.OwnerId).startsWith('005'))
            //End 92576
                leadOwnerIdSet.add(led.OwnerId);
            //Start 92576
            else
                leadOwnerIdQueueSet.add(led.OwnerId);
            //End 92576
        }
        
        if(leadOwnerIdSet.Size() > 0 || leadEventContactUser.size()>0){
            Map<Id,User> userMap = new Map<Id,User>([select id,name,Lead_Team__c,isactive from User where id IN: leadOwnerIdSet or name in :leadEventContactUser]);
            //Start 00094059
            Map<String,User> userEventContact = new Map<String,User>();
            if(leadEventContactUser.size()>0){
                for(User u: userMap.values()){
                    if(leadEventContactUser.contains(u.name) && u.isActive)
                        userEventContact.put(u.name,u);
                }
            }
            //End 00094059
            for(Lead led:leadList){
                //Start 00094059
                if(userEventContact.containsKey(led.Event_Contact__c)){
                    led.OwnerID = userEventContact.get(led.Event_Contact__c).ID;
                }
                //End 00094059              
                if(led.OwnerId!=null && userMap.size()>0 && String.valueOf(led.OwnerId).startsWith('005') && userMap.keySet().contains(led.OwnerId)){                
                    led.Lead_Team__c = userMap.get(led.OwnerId).Lead_Team__c;
                }else{
                    led.Lead_Team__c = null;
                }
            }
        }
        //Start 92576
        if(leadOwnerIdQueueSet.Size() > 0 || leadEventContactQueue.size()>0){
            Map<Id,Group> queueMap = new Map<Id,Group>([select id, Name from Group where id IN: leadOwnerIdQueueSet or name in :leadEventContactQueue]);
             //Start 00094059
            Map<String,Group> queueEventContact = new Map<String,Group>();
            if(leadEventContactQueue.size()>0){
                for(Group g: queueMap.values()){
                    if(leadEventContactQueue.contains(g.name))
                        queueEventContact.put(g.name,g);
                }
            }
            //End 00094059
            for(Lead led:leadList){
                //Start 00094059
                if(queueEventContact.containsKey(led.Event_Contact__c)){
                    led.OwnerID = queueEventContact.get(led.Event_Contact__c).ID;
                }
                //End 00094059 
                if(led.OwnerId!=null && queueMap.size()>0 && queueMap.keySet().contains(led.OwnerId)){  
                    if(queueMap.get(led.OwnerId).Name.contains('NA Commercial Marketing Queue'))              
                        led.Lead_Team__c = 'Marketing';
                    else if(queueMap.get(led.OwnerId).Name.contains('NA Commercial ISR Queue'))
                        led.Lead_Team__c = 'ISR';
                }
            }
        }
        //End 92576
   }  
   
   public static void updateLeadScore(Lead newLead){

    //this should go somewhere else
    //for(ID recordTypeId: idToLeadRecordTypeInfoMap.keySet()){
    //    mapRecordTypeIDName.put(recordTypeId, idToLeadRecordTypeInfoMap.get(recordTypeId).getName());
    //    if (idToLeadRecordTypeInfoMap.get(recordTypeId).getName() == 'Systems') {
    //        systemsRecordTypeId = recordTypeId;
    //    }
    //}
        // Commented for Case 00049358    
    Integer score = 0;
    Integer roofSize = 0;
    String roofMaterial='', roofAge='', installationTime='', avgeBill='', country='', grade='';
    String state='', homesbuildperYear='', numberOfStates='', numberOfSites='', installedThisYear='', systemSize='';
    String permitting = '', incentiveRebateReservation = '', mountingSystem = '', sizeOfProjects = '';
    String installDistributePV = '', experienceInYears = '', registryPresence = '', anticipatedDemand = '';
    Boolean iplanned, immediateInterest, engineeringResource, rooftopExp, focusOnGround, largeSystemExp;    
    
    //start for case # 00061964
    
      if(mapRecordTypeIDName.get(newlead.recordTypeID) == 'Residential' || mapRecordTypeIDName.get(newlead.recordTypeID) == 'Systems'){ //is this neccessary?
      if(mapRecordTypeIDName.get(newlead.recordTypeID) == 'Residential' && newlead.Theater__c != null && newlead.Theater__c == NA){
    //end for case # 00061964
        if(newlead.Ground_Roof_Space__c != null){     
          try{
            roofSize = Integer.ValueOf(newlead.Ground_Roof_Space__c);
          } catch(Exception ex){
            newlead.Ground_Roof_Space__c.addError(ex.getMessage());
            return;            
          }
          if(roofSize <= 250){
            score = 1;
          } else if(roofSize > 250 && roofSize <= 500) {
            score = 2;
          } else if(roofSize > 500) {
            score = 3; 
          }
        }   
        if(newlead.Roof_Material__c != null){
          roofMaterial =newlead.Roof_Material__c;
           if(roofMaterial == 'Membrane'){
             score += 0;
           } else if(roofMaterial == 'Corrugated Metal') {
             score++;
           } else if(roofMaterial == 'Metal Standing') {
             score += 2; 
           } else if(roofMaterial == 'Asphalt Shingle') {
             score += 3; 
           }
        }
        if(newlead.Age_Of_Roof__c != null){
          roofAge=newlead.Age_Of_Roof__c;
          if(roofAge == '> 15 yrs'){
            score += 0;
          } else if(roofAge == '> 10 yrs') {
            score++;
          } else if(roofAge == '> 5 yrs') {
            score += 2; 
          } else if(roofAge == '< 5 yrs') {
            score += 3; 
          }    
        }
        if(newlead.Time_Of_Installation__c != null){
          installationTime=newlead.Time_Of_Installation__c;
          if(installationTime == '> 6 months'){
            score += 0;
          } else if(installationTime == '> 3 months') {
            score++;
          } else if(installationTime == '< 2 months') {
            score += 2; 
          } else if(installationTime == '< 1 month') {
            score += 3; 
          }    
        }
        if(newlead.Average_Monthly_Electricity_Bill__c != null){
          avgeBill =newlead.Average_Monthly_Electricity_Bill__c;
          if(avgeBill == '< $50'){
            score += 0;
          } else if(avgeBill == '> $50') {
            score++;
          } else if(avgeBill == '> $150') {
            score += 2; 
          } else if(avgeBill == '> $300') {
            score += 3; 
          }    
        }
        if(score > 12){
          grade = 'A';
          newlead.LeadScore__c = score ;
          newlead.Rating = grade;
        } else if(score >= 9 && score <= 12){
          grade = 'B';
          newlead.LeadScore__c = score ;
          newlead.Rating = grade;
        } else if(score < 9){ 
          grade = 'C';  
          newlead.LeadScore__c = score ;
          newlead.Rating = grade;
        }
      }
      //start for case # 00061964
      else if(newlead.Theater__c != null 
        && (newlead.Theater__c == EU) || (newlead.Theater__c == AU)
        && newlead.Business_Unit__c !=null
        && newlead.Business_Unit__c == 'RLC'){              
        score = 0;
        grade = '';
        if(newlead.Installation_Type__c != null){
            if(newlead.Installation_Type__c.contains('Flat Roof') || newlead.Installation_Type__c.contains('Carport') || 
            (newlead.Installation_Type__c.contains('Slope Roof') && newlead.Roof_Orientation__c != null && newlead.Roof_Orientation__c == 'Doesn’t Know')
            ){
                //System.debug(loggingLevel.INFO, 'In Else if '+newlead.Time_Of_Installation__c);
                if(newlead.Time_Of_Installation__c != null){
                    if(newlead.Time_Of_Installation__c == '< 1 month' || newlead.Time_Of_Installation__c == '< 2 months' || newlead.Time_Of_Installation__c == '> 3 months')
                        score += 50;
                    else if(newlead.Time_Of_Installation__c == '> 5 months' || newlead.Time_Of_Installation__c == '> 6 months')
                        score += 30;
                }
                if(newlead.Did_you_apply_for_financing__c                       
                        && newlead.Time_Of_Installation__c != null
                        && newlead.Time_Of_Installation__c == '> 3 months')
                            score += 10;
                if(newlead.Did_you_apply_for_financing__c                       
                        && newlead.Time_Of_Installation__c != null
                        && newlead.Time_Of_Installation__c == '> 6 months')
                            score += 30;
                //System.debug(loggingLevel.INFO, 'In Else if '+score);
                if(score >= 60){
                  grade = 'A+';
                } else if(score >= 50){
                  grade = 'A';
                } else if(score >= 30){
                  grade = 'B';
                } else if(score >= 0){ 
                  grade = 'C'; 
                }
                //System.debug(loggingLevel.INFO, 'In Else if '+score);
                //System.debug(loggingLevel.INFO, 'In Else if '+grade);
                newlead.LeadScore__c = score ;
                newlead.Rating = grade;
            } else if(newlead.Installation_Type__c.contains('Slope Roof') || newlead.Installation_Type__c.contains('Metal Roof')){ 
                if(newlead.Theater__c == EU){
                    if(newlead.Roof_Orientation__c != null){ 
                        if(newlead.Roof_Orientation__c == 'North' || newlead.Roof_Orientation__c == 'North-West' || newlead.Roof_Orientation__c == 'North-East' )
                            score -= 40;
                        else if(newlead.Roof_Orientation__c == 'West' || newlead.Roof_Orientation__c == 'East')
                            score += 30;
                        else if(newlead.Roof_Orientation__c == 'South' || newlead.Roof_Orientation__c == 'South-West' || newlead.Roof_Orientation__c == 'South-East')
                            score += 50;
                    }
                    if(newlead.Did_you_apply_for_financing__c
                        && (newlead.Roof_Orientation__c == 'South' || newlead.Roof_Orientation__c == 'South-West' || newlead.Roof_Orientation__c == 'South-East')
                        && newlead.Time_Of_Installation__c != null
                        && newlead.Time_Of_Installation__c == '> 3 months')
                            score += 10;
                    if(newlead.Did_you_apply_for_financing__c
                        && (newlead.Roof_Orientation__c == 'South' || newlead.Roof_Orientation__c == 'South-West' || newlead.Roof_Orientation__c == 'South-East')
                        && newlead.Time_Of_Installation__c != null
                        //&& newlead.Time_Of_Installation__c == '> 6 months')//for Case#00081678 - Jitendra
                        && (newlead.Time_Of_Installation__c == '> 5 months' || newlead.Time_Of_Installation__c == '> 6 months'))//for Case#00081678 - Jitendra
                            score += 20;
                    if(newlead.Did_you_apply_for_financing__c
                        && (newlead.Roof_Orientation__c == 'West' || newlead.Roof_Orientation__c == 'East')
                        && newlead.Time_Of_Installation__c != null
                        && newlead.Time_Of_Installation__c == '> 3 months')
                            score += 30;
                    if(newlead.Did_you_apply_for_financing__c
                        && (newlead.Roof_Orientation__c == 'West' || newlead.Roof_Orientation__c == 'East')
                        && newlead.Time_Of_Installation__c != null
                        //&& newlead.Time_Of_Installation__c == '> 6 months')//for Case#00081678 - Jitendra
                        && (newlead.Time_Of_Installation__c == '> 5 months' || newlead.Time_Of_Installation__c == '> 6 months'))//for Case#00081678 - Jitendra
                            score += 50;
                }else if(newlead.Theater__c == AU){
                    //System.debug(loggingLevel.INFO, 'In EU and AU ');
                    if(newlead.Roof_Orientation__c != null){ 
                        if(newlead.Roof_Orientation__c == 'North' || newlead.Roof_Orientation__c == 'North-West' || newlead.Roof_Orientation__c == 'North-East' )
                            score += 50;
                        else if(newlead.Roof_Orientation__c == 'West' || newlead.Roof_Orientation__c == 'East')
                            score += 30;
                        else if(newlead.Roof_Orientation__c == 'South' || newlead.Roof_Orientation__c == 'South-West' || newlead.Roof_Orientation__c == 'South-East')
                            score -= 40;
                    }
                    if(newlead.Did_you_apply_for_financing__c
                        && (newlead.Roof_Orientation__c == 'North' || newlead.Roof_Orientation__c == 'North-West' || newlead.Roof_Orientation__c == 'North-East')
                        && newlead.Time_Of_Installation__c != null
                        && newlead.Time_Of_Installation__c == '> 3 months')
                            score += 10;
                    if(newlead.Did_you_apply_for_financing__c
                        && (newlead.Roof_Orientation__c == 'North' || newlead.Roof_Orientation__c == 'North-West' || newlead.Roof_Orientation__c == 'North-East')
                        && newlead.Time_Of_Installation__c != null
                        //&&  newlead.Time_Of_Installation__c == '> 6 months')//for Case#00081678 - Jitendra
                        && (newlead.Time_Of_Installation__c == '> 5 months' || newlead.Time_Of_Installation__c == '> 6 months'))//for Case#00081678 - Jitendra
                            score += 20;
                    if(newlead.Did_you_apply_for_financing__c
                        && (newlead.Roof_Orientation__c == 'West' || newlead.Roof_Orientation__c == 'East')
                        && newlead.Time_Of_Installation__c != null
                        && newlead.Time_Of_Installation__c == '> 3 months')
                            score += 30;
                    if(newlead.Did_you_apply_for_financing__c
                        && (newlead.Roof_Orientation__c == 'West' || newlead.Roof_Orientation__c == 'East')
                        && newlead.Time_Of_Installation__c != null
                        //&& newlead.Time_Of_Installation__c == '> 6 months')//for Case#00081678 - Jitendra
                        && (newlead.Time_Of_Installation__c == '> 5 months' || newlead.Time_Of_Installation__c == '> 6 months'))//for Case#00081678 - Jitendra
                            score += 50;        
                }
                
                if(newlead.Time_Of_Installation__c != null){
                    if(newlead.Time_Of_Installation__c == '< 1 month' || newlead.Time_Of_Installation__c == '< 2 months' || newlead.Time_Of_Installation__c == '> 3 months')
                        score += 50;
                    else if(newlead.Time_Of_Installation__c == '> 5 months' || newlead.Time_Of_Installation__c == '> 6 months')
                        score += 30;
                }
                
                if(score >= 110){
                  grade = 'A+';
                } else if(score >= 100){
                  grade = 'A';
                } else if(score >= 60 && score <= 80){
                  grade = 'B';
                } else if(score <= 50){ 
                  grade = 'C'; 
                } 
                //System.debug(loggingLevel.INFO, 'In Else if '+score);
                //System.debug(loggingLevel.INFO, 'In Else if '+grade);
                newlead.LeadScore__c = score ;
                newlead.Rating = grade;
            } 
        }
      }//end else if(newlead.Theater__c != null && (newlead.Theater__c == EU) || (newlead.Theater__c == AU))
      //end else if(newlead.Theater__c != null && newlead.Theater__c == EU)
      //end for case # 00061964
    }//end if(mapRecordTypeIDName.get(newlead.recordTypeID) == 'Residential'){
    
    // Changed for Case 00049358
    // else if(mapRecordTypeIDName.get(newlead.recordTypeID) == 'Commercial'){
    // Commented for Case 00053777
    
    else if(mapRecordTypeIDName.get(newlead.recordTypeID) == 'New Homes'){
      if(newlead.Theater__c != null && newlead.Theater__c == NA){
        if(newlead.State == null) {
          score = 0; 
        } else{
          state = newlead.State ;
          if(state == 'California' || state == 'Colorado' || state == 'Arizona' || state == 'Nevada'){
            score = 3;
          } else {
            score = 2;
          }            
        }
      }
      if(newlead.Homes_Built_per_year__c != null){
        homesbuildperYear = newlead.Homes_Built_per_year__c;
        if(homesbuildperYear == '< 500'){
          score += 0;
        } else if(homesbuildperYear == '500 - 1000'){
          score++;
        } else if(homesbuildperYear  == '1000 - 2000'){ 
          score += 2;
        } else if(homesbuildperYear  == '> 2000'){ 
          score += 3;
        }            
      }
      if(newlead.Number_Of_States__c != null){
        numberOfStates = newlead.Number_Of_States__c;
        if(numberOfStates == '1'){
          score++;
        } else if(numberOfStates  == '2'){ 
          score += 2;
        } else if(numberOfStates  == '3 +'){
          score += 3;
        } 
      } else{
        score += 0;
      }            
      if(newlead.Number_of_Sites_to_Install_Solar__c != null){
        numberOfSites= newlead.Number_of_Sites_to_Install_Solar__c;
        if(numberOfSites == '< 25'){
          score += 0;
        } else if(numberOfSites == '25 - 50'){ 
          score++;
        } else if(numberOfSites == '51 - 75'){
          score += 2;
        } else if(numberOfSites == '> 75'){
          score += 3;
        }
      }
      if(score > 9){
        grade = 'A';
        newlead.LeadScore__c = score ;
        newlead.Rating = grade;
      } else if(score >= 6){
        grade = 'B';
        newlead.LeadScore__c = score ;
        newlead.Rating = grade;
      } else if(score < 6){ 
        grade = 'C';     
        newlead.LeadScore__c = score ;
        newlead.Rating = grade;
      }  
    }//new homes end
    
    else if(mapRecordTypeIDName.get(newlead.recordTypeID) == 'Partner'){ 
      if(newlead.Theater__c != null && newlead.Theater__c == EU){
        
        if(newlead.Country == null){
          score = 0; 
        } else{
            
          country = newlead.Country ;
          if(country == 'Spain'){
            if(newlead.Does_Company_Install_PV_Distribute__c != null){
              installDistributePV = newlead.Does_Company_Install_PV_Distribute__c;
              if(installDistributePV == 'Distribute'){
                score = 0;
              } else if(installDistributePV == 'Both'){
                score = 2;
              } else if(installDistributePV == 'Install'){
                score = 3;
              }
            }
            if(newlead.Registry_Presence__c != null){
              registryPresence = newlead.Registry_Presence__c;
              if(registryPresence == 'No Presence'){
                score += 0;
              } else if(registryPresence == '3rd and 4th'){
                score++;
              } else if(registryPresence == '1st and 2nd'){
                score += 3;
              }
            }
            if(newlead.Immediate_Interest_in_Pricing__c != null){
              immediateInterest = newlead.Immediate_Interest_in_Pricing__c;
              if(immediateInterest == true){
                score += 0;
              } else if(immediateInterest == false){
                score += 3;
              }
            }            
            if(score > 5){
              grade = 'A';
              //newlead.LeadScore__c = score ;
              //newlead.Rating = grade;
            } else if(score >= 3){
              grade = 'B';
              //newlead.LeadScore__c = score ;
              //newlead.Rating = grade;
            } else if(score < 3){ 
              grade = 'C';
              //newlead.LeadScore__c = score ;
              //newlead.Rating = grade;
            }
            newlead.LeadScore__c = score ;
            newlead.Rating = grade;
          } else if(country == 'France') //Start 00116924
          {      
           System.debug('==========France');
            LeadRatingManagement.setFrance(newlead, mapRecordTypeIDName);
          }//End 00116924
          
          /* else if(country == 'France'){
            if(newlead.Does_Company_Install_PV_Distribute__c != null){
              installDistributePV = newlead.Does_Company_Install_PV_Distribute__c;
              if(installDistributePV == 'Distribute'){
                score = 0;
              } else if(installDistributePV == 'Both'){
                score = 2;
              } else if(installDistributePV == 'Install'){
                score = 3;
              }
            }
            if(newlead.Total_Experience_in_Solar_Business__c != null){
              experienceInYears = newlead.Total_Experience_in_Solar_Business__c;
              if(experienceInYears == '< 1 year'){
                score += 0;
              } else if(experienceInYears != 'New to Solar Business'){
                score += 3;
              }
            }
            if(newlead.Has_Engineering_and_Sales_Resources__c != null){
              engineeringResource = newlead.Has_Engineering_and_Sales_Resources__c;
              if(engineeringResource == true){
                score += 3;
              } else if(engineeringResource == false){
                score += 0;
              }
            }
            if(newlead.Size_of_Projects__c != null){
              sizeOfProjects = newlead.Size_of_Projects__c;
              if(sizeOfProjects == '< 20 KW' || sizeOfProjects == '> 20 KW'){
                score++;
              } else if(sizeOfProjects == '> 250 KW'){
                score += 3;
              }              
            }
            if(newlead.Immediate_Interest_in_Pricing__c != null){
              immediateInterest = newlead.Immediate_Interest_in_Pricing__c;
              if(immediateInterest == true){
                score += 0;
              } else if(immediateInterest == false){
                score += 3;
              }
            }            
            if(score > 12){
              grade = 'A';              
            } else if(score >= 9){
              grade = 'B';
            } else if(score < 9){ 
              grade = 'C';
            }
            newlead.LeadScore__c = score ;
            newlead.Rating = grade;
          } */ 
          //Start 00100808 - new code added
          
          else if(country == 'Germany'){            
             newlead.Rating = 'C';
             if(newlead.Focused_on_Ground_Mounted_Systems__c != null && newlead.Does_Company_Install_PV_Distribute__c != null && newlead.With_a_master_electrician__c != null 
                && newlead.Has_Engineering_and_Sales_Resources__c != null && newlead.Total_Experience_in_Solar_Business__c != null){
              experienceInYears = newlead.Total_Experience_in_Solar_Business__c;
              if(newlead.Does_Company_Install_PV_Distribute__c == 'Install' && newlead.With_a_master_electrician__c == true 
                && newlead.Has_Engineering_and_Sales_Resources__c == true && newlead.Focused_on_Ground_Mounted_Systems__c == false && 
                (experienceInYears == '1 - 2 years' || experienceInYears == '2 - 3 years' || experienceInYears == '3 - 4 years' || experienceInYears == '4 - 5 years' || experienceInYears == '5+ years')){
                newlead.Rating = 'A';
              }
             }
            if(newlead.Focused_on_Ground_Mounted_Systems__c != null && newlead.Does_Company_Install_PV_Distribute__c != null && newlead.With_a_master_electrician__c != null 
                && newlead.Has_Engineering_and_Sales_Resources__c != null && newlead.Total_Experience_in_Solar_Business__c != null){
                    experienceInYears = newlead.Total_Experience_in_Solar_Business__c;
                    if(newlead.With_a_master_electrician__c == true 
                    && newlead.Has_Engineering_and_Sales_Resources__c == false && 
                    (newlead.Does_Company_Install_PV_Distribute__c == 'Install' || newlead.Does_Company_Install_PV_Distribute__c == 'Both') 
                    && newlead.Focused_on_Ground_Mounted_Systems__c == false && 
                    (experienceInYears == '1 - 2 years' || experienceInYears == '2 - 3 years' || experienceInYears == '3 - 4 years' || experienceInYears == '4 - 5 years' || experienceInYears == '5+ years')){
                    newlead.Rating = 'B';
                  }
                }
                
             if(newlead.Focused_on_Ground_Mounted_Systems__c != null && newlead.Immediate_Interest_in_Pricing__c  != null 
                && newlead.Has_Engineering_and_Sales_Resources__c != null && newlead.Total_Experience_in_Solar_Business__c != null){
                    experienceInYears = newlead.Total_Experience_in_Solar_Business__c;
                    if(newlead.Focused_on_Ground_Mounted_Systems__c == true && newlead.Immediate_Interest_in_Pricing__c  == true 
                    && (experienceInYears == '< 1 year')){
                    newlead.Rating = 'C';
                  }
                }                            
          }
          //End 00100808
          else if(country == 'Italy'){      
            LeadRatingManagement.setItalyRating(newlead,mapRecordTypeIDName);
          }
          //Start case 00098837
          else if(newlead.Country == 'Belgium'){            
            System.debug('----------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+newlead.Country);  
            if(newlead.Total_Experience_in_Solar_Business__c != null ){
              experienceInYears = newlead.Total_Experience_in_Solar_Business__c;                          
                if(newlead.Installations_Realized_Previous_Year__c != null && newlead.Installations_Realized_Previous_Year__c >=10){                    
                    if(newlead.Has_Engineering_and_Sales_Resources__c==true){ 
                        if(experienceInYears == '1 - 2 years'||experienceInYears == '2 - 3 years'||experienceInYears == '3 - 4 years'||experienceInYears == '4 - 5 years'||experienceInYears == '5+ years'){
                             newlead.Rating = 'A';                             
                        }
                    }                   
                    else if(experienceInYears == '1 - 2 years'||experienceInYears == '2 - 3 years'||experienceInYears == '3 - 4 years'||experienceInYears == '4 - 5 years'||experienceInYears == '5+ years'){                
                         newlead.Rating = 'B';                         
                    }                   
                }
                //Removed else/status update for case 00100871 
                if(newlead.Does_Company_Install_PV_Distribute__c != null && newlead.NumberOfEmployees != null){             
                    if(newlead.NumberOfEmployees <4 && newlead.Website==null && newlead.Does_Company_Install_PV_Distribute__c == 'Distribute' && experienceInYears == '< 1 year'){  
                          newlead.Rating = 'C';                                    
                    }
                }
            }
                         
        }//End case 00098837
        //Start 00117536
        else if(newlead.Country == 'United Kingdom'){  
               LeadRatingManagement.setUKRating(newlead, mapRecordTypeIDName);   
            
        }
        
        //End 00117536
          else{
            if(newlead.Does_Company_Install_PV_Distribute__c != null){
              installDistributePV = newlead.Does_Company_Install_PV_Distribute__c;
              if(installDistributePV == 'Distribute'){
                score = 3;
              }
              else if(installDistributePV == 'Both'){
                score = 2;
              }
              else if(installDistributePV == 'Install'){
                score = 1;
              }
            }
            else{
              score = 0;
            }
            if(newlead.State != null){
              state = newlead.State;
              if(state == 'Portugal' || state == 'Greece' || state == 'Czech Republic' || state == 'Belgium' || state == 'Switzerland' || state == 'Slovenia' || state == 'Bulgaria' || state == 'Austria' || state == 'Middle East' || state == 'South Africa' || state == 'UAE'){
                score += 3;
              }
              else if(state == 'Russia' || state == 'Africa' || state == 'South America' || state == 'Turkey'){
                score += 2;
              }
              else{
                score++;
              }
            }
            if(newlead.Total_Experience_in_Solar_Business__c != null){
              experienceInYears = newlead.Total_Experience_in_Solar_Business__c;
              if(experienceInYears == 'New to Solar Business'){
                score += 0;
              }
              if(experienceInYears == '< 1 year'){
                score++;
              }              
              else if(experienceInYears == '1 - 2 years'  || experienceInYears == '> 1 year'){
                score += 3;
              }
            }
            if(newlead.Anticipated_Demand__c != null){
              anticipatedDemand = newlead.Anticipated_Demand__c;
              if(anticipatedDemand == 'Average'){
                score += 2;
              }
              else if(anticipatedDemand == 'Full Containers'){
                score += 3;
              }
              else if(anticipatedDemand == 'Very Low'){
                score += 0;
              }
            }
            if(newlead.Immediate_Interest_in_Pricing__c != null){
              immediateInterest = newlead.Immediate_Interest_in_Pricing__c;
              if(immediateInterest == true){
                score += 0;
              }
              else if(immediateInterest == false){
                score += 3;
              }
            }
            if(score > 12){
              grade = 'A';
            }
            else if(score >= 8){
              grade = 'B';
            }
            else if(score < 8){ 
              grade = 'C';
            }
            newlead.LeadScore__c = score ;
            newlead.Rating = grade;
          }          
        }
      }       
    }
}
   
}