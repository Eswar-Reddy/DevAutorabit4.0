/*******************************************
**Created by - Kapil Goutam
**Created On - June 05 2009
**Last Modified On- July 23 2009
**Last Modifiled by- Anuradha Suthar
**Description- Test Class
********************************************/
public class TestInspectionReportExtension {
    @isTest
    public static void Test_InspectionReportExtension(){ 
        
            //Create Account
            /*Account acct = new Account(name= 'te2221' + String.ValueOf(DateTime.Now()));
            acct.Country_Domain__c = 'rvar-es';
            acct.Type ='Commercial';
            acct.billingCity = 'TestCity';
            acct.BillingCountry = 'TestCountry';
            acct.BillingPostalCode = '12345';
            acct.BillingState = 'TestState';
            acct.BillingStreet = 'TestStreet';
            insert acct;*/
            
            List<Account> lstacc = [SELECT Id, Name, Country_Domain__c, Type, billingCity, BillingCountry, BillingPostalCode, BillingState, BillingStreet, Partner_Account__c FROM Account WHERE Name IN ('Sample 1','Sample 2','Sample 3','Sample 4','Sample 5')];
            //create contact
            /*Contact con = new Contact();
            con.LastName = 'Test Contact-'+ String.valueOf(DateTime.Now());        
            con.accountID = acct.id;
            con.email='TestInspec@rr.com';
            insert con;*/
            List<Contact> lstcon = [SELECT Id, Name, AccountId, email FROM Contact WHERE Name IN ('Sample 1','Sample 2','Sample 3','Sample 4','Sample 5')]; 
            Test.startTest();
            //Create Case
            List<RecordType> lstRecordType = new List<RecordType>([Select Id from RecordType where DeveloperName ='Case_Inspection_Audit']);//for Case#00078518
            Case newCase = new Case(AccountID=lstacc[0].id,Partner_Account__c=lstacc[0].id);
            if(lstRecordType.size()>0)
                newCase.RecordTypeId = lstRecordType.get(0).Id;
            insert newCase;            
            //Create inspection
            Inspection__c newInspection = new Inspection__c(case__c = newCase.id,Contact__c=userinfo.getUserid());
            insert newInspection;
                            
            //Assign query parameters
            ApexPages.currentPage().getParameters().put('siteType','Residential');
            ApexPages.currentPage().getParameters().put('isEdit','true');        
            
    
            //Call costructor without id & caseid
            InspectionReportExtension obj = new InspectionReportExtension(new ApexPages.standardController(new inspection__c()));
            obj.createCaseonImageUpload();
            //objInspection.save();
            
            //Call costructor without id & with caseid
            ApexPages.currentPage().getParameters().put('caseid',newCase.id);
            InspectionReportExtension obj1 = new InspectionReportExtension(new ApexPages.standardController(new inspection__c()));       
            obj1.save();
            obj1.cancelInspection(); 
            
            //Call costructor with id & caseid        
            ApexPages.currentPage().getParameters().put('id',newInspection.id);
            InspectionReportExtension objInspection = new InspectionReportExtension(new ApexPages.standardController(new inspection__c()));
            objInspection.getSiteType();
            objInspection.getResponseOptionType();
            objInspection.isExistingSharing();
            objInspection.onSeletionOfInspectionType();
            objInspection.selectedSiteType = 'Commercial';
            objInspection.onSeletionOfSiteType();
            objInspection.refreshSiteByName();
            //objInspection.selectedSiteId = spSite.id;
            objInspection.refreshSite();
            objInspection.refreshInspectorByName();
            objInspection.selectedInspectorId = lstcon[0].id;
            objInspection.refreshInspector();
            objInspection.refreshReviewerByName();
            objInspection.selectedReviewerId = userinfo.getUserid();
            objInspection.refreshReviewer();
            objInspection.refreshJobSupervisorByName();
            objInspection.selectedJobSupervisorId = lstcon[0].id;
            objInspection.refreshJobSupervisor();
            objInspection.refreshScore();
            objInspection.printResidential();
            objInspection.printCommercial();
            //objInspection.ShareObject();
            objInspection.site_ContactID = lstcon[0].id;
            try{
            Inspection__Share sh = new Inspection__Share();
            sh.UserOrGroupId = newInspection.Contact__c; 
            sh.ParentID =newInspection.id ;
            sh.AccessLevel = 'Read';
            insert sh;
            
            objInspection.save();
            }
            catch(Exception ex){}
            //objInspection.QuickSave(); 
            objInspection.cancelInspection();                              
           Test.stopTest();        
}
}