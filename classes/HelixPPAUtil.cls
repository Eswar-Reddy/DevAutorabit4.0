public class HelixPPAUtil {

//--------------------------------------------------------------------
// SavePPA
//--------------------------------------------------------------------
     public static SavePPAResponse savePPA(SavePPARequest request) {
        SavePPAResponse response = new SavePPAResponse();
        
        String errorMessage = '';
        if (request != null) {
            if (request.quote != null) {
                if (request.quote.Id != null) {
                    Savepoint sp = Database.setSavepoint();
                    try {
                        if (request.ExpirationDate != null && request.ExpirationDate != '') {
                            request.quote.ExpirationDate = Date.valueOf(request.ExpirationDate);
                        }
                        
                        update request.quote;
                        // this condition prevents deleting existing records when not clicking calculate savings and try to save quote
                        if (request.annualFinancialList != null && request.annualFinancialList.size() > 0) {
                            // delete existing items
                            List <Annual_Financial__c> afList = [SELECT Id FROM Annual_Financial__c WHERE Quote__c = :request.quote.Id];
                            if (afList.size() > 0) {
                                delete afList;
                            }
                            // insert new items
                            Id recordTypeId;
                            for(RecordType t : [SELECT Id FROM RecordType WHERE sObjectType = 'Annual_Financial__c' And DeveloperName = 'Commercial']) {
                                recordTypeId = t.id;
                                break;
                            }
                            if(recordTypeId != null) {
                                for(Annual_Financial__c a :  request.annualFinancialList) {
                                    a.RecordTypeId = recordTypeId;
                                }
                            }
                            insert request.annualFinancialList;
                        }
                        response.isSuccess = true;
                    } catch(Exception e) {
                        errorMessage = 'Error while updating quote: ' + e.getMessage();
                        Database.rollback(sp);
                    }
                } else {
                    errorMessage = 'Error: request.quote.Id is null';
                }
            } else {
                errorMessage = 'Error: request.quote is null';
            }
        } else {
            errorMessage = 'Error: request is null';
        }
        
        response.errorMessage = errorMessage;
        return response;
    }
    public class SavePPARequest {
        public Quote quote;
        public String ExpirationDate;
        public List <Annual_Financial__c> annualFinancialList;
    }
    public class SavePPAResponse {
        public Boolean isSuccess;
        public String errorMessage;
        public SavePPARequest request;
        public SavePPAResponse() {
            this.isSuccess = false;
        }
    }

//--------------------------------------------------------------------
// sendDesignValidationEmail
//--------------------------------------------------------------------

    public static EmailResponse sendDesignValidationEmail(List <Design__c> designList) {
        EmailResponse response = new EmailResponse(); 
        
        if (designList == null) {
            response.errorMessage = 'designList is null';
            return response;
        } else if (designList.size() == 0) {
            response.errorMessage = 'designList.size() is 0';
            return response;
        }

        response.requestCount = designList.size();
        Boolean isSandbox = isRunningInSandbox();
        String orgWideEmailAddressId = getOrgWideEmailAddressId('systemdesign.na@sunpowercorp.com');
        List <String> emailAddresses = getToEmailAddresses(isSandbox ? 'PPA_Quote_Sandbox' : 'PPA_Quote');
        List <Messaging.SingleEmailMessage> emailList = new List <Messaging.SingleEmailMessage>();  
        
        for (Design__c design : designList) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setOrgWideEmailAddressId(orgWideEmailAddressId);
            email.setToAddresses(emailAddresses);
            email.setSubject('Problem with PPA Quote for Opportunity: ' + design.Opportunity__r.Name);
            String html =
            '<html>' +
                '<body>' +
                    'CVAR Design Support team,' +
                    '<br/><br/>' +
                    'There has been a problem with the following Opportunity: ' +
                    '<a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + design.Opportunity__c + '">' + design.Opportunity__r.Name + '</a>' +
                    '<br/><br/>' +
                    'A dealer has attempted to create a PPA quote with this design: ' +
                    '<a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + design.Id + '">' + design.Name + '</a>' +
                    ' but the design does not have an acceptable technology system.' +
                    '<br/><br/>' +
                    ' Please access the design and select a different technology system.' +
                    '<br/><br/></br/>' +
                    'Thanks,' +
                    '<br/>' +
                    'The Digital Support team' +
                '</body>' +
            '</html>';
            email.setHtmlBody(html);
            emailList.add(email);
        }        

        if (emailList.size() > 0) {
            List <Messaging.SendEmailResult> resultList = new List <Messaging.SendEmailResult>();
            try {
                resultList = Messaging.sendEmail(emailList, false);
            } catch(Exception e) {
                response.errorMessage = e.getMessage(); 
                return response;
            }
            
            String errMsg = '';
            for (Messaging.SendEmailResult result : resultList) {
                if (result.isSuccess() == false) {
                    for (Messaging.SendEmailError error : result.getErrors()) {
                        errMsg += ' error.getFields():' + error.getFields();
                        errMsg += ' error.getMessage():' + error.getMessage();
                        errMsg += ' error.getStatusCode():' + error.getStatusCode();
                    }
                } else {
                    response.successCount++;
                }
            }
            response.errorMessage = errMsg;
        } else {
            response.errorMessage = 'emailList.size() is 0';
        }
        
        if (response.successCount > 0) {
            response.isSuccess = true;
        } 
            
        return response;    
    }
    
//--------------------------------------------------------------------
//
//--------------------------------------------------------------------    
    public static EmailResponse sendProductionDataValidationEmail(List<Design__c> designList) {
        EmailResponse response = new EmailResponse();
        
        if (designList == null) {
            response.errorMessage = 'designList is null';
            return response;
        } else if (designList.size() == 0) {
            response.errorMessage = 'designList.size() is 0';
            return response;
        }

        response.requestCount = designList.size();
        Boolean isSandbox = isRunningInSandbox();
        String orgWideEmailAddressId = getOrgWideEmailAddressId('systemdesign.na@sunpowercorp.com');
        List <String> emailAddresses = getToEmailAddresses(isSandbox ? 'PPA_Quote_Sandbox' : 'PPA_Quote');
        List <Messaging.SingleEmailMessage> emailList = new List <Messaging.SingleEmailMessage>();          
        
        for (Design__c design : designList) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setOrgWideEmailAddressId(orgWideEmailAddressId);
            email.setToAddresses(emailAddresses);            
            email.setSubject('Problem with PPA Quote for Opportunity Name: ' + design.Opportunity__r.Name);
            String html =
            '<html>' +
                '<body>' +
                    'CVAR Design Support team,' +
                    '<br/><br/>' +
                    'There has been a problem with the following Opportunity: ' +
                    '<a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + design.Opportunity__c + '">' + design.Opportunity__r.Name + '</a>' +
                    '<br/><br/>' +
                    'A dealer has attempted to create a PPA quote with this design: ' +
                    '<a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + design.Id + '">' + design.Name + '</a>' +
                    ' but the sum of the design monthly production data is not equal to the annual production.' +
                    '<br/><br/>' +
                    ' Please access the design and correct these values.' +
                    '<br/><br/></br/>' +
                    'Thanks,' +
                    '<br/>' +
                    'The Digital Support team' +
                '</body>' +
            '</html>';
            email.setHtmlBody(html);
            emailList.add(email);
        }        

        if (emailList.size() > 0) {
            List <Messaging.SendEmailResult> resultList = new List <Messaging.SendEmailResult>();
            try {
                resultList = Messaging.sendEmail(emailList, false);
            } catch(Exception e) {
                response.errorMessage = e.getMessage(); 
                return response;
            }
            
            String errMsg = '';
            for (Messaging.SendEmailResult result : resultList) {
                if (result.isSuccess() == false) {
                    for (Messaging.SendEmailError error : result.getErrors()) {
                        errMsg += ' error.getFields():' + error.getFields();
                        errMsg += ' error.getMessage():' + error.getMessage();
                        errMsg += ' error.getStatusCode():' + error.getStatusCode();
                    }
                } else {
                    response.successCount++;
                }
            }
            response.errorMessage = errMsg;
        } else {
            response.errorMessage = 'emailList.size() is 0';
        }
        
        if (response.successCount > 0) {
            response.isSuccess = true;
        } 
        
        return response;
    }

//--------------------------------------------------------------------
//
//--------------------------------------------------------------------    
    public static EmailResponse sendMissingDataValidationEmail(Set<Design__c> designSet) {
        EmailResponse response = new EmailResponse();
        
        if (designSet == null) {
            response.errorMessage = 'designSet is null';
            return response;
        } else if (designSet.size() == 0) {
            response.errorMessage = 'designSet.size() is 0';
            return response;
        }

        response.requestCount = designSet.size();
        Boolean isSandbox = isRunningInSandbox();
        String orgWideEmailAddressId = getOrgWideEmailAddressId('systemdesign.na@sunpowercorp.com');
        List <String> emailAddresses = getToEmailAddresses(isSandbox ? 'PPA_Quote_Sandbox' : 'PPA_Quote');
        List <Messaging.SingleEmailMessage> emailList = new List <Messaging.SingleEmailMessage>();          
        
        for (Design__c design : designSet) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setOrgWideEmailAddressId(orgWideEmailAddressId);
            email.setToAddresses(emailAddresses);            
            email.setSubject('Problem with PPA Quote for Opportunity Name: ' + design.Opportunity__r.Name);
            String html =
            '<html>' +
                '<body>' +
                    'CVAR Design Support team,' +
                    '<br/><br/>' +
                    'There has been a problem with the following Opportunity: ' +
                    '<a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + design.Opportunity__c + '">' + design.Opportunity__r.Name + '</a>' +
                    '<br/><br/>' +
                    'A dealer has attempted to create a PPA quote with this design: ' +
                    '<a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + design.Id + '">' + design.Name + '</a>' +
                    ' but the design is missing some of the following critical data: module quantity, monthly production data, annual production data, actual system size.' +
                    '<br/><br/>' +
                    ' Please access the design and correct these values.' +
                    '<br/><br/></br/>' +
                    'Thanks,' +
                    '<br/>' +
                    'The Digital Support team' +
                '</body>' +
            '</html>';
            email.setHtmlBody(html);
            emailList.add(email);
        }        

        if (emailList.size() > 0) {
            List <Messaging.SendEmailResult> resultList = new List <Messaging.SendEmailResult>();
            try {
                resultList = Messaging.sendEmail(emailList, false);
            } catch(Exception e) {
                response.errorMessage = e.getMessage(); 
                return response;
            }
            
            String errMsg = '';
            for (Messaging.SendEmailResult result : resultList) {
                if (result.isSuccess() == false) {
                    for (Messaging.SendEmailError error : result.getErrors()) {
                        errMsg += ' error.getFields():' + error.getFields();
                        errMsg += ' error.getMessage():' + error.getMessage();
                        errMsg += ' error.getStatusCode():' + error.getStatusCode();
                    }
                } else {
                    response.successCount++;
                }
            }
            response.errorMessage = errMsg;
        } else {
            response.errorMessage = 'emailList.size() is 0';
        }
        
        if (response.successCount > 0) {
            response.isSuccess = true;
        } 
        
        return response;
    }
    
//--------------------------------------------------------------------
// EmailResponse
//--------------------------------------------------------------------
    public class EmailResponse {
        public Boolean isSuccess;
        public Integer requestCount;
        public Integer successCount;
        public String errorMessage;
        public EmailResponse() {
            this.isSuccess = false;
            this.requestCount = 0;
            this.successCount = 0;
        }
    }
    
//--------------------------------------------------------------------
// static methods
//--------------------------------------------------------------------
    private static String getOrgwideEmailAddressId(String emailAddress) {
        String orgWideEmailAddressId;
        if (String.IsNotBlank(emailAddress)) {
            List <OrgWideEmailAddress> owaList = [select Id, Address from OrgWideEmailAddress WHERE Address = :emailAddress LIMIT 1];
            if (owaList.size() > 0) {
                orgWideEmailAddressId = owaList[0].Id;
            }
        }
        return orgWideEmailAddressId;
    }
    
    private static List <String> getToEmailAddresses(String groupName) {
        List <String> emailAddressess = new List <String>();
        if (String.IsNotBlank(groupName)) {
            List <Group> gList = [SELECT Id, (SELECT Id, UserOrGroupId FROM GroupMembers) FROM Group WHERE DeveloperName = :groupName];
            if (gList.size() > 0) {
                Set <String> userOrGroupIdIdSet = new Set <String>();
                for (GroupMember gm : gList[0].GroupMembers) {
                    userOrGroupIdIdSet.add(gm.UserOrGroupId);
                }
                for (User u : [SELECT Id, Email FROM User WHERE Id IN :userOrGroupIdIdSet]) {
                    emailAddressess.add(u.Email);
                }
            }
        
        }
        return emailAddressess;
    }
    
    private static Boolean isRunningInSandbox() {
        return [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
    }
    
}