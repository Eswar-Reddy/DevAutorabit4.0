public class SPVTCaseNotification {


    public static void setDealerInstallerNotification(Map <Integer, Case> qualifyMap) {
        CustomSetting cs = getCustomSetting();

        Set <String> partnerIdSet = new Set <String>();
        for (Case c : qualifyMap.values()) {  
            if (c.Partner_Name__c != null) {
                partnerIdSet.add(c.Partner_Name__c);
            }
        }

        Map <String, Account> partnerMap = new Map <String, Account>();
        if (partnerIdSet.size() > 0 && cs.contactRoleSet.size() > 0) {
            for (Account a : [SELECT Id, Name, Status__c, (SELECT Id, ContactId FROM AccountContactRoles 
                    WHERE Role IN :cs.contactRoleSet AND Contact.Email != null) 
                FROM Account WHERE Id IN :partnerIdSet]) {
                partnerMap.put(a.Id, a);            
            }
        }

        for (Case c : qualifyMap.values()) {   
            c.Dealer_Installer_Notification__c = true; 
            if (c.Partner_Name__c != null) {
                if (partnerMap.containsKey(c.Partner_Name__c)) {
                    Account partner = partnerMap.get(c.Partner_Name__c);
                    if (cs.spdAccountName != partner.Name && partner.Status__c == 'Active' &&
                            partner.AccountContactRoles != null && partner.AccountContactRoles.size() > 0) {
                        c.Dealer_Installer_Notification__c = false;
                    }
                }
            }
        }

    }
    
    public static SendEmailResponse sendEmail(Map <Integer, Case> qualifyMap) {
        CustomSetting cs = getCustomSetting();
        if (String.IsBlank(cs.templateId)) {
            return null;
        }

        Set <String> caseIdSet = new Set <String>();
        Set <String> partnerIdSet = new Set <String>();
        for (Case c : qualifyMap.values()) {  
            if (c.Id != null) {
                caseIdSet.add(c.Id);
            }  
            if (c.Partner_Name__c != null) {
                partnerIdSet.add(c.Partner_Name__c);
            }
        }
        
        Map <String, Case> caseMap = new Map <String, Case>();
        if (caseIdSet.size() > 0) {
            for (Case c : [SELECT Id, Residential_Field_Supervisor__r.Email, Area_Sales_Manager__r.Email, RSM__r.Email
                    FROM Case WHERE Id IN :caseIdSet]) {
                caseMap.put(c.Id, c);                            
            }
        }
        
        Map <String, Account> partnerMap = new Map <String, Account>();
        if (partnerIdSet.size() > 0 && cs.contactRoleSet.size() > 0) {
            for (Account a : [SELECT Id, Name, Status__c, (SELECT Id, ContactId, Contact.FirstName, Contact.LastName, Contact.Name
                    FROM AccountContactRoles 
                    WHERE Role IN :cs.contactRoleSet AND Contact.Email != null) 
                FROM Account WHERE Id IN :partnerIdSet]) {
                partnerMap.put(a.Id, a);            
            }
        }
        
        List <Messaging.SingleEmailMessage> emailList = new List <Messaging.SingleEmailMessage>();
        for (Case c : qualifyMap.values()) {    
            if (c.Partner_Name__c != null) {
                if (partnerMap.containsKey(c.Partner_Name__c)) {
                    Account partner = partnerMap.get(c.Partner_Name__c);
                    // for spd partner or inactive non spd partner, notification is sent to Trevor Williams through workflow
                    // refer method setDealerInstallerNotification in this clase. This sets flag Dealer_Installer_Notification__c
                    // to invoke workflow
                    if (partner.Name == cs.spdAccountName) {
                        continue;
                    } else if (partner.Status__c != 'Active') {
                        continue;
                    }
                    if (partner.AccountContactRoles != null) {
                        Set <String> ccAddressSet = new Set <String>();
                        if (caseMap.containsKey(c.Id)) {
                            ccAddressSet.add(caseMap.get(c.Id).Residential_Field_Supervisor__r.Email);
                            ccAddressSet.add(caseMap.get(c.Id).Area_Sales_Manager__r.Email);
                            ccAddressSet.add(caseMap.get(c.Id).RSM__r.Email);
                        }
                        if (cs.additionalEmailSet.size() > 0) {
                            ccAddressSet.addAll(cs.additionalEmailSet);
                        }
                        ccAddressSet.remove(null);
                        
                        for (AccountContactRole acr : partner.AccountContactRoles) {
                            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    
                            if (ccAddressSet.size() > 0) {
                                email.setCcAddresses(new List <String>(ccAddressSet));
                            }
                            if (String.IsNotBlank(cs.orgWideEmailAddressId)) {
                                email.setOrgWideEmailAddressId(cs.orgWideEmailAddressId);
                            }
                            email.setTemplateId(cs.templateId);
                            email.setTargetObjectId(acr.ContactId);
                            email.setWhatId(c.Id);
                            emailList.add(email);
                        }
                    }
                }
            }
        }
        
        List <Messaging.SendEmailResult> resultList = new List <Messaging.SendEmailResult>();
        List <Messaging.SendEmailError> errorList = new List <Messaging.SendEmailError>();
        if (emailList.size() > 0) {
            resultList = Messaging.sendEmail(emailList, false);
            for (Messaging.SendEmailResult result : resultList) {
                system.debug('result.isSuccess(): ' + result.isSuccess());
                if (result.isSuccess() == false) {
                    errorList = result.getErrors();
                    for (Messaging.SendEmailError error : errorList) {
                        system.debug('error.getFields():' + error.getFields()); 
                        system.debug('error.getMessage():' + error.getMessage()); 
                        system.debug('error.getStatusCode():' + error.getStatusCode()); 
                        system.debug('error.getTargetObjectId():' + error.getTargetObjectId()); 
                    }
                }
            }
        }
    
        // return 
        SendEmailResponse response = new SendEmailResponse();
        response.emailList = emailList;
        response.resultList = resultList;
        response.errorList = errorList;
        return response;
    }
    
    private static CustomSetting getCustomSetting() {
        CustomSetting cs = new CustomSetting();
        for (SPVT_Settings__c setting : SPVT_Settings__c.getAll().values()) {
            if (setting.Value__c != null) {
                if (setting.Name.equalsIgnoreCase('SPVT_Fail_Case_EmailTemplateId')) {
                    cs.templateId = setting.Value__c;
                } else if (setting.Name.equalsIgnoreCase('SPVT_Fail_Case_OrgWideEmailAddressId')) {
                    cs.orgWideEmailAddressId = setting.Value__c;
                } else if (setting.Name.startsWithIgnoreCase('SPVT_Fail_Case_AdditionalEmail_')) {
                    cs.additionalEmailSet.add(setting.Value__c);
                } else if (setting.Name.equalsIgnoreCase('SPVT_Fail_SPD_Account_Name')) {
                    cs.spdAccountName = setting.Value__c;
                } else if (setting.Name.startsWithIgnoreCase('SPVT_Fail_Case_ContactRole_')) {
                    cs.contactRoleSet.add(setting.Value__c);
                }
                
            }
        }

        return cs;    
    }
    
    public class SendEmailResponse {
        public List <Messaging.SingleEmailMessage> emailList = new List <Messaging.SingleEmailMessage>();
        public List <Messaging.SendEmailResult> resultList = new List <Messaging.SendEmailResult>();
        public List <Messaging.SendEmailError> errorList = new List <Messaging.SendEmailError>();
    }
    
    private class CustomSetting {
        private String templateId;     
        private String orgWideEmailAddressId;
        private Set <String> additionalEmailSet = new Set <String>();    
        private String spdAccountName;     
        private Set <String> contactRoleSet = new Set <String>();    
    }

}