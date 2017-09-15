public class HelixPPAPickList {
    public final String objectName;
    public final String fieldName;
    public String selectedValue {get; set;}
    public List <PicklistOption> options {get; set;}
    public HelixPPAPickList(String objectName, String fieldName, String selectedValue) {
        // init
        this.objectName = objectName;
        this.fieldName = fieldName;
        this.selectedValue = selectedValue;
        this.options = new List <PicklistOption>();
        // get options
        this.options = getOptions(objectName, fieldName);
    }

    public class PicklistOption {
        public String value {get; private set;}
        public String label {get; private set;}
        public PicklistOption(String value, String label) {
            this.value = value;
            this.label = label;
        }
    }
    
    // maintain a cache of options. 
    private static Map <String, List <PicklistOption>> optionsMap = new Map <String, List <PicklistOption>>();
    
    private static List <PicklistOption> getOptions(String objectName, String fieldName) {
        List <PicklistOption> options = new List <PicklistOption>();
        
        // return cloned copy from cache if exists
        String key = objectName + '.' + fieldName;
        if (optionsMap.containsKey(key)) {
            return optionsMap.get(key).clone();
        }
        Map<String, Schema.SObjectType> gdMap = Schema.getGlobalDescribe();
        if (gdMap.containsKey(objectName)) {
            Map<String, Schema.SObjectField> fieldMap = gdMap.get(objectName).getDescribe().fields.getMap();
            if (fieldMap.containsKey(fieldName)) {
                Schema.DescribeFieldResult dfr = fieldMap.get(fieldName).getDescribe();
                List<Schema.PicklistEntry> pleList = dfr.getPicklistValues();
                
                options.add(new PicklistOption('', '--None--'));
                for (Schema.PicklistEntry ple : pleList) {
                    if (ple.isActive()) {
                        options.add(new PicklistOption(ple.getValue(), ple.getLabel()));
                    }
                }
                optionsMap.put(key, options);
            }
        }
        return options;    
    }
    
}