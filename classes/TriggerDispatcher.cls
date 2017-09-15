/*

Dispatcher for all triggers, keeping track of what to call for which object

Class:              TriggerDispatcher
Date:               05/12/2014
Version:            1
Last Updated:       05/12/2014
    *   Completed

////////////////////////////////////////////////////////////////////////////////
*/

global class TriggerDispatcher
{
    // -------- Constants --------
    // None
    
    // -------- Constructor --------
    // None

    // -------- Variables --------
    // Map for matching running handlers
    @TestVisible
    private static Map<String, ITriggerHandler> handlers = 
        new Map<String, ITriggerHandler>();
    
    // For setting test run fo Test_TriggerFramework
    private static ApexTrigger testFile;
    private static Boolean testRun = false;
    
    // -------- Properties --------
    // None
    // 
    
    // -------- Methods --------
    // Only method called from the trigger; this determines the handler to
    // create and calls the methods in the handler based on its status
    global static void execute(Schema.sObjectType soType, List<sObject> newList, 
        List<sObject> oldList, Map<ID, sObject> newMap, 
        Map<ID, sObject> oldMap)
    {   
        ITriggerHandler handler;
        String executingOn = getObjectName(soType);
        
        if(executingOn != null)
        {
            handler = activateHandler(executingOn);
        }
        
        if(handler == null)
        {
            throw new NoHandlerException('Handler is Null');
        }
        else
        {
            if(!testRun)
            {
                if(!handler.isRunning())
                {
                    handler.startRunning();
                    handler.qualifyStartingRecords(newList, oldList, newMap, 
                        oldMap);
                    handler.start();
                    handler.finish(true);
                    handler.stopRunning();
                }
                else
                {
                    handler.qualifyReEntryRecords(newList, oldList, newMap, 
                        oldMap);
                    handler.reEntry();
                    handler.finish(false);
                }
            }
        }
    }
    
    // Return the object name the trigger is being run on
    private static String getObjectName(Schema.sObjectType soType) {
        String result;
        
        if(soType != null) {
            String soName = soType.getDescribe().getName();
            if (soName == 'echosign_dev1__SIGN_Agreement__c') {
                result = 'Agreement';
            } else if (soName == 'Live_Chat_Survey_Response__c') {
                result = 'LiveChatSurveyResp';
            } else if (soName == 'Business_Registration__c'){
                result = 'BusinessRegistration';
            }
            else if (soName == 'Credit_Check_Request__c'){
                result = 'CreditApp';
            }
            else if (soName == 'Invoice_Compliance_Document__c') {
                result = 'InvoiceComplianceDoc';
            }  
            else {
                result = soName;
            }
            if (String.IsNotBlank(result) && result.toLowerCase().endsWith('__c')) {
                Integer index = result.toLowerCase().indexOf('__c');
                result = result.substring(0, index);
            }
        }
        
        return result;
    }
    
    // Return the appropriate handler if exists, or creates a new one
    private static ITriggerHandler activateHandler(String executingOn)
    {
        ITriggerHandler result;
        
        if(testRun)
        {
            result = determineHandler(executingOn, 
                (testFile.UsageBeforeInsert || testFile.UsageBeforeUpdate || 
                testFile.UsageBeforeDelete), 
                (testFile.UsageAfterInsert || testFile.UsageAfterUpdate || 
                testFile.UsageAfterDelete || testFile.UsageAfterUndelete), 
                (testFile.UsageBeforeInsert || testFile.UsageAfterInsert), 
                (testFile.UsageBeforeUpdate || testFile.UsageAfterUpdate), 
                (testFile.UsageBeforeDelete || testFile.UsageAfterDelete), 
                testFile.UsageAfterUndelete);
        }
        else
        {
            result = determineHandler(executingOn, Trigger.isBefore, 
                Trigger.isAfter, Trigger.isInsert, Trigger.isUpdate, 
                Trigger.isDelete, Trigger.isUnDelete);
        }
        
        return result;
    }
    
    // Determine and return the handler for both normal and test coverage
    private static ITriggerHandler determineHandler(String executingOn, 
        Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate,
        Boolean isDelete, Boolean isUnDelete)
    {   
        ITriggerHandler result;
        String handlerName;
        System.debug('---------------------determineHandler=isBefore'+isBefore);
        System.debug('---------------------determineHandler=isAfter'+isAfter);
        System.debug('---------------------determineHandler=isInsert'+isInsert);
        System.debug('---------------------determineHandler=isUpdate'+isUpdate);
        if(isBefore)
        {
            if(isInsert)
            {
                handlerName = executingOn + 'BeforeInsertHandler';
                
                if(handlers.containsKey(handlerName) && !Util.isSkipTrigger(handlerName,null))
                {
                    result = handlers.get(handlerName);
                }
            }
            else if(isUpdate)
            {
                handlerName = executingOn + 'BeforeUpdateHandler';
          
                if(handlers.containsKey(handlerName) && !Util.isSkipTrigger(handlerName,null))
                {
                    result = handlers.get(handlerName);
                }
            } 
            else if(isDelete)
            {
                handlerName = executingOn + 'BeforeDeleteHandler';
                
                if(handlers.containsKey(handlerName) && !Util.isSkipTrigger(handlerName,null))
                {
                    result = handlers.get(handlerName);
                }
            }
        }
        else if(isAfter)
        {
            if(isInsert)
            {
                handlerName = executingOn + 'AfterInsertHandler';
                if(handlers.containsKey(handlerName) && !Util.isSkipTrigger(handlerName,null))
                {
                    result = handlers.get(handlerName);
                    }
            }
            else if(isUpdate)
            {
                handlerName = executingOn + 'AfterUpdateHandler';
                
                if(handlers.containsKey(handlerName)&& !Util.isSkipTrigger(handlerName,null))
                {
                    result = handlers.get(handlerName);
                }
            }
            else if (isDelete)
            {
                handlerName = executingOn + 'AfterDeleteHandler';
                
                if(handlers.containsKey(handlerName)&& !Util.isSkipTrigger(handlerName,null))
                {
                    result = handlers.get(handlerName);
                }
            }
            else if(isUnDelete)
            {
                handlerName = executingOn + 'AfterUnDeleteHandler';
                
                if(handlers.containsKey(handlerName)&& !Util.isSkipTrigger(handlerName,null))
                {
                    result = handlers.get(handlerName);
                }
            }
        }
        
        if(result == null)
        {
            Type classType = Type.forName(handlerName);
            result = (classType == null) ? null : 
                (ITriggerHandler)classType.newInstance();
            handlers.put(handlerName, result);
        }
            
        return result;
    }   
    
    // For other classes to determine if a handler is running
    global static Boolean isHandlerRunning(String handlerName)
    {
        Boolean result = false;
        
        if(handlers.containsKey(handlerName))
        {
            result = handlers.get(handlerName).isRunning();
        }
        
        return result;
    }
    
    // For resetting the trigger dispatcher during testing
    @TestVisible
    private static Boolean resetHandler(String handlerName)
    {
        Boolean result = false;
        
        ITriggerHandler handler = handlers.get(handlerName);
        
        if(handler != null)
        {
            handler.stopRunning();
            result = true;
        }
        
        return result;
    }
    
    // For framework testing
    @TestVisible
    private static void setFrameworkTestParameters(ApexTrigger file, 
        Boolean run)
    {   
        testFile = file;
        testRun = run;
    }
    
    // -------- Internal Classes --------
    // None
}