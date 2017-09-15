public class SobjectService {
    public static List<String> getAllFields(SobjectType sobjectType) {
        Map<String, SobjectField> nameToField = sobjectType.getDescribe().fields.getMap();

        List<String> fields = new List<String>();
        for(String name : nameToField.keySet()) {
            SobjectField field = nameToField.get(name);
            fields.add(String.valueOf(field));
        }

        return fields;
    }

    static List<Sobject> matchOrdering(List<Sobject> masters, List<Sobject> records) {
        Map<Id, Sobject> idToRecord = new Map<Id, Sobject>(records);
        List<Sobject> orderedRecords = new List<Sobject>();

        for(Sobject master : masters) {
            orderedRecords.add(idToRecord.get(master.Id));
        }

        return orderedRecords;
    }

    public static List<Sobject> selectStar(List<Sobject> records) {
        if(records.isEmpty()) {
            return new List<Sobject>();
        }

        SobjectType sobjectType = records[0].getSObjectType();

        String query = ''
            + ' SELECT ' + String.join(getAllFields(sobjectType), ', ')
            + ' FROM ' + sobjectType
            + ' WHERE Id IN :records';

        List<Sobject> queriedRecords = Database.query(query);

        return matchOrdering(records, queriedRecords);
    }

    public static void massSet(List<Sobject> records, SobjectField field, Object value) {
        for(Sobject record : records) {
            record.put(field, value);
        }
    }

    public static void massAppend(List<Sobject> records, SobjectField field, String suffix) {
        for(Sobject record : records) {
            record.put(field, record.get(field) + suffix);
        }
    }

    public static void massCopyField(List<Sobject> fromRecords, SobjectField fromField, List<Sobject> toRecords, SobjectField toField) {
        for(Integer i = 0; i < fromRecords.size(); i++) {
            toRecords[i].put(toField, fromRecords[i].get(fromField));
        }
    }

    public static List<Sobject> createSobjects(SobjectType objectType, Integer n) {
        List<Sobject> records = new List<Sobject>();

        for(Integer i = 0; i < n; i++) {
            records.add(objectType.newSobject());
        }

        return records;
    }

    public static void copyFields(Map<String, String> mapping, Sobject x, Sobject y) {
        for(String xfield : mapping.keySet()) {
            String yfield = mapping.get(xfield);

            x.put(xfield, FieldReference.build(yfield).getFrom(y));
        }
    }

    public static void copyFields(Map<String, String> mapping, List<Sobject> xs, List<Sobject> ys) {
        for(Integer i = 0; i < xs.size(); i++) {
            copyFields(mapping, xs[i], ys[i]);
        }
    }

    public static Sobject initWithFields(Map<String, String> mapping, Sobject fromRecord, SobjectType objectType) {
        Sobject toRecord;

        if(mapping.containsKey('Id')) {
            String fieldContainingId = mapping.get('Id');
            Id idValue = (Id) FieldReference.build(fieldContainingId).getFrom(fromRecord);
            toRecord = objectType.newSobject(idValue);
            mapping = mapping.clone();
            mapping.remove('Id');
        } else {
            toRecord = objectType.newSobject();
        }

        copyFields(mapping, toRecord, fromRecord);

        return toRecord;
    }

    public static Map<String, String> getAssignmentMap(List<Sobject> records, SobjectField x, SobjectField y) {
        return getAssignmentMap(records, FieldReference.build(x), FieldReference.build(y));
    }

    static Map<String, String> getAssignmentMap(List<Sobject> records, FieldReference x, FieldReference y) {
        Map<String, String> assignmentMap = new Map<String, String>();

        for(Sobject record : records) {
            assignmentMap.put((String)x.getFrom(record), (String)y.getFrom(record));
        }

        return assignmentMap;
    }

    public static List<Sobject> filterSobjects(List<Sobject> records, Set<Id> ids) {
        List<Sobject> ret = new List<Sobject>();

        for(Sobject record : records) {
            if(ids.contains(record.Id)) {
                ret.add(record);
            }
        }

        return ret;
    }
}