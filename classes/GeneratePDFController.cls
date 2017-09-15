public with sharing class GeneratePDFController {
	
	public static list<Attachment> atts {get;set;}
	public static Id rid {get;set;}

	public GeneratePDFController() {
		List<String> attNames = new List<String>();
		attNames.add('Photo of physical address (number) with the home in the background');
		attNames.add('Modules installed - show all panels in entire system');
		attNames.add('Modules installed - show all panels in entire system (2)');
		attNames.add('Modules installed - show all panels in entire system (3)');
		attNames.add('Modules installed - show all panels in entire system (4)');
		attNames.add('Electrical equipment - wide angle shot including all equipment');

		rId = ApexPages.currentPage().getParameters().get('rid');
    	atts = [SELECT Body,Id FROM Attachment WHERE parentId  =:rid AND Name IN: attNames];
	}


}