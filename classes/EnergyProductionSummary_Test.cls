@isTest
private class EnergyProductionSummary_Test {
	
	@isTest static void testGetSummaryDetails() {
		HelixDesignSummaryControllerTestData data = new HelixDesignSummaryControllerTestData();

		data.createTestData_googleMap();
		
		Test.startTest();
		PageReference pageRef = Page.EnergyProductionSummary;
        Test.setCurrentPage(pageRef);

	 	ApexPages.StandardController stdController = new ApexPages.StandardController(data.design_1);
        EnergyProductionSummaryController controller = new EnergyProductionSummaryController(stdController);

        controller.save();
        controller.edit();
        controller.cancel();

        Test.stopTest();
	}

	static TestMethod void NoSummaryNoRoofDesign() {

		Site_Information_Form__c site = HelixDesignSummaryControllerTestData.getNewSite();
		insert site;

		Design__c design = HelixDesignSummaryControllerTestData.getNewDesign(site.Id);
		insert design;

		Test.startTest();
		PageReference pageRef = Page.EnergyProductionSummary;
        Test.setCurrentPage(pageRef);

	 	ApexPages.StandardController stdController = new ApexPages.StandardController(design);
        EnergyProductionSummaryController controller = new EnergyProductionSummaryController(stdController);

        Test.stopTest();
	}

	static TestMethod void WithSummaryNoRoofDesign() {

		Site_Information_Form__c site = HelixDesignSummaryControllerTestData.getNewSite();
		insert site;

		Design__c design = HelixDesignSummaryControllerTestData.getNewDesign(site.Id);
		insert design;

		EnergyProductionYr1__c ep = getEP();
		ep.Design__c = design.Id;
		insert ep;

		Test.startTest();
		PageReference pageRef = Page.EnergyProductionSummary;
        Test.setCurrentPage(pageRef);

	 	ApexPages.StandardController stdController = new ApexPages.StandardController(design);
        EnergyProductionSummaryController controller = new EnergyProductionSummaryController(stdController);

        Test.stopTest();
	}

	static TestMethod void WithSummaryNotOnRoofDesign() {
		
		Site_Information_Form__c site = HelixDesignSummaryControllerTestData.getNewSite();
		insert site;

		Roof_Design__c roofDesign = HelixDesignSummaryControllerTestData.getNewRoofDesign();
		insert roofDesign;

		Design__c design = HelixDesignSummaryControllerTestData.getNewDesign(site.Id);
		design.Roof_Design__c = roofDesign.Id;
		insert design;
		
		roofDesign.Design__c = design.Id;
		update roofDesign;

		EnergyProductionYr1__c ep = getEP();
		ep.Design__c = design.Id;
		insert ep;

		Test.startTest();
		PageReference pageRef = Page.EnergyProductionSummary;
        Test.setCurrentPage(pageRef);

	 	ApexPages.StandardController stdController = new ApexPages.StandardController(design);
        EnergyProductionSummaryController controller = new EnergyProductionSummaryController(stdController);

        Test.stopTest();
	}

	private static EnergyProductionYr1__c getEP() {
		EnergyProductionYr1__c ep = new EnergyProductionYr1__c();
		ep.Jan__c = Math.random() * 1000;
		ep.Feb__c = Math.random() * 1000;
		ep.Mar__c = Math.random() * 1000;
		ep.Apr__c = Math.random() * 1000;
		ep.May__c = Math.random() * 1000;
		ep.Jun__c = Math.random() * 1000;
		ep.Jul__c = Math.random() * 1000;
		ep.Aug__c = Math.random() * 1000;
		ep.Sep__c = Math.random() * 1000;
		ep.Oct__c = Math.random() * 1000;
		ep.Nov__c = Math.random() * 1000;
		ep.Dec__c = Math.random() * 1000;
		return ep;
	}
	
}