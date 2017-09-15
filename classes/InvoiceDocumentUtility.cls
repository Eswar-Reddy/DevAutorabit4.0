public with sharing class InvoiceDocumentUtility {
	private static List<Installation_Model__c> installationModels;

	// Select a Installation Model that matches finance type, business channel, country and is of type 'Auto'
	public static Id findInstallationModel(String financingOption, String channel, String country){
		if(installationModels == NULL) installationModels = [SELECT Id, Partner__c, Financing_Option__c, Country__c FROM Installation_Model__c WHERE Type__c = 'Auto'];
		for(Installation_Model__c im : installationModels){
			if(im.Financing_Option__c.contains(financingOption) && channel == im.Partner__c && country == im.Country__c) return im.Id;
		}
		return NULL;
	}
}