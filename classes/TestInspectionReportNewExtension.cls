public class TestInspectionReportNewExtension {
	@isTest
    public static void Test_InspectionReportExtension(){ 
        	
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
	                        
	        //Assign query parameters
	        ApexPages.currentPage().getParameters().put('siteType','Residential');
	        ApexPages.currentPage().getParameters().put('isEdit','true');        
	        ApexPages.currentPage().getParameters().put('inspectionType','testRes');
	        
			//Call costructor without id & caseid
	        InspectionReportNewExtension obj = new InspectionReportNewExtension(new ApexPages.standardController(new inspection__c()));
	        obj.createCaseonImageUpload();
	        obj.cancelInspection();
	        //objInspection.save();
	        
	        Test.startTest();
	        
	        
	        //Call costructor without id & with caseid
	        ApexPages.currentPage().getParameters().put('caseid',newCase.id);
	        InspectionReportNewExtension obj1 = new InspectionReportNewExtension(new ApexPages.standardController(new inspection__c()));       
	        obj1.save();
	        obj1.cancelInspection(); 
	        
	        //Call costructor with id & caseid        
	        ApexPages.currentPage().getParameters().put('id',newInspection.id);
	        InspectionReportNewExtension objInspection = new InspectionReportNewExtension(new ApexPages.standardController(newInspection));
	        InspectionReportNewExtension.isTest = true;
	        objInspection.getSiteType();
	        objInspection.getResponseOptionType();
	        objInspection.isExistingSharing();
	        objInspection.onSeletionOfInspectionType();
	        objInspection.selectedSiteType = 'Residential';
	        objInspection.onSeletionOfSiteType();
	        objInspection.refreshSiteByName();
	        //objInspection.selectedSiteId = spSite.id;
	        objInspection.refreshSite();
	        objInspection.refreshInspectorByName();
	        objInspection.selectedInspectorId = con.id;
	        objInspection.refreshInspector();
	        objInspection.refreshReviewerByName();
	        objInspection.selectedReviewerId = userinfo.getUserid();
	        objInspection.refreshReviewer();
	        objInspection.refreshJobSupervisorByName();
	        objInspection.selectedJobSupervisorId = con.id;
	        objInspection.refreshJobSupervisor();
	        objInspection.refreshScore();
	        objInspection.printResidential();
	        objInspection.printCommercial();
	        objInspection.redirect();
	         //objInspection.ShareObject();
	        objInspection.site_ContactID = con.id;
	        try{
	        Inspection__Share sh = new Inspection__Share();
	        sh.UserOrGroupId = newInspection.Contact__c; 
	        sh.ParentID =newInspection.id ;
	        sh.AccessLevel = 'Read';
	        //insert sh;
	        
			// The new test functions
	        Boolean isEdit;
	        isEdit = objInspection.CheckUserEditReport();
	        objInspection.AssignParentUrl();
	        objInspection.QuickSave();
	      //  objInspection.inInspection_Name__c = 'test file name';
	        objInspection.SendMailtoDealer();
	        
	         ApexPages.currentPage().getParameters().put('id',newInspection.id);
	        InspectionReportNewExtension objInspection2 = new InspectionReportNewExtension(new ApexPages.standardController(newInspection));
	        
	        objInspection2.userRole = 'Inspection Specialist';
	        objInspection2.inspection.InspectionSavedBy__c = 'Inspection Specialist';
	        isEdit = objInspection2.CheckUserEditReport();
	        Boolean ischeckString = objInspection2.CheckInverterStringConfigutration();
	        objInspection2.save();
	        
	       
	        
	       	objInspection2 = new InspectionReportNewExtension(new ApexPages.standardController(newInspection));
	         
	        objInspection2.userRole = 'Inspector';
	        objInspection2.inspection.InspectionSavedBy__c = 'Inspector';
	        
	        isEdit = objInspection2.CheckUserEditReport();
	        objInspection2.save(); 
	        objInspection2.inspection.InspectionSavedBy__c = 'Inspection Specialist';
	        objInspection2.save(); 
	        
	        objInspection2 = new InspectionReportNewExtension(new ApexPages.standardController(newInspection));
	        
	        objInspection2.userRole = 'Inspection Specialist';
	        objInspection2.inspection.InspectionSavedBy__c = 'Technical Services Engineer';
	        isEdit = objInspection2.CheckUserEditReport();
	        ischeckString = objInspection2.CheckInverterStringConfigutration();
	        objInspection2.save(); 
	        
	        objInspection2 = new InspectionReportNewExtension(new ApexPages.standardController(newInspection));
	        
	       	objInspection2.userRole = 'Technical Services Engineer';
	        objInspection2.currentUserName = 'Mandeep Guragain';
	        objInspection2.inspection.InspectionSavedBy__c = 'Inspector';
	        isEdit = objInspection2.CheckUserEditReport();
	        ischeckString = objInspection2.CheckInverterStringConfigutration();
	        objInspection2.save(); 
	        
	        objInspection2 = new InspectionReportNewExtension(new ApexPages.standardController(newInspection));
	        
	        objInspection2.userRole = 'Technical Services Engineer';
	        objInspection2.inspection.InspectionSavedBy__c = 'Inspector';
	        objInspection2.inspection.InspectionByTSE__c = null;
	        objInspection2.inspection.Residential_Result__c = 'FAIL';
	        objInspection2.save(); 
	         
	         newInspection.InspectionSavedBy__c = 'Technical Services Engineer';
	         newInspection.InspectionByTSE__c = null;
	         newInspection.IsSaveByTSE__c = false;
	         newInspection.Residential_Result__c = 'FAIL';
	         newInspection.InspectionNameType__c = 'TestInspection_20_10_JM';
	         update newInspection;
	         
	         objInspection2 = new InspectionReportNewExtension(new ApexPages.standardController(newInspection));
	        
	        objInspection2.userRole = 'Technical Services Engineer';
	        objInspection2.inspection.InspectionSavedBy__c = 'Technical Services Engineer';
	        objInspection2.inspection.InspectionByTSE__c = null;
	        objInspection2.inspection.IsSaveByTSE__c = false;
	        objInspection2.inspection.Residential_Result__c = 'FAIL';
	         objInspection2.inspection.InspectionNameType__c = 'TestInspection_20_10_JM';
	        isEdit = objInspection2.CheckUserEditReport();
	        objInspection2.save(); 
	       
	        Test.stopTest();
	        
	        }
	        catch(Exception ex){}
	        //objInspection.QuickSave(); 
	        objInspection.cancelInspection();                              
	       // Test.stopTest();        
	}
}