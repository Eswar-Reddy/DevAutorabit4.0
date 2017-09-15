/*
   Copyright 2011 Mavens Consulting, Inc.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
@isTest
public with sharing class SmartFactory {
	public static boolean FillAllFields = false;

	// Key : SobjectAPIName  For ex. Account
	// Value : Map<String, Schema.SObjectField>, field map (k:fieldname, v:Schema.Sobjectfield)
	public static Profile userProfile = [Select Id from Profile where Name = 'SunPower Admin(No Deployment)'];

	private static final Map<String, Map<String, Schema.SObjectField>> FieldMapCache = new Map<String, Map<String, Schema.SObjectField>>();

	private static final Map<String, Schema.SObjectType> GlobalDescribe = Schema.getGlobalDescribe();

	// Default Country and State
	// When Country and State Picklists are enabled, cannot dynamically resolve which States are within a Country
	public static string DefaultCountry = 'United States';
	public static string DefaultState = 'CA';

	// Key: sobject.field
	// Value: first picklist value
	private static final Map<String, String> DefaultPicklistValue = new Map<String, String>();

	// can't map by Schema.sObjectType, use object name String instead
	public static map<String, set<String>> ExcludedFields = new map<String, set<String>>{
		'All' => new set<String>{'OwnerId', 'LastModifiedById', 'CreatedById', 'LastModifiedDate', 'CreatedDate'},
		'Account' => new set<String>{'FirstName', 'LastName'},
		'User' => new set<String>{'IsActive','DelegatedApproverId','CallCenterId','ContactId','DelegatedApproverId','ManagerId','UserRoleId','FederationIdentifier'}
	};

	// include nillable fields
	public static map<String, set<String>> IncludedFields = new map<String, set<String>>{

		// Standard Objects -- TestFactory_StandardObjects
		'User' => new set<String>{'Division','Country', 'FirstName','LastName','Username','Alias','TimeZoneSidKey','EmailEncodingKey','LanguageLocaleKey','Email','LocaleSidKey'},
		'Account' => new set<String>{'Name','BillingState','BillingStreet','BillingCountry','BillingCity','BillingPostalCode'},
		'Contact' => new set<String>{'FirstName','LastName','Email'},
		'Opportunity' => new set<String>{'Customer_Street__c','Customer_City__c', 'Customer_State__c','Customer_Zip__c','StageName','CloseDate'},
		'Quote' => new set<String>{'Sector__c','QuoteType__c','System_Model__c','Module_Count__c','Racking_Quantity__c','Modules_Per_String_1__c','Total_Parallel_String_2__c','Inverter_Model__c','Inverter_Manufacturer','Inverter_Quantity__c','Lease_Number__c'},
		'AccountContactRole' => new set<String>{'Role','IsPrimary'},

		// Residential Project Management -- TestFactory_ResidentialProjMgmt
		'Project_Task__c' => new set<String>{'Name','Milestone__c','SLA_Days__c','Role_Assignment__c'},
		'Residential_Project__c' => new set<String>{'Name'},
		'NH_Community__c' => new set<String>{'Name'},
		'Project_Installation_Setting__c' => new set<String>{'Zip_Code__c','Role__c'},
		'Installation_Model__c' => new set<String>{'Name','Financing_Option__c','State__c','Type__c','Partner_Role__c'},
		'POLineFeeSetup__c' => new set<String>{'Financial_Offering__c','MaxFit__c','MileStone__c','Partner_Role__c','Percentage__c','Value_From__c'},
		'Document__c' => new set<String>{'Name','Document_Type__c'},
		'Alliance_Partner' => new set<String>{'Role__c'},
		'StandardLineItem__c' => new set<String>{'Quantity__c'},

		// Configurations -- TestFactory_Configurations
		'Master_Configurator__c' => new set<String>{'Name','Configuration_Model__c'},
		'Item__c' => new set<String>{'Name','CEC_PTC_Rating__c','Description__c','Display_Name__c','Display_Order__c','Item_Category_1__c','Inverter_Oracle_Id__c','Line_Type__c','Manufacturing_Cost__c','Model__c','Item_ID__c','OraclePVSimld__c','Product_Family__c','Product_Line__c','Product_Type__c','Status__c','Module_Width__c'},
		'SalesConfiguration__c' => new set<String>{'Channel__c','Financial_Offering__c','Operating_Unit__c','SalesMethodology__c','Sector__c','State__c','Active__c'},
		'Module_Configuration__c' => new set<String>{'Name','Current_Type__c'},
		'Racking_Configuration__c' => new set<String>{'Name','Kit_Size__c','Type__c','Usage__c'},
		'Racking_Item_Junction__c' => new set<String>{'Name','Quantity__c'},
		'ModuleRackingJunction__c' => new set<String>{'Name'},
		'Inverter_Configuration__c' => new set<String>{'Name','End_Date__c','Inverter_Manufacturer__c', 'On_Board_Monitoring__c','Start_Date__c','Storage_Ready_Inverter__c'},
		'Monitoring_Configuration__c' => new set<String>{'Name'},
		'Monitoring_Item_junction__c' => new set<String>{'Name', 'Type__c'},
		'Storage_Configuration__c' => new set<String>{'Name'},

		// Ordering -- TestFactory_Ordering
		'Purchase_Order__c' => new set<String>{'Name','Ext_Id__c','Lease__c'},
		'Purchase_Order_Line__c' => new set<String>{'Price__c','Item_Description__c','Item_Number__c','Quantity__c','Unit_Price__c'},
		'Bill_To_Site__c' => new set<String>{'Address_1__c','City__c','State__c','Zip__c','Site_ID__c','Active__c'},
		'Ship_To_Site__c' => new set<String>{'Address_1__c','City__c','State__c','Zip__c','SiteID__c'},
		// agreement record
		'echosign_dev1__SIGN_Agreement__c' => new set<String>{'Name'},

		//Commercial - TestFactory_Commercial
		'Site_Information_Form__c'  => new Set<String>{'Site_Name__c','Site_Address__c','Site_City__c','Site_Zip_Postal_Code__c'},
		'Opportunity_Role__c' => new Set<String>{},
		'Design__c' => new Set<String>{'HelixDesignType__c','ModuleTypeandWattage__c','Design_Package_Type__c','Actual_System_Size__c','Actual_Annual_Production__c','Module_Quantity__c'},
		'EnergyProductionYr1__c' => new Set<String>{'Jan__c','Feb__c','Mar__c','Apr__c','May__c','Jun__c','Jul__c','Aug__c','Sep__c','Oct__c','Nov__c','Dec__c'},
		'Roof_Design__c' => new Set<String>{},
		'Quote_Design__c' => new Set<String>{},
		'Utility_Code__c' => new Set<String>{'External_Id__c','Utility_Name__c'},
		'Cost_Matrix__c' => new Set<String>{'Technology_System_Category__c','Active__c'}
	};

	public static SObject createSObject(String objectType) {
		return createSObject(objectType, false);
	}

	public static List<SObject> createSObjectList(String objectType, boolean cascade, Integer numberOfObjects) {
		List<SObject> sos = new List<SObject>();
		for( Integer i=0; i<numberOfObjects; i++ )
			sos.add(createSObject(objectType, cascade, i));
		return sos;
	}

	public static SObject createSObject(String objectType, boolean cascade, Integer counter) {
		System.debug('Creating ' + objectType);
		Schema.sObjectType token = GlobalDescribe.get(objectType);
		if (token == null) {
			throw new UnsupportedObjectTypeException('Unsupported ObjectType ' + objectType);
		}

		SObject obj = token.newSObject();

		for (Schema.SObjectField field : fieldMapFor(objectType).values()) {
			setFieldValue(obj, field, cascade, counter);
		}

		return obj;
	}

	public static SObject createSObject(String objectType, boolean cascade) {
		return createSObject(objectType, cascade, 1);
	}

	/**
		Returns a field map for a given sobject.

		Note : this method is kept public for Test cases to share the same field map info, without requiring a field desribe.

		@param objectType sobject api name for ex. Account
		@returns FieldMap [Key:FieldName,Value:Schema.SObjectField]
	*/
	public static  Map<String, Schema.SObjectField> fieldMapFor(String objectType) {
		Map<String, Schema.SObjectField> fieldMap = null;
		String normalizedObjectType = objectType.toLowerCase();

		if (FieldMapCache.containsKey(normalizedObjectType)) {
			fieldMap = FieldMapCache.get(normalizedObjectType);
		} else {
			fieldMap = GlobalDescribe.get(objectType).getDescribe().fields.getMap();
			// cache it for next use
			FieldMapCache.put(normalizedObjectType, fieldMap);
		}

		return fieldMap;
	}

	static String getDefaultPicklistValue(SObject obj, Schema.DescribeFieldResult fieldDescribe) {
		String key = obj.getSObjectType() + '.' + fieldDescribe.getName();

		if (!DefaultPicklistValue.containsKey(key)) {
			List<Schema.PicklistEntry> entries = fieldDescribe.getPicklistValues();
			String value = entries.size() > 0 ? entries[0].getValue() : null;
			DefaultPicklistValue.put(key, value);
		}

		return DefaultPicklistValue.get(key);
	}

	static boolean isExcludedField(Schema.DescribeFieldResult fieldDescribe) {
		return ExcludedFields.get('All').contains(fieldDescribe.getName());
	}

	static boolean isExcludedField(SObject obj, Schema.DescribeFieldResult fieldDescribe) {
		set<String> fields = ExcludedFields.get(obj.getSObjectType().getDescribe().getName());
		return fields == null ? false : fields.contains(fieldDescribe.getName());
	}

	static boolean isIncludedField(SObject obj, Schema.DescribeFieldResult fieldDescribe) {
		set<String> fields = includedFields.get(obj.getSObjectType().getDescribe().getName());
		return fields == null ? false : fields.contains(fieldDescribe.getName());
	}

	static boolean isPersonAccountField(Schema.DescribeFieldResult fieldDescribe) {
                Boolean isPersonAccountEnabled = fieldMapFor('Account').get('IsPersonAccount') != null;
                set<string> skipPersonAccountFields = new set<string>{ 'Salutation' };

                Boolean CustomPerson = fieldDescribe.isCustom() && fieldDescribe.getName().endsWith('pc');
                Boolean StandardPerson = !fieldDescribe.isCustom() && fieldDescribe.getName().startsWith('Person');

                return CustomPerson || StandardPerson ||
                    (isPersonAccountEnabled && skipPersonAccountFields.contains(fieldDescribe.getName()));
	}

	static void setFieldValue(SObject obj, Schema.SObjectField field, boolean cascade) {
		setFieldValue(obj, field, cascade, 0);
	}

	static void setFieldValue(SObject obj, Schema.SObjectField field, boolean cascade, Integer counter) {
		Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

		if (fieldDescribe.isCreateable() &&
			(
				isIncludedField(obj, fieldDescribe) ||
				(
					(
						(!fieldDescribe.isNillable() ||
						FillAllFields) ||
						(fieldDescribe.getType() == Schema.DisplayType.Reference && cascade) // always fill references with cascade
					) &&
					!isExcludedField(fieldDescribe) &&
					!isExcludedField(obj, fieldDescribe) &&
					!isPersonAccountField(fieldDescribe)
				)
			 )
			) {

			if (fieldDescribe.getName().endsWith('Country') || fieldDescribe.getName().startsWith('Country')) {
				obj.put(field, DefaultCountry);
			} else if (fieldDescribe.getName().endsWith('State') || fieldDescribe.getName().startsWith('State')) {
				obj.put(field, DefaultState);
			} else if (fieldDescribe.getType() == Schema.DisplayType.base64) {
				obj.put(field, blob.valueOf(counter.format()));
			}else if (fieldDescribe.getName() == 'Active__c' && fieldDescribe.getType() == Schema.DisplayType.Boolean) {
				obj.put(field, true);
			} else if (fieldDescribe.getType() == Schema.DisplayType.Boolean) {
				obj.put(field, false);
			} else if (fieldDescribe.getType() == Schema.DisplayType.Combobox) {
				obj.put(field, counter.format());
			} else if (fieldDescribe.getType() == Schema.DisplayType.Currency) {
				obj.put(field, counter);
			} else if (fieldDescribe.getType() == Schema.DisplayType.Date) {
				obj.put(field, Date.today());
			} else if (fieldDescribe.getType() == Schema.DisplayType.DateTime) {
				obj.put(field, DateTime.now());
			} else if (fieldDescribe.getType() == Schema.DisplayType.Double) {
				obj.put(field, counter);
			} else if (fieldDescribe.getType() == Schema.DisplayType.Email) {
				obj.put(field, 'test' + string.valueof(math.roundtolong(math.random()*1000000)) + '@test.com');
			} else if (fieldDescribe.getType() == Schema.DisplayType.EncryptedString) {
				obj.put(field, 's');
			} else if (fieldDescribe.getType() == Schema.DisplayType.Id) {
				//System.debug('Id field ' + fieldDescribe.getName());
			} else if (fieldDescribe.getType() == Schema.DisplayType.Integer) {
				obj.put(field, counter);
			} else if (fieldDescribe.getType() == Schema.DisplayType.MultiPicklist) {
				obj.put(field, getDefaultPicklistValue(obj, fieldDescribe));
			} else if (fieldDescribe.getType() == Schema.DisplayType.Percent) {
				obj.put(field, counter);
			} else if (fieldDescribe.getType() == Schema.DisplayType.Phone) {
				obj.put(field, '123-456-7890');
			} else if (fieldDescribe.getType() == Schema.DisplayType.Picklist) {
				obj.put(field, getDefaultPicklistValue(obj, fieldDescribe));
			} else if (fieldDescribe.getName() == 'Alias' && fieldDescribe.getType() == Schema.DisplayType.String) {
				obj.put(field, 'test'+ string.valueof(math.roundtolong(math.random()*1000)));//max len 8
			} else if (fieldDescribe.getName() == 'CommunityNickname' && fieldDescribe.getType() == Schema.DisplayType.String) {
				obj.put(field, 'test'+ string.valueof(math.roundtolong(math.random()*1000000)));
			} else if (fieldDescribe.getName() == 'UserName' && fieldDescribe.getType() == Schema.DisplayType.String) {
				obj.put(field, 'test'+ string.valueof(Userinfo.getOrganizationId())+ string.valueof(math.roundtolong(math.random()*1000000))+ string.valueof(Datetime.now()).replace('-','').replace(':','').replace(' ','')+'@test.com'); // was a@a.com
			} else if (fieldDescribe.getName() == 'Name' && fieldDescribe.getType() == Schema.DisplayType.String) {
				obj.put(field, 'test'+ string.valueof(math.roundtolong(math.random()*1000000)));
			} else if (fieldDescribe.getName().contains('Zip') && fieldDescribe.getType() == Schema.DisplayType.String) {
				obj.put(field, '12345');
			} else if (fieldDescribe.getType() == Schema.DisplayType.String) {
				obj.put(field, 'test'+ string.valueof(math.roundtolong(math.random()*1000000)));
			} else if (fieldDescribe.getType() == Schema.DisplayType.Reference) {
				String referenceObjectType = fieldDescribe.getReferenceTo()[0].getDescribe().getName();

				if (referenceObjectType == 'RecordType') {
					setRecordType(obj);
				} else if (cascade && referenceObjectType != obj.getSObjectType().getDescribe().getName()) {
					// TODO avoid infinite loop for same-type references
					System.debug('Creating reference to ' + referenceObjectType + ' for field ' + obj.getSObjectType().getDescribe().getName() + '.' + fieldDescribe.getName());
					SObject reference = createSObject(referenceObjectType);
					System.debug('Inserting ' + reference);
					insert reference;
					obj.put(field, reference.Id);
				}
				else if (referenceObjectType == 'Profile') {
					obj.put(field,userProfile.Id);
				}
			} else if (fieldDescribe.getType() == Schema.DisplayType.TextArea) {
				obj.put(field, 'test'+ string.valueof(math.roundtolong(math.random()*1000000)));
			} else if (fieldDescribe.getType() == Schema.DisplayType.Time) {
				obj.put(field, Time.newInstance(0, 0, 0, 0));
			} else if (fieldDescribe.getType() == Schema.DisplayType.URL) {
				obj.put(field, 'http://test' + string.valueof(math.roundtolong(math.random()*1000000)) + '.com');
			} else {
				System.debug('Unhandled field type ' + fieldDescribe.getType());
			}
		}
	}

	static void setRecordType(SObject obj) {
		List<Schema.RecordTypeInfo> recordTypes = obj.getSObjectType().getDescribe().getRecordTypeInfos();

		if (recordTypes.size() > 1) { // all objects have default Master type
			//System.debug('RecordTypes ' + recordTypes);
			for (Schema.RecordTypeInfo recordType : recordTypes) {
				if (recordType.isAvailable() && recordType.isDefaultRecordTypeMapping()) {
					obj.put('RecordTypeId', recordType.getRecordTypeId());
				}
			}
		}

	}
}