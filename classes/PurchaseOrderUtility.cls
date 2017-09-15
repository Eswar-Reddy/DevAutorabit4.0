/*
    Created By: Delivery Team
    Created:    Summer 2017

    Used by the Purchase Order Delta Controller for change orders

    The getChanges method is used to compare two purchase orders and their lines based on the active Purchase Order Delta Metadata records (custom metadata) and returns a list of changed data (wrapper class) to the caller.
*/

public without sharing class PurchaseOrderUtility {

    // public method to get list of purchase order changes
    public static List<ChangedData> getChanges(Id newPOId, Id oldPOId) {
        // list of changed data
        List<ChangedData> result = new List<ChangedData>();
        try {
            // get the objects/fields for comparsion - map is object name/list of metadata
            Map<String, List<Purchase_Order_Delta_Metadata__mdt>> objectInfo = getMetadata();
            // map of queries to be run - map is object name/query
            Map<String, String> queries = new Map<String, String>();
            // convert objects/fields into queries
            for(String k : objectInfo.keySet()) {
                queries.put(k, buildQuery(k, objectInfo.get(k)));
            }
            // query for records
            for(String k : queries.keySet()) {
                String qry = queries.get(k);
                // query for new and old records
                List<SObject> newRecord = getData(addId(qry, newPOId));
                List<SObject> oldRecord = getData(addId(qry, oldPOId));
                // check query results
                if(!newRecord.isEmpty() && !oldRecord.isEmpty()) {
                    // get the list of fields for this object
                    List<Purchase_Order_Delta_Metadata__mdt> fields = objectInfo.get(k);
                    // compare records
                    result.addAll(compareRecords(k, fields, newRecord[0], oldRecord[0]));
                } else {
                    // TODO: not sure what to do if only one list is empty... if both are empty that's fine.
                }
            }
        }
        catch(Exception e) {
            System.debug('getChanges error: ' + e.getMessage() + ' - ' + e.getStackTraceString());
        }
        return result;
    }

    // get the objects/fields that are subject to comparison
    private static Map<String, List<Purchase_Order_Delta_Metadata__mdt>> getMetadata() {
        Map<String, List<Purchase_Order_Delta_Metadata__mdt>> result = new Map<String, List<Purchase_Order_Delta_Metadata__mdt>>();
        // vars for loop
        String obj;
        // loop over metadata to build map
        for(Purchase_Order_Delta_Metadata__mdt pomd : [SELECT ObjectName__c, FieldName__c, PurchaseOrderId__c FROM Purchase_Order_Delta_Metadata__mdt WHERE isActive__c = true ORDER BY ObjectName__c, FieldName__c]) {
            // check/set the object name
            if(String.isBlank(obj)) {
                obj = pomd.ObjectName__c;
                result.put(obj, new List<Purchase_Order_Delta_Metadata__mdt>());
                result.get(obj).add(pomd);
            } else if(pomd.ObjectName__c == obj) {
                result.get(obj).add(pomd);
            } else { // object changed
                obj = pomd.ObjectName__c;
                result.put(obj, new List<Purchase_Order_Delta_Metadata__mdt>());
                result.get(obj).add(pomd);
            }
        }
        return result;
    }

    // buld the queries for each object and return the map of query strings
    private static String buildQuery(String obj, List<Purchase_Order_Delta_Metadata__mdt> objectInfo) {
        String result;
        // vars for select, from and where
        String sel = 'SELECT ';
        String whr = ' WHERE ' + objectInfo[0].PurchaseOrderId__c + ' = ';
        // build query strings
        for(Purchase_Order_Delta_Metadata__mdt pomd : objectInfo) {
            sel += pomd.FieldName__c + ', ';
        }
        result = sel.removeEnd(', ') + ' FROM ' + obj + whr;
        return result;
    }

    // run the query
    private static List<SObject> getData(String qry) {
        List<SObject> result;
        try {
            result = Database.query(qry);
        }
        catch(Exception e) {
            // something is wrong with the query
            System.debug('getData query error ' + e.getMessage() + ' - ' + e.getStackTraceString());
        }
        return result;
    }

    private static String addId(String qry, Id recordId) {
        return qry + '\'' + recordId + '\'';
    }

    // get the delta
    private static List<ChangedData> compareRecords(String obj, List<Purchase_Order_Delta_Metadata__mdt> fields, SObject newRecord, SObject oldRecord) {
        List<ChangedData> result = new List<ChangedData>();
        // setup describe info to get labels
        Schema.SObjectType sObjType = newRecord.Id.getSObjectType();
        // compare data based on metadata records
        for(Purchase_Order_Delta_Metadata__mdt pomd : fields) {
            // check field values for differences
            if(newRecord.get(pomd.FieldName__c) != oldRecord.get(pomd.FieldName__c)) {
                // create changed data record
                ChangedData cd = new ChangedData();
                cd.objectId = newRecord.Id;
                cd.objectName = obj;
                cd.objectLabel = sObjType.getDescribe().getLabel();
                cd.fieldName = pomd.FieldName__c;
                cd.fieldLabel = getFieldLabel(sObjType, pomd.FieldName__c);
                cd.fieldType = getFieldType(sObjType, pomd.FieldName__c);
                String n, o;
                n = String.valueOf(newRecord.get(pomd.FieldName__c));
                o = String.valueOf(oldRecord.get(pomd.FieldName__c));
                cd.newValue = String.isNotBlank(n) ? n : '--';
                cd.oldValue = String.isNotBlank(o) ? o : '--';
                // add record to list
                result.add(cd);
            }
        }
        return result;
    }

    // get the line data for the po's
    public static List<ChangedData> getLineChanges(Id newPOId, Id oldPOId) {
        List<ChangedData> lines = new List<ChangedData>();
        Map<String, Purchase_Order_Line__c> oldLines = new Map<String, Purchase_Order_Line__c>();
        // get the old lines
        for(Purchase_Order_Line__c l : [SELECT Item_Number__c, Item_Description__c, Quantity__c, Unit_Price__c, Price__c FROM Purchase_Order_Line__c WHERE Purchase_Order__c = :oldPOId ORDER BY Item_Number__c]) {
            oldLines.put(l.Item_Number__c, l);
        }
        // get the new lines
        for(Purchase_Order_Line__c l : [SELECT Item_Number__c, Item_Description__c, Quantity__c, Unit_Price__c, Price__c FROM Purchase_Order_Line__c WHERE Purchase_Order__c = :newPOId ORDER BY Item_Number__c]) {
            // get the old lines data for this item
            Purchase_Order_Line__c ol = oldLines.get(l.Item_Number__c);
            // get the delta if any
            lines.addAll(parseLine(l, ol));
            // remove item so we have a list w/old items not on new po
            oldLines.remove(l.Item_Number__c);
        }
        // add remaining old lines
        for(Purchase_Order_Line__c l : oldLines.values()) {
            lines.addAll(parseLine(null, l));
        }
        return lines;
    }

    // parse line changes
    private static List<ChangedData> parseLine(Purchase_Order_Line__c newLine, Purchase_Order_Line__c oldLine) {
        List<ChangedData> result = new List<ChangedData>();
        // list of fields for compare
        List<String> fields = new List<String> {'Quantity__c', 'Unit_Price__c', 'Price__c'};
        // check nulls
        if(newLine != null && oldLine != null) {
            // compare values
            if(newLine.Quantity__c != oldLine.Quantity__c || newLine.Unit_Price__c != oldLine.Unit_Price__c || newLine.Price__c != oldLine.Price__c) {
                for(String f : fields) {
                    result.add(getLineChange(f, newLine, oldLine));
                }
            }
        } else {
            // new or removed item in lines
            for(String f : fields) {
                result.add(getLineChange(f, newLine, oldLine));
            }
        }
        return result;
    }

    // line changes
    private static ChangedData getLineChange(String field, Purchase_Order_Line__c newLine, Purchase_Order_Line__c oldLine) {
        ChangedData result = new ChangedData();
        // setup describe info to get label
        Schema.SObjectType sObjType = newLine != null ? newLine.Id.getSObjectType() : oldLine.Id.getSObjectType();
        // setup changes
        result.objectName = 'Purchase_Order_Line__c';
        result.objectLabel = newLine != null ? newLine.Item_Number__c + ' - ' + newLine.Item_Description__c : oldLine.Item_Number__c + ' - ' + oldLine.Item_Description__c;
        result.fieldName = field;
        result.fieldLabel = getFieldLabel(sObjType, field);
        result.fieldType = getFieldType(sObjType, field);
        result.newValue = newLine != null ? String.valueOf(newLine.get(field)) : '--';
        result.oldValue = oldLine != null ? String.valueOf(oldLine.get(field)) : '--';
        return result;
    }

    private static String getFieldLabel(Schema.SObjectType sObjType, String strField) {
        Schema.DescribeSObjectResult dor = sObjType.getDescribe();
        Schema.DescribeFieldResult dfr = dor.fields.getMap().get(strField).getDescribe();
        return dfr.getLabel();
    }

    private static Schema.DisplayType getFieldType(Schema.SObjectType sObjType, String strField) {
        Schema.DescribeSObjectResult dor = sObjType.getDescribe();
        Schema.DescribeFieldResult dfr = dor.fields.getMap().get(strField).getDescribe();
        return dfr.getType();
    }

    // wrapper for changed data
    public class ChangedData {
        public Id objectId;
        public String objectName;
        public String objectLabel {get; set;}
        public String fieldName;
        public String fieldLabel {get; set;}
        public Schema.DisplayType fieldType {get; set;}
        public String newValue {get; set;}
        public String oldValue {get; set;}
    }

    public static String getPODeltaURL(Id newPOId, Id oldQuoteId) {
        String result;
        if(String.isNotBlank(oldQuoteId)) {
            for(Purchase_Order__c p : [SELECT Id FROM Purchase_Order__c WHERE Quote__c = :oldQuoteId AND Order_Status__c = 'Processed']) {
                result = '/apex/PurchaseOrderDelta?newPOId=' + newPOId + '&oldPOId=' + p.Id;
            }
        }
        return result;
    }
}