public with sharing class MetadataRetrievalUtil {
	
	/*Constants*/
	@TestVisible
	private static String SoapEndpoint = Label.SoapURL;

	/*Variables*/



	/*Constructors*/
	public MetadataRetrievalUtil() {
		
	}

	@RemoteAction
	public static ResultMessage retrievePicklistsForRecordType(String sObjectType, String[] recTypeIds) { //TODO: Handle internally for multiple record types

		ResultMessage result = new ResultMessage();
		result.success = false;

		if(recTypeIds == null || recTypeIds.isEmpty() || String.isBlank(sObjectType)) {
			result.message = SPCommunityErrorUtility.invalidParams;
			return result;
		}

		Map<String, List<SelectOption>> picklistMap = new Map<String, List<SelectOption>>();
		try {
			//init handler
			sobjectPartnerSoapSforceCom.Soap handler = getSOAPHandler();

			//get layouts
			sobjectPartnerSoapSforceCom.DescribeLayoutResult LayoutResult = handler.describeLayout(sObjectType, recTypeIds); //TODO try/catch

			if(LayoutResult == null || LayoutResult.recordTypeMappings == null || LayoutResult.recordTypeMappings.size() == 0) {
				//todo: empty result error here
			} else {
				//We have results, now handle them
				picklistMap = getPicklistMapping(LayoutResult);
			}
			result.payloadMap.put('picklists', picklistMap);
			result.success = true;
			
		} catch(Exception e) {
			result.err = JSON.deserializeUntyped(SPCommunityErrorUtility.generateExceptionJSON(e));
		}

		return result;
	}

	//used for specific record type mappings
    public static Map<String,Id> getRecordTypeMap() {
        Map<String,Id> objRecordTypeMap = new Map<String, Id> {
            'Site_Information_Form__c' => SFDCSpecialUtilities.getRecordTypeIdsByDeveloperName(Site_Information_Form__c.sObjectType).get('Standard_Site'),
            'Contact' => SFDCSpecialUtilities.getRecordTypeIdsByDeveloperName(Contact.sObjectType).get('Customer')
        };
        return objRecordTypeMap;
    }

	public static Map<String, List<SelectOption>> getPicklistMapping(sobjectPartnerSoapSforceCom.DescribeLayoutResult LayoutResult) {
		Map<String, List<SelectOption>> picklistMap = new Map<String, List<SelectOption>>();
		for(Integer i = 0; i < LayoutResult.recordTypeMappings.size(); i++) {
		    sobjectPartnerSoapSforceCom.RecordTypeMapping recTypeMapping = LayoutResult.recordTypeMappings[i];
		    for(Integer x = 0; x < recTypeMapping.picklistsForRecordType.size(); x++) {
		        sObjectPartnerSoapSforceCom.PicklistForRecordType picklistforRecType = recTypemapping.picklistsForRecordType[x];
		        List<SelectOption> availableVals = new List<SelectOption>();
		        if(picklistforRecType.picklistValues != null) {
		            for(sObjectPartnerSoapSforceCom.PicklistEntry pVal : picklistforRecType.picklistValues) {
		                availableVals.add(new SelectOption(pVal.value, pVal.label));
		            }
		        } 
		        picklistMap.put(picklistforRecType.picklistName, availableVals);
		    }
		}
		return picklistMap;
	}

	public static sobjectPartnerSoapSforceCom.Soap getSOAPHandler() {
		sobjectPartnerSoapSforceCom.Soap handler = new sobjectPartnerSoapSforceCom.Soap();
		handler.endpoint_x = SoapEndpoint;
		sobjectPartnerSoapSforceCom.SessionHeader_element sessionHeader = new sobjectPartnerSoapSforceCom.SessionHeader_element();
		sessionHeader.sessionId = UserInfo.getSessionId();
		handler.SessionHeader = sessionHeader;

		return handler;
	}

	@RemoteAction
	public static ResultMessage getPicklistValues(String sObjectType, String fieldAPIName) {
		ResultMessage result = new ResultMessage();
		result.success = false;

		if(String.isBlank(sObjectType) || String.isBlank(fieldAPIName)) {
			result.message = SPCommunityErrorUtility.invalidParams;
			return result;
		}

		Map<String, List<SelectOption>> picklistMap = new Map<String, List<SelectOption>>();
		picklistMap.put(fieldAPIName, getOptions(sObjectType, fieldAPIName));
		result.payloadMap.put('picklists', picklistMap);
		result.success = true;
		return result;
	}

	private static List<SelectOption> getOptions(String sObjectType, String fieldAPIName) {
		List<SelectOption> options = new List<SelectOption>();

		Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
		Schema.SObjectType schemaType = gd.get(sObjectType);
		Map<String, Schema.SobjectField> fmap = schemaType.getDescribe().fields.getMap();
		Schema.DescribeFieldResult schemaField = fmap.get(fieldAPIName).getDescribe();

  		for( Schema.PicklistEntry f : schemaField.getPicklistValues()) {
     		options.add(new SelectOption(f.getValue(), f.getLabel()));
  		}

  		return options;
	}

	@RemoteAction
	public static ResultMessage getFieldMapForObject(String sObjectType) {
		ResultMessage result = new ResultMessage();
		result.success = false;

		if(String.isBlank(sObjectType)) {
			result.message = SPCommunityErrorUtility.invalidParams;
			return result;
		}
		Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
		Schema.SObjectType schemaType = gd.get(sObjectType);
		Map<String, Schema.SobjectField> fmap = schemaType.getDescribe().fields.getMap();
		result.payloadMap.put('fieldsMap', fmap);
		result.success = true;

		return result;
	}

	@RemoteAction
	public static ResultMessage getRecordTypeIdsForObject(String sObjectType) {
		ResultMessage result = new ResultMessage();
		result.success = false;

		if(String.isBlank(sObjectType)) {
			result.message = SPCommunityErrorUtility.invalidParams;
			return result;
		}

		Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
		Schema.SObjectType schemaType = gd.get(sObjectType);
		result.payloadMap.put('recordTypeMappings', SFDCSpecialUtilities.getRecordTypeIdsByDeveloperName(schemaType));
		result.success = true;

		return result;
	}

	//Picklist dependencies
	public class PickListInfo { 
        public String validFor; 
    }

    public static Map<String, List<String>> getFieldDependencies(String objectName, String controllingField, String dependentField) {
        Map<String, List<String>> controllingInfo = new Map<String, List<String>>();

        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);

        Schema.DescribeSObjectResult describeResult = objType.getDescribe();
        Schema.DescribeFieldResult controllingFieldInfo = describeResult.fields.getMap().get(controllingField).getDescribe();
        Schema.DescribeFieldResult dependentFieldInfo = describeResult.fields.getMap().get(dependentField).getDescribe();

        List<Schema.PicklistEntry> controllingValues = controllingFieldInfo.getPicklistValues();
        List<Schema.PicklistEntry> dependentValues = dependentFieldInfo.getPicklistValues();

        for(Schema.PicklistEntry currControllingValue : controllingValues)
        {
            controllingInfo.put(currControllingValue.getLabel(), new List<String>());
        }

        for(Schema.PicklistEntry currDependentValue : dependentValues)
        {
            String jsonString = JSON.serialize(currDependentValue);

            PickListInfo info = (PickListInfo) JSON.deserialize(jsonString, PickListInfo.class);

            String hexString = EncodingUtil.convertToHex(EncodingUtil.base64Decode(info.validFor)).toUpperCase();

            Integer baseCount = 0;

            for(Integer curr : hexString.getChars())
            {
                Integer val = 0;

                if(curr >= 65)
                {
                    val = curr - 65 + 10;
                }
                else
                {
                    val = curr - 48;
                }

                if((val & 8) == 8)
                {
                    controllingInfo.get(controllingValues[baseCount + 0].getLabel()).add(currDependentValue.getLabel());
                }
                if((val & 4) == 4)
                {
                    controllingInfo.get(controllingValues[baseCount + 1].getLabel()).add(currDependentValue.getLabel());                    
                }
                if((val & 2) == 2)
                {
                    controllingInfo.get(controllingValues[baseCount + 2].getLabel()).add(currDependentValue.getLabel());                    
                }
                if((val & 1) == 1)
                {
                    controllingInfo.get(controllingValues[baseCount + 3].getLabel()).add(currDependentValue.getLabel());                    
                }

                baseCount += 4;
            }            
        } 
        return controllingInfo;
    }
}