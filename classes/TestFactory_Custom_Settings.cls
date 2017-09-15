/**
 * Created by Ankit Khandelwal on 05/15/17.
 * Test Factory for Custom Settings
 */
@isTest(SeeAllData=false)
public class TestFactory_Custom_Settings {
	private static DocGen_Callout_Settings__c newDocGenCalloutSetting;
	private static Lease_2_1_PO_Creation__c newLease21POCreation;
	private static List<Loan_Callout_Settings__c> newLoanCalloutSettings;
	private static List<Mosaic_Upload_Documents__c> newMosaicUploadDocuments;

	public static List<Mosaic_Upload_Documents__c> getMosaicUploadDocuments() {
		if(newMosaicUploadDocuments == NULL) {
			List<Mosaic_Upload_Documents__c> muds = createMosaicUploadDocuments();
			insert muds;
			newMosaicUploadDocuments = muds;
		}
		return newMosaicUploadDocuments;
	}

	public static List<Mosaic_Upload_Documents__c> createMosaicUploadDocuments() {
		List<Mosaic_Upload_Documents__c> muds = new List<Mosaic_Upload_Documents__c>();
		Mosaic_Upload_Documents__c mud1 = createMosaicUploadDocument('Final Permit', 'FINAL_PERMIT');
		muds.add(mud1);
		Mosaic_Upload_Documents__c mud2 = createMosaicUploadDocument('Photos', 'INSTALL_COMPLETE');
		muds.add(mud2);
		Mosaic_Upload_Documents__c mud3 = createMosaicUploadDocument('PTO Letter', 'PERMISSION_TO_OPERATE');
		muds.add(mud3);

		return muds;
	}

	private static Mosaic_Upload_Documents__c createMosaicUploadDocument(String name, String docType) {
		Mosaic_Upload_Documents__c mud = new Mosaic_Upload_Documents__c();
		mud.Name = name;
		mud.Document_Type__c = docType;
		return mud;
	}

	public static DocGen_Callout_Settings__c getDocGenCallOutSetting() {
		if(newDocGenCalloutSetting == NULL) {
			DocGen_Callout_Settings__c dgCS = createDocGenCallOutSetting();
			insert dgCS;
			newDocGenCalloutSetting = dgCS;
		}
		return newDocGenCalloutSetting;
	}

	public static DocGen_Callout_Settings__c createDocGenCallOutSetting() {
		DocGen_Callout_Settings__c dgCS = new DocGen_Callout_Settings__c();
		dgCS.Name = 'DocGen';
		dgCS.EndPoint__c = 'https://dcs.dev.sunpower.com/ws/docgen/proposal/proposal';
		dgCS.EndPoint_Contract__c = 'https://dcs.dev.sunpower.com/ws/docgen/docx/generatePdf';
		dgCS.SPDContract_Key__c = 'DC97-20AF-567E';

		return dgCS;
	}

	public static Lease_2_1_PO_Creation__c getLease21POCreation() {
		if(newLease21POCreation == NULL) {
			Lease_2_1_PO_Creation__c lpoc = createLease21POCreation();
			insert lpoc;
			newLease21POCreation = lpoc;
		}
		return newLease21POCreation;
	}

	public static Lease_2_1_PO_Creation__c createLease21POCreation() {
		Map<String, Schema.RecordTypeInfo> recordtypeName = Schema.SObjectType.echosign_dev1__SIGN_Agreement__c.getRecordTypeInfosByName();

		Lease_2_1_PO_Creation__c lpoc = new Lease_2_1_PO_Creation__c();
		lpoc.Lien_Waiver_Id__c = recordtypeName.get('Lien Waiver').getRecordTypeId();
		lpoc.Lease_Contract_Id__c = recordtypeName.get('Lease Contract').getRecordTypeId();
		lpoc.Amendment_Id__c = recordtypeName.get('Amendment Agreement').getRecordTypeId();
		lpoc.Partner_Id__c = recordtypeName.get('Partner Agreement').getRecordTypeId();
		lpoc.Draft_Lease_Contract_Id__c = recordtypeName.get('Draft Lease Contract').getRecordTypeId();
		lpoc.Termination_Id__c = recordtypeName.get('Termination Agreement').getRecordTypeId();
		lpoc.Name = 'Counter Signature Info';

		return lpoc;
	}

	public static List<Loan_Callout_Settings__c> getLoanCallOutSettings() {
		if(newLoanCalloutSettings == NULL) {
			List<Loan_Callout_Settings__c> lcs = createLoanCallOutSettings();
			insert lcs;
			newLoanCalloutSettings = lcs;
		}
		return newLoanCalloutSettings;
	}

	public static List<Loan_Callout_Settings__c> createLoanCallOutSettings() {
		List<Loan_Callout_Settings__c> lst = new List<Loan_Callout_Settings__c>();
		lst.add(new Loan_Callout_Settings__c(Name = 'ServiceObjects',
											BackupZipCodeUrl__c = 'http://ws.serviceobjects.com/ft/FastTax.asmx/GetTaxInfoByZip_V2?PostalCode=',
											ZipCodeUrl__c = 'http://ws.serviceobjects.com/ft/FastTax.asmx/GetTaxInfoByZip_V2?PostalCode=',
											Client_ID__c = 'WS19-GFX1-JVR3',
											BackupURL__c = 'http://ws.serviceobjects.com/gcr/GeoCoder.asmx/GetBestMatch_V3?Address=',
											NameSpace__c = 'http://www.serviceobjects.com/'));

		lst.add(new Loan_Callout_Settings__c(Name = 'Aurora', Endpoint_URL__c = 'http://www.aurora.com',
											Endpoint_URL_Sandbox__c = 'http://www.aurora.com',
											Key__c = 'key', Tenant_Id__c = 'tenantId', Client_Secret__c = 'clientSecret',
											Redirect_URI_Sandbox__c = 'https%3A%2F%2Fsandbox.aurorasolar.com%2F',
											Redirect_URI_Production__c = 'https%3A%2F%2Fsandbox.aurorasolar.com%2F'));

		lst.add(new Loan_Callout_Settings__c(Name = 'Mosaic', SalesRepEmail__c = 'test@mosaic.com',
											Endpoint_URL__c ='http://www.mosaic.com', Client_ID__c = 'clientID',
											Client_Secret__c = 'clientSecret', Grant_Type__c = 'grantType'));
		return lst;
	}
}