global class skedSkeduloApiManager {
    
    @future(callout=true)
    global static void dispatchJobs_future(set<Id> jobIds) {
        dispatchJobs(jobIds);
    }
    
    global static void dispatchJobs(set<Id> jobIds) {
        List<sked__Job__c> jobResults = [SELECT Id, Name, Skedulo_API_Error__c, Skedulo_API_Error_Message__c,
                                         (SELECT Id, sked__Resource__c, sked__Status__c, sked__Resource__r.sked__Resource_Type__c
                                          FROM sked__Job_Allocations__r
                                          WHERE sked__Status__c != :skedConstants.JOB_ALLOCATION_STATUS_DELETED)
                                         FROM sked__Job__c
                                         WHERE Id IN :jobIds];
        if (!jobResults.isEmpty()) {
            List<sked__Job_Allocation__c> jobAllocsToUpdate = new List<sked__Job_Allocation__c>();
            for (sked__Job__c job : jobResults) {
                sendDispatchNotification(job, jobAllocsToUpdate);
            }
            update jobResults;
            if (!jobAllocsToUpdate.isEmpty()) {
                update jobAllocsToUpdate;
            }
        }
    }
    
    private static void sendDispatchNotification(sked__Job__c job, List<sked__Job_Allocation__c> jobAllocsToUpdate) {
        skedSkeduloApiData.ApiResponse result = dispatchJob(job, jobAllocsToUpdate);
        system.debug('#result dispatch Job#' + result);
        if (result.success == FALSE) {
            job.Skedulo_API_Error__c = TRUE;
            job.Skedulo_API_Error_Message__c = '';
            if (!string.isBlank(result.errorCode)) {
                job.Skedulo_API_Error_Message__c += 'Error Code: ';
                job.Skedulo_API_Error_Message__c += result.errorCode;
                job.Skedulo_API_Error_Message__c += '\n';
            }
            if (!string.isBlank(result.errorMessage)) {
                job.Skedulo_API_Error_Message__c += 'Error Message: ';
                job.Skedulo_API_Error_Message__c += result.errorMessage;
            }
        } else {
            job.sked__Job_Status__c = skedConstants.JOB_STATUS_DISPATCHED;
        }
        system.debug('#job#' + job);
    }
    
    private static skedSkeduloApiData.ApiResponse dispatchJob(sked__Job__c job, List<sked__Job_Allocation__c> jobAllocsToUpdate) {
        skedSkeduloApiData.ApiResponse result = new skedSkeduloApiData.ApiResponse();
        Http http      = new Http();
        HttpRequest req    = new HttpRequest();
        HttpResponse res  = new HttpResponse();
        
        Skedulo_API_Setting__c skeduloApiSetting = Skedulo_API_Setting__c.getOrgDefaults();
        if (string.isBlank(skeduloApiSetting.API_Token__c)) {
            result.success = FALSE;
            result.errorMessage = 'Skedulo API Error: API Token is null.';
            return result;
        }
        
        //Set end point to Authenciate
        string EndPoint = 'https://app.skedulo.com/dispatch?';
        string jobParams = EncodingUtil.urlEncode(job.Id, 'UTF-8');
        EndPoint = EndPoint + 'job=' + jobParams;
        
        req.setEndpoint( EndPoint );
        req.setMethod('POST');
        req.setTimeout(20000);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setHeader('apiToken', skeduloApiSetting.API_Token__c);
        
        string jsonResponse;
        try {
            res = http.send(req);
            jsonResponse = res.getBody();
            
            Map<string, object> deserializedResponse = (Map<string, object>)Json.deserializeUntyped(jsonResponse);
            Map<string, object> resultsObject = (Map<string, object>)deserializedResponse.get('results');
            System.debug('deserializedResponse#' + deserializedResponse);
            for (sked__Job_Allocation__c jobAlloc : job.sked__Job_Allocations__r) {
                string resourceResponseString = Json.serialize(resultsObject.get(jobAlloc.sked__Resource__c));
                skedSkeduloApiData.ApiResponse allocResponse = (skedSkeduloApiData.ApiResponse)Json.deserialize(resourceResponseString, skedSkeduloApiData.ApiResponse.class);
                System.debug('ApiResponse#' + allocResponse);
                if (allocResponse.success == FALSE) {
                    jobAlloc.Skedulo_API_Error__c = TRUE;
                    jobAlloc.Skedulo_API_Error_Message__c = '';
                    if (!string.isBlank(allocResponse.errorCode)) {
                        jobAlloc.Skedulo_API_Error_Message__c += 'Error Code: ';
                        jobAlloc.Skedulo_API_Error_Message__c += allocResponse.errorCode;
                        jobAlloc.Skedulo_API_Error_Message__c += '\n';
                    }
                    if (!string.isBlank(allocResponse.errorMessage)) {
                        jobAlloc.Skedulo_API_Error_Message__c += 'Error Message: ';
                        jobAlloc.Skedulo_API_Error_Message__c += allocResponse.errorMessage;
                    }
                    jobAllocsToUpdate.add(jobAlloc);
                } else {
                    if (jobAlloc.sked__Status__c == skedConstants.JOB_ALLOCATION_STATUS_PENDING_DISPATCH) {
                        jobAlloc.sked__Status__c = skedConstants.JOB_ALLOCATION_STATUS_DISPATCHED;
                        jobAllocsToUpdate.add(jobAlloc);
                    }
                }
            }
        }
        catch (JSONException jsonEx) {
            result.success = FALSE;
            result.errorMessage = 'An error happens in Skedulo Server. Please contact administrator.';
            result.errorMessage += (' Json Response: ' + jsonResponse);
        }
        catch(Exception ex) {
            result.success = FALSE;
            result.errorMessage = ('Error: ' + ex.getMessage());
            result.errorMessage += (' Stack Trace: ' + ex.getStackTraceString());
            System.debug('result.errorMessage#' + result.errorMessage);
        }
        system.debug(result);
        return result;
    }

}