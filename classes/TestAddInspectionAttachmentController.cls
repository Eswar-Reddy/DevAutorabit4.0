public  class TestAddInspectionAttachmentController {
	
	@isTest	
    public static  void myUnitTest() {
        
        //Create Account
	        Account acct = new Account(name= 'te2221' + String.ValueOf(DateTime.Now()));
	        acct.Country_Domain__c = 'rvar-es';
	        acct.Type ='Commercial';
	        acct.billingCity = 'TestCity';
            acct.BillingCountry = 'TestCountry';
            acct.BillingPostalCode = '12345';
            acct.BillingState = 'TestState';
            acct.BillingStreet = 'TestStreet';
	        insert acct;
	        //create contact
	        Contact con = new Contact();
	        con.LastName = 'Test Contact-'+ String.valueOf(DateTime.Now());        
	        con.accountID= acct.id;
	        con.email='TestInspec@rr.com';
	        insert con;
	        
	        //Create Case
	        List<RecordType> lstRecordType = new List<RecordType>([Select Id from RecordType where DeveloperName ='Case_Inspection_Audit']);//for Case#00078518
	        Case newCase = new Case(AccountID=acct.id,Partner_Account__c=acct.id);
	        if(lstRecordType.size()>0)
	            newCase.RecordTypeId = lstRecordType.get(0).Id;
	        insert newCase;
	                
	        //Create inspection
	        Inspection__c newInspection = new Inspection__c(case__c = newCase.id,Contact__c=userinfo.getUserid());
	        newInspection.InspectionSavedBy__c = 'Inspection Specialist';
	        newInspection.Residential_Result__c = 'FAIL';
	        insert newInspection;
	        
	        Attachment attach = new Attachment();
        	attach.Body = Blob.valueOf('Test String for attachment' + String.valueOf(Datetime.Now()));
        	attach.Name = 'Test_Attachment'+ String.valueOf(Datetime.Now());
        	attach.ParentId = newCase.Id;
       		insert attach;
       		
       		 ApexPages.currentPage().getParameters().put('insid',newInspection.Id);
       	    AddInspectionAttachmentController objInsAttach = new AddInspectionAttachmentController(new ApexPages.standardController(newInspection));
       	    objInsAttach.contentFile = Blob.valueOf('Test String for attachment2' + String.valueOf(Datetime.Now()));
       	    objInsAttach.nameFile = 'testfile.txt';
       	    
       	    objInsAttach.AttachFile();
       	    objInsAttach.DeleteAttachments();
       	    
    }
}