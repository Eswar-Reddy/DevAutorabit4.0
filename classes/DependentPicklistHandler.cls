public with sharing class DependentPicklistHandler {
	
	@RemoteAction
	public static CustomDependentPicklist getPicklistDependency(String controllingField) {

		if(String.isBlank(controllingField)) return new CustomDependentPicklist(null);

		CustomDependentPicklist picklist = new CustomDependentPicklist(controllingField);

		for(Dependent_Picklist_Controller__mdt controller : [SELECT Id, Field_Label__c, Value__c,
																	(SELECT Id, Field_Label__c, Value__c
																	 FROM Dependent_Picklist_Values__r) 
															 FROM Dependent_Picklist_Controller__mdt
															 WHERE Field_Label__c =: controllingField
															 ORDER BY Value__c ASC]) {
			List<String> dependencies = new List<String>();
			for(Dependent_Picklist_Value__mdt child : controller.Dependent_Picklist_Values__r) {
				dependencies.add(child.Value__c);
				if(String.isBlank(picklist.dependentField))
					picklist.dependentField = child.Field_Label__c;
			}
			picklist.optionsMap.put(controller.Value__c, dependencies);
		}
		picklist.success = true;
		return picklist;
	}


	public class CustomDependentPicklist {	
		public Map<String, List<String>> optionsMap {get;set;}
		public Boolean success {get;set;}
		public String controllingField {get;set;}
		public String dependentField {get;set;}
		
		public CustomDependentPicklist(String controllingField) {
			this.optionsMap = new Map<String, List<String>>();
			this.success = false;
			this.controllingField = controllingField;
		}

		public CustomDependentPicklist() { /*EMPTY CONSTRUCTOR*/ }
	}
}