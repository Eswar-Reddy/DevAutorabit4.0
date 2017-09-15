/*******************************************************************************************************
* @description GW_RecTypes is a class that is meant to allow for access to Record Type information from
* within other classes.
* It is called statically, and therefore will supply the same information to all calls made from
* within one transaction, or set of trigger calls. This is beneficial because this info should
* be the same for all calls in a transaction, and by calling it statically we reduce the calls
* that are made, making the total transaction more efficient.
*/
global class GW_RecTypes {
    
    //maps to hold the record type info
    private static Map<String, Schema.SObjectType> gd;
    private static Map<String,Map<Id,Schema.RecordTypeInfo>> recordTypesById = new Map<String,Map<Id,Schema.RecordTypeInfo>>();
    private static Map<String,Map<String,Schema.RecordTypeInfo>> recordTypesByName = new Map<String,Map<String,Schema.RecordTypeInfo>>();
    
        
    /*******************************************
    * Gets record type maps for a new object
    ********************************************/
    static void fillMapsForObject(string objectName) {
        // get the object map the first time
        if (gd==null) gd = Schema.getGlobalDescribe();
        
        // get the object description
        if (gd.containsKey(objectName)) {
            Schema.DescribeSObjectResult d = gd.get(objectName).getDescribe();
            recordTypesByName.put(objectName, d.getRecordTypeInfosByName());
            recordTypesById.put(objectName, d.getRecordTypeInfosById());
            
        }
    }

    /*******************************************************************************************************
    * @description Gives record type ID from a given record type name.
    * @param objectName The name of an Object.
    * @param RecordTypeName The name of a Record Type.
    * @return The Record Type's ID.
    */
    global static Id GetRecordTypeId(String objectName, String RecordTypeName) {
        // make sure we have this object's record types mapped
        if (!recordTypesByName.containsKey(objectName)) 
            fillMapsForObject(objectName);
        
        // now grab and return the requested id 
        Map<String,Schema.RecordTypeInfo> rtMap = recordTypesByName.get(objectName);
        if (rtMap != null && rtMap.containsKey(RecordTypeName)) {
            return rtMap.get(RecordTypeName).getRecordTypeId();
        } else {
            return null;
        }
    }
        
    /*******************************************************************************************************
    * @description Gives record name from a given Record Type ID.
    * @param objectName The name of an Object.
    * @param RecordTypeId The ID of a Record Type.
    * @return The Record Type's name.
    */
    global static String GetRecordTypeName(String objectName, Id RecordTypeId) {
        // make sure we have this object's record types mapped
        if (!recordTypesById.containsKey(objectName)) 
            fillMapsForObject(objectName);
        
        // now grab and return the requested id
        Map<Id,Schema.RecordTypeInfo> rtMap = recordTypesById.get(objectName);
        if (rtMap != null && rtMap.containsKey(RecordTypeId)) {
            return rtMap.get(RecordTypeId).getName();
        } else {
            return null;
        }
    }

    /*******************************************************************************************************
    * @description Gives a set of record type IDs from a given set of names.
    * @param objectName The name of an Object.
    * @param RecordTypeNameSet A Set of Record Type names.
    * @return A Set of Record Type IDs.
    */
    global static set<Id> GetRecordTypeIdSet(String objectName, set<string> RecordTypeNameSet) {
        set<Id> recordTypeIds = new set<Id>();

        // make sure we have this object's record types mapped
        if (!recordTypesByName.containsKey(objectName)) 
            fillMapsForObject(objectName);

        // fill the id set from the name set
        if (recordTypesByName.containsKey(objectName)) { 
            Map<String,Schema.RecordTypeInfo> rtMap = recordTypesByName.get(objectName);
            for (String recTypeName : RecordTypeNameSet) {
                if (rtMap.containsKey(recTypeName)) {
                    recordTypeIds.add(rtMap.get(recTypeName).getRecordTypeId());
                }
            }
        }
        return recordTypeIds;
    }
    
    /*******************************************************************************************************
    * @description Gives a map of record type Ids from a given object name.
    * @param objectName The name of an Object.
    * @return A Map of Record Type IDs.
    */
    global static Map<String, Id> GetRecordTypeIdMap(String objectName) {
        Map<String, Id> recordTypeMap = new Map<String, Id>();  
        // make sure we have this object's record types mapped
        if (!recordTypesByName.containsKey(objectName)) 
            fillMapsForObject(objectName);

        // fill the name to id map
        if (recordTypesByName.containsKey(objectName)) { 
            Map<String,Schema.RecordTypeInfo> rtMap = recordTypesByName.get(objectName);
            for (recordTypeInfo rti : rtMap.values()) {
                if (rti.getName() != 'Master')
                    recordTypeMap.put(rti.getName(), rti.getRecordTypeId());
            }
        }
        
        return recordTypeMap;
    }

    /*******************************************
    * Gets record type naming suffix from record type name
    Removed from GWBase since static methods cannot be virtual, but
    client would need to be able to override this with their suffixes,
    if we felt we needed to support this functionality.
    
    global static String GetOppNamingSuffix(String RecordTypeName){
        Map<String,String> OpportunitySufix =  new Map<String,String>();

        //add overrides for naming suffixes
        //OpportunitySufix.put('Gift','Gift Suffix');

        String Suffix;
        Suffix = OpportunitySufix.get(RecordTypeName);
        return (Suffix==null) ? RecordTypeName : Suffix;    
    }
    ********************************************/
    
    /*******************************************************************************************************
    * @description Gives a list of select options for a Visualforce picklist of record types. 
    * @param objectName The name of an Object.
    * @return A list of Select Options.
    */
    global static List<SelectOption> getRecordTypesForSelectList(String objectName) {
        
        List<SelectOption> recordTypesOptions = new List<SelectOption>();
        Map<String,Id> availRecordTypes = getRecordTypeIdMap(objectName);
        if (!availRecordTypes.isEmpty()) {
            for (string thisRecordType : availRecordTypes.keyset()) {
                recordTypesOptions.add(new SelectOption(availRecordTypes.get(thisRecordType), thisRecordType)); 
            }
        }
        return recordTypesOptions;
    }

    
    /*******************************************************************************************************
    *@description Gives a list of record types given an sOject
    *param objectName The name of an Object
    *@return A list of record types for a given sObject 
    */
    global static List<RecordType> getRecordTypeforSelectedObject(String objectName)
    {
        List<RecordType> lstRecordTypes = new List<RecordType>();
        if (!recordTypesByName.containsKey(objectName)) 
            fillMapsForObject(objectName);
            
        if (recordTypesByName.containsKey(objectName)) 
        {
            Map<String,Schema.RecordTypeInfo> rtMap = recordTypesByName.get(objectName);
            for (Schema.RecordTypeInfo rti : rtMap.values()) 
            {
                if (rti.getName() != 'Master')
                    lstRecordTypes.add(new RecordType(id = rti.getRecordTypeId(),Name = rti.getName(),SobjectType = objectName));
            }

        }
        return lstRecordTypes;
    }
    
    global static List<RecordType> getRecordTypeforSelectedObjectList(List<String> lstobjectName)
    {
        List<RecordType> lstRecordTypes = new List<RecordType>();
        for(String objectName : lstobjectName)
        {
            if (!recordTypesByName.containsKey(objectName)) 
            fillMapsForObject(objectName);
            
            if (recordTypesByName.containsKey(objectName)) 
            {
                Map<String,Schema.RecordTypeInfo> rtMap = recordTypesByName.get(objectName);
                for (Schema.RecordTypeInfo rti : rtMap.values()) 
                {
                    if (rti.getName() != 'Master')
                        lstRecordTypes.add(new RecordType(id = rti.getRecordTypeId(),Name = rti.getName(),SobjectType = objectName));
                }

            }
        }
        return lstRecordTypes;
    }
    
    
    
    
    // TEST
    static testmethod void testRecTypes() {
        // try bogus values
        Id reallyBogus = GetRecordTypeId('Bogus', 'Bogus');
        System.assert(reallyBogus == null);
        Id bogus = GetRecordTypeId('Opportunity', 'Bogus');
        System.assert(bogus == null);
        bogus = GetRecordTypeId('Contact', 'Bogus');
        System.assert(bogus == null);
        bogus = GetRecordTypeId('Campaign', 'Bogus');
        System.assert(bogus == null);
        
        // try all the functions
        set<Id> oppRtSet = GetRecordTypeIdSet('Opportunity', (new set<string>{'Bogus', 'Master', 'Grant'}));
        Map<String, Id> oppTypeMap = GetRecordTypeIdMap('Opportunity');
        List<SelectOption> rtOptions = getRecordTypesForSelectList('Opportunity');
        //system.assertEquals('TestName',GetOppNamingSuffix('TestName'));
        
        // check against queried rectypes
        list<recordtype> ort = [select id, name from recordtype where isactive=true and sobjecttype='Opportunity' limit 1];
        if (!ort.isEmpty()) {
            Id rtId = GetRecordTypeId('Opportunity', ort[0].name);
            system.assertEquals(ort[0].id, rtId); 
            String rtName = GetRecordTypeName('Opportunity', ort[0].id);
            system.assertEquals(ort[0].name, rtName); 

            // the sets above should contain something too
            system.assert(oppRtSet.size() > 0);
            system.assert(oppTypeMap.size() > 0);
            system.assert(rtOptions.size() > 0);            
        }       
    }
    
    static testMethod void TestRecordTypes() {

        // we are willing to assume that Gift and Grant recordtypes always exist in our base.   

        ID idCommercial = GW_RecTypes.GetRecordTypeId('Opportunity', 'Commercial' );
        ID idSystems = GW_RecTypes.GetRecordTypeId('Opportunity', 'Systems');
        system.Assert(idCommercial != idSystems);
        
        Set<String> setStr = new Set<String>{'Commercial', 'Systems'};
        Set<Id> setId = GW_RecTypes.GetRecordTypeIdSet('Opportunity', setStr);
        system.Assert(setId.contains(idCommercial));
        system.Assert(setId.contains(idSystems));
        
        Map<String, Id> mapRCId = GW_RecTypes.GetRecordTypeIdMap('Opportunity');
        system.AssertEquals(idCommercial, mapRCId.get('Commercial'));       
        system.AssertEquals(idSystems, mapRCId.get('Systems'));
        
        system.AssertEquals('Commercial', GW_RecTypes.GetRecordTypeName('Opportunity', idCommercial));      
        system.AssertEquals('Systems', GW_RecTypes.GetRecordTypeName('Opportunity', idSystems));        
        
        //system.AssertEquals(rectype1, GW_RecTypes.GetOppNamingSuffix(rectype1));      

        List<SelectOption> listSO = GW_RecTypes.getRecordTypesForSelectList('Opportunity');
        system.Assert(listSO.IsEmpty() == false);     
        
        List<RecordType> lstRT = GW_RecTypes.getRecordTypeforSelectedObject('Opportunity'); 
        
        List<String> lstObjNames = new String[3];
        lstObjNames [0] = 'Account';
        lstObjNames [1] = 'Opportunity';
        lstObjNames [2] = 'Contact';
        List<RecordType> lstAllRT = GW_RecTypes.getRecordTypeforSelectedObjectList(lstObjNames); 
        
        
    }       
}