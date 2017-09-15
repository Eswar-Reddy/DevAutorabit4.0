public class ServiceRequestUtil {

    public static void setCompletedDate(Map<Integer, WorkOrder> qualifyMap) {
        for (WorkOrder wo : qualifyMap.values()) {
            wo.Completed_Date__c = system.today();
        }
    }

    public static void setDateActionCompleted(Map<Integer, WorkOrder> qualifyMap) {
        for (WorkOrder wo : qualifyMap.values()) {
            wo.Date_Action_Completed__c = system.today();
        }
    }

    public static void createTaskOnSRClose(Map<Integer, WorkOrder> qualifyMap) {
        Boolean canCreateTask = false;
        String taskRecordType = 'Private_Task';    // Task visible to SunPower only
        List <DefaultField> defaultFieldList = new List <DefaultField>();
        Integer taskDueDateOffset = 0;
        
        // load custom settings
        List <Service_Request_Settings__c> settingList = [SELECT Name, Default_Value__c 
            FROM Service_Request_Settings__c 
            WHERE Name LIKE 'SR_%'
            ORDER BY Name ASC];    
        for (Service_Request_Settings__c setting : settingList) {
            if (String.IsNotBlank(setting.Default_Value__c)) {
                if (setting.Name.equalsIgnoreCase('SR_CreateTask_CloseSR')) {
                    if (setting.Default_Value__c.equalsIgnoreCase('true')) {
                        canCreateTask = true;
                    }
                } else if (setting.Name.equalsIgnoreCase('SR_Task_CloseSR_RecordType')) {
                    taskRecordType = setting.Default_Value__c;
                } else if (setting.Name.startsWithIgnoreCase('SR_Task_CloseSR_DefaultField_')) {
                    String fieldName;
                    String defaultValue; 
                    List <String> parts = setting.Default_Value__c.split('~');
                    if (String.IsNotBlank(parts[0])) {
                        fieldName = parts[0].trim();
                    }
                    if (parts.size() > 1 && String.IsNotBlank(parts[1])) {
                        defaultValue = parts[1].trim();
                    }
                    defaultFieldList.add(new DefaultField(fieldName, defaultValue));
                } else if (setting.Name.equalsIgnoreCase('SR_Task_CloseSR_DueDate')) {
                    taskDueDateOffset = Integer.valueOf(setting.Default_Value__c);
                }
            }        
        }
        
        if (canCreateTask == false) {
            return;
        }

        List <RecordType> rtList = [SELECT Id FROM RecordType WHERE DeveloperName = :taskRecordType AND SOBjectType = 'Task'];
        if (rtList.size() == 0) {
            system.debug('Task record type not found: ' + taskRecordType);  
            return;      
        }
         
        Set <String> woIdSet = new Set <String>();    
        for (WorkOrder wo : qualifyMap.values()) {
            if (wo.Id != null) {    
                woIdSet.add(wo.Id);    
            }
        }
        if (woIdSet.size() > 0) {
            List <Task> taskList = new List <Task>();
            List <WorkOrder> woList = [SELECT Id, WorkOrderNumber, CreatedById FROM WorkOrder WHERE Id IN :woIdSet];        
            for (WorkOrder wo : woList) {        
                Task t = new Task();
                
                // set default values
                for (DefaultField f : defaultFieldList) {
                    t.put(f.fieldName, f.defaultValue);
                }
                
                t.RecordTypeId = rtList[0].Id;
                t.WhatId = wo.Id;
                t.OwnerId = wo.CreatedById;
                t.Subject = 'SR#: ' + wo.WorkOrderNumber + ' is closed';
                t.ActivityDate = system.today().addDays(taskDueDateOffset);
                
                // set remaider
                t.IsReminderSet = true;
                t.ReminderDateTime = System.today();

                taskList.add(t);
            }
            
            if (taskList.size() > 0) {
                Database.SaveResult[] srList = Database.insert(taskList, false);
                for (Integer i=0; i<srList.size(); i++) {
                    Database.SaveResult sr = srList[i]; 
                    if (sr.isSuccess()) {
                    } else {
                        String errMsg = 'The following error has occurred while inserting task: ';
                        for(Database.Error err : sr.getErrors()) {
                            errMsg += err.getStatusCode() + ': ' + err.getMessage();                    
                            errMsg += '. Fields that affected this error: ' + err.getFields();
                        } 
                        system.debug(errMsg);                   
                    }                
                }
            }                
        }
        
    }

    private class DefaultField {
        String fieldName;
        String defaultValue;
        private DefaultField(String fieldName, String defaultValue) {
            this.fieldName = fieldName;
            this.defaultValue = defaultValue;
        }
    }

}