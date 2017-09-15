public class Case360ViewChronController {
    
    public Case parentCase {get; private set;}
    public Map <String, QueryWrapper> objectName_qryWrpr_map {get; private set;}    // for debug
    public List <Wrapper360> wrapper360List {get; private set;}
    public String errorMsg {get; private set;}
    
    private List <SettingWrapper> settingWrapperList = new List <SettingWrapper>();
    private String caseKeyPrefix;
    private String workOrderKeyPrefix;
    
    public Case360ViewChronController() {
        parentCase = new Case();
        objectName_qryWrpr_map = new Map <String, QueryWrapper>();
        wrapper360List = new List <Wrapper360>();
        
        caseKeyPrefix = Case.SObjectType.getDescribe().getKeyPrefix();
        workOrderKeyPrefix = WorkOrder.SObjectType.getDescribe().getKeyPrefix();
        
        load360();
        
    }

    private void load360() {
        String parentId = APexPages.currentPage().getParameters().get('Id');
        String caseId;
        Set <String> whereIdSet = new Set <String>();
        if (String.IsNotBlank(parentId)) {
            if (parentId.startsWithIgnoreCase(caseKeyPrefix)) {
                List <Case> cList = [SELECT Id, (SELECT Id FROM WorkOrders) FROM Case WHERE Id = :parentId];
                if (cList.size() > 0) {
                    caseId = cList[0].Id;
                    whereIdSet.add(caseId);
                    for (WorkOrder wo : cList[0].WorkOrders) {
                        whereIdSet.add(wo.Id);
                    }
                } else {
                    errorMessage('Case not found for id: ' + parentId);
                }
            } else if (parentId.startsWithIgnoreCase(WorkOrderKeyPrefix)) {
                List <WorkOrder> woList = [SELECT Id, CaseId, WorkOrderNumber FROM WorkOrder WHERE Id = :parentId];
                if (woList.size() > 0) {
                    if (woList[0].CaseId != null) {
                        caseId = woList[0].CaseId;
                        whereIdSet.add(woList[0].Id);
                        whereIdSet.add(woList[0].CaseId);
                    } else {
                        errorMessage('Case is required in service request: ' + woList[0].WorkOrderNumber);
                    } 
                } else {
                    errorMessage('Service request not found for id: ' + parentId);
                }
            } else {
                errorMessage('Not a case or service request id: ' + parentId);
            }       
        } else {
            errorMessage('Page requires case or service request id param');
        }
        if (String.IsNotBlank(errorMsg)) {
            return;
        }
        
        loadCustomSetting();
        buildQuery();
        
        try {
            queryObjects(whereIdSet);
        } catch(Exception e) {
            errorMessage('Error in queryObjects: ' + e.getMessage());
            return;
        }
        load360Wrapper();
    
    }
    
    private void load360Wrapper() {
        
        for (SettingWrapper wrpr : settingWrapperList) {
            if (objectName_qryWrpr_map.containsKey(wrpr.ow.objectName)) {
                QueryWrapper qryWrpr = objectName_qryWrpr_map.get(wrpr.ow.objectName);            
                for (SObject sobj : qryWrpr.sobjList) {            
                    Wrapper360 w360 = new Wrapper360(); 
                    w360.sobj = sobj;           
                    w360.dtTm = getDateTime(String.valueOf(sobj.get('CreatedDate')));
                    w360.dtTmFormat = w360.dtTm.format();
                    // not sure why this is null in test method for comments test
                    if (sobj.getSobject('CreatedBy') != null) {
                        w360.createdBy = String.valueOf(sobj.getSobject('CreatedBy').get('Name'));
                    }
                    w360.type = wrpr.type;
                    w360.fwList = clone(wrpr.fwList);
                    
                    for (FieldWrapper fw : w360.fwList) {
                        if (w360.type == 'Case' && fw.Name == 'CaseNumber') {
                            fw.attrClass = 'case';
                            fw.attrId = 'Id';
                            fw.attrHref = 'Id';
                        } else if (w360.type == 'Service Request' && fw.Name == 'WorkOrderNumber') {
                            fw.attrClass = 'serviceRequest';
                            fw.attrId = 'Id';
                            fw.attrHref = 'Id';
                        } else if (w360.type == 'RMA' && fw.Name == 'Name') {
                            fw.attrClass = 'rma';
                            fw.attrId = 'Id';
                            fw.attrHref = 'Id';
                        } else if (w360.type == 'Task') {
                            if (fw.Name == 'What.Name') {
                                String whatId = String.valueOf(sobj.get('WhatId'));
                                if (String.IsNotBlank(whatId) && whatId.startsWithIgnoreCase(caseKeyPrefix)) {
                                    fw.attrClass = 'case';
                                } else if (String.IsNotBlank(whatId) && whatId.startsWithIgnoreCase(workOrderKeyPrefix)) {
                                    fw.attrClass = 'serviceRequest';
                                }
                                fw.attrId = 'WhatId';
                                fw.attrHref = 'WhatId';
                            } else if (fw.Name == 'Subject') {
                                fw.attrClass = 'task';
                                fw.attrId = 'Id';
                                fw.attrHref = 'Id';
                            }
                        } else if (w360.type == 'Event') {
                            if (fw.Name == 'What.Name') {
                                String whatId = String.valueOf(sobj.get('WhatId'));
                                if (String.IsNotBlank(whatId) && whatId.startsWithIgnoreCase(caseKeyPrefix)) {
                                    fw.attrClass = 'case';
                                } else if (String.IsNotBlank(whatId) && whatId.startsWithIgnoreCase(workOrderKeyPrefix)) {
                                    fw.attrClass = 'serviceRequest';
                                }
                                fw.attrId = 'WhatId';
                                fw.attrHref = 'WhatId';
                            } else if (fw.Name == 'Subject') {
                                fw.attrClass = 'event';
                                fw.attrId = 'Id';
                                fw.attrHref = 'Id';
                            }
                        } else if (w360.type == 'Email' && fw.Name == 'Subject') {
                            fw.attrClass = 'email';
                            fw.attrId = 'Id';
                            fw.attrHref = 'Id';
                        }                   
                    
                    }
                    
                    wrapper360List.add(w360);
                }
            }
        }
        wrapper360List.sort();            
    }
        
    private void queryObjects(Set <String> whereIdSet) {
        if (whereIdSet != null && whereIdSet.size() > 0) {
            for (String objectName : objectName_qryWrpr_map.keySet()) {
                QueryWrapper qryWrpr = objectName_qryWrpr_map.get(objectName);
                List <SObject> sobjList = Database.query(qryWrpr.queryStr);
                qryWrpr.sobjList = sobjList;
                qryWrpr.querySize = sobjList.size(); 
                
                if (objectName == 'Case') {
                    parentCase = ((List <Case>)sobjList)[0];
                }               
            }
        }
    }
    
    private void buildQuery() {
        for (SettingWrapper w : settingWrapperList) { 
            String type = w.type;
            String objectName = w.ow.objectName;  
            QueryWrapper qryWrpr = new QueryWrapper();
            if (objectName_qryWrpr_map.containsKey(objectName)) {
                qryWrpr = objectName_qryWrpr_map.get(objectName);
            }
            Set <String> fnSet = qryWrpr.fnSet; 
            for (FieldWrapper fw : w.fwList) {    
                if (String.IsNotBlank(fw.name)) {        
                    fnSet.add(fw.name.toLOwerCase());
                }
            }
            fnSet.add('Id'.toLOwerCase());
            fnSet.add('CreatedDate'.toLOwerCase());
            fnSet.add('CreatedBy.Name'.toLOwerCase());
            if (objectName == 'Case') {
                fnSet.add('Id'.toLOwerCase());
                qryWrpr.whereField = 'Id';
            } else if (objectName == 'WorkOrder') {
                fnSet.add('Id'.toLOwerCase());
                qryWrpr.whereField = 'Id';
            } else if (objectName == 'CaseComment') {
                fnSet.add('ParentId'.toLOwerCase());
                qryWrpr.whereField = 'ParentId';
            } else if (objectName == 'Task') {
                fnSet.add('WhatId'.toLOwerCase());
                qryWrpr.whereField = 'WhatId';
            } else if (objectName == 'Event') {
                fnSet.add('WhatId'.toLOwerCase());
                qryWrpr.whereField = 'WhatId';
            } else if (objectName == 'RMA__c') {
                fnSet.add('Case__c'.toLOwerCase());
                qryWrpr.whereField = 'Case__c';
            } else if (objectName == 'EmailMessage') {
                fnSet.add('ParentId'.toLOwerCase());
                qryWrpr.whereField = 'ParentId';
            } else if (objectName == 'CaseTeamMember') {
                fnSet.add('ParentId'.toLOwerCase());
                qryWrpr.whereField = 'ParentId';
            }
            qryWrpr.fnSet = fnSet;
            objectName_qryWrpr_map.put(objectName, qryWrpr);
            
        }  
        
        for (String objectName : objectName_qryWrpr_map.keySet()) {
            QueryWrapper qryWrpr = objectName_qryWrpr_map.get(objectName);
            List <String> fnList = new List <String>(qryWrpr.fnSet);
            fnList.sort();
            String fields = String.join(fnList, ',');
            String queryStr = 'SELECT ' + fields + ' FROM ' + objectName + ' WHERE ' + qryWrpr.whereField + ' IN :whereIdSet';
            qryWrpr.queryStr = queryStr;        
        }  
    }
    
    private void loadCustomSetting() {
        List <Service_Request_Settings__c> settingList = [SELECT Name, Default_Value__c 
            FROM Service_Request_Settings__c 
            WHERE Name LIKE 'SR_360Chron_Fields_%' 
            ORDER BY Name ASC];    
        for (Service_Request_Settings__c setting : settingList) {
            if (String.IsNotBlank(setting.Default_Value__c)) {
                if (setting.Name.startsWithIgnoreCase('SR_360Chron_Fields_')) {
                    String type;
                    String objectName;
                    SettingWrapper w = new SettingWrapper();
                    
                    List <String> parts = setting.Default_Value__c.split('~');
                    if (String.IsNotBlank(parts[0])) {
                        type = parts[0].trim();
                    }
                    if (parts.size() > 1 && String.IsNotBlank(parts[1])) {
                        objectName = parts[1].trim();
                    }
                    w.type = type;
                    w.ow.objectName = objectName;
                    
                    if (parts.size() > 2) {
                        for (Integer i=2; i<parts.size(); i++) {
                            if (String.IsNotBlank(parts[i])) {
                                String field = parts[i].trim(); 
                                List <String> fieldParts = field.split(','); 
                                
                                if (String.IsNotBlank(fieldParts[0])) {
                                    FieldWrapper fw = new FieldWrapper();
                                    fw.name = fieldParts[0].trim();
                                    fw.label = fw.name;    // if label not specified. load from describe field ?
                                    if (fieldParts.size() > 1 && String.IsNotBlank(fieldParts[1])) {
                                        fw.label = fieldParts[1].trim();
                                    }
                                    w.fwList.add(fw);
                                }                           
                            }                        
                        }
                    }
                    settingWrapperList.add(w);
                }
            }                
        }                
    }
    
    private DateTime getDateTime(String str) {
        DateTime dt;
        Integer year, month, day, hour, minute, second;
        List <String> parts = str.split(' ');
        if (parts.size() > 0) {
            List <String> subParts = parts[0].split('-');
            if (subParts.size() > 0 && String.IsNotBlank(subParts[0])) {
                year = Integer.valueOf(subParts[0].trim());
            }
            if (subParts.size() > 1 && String.IsNotBlank(subParts[1])) {
                month = Integer.valueOf(subParts[1].trim());
            }
            if (subParts.size() > 2 && String.IsNotBlank(subParts[2])) {
                day = Integer.valueOf(subParts[2].trim());
            }
        }
        if (parts.size() > 1) {
            List <String> subParts = parts[1].split(':');
            if (subParts.size() > 0 && String.IsNotBlank(subParts[0])) {
                hour = Integer.valueOf(subParts[0].trim());
            }
            if (subParts.size() > 1 && String.IsNotBlank(subParts[1])) {
                minute = Integer.valueOf(subParts[1].trim());
            }
            if (subParts.size() > 2 && String.IsNotBlank(subParts[2])) {
                second = Integer.valueOf(subParts[2].trim());
            }
        }
        
        dt = DateTime.newInstanceGMT(year, month, day, hour, minute, second);
        
        return dt;    
    }
    
    private List <FieldWrapper> clone(List <FieldWrapper> wList) {
        List <FieldWrapper> retList = new List <FieldWrapper>();
        for (FieldWrapper w : wList) {
            FieldWrapper ret = new FieldWrapper();
            ret.name = w.name;
            ret.label = w.label;
            ret.attrHref = w.attrHref;
            ret.attrClass = w.attrClass;
            ret.attrId = w.attrId;
            retList.add(ret);
        }    
        return retList;
    }
    
    private void errorMessage(String msg) {
        errorMsg = msg;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg));
    }
    
    public class Wrapper360 implements Comparable {
        public DateTime dtTm {get; private set;}
        public String dtTmFormat {get; private set;}
        public String type {get; private set;} 
        public SObject sobj {get; private set;}    
        public List <FieldWrapper> fwList {get; private set;}
        public String createdBy {get; private set;} 
        public String debugStr {get; private set;} 
        
        public Wrapper360() {
            fwList = new List <FieldWrapper>();
        }  
        
        public Integer compareTo(Object sobj) {
            Wrapper360 w360 = (Wrapper360)sobj;
            if (dtTm == w360.dtTm) return 0;
            if (dtTm > w360.dtTm) return 1;
            return -1;
        }
    }
                
    public class SettingWrapper {
        public String type {get; private set;}
        public ObjectWrapper ow;
        public List <FieldWrapper> fwList {get; private set;}
         
        public SettingWrapper() {
            ow = new ObjectWrapper();
            fwList = new List <FieldWrapper>();
        } 
    
    }

    public class ObjectWrapper {
        public String objectName {get; private set;}    
    }
    
    public class FieldWrapper {
        public String name {get; private set;}
        public String label {get; private set;}
        public String attrHref {get; private set;}
        public String attrClass {get; private set;}
        public String attrId {get; private set;}
    }
    
    public class QueryWrapper {
        public String queryStr {get; private set;}    
        public Integer querySize {get; private set;}    
        Set <String> fnSet; 
        String whereField; 
        List <SObject> sobjList;  
        public QueryWrapper() {
            fnSet = new Set <String>();
            sobjList = new List <SObject>();
        }
    }
    
}