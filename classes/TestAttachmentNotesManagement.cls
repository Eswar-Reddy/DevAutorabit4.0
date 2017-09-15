/********************************************************************************************
Name   : TestAttachmentNotesManagement
Author : Jitendra Kothari
Date   : July 11, 2011
Usage  : Test Class for AttachmentNotesManagement.
Case   : 00068744
********************************************************************************************/
public class TestAttachmentNotesManagement {
    @isTest
    public static void test_AttachmentNotesManagement(){ 
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
       user.Email = 'testDesignManage@tt.com';
       user.LocaleSidKey = 'en_US';
       user.Web_User__c = True;
       user.ByPassValidation__c = False;
       
       List<Profile> lstProfile = [select Id from Profile where Name = 'System Administrator'];
       if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            insert user;
        }
        Design__c design;
       System.RunAs(user){
       
       Id designRecordTypeId = Schema.SObjectType.Design__c.getRecordTypeInfosByName().get('Proposal Design').getRecordTypeId();
       Id siteRecordTypeId = Schema.SObjectType.Site_Information_Form__c.getRecordTypeInfosByName().get('Standard Site').getRecordTypeId();
       /*List<RecordType> rt = [select Id, Name From RecordType where SobjectType = 'Site_Information_Form__c' and Name ='Standard Site'];
       List<RecordType> DesignRt = [Select Id, DeveloperName from RecordType where SobjectType = 'Design__c' and Name = 'Project Design'];
       List<RecordType> DesignRt2 = [Select Id, DeveloperName from RecordType where SobjectType = 'Design__c' and DeveloperName = 'Proposal_Design'];*/
       
       Account acc= new Account();
       acc.Name = 'Test_New_Acc';   
       acc.BillingCity='Tesr_City';
       acc.BillingState='Tesr_State';
       acc.BillingPostalCode='1234';
       acc.BillingCountry='Tesr_Country';
       acc.BillingStreet= 'Test_street';  
       insert acc;
       
       
       Opportunity opp = new Opportunity();
       opp.Name = 'Testopp';
       List<Account> lstAcc = [select Id,Name from Account limit 1];
       if(lstAcc.Size()>0){
           opp.AccountId =lstAcc[0].Id;
           opp.StageName = '04 � Negotiate Contract';
           opp.CloseDate = system.today();
           insert opp;
          }
       
       OpportunityTeamMember oppMem = new OpportunityTeamMember();
       oppMem.TeamMemberRole = 'Sales Analyst';
       oppMem.OpportunityId = opp.Id;
       oppMem.UserId = user.Id;
       insert oppMem;  
       
       Site_Information_Form__c lstsite = new Site_Information_Form__c();
       lstsite.RecordTypeId = siteRecordTypeId;
       lstsite.Site_Name__c = 'Test_Site';
       lstsite.Account__c= acc.Id;
       lstsite.Opportunity_del__c = opp.id;
       insert lstsite;
       
       /*PSR__c psr = new PSR__c();
       List<Product2> lstProd = [select Id,Name from Product2];
       if(lstProd.Size()>0){
           psr.Mounting_System__c = lstProd[0].Id;
           psr.PV_Module_Type__c = lstProd[0].Id;
           psr.array_layout_completed__c = system.today().addDays(1);
           psr.Design_Tracking__c = system.today().addDays(1);
           insert psr;
        }  */     
       design__c DNoId = new Design__c();
       DNoId.Status__c = 'Active';
       DNoId.Site__c = lstsite.Id;
       DNoId.RecordTypeId = designRecordTypeId;
       DNoId.Date_Design_Completed__c = system.today();
       DNoId.Design_Tracking__c = system.today();
       DNoId.Record_Drawings_Actual_Submit__c = system.today();
       //DNoId.PSR__c = psr.Id;
       DNoId.Opportunity__c = opp.Id;
       DNoId.OwnerId = user.Id;
       
       
       design = new Design__c();
       design.Status__c = 'Active';
       design.Site__c = lstsite.Id;
       design.RecordTypeId = designRecordTypeId;
       design.Date_Design_Completed__c = system.today();
       design.Design_Tracking__c = system.today();
       design.Record_Drawings_Actual_Submit__c = system.today();
       //design.PSR__c = psr.Id;
       design.Opportunity__c = opp.Id;
       design.OwnerId = user.Id;
       insert design;
       AttachmentNotesManagement.getDesigns();
       
       Attachment attach1 = new Attachment(ParentId=design.Id);
       attach1.Name = 'TestAttachment1';
       attach1.Body = Blob.valueOf('TestBody');      
       Test.startTest(); 
        insert attach1;
        
        
       Note notes1 = new Note(ParentId=design.Id);
       notes1.Title = 'TestNotes1';
       notes1.Body = 'TestBody1';
       insert notes1;       
       
       design.Status__c = 'Completed';
       
       update design;
              
       Attachment attach = new Attachment(ParentId=design.Id);
       attach.Name = 'TestAttachment';
       attach.Body = Blob.valueOf('TestBody');
           try{
            insert attach;
           }catch(DMLException ex){
                    System.assert(ex.getMessage().contains('Can\'t insert/update/delete Attachments for approved Design.'));
           }
           Note notes = new Note(ParentId=design.Id);
           notes.Body = 'TestBody';
           notes.Title = 'TestNotes';
           try{
            insert notes;
           }catch(DMLException ex){
                    System.assert(ex.getMessage().contains('Can\'t insert/update/delete Notes for approved Design.'));
           }
           try{
            delete attach1;
           }catch(DMLException ex){
                    System.assert(ex.getMessage().contains('Can\'t insert/update/delete Attachments for approved Design.'));
           }
           try{
            delete notes1;
           }catch(DMLException ex){
                    System.assert(ex.getMessage().contains('Can\'t insert/update/delete Notes for approved Design.'));
           }
       }
       Attachment attach2 = new Attachment(ParentId=design.Id);
       attach2.Name = 'TestAttachment';
       attach2.Body = Blob.valueOf('TestBody');
       //Shree- 27092012 : Due to Bluwolf Booking Template Module Faliure: added Exception Handling Block
       try{
           insert attach2;
       }catch(Exception ex){}
       
       Test.stopTest();
    }
}