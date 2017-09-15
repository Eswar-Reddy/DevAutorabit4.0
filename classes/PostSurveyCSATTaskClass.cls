/** Called by PostSurveyCSATClass
    Date :: Mar 10, 2011
    Case :: 00049072
    Case Owner :: (Appirio) Anuradha
**/

public with sharing class PostSurveyCSATTaskClass {
    public static void createPostCsatTask(Set<Id> opportunityIds) {
        List<Opportunity> oppList = new List<Opportunity>();
        Map<String,List<Date>> dateMap = new Map<String,List<Date>>();
        Map<Id,List<Customer_Survey_Result__c>> csrMap = new Map<Id,List<Customer_Survey_Result__c>>();
        Map<Id,Decimal> CSATscoreMap = new Map<Id,Decimal>();
        Map<Id,Integer> CSATsurveyMap = new Map<Id,Integer>();
        Task[] newTask = new Task[0];
        Map<String,Id> theaUsrMap = new Map<String,Id>();
    
        Set<Id> accountIdsSet = new Set<Id>();
        List<Opportunity> requiredOpportunities = new List<Opportunity>([select Id,Theater__c,PartnerAccountId,PartnerAccount.IsPremierCandidate__c,partnerAccount.type,account.BillingCountry,Account.Id,Primary_Contact__r.Account.OwnerId,primary_contact__r.phone,primary_contact__r.Email,Primary_Contact__r.Account.Id,Primary_Contact__r.Id,Customer_Satisfaction_survey_opt_in__c,primary_contact__r.account.type,Account.Contact_Language__c from Opportunity where Id IN :opportunityIds]);
        for(Opportunity opp : requiredOpportunities) {          
            if(opp.Theater__c == 'Central America and the Caribbean' || opp.Theater__c == 'North America' ) {                        
                if(opp.partnerAccount!= null && (opp.partnerAccount.Type.contains('Elite') || opp.partnerAccount.Type.contains('Authorized') ||  opp.partnerAccount.Type.contains('Premier')) ) {
                    accountIdsSet.add(opp.partnerAccountId);
                }        
            }             
            else if(opp.Theater__c == 'Europe'){
              //Case 00100108 - Updated type condition
              if(opp.partnerAccount!= null && (opp.partnerAccount.Type.contains('Residential Installer') || opp.partnerAccount.Type.contains('Authorized') ||  opp.partnerAccount.Type.contains('Premier')) ) {
                accountIdsSet.add(opp.partnerAccountId);
              }
            }
        }
    
    /*=============================CSR Supervisor======================================*/
    for(User usr : [select Id,Name from User where (Name = 'Julia Waszczuk' OR Name = 'Maria Luisa Cuenca-Abril') AND isActive = true])//For Case# 00168070, 'Sylwia Buczynska' is changed to 'Julia Waszczuk'.
    {
        if(usr.Name == 'Julia Waszczuk')//For Case# 00168070, 'Sylwia Buczynska' is changed to 'Julia Waszczuk'.
        {
            theaUsrMap.put('Europe', usr.Id);
        }
        else if(usr.Name == 'Maria Luisa Cuenca-Abril')
        {
            theaUsrMap.put('North America', usr.Id);
            theaUsrMap.put('Central America and the Caribbean', usr.Id);
        }
    }
    /*===========Fill Map of Customer Survey Result according to accountIdsSet=====*/
        if(accountIdsSet!= null && accountIdsSet.size() > 0) {
            for(Customer_Survey_Result__c csrObj : [Select Survey_response_date__c,Aggregate_Score_New__c,partner_account__r.Id,partner_account__r.Theater__c from Customer_Survey_Result__c where partner_account__r.Id IN :accountIdsSet AND Survey_Response_Date__c != NULL]) {
                system.debug('=======2========');
                if( !csrMap.containsKey(csrObj.partner_account__c) ) {   
                system.debug('=======2.1========');
                    List<Customer_Survey_Result__c> csrList = new List<Customer_Survey_Result__c>();
                    csrList.add(csrObj);
                    csrMap.put(csrObj.partner_account__c,csrList);
                } else {
                    csrMap.get(csrObj.partner_account__c).add(csrObj);
                }
            }
        }
        
    /*=============================================================================*/    
    /*====================Fetch Dates from performance metrics for particular theater=====*/    
        for(Performance_Metric__c pm : [select Thea__c,Performance_Period_Start_Date__c,Performance_Period_End_Date__c from Performance_Metric__c where Performance_Period_Start_Date__c <= TODAY AND Performance_Period_End_Date__c >= TODAY]){
            system.debug('=======3========');
            if(!dateMap.containsKey(pm.Thea__c)) {
                List<Date> datesList = new List<Date>();
                String country = pm.Thea__c ;
                datesList.add(pm.Performance_Period_Start_Date__c);
                datesList.add(pm.Performance_Period_End_Date__c);
                dateMap.put(country,datesList);
            }
        }
    /*==============================================================================*/    
    /*==================== CSAT score for a particular account======================*/
        if(accountIdsSet!= null && accountIdsSet.size() > 0) {
        system.debug('=======4.1========'+accountIdsSet.size());
            for(Id pid : accountIdsSet) {
            system.debug('=======4.2========'+pid);
                //if(csrMap.size() > 0) {
                if(csrMap!= null && csrMap.size() > 0 && csrMap.containsKey(pid)) {
                    for(Customer_Survey_Result__c cs : csrMap.get(pid)) {
                    system.debug('=======4.3========'+cs.Survey_Response_Date__c);
                    system.debug('=======4.4========'+cs.Id);
                    
                        //if(cs.Survey_Response_Date__c >= dateMap.get(cs.partner_account__r.Theater__c)[0] && cs.Survey_Response_Date__c <= dateMap.get(cs.partner_account__r.Theater__c)[1]) {
                        if(dateMap != null && dateMap.get(cs.partner_account__r.Theater__c) != null && dateMap.get(cs.partner_account__r.Theater__c).size() > 1  && cs.Survey_Response_Date__c >= dateMap.get(cs.partner_account__r.Theater__c)[0] && cs.Survey_Response_Date__c <= dateMap.get(cs.partner_account__r.Theater__c)[1]) {
                            system.debug('=======4========');
                            if(!CSATsurveyMap.containsKey(pid)) {
                                CSATsurveyMap.put(pid,1);
                            } else {
                                Integer csat_response = CSATsurveyMap.get(pid) ;
                                csat_response += 1;
                                CSATsurveyMap.put(pid,csat_response);
                            }
                            if(!CSATscoreMap.containsKey(pid)) {
                                CSATscoreMap.put(pid,cs.Aggregate_Score_New__c);
                            } else {
                            system.debug('=======5 Aggregate Score========');
                                Decimal csat_score = CSATscoreMap.get(pid) ;
                                csat_score += cs.Aggregate_Score_New__c;
                                CSATscoreMap.put(pid,csat_score);
                            }
                        }
                    }
                }
                if(csrMap.size() == 0 || (CSATscoreMap.size() == 0 && CSATscoreMap.size() == 0)) {
                    CSATsurveyMap.put(pid,0);
                    CSATscoreMap.put(pid,0.0);                
                }           
            }
        }
    /*=========================================================================*/
   //Start 96974                   
   Schema.DescribeSObjectResult drt = Schema.SObjectType.Task;
   Map<String,Schema.RecordTypeInfo> rtMapByName = drt.getRecordTypeInfosByName();
   Schema.RecordTypeInfo rtByName =  rtMapByName.get('Call Task');
   //End 96974 
                   
    for(Opportunity opp : requiredOpportunities) {
       boolean isPhoneRight = false ;
       boolean doesConditionSatisfy = false ;
       boolean responseReceived = false ;
       system.debug('=======6.1========'+isPhoneRight);
       if(opp.Primary_Contact__r.Phone == '' || opp.Primary_Contact__r.Phone == null) {
       
       } else if(accountIdsSet.contains(opp.partnerAccountId)) {
           String regexPhone1 = '^(\\+[0-9]{2}|^\\+[0-9]{2}\\(0\\)|^\\(\\+[0-9]{2}\\)\\(0\\)|^00[0-9]{2}|^0)([0-9]{9}$|[0-9\\-\\s]{10})$';
           String regexPhone2 = '[^a-zA-Z]+' ;
           if(Pattern.matches(regexPhone1 ,opp.Primary_Contact__r.Phone) || Pattern.matches(regexPhone2 ,opp.Primary_Contact__r.Phone)) {
               isPhoneRight = true ;
               system.debug('=======6========'+isPhoneRight);
           }
       }
       
       if( isPhoneRight == true ) {
           system.debug('======7.1======'+CSATsurveyMap + opp.Theater__c);
           system.debug('======7.2======'+CSATscoreMap);
           system.debug('======7.3======'+CSATsurveyMap.get(opp.PartnerAccountId));       
           system.debug('======7.4======'+CSATscoreMap.get(opp.PartnerAccountId));
           if(opp.Theater__c == 'Europe') {
               if(CSATsurveyMap.get(opp.PartnerAccountId) < 5 || CSATscoreMap.get(opp.PartnerAccountId) < 75.0) {
                  system.debug('=======7========');
                  doesConditionSatisfy = true;
               }
           } else if(opp.Theater__c == 'Central America and the Caribbean' || opp.Theater__c == 'North America') {
               // Done for case # 00064610 (Removed the criteria check for NA)
               //if(CSATsurveyMap.get(opp.partnerAccountId) < 5 || CSATscoreMap.get(opp.partnerAccountId) < 70.0) {
                  system.debug('=======8========');
                  doesConditionSatisfy = true;
               //}
           }
           if(doesConditionSatisfy == true){
           system.debug('========9.1========'+theaUsrMap.get(opp.Theater__c)+'===='+doesConditionSatisfy);
               if(theaUsrMap.get(opp.Theater__c) != null){
                   String country = '' ;
                   String partner_accountId = '' ;
                   String ivString = '' ;
                   system.debug('=======9========');
                   //Start 96974                   
                   /*Schema.DescribeSObjectResult drt = Schema.SObjectType.Task;
           Map<String,Schema.RecordTypeInfo> rtMapByName = drt.getRecordTypeInfosByName();
           Schema.RecordTypeInfo rtByName =  rtMapByName.get('Call Task');*/
           //End 96974   
                   if(opp.account.BillingCountry == null || opp.account.BillingCountry == '') {
                       country = opp.Theater__c ;
                   } else {
                       country = opp.account.BillingCountry ;
                   }
                   //Added contact language condition for case 00100108
                   if(opp.Theater__c == 'Europe') {
                       partner_accountId = opp.PartnerAccountId ;
                       if(opp.Account.BillingCountry == 'Germany'){
                           ivString='3b126e4fcce6cd8';
                       } else if(opp.Account.BillingCountry == 'France' || (opp.Account.BillingCountry == 'Belgium' && opp.Account.Contact_language__c=='French')) {
                           ivString='3912cacaaaa6966';
                       } else if(opp.Account.BillingCountry == 'Italy') {
                           ivString='391274485de6bf7';
                       } else if(opp.Account.BillingCountry == 'Belgium' && opp.Account.Contact_language__c=='Dutch'){
                           ivString='18c6ue0oxtvoj8';
                       }                       
                   } else if(opp.Theater__c == 'Central America and the Caribbean' || opp.Theater__c == 'North America') {
                       partner_accountId = opp.PartnerAccountId ;
                       ivString='391247db12873d2';                       
                   }
                   newTask.add(new Task(
                       RecordTypeId = rtByName.getRecordTypeId(),
                       Status = 'Not Started',
                       Subject = 'CSAT by Phone ' +country,
                       WhoId = opp.Primary_Contact__c,
                       WhatId = opp.Id,
                       Description = 'http://survey.sunpowercorp.com/go?iv='+ivString+'&q1='+Opp.Account.Id+'&q2='+Opp.Primary_Contact__r.Id+'&q3='+partner_accountId+'&q4='+Opp.Id,
                       ActivityDate = system.today()+7,
                       OwnerId = theaUsrMap.get(opp.Theater__c) 
                       //OwnerId = opp.Primary_Contact__r.Account.OwnerId 
                       ));
                    }
                }
            }
        }
        if(newTask.size() > 0) {
            system.debug('=======10========');
            insert newTask ;
        }
    }
}