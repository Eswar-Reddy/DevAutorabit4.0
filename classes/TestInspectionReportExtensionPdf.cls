/**************************************************
**Created By- Anuradha Suthar
**Created On- July 22 2009
**Last Modified- 
**Last Modified On-   
**Desciption- Test class for class InspectionReportExtensionPdf
*****************************************************/
public class TestInspectionReportExtensionPdf{

  @isTest
  public static void checkInspectionReportExtensionPdf(){        
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
            
            acct.shippingCity = 'TestCity';
            acct.shippingCountry = 'TestCountry';
            acct.shippingPostalCode = '12345';
            acct.shippingState = 'TestState';
            acct.shippingStreet = 'TestStreet';
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
            InspectionReportExtensionPdf obj = new InspectionReportExtensionPdf(new ApexPages.standardController(new Inspection__c()));
            obj.createCaseonImageUpload();
            //objInspection.save();
            
            //Call costructor without id & with caseid
            ApexPages.currentPage().getParameters().put('caseid',newCase.id);
            InspectionReportExtensionPdf obj1 = new InspectionReportExtensionPdf(new ApexPages.standardController(new Inspection__c()));       
            obj1.setInspectionForPartner(newinspection);
            obj1.save();
            obj1.cancelInspection(); 
            
            //Call costructor with id & caseid        
            ApexPages.currentPage().getParameters().put('id',newInspection.id);
            InspectionReportExtensionPdf objInspection = new InspectionReportExtensionPdf(new ApexPages.standardController(newInspection));
            objInspection.selectedSiteType = 'Residential';
            objInspection.getInspectionForPartner();       
            objInspection.getSiteType();
            objInspection.getResponseOptionType(); 
            objInspection.setSite_CityStateZip('123');    
            String zip =  objInspection.getSite_CityStateZip(); 
            objInspection.setSite_Email('test@test.com');
            String email =  objInspection.getSite_Email();
            objInspection.setSite_Phone('1412345678');
            String ph = objInspection.getSite_Phone();
            objInspection.setSite_ContactLastName('testlast'+String.valueOf(datetime.now()));
            String lastname = objInspection.getSite_ContactLastName();
            objInspection.setSite_ContactFirstName('testLastName');
            String firstName = objInspection.getSite_ContactFirstName();
            objInspection.onSeletionOfInspectionType();        
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