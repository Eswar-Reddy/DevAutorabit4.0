/*
Below Methods are Commented For Case#00216417: RMA Re-engineering:Removing all references of RMA related fields. 
However, backup of this class is attached with case.
  1. sendEmailToPSRs
  2. sendCaseRMAStillOpenAlert
  3. sendCaseClosedAlert
  4. checkRmaFieldDependency
  5. checkForTechSupportCases
Modified On 17th Jun 2013.
*/

public class CaseManagement 
{
    /**
    Populates values in fields:
      1. Case_CreatedDate_Text__c
      2. SP_Week__c       
    **/         
    public static Id crmCaseRecTypeId;//for case# 00066693
    //for case # 00045421
    public static Id euInspectionCaseRecTypeId;
    //Start 00108097
    public static Id cscRecordTypeId;
    public static Id tscRecordTypeId;
    public static Map<String, Schema.RecordTypeInfo> nameToCaseRecordTypeInfoMap = Schema.SObjectType.Case.getRecordTypeInfosByName();
    //Start 00108097
    static 
    {
      //Start 00108097
        /*euInspectionCaseRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('New Inspections').getRecordTypeId();   
        crmCaseRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CRM Case').getRecordTypeId();     //for case# 00066693*/
        euInspectionCaseRecTypeId = nameToCaseRecordTypeInfoMap.get('New Inspections').getRecordTypeId();   
        crmCaseRecTypeId = nameToCaseRecordTypeInfoMap.get('CRM Case').getRecordTypeId();
        cscRecordTypeId = nameToCaseRecordTypeInfoMap.get('Customer Service Case').getRecordTypeId();
        tscRecordTypeId = nameToCaseRecordTypeInfoMap.get('Technical Support Case').getRecordTypeId();
        //End 00108097
    }    
    //for case # 00045421 
    private static String emailBody = 'Hi,<br/><br/>A new RMA Case has been assigned to your region.'+ 
                                      '<br/>Please observe the SLA time needed for processing until closing.<br/><br/>'+
                                      'See case description for more information.<br/>CaseLink<br/><br/>Thank you.<br/>'; 
    
    private static Set<String> setRecipientName = new Set<String>{  'Chris White',
                                                                    'Shane Messer',
                                                                    'John osmer',
                                                                    'Mei Juknelis',
                                                                    'Anish Shah',
                                                                    'Mark Schmidt',
                                                                    'Nick Hyner',
                                                                    'Mark Babcock',
                                                                    'Lluis Juncosa',
                                                                    'Ignacio Cuenca',
                                                                    'Jorge Carbonell',
                                                                    'George Collins',
                                                                    'David Monasterio',
                                                                    'Peter Drennan',
                                                                    'Wilf Johnson',
                                                                    'Chris OBRIEN',
                                                                    'Andrew Turner',
                                                                    'Reinhardt Lampe',
                                                                    'Carlos Garcia', 
                                                                    'Andrea Antolini',
                                                                    'Ken Fong',
                                                                    'Oscar Cepas',
                                                                    'Chris Baker'};      
    //Method called after case inserted
    public static void afterCaseInsert(List<Case> lstCasesNew, List<Case> lstCasesOld){
        //Send email to users according to organisation unit and dept owner if feedback case is created
        //Done for the case-00012428
        sendEmailForFeedbackCase(lstCasesNew);               
    }
    
    public static void afterCaseInsertUpdate(Map<ID, Case> oldMap, Map<ID, Case> newMap) {
        ////Below Line is Commented For Case#00216417: RMA Re-engineering:
        ////sendEmailToPSRs(oldMap, newMap);  
              
        inspectionUpdate(newMap.values(),oldMap);//for case # 00045421
        IssueManagement.copyOwnerToIssues(newMap.values(),oldMap);//for Case# 00079081
        CaseMetricManagment.afterCaseInsertUpdate(newMap.values(), oldMap);
    }
    
    //Method called before case inserted
    public static void beforeCaseInsertUpdate(List<Case> lstCasesNew,Map<ID,Case> mapOldCs){
        checkRecordType(lstCasesNew,mapOldCs);//for case # 00045421
        //Set RSM and case owner
        //Done for the case-00012428        
        setCaseFields(lstCasesNew,mapOldCs);
        if(mapOldCs==null){
            //chgDates(lstCasesNew);//for case # 00040489    
        }else{            
            CaseMetricManagment.beforeCaseUpdate(lstCasesNew, mapOldCs);
        }    
    }
    //for case # 00045421
    public static void inspectionUpdate(List<Case> lstCasesNew,Map<ID,Case> mapOldCs){
        Set<Id> caseIdSet = new Set<Id>();
        Set<Id> ownerCaseIdSet = new Set<Id>();//for case#00068711              
        for(Case newCase : lstCasesNew){            
            String oldStatus='';
            if(mapOldCs!=null){
                oldStatus = mapOldCs.get(newCase.Id).Status;
            }           
            if(newCase.RecordTypeId == euInspectionCaseRecTypeId && newCase.Status != oldStatus)
                caseIdSet.add(newCase.Id);
            //Start for case#00068711
            String oldOwner='';
            if(mapOldCs!=null)
                oldOwner = mapOldCs.get(newCase.Id).OwnerId;
            if(newCase.RecordTypeId == euInspectionCaseRecTypeId && oldOwner != '' && newCase.OwnerId != oldOwner){
                //newCase.Status == 'Assigned' && 
                ownerCaseIdSet.add(newCase.Id);
                caseIdSet.add(newCase.Id);
            }
            //End for case#00068711
        }
        List<Case> caseList = new List<Case>();
        Map<Id, Inspection__c> inspectionMap = new Map<Id, Inspection__c>();
        if(caseIdSet.size()>0)
            caseList = [Select Id, OwnerId, Status, (select Id, Case_Status__c, Contact__c from Inspections__r)  from Case where Id in :caseIdSet];         
        Set<Id> userSet = new Set<Id>();//for case#00068711
        if(caseList.isEmpty()) return;//for case#00068711
        for(Case c:caseList){
            if(ownerCaseIdSet.contains(c.Id))//for case#00068711
                userSet.add(c.OwnerId);//for case#00068711
            else if(c.Inspections__r.size()>0){
                Inspection__c ins = c.Inspections__r.get(0);
                c.OwnerId = ins.Contact__c;
            }
            for(Inspection__c ins : c.Inspections__r){
                ins.Case_Status__c = c.Status;                    
                inspectionMap.put(ins.Id, ins);
            }
        }
        //Start for case#00068711    
        if(userSet.isEmpty()) return;
        Map<Id, User> userMap = new Map<Id, User>([Select Id, UserRole.Name from User where Id in :userSet]);
        for(Case c:caseList){
            if(ownerCaseIdSet.contains(c.Id)){
                if(userMap.get(c.OwnerId)!=null && 
                    (userMap.get(c.OwnerId).UserRole.Name == 'Inspector' || userMap.get(c.OwnerId).UserRole.Name == 'Inspector Leader') ){
                    for(Inspection__c ins : c.Inspections__r){
                        //ins.Contact__c = c.OwnerId;
                        ins.OwnerId = c.OwnerId;
                        inspectionMap.put(ins.Id, ins);
                    }
                }
            }
            
        }
        //End for case#00068711
        if(inspectionMap.size()>0)
            update inspectionMap.values();      
    }
    public static void checkRecordType(List<Case> lstCasesNew,Map<ID,Case> mapOldCs)
    {
        Set<ID> caseIdSet = new Set<ID>();      
        for(Case newCase : lstCasesNew){
            Id oldRecordTypeId = null;
            String oldStatus = null;//for case# 00066693
            if(mapOldCs!=null){
                oldRecordTypeId = mapOldCs.get(newCase.Id).RecordTypeId;
                oldStatus = mapOldCs.get(newCase.Id).Status;
            }
            //Start for case# 00066693
            if(crmCaseRecTypeId == newCase.RecordTypeId && newCase.Last_Response_Timestamp__c != null 
                && newCase.Status != null && (newCase.Status == 'Pending User Response' || newCase.Status == 'Pending User Acceptance')){
                    if(oldStatus != null && oldStatus == newCase.Status){               
                        continue;
                    }
                    newCase.First_Reminder_Date__c = DateCalculationUtility.getWorkingDay(System.now() , 3);
                    newCase.Second_Reminder_Date__c = DateCalculationUtility.getWorkingDay(System.now() , 6);
            }           
            //End for case# 00066693                                   
            if(oldRecordTypeId!=null && oldRecordTypeId == euInspectionCaseRecTypeId && oldRecordTypeId != newCase.RecordTypeId)
                newCase.addError('Record Type Change is not allowed.');
            if(newCase.RecordTypeId == euInspectionCaseRecTypeId && newCase.Status =='Completed'){
                if(newCase.Review_By__c != null){
                    newCase.OwnerId = newCase.Review_By__c;
                }
            }
        }       
    }
    //Case# 00067852 start
    
    /**  == Case#00216417: RMA Re-engineering-Removing All RMA related code from Case Trigger & it's supporting class == **/
    /* Below Method "sendEmailToPSRs" is commented for Case#00216417
    //It is sending automatic notification to assigned PSRs per account for a new case to process once the RMA box has been checked. 
    //Added for Sunpower Case # 00044909
    private static void sendEmailToPSRs(Map<ID, Case> oldMap, Map<ID, Case> newMap) 
    {
SYSTEM.DEBUG('--1-- newMap --' + newMap);    
       
       
        Map<ID, Case> caseMapWithRMA = new Map<ID, Case>();
        Map<ID, Case> caseMapWithRMAStillOpen = new Map<ID, Case>();
       
       
        Set<ID> accountIdsSet = new Set<ID>();
        Map<ID,Case> caseMapForUpdateAlert = new Map<ID,Case>();   
        Map<Id, Case> caseMapForCloseAlert = new Map<Id, Case>();//for Case# 00072277
        Map<Id, Id> caseMapforCaseIdvsCreator = new Map<Id, Id>();//Case: 00157758
        Set<Id> caseCreatorSet = new Set<Id>();//Case: 00157758
        Map<Id, Case> caseMapForPEAlert = new Map<Id, Case>(); //Case 00074218        
        //Set<String> operatingUnits = new Set<String>{'SPNA', 'SPAU', 'SPDE', 'SPES', 'SPFR', 'SPIT', 'SPEB'};//for Case# 00072277
          Set<String> operatingUnits = new Set<String>{'SPNA', 'SPAU', 'SPDE', 'SPES', 'SPFR', 'SPIT', 'SPEB', 'SPAP', 'SPBE', 'SPGB', 'SPSW'};//Case: 00157758
        for (Case newCase : newMap.values()) 
        {
SYSTEM.DEBUG('--2-- newCase --' + newCase);          
            if(newCase.AccountId != null && oldMap != null && newCase.Notification_for_Update__c && !oldMap.get(newCase.Id).Notification_for_Update__c)
                caseMapForUpdateAlert.put(newCase.Id,newCase);
         
                    
            if (!(newCase.RMA__c == false ||  newCase.AccountId == null || (oldMap != null && oldMap.get(newCase.Id).RMA__c == true))) 
            {
                caseMapWithRMA.put(newCase.Id, newCase);
            }  
//Case#00087990            
            if(oldMap != null && newCase.RMA_Case_Open_Alert__c != oldMap.get(newCase.Id).RMA_Case_Open_Alert__c)
            {
              caseMapWithRMAStillOpen.put(newCase.Id, newCase);
            }
           
            
//Case 00074218                   
            if((oldMap == null && newCase.PE__c == true) || 
               (oldMap != null && oldMap.get(newCase.Id).PE__c == false && oldMap.get(newCase.Id).PE__c != newCase.PE__c))
            {
                caseMapForPEAlert.put(newCase.Id, newCase);
            }            
//Case# 00072277: start
            if(newCase.AccountId != null && 
               operatingUnits.contains(newCase.Region__c) && 
               newCase.Business_Unit__c == 'RLC' &&
               (((newCase.RecordTypeId == cscRecordTypeId || newCase.RecordTypeId == tscRecordTypeId) && newCase.RMA__c) || newCase.SubInventory_in_Oracle__c != null))
            {
SYSTEM.DEBUG('--3.1-- newCase --' + newCase);            
                caseMapForCloseAlert.put(newCase.Id, newCase);
                caseMapforCaseIdvsCreator.put(newCase.Id, newCase.CreatedById);//Case: 00157758
                caseCreatorSet.add(newCase.CreatedById);
SYSTEM.DEBUG('--3.2-- caseMapForCloseAlert --' + caseMapForCloseAlert);   
SYSTEM.DEBUG('--3.3-- caseMapforCaseIdvsCreator--' + caseMapforCaseIdvsCreator);   
SYSTEM.DEBUG('--3.4-- caseCreatorSet--' + caseCreatorSet);                   
            }
            
            if( caseMapWithRMA.containsKey(newCase.Id) || 
                caseMapForUpdateAlert.containsKey(newCase.Id) || 
                caseMapForCloseAlert.containsKey(newCase.Id) || 
                caseMapForPEAlert.containsKey(newCase.Id) || 
                caseMapWithRMAStillOpen.containsKey(newCase.Id))
            {
                accountIdsSet.add(newCase.AccountId);
            }          
        }

        Map<ID, Account> accountMap = new Map<ID, Account>([SELECT Id, Name, 
                                                                   Assigned_PSR_IDS__c, Primary_PSR__c, 
                                                                   Primary_PSR__r.Email, OwnerId, 
                                                                   Owner.Email 
                                                            FROM Account 
                                                            WHERE id IN: accountIdsSet AND 
                                                                  Assigned_PSR_IDS__c != null AND 
                                                                  Assigned_PSR_IDS__c != '']);

        Map<ID, Set<String>> caseIdToUserIdsMap = new Map<ID, Set<String>>();
        Set<String> userIdsSet = new Set<String>();
        
        for (Case newCase : newMap.values()) 
        {
            if ((!caseMapWithRMA.containsKey(newCase.Id) && 
                 !caseMapForUpdateAlert.containsKey(newCase.Id) && 
                 !caseMapForPEAlert.containsKey(newCase.Id) && 
                 !caseMapForCloseAlert.containsKey(newCase.Id) && 
                 !caseMapWithRMAStillOpen.containsKey(newCase.Id)) || 
                accountMap.get(newCase.AccountId) == null) 
            {
                continue;
            }
            
            Set<String> userIdsSetLocal = new Set<String>();
            for(String psrID : accountMap.get(newCase.AccountId).Assigned_PSR_IDS__c.split(','))
            {
                if(psrID.length() == 15 || psrID.length() == 18)
                    userIdsSetLocal.add(psrID);             
            }
            caseIdToUserIdsMap.put(newCase.Id, userIdsSetLocal);
            userIdsSet.addAll(userIdsSetLocal);
        }
SYSTEM.DEBUG('--4--');        
        Map<Id, User> userMap = new Map<Id, User>();
        Map<Id, User> caseCreatormap = new Map<Id, User>();
        for(User usr: [SELECT Id, Email 
                       FROM User 
                       WHERE id IN: userIdsSet OR 
                             id IN: caseMapforCaseIdvsCreator.values()])//Case: 00157758 
        {
            if(userIdsSet.contains(usr.Id))
                userMap.put(usr.Id, usr);
            if(caseCreatorSet.contains(usr.Id))
                caseCreatormap.put(usr.Id, usr);
        }
SYSTEM.DEBUG('--5--userMap--'+ userMap.size());        
        if (userMap.isEmpty()) 
            return;
        
        List<Messaging.SingleEmailMessage> emailsList = new List<Messaging.SingleEmailMessage>();
            emailsList.addAll(sendCaseUpdateAlert(caseMapForUpdateAlert,accountMap,caseIdToUserIdsMap,userMap));//for Case#00074218
            emailsList.addAll(sendCaseClosedAlert(caseMapForCloseAlert,accountMap,caseIdToUserIdsMap,userMap, oldMap, caseCreatormap)); //for Case# 00072277//for Case#00074218
            emailsList.addAll(sendCasePEAlert(caseMapForPEAlert,accountMap,caseIdToUserIdsMap,userMap, oldMap)); //Case 00074218
            emailsList.addAll(sendCaseRMAStillOpenAlert(caseMapWithRMAStillOpen,accountMap,caseIdToUserIdsMap,userMap, oldMap)); //Case 00087990
                
        for (ID caseId : caseMapWithRMA.keySet()) 
        {
            List<String> userEmails = new List<String>();
            
            for (ID userId : caseIdToUserIdsMap.get(caseId)) 
                if (userMap.get(userId) != null)
                    userEmails.add(userMap.get(userId).Email);
            
            if (userEmails.size() == 0) {
                continue;
            }
            
            Case newCase = caseMapWithRMA.get(caseId);
            Messaging.SingleEmailMessage singleEmailMsg = new Messaging.SingleEmailMessage();
            singleEmailMsg.setToAddresses(userEmails);
            singleEmailMsg.setHTMLBody(emailBody.replace('CaseLink', 'https://login.salesforce.com/' + caseId));
            singleEmailMsg.setSubject('Escalated Case - ' + newCase.CaseNumber + ' ' + accountMap.get(newCase.AccountId).Name);
            singleEmailMsg.saveAsActivity = false;
            singleEmailMsg.setWhatId(caseId);
            emailsList.add(singleEmailMsg);                        
        }
SYSTEM.DEBUG('--6--emailsList.size()--'+ emailsList.size() + '\n' + emailsList);        
        if (emailsList.size() > 0) {
            Messaging.sendEmail(emailsList);
        }
    }
    */
    
    /**  == Case#00216417: RMA Re-engineering-Removing All RMA related code from Case Trigger & it's supporting class == **/
    /* Below Method "sendCaseRMAStillOpenAlert" is commented for Case#00216417 */
    //It is sending RMA Case Email Alert after 10 & 15 days if RMA Case is not closed.
    /* Start Case#00216417
    //Case 00087990
    private static List<Messaging.SingleEmailMessage> sendCaseRMAStillOpenAlert(Map<Id,Case> mapCases,Map<Id,Account> accountMap,Map<ID, Set<String>> caseIdToUserIdsMap,Map<Id,User> mapUsers, Map<ID, Case> oldMap)
    {
        List<Messaging.SingleEmailMessage> emailsList = new List<Messaging.SingleEmailMessage>();
        for(Case newCase : mapCases.values()){          
            //prepare to address list 
            Set<String> userEmails = new Set<String>();
            if(accountMap.get(newCase.AccountId).Primary_PSR__c != null && accountMap.get(newCase.AccountId).Primary_PSR__r.Email != null && accountMap.get(newCase.AccountId).Primary_PSR__r.Email != '')
                userEmails.add(accountMap.get(newCase.AccountId).Primary_PSR__r.Email);
            for (ID userId : caseIdToUserIdsMap.get(newCase.Id)) {
                if (mapUsers.get(userId) != null) {
                    userEmails.add(mapUsers.get(userId).Email);
                }
            }
            userEmails.add('salesforcearchives@sunpowercorp.com');
            
            String url;                       
            if(SalesforceOrgUtils.isProductionOrg()){
                url='https://login.salesforce.com/'+newCase.Id;
            }else{
                url='https://test.salesforce.com/'+newCase.Id;                
            }                  
            url = URL.getSalesforceBaseUrl().toExternalForm()+'/';

            List<String> toAddresses = new List<String>();
            toAddresses.addAll(userEmails);
            
            Messaging.SingleEmailMessage singleEmailMsg = new Messaging.SingleEmailMessage();                                   
            singleEmailMsg.setPlainTextBody('Hi ,\n\nBe advise that this case has been opened for '+newCase.RMA_Days_Opened__c+' days.\n\nCase Detail - '+ url +'\n\nThanks.');
            singleEmailMsg.setSubject('RMA Case has been Opened for '+newCase.RMA_Days_Opened__c+' days - Case #'+ newCase.CaseNumber);                
            singleEmailMsg.setToAddresses(toAddresses);
            singleEmailMsg.saveAsActivity = false;
            singleEmailMsg.setWhatId(newCase.Id);           
            emailsList.add(singleEmailMsg);
        }
         return emailsList;
    }
    //End Case 00087990
    
    // Below Method "sendCaseClosedAlert" is commented for Case#00216417:RMA Re-Engineering
    //This method sends email alert when RMA case is closed.
    //Start for Case# 00072277  
    private static List<Messaging.SingleEmailMessage> sendCaseClosedAlert(Map<Id,Case> mapCases, 
                                                                          Map<Id,Account> accountMap,
                                                                          Map<ID, 
                                                                          Set<String>> caseIdToUserIdsMap,
                                                                          Map<Id,User> mapUsers, 
                                                                          Map<ID, Case> oldMap, 
                                                                          Map<Id,User> mapCreator)//Case# 00157758 
    {
SYSTEM.DEBUG('--5.1--');     
        List<Messaging.SingleEmailMessage> emailsList = new List<Messaging.SingleEmailMessage>();
        Set<String> setRegion1Chk = new Set<String>{'SPNA', 'SPAU'};//Case# 00157758
        Set<String> setRegion2Chk = new Set<String>{'SPDE', 'SPES', 'SPFR', 'SPIT', 'SPEB'};//Case# 00157758   
        Set<String> setregion3Chk = new Set<String>{'SPAP', 'SPBE', 'SPGB', 'SPSW'};//Case# 00157758 
        for(Case newCase : mapCases.values())
        { 
SYSTEM.DEBUG('--5.1.1--');                  
            Set<String> userEmails = new Set<String>();
            
            if( accountMap.get(newCase.AccountId).Primary_PSR__c != null && 
                accountMap.get(newCase.AccountId).Primary_PSR__r.Email != null && 
                accountMap.get(newCase.AccountId).Primary_PSR__r.Email != '')
            {
                userEmails.add(accountMap.get(newCase.AccountId).Primary_PSR__r.Email);
            }
            
            for (ID userId : caseIdToUserIdsMap.get(newCase.Id)) 
                if (mapUsers.get(userId) != null)
                    userEmails.add(mapUsers.get(userId).Email);
SYSTEM.DEBUG('--5.1.2--userEmails--' + userEmails);             
            List<String> toAddresses = new List<String>();
            toAddresses.addAll(userEmails);
            
            Messaging.SingleEmailMessage singleEmailMsg = new Messaging.SingleEmailMessage();  
//SYSTEM.DEBUG('--5.1.2--setRegion1Chk.contains(newCase.Region__c)--' + setRegion1Chk.contains(newCase.Region__c) + '--newCase.Region__c--' + newCase.Region__c);
//SYSTEM.DEBUG('--5.1.2--newCase.RMA__c--' + newCase.RMA__c);
//SYSTEM.DEBUG('--5.1.2--oldMap == null--' + (oldMap == null) + '--newCase.Status--' + newCase.Status + '--oldMap.get(newCase.Id).Status--' + oldMap.get(newCase.Id).Status);
//SYSTEM.DEBUG('--5.1.2--newCase.RecordTypeId == cscRecordTypeId--' + (newCase.RecordTypeId == cscRecordTypeId));
//SYSTEM.DEBUG('--5.1.2--newCase.RecordTypeId == tscRecordTypeId--' + (newCase.RecordTypeId == tscRecordTypeId));
//SYSTEM.DEBUG('--5.1.2--setRegion2Chk.contains(newCase.Region__c)--' + setRegion2Chk.contains(newCase.Region__c) + '--newCase.Region__c--' + newCase.Region__c);
//SYSTEM.DEBUG('--5.1.2--newCase.SubInventory_in_Oracle__c--' + newCase.SubInventory_in_Oracle__c);
//SYSTEM.DEBUG('--5.1.2--oldMap.get(newCase.Id).SubInventory_in_Oracle__c--' + oldMap.get(newCase.Id).SubInventory_in_Oracle__c);            
            if( setRegion1Chk.contains(newCase.Region__c) && 
                newCase.RMA__c && 
                ((oldMap == null && newCase.Status == 'Closed')  || 
                (oldMap != null && newCase.Status == 'Closed' && oldMap.get(newCase.Id).Status != newCase.Status )) &&
                (newCase.RecordTypeId == cscRecordTypeId || newCase.RecordTypeId == tscRecordTypeId))
            {
SYSTEM.DEBUG('--5.1.2.X--newCase--' + newCase);            
                singleEmailMsg.setPlainTextBody('Hi ,\n\nYour case is now Closed. Please update the Credit Memo & Debit Memo Fields in Salesforce.\n\nThanks.');
                singleEmailMsg.setSubject('Case-' + newCase.CaseNumber + ' '+ accountMap.get(newCase.AccountId).Name +' is now Closed');
            }
            else if(setRegion2Chk.contains(newCase.Region__c) && 
                    ((oldMap == null && newCase.SubInventory_in_Oracle__c != null)  || 
                    (oldMap != null && oldMap.get(newCase.Id).SubInventory_in_Oracle__c == null && newCase.SubInventory_in_Oracle__c != null)))
            {
SYSTEM.DEBUG('--5.1.2.Y--newCase--' + newCase);               
                singleEmailMsg.setPlainTextBody('Hi ,\n\nReceipt process has been done in Oracle. Please close the case in SFDC once Credit Memo has been generated.\n\nThanks.');
                singleEmailMsg.setSubject(newCase.CaseNumber + ' ('+ accountMap.get(newCase.AccountId).Name +') For Closing in SFDC');               
            }
            else if( setRegion3Chk.contains(newCase.Region__c) && 
                     newCase.RMA__c && 
                     ((oldMap == null && newCase.Status == 'Closed')  || 
                     (oldMap != null && newCase.Status == 'Closed' && oldMap.get(newCase.Id).Status != newCase.Status )) &&
                     (newCase.RecordTypeId == cscRecordTypeId || newCase.RecordTypeId == tscRecordTypeId))//Case# 00157758 
            {
SYSTEM.DEBUG('--5.1.2.Z--newCase--' + newCase);                      
                singleEmailMsg.setPlainTextBody('Hi ,\n\nYour case is now Closed. Please update the Credit Memo & Debit Memo Fields in Salesforce.\n\nThanks.');
                singleEmailMsg.setSubject('Case-' + newCase.CaseNumber + ' '+ accountMap.get(newCase.AccountId).Name +' is now Closed');             
            }//Case# 00157758 
            else
            {
SYSTEM.DEBUG('--5.1.2.W--newCase--' + newCase);               
                continue;
            }
            
            if(mapCreator.containsKey(newCase.CreatedById))//Case# 00157758 
            {
                toAddresses.add(mapCreator.get(newCase.CreatedById).Email);
            }//Case# 00157758            
            singleEmailMsg.setToAddresses(toAddresses);
            singleEmailMsg.saveAsActivity = false;
            singleEmailMsg.setWhatId(newCase.Id);
            emailsList.add(singleEmailMsg);
SYSTEM.DEBUG('--5.2--singleEmailMsg--'+ singleEmailMsg);             
        }
        return emailsList;        
    }
    //End for Case# 00072277    
    
    */
    //End Case#00216417:RMA Re-engineering 
    
    
    //Case 00074218
     private static List<Messaging.SingleEmailMessage> sendCasePEAlert(Map<Id,Case> mapCases,Map<Id,Account> accountMap,Map<ID, Set<String>> caseIdToUserIdsMap,Map<Id,User> mapUsers, Map<ID, Case> oldMap)
     {
        List<Messaging.SingleEmailMessage> emailsList = new List<Messaging.SingleEmailMessage>();
        for(Case newCase : mapCases.values()){          
            //prepare to address list 
            Set<String> userEmails = new Set<String>();
            if(accountMap.get(newCase.AccountId).Primary_PSR__c != null && accountMap.get(newCase.AccountId).Primary_PSR__r.Email != null && accountMap.get(newCase.AccountId).Primary_PSR__r.Email != '')
                userEmails.add(accountMap.get(newCase.AccountId).Primary_PSR__r.Email);
            for (ID userId : caseIdToUserIdsMap.get(newCase.Id)) {
                if (mapUsers.get(userId) != null) {
                    userEmails.add(mapUsers.get(userId).Email);
                }
            }
            String urlstg;
            userEmails.add('MariaChona.Alandy@sunpowercorp.com');
            userEmails.add('Shieryl.Espiritu@sunpowercorp.com');
            /*if(SalesforceOrgUtils.isProductionOrg()){
                urlstg='https://login.salesforce.com/'+newCase.Id;
            }else{
                urlstg='https://test.salesforce.com/'+newCase.Id;                
            } */
                             
            urlstg= URL.getSalesforceBaseUrl().toExternalForm()+'/';

            List<String> toAddresses = new List<String>();
            toAddresses.addAll(userEmails);
            Messaging.SingleEmailMessage singleEmailMsg = new Messaging.SingleEmailMessage();
                       
            //if(newCase.PE__c && !oldMap.get(newCase.Id).PE__c){
                singleEmailMsg.setPlainTextBody('Hi ,\n\nA new case has been assigned to you for PE Evaluation.\n\nPlease read the case description for further information.\n'+ urlstg+'\n\nThanks.');
                singleEmailMsg.setSubject('Case-' + newCase.CaseNumber + 'in SFDC_ For PE Evaluation');    
            
            singleEmailMsg.setToAddresses(toAddresses);
            singleEmailMsg.saveAsActivity = false;
            singleEmailMsg.setWhatId(newCase.Id);
            System.debug('Jitendra Test-> '+singleEmailMsg);
            emailsList.add(singleEmailMsg);
        }
         return emailsList;
     }
    //End Case 00074218
    
    private static List<Messaging.SingleEmailMessage> sendCaseUpdateAlert(Map<Id,Case> mapCases,Map<Id,Account> accountMap,Map<ID, Set<String>> caseIdToUserIdsMap,Map<Id,User> mapUsers){
        List<Messaging.SingleEmailMessage> emailsList = new List<Messaging.SingleEmailMessage>();
        for(Case newCase : mapCases.values()){
            //prepare to address list 
            Set<String> userEmails = new Set<String>();
            if(accountMap.get(newCase.AccountId).Owner.Email != null || accountMap.get(newCase.AccountId).Owner.Email != '')
                userEmails.add(accountMap.get(newCase.AccountId).Owner.Email);
            for (ID userId : caseIdToUserIdsMap.get(newCase.Id)) {
                if (mapUsers.get(userId) != null) {
                    userEmails.add(mapUsers.get(userId).Email);
                }
            }            
            List<String> toAddresses = new List<String>();
            toAddresses.addAll(userEmails);
            
            //prepare mail
            Messaging.SingleEmailMessage singleEmailMsg = new Messaging.SingleEmailMessage();
            singleEmailMsg.setToAddresses(toAddresses);
            singleEmailMsg.setPlainTextBody('Hi ,\n\nPlease update \'Original SO#\' & \'Packing List#\' for this case.\n\nThanks,');
            singleEmailMsg.setSubject('\'Original SO#\' & \'Packing List#\' needs modifications for Case#' + newCase.CaseNumber);
            singleEmailMsg.saveAsActivity = false;
            singleEmailMsg.setWhatId(newCase.Id);
            emailsList.add(singleEmailMsg);
        }
        //Start for Case#00074218
        return emailsList;
        /*if (emailsList.size() > 0) {
            Messaging.sendEmail(emailsList);
        }*/
        //End for Case#00074218
    }
    //Case# 00067852 end
    
    //Set RSM and case owner
    private static void setCaseFields(List<Case> lstCasesNew,Map<ID,Case> mapOldCs){
        //Get the ID of the case record type 'Feedback'
        List<RecordType> lstRecordType  = new List<RecordType>([Select r.SobjectType, r.Name, r.Id From RecordType r where SobjectType ='Case' and Name = 'Feedback']);
        String feedbackRecTypeID = null;
        if(lstRecordType.size()>0){
            feedbackRecTypeID = lstRecordType[0].ID;
        }       
        
        //Get the users map of recipient name with the ID
        map<String,String> mapUserNameID = new map<String,String>();        
        for(User u:[Select id,name from User where name in:setRecipientName and isActive=true]){
            mapUserNameID.put(u.name,u.ID);
        }
        
        //Prepare the set of AccountIDs
        Set<String> setAccounts = new Set<String>();
       
        //Map Contains Account(only for Recordtype = Partner) Assigned PSRs value 
        map<String,String> accountUserMap = new Map<String,String>();
        
        for(Case cs:lstCasesNew){
            setAccounts.Add(cs.AccountID);

        }
        //Prepare map of AccountID with Account detail
        Map<String,Account> mapAccount = new Map<String,Account>();
        //Prepare map of Accounts with the RSM
        map<String,String> mapAccountWithRSM = new map<String,String>();
        for(Account acc:[Select id,Name,RSM__c,Assigned_PSR_s__c,RecordType.Name from Account where id in :setAccounts]){
            mapAccount.put(acc.ID,acc);
            if(acc.RSM__c!=null)
                mapAccountWithRSM.put(acc.id,acc.RSM__c);
            if(acc.Assigned_PSR_s__c!=null && acc.Assigned_PSR_s__c!='')    
            accountUserMap.put(acc.id,acc.Assigned_PSR_s__c); 
           // System.debug(accountUserMap + '------accountUserMap---------');    
        }
                
        //Traverse through each case  
        Set<String> setUser = new Set<String>();   
        map<String,Case> UserMapwithCase = new Map<String,Case>();
        String dummyAccountID = '';               
        for(Case cs:lstCasesNew){
            dummyAccountID = cs.AccountID;
            //System.debug('===========for loop------');
            //Set RSM of the case equal to RSM of Case'Account if case's RSM is not populated manually
            if(mapAccountWithRSM.containsKey(cs.AccountID)){
                cs.RSM__c = mapAccountWithRSM.get(cs.AccountID);
            }
            if(cs.recordTypeID==feedbackRecTypeID){
               //    continue;
               //Set ownerID according to operating unit and department owner of Case
               String ownerID = getRelatedUserID(cs,mapUserNameID);            
               if(ownerID!=null){
                cs.ownerID = ownerID;
               }         
            } 
    // Below Code is commented for Case#00216417:RMA Re-Engineering
    /******             
            if(cs.RMA__c && cs.id!=null && mapOldCs.containsKey(cs.id) && cs.ownerID != mapOldCs.get(cs.id).ownerID && accountUserMap.get(cs.AccountID)!= null)                             
           // If(((cs.RMA__c && cs.id==null) || (cs.RMA__c && cs.id!=null && mapOldCs.containsKey(cs.id) && cs.RMA__c != mapOldCs.get(cs.id).RMA__c)) && accountUserMap.get(cs.AccountID)!= null)
            {
              String assignedPSRs = accountUserMap.get(cs.AccountID);
              String[] assignedPSR = assignedPSRs.split(',');
              setUser.addAll(assignedPSR); 
             // system.debug(setUser +'------setUser--------');           
             for(string username : assignedPSR )
             {
                System.debug('--cs.id--'+cs.id); 
               UserMapwithCase.put(username,cs);
             } 
              
         
            }  
    *****/
        } 
        
        /* Commented for Sunpower Case # 00044909 */
        /********
        List<User> userEmail= new List<User>();
        userEmail = [select Id,Name,Email from User where Name in : setUser];               
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
         
        for(User us:userEmail)
        {
          if(UserMapwithCase.get(us.Name)==null){
            continue;
          }
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();   
          mail.setToAddresses(new String []{us.Email}); 
          //mail.setTemplateId(([SELECT id, name FROM Emailtemplate where name ='RMACaseAssigned']).Id);  
          emailBody = emailBody.replace('CaseLink','https://login.salesforce.com/'+UserMapwithCase.get(us.Name).ID);
          mail.setHTMLBody(emailBody);          
          String accountName = '';
          if(mapAccount.get(UserMapwithCase.get(us.Name).AccountID)!=null){
            accountName = mapAccount.get(UserMapwithCase.get(us.Name).AccountID).Name;
          }          
          mail.setSubject('Escalated Case-'+UserMapwithCase.get(us.Name).CaseNumber + ' '+accountName);
          mail.saveAsActivity = false;
          
          mail.setWhatId(UserMapwithCase.get(us.Name).ID);
          
        
          emails.add( mail);
          system.debug(emails+'-------emails----');
       }
       if(emails.size()>0){ 
            
           Messaging.sendEmail(emails);
       }
       ********/
    }
    //Send email to users according to organisation unit and dept owner if feedback case is created
    private static void sendEmailForFeedbackCase(List<Case> lstCasesNew){
        //Get the ID of the case record type 'Feedback'
        List<RecordType> lstRecordType  = new List<RecordType>([Select r.SobjectType, r.Name, r.Id From RecordType r where SobjectType ='Case' and Name = 'Feedback']);
        String feedbackRecTypeID = null;
        if(lstRecordType.size()>0){
            feedbackRecTypeID = lstRecordType[0].ID;
        }       
        
        //Get the users map of recipient name with the ID
        map<String,String> mapUserNameID = new map<String,String>();        
        for(User u:[Select id,name from User where name in:setRecipientName and isActive=true]){
            mapUserNameID.put(u.name,u.ID);
        }
                
        //Prepare mail list
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();                 
        for(Case cs:lstCasesNew){
            if(cs.recordTypeID!=feedbackRecTypeID){
                continue;
            }
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();         
            mail.saveAsActivity=false;          
            mail.Subject = 'New feedback case has been received.';
            //Start for case #00067458            
       //String url = SalesforceOrgUtils.isProductionOrg() ? 'https://login.salesforce.com/' : 'https://cs3.salesforce.com/';
       String urlStg = URL.getSalesforceBaseUrl().toExternalForm()+'/';    
            //mail.setCcAddresses(new String[]{'jkothari@appirio.com'});
            String FCEmailBody = 'New feedabck case of type ' + cs.Type +' is received.<br/><br/>Check the following Case number. <br/>Case Number: <a href='+urlStg+cs.Id+'>' +  cs.caseNumber+'</a>';
            //mail.setHTMLBody('New feedabck case of type ' + cs.Type +' is received.<br/><br/>Check the following Case number. <br/>Case Number: ' +  cs.caseNumber);
            mail.setHTMLBody(FCEmailBody);
            //End for case #00067458
            //Set TragetObjectID according to operating unit and department owner of Case
            mail.targetobjectid = getRelatedUserID(cs,mapUserNameID);
                         
            System.Debug('Target User Id'+mail.targetobjectid);
            if(mail.targetobjectid!=null){
                mailList.add(mail);
            }
            
            //Mail to RSM of case
            if(cs.RSM__c!=null){
                Messaging.SingleEmailMessage mailRSM = new Messaging.SingleEmailMessage();          
                mailRSM.saveAsActivity=false;           
                mailRSM.Subject = 'New feedback case has been received.';
                //mailRSM.setHTMLBody('New feedabck case of type ' + cs.Type +' is received.<br/><br/>Check the following Case number. <br/>Case Number: ' +  cs.caseNumber);//for case #00067458
                mailRSM.setHTMLBody(FCEmailBody);//for case #00067458
                mailRSM.targetobjectid = cs.RSM__c;
                mailList.add(mailRSM);
            }
            
            if(mailList.size()>200){
                Messaging.sendEmail(mailList);
                mailList.clear();
            }
        }
        if(mailList.size()>0){
            Messaging.sendEmail(mailList);          
        }
    }
    private static string getRelatedUserID(Case cs,map<String,String> mapUserNameID){
        String userID=null;
        if(cs.Region__c=='SPNA'){
                if(cs.VAR_Dept_Owner__c=='Operations / Shipping + Logistics' && mapUserNameID.containsKey('Chris White')){
                    userID=mapUserNameID.get('Chris White');
                }
                //Start 00121941
                /*if(cs.VAR_Dept_Owner__c=='Sales' && mapUserNameID.containsKey('Shane Messer')){
                    userID=mapUserNameID.get('Shane Messer');
                }*/
                //End 00121941
                if(cs.VAR_Dept_Owner__c=='Partner Experience' && mapUserNameID.containsKey('John osmer')){
                    userID=mapUserNameID.get('John osmer');
                }
                //Start 00121941
                /*if(cs.VAR_Dept_Owner__c=='Marketing' && mapUserNameID.containsKey('Mei Juknelis')){
                    userID=mapUserNameID.get('Mei Juknelis');
                }*/
                //End 00121941
                if(cs.VAR_Dept_Owner__c=='Finance' && mapUserNameID.containsKey('Anish Shah')){
                    userID=mapUserNameID.get('Anish Shah');
                }
                if(cs.VAR_Dept_Owner__c=='Customer Finance' && mapUserNameID.containsKey('Mark Schmidt')){
                    userID=mapUserNameID.get('Mark Schmidt');
                }
                if(cs.VAR_Dept_Owner__c=='Channel Development' && mapUserNameID.containsKey('Ken Fong')){
                    userID = mapUserNameID.get('Ken Fong');
                }
            }
            
            if(cs.Region__c=='SPDE' || cs.Region__c=='SPIT' || cs.Region__c=='SPES' || cs.Region__c=='SPFR'){
                if(cs.VAR_Dept_Owner__c=='Operations / Shipping + Logistics' && mapUserNameID.containsKey('Nick Hyner')){
                    userID=mapUserNameID.get('Nick Hyner');
                }
                if(cs.VAR_Dept_Owner__c=='Sales'){
                    if(cs.Region__c=='SPFR' && mapUserNameID.containsKey('Mark Babcock'))
                        userID=mapUserNameID.get('Mark Babcock');
                    if(cs.Region__c=='SPDE' && mapUserNameID.containsKey('Reinhardt Lampe'))
                        userID=mapUserNameID.get('Reinhardt Lampe');
                    if(cs.Region__c=='SPIT'&& mapUserNameID.containsKey('Andrea Antolini'))
                        userID=mapUserNameID.get('Andrea Antolini');
                    if(cs.Region__c=='SPES' && mapUserNameID.containsKey('Carlos Garcia'))
                        userID=mapUserNameID.get('Carlos Garcia');
                }
                //Start 00121941
                /*if(cs.VAR_Dept_Owner__c=='Partner Experience' && mapUserNameID.containsKey('Lluis Juncosa')){
                    userID=mapUserNameID.get('Lluis Juncosa');
                }*/
                //End 00121941
                if(cs.VAR_Dept_Owner__c=='Marketing' && mapUserNameID.containsKey('Ignacio Cuenca')){
                    userID=mapUserNameID.get('Ignacio Cuenca');
                }
                if(cs.VAR_Dept_Owner__c=='Business Process' && mapUserNameID.containsKey('Jorge Carbonell')){
                    userID=mapUserNameID.get('Jorge Carbonell');
                }
                if(cs.VAR_Dept_Owner__c=='Finance' && mapUserNameID.containsKey('George Collins')){
                    userID=mapUserNameID.get('George Collins');
                }
                if(cs.VAR_Dept_Owner__c=='Customer Finance' && mapUserNameID.containsKey('David Monasterio')){
                    userID=mapUserNameID.get('David Monasterio');
                }
                if(cs.VAR_Dept_Owner__c=='Channel Development' && mapUserNameID.containsKey('Oscar Cepas')){
                    userID = mapUserNameID.get('Oscar Cepas');
                }
            }
            
            if(cs.Region__c=='SPAU' || cs.Region__c=='SPKR'){
                if(cs.VAR_Dept_Owner__c=='Operations / Shipping + Logistics' && mapUserNameID.containsKey('Andrew Turner')){
                    userID=mapUserNameID.get('Andrew Turner');
                }
                if(cs.VAR_Dept_Owner__c=='Sales' && mapUserNameID.containsKey('Chris OBRIEN')){
                    userID=mapUserNameID.get('Chris OBRIEN');
                }
                if(cs.VAR_Dept_Owner__c=='Partner Experience' && mapUserNameID.containsKey('Wilf Johnson')){
                    userID=mapUserNameID.get('Wilf Johnson');
                }               
                if(cs.VAR_Dept_Owner__c=='Finance' && mapUserNameID.containsKey('Peter Drennan')){
                    userID=mapUserNameID.get('Peter Drennan');
                }
                if(cs.VAR_Dept_Owner__c=='Channel Development' && mapUserNameID.containsKey('Chris Baker')){
                    userID = mapUserNameID.get('Chris Baker');
                }               
            }   
            
            return userID;            
    }
   

    // Case#00216417: RMA Re-engineering-Removing All RMA related code from Case Trigger & it's supporting class 
    // Below Method "checkRmaFieldDependency" is commented for Case#00216417  
    /* Start Case#00216417
    
  //Implemented for case 00039927
    public static void checkRmaFieldDependency(List<Case> lstCasesNew, List<Case> lstCasesOld)
    {
        List<RecordType> lstRecordType  = new List<RecordType>([Select r.SobjectType, r.Name, r.Id From RecordType r where SobjectType ='Case' and ( Name = 'Technical Support Case' OR Name = 'Customer Service Case')]);
        if(lstRecordType.Size() >0){
            string id = null;
            
            if(lstRecordType.get(0).Id != null)
                id = lstRecordType.get(0).Id;
                
            string id2 = null;
            if(lstRecordType.get(1).Id != null){
                id2 = lstRecordType.get(1).Id;
            }
            
            for(Case cs:lstCasesNew){
            if(cs.RecordTypeId == id || cs.RecordTypeId == id2){    
                
                if(cs.Product_Category__c=='Inverters' && (cs.Product_Sub_Category__c=='SPR-M' || cs.Product_Sub_Category__c=='SPR-F')&& cs.RMA_Type__c == 'Technical Support'){
                    if(cs.Type_of_RMA_exchange__c != 'Part exchange' && cs.Type_of_RMA_exchange__c != 'Complete exchange'){
                        cs.Type_of_RMA_exchange__c.addError('Please select Part Exchange or Complete Exchange');
                    }
                }
                   if(cs.Product_Sub_Category__c=='SPR-M' && cs.Type_of_RMA_exchange__c == 'Part exchange' && cs.RMA_Type__c == 'Technical Support'){
                        
                        if(cs.Replace_with_Part__c != 'RS485' &&  cs.Replace_with_Part__c != 'Display' && cs.Replace_with_Part__c !='Grounding kit'){
                            cs.Replace_with_Part__c.addError('You Can Select Only "RS485", "display", "grounding kit" when Product Sub Category is SPR-M and Type of RMA exchange is Part Exchange');
                        }
                      }else if(cs.Product_Sub_Category__c=='SPR-F' && cs.Type_of_RMA_exchange__c == 'Part exchange'&& cs.RMA_Type__c == 'Technical Support'){
         
                        if(cs.Replace_with_Part__c != 'Power stage' &&  cs.Replace_with_Part__c != 'Fuse' &&  cs.Replace_with_Part__c != 'Display' && cs.Replace_with_Part__c !='Com card'){
                            cs.Replace_with_Part__c.addError('You Can Select Only "power stage", "fuse", "display", "com card" when Product Sub Category is SPR-F and Type of RMA exchange is Part Exchange');
                        }
                      }
                 if(cs.RMA_Type__c == 'Technical Support' && (cs.Product_Sub_Category__c=='SPR-F' || cs.Product_Sub_Category__c=='SPR-M'))               
                 {
                    Integer count;
                                                
                    if(cs.Serial_Numbers_of_Replacement__c!=null){
                         count=cs.Serial_Numbers_of_Replacement__c.length();
                    }else{
                         count=null;
                    }            
                                
                        if(cs.Type_of_RMA_exchange__c == 'Complete exchange'){
                            
                            if(count!=null){  
                                if(count<8 || count >10){           
                                    cs.Serial_Numbers_of_Replacement__c.addError('S/N of replacement inverter can be of min 8 max 10 digits');
                                }
                            }else{
                                cs.Serial_Numbers_of_Replacement__c.addError('Serial number of Replacement can not be empty');
                            }
                            
                        }else if(cs.Type_of_RMA_exchange__c == 'Part exchange'&& cs.Product_Sub_Category__c=='SPR-F' && cs.Replace_with_Part__c=='Power stage'){
                            
                            if(count!=null){                                
                                if(count!=17){
                                    cs.Serial_Numbers_of_Replacement__c.addError('Id of power stage can be 17 digits');         
                                }   
                            }else{
                                cs.Serial_Numbers_of_Replacement__c.addError('Serial number of Replacement can not be empty');
                            }                                                   
                                                
                        }
                                    
                 }
                 
            }   
              //cs.addError('Dummy Error');
             }      
        }
      }
     */ 
     //Stop Case#00216417 

//Start Case#00216417: Removing All RMA related fields from Case Trigger & Helper Class
/****      
    public static void checkForTechSupportCases(List<Case> lstCasesNew, List<Case> lstCasesOld){
        List<RecordType> lstRecordType  = new List<RecordType>([Select r.SobjectType, r.Name, r.Id From RecordType r where SobjectType ='Case' and ( Name = 'Technical Support Case' OR Name = 'Customer Service Case')]);
        if(lstRecordType.Size() >0){
            string id = null;
            if(lstRecordType.get(0).Id != null)
                id = lstRecordType.get(0).Id;
                
            string id2 = null;
            if(lstRecordType.get(1).Id != null){
                id2 = lstRecordType.get(1).Id;
            }
            
            
            //changes for case - 11980
           // Set<Id> accountIdsSet = new Set<Id>();
            //for(Case c: lstCasesNew){
                   // if(c.Partner_Name__c!=null){
                       // accountIdsSet.add(c.Partner_Name__c);
                    //}
            //}
            //Map<Id,Account> accountMap = new Map<Id,Account>( [select isPartner,Id from Account where Id in : accountIdsSet]);
            
            //end

            for(Case c:lstCasesNew)
            {
                
                if(c.RMA__c && (c.RecordTypeId == id || c.RecordTypeId == id2)){
                    if(c.RMA_Date__c == null){
                        //c.RMA_Date__c.addError('RMA Date required for RMA case');
                        c.RMA_Date__c =  Datetime.now();
                        
                    }
                    // Done for case # 00066557 consolidating business units IBD and Components into 'UPP Intl'.
                    //if(c.Business_Unit__c!='Components'){//added for case # 00040255
                    if(c.Business_Unit__c!='UPP Intl'){//added for case # 00040255
                        if(c.RMA_Type__c == null){
                            c.RMA_Type__c.addError('RMA Type required for new RMA case');
                        }
                        if(c.RMA_Status__c == null){
                            c.RMA_Status__c.addError('RMA Status required for new RMA case');
                        }
                        if(c.RMA_Quantity__c == null){
                            c.RMA_Quantity__c.addError('RMA Quantity required for new RMA case');
                        }
                        if(c.Vendor__c == null){
                            c.Vendor__c.addError('Vendor required for RMA case');
                        }
                        if(c.Vendor_RMA_Status__c == null){
                            c.Vendor_RMA_Status__c.addError('Vendor RMA Status required for new RMA case');
                        }
                        if(c.Disposition__c == null){
                            c.Disposition__c.addError('Disposition required for new RMA case');
                        }
                    }//added for case # 00040255
                   
                   
                    if(c.Replace_with_Part__c == null){
                        c.Replace_with_Part__c.addError('Replace with Part# required for new RMA case');
                    }
                    
                    if(c.Field_Return__c == null){
                        c.Field_Return__c.addError('Field Return required for RMA case');
                    }
                    
                    if(c.Warranty__c == null){
                        c.Warranty__c.addError('Warranty required for RMA case');
                    }

                }
                //New added for case 11980
                
                //Account partnerAccount = null;
                //if(c.Partner_Name__c != null){
                    //partnerAccount = accountMap.get(c.Partner_Name__c);
                 //}
                 
                 if(c.Type=='Customer Complaint' && c.Complaint_Towards__c == 'Dealer' && c.Partner_Name__c == null){
                    // if(partnerAccount == null || (!partnerAccount.isPartner)){
                         c.Partner_Name__c.addError('Partner Name is required for Dealer Customer Complaint case');
                    // }
                 }
                 //end
                
                if(c.RMA__c && c.RecordTypeId == id && c.Status == 'Closed'){
                    if(c.RMA_Num__c == null){
                        c.RMA_Num__c.addError('RMA# required required to close RMA case');
                    }
                    if(c.Debit_Memo_Num__c == null){
                        c.Debit_Memo_Num__c.addError('Debit Memo# required to close RMA case');
                    }
                    if(c.Total_Value_of_Return__c == null){
                        c.Total_Value_of_Return__c.addError('Total Value of Return required to close RMA case');
                    }
                }

            }
            
        }  
    }
    */ //Stop Case#00216417 
    
    public static void CalculateCalendarWeek(List<Case> lstCases){ 
    
      DateTime CaseCreatedDateTime;   
      Date CaseCreatedDate;
      
      Set<String> setDates;
      List<SP_Week_Lookup__c> lstSPWeeks;
      Map<String, Double> mapSPWeeks;
      
      setDates = new Set<String>();
      
      //for each lead
      for(Case caseObj : lstCases){
       
        //populate value in the field Case_CreatedDate_Text__c
        if(caseObj.Case_CreatedDate__c == null){
          caseCreatedDateTime = DateTime.now(); 
        }
        else{
          caseCreatedDateTime = caseObj.Case_CreatedDate__c;
        }        
      
        caseCreatedDate = Date.newInstance(caseCreatedDateTime.year(), caseCreatedDateTime.month(), caseCreatedDateTime.day());        
        caseObj.Case_CreatedDate_Text__c = String.valueOf(caseCreatedDate).replace('-', '');
        
        //create a set of leadCreatedDates      
        if(!setDates.contains(caseObj.Case_CreatedDate_Text__c)){
          setDates.add(caseObj.Case_CreatedDate_Text__c);   
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
      
      //for each case get week number from the Map      
      for(Case caseObj : lstcases){
        if(mapSPWeeks.containsKey(caseObj.Case_CreatedDate_Text__c)){
          caseObj.SP_Week__c = mapSPWeeks.get(caseObj.Case_CreatedDate_Text__c);           
        }
        else{
          caseObj.SP_Week__c = 0;   
        }       
      }//end for loop
        
    }
    
    public static void updateInternalContactName(List<Case> lstCasesNew, Map<ID,Case> mapOldCase){
        List<User> lstuserRole  = new List<User>([Select UserRoleId, UserRole.Name From User where Id=:Userinfo.getUserId()]);
        
        if(lstuserRole.size()==0 || lstuserRole.get(0).UserRoleId == null || lstuserRole.get(0).UserRole.Name != 'Customer Services Representative'){
            return;
        }
          for(Case newCase : lstCasesNew){              
            if (newCase.Status != mapOldCase.get(newCase.id).Status) {                  
                    newCase.Internal_Contact_Name__c = Userinfo.getUserId();                        
            }
            
          }
    }    
    //for case # 00040489
    public static void chgDates(List<Case> lstCasesNew){
        for(Case newCase : lstCasesNew){              
            if (newCase.Type == 'Customer Complaint'){
                //newCase.Case_CreatedDate__c
                Date dateToUse = DateTime.Now().Date();
                if(newCase.createdDate!=null){
                    dateToUse = newCase.createdDate.Date();
                }
                
                newCase.P1_Notification_Email__c = true;
                newCase.P1_Maturity_Date__c = DateCalculationUtility.getWorkingDay(dateToUse , 1);
                newCase.P5_Maturity_Date__c = DateCalculationUtility.getWorkingDay(dateToUse , 5);
                newCase.P30_Maturity_Date__c = DateCalculationUtility.getWorkingDay(dateToUse , 36);
                newCase.P30_Reminder_Date__c = DateCalculationUtility.getWorkingDay(dateToUse , 12);
                newCase.P5_Reminder_Date__c = DateCalculationUtility.getWorkingDay(dateToUse , 1);
            }else{
                newCase.P1_Notification_Email__c = false;
            }
        }           
    }
    //for case # 00040489
        //Case 00218987:New request - Issue Resolution Survey configuration and deployment
    //This Method is created for Issue Resolution Survey to create a new PostCallSurvey Object records when a Case is closed and meet specific criteria.
Public Static Void createPostCallSurvey(List<Case> lstCases)
{
    List<Post_Call_Survey__c> lstPCS=new List<Post_Call_Survey__c>();
    for(Case c:lstCases)
    { 
    lstPCS.add(new Post_Call_Survey__c(Name='Issue Resolution-Transactional Survey',Contact__c=c.ContactID,Case__c=c.ID,Survey_Status__c='Invitation Sent'));    
    }
    
    if(lstPCS.size()>0)
    {
    System.debug('***Testing ContactID & CaseID '+lstPCS[0].Contact__C+'**Case ID::'+lstPCS[0].Case__c);
    insert lstPCS;
    }
}  //END OF METHOD //Case 00218987:
}