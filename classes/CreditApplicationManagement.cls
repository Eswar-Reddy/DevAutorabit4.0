public class CreditApplicationManagement {
    public static Map<String, Schema.RecordTypeInfo> nameToCARecordTypeInfoMap;    
    static {
        nameToCARecordTypeInfoMap = Schema.SObjectType.Credit_Application__c.getRecordTypeInfosByName();        
    }
    public static void beforeCreditApplicationInsert (List<Credit_Application__c> creditApplicationList){
      setRSMField(creditApplicationList);
      updateAccountCreditLimit(creditApplicationList, null);
      updateFields(creditApplicationList);
      if (UserInfo.getUserType() == 'PowerPartner') {
        assignAccount(creditApplicationList);
      }      
    }  
    
    
    public static void afterCreditApplicationInsert(Map<ID, Credit_Application__c> newCAMap,
            List<Credit_Application__c> creditApplicationList, List<Credit_Application__c> oldCreditApplicationList){      
      createSharings(creditApplicationList);
      checkForDuplicate(newCAMap);
    }//end of function        
    
    public static void afterCreditApplicationUpdate(List<Credit_Application__c> creditApplicationList,List<Credit_Application__c> oldCreditApplicationList){
      
    }//end of function   
    public static void beforeCreditApplicationUpdate (List<Credit_Application__c> creditApplicationList, 
        List<Credit_Application__c> oldCreditApplicationList,
        Map<ID, Credit_Application__c> creditApplicationMap, 
        Map<ID, Credit_Application__c> oldCreditApplicationMap){
      
        setRSMField(creditApplicationList);    
        updateAccountCreditLimit(creditApplicationList, oldCreditApplicationMap);   
        updateFields(creditApplicationList);
        checkForCreditTeam(creditApplicationMap, oldCreditApplicationMap);
        checkStatus(creditApplicationMap, oldCreditApplicationMap);
        updateInstructions(creditApplicationList, oldCreditApplicationMap, false);
    }
    
    private static void assignAccount(List<Credit_Application__c> creditApplicationList) {
        ID accountId = [Select Contact.AccountId From User where Id = :UserInfo.getUserId()].Contact.AccountId;
        
        for (Credit_Application__c creApp : creditApplicationList) {
            if (creApp.Account__c == null) {
                creApp.Account__c = accountId;
            }else if(creApp.Account__c != accountId){
                creApp.Account__c.AddError(System.Label.CAAccountChangeError);
            }
        }        
    }
    
    private static void createSharings(List<Credit_Application__c> creditApplicationList) {
        Set<String> accountsIdSet = new Set<String>();
        for (Credit_Application__c creApp : creditApplicationList) {
            if (creApp.Account__c != null) {
                accountsIdSet.add(creApp.Account__c);
            }
        }
        
        Map<ID, Account> idToAccountMap = new Map<ID, Account>([SELECT Id, Name FROM Account
                WHERE Id IN :accountsIdSet]);
        Set<String> partnerRolesName = new Set<String>();
        for (Account acc : idToAccountMap.values()) {
            partnerRolesName.add(acc.Name + ' Partner User');
        }
        
        Map<ID, UserRole> idToRoleMap = new Map<ID, UserRole>([SELECT Id, PortalAccountId
                FROM UserRole WHERE Name IN :partnerRolesName AND PortalAccountId IN :idToAccountMap.keySet()
                AND PortalType = 'Partner']);
        Map<ID, ID> accountIdToRoleIdMap = new Map<ID, ID>();
        for (UserRole role : idToRoleMap.values()) {
            accountIdToRoleIdMap.put(role.PortalAccountId, role.Id);
        }
        
        List<Group> groupsList = [SELECT Id, RelatedId FROM Group WHERE RelatedId IN :idToRoleMap.keySet()];
        Map<ID, ID> roleIdToGroupIdMap = new Map<ID, ID>();
        for (Group g : groupsList) {
            roleIdToGroupIdMap.put(g.RelatedId, g.Id);
        }
        
        List<Credit_Application__Share> sharingsList = new List<Credit_Application__Share>();
        
        for (Credit_Application__c creApp : creditApplicationList) {
            if (creApp.Account__c != null && accountIdToRoleIdMap.get(creApp.Account__c) != null
                    && roleIdToGroupIdMap.get(accountIdToRoleIdMap.get(creApp.Account__c)) != null) {
                Credit_Application__Share sharing = new Credit_Application__Share();
                sharing.ParentId = creApp.Id;
                sharing.UserOrGroupId = roleIdToGroupIdMap.get(accountIdToRoleIdMap.get(creApp.Account__c));
                sharing.AccessLevel = 'Edit';
                sharing.RowCause = 'Manual';
                sharingsList.add(sharing);
            }
        }
        
        insert sharingsList;
    }
    
    private static void checkForCreditTeam(Map<ID, Credit_Application__c> newCreditApplicationMap,
            Map<ID, Credit_Application__c> oldCreditApplicationMap) {
        
        // If current user is not member of Credit Team then return
        String currentUserProfile = [SELECT Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;
        if (currentUserProfile != 'SunPower Credit') {
            return;
        }
        
        String errorMsg = 'You cannot change value of this field.';
        
        for (ID creditApplicationId : newCreditApplicationMap.keySet()) {
            Credit_Application__c newCreditApplication = newCreditApplicationMap.get(creditApplicationId);
            Credit_Application__c oldCreditApplication = oldCreditApplicationMap.get(creditApplicationId);
            
            // Credit Team cannot change value of following fields
            if (newCreditApplication.Credit_Limit_Requested__c != oldCreditApplication.Credit_Limit_Requested__c) {
                newCreditApplication.Credit_Limit_Requested__c.addError(errorMsg);
            }
            
            if (newCreditApplication.Trade_Reference_1_Company__c != oldCreditApplication.Trade_Reference_1_Company__c) {
                newCreditApplication.Trade_Reference_1_Company__c.addError(errorMsg);
            }
            
            if (newCreditApplication.Trade_Reference_2_Company__c != oldCreditApplication.Trade_Reference_2_Company__c) {
                newCreditApplication.Trade_Reference_2_Company__c.addError(errorMsg);
            }
            
            if (newCreditApplication.Trade_Reference_1_Phone__c != oldCreditApplication.Trade_Reference_1_Phone__c) {
                newCreditApplication.Trade_Reference_1_Phone__c.addError(errorMsg);
            }
            
            if (newCreditApplication.Trade_Reference_2_Phone__c != oldCreditApplication.Trade_Reference_2_Phone__c) {
                newCreditApplication.Trade_Reference_2_Phone__c.addError(errorMsg);
            }
            
            if (newCreditApplication.Bank_Reference_Name__c != oldCreditApplication.Bank_Reference_Name__c) {
                newCreditApplication.Bank_Reference_Name__c.addError(errorMsg);
            }
        }
    }
    
    private static void checkStatus(Map<ID, Credit_Application__c> newCreditApplicationMap,
            Map<ID, Credit_Application__c> oldCreditApplicationMap) {
        
        // If current user is not Partner User then return
        if (UserInfo.getUserType() != 'PowerPartner') {
            return;
        }
        
        ID creAppQueueId = null;
        List<Group> creAppQueue = [Select Id From Group where Name = 'Credit Application Queue'
                and Type = 'Queue'];
        if (creAppQueue.size() > 0) {
            creAppQueueId = creAppQueue[0].Id;
        }
        
        String errorMsg = 'You cannot change Status other than Withdrawn.';
        
        for (ID creditApplicationId : newCreditApplicationMap.keySet()) {
            Credit_Application__c newCreditApplication = newCreditApplicationMap.get(creditApplicationId);
            Credit_Application__c oldCreditApplication = oldCreditApplicationMap.get(creditApplicationId);
            
            // Allow to update status if "Submit" button is clicked
            if (creAppQueueId != null && newCreditApplication.OwnerId == creAppQueueId
                    && newCreditApplication.Status__c == 'Ready for Review') {
                continue;
            }
            
            if (newCreditApplication.Status__c != 'Withdrawn'
                    && newCreditApplication.Status__c != oldCreditApplication.Status__c) {
                newCreditApplication.Status__c.addError(errorMsg);
            }
        }
    }
    
    private static void checkForDuplicate(Map<ID, Credit_Application__c> newCAMap) {
        String baseUrl;
        
        // If current org is SunPower Production then use login domain else cs3
        if (UserInfo.getOrganizationId() == '00D80000000ZF1LEAW') {
            baseUrl = 'https://login.salesforce.com/';
        } else {
            baseUrl = 'https://test.salesforce.com/';
        }
        baseUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/';
        
        // Abbreviation to Word Map (All in UpperCase)
        Map<String, String> apprToWordMap = new Map<String, String>();
        apprToWordMap.put('LLC', 'LIMITED LIABILITY COMPANY');
        apprToWordMap.put('CORP', 'CORPORATION');
        apprToWordMap.put('SYS', 'SYSTEMS');
        apprToWordMap.put('LTD', 'LIMITED');
        apprToWordMap.put('ENG', 'ENGINEERING');
        apprToWordMap.put('ENGG', 'ENGINEERING');
        apprToWordMap.put('PART', 'PARTNERS');
        apprToWordMap.put('DIST', 'DISTRICT');
        apprToWordMap.put('INC', 'INCORPORATED');
        apprToWordMap.put('&', 'AND');
        
        // DO NOT include '.' in below Set
        Set<String> allowedChars = new Set<String>();
        allowedChars.add(' ');
        allowedChars.add(',');
        allowedChars.add('-');
        
        Set<ID> newCAIdsSet = newCAMap.keySet();
        Map<String, DuplicateCA> fullNameToDuplicateCAMap = new Map<String, DuplicateCA>();
        
        List<Credit_Application__c> creAppList = [SELECT Id, Account__c, Legal_Company_Name__c
                FROM Credit_Application__c];
        
        for (Credit_Application__c creApp : creAppList) {
            if (creApp.Account__c == null || creApp.Legal_Company_Name__c == null
                    || creApp.Legal_Company_Name__c == '') {
                continue;
            }
            
            String compName = creApp.Legal_Company_Name__c.trim().toUpperCase();
            
            for (String appr : apprToWordMap.keySet()) {
                Integer apprIndex = compName.indexOf(appr);
                
                while (apprIndex != -1) {
                    Boolean apprFound = true;
                    String substringBeforeAppr = compName.substring(0, apprIndex);
                    String substringAfterAppr = '';
                    Integer indexAfterAppr = apprIndex + appr.length();
                    
                    if (indexAfterAppr < compName.length()) {
                        String charAfterAppr = compName.substring(indexAfterAppr, indexAfterAppr + 1);
                        
                        if (allowedChars.contains(charAfterAppr)) {
                            substringAfterAppr = compName.substring(indexAfterAppr);
                        } else if (charAfterAppr == '.') {
                            if ((indexAfterAppr + 1) < compName.length()) {
                                substringAfterAppr = compName.substring(indexAfterAppr + 1);
                            } else {
                                substringAfterAppr = '';
                            }
                        } else {
                            apprFound = false;
                        }
                    }
                    
                    if (apprFound) {
                        compName = substringBeforeAppr + apprToWordMap.get(appr) + substringAfterAppr;
                    }
                    
                    apprIndex = compName.indexOf(appr, apprIndex + 1);
                }
            }
            
            // Consider "Account" and "Legal Company Name" both
            String fullName = creApp.Account__c + ' - ' + compName;
            DuplicateCA duplicateCA = fullNameToDuplicateCAMap.get(fullName);
            
            if (duplicateCA == null) {
                duplicateCA = new DuplicateCA();
                fullNameToDuplicateCAMap.put(fullName, duplicateCA);
            }
            
            if (newCAIdsSet.contains(creApp.Id)) {
                duplicateCA.newCASet.add(creApp.Id);
            } else {
                duplicateCA.existingCASet.add(creApp.Id);
            }
            
        
        }
        
        List<DuplicateCA> filteredDuplicateCA = new List<DuplicateCA>();
        
        
        for (DuplicateCA duplicateCA : fullNameToDuplicateCAMap.values()) {
            
            
            if (duplicateCA.newCASet.size() > 0
                    && (duplicateCA.newCASet.size() + duplicateCA.existingCASet.size()) > 1) {
                filteredDuplicateCA.add(duplicateCA);
            }
        }
        
        if (filteredDuplicateCA.size() == 0) {
            return;
        }
        
        // Send Email Alert
        String emailBody = 'Possible duplicate CA(s) is/are submitted.';
        
        for (DuplicateCA duplicateCA : filteredDuplicateCA) {
            emailBody += '\n\nNew CA(s):';
            
            for (ID creAppId : duplicateCA.newCASet) {
                emailBody += '\n' + baseUrl + creAppId;
            }
            
            if (duplicateCA.existingCASet.size() == 0) {
                continue;
            }
            
            emailBody += '\nExisting CA(s):';
            
            for (ID creAppId : duplicateCA.existingCASet) {
                emailBody += '\n' + baseUrl + creAppId;
            }
        }
        
        List<String> toAddresses = new List<String>();
        toAddresses.add('johnny.spain@sunpowercorp.com');
        toAddresses.add('anamarie.molano@sunpowercorp.com');
        toAddresses.add('evan.popaduke@sunpowercorp.com');
        
        Messaging.SingleEmailMessage singleEmailMessage = new Messaging.SingleEmailMessage();
        singleEmailMessage.setToAddresses(toAddresses);
        singleEmailMessage.setSubject('Duplicate CA Alert');
        singleEmailMessage.setPlainTextBody(emailBody);
        List<Messaging.SendEmailResult> sendEmailResults =
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{singleEmailMessage}, false);
        
        for (Messaging.SendEmailResult sendEmailResult : sendEmailResults) {
            if (sendEmailResult.isSuccess()) {
                continue;
            }
            
            for (Messaging.SendEmailError error : sendEmailResult.getErrors()) {
                System.debug('Debug: SendEmail Error - ' + error.getMessage());
            }
        }
    }
    
    private class DuplicateCA {
        Set<ID> newCASet;
        Set<ID> existingCASet;
        
        private DuplicateCA() {
            newCASet = new Set<ID>();
            existingCASet = new Set<ID>();
        }
    }
    
    private static void updateFields(List<Credit_Application__c> creditApplicationList){


        /* Get theater info Start */
        List<String> countries = new List<String> ();

        for(Credit_Application__c creditApp : creditApplicationList){
        
            /* Get all countries */
            if(creditApp.Theater__c == null && creditApp.Bill_To_Country__c != null){               
                countries.add(creditApp.Bill_To_Country__c);                    
            }            
            
        }           


        Map<String,String> countryTheaterMap = new Map<String,String> ();
        
        if(countries.size()>0){
            for(Country_Reference__c countryRef : [select Country__c, Theater__c from Country_Reference__c where Country__c in : countries]){                    
                countryTheaterMap.put(countryRef.country__c, countryRef.theater__c);
            }
        }
        /* Get theater info End */
 
 
        
        for(Credit_Application__c creditApp : creditApplicationList){



        /* default address start */
        /* if ship to address is blank, populate with bill to address */
        if (creditApp.Ship_To_Zip__c == null && creditApp.Ship_To_State__c == null
            && creditApp.Ship_To_City__c == null && creditApp.Ship_To_Address__c == null
            && creditApp.Bill_To_Zip__c != null && creditApp.Bill_To_State__c != null
            && creditApp.Bill_To_City__c != null && creditApp.Bill_To_Address__c != null            
            ){
        
            creditApp.Ship_To_Zip__c = creditApp.Bill_To_Zip__c;
            creditApp.Ship_To_State__c = creditApp.Bill_To_State__c;
            creditApp.Ship_To_Country__c = creditApp.Bill_To_Country__c;
            creditApp.Ship_To_City__c = creditApp.Bill_To_City__c;
            creditApp.Ship_To_Address__c = creditApp.Bill_To_Address__c;
                
        } 
        /* default address end */
        
        
        /* default Theater start */
        //Start 00105722
        if(creditApp.Theater__c == null && creditApp.Bill_To_Country__c != null && creditApp.RecordTypeId == nameToCARecordTypeInfoMap.get('NA Credit Application').getRecordTypeId()){
        //End 00105722
            creditApp.Theater__c = countryTheaterMap.get(creditApp.Bill_To_Country__c); 
            
        }
        /* default Theater end */       
        
        
        
        
 
      }         
        
    }       

    
    private static void updateAccountCreditLimit(List<Credit_Application__c> creditApplicationList,
            Map<ID, Credit_Application__c> oldCreditApplicationMap){
         //Start 00105722
         //List<Account> lstAccounts = getAccountList(creditApplicationList);
         Map<Id, Account> mapAccounts = getAccountMap(creditApplicationList);
        //End 00105722
         List<Account> lstUpdateAccounts = new List<Account> ();
        //Start 00105722
        
         if(mapAccounts == null || mapAccounts.values() == null || mapAccounts.values().size()==0) return;
         for(Credit_Application__c credit : creditApplicationList){
            if(credit.Theater__c == null && credit.RecordTypeId == nameToCARecordTypeInfoMap.get('EU Credit Application').getRecordTypeId()
                && mapAccounts.get(credit.Account__c) != null){
                credit.Theater__c = mapAccounts.get(credit.Account__c).Theater__c;
            }
         }
         //for(Account acc:lstAccounts){
         for(Account acc : mapAccounts.values()){
         //End 00105722   
            boolean updateAccount = false; 
            
            for(Credit_Application__c credit:creditApplicationList){
                
                //condition to match account id
                if(credit.Account__c !=null && acc.Id == credit.Account__c){
                    
                    // Set "Credit Limit" and "Credit Limit Date" of Partner Account
                    // if the CA has a "Credit Limit" and its Status is updated to "Approved"
                    if (credit.Credit_Limit__c != null && credit.Status__c == 'Approved'
                            && (oldCreditApplicationMap == null
                            || oldCreditApplicationMap.get(credit.Id).Status__c != 'Approved')) {
                        
                        acc.Credit_Limit__c = credit.Credit_Limit__c;
                        acc.Credit_Limit_Date__c = Date.today();
                        updateAccount = true;
                    }
                    /**************************************/
                    
                    if(acc.Status__c == 'Contract Pending'){
                        
                        if(credit.Notarized_Personal_Guaranty__c
                            && !acc.Signed_and_Notarized_Personal_Guaranty__c) {
                                
                            acc.Signed_and_Notarized_Personal_Guaranty__c = true;
                            
                            updateAccount=true;                             
                        }   
                        
                        if(credit.Resale_Certificate_Form__c 
                            && !acc.Resale_Certificate__c){ 
                           
                            acc.Resale_Certificate__c = true;
                            
                            updateAccount=true;                             
                        }
                        
                        if(credit.Status__c == 'Ready for Review'
                            && !acc.Completed_and_Signed_Credit_Application__c){
                            
                            acc.Completed_and_Signed_Credit_Application__c = true;                              
                            updateAccount=true;                             
                        }   
                        
                    }//end-if Contract Pending
                    
                }//end-if [acc.Id == credit.Account__c] 
                
            }//end-for creditApplicationList
            
            if (updateAccount)
                lstUpdateAccounts.add(acc);
                    
            
         }//end-for lstAccounts
         
         if (lstUpdateAccounts.size()>0)
            update lstUpdateAccounts;
                
 
        
    }//function end
    //Start 00105722
    private static Map<Id, Account> getAccountMap(List<Credit_Application__c> creditApplicationList){      
      //holds Account Ids to fetch      
      Set<Id> setAccountIds = new Set<Id>();                   
      for(Credit_Application__c creditAppObj : creditApplicationList){
         if (creditAppObj.Account__c != null)    
            setAccountIds.add(creditAppObj.Account__c);
      }
      //return, if no Ids in set
      if(setAccountIds.size() == 0) return null;
      return new Map<Id, Account>([select Id, Resale_Certificate__c, Credit_Limit__c, Credit_Limit_Date__c, Completed_and_Signed_Credit_Application__c,
            Signed_and_Notarized_Personal_Guaranty__c,Status__c, Theater__c from Account where Id in : setAccountIds]); 
      
    }    
    //End 00105722
    private static void setRSMField(List<Credit_Application__c> creditApplicationList){  
            
      //holds Account Ids to fetch      
      Set<Id> setAccountIds = new Set<Id>();
      
      //holds Account objects
      List<Account> lstAccountObj = new List<Account>();
       
      //holds Id of CreditApplication object as key and its Account id as value
      Map<Id, Id> mapCreditAccount = new Map<Id, Id>();
      
      Map<Id, Account> mapAccountObj = new Map<Id, Account>();
      
      for(Credit_Application__c creditAppObj : creditApplicationList){        
        //proceed to fill RSM field only if it's null
        if(creditAppObj.RSM__c == null){          
          if(creditAppObj.Account__c != null){
            setAccountIds.add(creditAppObj.Account__c);
            mapCreditAccount.put(creditAppObj.Id, creditAppObj.Account__c);
          }
        }
      }      
      
      //return, if no Ids in set
      if(setAccountIds.size() <= 0){
        return;
      }
      
      lstAccountObj = [select Id, Name, RSM__c,Country_Domain__c
        from Account 
        where RSM__c != null AND Id in : setAccountIds];      
      
      //return if no objects in list
      if(lstAccountObj.size() <= 0){
        
        return;
      }
      
      for(Account accountObj : lstAccountObj){
        mapAccountObj.put(accountObj.Id, accountObj);
      }
      
      for(Credit_Application__c creditAppObj : creditApplicationList){
       
        if(mapCreditAccount.containsKey(creditAppObj.Id)){

          string accountId = mapCreditAccount.get(creditAppObj.Id);
          if(mapAccountObj.containsKey(accountId)){
            Account accountObj = mapAccountObj.get(accountId);
            creditAppObj.RSM__c = accountObj.RSM__c;
          
        }// if end
      } //for end
     }//if end
      
    }//end of function  
    private static void updateInstructions(List<Credit_Application__c> creditApplicationList, Map<ID, Credit_Application__c> oldCreditApplicationMap, Boolean isInsert){
        Set<String> accountsIdSet = new Set<String>();
        for (Credit_Application__c creApp : creditApplicationList) {
            if(!isInsert){
                String oldStatus = oldCreditApplicationMap.get(creApp.Id).Status__c;
                if(oldStatus != creApp.Status__c && creApp.CreatedById !='00580000001zGxpAAE'){//change before moving to prod
                    if(creApp.Status__c == 'Evaluation On Hold - Missing Documentation'
                        ||creApp.Status__c == 'Waiting for Partner'){
                            creApp.OwnerId = creApp.CreatedById;
                        }
                }
            }            
        }
    }
}