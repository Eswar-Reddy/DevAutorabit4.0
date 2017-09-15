/*.......................................................................
Name:: OpportunityAssignmentEngine2
Author:: Appirio (Prakash)
Date:: Aug 27, 2009
Requester :: Richard Wu, PR-02420
Purpose:: Newly Class for Opportunity Assignment Engine 2
..........................................................................*/
public class OpportunityAssignmentEngine2 {
    /* Added for Sunpower Case # 00030248 */
    private static final String DEFAULT_PROJECT_STAGE;
    
    static {
        List<Schema.Picklistentry> projectStages = Opportunity.Project_Stage__c.getDescribe()
                .getPicklistValues();
        
        for (Schema.Picklistentry picklistentry : projectStages) {
            if (picklistentry.isActive() == true && picklistentry.isDefaultValue() == true) {
                DEFAULT_PROJECT_STAGE = picklistentry.getValue();
                break;
            }
        }
        
        if (DEFAULT_PROJECT_STAGE == null) {
            DEFAULT_PROJECT_STAGE = '';
        }
    }
    /**************************************/
    
    private static String staticDefaultHomeOwnerStage =null;
    private static String staticDefaultCommercialStage =null;
    public static void setFieldsOnLeadConvert(List<Lead> leadLists){
        List<Account> acctRecords = new List<Account>();
        List<Opportunity> oppRecords = new List<Opportunity>();
        List<Contact> conRecords = new List<Contact>();
        Map<String,ID> accountRecordTypes = new Map<String,ID>(); 
        Map<String,ID> opportunityRecordTypes = new Map<String,ID>();
        Map <String,ID> contactRecordTypes = new Map<String,ID>(); 
        Map <String,String> leadRecordTypes = new Map<String,String>();
        //FETCH RECORDTYPES             
        Set<String> objTypes = new Set<String>();
        objTypes.add('Account');
        objTypes.add('Opportunity');
        objTypes.add('Contact');
        //Following is done for case-00040774 to reduce the queries  
        //Account record type
        Schema.DescribeSObjectResult da = Schema.SObjectType.Account;
        Map<Id,Schema.RecordTypeInfo> acctMapById = da.getRecordTypeInfosById();
        for(ID i:acctMapById.keySet()){
            accountRecordTypes.put(acctMapById.get(i).name,string.valueOf(i));
        }
        //Contact record type
        Schema.DescribeSObjectResult dc = Schema.SObjectType.Contact;
        Map<Id,Schema.RecordTypeInfo> contMapById = dc.getRecordTypeInfosById();
        for(ID i:contMapById.keySet()){
            contactRecordTypes.put(contMapById.get(i).name,string.valueOf(i));
        }
        //Opportunity record type
        Schema.DescribeSObjectResult dOpp = Schema.SObjectType.Opportunity;
        Map<Id,Schema.RecordTypeInfo> oppMapById = dOpp.getRecordTypeInfosById();
        for(ID i:oppMapById.keySet()){
            opportunityRecordTypes.put(oppMapById.get(i).name,string.valueOf(i));
        }
        //Lead record type
        //Schema.DescribeSObjectResult dLead = Schema.SObjectType.Lead;
        //Map<Id,Schema.RecordTypeInfo> leadMapById = dLead.getRecordTypeInfosById();
        Map<Id,Schema.RecordTypeInfo> leadMapById = LeadManagement.idToLeadRecordTypeInfoMap;
        for(ID i:leadMapById.keySet()){
            leadRecordTypes.put(i,leadMapById.get(i).name);
        }
        /*for(RecordType rec: [select Id,Name,sObjecttype from RecordType where sObjecttype in :objTypes]){
            if(rec.sObjecttype == 'Account')
                accountRecordTypes.put(rec.Name,rec.ID);
            else if(rec.sObjecttype=='Opportunity')     
                opportunityRecordTypes.put(rec.Name,rec.ID);
            else
                contactRecordTypes.put(rec.Name,rec.ID);
        }*/
        
        /* Added for Sunpower Case # 00027221 */
        Date todayDate = Date.today();
        /**************************************/
        //NOW LOOP FOR EACH LEAD AND MODIFY VALUES
        Set<ID> accIDs = new Set<ID>();
        Set<ID> oppIDs = new Set<ID>();
        for(Lead lead : leadLists){
            if(lead.IsConverted ){
                accIDs.Add(lead.ConvertedAccountID);
                oppIDs.add(lead.convertedopportunityID);
            }        
        }   
        
        Map<ID , Account> accounts = new Map<ID,Account>();
        if(accIDs.size() > 0){
            // Done for Case # 00076878 [removing the lead conversion validation implemented on case 00074237]
            // Done for Case # 00074237 [adding lead conversion validation error messages]
            accounts  =  new Map<ID,Account>([Select id ,IsPersonAccount from Account where id in : accIDs]); 
            //accounts  =  new Map<ID,Account>([Select id ,IsPersonAccount,Lead_Approval__c,HD_Lead_Status__c from Account where id in : accIDs]);
        }
        
        //Added for Case#00061072  
        Map<ID , Opportunity> opportunities = new Map<ID,Opportunity>();
        if(oppIDs.size() > 0){
            //Start 00108073
            //opportunities  =  new Map<ID,Opportunity>([Select id ,RecordTypeId, Facility_Address1__c from Opportunity where id in : oppIDs]);
            opportunities  =  new Map<ID,Opportunity>([Select id ,RecordTypeId, Facility_Address1__c, Facility_State1__c, Facility_City1__c  from Opportunity where id in : oppIDs]);
            //End 00108073 
        }        
        
       
        for(Lead lead : leadLists){
            if(lead.IsConverted ){
                Account acct = accounts.get(lead.ConvertedAccountID);//new Account(id =lead.ConvertedAccountID);
                
                system.debug('---+++'+acct.id);                
                //System.debug('debug Oppassignemnt->'+lead.ownerId);
                //System.debug('debug Oppassignemnt->'+[select owner.Name from Opportunity where Id=:lead.convertedopportunityID]);
                Opportunity opp = new Opportunity (id =lead.convertedopportunityID);
                Contact con = new Contact(id=lead.convertedContactID);
                
                // Done for Case # 00076878 [removing the lead conversion validation implemented on case 00074237]
                // Done for Case # 00074237 [adding lead conversion validation error messages]
                /* if(lead.RLC_Type__c == 'EU Commercial'){
                    system.debug('_________________'+lead.RLC_Type__c);
                    if(acct.Lead_Approval__c == 'False' || acct.Lead_Approval__c == null){
                        lead.addError('You are required approval before conversion from your Sales Manager');
                        continue; 
                    }
                    if(acct.HD_Lead_Status__c != 'Qualified'){
                        lead.addError('Lead must be set to qualified to convert');
                        continue; 
                    }
                }
                // End Case # 00074237.*/
                // End Case # 00076878.
                
                //Following is done for the case-00038301
                if(lead.description!=null && lead.description!=''){
                    acct.description = lead.description;
                    opp.description = lead.description;                     
                }
                // following is done for the case - 00037278
                if (lead.Lead_Qualification_Notes__c !=null && lead.Lead_Qualification_Notes__c!=''){                    
                    opp.Lead_Qualification_Notes__c = lead.Lead_Qualification_Notes__c;
                }
                //Following is done for case-00040774 to reduce the queries                
                if(lead.Referral_Program_Status__c!=null){
                    acct.Referral_Program_Status__c = lead.Referral_Program_Status__c;
                    opp.Referral_Program_Status__c = lead.Referral_Program_Status__c;                   
                    con.Referral_Program_Status__c = lead.Referral_Program_Status__c;                   
                }
                //Following is done for case-00046612 to map the value with account field
                if(lead.Transmission_Capacity__c!=null){
                    acct.Transmission_Capacity__c = lead.Transmission_Capacity__c;
                }
                //Case-00038175
                if(lead.business_unit__c=='NA Commercial' || lead.business_unit__c=='UPP Americas'){
                    opp.closeDate = Date.Today().addDays(270);
                }
                //Start 00104897
                //00119705 - Added null check
                else if(lead.business_unit__c=='RLC' && opportunities != null && opportunities.get(opp.Id) != null && opportunities.get(opp.Id).RecordTypeId == OpportunityManagement2.COMMERCIAL_RecordType_ID && lead.Theater__c == 'North America'){
                    opp.closeDate = Date.Today().addDays(635);
                }
                //End 00104897
                //Case-00045356
                if(lead.Primary_Contact__c){
                    opp.Primary_Contact__c = lead.convertedContactID;                   
                }
                //Start 00105750 - Moved code from class LeadConversion to reduce SOQL
                if(lead.Business_Unit__c =='UPP Intl' && Util.currentUser!=null && !Util.currentUser.Web_User__c && opportunityRecordTypes.get('Components')!=null){
                    opp.recordtypeID = opportunityRecordTypes.get('Components');
                }
                //End 00105750
                //Following is done to remove the Lead_Type__c field from Lead-Case#00044431
                opp.Lead_Type__c = leadRecordTypes.get(lead.recordTypeID);
                //Case-00049328
                con.Contact_Language__c = lead.Contact_Language__c;
                acct.Contact_Language__c = lead.Contact_Language__c;
                // Added for Case 00059536
                
                if(leadRecordTypes.get(lead.recordTypeID) == 'New Homes'){
                    //Case# 00153025--Requested By Raul - Added by Paritosh-BIRLASOFT
                    if (lead.Business_Unit__c == 'UPP Intl'){
                        if(accountRecordTypes.get('Standard') != null)
                            acct.RecordTypeId = accountRecordTypes.get('Standard');
                    //Case# 00153025--Requested By Raul - Added by Paritosh-BIRLASOFT        
                    // Done for case # 00066557 consolidating business units IBD and Components into 'UPP Intl'.        
                    // else if((lead.Business_Unit__c == 'RLC' && lead.RLC_Type__c=='New Homes') || lead.Business_Unit__c == 'Components' || lead.Business_Unit__c == 'IBD')
                    }else 
                     if((lead.Business_Unit__c == 'RLC' && lead.RLC_Type__c=='New Homes') || lead.Business_Unit__c == 'UPP Intl'){
                        if(accountRecordTypes.get('Residential Customer') != null && ! acct.IsPersonAccount)
                            acct.RecordTypeId = accountRecordTypes.get('Residential Customer');
                            
                    }else if(lead.Business_Unit__c == 'NA Commercial' || lead.Business_Unit__c == 'UPP Americas'){
                        if(accountRecordTypes.get('Standard') != null && ! acct.IsPersonAccount)
                            acct.RecordTypeId = accountRecordTypes.get('Standard');
                    }
                    
                        //acct.type = 'Commercial';
                }
                
                if(leadRecordTypes.get(lead.recordTypeID) == 'Systems'){
                    //Case# 00153025--Requested By Raul - Added by Paritosh-BIRLASOFT
                    if (lead.Business_Unit__c == 'UPP Americas' || lead.Business_Unit__c == 'UPP Intl'){
                        if(accountRecordTypes.get('Standard') != null)
                            acct.RecordTypeId = accountRecordTypes.get('Standard');
                    //Case# 00153025--Requested By Raul - Added by Paritosh-BIRLASOFT        
                    }else 
                     if(lead.Business_Unit__c == 'RLC' && lead.RLC_Type__c=='Light Commercial'){
                        if(accountRecordTypes.get('Commercial Customer') != null)
                            acct.RecordTypeId = accountRecordTypes.get('Commercial Customer');
                    
                    // Done for case # 00066557 consolidating business units IBD and Components into 'UPP Intl'.        
                    // else if(lead.Business_Unit__c == 'NA Commercial' || lead.Business_Unit__c == 'Components' || lead.Business_Unit__c == 'IBD')
                    }else if(lead.Business_Unit__c == 'NA Commercial' || lead.Business_Unit__c == 'UPP Intl'){
                        if(accountRecordTypes.get('Standard') != null && ! acct.IsPersonAccount)
                            acct.RecordTypeId = accountRecordTypes.get('Standard');
                    }
                }
                // End of changes for Case 00059536
                // Changed below if for Case 00049358
                //if(leadRecordTypes.get(lead.recordTypeID) != 'Residential' && leadRecordTypes.get(lead.recordTypeID) != 'Commercial')
                if(leadRecordTypes.get(lead.recordTypeID) != 'Residential'){
                    acctRecords.add(acct);
                    conRecords.add(con);                    
                    
                     if(opp.Id != null){//if user not creating opportunity
                        if(opportunities.get(opp.Id).RecordTypeId == OpportunityManagement2.COMMERCIAL_RecordType_ID){
                            /* Added for Sunpower Case # 00027221 */
                            // Put default value of "Projected Delivery Date" if it is null
                            if (opp.Projected_Delivery_Date__c == null) {
                                
                                Integer monthToAdd;
                                
                                if (lead.Time_Of_Installation__c == '< 1 month') {
                                    monthToAdd = 1;
                                } else if (lead.Time_Of_Installation__c == '< 2 months') {
                                    monthToAdd = 2;
                                } else if (lead.Time_Of_Installation__c == '> 3 months') {
                                    monthToAdd = 3;
                                } else if (lead.Time_Of_Installation__c == '> 5 months') {
                                    monthToAdd = 5;
                                } else if (lead.Time_Of_Installation__c == '> 6 months') {
                                    monthToAdd = 6;
                                } else if (lead.Time_Of_Installation__c == '> 12 months') {
                                    monthToAdd = 12;
                                } else {
                                    monthToAdd = 0;
                                }
                                
                                opp.Projected_Delivery_Date__c = opp.Delivery_Date__c = todayDate.addMonths(monthToAdd);
                                
                            }            
                            
                            //Added for Case#00061072                 
                            setDefaultStageName('Commercial',opp);
                            opp.Facility_Address1__c = lead.Facility_Address__c;
                        }
                        
                        /**************************************/
                        
                        /* Added for Sunpower Case # 00030248 */
                        // Lead conversion process does not set default field values.
                        // So set default values of fields.
                        setDefaultValues(opp);
                        /**************************************/
                        //start for case # 00064321
                        if (opportunities.get(opp.Id).RecordTypeId == OpportunityManagement2.COMMERCIAL_RecordType_ID){
                            if (opp.Facility_Address1__c == null || opp.Facility_Address1__c == ''){
                                lead.addError('Facility Address is required for Commercial Opportunities/Leads.');
                                system.debug('************ Facility Address is required **********'+opp.Facility_Address1__c);
                                continue;
                            }
                            //Start 00108073
                            opp.Facility_State1__c = lead.Facility_State__c;
                            opp.Facility_City1__c = lead.Facility_City__c;
                            system.debug('************ RLC **********'+opp.RLC_Type__c);
                            system.debug('************ Facility Address is required **********'+opp.Facility_City1__c);
                            if (opp.Facility_City1__c == null || opp.Facility_City1__c == ''){
                                    lead.addError('Facility City is required for Commercial Opportunities/Leads.');
                                    system.debug('************ Facility Address is required **********'+opp.Facility_City1__c);
                                    continue;
                            }
                            if (opp.Facility_State1__c == null || opp.Facility_State1__c == ''){
                                lead.addError('Facility State is required for Commercial Opportunities/Leads.');
                                system.debug('************ Facility Address is required **********'+opp.Facility_State1__c);
                                continue;
                            }
                            //End 00108073
                        }//end - if
                        //end for case # 00064321
                        oppRecords.add(opp); 
                        
                     }                      
                 continue;
                }
                if(leadRecordTypes.get(lead.recordTypeID) == 'Residential'){
                    // Added for Case 00059536
                    // Done for case # 00066557 consolidating business units IBD and Components into 'UPP Intl'.
                    // if (lead.Business_Unit__c == 'Components' || lead.Business_Unit__c == 'IBD' || lead.Business_Unit__c == 'NA Commercial'  || lead.Business_Unit__c == 'UPP Americas')
                    if (lead.Business_Unit__c == 'UPP Intl' || lead.Business_Unit__c == 'NA Commercial'  || lead.Business_Unit__c == 'UPP Americas'){
                        if(accountRecordTypes.get('Standard') != null && ! acct.IsPersonAccount)
                            acct.RecordTypeId = accountRecordTypes.get('Standard');
                            
                    }else if(lead.Business_Unit__c == 'RLC' && lead.RLC_Type__c=='Residential'){
                        if(accountRecordTypes.get('Residential Customer') != null && ! acct.IsPersonAccount)
                            acct.RecordTypeId = accountRecordTypes.get('Residential Customer');
                            
                    }else{
                        if(accountRecordTypes.get('Residential Customer') != null && ! acct.IsPersonAccount)
                            acct.RecordTypeId = accountRecordTypes.get('Residential Customer');
                    }
                    
                    if(opportunityRecordTypes.get('Home Owner') != null)
                        opp.RecordTypeID = opportunityRecordTypes.get('Home Owner');
                    opp.Type = leadRecordTypes.get(lead.recordTypeID);
                    setDefaultStageName('Home Owner',opp); 
                    setAccountFacilityValue(lead, acct);
                 }/* Commented below for Case 00049358 */
                 /* else if(leadRecordTypes.get(lead.recordTypeID) == 'Commercial'){
                    if(accountRecordTypes.get('Commercial Customer') != null){
                        acct.RecordTypeId = accountRecordTypes.get('Commercial Customer');
                        acct.type = 'Commercial';
                    }
                    if(opportunityRecordTypes.get('Commercial') != null){
                        opp.RecordTypeID = opportunityRecordTypes.get('Commercial');
                        opp.Company__c = lead.Company;
                    }
                    setDefaultStageName('Commercial',opp);
                    setAccountFacilityValue(lead, acct);
                    opp.Type = leadRecordTypes.get(lead.recordTypeID); 
                 } */
                 if(contactRecordTypes.get('Customer')!=null && ! acct.IsPersonAccount)
                    con.RecordTypeId = contactRecordTypes.get('Customer'); 
                
                 acctRecords.add(acct);
                 conRecords.add(con);
                 //Case#00063703
                 if(opp.Id != null) 
                    oppRecords.add(opp);//for case #00062383
            }else
                continue;
            
        /*    if(acctRecords != null && acctRecords.size()>=200){
                update acctRecords;
                acctRecords.clear();    
            }
            if(conRecords!=null && conRecords.size()>=200){
                update conRecords;
                conRecords.clear();
            }
            if(oppRecords != null && oppRecords.size()>=200){
                update oppRecords;
                oppRecords.clear(); 
            }*/
        }//for loop ends
        //MODIFICATIONS END NOW UPDATE FINALLY
         if(acctRecords != null && acctRecords.size()>0)
                update acctRecords;
                
         system.debug('===========conRecords ====='+ conRecords );
         if(conRecords != null && conRecords.size()>0)
            update conRecords;
         if(oppRecords != null && oppRecords.size()>0){
                update oppRecords;
         }      
        return;                     
    }
    
    /* Added for Sunpower Case # 00030248 */
    private static void setDefaultValues(Opportunity opp) {
        opp.Project_Stage__c = DEFAULT_PROJECT_STAGE;
    }
    /**************************************/
    
    /*
        Name :: setDefaultStageName
        Author:: Appirio (Prakash)
        Purpose :: Helper function for setting stage Value according their record type when lead is going to convert
    */
    private static void setDefaultStageName(String strType,Opportunity opp){
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
   
    
     // Mapping the Facility Fields with account
    private static void setAccountFacilityValue(Lead ld, Account acc)
    {       
           if(ld.Facility_Address__c == null && ld.Facility_Address_2__c == null && ld.facility_City__c == null && ld.Facility_Zip__c == null && ld.Facility_State__c == null)
           {
               return;
           }
           acc.Facility_Address__c = ld.Facility_Address__c; 
           acc.Facility_Address_2__c = ld.Facility_Address_2__c; 
           acc.Facility_City__c = ld.Facility_City__c; 
           acc.Facility_Zip__c = ld.Facility_Zip__c; 
           acc.Facility_State__c =ld.Facility_State__c; 
           return;           
    }
    
    
}