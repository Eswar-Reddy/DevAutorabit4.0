@isTest
public class TestDesignManagement{
    
    @future
    public static void setupTestData() { 
        SFDCSpecialUtilities.isRunningTest = True;
        UserManagement.IS_TEST = true;
        ReminderEmailAddress__c archive = new ReminderEmailAddress__c();
        archive.email__c = 'salesforcearchives@sunpowercorp.com.test';
        insert archive;
        
        User testUser = TestClassFactory.testUser('System Administrator', 'test' + '856498111@' + 'emailName.123', '1234spwr');
        testUser.SOX_Profile_was_approval_received__c = true;
        testUser.Division = 'IT';
        testUser.Country = 'US';
        insert testUser;
    }
    
    public static TestMethod void test_method() { 
        
        SFDCSpecialUtilities.isRunningTest = True; 
        setupTestData();
        
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
        user.SOX_Profile_was_approval_received__c = true;
        user.ProfileId = SFDCSpecialUtilities.getProfileIdByName('System Administrator');
        
        System.RunAs(user){

            Util.currentUser = user;
            
            List<RecordType> rt = [select Id, Name From RecordType where SobjectType = 'Site_Information_Form__c' and Name ='Standard Site'];
            List<RecordType> DesignRt = [Select Id, DeveloperName from RecordType where SobjectType = 'Design__c' and Name = 'Project Design'];
            List<RecordType> DesignRt2 = [Select Id, DeveloperName from RecordType where SobjectType = 'Design__c' and DeveloperName = 'Proposal_Design'];
            
            Account acc= new Account();
            acc.Name = 'Test_New_Acc';   
            acc.BillingCity='Tesr_City';
            acc.BillingState='Tesr_State';
            acc.BillingPostalCode='1234';
            acc.BillingCountry='Tesr_Country';
            acc.BillingStreet= 'Test_street';  
            insert acc;
            
            List<Opportunity > oppList = new List<Opportunity >();
            Opportunity opp = new Opportunity();
            opp.Name = 'topp';
            opp.accountId=acc.id;
            opp.StageName='test';
            opp.Probability=3;
            opp.CloseDate=system.today();
            oppList.add(opp);            
            insert oppList;
            
            User testUser;
            try {
                testUser = [SELECT Id FROM User WHERE Id !=: UserInfo.getUserId() AND Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
            } catch(Exception e) { }
            
            List<OpportunityTeamMember> members = new List<OpportunityTeamMember>();
            
            OpportunityTeamMember oppMem = new OpportunityTeamMember();
            oppMem.TeamMemberRole = 'Sales Analyst';
            oppMem.OpportunityId = opp.Id;
            oppMem.UserId = UserInfo.getUserId();
            members.add(oppMem);
            
            if(testUser != null && testUser.Id != null) {
                OpportunityTeamMember oppMem2 = new OpportunityTeamMember();
                oppMem2.TeamMemberRole = 'Sales Person';
                oppMem2.OpportunityId = opp.Id;
                oppMem2.UserId = testUser.Id;
                members.add(oppMem2);
            } 
            insert members;
            
            Site_Information_Form__c lstsite = new Site_Information_Form__c();
            lstsite.RecordTypeId = rt[0].Id;
            lstsite.Site_Name__c = 'Test_Site';
            lstsite.Account__c= acc.Id;
            lstsite.Opportunity_del__c = opp.id;
            insert lstsite;
            
            PSR__c psr = new PSR__c();
            List<Product2> lstProd = [select Id,Name from Product2 WHERE isActive = TRUE AND Case_Product__c = FALSE];
            if(lstProd.Size()>0){
                psr.Mounting_System__c = lstProd[0].Id;
                psr.PV_Module_Type__c = lstProd[0].Id;
                psr.array_layout_completed__c = system.today().addDays(1);
                psr.Design_Tracking__c = system.today().addDays(1);
                insert psr;
            }
            
            List<Design__c> lstdesign = new List<Design__c>();    
            Design__c design = new Design__c();
            design.Status__c = 'STATUS_CUSTOMER_SERVICE';
            design.Site__c = lstsite.Id;
            design.RecordTypeId =DesignRt[0].Id;
            design.Date_Design_Completed__c = date.newInstance(2000,12,12);
            design.Design_Tracking__c = system.today();
            design.Record_Drawings_Actual_Submit__c = system.today();
            design.Record_Drawings_Red_lines_Received__c=date.newInstance(2011,12,12);
            design.Permit_Award_Actual__c=date.newInstance(2011,2,12);
            design.Plan_Check_Actual_Submit__c=date.newInstance(2011,3,23);
            design.Client_Approve_Package__c=date.newInstance(2011,2,2);
            design.Client_Review_Actual_Submit__c=date.newInstance(2009,2,2);
            design.X75_Percent_Briefing_Meeting__c=date.newInstance(2010,12,2);
            design.PSR__c = psr.Id;
            design.Opportunity__c = opp.Id;
            // design.OwnerId = user.Id;
            insert design;
            lstdesign.add(design);
            //DesignManagement.getDesignRecordTypes();
            DesignManagement.updateRelatedObjects(lstDesign);
            
            design.Date_Design_Completed__c = date.newInstance(2011,12,23);
            design.Status__c='Completed';
			design.Technology_System__c = Label.HelixDualTilt;
            if(testUser != null && testUser.Id != null) 
                design.OwnerId = testUser.Id;
            design.Record_Drawings_Actual_Submit__c = null;
            design.Record_Drawings_Red_lines_Received__c = null;
            design.Permit_Award_Actual__c = null;
            design.Plan_Check_Actual_Submit__c = null;
            design.Client_Approve_Package__c = null;
            design.Client_Review_Actual_Submit__c = null;
            design.Design_Tracking__c = null;
            design.X75_Percent_Briefing_Meeting__c=date.newInstance(2014,12,2);
            List<design__c> newListTemp = new List<design__c>();
            newListTemp.add(design);
            DesignManagement.populateDesignFields(newListTemp, null);
            
            design.Record_Drawings_Actual_Submit__c = system.today();
            design.Record_Drawings_Red_lines_Received__c=date.newInstance(2011,12,12);
            design.Permit_Award_Actual__c=date.newInstance(2011,2,12);
            design.Plan_Check_Actual_Submit__c=date.newInstance(2011,3,23);
            design.Client_Approve_Package__c=date.newInstance(2011,2,2);
            design.Client_Review_Actual_Submit__c=date.newInstance(2009,2,2);
            update design;

            List<Design__c> designs = new List<Design__c>();
            designs.add(design);

            DesignManagement.selectPrimaryPSRDesign(designs);
            
            List<design__c> newList = [select id,Opportunity__c,Date_Design_Completed__c,Status__c,OwnerId,Design_Tracking__c,Record_Drawings_Actual_Submit__c,name from design__c where id =: design.id];
            
            design.Date_Design_Completed__c = system.today();
            design.Status__c='Completed';
			design.Technology_System__c = Label.HelixDualTilt;
            design.OwnerId = UserInfo.getUserId();
            design.Design_Tracking__c = date.newInstance(2000,12,23);
            design.Record_Drawings_Actual_Submit__c = date.newInstance(2011,11,23);
            try{
                update design;
            } catch(Exception e) {          
            
            } 
            List<design__c> newList1 = [select id,Opportunity__c,Date_Design_Completed__c,Status__c,OwnerId,Design_Tracking__c,Record_Drawings_Actual_Submit__c,name,Technology_System__c from design__c where id =: design.id];
            
            
            DesignManagement.SendEmailonDesignAssignedtoDesigner(newList , lstdesign);           
            
        } 
    }
    
    @isTest
    public static void test_method1()
    { 
        SFDCSpecialUtilities.isRunningTest = True; 
        
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
        user.SOX_Profile_was_approval_received__c = true;
        user.ProfileId = SFDCSpecialUtilities.getProfileIdByName('System Administrator');
        insert user;
        
        List<RecordType> rt = [select Id, Name From RecordType where SobjectType = 'Site_Information_Form__c' and Name ='Standard Site'];
        List<RecordType> DesignRt = [Select Id, DeveloperName from RecordType where SobjectType = 'Design__c' and Name = 'Project Design'];
        List<RecordType> DesignRt2 = [Select Id, DeveloperName from RecordType where SobjectType = 'Design__c' and DeveloperName = 'Proposal_Design'];
        
        Account acc= new Account();
        acc.Name = 'Test_New_Acc';   
        acc.BillingCity='Tesr_City';
        acc.BillingState='Tesr_State';
        acc.BillingPostalCode='1234';
        acc.BillingCountry='Tesr_Country';
        acc.BillingStreet= 'Test_street';  
        insert acc;
        
        
        Contact con = new Contact();
        con.lastname='test';
        con.email='test@sify.com';
        con.firstname='contact1';
        con.accountId=acc.id;
        insert con;
        
        List<Opportunity > oppList = new List<Opportunity >();
        Opportunity opp = new Opportunity();
        opp.Name = 'topp';
        opp.accountId=acc.id;
        opp.StageName='test';
        opp.CloseDate=system.today();
        oppList.add(opp);        
        insert oppList;
        
        User testUser;
        try {
            testUser = [SELECT Id FROM User WHERE Id !=: UserInfo.getUserId() AND Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
        } catch(Exception e) { }
        
        List<OpportunityTeamMember> members = new List<OpportunityTeamMember>();
        
        OpportunityTeamMember oppMem = new OpportunityTeamMember();
        oppMem.TeamMemberRole = 'Sales Analyst';
        oppMem.OpportunityId = opp.Id;
        oppMem.UserId = UserInfo.getUserId();
        members.add(oppMem);
        
        if(testUser != null && testUser.Id != null) {
            OpportunityTeamMember oppMem2 = new OpportunityTeamMember();
            oppMem2.TeamMemberRole = 'Sales Person';
            oppMem2.OpportunityId = opp.Id;
            oppMem2.UserId = testUser.Id;
            members.add(oppMem2);
        } 
        insert members; 
        
        ReminderEmailAddress__c archive = new ReminderEmailAddress__c();
        archive.email__c = 'salesforcearchives@sunpowercorp.com.test';
        insert archive;
        
        Site_Information_Form__c lstsite = new Site_Information_Form__c();
        lstsite.RecordTypeId = rt[0].Id;
        lstsite.Site_Name__c = 'Test_Site';
        lstsite.Account__c= acc.Id;
        lstsite.Opportunity_del__c = opp.id;
        insert lstsite;
        
        PSR__c psr = new PSR__c();
        List<Product2> lstProd = [select Id,Name from Product2 WHERE isActive = TRUE AND Case_Product__c = FALSE];
        if(lstProd.Size()>0){
            psr.Mounting_System__c = lstProd[0].Id;
            psr.PV_Module_Type__c = lstProd[0].Id;
        }
        psr.array_layout_completed__c = system.today().addDays(1);
        psr.Design_Tracking__c = system.today().addDays(1);
        
        insert psr;
    
        System.runAs(user) {

            Util.currentUser = user;

            List<Design__c> lstdesign = new List<Design__c>(); 
            Design__c design = new Design__c();
            design.Status__c = 'Awaiting Approval';
            design.Site__c = lstsite.Id;
            design.RecordTypeId =DesignRt2[0].Id;
            design.Date_Design_Completed__c = date.newInstance(2000,12,12);
            design.Design_Tracking__c = system.today();
            design.X75_Percent_Briefing_Meeting__c=date.newInstance(2010,12,2);
            design.PSR__c = psr.Id;
            design.Opportunity__c = opp.Id;
            design.OwnerId = user.Id;
            design.Designer_1__c = user.Id;
            design.Designer_2__c = user.Id;
           try{
            insert design;
           }catch(Exception e){
            
           }
            lstdesign.add(design);
            
            DesignManagement.populateDesignFields(lstdesign, null);
            
            User  user1 = null;
            
            String username1 ='heo@world.com';
            user1 = new User(LastName = 'ab2'+String.ValueOf(DateTime.Now()) ,FirstName = 'G'+ String.ValueOf(DateTime.Now()));
            user1.Username = username1;        
            user1.Alias = 'rto';       
            user1.CommunityNickname = username.subString(0,2);
            user1.TimeZoneSidKey = 'America/Los_Angeles';
            user1.EmailEncodingKey = 'ISO-8859-1';
            user1.LanguageLocaleKey = 'en_US';
            user1.Email = 'test@test.com';
            user1.LocaleSidKey = 'en_US';
            user1.division='IT';
            user1.country='USA';
            user1.SOX_Profile_was_approval_received__c = true;
            Test.startTest();
            user1.ProfileId = SFDCSpecialUtilities.getProfileIdByName('System Administrator');
            insert user1;
            
            ReminderEmailAddress__c reminder = ReminderEmailAddress__c.getOrgDefaults();
            try{
                design__c design1=[SELECT Id, Opportunity__c, Technology_System__c, Date_Design_Completed__c, Status__c, OwnerId, Design_Tracking__c,
                                          Record_Drawings_Actual_Submit__c, Name, PSR__c FROM Design__c WHERE Id =: design.id];
                design1.Date_Design_Completed__c = system.today();
                if(reminder != null) {
                    design1.Status__c='Completed';
					design1.Technology_System__c = Label.HelixDualTilt;
				}
                design1.OwnerId = user1.Id;
                design1.Design_Tracking__c = date.newInstance(2000,12,23);
                design1.Record_Drawings_Actual_Submit__c = date.newInstance(2011,11,23);
                update design1;
                
                List<design__c> newList = new List<design__c>();
                newList.add(design1);
                
                DesignManagement.SendEmailonDesignAssignedtoDesigner(newList,lstdesign);
             //   DesignManagement.SendEmailonDesignOwnerChangeORCompleteApproved(newList,lstdesign);
            }catch(Exception e){
            
           }

       }      
    }
    
  /* Method:    testFinalDesign 
   * Purpose:   This test method made primary design as per Project/Design record type
   * CreatedBy: Raee$
   * Date:      8/22/2016
   */  
      public static TestMethod void testFinalDesign() { 
        
        SFDCSpecialUtilities.isRunningTest = True; 
        setupTestData();
        
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
        user.ByPassValidation__c = false;
        user.SOX_Profile_was_approval_received__c = true;
        user.ProfileId = SFDCSpecialUtilities.getProfileIdByName('System Administrator');
        
        System.RunAs(user){

            Util.currentUser = user;
            
            List<RecordType> rt = [select Id, Name From RecordType where SobjectType = 'Site_Information_Form__c' and Name ='Standard Site'];
            List<RecordType> DesignRt = [Select Id, DeveloperName from RecordType where SobjectType = 'Design__c' and Name = 'Project Design'];
            List<RecordType> DesignRt2 = [Select Id, DeveloperName from RecordType where SobjectType = 'Design__c' and DeveloperName = 'Proposal_Design'];
            
            Account acc= new Account();
            acc.Name = 'Test_New_Acc';   
            acc.BillingCity='Tesr_City';
            acc.BillingState='Tesr_State';
            acc.BillingPostalCode='1234';
            acc.BillingCountry='Tesr_Country';
            acc.BillingStreet= 'Test_street';  
            insert acc;
            
            List<Opportunity > oppList = new List<Opportunity >();
            for(Integer i=0 ; i<2 ; i++){
                Opportunity opp = new Opportunity();
                opp.Name = 'topp';
                opp.accountId=acc.id;
                opp.StageName='01 - Build Single Sales Objective';
                if( i == 0)
                    opp.RecordTypeId = DesignManagement.systemOpptyRecordType;
                    
                opp.RecordTypeId = DesignManagement.commercialOpptyRecordType;  
                opp.Business_Unit__c = 'NA Commercial';
                opp.Probability=0.12;
                opp.Override_System_Size__c = false;
                opp.CloseDate=system.today();
                oppList.add(opp);            
            }
            try{    
                insert oppList;
              }catch(Exception e){
               } 
            User testUser;
            try {
                testUser = [SELECT Id FROM User WHERE Id !=: UserInfo.getUserId() AND Profile.Name = 'System Administrator' AND isActive = true LIMIT 1];
            } catch(Exception e) { }           
            
            List<Site_Information_Form__c> listOfSite = new List<Site_Information_Form__c>();
            for(Integer i=0 ; i<2 ; i++){
                Site_Information_Form__c lstsite = new Site_Information_Form__c();
                lstsite.RecordTypeId = rt[0].Id;
                lstsite.Site_Name__c = 'Test_Site';
                lstsite.Account__c= acc.Id;
                lstsite.Site_Country__c = 'Test Country'; 
                lstsite.Site_State__c = 'Test State';
                lstsite.Site_City__c = 'Test City';
                lstsite.Site_Address__c = 'Test Address';
                lstsite.Site_Zip_Postal_Code__c = '94086';
                if(i == 0)
                    lstsite.Opportunity_del__c = oppList.get(0).id;
                lstsite.Opportunity_del__c = oppList.get(1).id;
                listOfSite.add(lstsite);
            }
            try{
                insert listOfSite;
                 }catch(Exception e){
               }        
            List<Design__c> lstdesign = new List<Design__c>();    
            List<Design__c> lstUpdatedesign = new List<Design__c>();
            Design__c design;
            for(Integer i=1; i<=3 ; i++){
                design = new Design__c();
                design.Status__c = 'STATUS_CUSTOMER_SERVICE';
                
                if(i==1){
                    design.RecordTypeId = DesignManagement.proposalRecordType;
                    design.Final_Design__c = true;
                    design.Opportunity__c = oppList.get(1).id;
                    design.Site__c = listOfSite.get(1).Id; 
                }else if(i==2){
                    design.RecordTypeId = DesignManagement.projectRecordType;   
                    design.Final_Design__c = false; 
                    design.Opportunity__c = oppList.get(0).id;
                    design.Site__c = listOfSite.get(0).Id; 
                } else {
                    design.RecordTypeId = DesignManagement.projectRecordType;   
                    design.Final_Design__c = false; 
                    design.Opportunity__c = oppList.get(0).id;
                    //design.Site__c = listOfSite.get(0).Id; 
                }          
                design.Date_Design_Completed__c = date.newInstance(2000,12,12);
                design.Technology_System__c = Label.HelixDualTilt;
				design.Design_Tracking__c = system.today();
                design.Record_Drawings_Actual_Submit__c = system.today();
                design.Record_Drawings_Red_lines_Received__c=date.newInstance(2011,12,12);
                design.Permit_Award_Actual__c=date.newInstance(2011,2,12);
                design.Plan_Check_Actual_Submit__c=date.newInstance(2011,3,23);
                design.Client_Approve_Package__c=date.newInstance(2011,2,2);
                design.Client_Review_Actual_Submit__c=date.newInstance(2009,2,2);
                design.X75_Percent_Briefing_Meeting__c=date.newInstance(2010,12,2);
                design.Actual_System_Size__c = 10;
               
                lstdesign.add(design);             
            }
            try{
                if(!lstdesign.isEmpty()){
                    Database.saveResult [] srList = Database.insert(lstdesign,false); 
                }
            } catch(Exception e) {
             
            } 
            for(Design__c designn: lstdesign){
                if(designn.RecordTypeId == DesignManagement.projectRecordType){
                    designn.Final_Design__c = true;
                    design.Actual_System_Size__c = 100;
                    lstUpdatedesign.add(designn);     
                }                   
            }

            Database.saveResult [] srList = Database.update(lstUpdatedesign,false);

            Design__c dTest = lstUpdatedesign[0];
            dTest.Site__c = listOfSite.get(0).Id;
            //trying scenario testing
            try {
                update dTest;
            } catch(Exception e) {

            }

            dTest.Opportunity__c = oppList.get(1).id;
            try {
                update dTest;
            } catch(Exception e) {

            }
        
            try {
                Database.DeleteResult [] dListDesigns = Database.delete(lstdesign,false); 
                Database.DeleteResult [] dListSite = Database.delete(listOfSite,false); 
            } catch(Exception e) {              
            
            }      
        } 
    }

    private static TestMethod void testDesignNegatives() {

        SFDCSpecialUtilities.isRunningTest = True; 
        setupTestData();
        
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
        user.ByPassValidation__c = true;
        user.SOX_Profile_was_approval_received__c = true;
        user.ProfileId = SFDCSpecialUtilities.getProfileIdByName('System Administrator');
        
        System.RunAs(user){

            Util.currentUser = user;

            Design__c d = new Design__c();
            insert d;

            Test.startTest();
            d.Actual_System_Size__c = NULL;
            d.Final_Design__c = true;
            d.Dealer_Status__c = 'Design In Progress';
            try {
                update d;
            } catch(Exception e) {
                //should hit this error
            }

            Test.stopTest();

        }
    }
}