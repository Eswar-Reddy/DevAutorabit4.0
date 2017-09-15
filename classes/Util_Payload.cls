public class Util_Payload {

    public Map<String, Map<String, PayloadSettings__c>> sObjectFieldMap {get; private set;}
    public List<PayloadSettings__c> settings {get; private set;}

    public Util_Payload(String application) {
        loadSettings(application);
    }

    //Pulls all Spectrum Settings and populates usable Map to hold data.
    public static Boolean hasAction(String xaction, PayloadSettings__c ps) {

	    for (String s: ps.Action__c.Split(',')){
	    	if (xaction.equals(s)){
	    		return true;
	    	}
	    }

	    return false;
    }

    //Pulls all Spectrum Settings and populates usable Map to hold data.
    private void loadSettings(String application) {
        sObjectFieldMap = new Map<String, Map<String, PayloadSettings__c>>();

        //Instance method of List Custom Settings to get all in the list
        settings = PayloadSettings__c.getAll().values();
        for (PayloadSettings__c ss : settings) {

            if (ss.application__c != application) {
                continue;
            }

            //Check for key and create Map of Map
            if (!sObjectFieldMap.containsKey(ss.sObject_Name__c))
                sObjectFieldMap.put(ss.sObject_Name__c, new Map<String, PayloadSettings__c>());

            //Populates Map with JsonString and actual apiname. The Json String will make the json object "pretty"
            Map<String, PayloadSettings__c> jsonFieldMap = sObjectFieldMap.get(ss.sObject_Name__c);
            if (ss.JSON_Name__c != null)
                jsonFieldMap.put(ss.JSON_Name__c, ss);
            else
                jsonFieldMap.put(ss.Field_API_Name__c, ss);

        }
    }

}