public class BuildSOQLQuery{
    
    public Static String buildQuery(String objectName,String clause){
        if(clause == null || clause == '')
            return null;	
        Map<String,Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        
        List<String> fields = new List<String>();
        String query = '';
        
        if(fieldMap != null){
            for(Schema.SObjectField sf : fieldMap.values()){
                Schema.DescribeFieldResult dfr = sf.getDescribe();
                //	if(dfr.isCreateable()){
                fields.add(dfr.getName());
                //	}
            }
        }
        
        if(!fields.isEmpty()){
            for(String s : fields){
                query += s + ',';
            }
        }
        
        if(query.endsWith(',')){
            query = query.substring(0,query.lastIndexOf(','));
        }
        
        return 'SELECT ' + query + ' FROM ' +  objectName + ' WHERE ' + clause; 			
    }
    
    public static String buildQueryBase(String objectName) {
        Map<String,Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        
        List<String> fields = new List<String>();
        String query = '';
        
        if(fieldMap != null){
            for(Schema.SObjectField sf : fieldMap.values()){
                Schema.DescribeFieldResult dfr = sf.getDescribe();
                fields.add(dfr.getName());
            }
        }
        
        if(!fields.isEmpty()){
            for(String s : fields){
                query += s + ',';
            }
        }
        
        if(query.endsWith(',')){
            query = query.substring(0,query.lastIndexOf(','));
        }
        
        String result = 'SELECT ' + query + ' FROM ' + objectName + ' WHERE Id IN: XXX';
        System.debug('RESULT: ' + result);
        return result;
    }
    
}