public class ServiceRequestTask {

    public static void createTaskOnSROwnerChange(Map<Integer, WorkOrder> qualifyMap) {
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
                if (setting.Name.equalsIgnoreCase('SR_CreateTask_OwnerChangeSR')) {
                    if (setting.Default_Value__c.equalsIgnoreCase('true')) {
                        canCreateTask = true;
                    }
                } else if (setting.Name.equalsIgnoreCase('SR_Task_OwnerChangeSR_RecordType')) {
                    taskRecordType = setting.Default_Value__c;
                } else if (setting.Name.startsWithIgnoreCase('SR_Task_OwnerChangeSR_DefaultField_')) {
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
                } else if (setting.Name.equalsIgnoreCase('SR_Task_OwnerChangeSR_DueDate')) {
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
            String userKeyPrefix = User.SObjectType.getDescribe().getKeyPrefix();
            String groupKeyPrefix = Group.SObjectType.getDescribe().getKeyPrefix();
            List <Task> taskList = new List <Task>();
            List <WorkOrder> woList = [SELECT Id, WorkOrderNumber, OwnerId FROM WorkOrder WHERE Id IN :woIdSet];  
            
            Map <String, List <GroupMember>> queueId_gmList_map = new Map <String, List <GroupMember>>();
            Set <String> queueIdSet = new Set <String>();
            for (WorkOrder wo : woList) {  
                if (((String)wo.OwnerId).startsWith(groupKeyPrefix)) {
                    queueIdSet.add(wo.OwnerId);
                }
            }
            if (queueIdSet.size() > 0) {
                for (Group g : [SELECT Id, (SELECT UserOrGroupId FROM GroupMembers) FROM Group WHERE Id IN :queueIdSet]) {
                    queueId_gmList_map.put(g.Id, g.GroupMembers);
                }
            }
                              
            for (WorkOrder wo : woList) {  
                if (((String)wo.OwnerId).startsWith(userKeyPrefix)) {
                    // if service resquest is aggined to user then create a task for that use
                    Task t = getTask(defaultFieldList, wo, rtList[0].Id, taskDueDateOffset);
                    t.OwnerId = wo.OwnerId;
                    taskList.add(t);
                } else if (queueId_gmList_map.containsKey(wo.OwnerId)){
                    // if service resquest is aggined to queue then create a task for each queue member
                    for (GroupMember gm : queueId_gmList_map.get(wo.OwnerId)) {
                        if (((String)gm.UserOrGroupId).startsWith(userKeyPrefix)) {
                            Task t = getTask(defaultFieldList, wo, rtList[0].Id, taskDueDateOffset);
                            t.OwnerId = gm.UserOrGroupId;
                            taskList.add(t);
                        }
                    }                    
                }
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
    
    private static Task getTask(List <DefaultField> defaultFieldList, WorkOrder wo, String recordTypeId, Integer taskDueDateOffset) {
        Task t = new Task();    
    
        // set default values
        for (DefaultField f : defaultFieldList) {
            t.put(f.fieldName, f.defaultValue);
        }
        
        t.RecordTypeId = recordTypeId;
        t.WhatId = wo.Id;
        t.OwnerId = wo.OwnerId;
        t.Subject = 'SR#: ' + wo.WorkOrderNumber + ' is assigned';
        t.ActivityDate = system.today().addDays(taskDueDateOffset);
        
        // set remaider
        t.IsReminderSet = true;
        t.ReminderDateTime = System.today();

        return t;
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