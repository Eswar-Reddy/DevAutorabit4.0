public class TestInspectionReportEUController
{
    
    @isTest
    public static void test_TestInspectionReportEUController()
    {     
       String username ='hello10101@world.com';
       User user = new User(LastName = 'Hello2222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
       user.Username = username;
       user.Alias = 'yoo123';
       user.Country_Domain__c ='rvar-fr';
       user.Country = 'Italy';
       user.Country_Domain__c = 'rvar-us';
       user.Division ='SunPower EU';
       user.CommunityNickname = username.subString(0,7);
       user.TimeZoneSidKey = 'America/Los_Angeles';
       user.EmailEncodingKey = 'ISO-8859-1';
       user.LanguageLocaleKey = 'en_US';
       user.Email = 'testInspectionReportEU@tt.com';
       user.LocaleSidKey = 'en_US';
       user.Web_User__c = True;
       user.ByPassValidation__c = False;
             
       List<Profile> lstProfile = [select Id from Profile where Name = 'System Administrator'];
       if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            //insert user;
        }
       List<UserRole> lstUserRole = [Select Id,Name From UserRole where Name='Technical Services Engineer']; 
       if(lstUserRole.Size()>0){
           user.UserRoleId = lstUserRole[0].Id;
           insert user;
       }
     
       System.RunAs(user){
        List<RecordType> rt = [select Id, Name From RecordType where SobjectType = 'Case' and Name ='New Inspections'];
        Case cs = new Case();
        cs.RecordTypeId = rt[0].Id;
        // Done for case # 00066557 consolidating business units IBD and Components into 'UPP Intl'.
        // cs.Business_Unit__c = 'Components';
        cs.Business_Unit__c = 'UPP Intl';
        cs.Region__c = 'SPNA';
        cs.Origin = 'Email';
        cs.VAR_Dept_Owner__c = 'Fab';
        cs.Subject = 'NewCase';
        cs.Status = 'New';
        cs.Type = 'Inspection';
        List<Account> lstAccount = [Select Id,Name,RecordTypeId From Account where BillingCountry = 'Italy' Limit 1]; 
        if(lstAccount.Size()>0){
           cs.AccountId = lstAccount[0].Id;
        }     
        insert cs;
            
        String test= 'Test';
        Attachment att = new Attachment();
        att.ParentId = cs.Id;
        att.Name ='TestAtt';
        att.Body =  Blob.valueOf(test);
        insert att;
                                 
        Inspection__c Inspection= new Inspection__c();
        Inspection.Case__c = cs.id;
        Inspection.Reviewer__c = user.Id;        
        Inspection.Site_Type__c = 'Residential';
        Inspection.Residential_Q49_Rating__c =  '123';
        Inspection.Residential_Q50_Rating__c =  '123';
        Inspection.Contact__c =user.Id;
        inspection.IsSaveByTSE__c = true;
               
        ApexPages.currentPage().getParameters().put('siteType','Residential');
        ApexPages.currentPage().getParameters().put('isEdit','true');        
        ApexPages.currentPage().getParameters().put('inspectionType','testRes');
        ApexPages.currentPage().getParameters().put('cancelURL',cs.Id);
     
        //Without CaseId & InspectionId
        ApexPages.StandardController sController = new ApexPages.StandardController(Inspection); 
        InspectionReportEUController controller = new InspectionReportEUController(sController);           
        controller.createCaseonImageUpload();
        controller.cancelInspection_EU();
      
        String CaseId = ApexPages.CurrentPage().getParameters().put('caseid',cs.Id);    
        ApexPages.StandardController sController1 = new ApexPages.StandardController(Inspection); 
        InspectionReportEUController controller1 = new InspectionReportEUController(sController1);        
        controller1.save_EU();
        controller1.QuickSave_EU();
        controller1.printResidential_EU();
         
        insert Inspection;      
        String InspectionId = ApexPages.CurrentPage().getParameters().put('Id',Inspection.Id); 
        ApexPages.StandardController sController2 = new ApexPages.StandardController(Inspection); 
        InspectionReportEUController controller2 = new InspectionReportEUController(sController2);       
        controller2.printResidential_EU();
               
        
        List<Account> lstAccount2 = [Select Id,Name From Account where BillingCountry = 'Germany' Limit 1]; 
        if(lstAccount2.Size()>0){
           cs.AccountId = lstAccount2[0].Id;           
        }
        update cs;
        List<Inspection__c> lstInspection = [Select Id,Name From Inspection__c Limit 1]; 
        if(lstInspection.Size()>0){
          Inspection.InspectionByTSE__c = lstInspection [0].Id;               
        } 
        update Inspection;
        
        controller2 = new InspectionReportEUController(sController2);
        
        List<SelectOption> siteType = new List<SelectOption> ();
        siteType  = controller1.getSiteType(); 
        
        List<SelectOption> Language = new List<SelectOption> ();
        Language = controller1.getLanguage();         
        
        String setRack = 'rack';
        String setSelLang = 'it';
        String setRoof = 'roof';
        String setMount = 'mount';
        
        controller1.setRack(setRack);
        controller1.getRack();
        
        controller1.setSelLang(setSelLang);
        controller1.getSelLang();
        
        controller1.setRoof(setRoof );
        controller1.getRoof();
        
        controller1.setMount(setMount);
        controller1.getMount();
        
        List<SelectOption> Roof = new List<SelectOption> ();
        Roof = controller1.getRoofMaterial(); 
        
        List<SelectOption> RackType = new List<SelectOption> ();
        RackType = controller1.getRackType(); 
        
        List<SelectOption> Lang = new List<SelectOption> ();
        Lang = controller1.getMountingType(); 
        
        controller1.redirect();
        controller1.populateLanguage(); 
        //controller1.SendMailtoDealer();    

        
            
       }
   
    }
}