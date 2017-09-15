//Modified By Vishal :
//Added one more field named Rule_Advance_Logic__c in the SOQL query 
public with sharing class QualificationServices
{
	public static final String BOOLEAN_RULE_TYPE = 'Boolean';
	public static final String TEXT_RULE_TYPE = 'Text';

	/**
	* @description	Get qualification from the DynaForm Id
	* @return Qualification__c	Qualification with related Qualification Rules
	*/
	public static Qualification__c getQualificationByFormId(Id formId)
	{
		List<Dynaform__c> forms = [
			SELECT Id, Qualification__c
			FROM Dynaform__c
			WHERE Id = :formId
		];

		if( forms.isEmpty() || forms[0].Qualification__c == null)
		{
			return null;
		}

		return [
			SELECT Name,Rule_Advance_Logic__c,
			 (SELECT Field_API_Name__c, Accepted_Values__c, Field_Type__c, Eloqua_Field_Name__c,
			 		Disqualified_Reason__c, Order__c
			  FROM Qualification_Rules__r ORDER BY Order__c ASC)
			FROM Qualification__c
			WHERE Id = :forms[0].Qualification__c
		];
	}
}