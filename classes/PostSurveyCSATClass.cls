/*   Backup on 11/26/2012,This work was been deployed in production as on 11/26/2012.But there is a issue that Europe Post Installation Surveys were not going out.
        Called by trigger afterOpportunityInsert,afterOpportunityUpdate
        Date :: Mar 10, 2011
        Case :: 00049072
        Case Owner :: (Appirio) Anuradha
        
Changes Made-
Amit Saha- 11-26-2012- New Id condition to send CSAT survey for Europe- Line 151 
Commercial workstream: #120804611 - Create a Customer Survey Record Type for Commercial WW39 - 2016
    added logic to separate residential and commercial survey results       
*/

public without sharing class PostSurveyCSATClass {
    public static final ID HomeOwner_RecordType_ID;
    private static User currentUser;
    Static {
        currentUser = Util.currentUser;
        HomeOwner_RecordType_ID = null;
        /*
        for(RecordType rec :OpportunityManagement2.LIST_OppRecordtypes){
            if(rec.name == 'Home Owner'){
                HomeOwner_RecordType_ID = rec.Id;
                break;
            }
        }*/
        HomeOwner_RecordType_ID=SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Opportunity.SobjectType).get('Home Owner');
    }
    
    //Case#00072371 Start
    /* When an Opportunity is Inserted and updated*/
    public static void afterInsertUpdatePostInstallationCSATSurvey(Map<Id,Opportunity> newOpportunityMap,Map<Id,Opportunity> oldOpportunityMap, Boolean isInsert) {
        
        System.debug('#1.1');
        //if(util.byPassValidation()) return;
        System.debug('#1');
        Map<Id,String> oppTheaterMap = new Map<Id,String>();
        //Start 83101
        Set<Id> accountIds = new Set<Id>();
        //End 83101
        //Start case#00216407        
        List<Post_Visit_Follow_Up_Survey__c> SurveyList = new List<Post_Visit_Follow_Up_Survey__c>();
        Map<Id,Post_Visit_Follow_Up_Survey__c> PostVisitSurveyMap = new Map<Id,Post_Visit_Follow_Up_Survey__c>();
        //End case#00216407
        
        Map<Id,Opportunity> mapOpportunityDetails = new Map<Id,Opportunity>( [select Id,Account.Theater__c ,PartnerAccount.Theater__c,  
                                               Account.BillingCountry,PartnerAccountID,PartnerAccount.BillingCountry,PartnerAccount.RSM__c,Primary_Contact_Email__c, AccountId from Opportunity where Id in :newOpportunityMap.keyset()]);
        System.debug('#2');
        
        for(Opportunity oppObj : mapOpportunityDetails.values()) {
            // Done for Change order "EU Partner Opportunity Management" [replacing EU Partner Account with PartnerAccount]
            //Updated If/ElseIf condition under case 00101678
            if((oppObj.PartnerAccount.Theater__c != null && oppObj.PartnerAccount.Theater__c != '')) {
                oppTheaterMap.put(oppObj.Id,oppObj.PartnerAccount.Theater__c) ;
            }
            else if((oppObj.Account.Theater__c != null && oppObj.Account.Theater__c != '')) {
                oppTheaterMap.put(oppObj.Id,oppObj.Account.Theater__c) ; 
            } 
            //Start 83101            
            if(oppObj.AccountId != null)
                accountIds.add(oppObj.AccountId);
            //End 83101
        }
        //Start 83101
        Map<Id, Account> accountMap = new Map<Id, Account>([select Id, (Select Id, Email from Contacts where Terminated__c = false and Email != null 
            order by createdDate limit 1) from Account where Id in : accountIds]);
        //End 83101
        System.debug('#3');
        afterInsertUpdate1YSatisfactionSurvey(newOpportunityMap,oldOpportunityMap, isInsert,oppTheaterMap,mapOpportunityDetails);
               
        //Done for Case#00063181 (To prevent duplicate survey result for an opportunity)
        //Get map of opportunity with survey result if exist
        Map<ID,Customer_Survey_Result__c> mapOppSurvey = new Map<ID,Customer_Survey_Result__c>();
        for(Customer_Survey_Result__c c:[select id, Opportunity_ID__c from Customer_Survey_Result__c where Opportunity_ID__c in :newOpportunityMap.keySet()]){
            mapOppSurvey.put(c.Opportunity_ID__c,c);
        }
        
        //Start 83101
        //Prepare set of opportunities for which post visit survey already created
        Set<ID> setPostVisitSurvey = new Set<ID>();
        for(Post_Visit_Follow_Up_Survey__c s:[select id,Partner_RSM__c ,Partner_Account__c ,Opportunity_Id__c from Post_Visit_Follow_Up_Survey__c where Opportunity_ID__c in :newOpportunityMap.keySet()]){
            setPostVisitSurvey.add(s.Opportunity_ID__c);
            PostVisitSurveyMap.put(s.id,s); //added for case#00216407
        }              
         for(Opportunity oppObj : mapOpportunityDetails.values())
       {
         for(Post_Visit_Follow_Up_Survey__c su : PostVisitSurveyMap.values())
          {
           if(su.Opportunity_Id__c==oppObj.Id)
            {
            
            su.Partner_Account__c = oppObj.PartnerAccountID;
            su.Partner_RSM__c = oppObj.PartnerAccount.RSM__c;
            System.debug('TestBirlasoft'+su.Partner_Account__c);
            SurveyList.add(su);
            }
          }
       }        
        List<Post_Visit_Follow_Up_Survey__c> listPostVisitSurveryToInsert = new List<Post_Visit_Follow_Up_Survey__c>();
        //End 83101
        List<Customer_Survey_Result__c> csrList = new List<Customer_Survey_Result__c>();
        Set<Id> oppTaskSet = new Set<Id>();
        
        for(Opportunity opp : newOpportunityMap.values()){
             System.debug('#3.1');
            String primaryContactMail = mapOpportunityDetails.get(opp.Id).Primary_Contact_Email__c;
            //Start 83101
            //Create Post Visit Followup Survey record if conditions are met
            String billingCountry = null;
            if(mapOpportunityDetails.get(opp.Id).PartnerAccountID!=null)
                billingCountry = mapOpportunityDetails.get(opp.Id).PartnerAccount.BillingCountry;
            if(!setPostVisitSurvey.contains(opp.ID) 
                && (billingCountry == 'Germany' || billingCountry == 'United States' || billingCountry == 'United States of America' || billingCountry == 'Italy' || billingCountry == 'France')
                && (opp.Lead_Manufacturer__c == 'SunPower' || (opp.Lead_Manufacturer__c == 'Partner' && opp.Alliance_Program_Lead__c))
                && opp.stageName != 'Installation Completed' && opp.RecordTypeId == HomeOwner_RecordType_ID && opp.RLC_Type__c == 'Residential'                 
                //&& (primaryContactMail != null && primaryContactMail != ''
                &&  Date.newinstance(2012, 1, 1).daysBetween(opp.CreatedDate.date()) >= 0
                && (opp.PartnerAccountID != null) 
                ){
                    Id contactId;
                    /*if(opp.Primary_Contact__c != null && primaryContactMail != null)
                        contactId = opp.Primary_Contact__c;*/
                    if(accountMap.get(opp.AccountId) != null && accountMap.get(opp.AccountId).Contacts.size() > 0){
                        contactId = accountMap.get(opp.AccountId).Contacts.get(0).Id;
                    }
                    //Case 00105728 Partner RSM field added
                    Post_Visit_Follow_Up_Survey__c postVSurvey = new Post_Visit_Follow_Up_Survey__c(Status_Survey__c='Invitation Scheduled'
                                                                     , Opportunity_ID__c = opp.ID
                                                                     , Partner_Account__c = opp.PartnerAccountID
                                                                     , Customer_Contact__c = contactId
                                                                     , Customer_Account__c = opp.AccountId
                                                                     , Survey_Channel__c = 'Email'
                                                                     , Name = 'Survey for ' + opp.Name
                                                                     , Opportunity_Creation_Date__c = opp.createdDate
                                                                     , Opportunity_Alliance_Program_Lead__c = opp.Alliance_Program_Lead__c
                                                                     , Partner_RSM__c = mapOpportunityDetails.get(opp.Id).PartnerAccount.RSM__c);
                    listPostVisitSurveryToInsert.add(postVSurvey);
                System.debug('#3.2');       
            }
            //End 83101
            
            //Done for Case#00063181 (To prevent duplicate survey result for an opportunity)
            if(mapOppSurvey.containsKey(opp.ID)){
                continue;
            } 
                System.debug('#3.2.1');         
            /* BackUp-------
            if(opp.Customer_Satisfaction_Survey_opt_in__c == true 
                //&& (isInsert == true || (oldOpportunityMap.get(opp.id).Customer_Satisfaction_Survey_opt_in__c!= opp.Customer_Satisfaction_Survey_opt_in__c && isInsert == false))
                && (primaryContactMail != null || primaryContactMail != '')
                && opp.stageName == 'Installation Completed' && opp.RecordTypeId == HomeOwner_RecordType_ID 
                && ((oppTheaterMap.get(opp.Id) == 'Europe')||(oppTheaterMap.get(opp.Id) == 'Central America and the Caribbean' || oppTheaterMap.get(opp.Id) == 'North America')))

            {
                System.debug('#3.2.2');
                System.debug('#3.2.2.1--' + opp.PartnerAccountId );
                System.debug('#3.2.2.2--' + opp.Id );
                System.debug('#3.2.2.3--' + opp.Primary_Contact__c);
                System.debug('#3.2.2.4--' + opp.AccountId);
                
                Customer_Survey_Result__c CsatSurvey = new Customer_Survey_Result__c();
                // Done for Change order "EU Partner Opportunity Management" [replacing EU Partner Account with PartnerAccount]
                CsatSurvey.Partner_Account__c = opp.PartnerAccountId;
                CsatSurvey.Opportunity_ID__c = opp.Id;
                CsatSurvey.Contact__c = opp.Primary_Contact__c;
                CsatSurvey.Account1__c = opp.AccountId;
                System.debug('#3.2.3'); 
                if(CsatSurvey.Partner_Account__c!=null)//for case #00064666
                    csrList.add(CsatSurvey);
                System.debug('#3.3' + csrList.size());                   
                          
            }
             ----END Backup*/ 
             
            //For Europe -----### ADDED ON 11-26-2012 AMIT SAHA
            
            if(opp.Customer_Satisfaction_Survey_opt_in__c == true 
               //&& (isInsert == true || (oldOpportunityMap.get(opp.id).Customer_Satisfaction_Survey_opt_in__c!= opp.Customer_Satisfaction_Survey_opt_in__c && isInsert == false))
                && (primaryContactMail != null || primaryContactMail != '')
                && opp.stageName == 'Installation Completed' && opp.RecordTypeId == HomeOwner_RecordType_ID 
                && ((oppTheaterMap.get(opp.Id) == 'Europe')) 
                && opp.Installation_Completed_Date__c > Date.Today()-180) /////

            {
                System.debug('#3.2.2');
                System.debug('#3.2.2.1--' + opp.PartnerAccountId );
                System.debug('#3.2.2.2--' + opp.Id );
                System.debug('#3.2.2.3--' + opp.Primary_Contact__c);
                System.debug('#3.2.2.4--' + opp.AccountId);
                
                Customer_Survey_Result__c CsatSurvey = new Customer_Survey_Result__c();
                // Done for Change order "EU Partner Opportunity Management" [replacing EU Partner Account with PartnerAccount]
                CsatSurvey.Partner_Account__c = opp.PartnerAccountId;
                CsatSurvey.Opportunity_ID__c = opp.Id;
                CsatSurvey.Contact__c = opp.Primary_Contact__c;
                CsatSurvey.Account1__c = opp.AccountId;
                System.debug('#3.2.3'); 
                if(CsatSurvey.Partner_Account__c!=null)//for case #00064666
                    csrList.add(CsatSurvey);
                System.debug('#3.3' + csrList.size());                   
                          
            }       
            
            //For Lease 
            else if(opp.Customer_Satisfaction_Survey_opt_in__c == true 
                && opp.Lease__c
                && opp.Lease_Placed_in_Service__c
                //&& (isInsert == true || (oldOpportunityMap.get(opp.id).Customer_Satisfaction_Survey_opt_in__c!= opp.Customer_Satisfaction_Survey_opt_in__c && isInsert == false))
                && (primaryContactMail != null || primaryContactMail != '')
                && opp.stageName == 'Installation Completed' && opp.RecordTypeId == HomeOwner_RecordType_ID 
                && ((oppTheaterMap.get(opp.Id) == 'Central America and the Caribbean' || oppTheaterMap.get(opp.Id) == 'North America'))
                && opp.Installation_Completed_Date__c > Date.Today()-180)

            {
                System.debug('#3.2.2');
                System.debug('#3.2.2.1--' + opp.PartnerAccountId );
                System.debug('#3.2.2.2--' + opp.Id );
                System.debug('#3.2.2.3--' + opp.Primary_Contact__c);
                System.debug('#3.2.2.4--' + opp.AccountId);
                
                Customer_Survey_Result__c CsatSurvey = new Customer_Survey_Result__c();
                // Done for Change order "EU Partner Opportunity Management" [replacing EU Partner Account with PartnerAccount]
                CsatSurvey.Partner_Account__c = opp.PartnerAccountId;
                CsatSurvey.Opportunity_ID__c = opp.Id;
                CsatSurvey.Contact__c = opp.Primary_Contact__c;
                CsatSurvey.Account1__c = opp.AccountId;
                CsatSurvey.Lease__c = True;
                //Added below line to replace the Trigger on Customer Survey Result to populate Primary Contact Email
                CsatSurvey.Primary_Contact_Email__c = opp.Primary_Contact_Email__c;
                System.debug('#3.2.3'); 
                if(CsatSurvey.Partner_Account__c!=null)//for case #00064666
                    csrList.add(CsatSurvey);
                System.debug('#3.3' + csrList.size());                   
                          
            }
            //For Cash 
            else if(opp.Customer_Satisfaction_Survey_opt_in__c == true 
                && opp.Lease__c != true
                && opp.Lease_Placed_in_Service__c != true
                //&& (isInsert == true || (oldOpportunityMap.get(opp.id).Customer_Satisfaction_Survey_opt_in__c!= opp.Customer_Satisfaction_Survey_opt_in__c && isInsert == false))
                && (primaryContactMail != null || primaryContactMail != '')
                && opp.stageName == 'Installation Completed' && opp.RecordTypeId == HomeOwner_RecordType_ID 
                && ((oppTheaterMap.get(opp.Id) == 'Central America and the Caribbean' || oppTheaterMap.get(opp.Id) == 'North America'))
                && opp.Installation_Completed_Date__c > Date.Today()-180)

            {
                System.debug('#10.2.2');
                System.debug('#10.2.2.1--' + opp.PartnerAccountId );
                System.debug('#10.2.2.2--' + opp.Id );
                System.debug('#10.2.2.3--' + opp.Primary_Contact__c);
                System.debug('#10.2.2.4--' + opp.AccountId);
                
                Customer_Survey_Result__c CsatSurvey = new Customer_Survey_Result__c();
                // Done for Change order "EU Partner Opportunity Management" [replacing EU Partner Account with PartnerAccount]
                CsatSurvey.Partner_Account__c = opp.PartnerAccountId;
                CsatSurvey.Opportunity_ID__c = opp.Id;
                CsatSurvey.Contact__c = opp.Primary_Contact__c;
                CsatSurvey.Account1__c = opp.AccountId;
                CsatSurvey.Cash__c = True;
                //Added below line to replace the Trigger on Customer Survey Result to populate Primary Contact Email
                CsatSurvey.Primary_Contact_Email__c = opp.Primary_Contact_Email__c;
                
                System.debug('#3.2.3'); 
                if(CsatSurvey.Partner_Account__c!=null)//for case #00064666
                    csrList.add(CsatSurvey);
                System.debug('#3.3' + csrList.size());                   
                          
            }       
            else if(opp.Customer_Satisfaction_Survey_opt_in__c == true 
                && (isInsert == true || (oldOpportunityMap.get(opp.id).Customer_Satisfaction_Survey_opt_in__c!= opp.Customer_Satisfaction_Survey_opt_in__c && isInsert == false))
                && (primaryContactMail == null || primaryContactMail == '')
                && opp.stageName == 'Installation Completed' && opp.RecordTypeId == HomeOwner_RecordType_ID
                && ((oppTheaterMap.get(opp.Id) == 'Europe')||(oppTheaterMap.get(opp.Id) == 'Central America and the Caribbean' || oppTheaterMap.get(opp.Id) == 'North America'))
                && opp.Installation_Completed_Date__c > Date.Today()-180){
                 system.debug('enter===');
                oppTaskSet.add(opp.Id); 
                System.debug('#3.4');   
            }
        }
        System.debug('#4');
        

        if(csrList.size() > 0) {
            insert csrList ;
        }
        System.debug('#5'+ csrList);
        
        //Start 83101
        //Insert PostVisitSurvey records
        if(listPostVisitSurveryToInsert.size() > 0) {
            insert  listPostVisitSurveryToInsert;
        }
        //End 83101
        //Start Case00216407
        if(SurveyList.size() > 0)
        {
         //update SurveyList;
        }
        //End Case00216407
        if(oppTaskSet.size() > 0) {
            PostSurveyCSATTaskClass.createPostCsatTask(oppTaskSet);
        }        
    }
    
    public static void afterInsertUpdate1YSatisfactionSurvey(Map<Id,Opportunity> newOpportunityMap,Map<Id,Opportunity> oldOpportunityMap, Boolean isInsert,Map<Id,String> oppTheaterMap,Map<Id,Opportunity> mapOpportunityDetails) {
        //Get map of opportunity with survey result if exist
        Map<ID,X1Y_Satisfaction_Survey_Result__c> mapOppSurvey = new Map<ID,X1Y_Satisfaction_Survey_Result__c>();
        for(X1Y_Satisfaction_Survey_Result__c c:[select id, Opportunity__c from X1Y_Satisfaction_Survey_Result__c where Opportunity__c in :newOpportunityMap.keySet()]){
            mapOppSurvey.put(c.Opportunity__c,c);
        }
              
        List<X1Y_Satisfaction_Survey_Result__c> listSurvery = new List<X1Y_Satisfaction_Survey_Result__c>();        
        for(Opportunity opp : newOpportunityMap.values()){
            //To prevent duplicate survey result for an opportunity
            if(mapOppSurvey.containsKey(opp.ID)){
                continue;
            }
             
            String billingCountry = mapOpportunityDetails.get(opp.Id).Account.BillingCountry;
            String primaryContactMail = mapOpportunityDetails.get(opp.Id).Primary_Contact_Email__c;
            Date oneYearDate = null;
           
            if(opp.Installation_Completed_Date__c != null){
                oneYearDate = opp.Installation_Completed_Date__c.addYears(1);
               
            }
            
            
            if(opp.stageName == 'Installation Completed' && opp.RecordTypeId == HomeOwner_RecordType_ID && (primaryContactMail != null && primaryContactMail != '')
              && (billingCountry == 'Germany' || billingCountry == 'United States' || billingCountry == 'Italy' || billingCountry == 'France')            
              && (oneYearDate!=null && oneYearDate > System.Today())
              && opp.Customer_Satisfaction_Survey_opt_in__c == true  && opp.Lease__c
                && opp.Lease_Placed_in_Service__c){
                
                X1Y_Satisfaction_Survey_Result__c survey = new X1Y_Satisfaction_Survey_Result__c();
                // Done for Change order "EU Partner Opportunity Management" [replacing EU Partner Account with PartnerAccount]
                survey.Partner_Account__c = opp.PartnerAccountId;
                survey.Opportunity__c = opp.Id;
                survey.Primary_Contact_Email__c = opp.Primary_Contact_Email__c;
                survey.Theater__c = opp.Theater__c;
                survey.Lease__c = True;
                survey.Contact__c = opp.Primary_Contact__c;
                survey.Customer_Account__c = opp.AccountId;   
                survey.Survey_Reference_Date__c = opp.Installation_Completed_Date__c;
                survey.Status_Survey__c='1st Invitation Scheduled';
                if(survey.Partner_Account__c!=null)          
                    listSurvery.add(survey);        
            }

 else if(opp.stageName == 'Installation Completed' && opp.RecordTypeId == HomeOwner_RecordType_ID && (primaryContactMail != null && primaryContactMail != '') && (billingCountry == 'Germany' || billingCountry == 'United States' || billingCountry == 'Italy' || billingCountry == 'France') && (oneYearDate!=null && oneYearDate > System.Today()) && opp.Customer_Satisfaction_Survey_opt_in__c == true  && opp.Lease__c != true
                && opp.Lease_Placed_in_Service__c != true)
          {
              
                X1Y_Satisfaction_Survey_Result__c survey = new X1Y_Satisfaction_Survey_Result__c();
                // Done for Change order "EU Partner Opportunity Management" [replacing EU Partner Account with PartnerAccount]
                survey.Partner_Account__c = opp.PartnerAccountId;
                survey.Opportunity__c = opp.Id;
                survey.Primary_Contact_Email__c = opp.Primary_Contact_Email__c;
                survey.Theater__c = opp.Theater__c;
                survey.Cash__c = True;
                survey.Contact__c = opp.Primary_Contact__c;
                survey.Customer_Account__c = opp.AccountId;   
                survey.Survey_Reference_Date__c = opp.Installation_Completed_Date__c;
                survey.Status_Survey__c='1st Invitation Scheduled';
                if(survey.Partner_Account__c!=null)          
                    listSurvery.add(survey);        
            }           
        }
        if(listSurvery.size() > 0) {
            insert listSurvery ;
        }
    }
    //Case#00072371 End
    
    public static void afterInsertUpdateCSAT(Map<Id,Customer_Survey_Result__c> newCSRMap,Map<Id,Customer_Survey_Result__c> oldCSRMap, Boolean isInsert) {
        Id resiSurveyRecTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Customer_Survey_Result__c.SobjectType).get('Residential'); //#120804611
        Set<Id> opportunityTaskSet = new Set<Id>();
        if(isInsert){
        } else {            
            for(Customer_Survey_Result__c csr : newCSRMap.values()) {
                if(csr.RecordTypeId != null && csr.RecordTypeId == resiSurveyRecTypeId && //#120804611
                   csr.Survey_Status__c != oldCSRMap.get(csr.Id).Survey_Status__c && 
                   csr.Survey_Status__c == 'No response received') {
                    opportunityTaskSet.add(csr.Opportunity_Id__c);
                }                               
            }
            if(opportunityTaskSet.size() > 0) {
                PostSurveyCSATTaskClass.createPostCsatTask(opportunityTaskSet);
            }
        }
    }
}