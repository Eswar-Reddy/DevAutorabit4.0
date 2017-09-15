/**************************************************
**Created By- Harsh Mathur
**Created On- July 22 2009
**Last Modified- 
**Last Modified On-   
**Desciption- Test class for class InspectionReportExtension_Refactor
*****************************************************/
public class TestInspectionReportExtension_Refactor{
  
  @isTest
  public static void checkInspectionReportExtension_Refactor(){   
       //Create Account
       Test.startTest();
        Account acct = new Account(name= 'te2221' + String.ValueOf(DateTime.Now()));
        acct.Country_Domain__c = 'rvar-es';
        acct.Type ='Commercial';
        acct.billingCity = 'TestCity';
        acct.BillingCountry = 'TestCountry';
        acct.BillingPostalCode = '12345';
        acct.BillingState = 'TestState';
        acct.BillingStreet = 'TestStreet';
        
        acct.ShippingCity = 'TestCity';
        acct.ShippingCountry = 'TestCountry';
        acct.ShippingPostalCode = '12345';
        acct.ShippingState = 'TestState';
        acct.ShippingStreet = 'TestStreet';
        insert acct;
        //create contact
        Contact con = new Contact();
        con.LastName = 'Test Contact-'+ String.valueOf(DateTime.Now());        
        con.accountID= acct.id;
        con.email='TestInspec@rr.com';
        insert con;
        Test.stopTest();
        //Create sp_site__c
        //SP_Site__c spSite = new SP_Site__c();
        //insert spSite;
        //insert contact site relation
        //Contact_site__c conSite = new contact_site__c(Contact__c=con.id);
        //insert conSite;
        //Create user
        /*String username ='h10101@world.com';
        User user = new User(LastName = 'Hello2221'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+         String.ValueOf(DateTime.Now()));
        user.ContactId = con.Id;
        user.Username = username;
        user.Alias = 'yoo12322';
        user.Country_Domain__c = 'rvar-it';
        user.CommunityNickname = username.subString(0,7);
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.Email = con.Email;
        user.LocaleSidKey = 'en_US';
        Test.startTest();
        List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Sales'];
        if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            insert user;
        }
        Test.stopTest();*/
        //Create Case
        List<RecordType> lstRecordType = new List<RecordType>([Select Id from RecordType where DeveloperName ='Case_Inspection_Audit']);//for Case#00078518
        Case newCase = new Case(AccountID=acct.id,Partner_Account__c=acct.id);
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
        InspectionReportExtension_Refactor obj = new InspectionReportExtension_Refactor(new ApexPages.standardController(new inspection__c()));
        obj.createCaseonImageUpload();
        //objInspection.save();
        
        //Call costructor without id & with caseid
        ApexPages.currentPage().getParameters().put('caseid',newCase.id);
        InspectionReportExtension_Refactor obj1 = new InspectionReportExtension_Refactor(new ApexPages.standardController(new inspection__c()));       
        obj1.save();
        obj1.cancelInspection(); 
        
        //Call costructor with id & caseid        
        ApexPages.currentPage().getParameters().put('id',newInspection.id);
        InspectionReportExtension_Refactor objInspection = new InspectionReportExtension_Refactor(new ApexPages.standardController(new inspection__c()));
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
        objInspection.selectedInspectorId = con.id;
        objInspection.refreshInspector();
        objInspection.refreshJobSupervisorByName();
        objInspection.selectedJobSupervisorId = con.id;
        objInspection.refreshJobSupervisor();
        objInspection.refreshScore();
        objInspection.printResidential();
        objInspection.printCommercial();
        //objInspection.ShareObject();
        objInspection.site_ContactID = con.id;
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
  }
}