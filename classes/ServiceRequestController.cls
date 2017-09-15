public class ServiceRequestController {
    private String caseId;
    private String rmaId;
    private String workOrderRecordType;
    private String workOrderRecordTypeId;
    private final Case thisCase;
    private final RMA__c rma;
    @TestVisible private final WorkOrder srWorkOrder;
    private String srParentId;
    private String cancelId;
    
    public List <SelectOption> recordTypeOptions {get; private set;}
    public String selectedRecordType {get; set;}
    public WorkOrder tempWorkOrder {get; set;}    // to get input fields
    public List <InputField> inputFieldList {get; private set;}
    public Boolean createNotificationTask {get; set;}
    public String errorMsg {get; private set;}
    
    private List <CopyField> copyFieldList = new List <CopyField>();
    private List <DefaultField> defaultFieldList = new List <DefaultField>();
    private Boolean canCreateTask = false;
    private List <CopyField> taskCopyFieldList_caseToTask = new List <CopyField>();
    private List <CopyField> taskCopyFieldList_srToTask = new List <CopyField>();
    private Integer taskDueDateOffset = 0;
    private String taskRecordType = 'Private_Task';    // Task visible to SunPower only
    private Boolean canAddToCaseTeam = false;
    private String caseTeamRole = 'Service Request Owner';
    private Set <String> availableRecordTypeIdSet = new Set <String>();
    
    private String userKeyPrefix = User.SObjectType.getDescribe().getKeyPrefix();
    private String caseKeyPrefix = Case.SObjectType.getDescribe().getKeyPrefix();
    private String WorkOrderKeyPrefix = WorkOrder.SObjectType.getDescribe().getKeyPrefix();
    private String rmaKeyPrefix = RMA__c.SObjectType.getDescribe().getKeyPrefix();
    
    public ServiceRequestController() {
        // init
        recordTypeOptions = new List <SelectOption>();
        tempWorkOrder = new WorkOrder();
        srWorkOrder = new WorkOrder();
        inputFieldList = new List <InputField>();
        createNotificationTask = true;
        workOrderRecordType = 'Service_Request';

        loadURLParam();
        loadCustomSetting();
        loadRecordTypeOptions();
        
        if (String.IsNotBlank(caseId)) {
            String caseSelectQuery = 'SELECT ' + getCaseSelectFields() + ' FROM Case WHERE Id = :caseId';
            system.debug('caseSelectQuery: ' + caseSelectQuery);
            List <Case> cList = Database.query(caseSelectQuery);
            if (cList.size() > 0) {
                thisCase = cList[0];
            } else {
                errorMessage('Case not found for id: ' + caseId);        
            }
        }
        
        if (String.IsNotBlank(rmaId)) {
            String rmaSelectQuery = 'SELECT ' + getRMASelectFields() + ' FROM RMA__c WHERE Id = :rmaId';
            system.debug('rmaSelectQuery: ' + rmaSelectQuery);
            List <RMA__c> rmaList = Database.query(rmaSelectQuery);
            if (rmaList.size() > 0) {
                rma = rmaList[0];
                workOrderRecordType = 'Unauthorized_RMA';
            }
        }
        
        // workorder record type determination
        Map <String, String> devName_id_map = new Map <String, String>();
        for (RecordType rt : [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'WorkOrder']) {
            devName_id_map.put(rt.DeveloperName, rt.Id);
        }
        if (devName_id_map.containsKey(workOrderRecordType)) {
            workOrderRecordTypeId = devName_id_map.get(workOrderRecordType);
            if (availableRecordTypeIdSet.contains(workOrderRecordTypeId)) {
                selectedRecordType = workOrderRecordTypeId;
                tempWorkOrder.RecordTypeId = workOrderRecordTypeId;
            } else {
                String errMsg = 'You do not have access to WorkOrder record type: ' + workOrderRecordType;
                errMsg += '. Please contact System Administrator to get access'; 
                errorMessage(errMsg);
            }
        } else {
            errorMessage('Record Type does not exists: ' + workOrderRecordType);
        }
        
        if (inputFieldList.size() > 0) {
            for (InputField f : inputFieldList) {
                if (f.recordTypeList != null && f.recordTypeList.size() > 0) {
                    Boolean rtFound = false;
                    for (String rt : f.recordTypeList) {
                        if (rt.equalsIgnoreCase(workOrderRecordType)) {
                            rtFound = true;
                            break;
                        }
                    }
                    if (rtFound == false) {
                        f.rendered = false;
                    }
                }
                tempWorkOrder.put(f.fieldName, f.defaultValue);
                if (String.IsNotBlank(f.fieldName) && f.fieldName.equalsIgnoreCase('Subject')) {
                    if (rma != null) {
                        if (String.IsNotBlank(f.defaultValue)) {
                            tempWorkOrder.put(f.fieldName, f.defaultValue + ' ' + rma.Name + ' - Unauthorized RMA Materials');
                        } else {
                            tempWorkOrder.put(f.fieldName, 'SR - ' + rma.Name + ' - Unauthorized RMA Materials');
                        }               
                    } else if (thisCase != null) {
                        if (String.IsNotBlank(f.defaultValue)) {
                            tempWorkOrder.put(f.fieldName, f.defaultValue + ' Case ' + thisCase.CaseNumber);
                        } else {
                            tempWorkOrder.put(f.fieldName, 'SR - Case ' + thisCase.CaseNumber);
                        }               
                    }
                }
            }        
        }   

        // defaults
        if (workOrderRecordType == 'Unauthorized_RMA') {
            tempWorkOrder.Requested_Date__c = getNextWeekDay(system.today());
        }

    }
    
    private void loadURLParam() {
        srParentId = ApexPages.CurrentPage().getParameters().get('Id');
        if (String.IsNotBlank(srParentId)) {
            if (srParentId.startsWith(caseKeyPrefix)) {
                List <Case> cList = [SELECT Id FROM Case WHERE Id = :srParentId];
                if (cList.size() > 0) {
                    caseId = cList[0].Id;
                    cancelId = cList[0].Id;
                } else {
                    errorMessage('Case not found for id: ' + srParentId);
                }
            } else if (srParentId.startsWith(WorkOrderKeyPrefix)) {
                List <WorkOrder> woList = [SELECT Id, CaseId, RMA__c, WorkOrderNumber FROM WorkOrder WHERE Id = :srParentId];
                if (woList.size() > 0) {
                    cancelId = woList[0].Id;
                    if (woList[0].RMA__c != null) {
                        rmaId = woList[0].RMA__c;
                    }
                    if (woList[0].CaseId != null) {
                        caseId = woList[0].CaseId;
                    }
                    if (woList[0].RMA__c == null && woList[0].CaseId == null) {
                        errorMessage('Case or RMA required in service request: ' + woList[0].WorkOrderNumber);
                    } 
                } else {
                    errorMessage('Service request not found for id: ' + srParentId);
                }
            } else if (srParentId.startsWith(rmaKeyPrefix)) {
                List <RMA__c> rmaList = [SELECT Id, Name, Case__c FROM RMA__c WHERE Id = :srParentId];
                if (rmaList.size() > 0) {
                    rmaId = rmaList[0].Id;
                    cancelId = rmaList[0].Id;
                    if (rmaList[0].Case__c != null) {
                        caseId = rmaList[0].Case__c;
                    } 
                } else {
                    errorMessage('RMA not found for id: ' + srParentId);
                }
            } else {
                errorMessage('Not a case or service request id: ' + srParentId);
            }       
        } else {
            errorMessage('Page requires case or service request id param');
        }
    }
    
    private void loadRecordTypeOptions() {
        recordTypeOptions = new List <SelectOption>();
        List <RecordTypeInfo> infos = WorkOrder.SOBjectType.getDescribe().getRecordTypeInfos();  
        recordTypeOptions.add(new SelectOption('--SELECT--', '--Select--'));   
        for (RecordTypeInfo info : infos) {
            if (info.isAvailable()) {    
                recordTypeOptions.add(new SelectOption(info.getRecordTypeId(), info.getName()));
                availableRecordTypeIdSet.add(info.getRecordTypeId());
            }
        }
    }
    
    public PageReference gotoServiceRequest() {
        if (String.IsNotBlank(errorMsg)) {
            errorMessage(errorMsg);
            return null;
        }
        
        PageReference pr; 
        Savepoint sp = Database.setSavepoint();

        if (String.IsBlank(errorMsg)) createServiceRequest();
        if (String.IsBlank(errorMsg)) {
            if (createNotificationTask) {
                createTask();
            }
        }
        if (String.IsBlank(errorMsg)) addToCaseTeam();
        
        if (String.IsBlank(errorMsg)) {
            if (srWorkOrder.Id != null) {
                pr = new PageReference('/' + srWorkOrder.Id);
                pr.setRedirect(true);
            }
        } else {
            Database.rollback(sp);
            errorMessage(errorMsg);
            return null;
        }
        
        return pr;
    } 

    public PageReference gotoCancel() {
        PageReference pr = new PageReference('/500/o');    // case tab default
        if (String.IsNotBlank(cancelId)) {
            pr = new PageReference('/' + cancelId);
        }
        pr.setRedirect(true);
        return pr;
    }
        
    private void createServiceRequest() {
        // set default values
        for (DefaultField f : defaultFieldList) {
            srWorkOrder.put(f.fieldName, f.defaultValue);
        }
        
        // transfer fields from input
        for (InputField f : inputFieldList) {
            srWorkOrder.put(f.fieldName, tempWorkOrder.get(f.fieldName));            
        }  
        
        // copy fields from case
        for (CopyField f : copyFieldList) {
            srWorkOrder.put(f.fieldName, thisCase.get(f.fieldName));
        }

        // set parent
        srWorkOrder.CaseId = caseId;
        if (rma != null) {
            srWorkOrder.RMA__c = rma.Id;
        }
        
        // record type
        if (String.IsBlank(selectedRecordType) || selectedRecordType == '--SELECT--') {
            errorMessage('Please select record type');
            return;
        } else {
            srWorkOrder.RecordTypeId = selectedRecordType;
        }
        
        try {
            insert srWorkOrder;
        } catch (Exception e) {
            errorMessage(e.getMessage());
        }
        
    }

    private Task getTask(WorkOrder sr) {
        Task t = new Task();
        // copy fields from case to task
        for (CopyField f : taskCopyFieldList_caseToTask) {  
            t.put(f.targetFieldName, thisCase.get(f.sourceFieldName));    
        }
        
        // set due date
        t.ActivityDate = system.today().addDays(taskDueDateOffset);

        // copy fields from sr to task
        for (CopyField f : taskCopyFieldList_srToTask) {                
            t.put(f.targetFieldName, sr.get(f.sourceFieldName)); 
            if (String.IsNotBlank(f.targetFieldName) && f.targetFieldName.equalsIgnoreCase('Subject')) {
                t.put(f.targetFieldName, 'SR # ' + sr.WorkOrderNumber + ' created: ' + sr.get(f.sourceFieldName));
            }   
        }
        
        // set remaider
        t.IsReminderSet = true;
        t.ReminderDateTime = System.today();
        
        return t;                
    }
    
    private void createTask() {
        if (canCreateTask) {   
            // get record type
            List <RecordType> rtList = [SELECT Id FROM RecordType WHERE DeveloperName = :taskRecordType AND SObjectType = 'Task'];
            if (rtList.size() == 0) {
                errorMessage('Task record type: ' + taskRecordType + ' not found');
                return;
            }

            // query SR
            String selectFields = getSRSelectFields();
            String srId = srWorkOrder.Id;
            String selectQuery = 'SELECT ' + selectFields + ' FROM WorkOrder WHERE Id = :srId';
            
            List <WorkOrder> srList = Database.query(selectQuery);
            if (srList.size() == 0) {
                errorMessage('Service request not found for Id: ' + srId);
                return;
            }
            WorkOrder sr = srList[0];
            
            // if service resquest is aggined to user then create a task for that user
            List <Task> taskList = new List <Task>();
            String srOwnerId = sr.OwnerId;
            if (String.IsNotBlank(srOwnerId) && srOwnerId.startsWith(userKeyPrefix)) {
                Task t = getTask(sr);
                t.OwnerId = sr.OwnerId;
                t.RecordTypeId = rtList[0].Id;
                taskList.add(t);
            }  else {         
                // if service resquest is aggined to queue then create a task for each queue member 
                for (GroupMember gm : [SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :sr.OwnerId]) {
                    String memberId = gm.UserOrGroupId;
                    if (String.IsNotBlank(memberId) && memberId.startsWith(userKeyPrefix)) {
                        Task t = getTask(sr);
                        t.OwnerId = gm.UserOrGroupId;
                        t.RecordTypeId = rtList[0].Id;
                        taskList.add(t);
                    }           
                }
                
            }

            if (taskList.size() > 0) {
                try {
                    insert taskList;
                } catch (Exception e) {
                    errorMessage(e.getMessage());
                }
            }
                
        }
    }
    
    private void addToCaseTeam() {
    
        if (canAddToCaseTeam) { 
            String ownerId = srWorkOrder.OwnerId;
            if (String.IsNotBlank(ownerId)) { 
                if (ownerId.startsWith(userKeyPrefix)) {
                    // verify if already added
                    List <CaseTeamMember> ctmList = [SELECT Id FROM CaseTeamMember 
                        WHERE ParentId = :caseId AND MemberId = :srWorkOrder.OwnerId];    
                    if (ctmList.size() == 0) {
                        // get TeamRoleId
                        if (String.IsNotBlank(caseTeamRole)) {
                            // looks like there is a bug after sandbox refresh. this is not fetching in SIT but works in production
                            //List <CaseTeamRole> ctrList = [SELECT Id FROM CaseTeamRole WHERE Name = :caseTeamRole];
                            CaseTeamRole ctr;
                            for (CaseTeamRole rec : [SELECT Id, Name FROM CaseTeamRole]) {
                                if (rec.Name == caseTeamRole) {
                                    ctr = rec;
                                }
                            }
                            
                            if (ctr != null) {
                                CaseTeamMember ctm = new CaseTeamMember();
                                ctm.ParentId = caseId;    // add to parent case
                                ctm.MemberId = srWorkOrder.OwnerId;
                                ctm.TeamRoleId = ctr.Id;        
                                   
                                try {    
                                    insert ctm;
                                }  catch (Exception e) {
                                    errorMessage(e.getMessage());
                                }  
                            }
                        }      
                    }
                }
            }
        }
    
    }

    private void loadCustomSetting() {
        List <Service_Request_Settings__c> settingList = [SELECT Name, Default_Value__c 
            FROM Service_Request_Settings__c 
            WHERE Name LIKE 'SR_%'
            ORDER BY Name ASC];    
        for (Service_Request_Settings__c setting : settingList) {
            if (String.IsNotBlank(setting.Default_Value__c)) {
                if (setting.Name.startsWithIgnoreCase('SR_InputField_')) {
                    String fieldName;
                    String fieldLabel;
                    String defaultValue; 
                    String style;
                    Boolean required = false;
                    List <String> recordTypeList = new List <String>();
            
                    List <String> parts = setting.Default_Value__c.split('~');
                    if (String.IsNotBlank(parts[0])) {
                        fieldName = parts[0].trim();
                    }
                    if (parts.size() > 1 && String.IsNotBlank(parts[1])) {
                        fieldLabel = parts[1].trim();
                    }
                    if (parts.size() > 2 && String.IsNotBlank(parts[2])) {
                        defaultValue = parts[2].trim();
                    }
                    if (parts.size() > 3 && String.IsNotBlank(parts[3])) {
                        style = parts[3].trim();
                    }
                    if (parts.size() > 4 && String.IsNotBlank(parts[4])) {
                        if (parts[4].equalsIgnoreCase('true')) {
                            required = true;                
                        }
                    }
                    if (parts.size() > 5 && String.IsNotBlank(parts[5])) {
                        String recordTypes = parts[5].trim();
                        recordTypeList = recordTypes.split(',');
                    }
                    inputFieldList.add(new InputField(fieldName, fieldLabel, defaultValue, style, required, recordTypeList));
                } else if (setting.Name.startsWithIgnoreCase('SR_CopyField_CaseToSR_')) {
                    copyFieldList.add(new CopyField(setting.Default_Value__c.trim()));        
                } else if (setting.Name.startsWithIgnoreCase('SR_DefaultField_')) {
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
                } else if (setting.Name.equalsIgnoreCase('SR_CreateTask_NewSR')) {
                    if (setting.Default_Value__c.equalsIgnoreCase('true')) {
                        canCreateTask = true;
                    }
                } else if (setting.Name.startsWithIgnoreCase('SR_CopyField_NewSR_CaseToTask_')) {
                    String sourceFieldName;
                    String targetFieldName;
                    List <String> parts = setting.Default_Value__c.split('~');
                    if (String.IsNotBlank(parts[0])) {
                        sourceFieldName = parts[0].trim();
                    }
                    if (parts.size() > 1 && String.IsNotBlank(parts[1])) {
                        targetFieldName = parts[1].trim();
                    }
                    taskCopyFieldList_caseToTask.add(new CopyField(sourceFieldName, targetFieldName));
                } else if (setting.Name.startsWithIgnoreCase('SR_CopyField_NewSR_SRToTask_')) {
                    String sourceFieldName;
                    String targetFieldName;
                    List <String> parts = setting.Default_Value__c.split('~');
                    if (String.IsNotBlank(parts[0])) {
                        sourceFieldName = parts[0].trim();
                    }
                    if (parts.size() > 1 && String.IsNotBlank(parts[1])) {
                        targetFieldName = parts[1].trim();
                    }
                    taskCopyFieldList_srToTask.add(new CopyField(sourceFieldName, targetFieldName));
                } else if (setting.Name.equalsIgnoreCase('SR_Task_NewSR_DueDate')) {
                    taskDueDateOffset = Integer.valueOf(setting.Default_Value__c);
                } else if (setting.Name.equalsIgnoreCase('SR_CaseTeam_AddSROwner')) {
                    if (setting.Default_Value__c.equalsIgnoreCase('true')) {
                        canAddToCaseTeam = true;
                    }
                } else if (setting.Name.equalsIgnoreCase('SR_CaseTeam_Role')) {
                    caseTeamRole = setting.Default_Value__c;
                } else if (setting.Name.equalsIgnoreCase('SR_Task_NewSR_RecordType')) {
                    taskRecordType = setting.Default_Value__c;
                }           
            }        
        
        } 
        
    }
    
    private String getCaseSelectFields() {
        String retValue;  
        Set <String> fieldNameSet = new Set <String>();  
        for (CopyField f : copyFieldList) {
            if (String.IsNotBlank(f.fieldName)) {
                fieldNameSet.add(f.fieldName.toLowerCase());
            } 
        }
        for (CopyField f : taskCopyFieldList_caseToTask) {
            if (String.IsNotBlank(f.sourceFieldName)) {
                fieldNameSet.add(f.sourceFieldName.toLowerCase());
            } 
        }
        fieldNameSet.add('Id'.toLowerCase());           
        fieldNameSet.add('ParentId'.toLowerCase());           
        fieldNameSet.add('RecordType.DeveloperName'.toLowerCase());           
        fieldNameSet.add('CaseNumber'.toLowerCase());           

        List <String> fieldNameList = new List <String>(fieldNameSet);
        fieldNameList.sort();
        if (fieldNameList.size() > 0) {
            retValue = String.join(fieldNameList, ',');
        }
        return retValue;    
    }

    private String getSRSelectFields() {
        String retValue;  
        Set <String> fieldNameSet = new Set <String>();  
        for (CopyField f : taskCopyFieldList_srToTask) {
            if (String.IsNotBlank(f.sourceFieldName)) {
                fieldNameSet.add(f.sourceFieldName.toLowerCase());
            } 
        }
        fieldNameSet.add('Id'.toLowerCase());           
        fieldNameSet.add('WorkOrderNumber'.toLowerCase());           

        List <String> fieldNameList = new List <String>(fieldNameSet);
        fieldNameList.sort();
        if (fieldNameList.size() > 0) {
            retValue = String.join(fieldNameList, ',');
        }
        return retValue;    
    }

    private String getRMASelectFields() {
        String retValue;  
        Set <String> fieldNameSet = new Set <String>();  

        fieldNameSet.add('Id'.toLowerCase());           
        fieldNameSet.add('Name'.toLowerCase());           
        fieldNameSet.add('Case__c'.toLowerCase());           

        List <String> fieldNameList = new List <String>(fieldNameSet);
        fieldNameList.sort();
        if (fieldNameList.size() > 0) {
            retValue = String.join(fieldNameList, ',');
        }
        return retValue;    
    }
    
    private static Date getNextWeekDay(Date dt) {
        Date retDt = dt;
        Date referenceDate = Date.newInstance(1900, 1, 7);    // sunday    
        Integer modValue = Math.Mod(referenceDate.daysBetween(dt), 7);
        // 0-sunday, 6-saturday
        if (modValue == 5) {    // friday
           retDt = retDt.addDays(3);
        } else if (modValue == 6) {    // saturday
            retDt = retDt.addDays(2);
        } else {
           retDt = retDt.addDays(1);
        }
        return retDt;            
    }
    
    public class InputField {
        public String fieldName {get; private set;}
        public String fieldLabel {get; private set;}
        public String defaultValue {get; private set;} 
        public String style {get; private set;} 
        public Boolean required {get; private set;} 
        public Boolean rendered {get; private set;} 
        private List <String> recordTypeList;
        public InputField(String fieldName, String fieldLabel, String defaultValue, String style, Boolean required) {
            this.fieldName = fieldName;
            this.fieldLabel = fieldLabel;
            this.defaultValue = defaultValue;
            this.style = style;
            this.required = required;
            this.rendered = true;
        }           
        public InputField(String fieldName, String fieldLabel, String defaultValue, String style, Boolean required, List <String> recordTypeList) {
            this.fieldName = fieldName;
            this.fieldLabel = fieldLabel;
            this.defaultValue = defaultValue;
            this.style = style;
            this.required = required;
            this.rendered = true;
            this.recordTypeList = recordTypeList;
        }           
    }
    
    private class CopyField {
        String fieldName;
        String sourceFieldName;
        String targetFieldName;
        private CopyField(String fieldName) {
            this.fieldName = fieldName;
        }
        private CopyField(String sourceFieldName, String targetFieldName) {
            this.sourceFieldName = sourceFieldName;
            this.targetFieldName = targetFieldName;
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
    
    private void errorMessage(String msg) {
        errorMsg = msg;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg));
    }
    
}