public class ServiceRequestEmail {
    @TestVisible private static List <Request> emailRequestList;
    @TestVisible private static List <Response> emailResponseList;
    
    public static List <Response> sendEmail(Map<Integer, WorkOrder> emailNotificationMap) {
        String userKeyPrefix = User.SObjectType.getDescribe().getKeyPrefix();
        emailRequestList = new List <Request>();
        CustomSetting cs = getCustomSetting();
        Set <String> srIdSet = new Set <String>();
        for (WorkOrder sr : emailNotificationMap.values()) {
            if (sr.Id != null) {
                srIdSet.add(sr.Id);
            }
        }
        if (srIdSet.size() > 0) {
            List <WorkOrder> srList = [SELECT Id, CreatedBy.Name, LastModifiedBy.Name,
                    Description,
                    OwnerId, 
                    Priority,
                    Requested_Date__c,
                    Subject, 
                    WorkOrderNumber 
                FROM WorkOrder WHERE Id IN :srIdSet];
            
            // owner id -> SR list
            Map <String, List <WorkOrder>> ownerId_srList_map = new Map <String, List <WorkOrder>>();
            for (WorkOrder sr : srList) {
                List <WorkOrder> srs = new List <WorkOrder>();
                if (ownerId_srList_map.containsKey(sr.OwnerId)) {
                    srs = ownerId_srList_map.get(sr.OwnerId);
                } 
                srs.add(sr);
                ownerId_srList_map.put(sr.OwnerId, srs);
            }
            
            Set <String> userIdSet = new Set <String>();
            if (ownerId_srList_map.size() > 0) {
                userIdSet.addAll(ownerId_srList_map.keySet());
                
                // if the SR owner is queue send email to queue email address
                List <Group> grpList = [SELECT Id, DeveloperName, Email FROM Group WHERE Id = :ownerId_srList_map.keySet()];
                for (Group grp : grpList) {
                    if (ownerId_srList_map.containsKey(grp.Id)) {
                        List <WorkOrder> srs = ownerId_srList_map.get(grp.Id);
                        for (WorkOrder sr : srs) {
                            Request req = getEmailRequest(grp, sr, cs);
                            if (req != null) {
                                emailRequestList.add(req);
                            }
                        }
                    }
                }
                
                // queue id -> user/group id set
                Map <String, Set <String>> qId_uIdSet_map = new Map <String, Set <String>>();
                for (GroupMember gm : [SELECT GroupId, UserOrGroupId FROM GroupMember WHERE GroupId = :ownerId_srList_map.keySet()]) {
                    Set <String> uIdSet = new Set <String>();
                    if (qId_uIdSet_map.containsKey(gm.GroupId)) {
                        uIdSet = qId_uIdSet_map.get(gm.GroupId);
                    } 
                    String userOrGroupId = gm.UserOrGroupId;
                    if (userOrGroupId.startsWith(userKeyPrefix)) {
                        uIdSet.add(userOrGroupId);
                    }
                    qId_uIdSet_map.put(gm.GroupId, uIdSet);   
                }
                
                for (Set <String> uIdSet : qId_uIdSet_map.values()) {
                    userIdSet.addAll(uIdSet);
                }
                if (userIdSet.size() > 0) {
                    Map <String, User> uMap = new Map <String, User>();
                    for (User u :  [SELECT Id, UserName, Profile.Name, UserRole.Name FROM User WHERE Id IN :userIdSet]) {
                        uMap.put(u.Id, u);
                    }
                    
                    for (String ownerId : ownerId_srList_map.keySet()) {
                        List <WorkOrder> srs = ownerId_srList_map.get(ownerId);
                        if (uMap.containsKey(ownerId)) {
                            // if the SR owner is user send email
                            User u = uMap.get(ownerId);
                            for (WorkOrder sr : srs) {
                                Request req = getEmailRequest(u, sr, cs);
                                if (req != null) {
                                    emailRequestList.add(req);
                                }
                            }
                        } else if (qId_uIdSet_map.containsKey(ownerId)) {
                            // if SR owner is queue send email to queue members
                            Set <String> uIdSet = qId_uIdSet_map.get(ownerId);
                            for (String uId : uIdSet) {
                                if (uMap.containsKey(uId)) {
                                    // if the SR owner is user send email
                                    User u = uMap.get(uId);
                                    for (WorkOrder sr : srs) {
                                        Request req = getEmailRequest(u, sr, cs);
                                        if (req != null) {
                                            emailRequestList.add(req);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }
        } 
        
        List <Response> resList = new List <Response>();
        if (emailRequestList.size() > 0) {
            resList = sendEmail(emailRequestList);
            for (Response res : resList) {
                if (res.isSuccess == false) {
                    String errMsg = 'Error: ' + res.message + '. fields: ' + res.fields + '. statusCode' + res.statusCode; 
                    errMsg += '. targetObjectId: ' + res.targetObjectId;
                    system.debug(errMsg);                   
                }
            }                
        }   
        emailResponseList = resList;    // to use in test class
        return resList;        
    }

    private static List <Response> sendEmail(List <Request> reqList) {
        List <Response> resList = new List <Response>(); 
        
        List <Messaging.SingleEmailMessage> mailList = new List <Messaging.SingleEmailMessage>();
        for (Request req : reqList) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
            if (req.toAddresses.size() > 0) {
                mail.setToAddresses(req.toAddresses);
            }
            if (String.IsNotBlank(req.subject)) { 
                mail.setSubject(req.subject);
            } 
            if (String.IsNotBlank(req.plainTextBody)) {
                mail.setPlainTextBody(req.plainTextBody);
            }  
            if (String.IsNotBlank(req.htmlBody)) {
                mail.setHtmlBody(req.htmlBody);
            }  
            if (String.IsNotBlank(req.targetObjectId)) { 
                mail.setTargetObjectId(req.targetObjectId);
            }   
            if (String.IsNotBlank(req.whatId)) {     
                mail.setWhatId(req.whatId); 
            }  
            if (String.IsNotBlank(req.orgWideEmailAddressId)) {     
                mail.setOrgWideEmailAddressId(req.orgWideEmailAddressId);  
            } 
            if (String.IsNotBlank(req.templateId)) {     
                mail.setTemplateId(req.templateId); 
            }
            mail.setSaveAsActivity(req.saveAsActivity);
            
            mailList.add(mail);       
        
        } 
        
        if (mailList.size() > 0) {
            Messaging.SendEmailResult[] resultList = Messaging.sendEmail(mailList, false);
            for (Messaging.SendEmailResult result : resultList) {
                Response res = new Response();
                res.isSuccess = result.isSuccess();
                if (result.isSuccess()) {
                
                } else {
                    Messaging.SendEmailError[] errorList = result.getErrors();
                    List <String> messageList = new List <String>();
                    for (Messaging.SendEmailError error : errorList) {
                        res.fields.addAll(error.getFields());
                        messageList.add(error.getMessage());
                        
                        if (String.IsNotBlank(error.targetObjectId)) {
                            res.targetObjectId = error.getTargetObjectId();
                        }
                        res.statusCode = error.getStatusCode();    // getting the last code ?
                    }
                    res.message = String.join(messageList, ',');
                }
                
                resList.add(res);
            }        
        }
    
        return resList;    
    }

    private static Request getEmailRequest(User u, WorkOrder sr, CustomSetting cs) {
        Request req; 
        
        Boolean emailPref = false;
        if (u.Profile.Name != null && cs.emailPrefUserProfileSet.contains(u.Profile.Name.toLowerCase())) {
            emailPref = true;
        } else if (u.UserRole.Name != null && cs.emailPrefUserRoleSet.contains(u.UserRole.Name.toLowerCase())) {
            emailPref = true;
        } else if (u.UserName != null && cs.emailPrefUserNameSet.contains(u.UserName.toLowerCase())) {
            emailPref = true;
        }   

        if (emailPref == true) { 
            req = new Request();
            req.targetObjectId = u.Id;
            // WhatId is not available for sending emails to UserIds. using vf template as workaround
            req.whatId = sr.Id;
            req.templateId = cs.emailTemplateIdNewSR;
            if (String.IsNotBlank(cs.orgWideEmailAddressId)) {
                req.orgWideEmailAddressId = cs.orgWideEmailAddressId;
            }
            req.saveAsActivity = false;    // saveAsActivity must be false when sending mail to users
        }

        return req;    
    }
    
    private static Request getEmailRequest(Group grp, WorkOrder sr, CustomSetting cs) {
        Request req;    

        Boolean emailPref = false;
        if (String.IsNotBlank(grp.DeveloperName) && cs.emailPrefQueueNameSet.contains(grp.DeveloperName.toLowerCase())) {
            if (String.IsNotBlank(grp.Email)) {
                emailPref = true;
            }
        }
        
        if (emailPref == true) {
            req = new Request();
            req.toAddresses = new List <String>{grp.Email};
            req.subject = getSubject(sr);
            req.htmlBody = getHtmlBody(sr); 
            if (String.IsNotBlank(cs.orgWideEmailAddressId)) {
                req.orgWideEmailAddressId = cs.orgWideEmailAddressId;
            }
            req.saveAsActivity = false;    // saveAsActivity must be false when sending mail to users
        }

        return req;    
    }
    
    private static String getSubject(WorkOrder sr) {
        String subject = 'SR# ';
        
        if (sr != null) {
            subject += sr.WorkOrderNumber + ' is created ' + sr.Subject;
        }
        
        return subject;    
    }

    private static String getHtmlBody(WorkOrder sr) {
        String body;
        
        if (sr != null) {
            body = '';
            body += '<b>' + sr.LastModifiedBy.Name + '</b>' + ' has assigned you the following Service Request: ' + '<br/><br/>';

            body += '<b>Priority:</b>&nbsp;' + sr.Priority + '<br/>';
            body += '<b>Due Date:</b>&nbsp;' + sr.Requested_Date__c + '<br/>';
            body += '<b>Service Request#:</b>&nbsp;' + sr.WorkOrderNumber + '<br/>';
            body += '<b>Service Request Subject:</b>&nbsp;' + sr.Subject + '<br/>';
            body += '<b>Description:</b>&nbsp;' + sr.Description + '<br/><br/>';

            body += 'For more details, click the following link: <br/>';
            body += '<a href="' + URL.getSalesforceBaseURL().toExternalForm() + '/' + sr.Id + '">' + sr.WorkOrderNumber + '</a>';
        }
        
        return body;    
    }

    private static CustomSetting getCustomSetting() {
        CustomSetting cs = new CustomSetting();
        List <Service_Request_Settings__c> settingList = [SELECT Name, Default_Value__c 
            FROM Service_Request_Settings__c 
            WHERE Name LIKE 'SR_%'
            ORDER BY Name ASC];    
        for (Service_Request_Settings__c setting : settingList) {
            if (String.IsNotBlank(setting.Default_Value__c)) {
                if (setting.Name.startsWithIgnoreCase('SR_EmailPref_UserLogin_')) {
                    cs.emailPrefUserNameSet.add(setting.Default_Value__c.toLowerCase());
                } else if (setting.Name.startsWithIgnoreCase('SR_EmailPref_UserProfile_')) {
                    cs.emailPrefUserProfileSet.add(setting.Default_Value__c.toLowerCase());
                } else if (setting.Name.startsWithIgnoreCase('SR_EmailPref_UserRole_')) {
                    cs.emailPrefUserRoleSet.add(setting.Default_Value__c.toLowerCase());
                } else if (setting.Name.startsWithIgnoreCase('SR_EmailPref_QueueName_')) {
                    cs.emailPrefQueueNameSet.add(setting.Default_Value__c.toLowerCase());
                } else if (setting.Name.equalsIgnoreCase('SR_EmailTemplateId_NewSR')) {
                    cs.emailTemplateIdNewSR = setting.Default_Value__c;
                } else if (setting.Name.equalsIgnoreCase('SR_OrgWideEmailAddressId')) {
                    cs.orgWideEmailAddressId = setting.Default_Value__c;
                }           
            }        
        
        } 
        return cs;        
    }
    
    private class CustomSetting {
        private set <String> emailPrefUserNameSet = new Set <String>();
        private set <String> emailPrefUserProfileSet = new Set <String>();
        private set <String> emailPrefUserRoleSet = new Set <String>();
        private set <String> emailPrefQueueNameSet = new Set <String>();
        private String emailTemplateIdNewSR;
        private String orgWideEmailAddressId;
    }

    public class Request {
        public List <String> toAddresses;
        public String subject;
        public String plainTextBody;
        public String htmlBody;
        public String targetObjectId;
        public String whatId;
        public String orgWideEmailAddressId;
        public String templateId;
        public Boolean saveAsActivity; 
        public Request() {
            toAddresses = new List <String>();
            saveAsActivity = false;
        }   
    }
    
    public class Response {
        public Boolean isSuccess;
        public List <String> fields;
        public String message;
        public System.StatusCode statusCode;
        public String targetObjectId; 
        public Response() {
            fields = new List <String>();
        }   
    }

}