/*

For throwing and recording custom exceptions aginst the SunPowerException object

Class:              SunPowerException
Date:               08/20/2014
Version:            1
Last Updated:       08/20/2014
    *   Stubbed / Completed
    
////////////////////////////////////////////////////////////////////////////////
*/

public without sharing class SunPowerException extends Exception
{
    // -------- Constants --------
    // None
    
    // -------- Constructor --------
    // None

    // -------- Variables --------
    // None
    
    // -------- Properties --------
    // None
    
    // -------- Methods --------
    // Generic error creation for each record
    private static Exception_log__c createError(String className, String methodName, String systemException)
    {
        Exception_log__c result = new Exception_log__c();
        result.Class_Name__c = className;
        result.Class_Name__c += ' Method:' +  methodName;
        List<String> exceptionSplit=systemException.split('EXCEPTION:',2);
        try{
        result.Request_Message__c = (exceptionSplit[0].length() > 100000) ? exceptionSplit[0].left(100000) : exceptionSplit[0];
        result.Error_Message__c   = (exceptionSplit[1].length() > 100000) ? exceptionSplit[1].left(100000) : exceptionSplit[1];
        }
        catch(Exception e){
        	
        }
        return result;
    }
    
    // Generic insert of record
    private static void insertError(Exception_log__c newError)
    {
        try
        {
            insert newError;
        }
        catch(DMLException error)
        {
             
        }
    }
    
    // Standard class / trigger error
    public static void recordError(String className, String methodName, String systemException)
    {
        Exception_log__c newError = createError(className, methodName, systemException);
        insertError(newError);
    }
    
    public static void recordError(String className, String methodName, Exception systemException)
    {
        Exception_log__c newError = createError(className, methodName, 
            systemException.getMessage() + systemException.getStackTraceString());
        insertError(newError);
    }
    
    // Batch error
    public static void recordErrorBatch(String className, String methodName, String systemException, ID batchID)
    {
        Exception_log__c newError = createError(className, methodName, systemException);
        newError.Class_Id__c = String.valueOf(batchID);
        insertError(newError);
    }
    
    public static void recordErrorBatch(String className, String methodName, Exception systemException, ID batchID)
    {
        Exception_log__c newError = createError(className, methodName, 
            systemException.getMessage() + systemException.getStackTraceString());
        newError.Class_Id__c = String.valueOf(batchID);
        insertError(newError);
    }
    
    // Service errors
    public static ID recordErrorService(String className, String methodName, String systemException, String serviceCall)
    {
        Exception_log__c newError = createError(className, methodName, systemException);
        newError.Type__c = serviceCall;
        insertError(newError);
        return(newError.Id);
    }
    
    public static void recordErrorService(String className, String methodName, Exception systemException, String serviceCall)
    {
        Exception_log__c newError = createError(className, methodName, 
            systemException.getMessage() + systemException.getStackTraceString());
        newError.Type__c = serviceCall;
        insertError(newError);
    }
    
    public static void recordOpportunityError(String className, String methodName, String systemException, String serviceCall, String oppId) {
        Exception_log__c newError = createError(className, methodName, systemException);
        newError.Type__c = serviceCall;
        newError.Opportunity_Id__c = oppId;
        insertError(newError);
    }
    
    // -------- Internal Classes --------
    // None
}