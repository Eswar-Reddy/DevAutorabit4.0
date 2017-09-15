public class TestNewCaseIntermediateController{
	
	@isTest
	// when case record type is 'Feedback'
	public static void checkCaseIntermediateTest(){
	    
	    Test.startTest();
	    PageReference pageRef = Page.NewCaseIntermediatePage;
		Test.setCurrentPageReference(pageRef);
		
	    Case cs = new case();        
	    List<RecordType> lstRecordType  = new List<RecordType>([Select r.SobjectType, r.Name, r.Id From RecordType r where SobjectType ='Case' and Name = 'Feedback']);
	    if(lstRecordType.size()>0){
	        ApexPages.currentPage().getParameters().put('RecordType',lstRecordType[0].ID); 
	    }
	    
	    ApexPages.standardController std = new ApexPages.standardController(cs);
	    NewCaseIntermediateController obj = new NewCaseIntermediateController(std);
		Test.stopTest();	
	}
	
	@isTest
	// when case record type is 'New Inspections'
	public static void checkCaseIntermediateTest1(){
	    
	    Test.startTest();
	    PageReference pageRef = Page.NewCaseIntermediatePage;
		Test.setCurrentPageReference(pageRef);
		
	    Case cs = new case();        
	    ID euInspectionCaseRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('New Inspections').getRecordTypeId();
        ApexPages.currentPage().getParameters().put('RecordType',euInspectionCaseRecTypeId); 
	    ID contactId , accountID;
			    
	    List<Contact> con = new List<Contact>([Select id,accountID from Contact where Account.RecordType.Name = 'Partner' limit 1]);
        if(con.size()>0){
            contactID = con[0].ID;
            accountID = con[0].accountID; 
        }
	    ApexPages.currentPage().getParameters().put('def_account_id',accountID);
	    ApexPages.standardController std = new ApexPages.standardController(cs);
	    NewCaseIntermediateController obj = new NewCaseIntermediateController(std);
	    obj.removeParameter(ApexPages.currentPage().getURL() ,euInspectionCaseRecTypeId);
	    
	    ApexPages.currentPage().getParameters().put('def_contact_id',contactID);
	    obj = new NewCaseIntermediateController(std);
		Test.stopTest();	
	}
	
	@isTest
	// when case record type is 'Residential Customer'
	public static void checkCaseIntermediateTest2(){
	    
	    Test.startTest();
	    PageReference pageRef = Page.NewCaseIntermediatePage;
		Test.setCurrentPageReference(pageRef);
		
	    Case cs = new case();        
	    ID euInspectionCaseRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('New Inspections').getRecordTypeId();
        ApexPages.currentPage().getParameters().put('RecordType',euInspectionCaseRecTypeId); 
	    ID contactId , accountID;
			    
	    List<Contact> con = new List<Contact>([Select id,accountID from Contact where Account.RecordType.Name = 'Residential Customer' limit 1]);
        if(con.size()>0){
            contactID = con[0].ID;
            accountID = con[0].accountID; 
        }
	    ApexPages.currentPage().getParameters().put('def_account_id',accountID);
	    ApexPages.standardController std = new ApexPages.standardController(cs);
	    NewCaseIntermediateController obj = new NewCaseIntermediateController(std);
	    obj.removeParameter(ApexPages.currentPage().getURL() ,euInspectionCaseRecTypeId);
	    
	    ApexPages.currentPage().getParameters().put('def_contact_id',contactID);
	    obj = new NewCaseIntermediateController(std);
		Test.stopTest();	
	}
}