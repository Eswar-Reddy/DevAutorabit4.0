public with sharing class RoofDetailsListController {
	public List<Roof_Details__c> roofs {get;set;}
	
	public RoofDetailsListController(ApexPages.StandardController controller) {
		Residential_Project__c project = (Residential_Project__c)controller.getRecord();
		roofs = [SELECT Name, Description__c, Pitch__c, Direction__c, Jan__c, Feb__c, Mar__c, Apr__c, May__c, Jun__c, Jul__c, Aug__c, Sep__c, Oct__c, Nov__c, Dec__c FROM Roof_Details__c WHERE Residential_Project__c =: project.Id];
	}
}