public with sharing class SPCommunityRecordHistoryUtil {

    public SPCommunityRecordHistoryUtil() {}
    
    @RemoteAction
    public static ResultMessage getRecordHistory(String parentId) {
        ResultMessage result = new ResultMessage();
        result.success = false;
        
        if (String.IsBlank(parentId)) {
            result.message = Label.Invalid_Parameters;
            return result;
        }
        
        History hist = getHistory(parentId);
        result.payloadMap.put('records', hist);
        result.success = hist.isSuccess;
        result.message = hist.errorMessage;
        
        return result;    
    }
    
    private static History getHistory(Id parentId) {
        return getHistory(parentId, new List <TestData>());
    }
    
    @TestVisible
    private static History getHistory(Id parentId, List <TestData> testDataList) {
        History hist = new History();

        String historyQuery;
        String historyObjectName;
        String parentIdFieldName = 'ParentId';    
    
        Schema.SObjectType parentToken = parentId.getSObjectType();
        Schema.DescribeSObjectResult dr = parentToken.getDescribe();
        String parentObjectName = dr.getName();
        String parentObjectLabel = dr.getLabel();
        
        // used in related list header
        hist.parentObjectLabel = parentObjectLabel;
        
        // parent query
        String parentQuery = 'SELECT Id, currencyIsoCode FROM ' + parentObjectName + ' WHERE Id = ' + '\'' + parentId + '\'';
        SObject parentSobj;
        try {
            List <SObject> parentSobjList = Database.query(parentQuery);
            if (parentSobjList.size() > 0) {
                parentSobj = parentSobjList[0];
            }
        } catch(Exception e) {
            hist.errorMessage = e.getMessage();
            return hist;
        }
        
        if (parentObjectName.endsWithIgnoreCase('__c')) {
            historyObjectName = parentObjectName.removeEndIgnoreCase('__c') + '__History';
        } else {
            if (parentObjectName == 'Opportunity') {
                historyObjectName = 'OpportunityFieldHistory';
            } else {
                historyObjectName = parentObjectName + 'History';
            }
            parentIdFieldName = parentObjectName + 'Id';
        }
        historyQuery = 'SELECT Id, CreatedById, CreatedBy.Name, CreatedBy.FirstName, CreatedBy.LastName, CreatedDate, Field, IsDeleted, NewValue, OldValue, ' + parentIdFieldName;
        historyQuery += ' FROM ' + historyObjectName;
        historyQuery += ' WHERE ' + parentIdFieldName + ' = \'' + parentId + '\'' + ' AND IsDeleted = false';
        historyQuery += ' ORDER BY CreatedDate DESC';
        
        hist.historyQuery = historyQuery;

        List <SObject> historySobjList;
        try {
            historySobjList = Database.query(historyQuery);
        } catch(Exception e) {
            hist.errorMessage = e.getMessage();
            return hist;
        }
        
        // when records are created/updated in test method, salesforce does not insert records in history table 
        // you can inject test data in history table through this list. 
        if (Test.isRunningTest()) {
            if (testDataList != null) {
                for (TestData td : testDataList) {
                    historySobjList.add(td.historySobj);
                }
            }
        }
        
        // adjust list. created appears one row above last
        List <SObject> sortedSobjList = new List <SObject>();
        SObject createdSobj;
        for (SObject sobj : historySobjList) {
            String fieldName = String.valueOf(sobj.get('Field'));
            if (fieldName != 'created') {
                sortedSobjList.add(sobj);
            } else {
                createdSobj = sobj;
            }
        }
        if (createdSobj != null) {
            sortedSobjList.add(createdSobj);
        }
        
        if (sortedSobjList.size() > 0) {
            hist.updatedBy = getFullName(sortedSobjList[0]); 
            hist.createdBy = getFullName(sortedSobjList[sortedSobjList.size()-1]); 

            Object updatedDate = sortedSobjList[0].get('CreatedDate');
            Object createdDate = sortedSobjList[sortedSobjList.size()-1].get('CreatedDate');
            if (Test.isRunningTest()) {
                if (testDataList != null && testDataList.size() == sortedSobjList.size()) {
                    updatedDate = testDataList[0].updatedOn;
                    createdDate = testDataList[testDataList.size()-1].createdOn;
                }
            }
            if (updatedDate != null) {
                DateTime dt = DateTime.valueOfGmt(String.valueOf(updatedDate));
                hist.updatedOn = updatedDate; //dt.dateGmt();
            }

            if (createdDate != null) {
                DateTime dt = DateTime.valueOfGmt(String.valueOf(createdDate));
                hist.createdOn = createdDate; //dt.dateGmt();
            }
            
            Map<String, Schema.SObjectField> fieldMap = dr.fields.getMap();
            
            for (Integer i=0; i<sortedSobjList.size(); i++) {
                SObject sobj = sortedSobjList[i];
                HistoryItem item = new HistoryItem();
                item.actionBy = getFullName(sobj);  
                if (sobj.get('CreatedDate') != null) { 
                    DateTime dt = DateTime.valueOfGmt(String.valueOf(sobj.get('CreatedDate')));
                    item.actionDate = sobj.get('CreatedDate'); //dt ;//DateTime.valueOf();
                }
                
                String fieldName = String.valueOf(sobj.get('Field'));
                Object oldObj = sobj.get('OldValue');
                Object newObj = sobj.get('NewValue');
                
                // Field OldValue, NewValue not editable
                if (Test.isRunningTest()) {
                    if (testDataList != null && testDataList.size() > i) {
                        oldObj = testDataList[i].oldValue;
                        newObj = testDataList[i].newValue;
                    }
                }
                
                // if you change owner then field name comes as Owner
                if (fieldName == 'Owner') {
                    fieldName = 'OwnerId';
                }
                
                // skip rows like 
                // Changed Owner ID from 00580000003YyqfAAC to 00534000009BUlPAAW
                // Changed CRSM to 005340000089xr0AAA
                if (isLookupIdRow(fieldMap, fieldName, oldObj, newObj)) {
                    continue;
                }
        
                item.action = getAction(parentObjectLabel, parentSobj, fieldMap, fieldName, oldObj, newObj);
                
                hist.items.add(item);
            }
        }
        
        hist.isSuccess = true;
        return hist;    
    }

    private static String getFullName(SObject sobj) {
        // community users see nickname for CreatedBy.Name
        String fullName;
        SObject userSobj = sobj.getSobject('CreatedBy');
        if (userSobj != null) {
            String firstName = String.valueOf(userSobj.get('FirstName'));
            String lastName = String.valueOf(userSobj.get('LastName'));
            fullName = String.IsBlank(firstName) ? lastName : firstName + ' ' + lastName;
        }
        return fullName;
    }

    private static Boolean isLookupIdRow(Map<String, Schema.SObjectField> fieldMap, String fieldName, Object oldObj, Object newObj) {
        Boolean retValue = false;
    
        if (fieldMap.containsKey(fieldName)) {
            Schema.DescribeFieldResult dfr = fieldMap.get(fieldName).getDescribe();
            List <Schema.sObjectType> refList = dfr.getReferenceTo();
            if (refList != null && refList.size() > 0) {
                if ((oldObj != null && isValidId(String.valueOf(oldObj))) || (newObj != null && isValidId(String.valueOf(newObj)))) {
                    retValue = true;
                }
            }
        }
    
        return retValue;
    }

    private static String getAction(String parentObjectLabel, SObject parentSobj, Map<String, Schema.SObjectField> fieldMap, String fieldName, Object oldObj, Object newObj) {
        String action;
        
        system.debug('fieldName: ' + fieldName);
        // if you change account name then field name is appearing as TextName
        if (fieldName == 'TextName') {
            fieldName = 'Name';
        }
        
        if (fieldName == 'created') {
            action = 'Created';
        } else if (fieldMap.containsKey(fieldName)) {
            Schema.DescribeFieldResult dfr = fieldMap.get(fieldName).getDescribe();
            String fieldLabel = dfr.getLabel();
            
            // if you change account owner then action shows as Account Owner. avoid showing as OwnerId.
            if (fieldName == 'OwnerId') {
                fieldLabel = parentObjectLabel + ' Owner';
            }
            
            Schema.DisplayType displayType = dfr.getType();
            if (oldObj == null && newObj == null) {
                // long text, multi picklist fields
                action = 'Changed ' + fieldLabel;
            } else if (oldObj != null && newObj != null) {
                // changed old value to new new value
                action = 'Changed ' + fieldLabel;
                action += ' from ' + getValue(parentSobj, displayType, oldObj);
                action += ' to ' + getValue(parentSobj, displayType, newObj);
            } else if (oldObj == null && newObj != null) {
                // new value set
                action = 'Changed ' + fieldLabel;
                action += ' to ' + getValue(parentSobj, displayType, newObj);
            } else if (oldObj != null && newObj == null) {
                // deleted old value
                action = 'Deleted ' + getValue(parentSobj, displayType, oldObj) + ' in ' + fieldLabel;
            }
            
        }

        return action;
    }

    private static Boolean isValidId(String val) {
        Boolean retValue = true;
        try {
            String idVal = (Id)val;
        } catch(exception e) {
            retValue = false;
        }
        return retValue;    
    }

    private static String getValue(SObject parentSobj, Schema.DisplayType displayType, Object obj) {
        String value;
        if (displayType == Schema.DisplayType.Date) {
            value = Date.valueOf(obj).format();
        } else if (displayType == Schema.DisplayType.DateTime) {
            value = DateTime.valueOf(obj).format();
        } else if (displayType == Schema.DisplayType.Double) {
            value = Double.valueOf(obj).format();
        } else if (displayType == Schema.DisplayType.Integer) {
            value = Integer.valueOf(obj).format();
        } else if (displayType == Schema.DisplayType.Currency) {
            value = String.valueOf(parentSobj.get('currencyIsoCode')) + ' ' + Double.valueOf(obj).format();
        } else {
            value = String.valueOf(obj);
        }
        return value;
    }

    public class Request {
        public String parentId;
    }

    public class History {
        public Boolean isSuccess;
        public String errorMessage;
        public String parentObjectLabel {get; private set;}
        public String historyQuery {get; private set;}
        public String createdBy {get; private set;}
        //public Date createdOn {get; private set;}
        public Object createdOn {get; private set;}
        public String updatedBy {get; private set;}
        //public Date updatedOn {get; private set;}
        public Object updatedOn {get; private set;}
        public List <HistoryItem> items {get; private set;}
        public History() {
            isSuccess = false;
            items = new List <HistoryItem>();
        } 
    }
    public class HistoryItem {
        //public DateTime actionDate {get; private set;}
        public Object actionDate {get; private set;}
        public String actionBy {get; private set;}
        public String action {get; private set;}
    
    }
    public class TestData {
        public SObject historySobj;
        public Object oldValue;
        public Object newValue;
        public Object createdOn;
        public Object updatedOn;
    }

}