//@isTest(SeeAllData=True)
@isTest (seeAllData=false)
public class TestScheduleReminders {

    public static String CRON_EXP = '0 0 0 15 3 ? 2022'; //cron expression for testing schedulable classes, added by KANE MACASPAC

   /* static testmethod void testex5() {
        Test.startTest();      
        scheduledReminders sr = new scheduledReminders();
        sr.executeFunction();
        BatchCalculateTimeForCRMCases batchTest = new BatchCalculateTimeForCRMCases();      
        Test.stopTest();
    } */
    
 /* static testMethod void createPostCsatTaskTest()
    { 
        Test.startTest();
    Account accountObj = new Account();
      accountObj.Name = 'Testing Account' +String.valueOf(DateTime.Now());
      accountObj.Type ='Residential Customer';
      accountObj.BillingCity = 'Temecula';
      accountObj.BillingCountry = 'United States';
      accountObj.BillingStreet = 'btm';
      accountObj.BillingPostalCode = '92592';
      accountObj.Theater__c = 'North America';
      accountObj.BillingState='CA';
      //accountObj.Territory__c = 'Spain';
      insert accountObj;  
       String username ='hello2233@world.com';
       User user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
       user.Username = username;
       user.Alias = 'yoo';
       user.CommunityNickname = username.subString(0,7);
       user.TimeZoneSidKey = 'America/Los_Angeles';
       user.EmailEncodingKey = 'ISO-8859-1';
       user.LanguageLocaleKey = 'en_US';
       user.Email = 'testRSMPopulate@test.com';
       user.LocaleSidKey = 'en_US';
       user.Division='IT'; 
       user.Country='United States';
       List<Profile> lstProfile = [select Id from Profile where Name = 'System Administrator' LIMIT 1];
       if(lstProfile.Size()>0 )
        {           
         user.ProfileId = lstProfile[0].Id;
        }
       insert user;
         List<RecordType> RecType=[SELECT Id,Name FROM RecordType WHERE Name = 'Standard Site'];     
         Site_Information_Form__c siteObj = new Site_Information_Form__c();
         siteObj.Site_Status__c ='Active';
         siteObj.Site_Name__c='Test';
         siteObj.Account__c=accountObj.Id;      
         if(RecType.Size()>0)
          {
          siteObj.RecordType=RecType[0];
          }
         insert siteObj;
        Interconnection_Application__c  inv = new Interconnection_Application__c();
        inv.Name='Test';
        inv.IA_Assigned_To__c =user.Id;
        inv.Site__c =siteObj.Id;
        inv.Type_of_Interconnection__c='NEM-Extended';
        inv.Utility_Customer_Account__c='TBD';
        inv.Utility_Service_Account__c='TBD';
        inv.Interconnection_Meter_Number__c='TBD';
        inv.Date_Interconnection_Cancelled__c=System.Today();
        inv.Trigger_Workflow__c=False;
        insert inv;
        scheduledReminders SBatch = new scheduledReminders();
        SchedulableContext sc ;
        SBatch.execute(sc);
         Test.stopTest();
    }  */
  
    //KANE MACASPAC 08-07-2015 04:13 AM PDT
    //test method for a schedulable class being implemented as fix for production error:
    //System.QueryException: Non-selective query against large object type
    //this should replace testex1() method below once completed 
/*    static testmethod void testex1() {
        //test data follows
        Account a = new Account();
        a.Name = 'Really Bright Solar';
        a.Type = 'Premier-Partner-Residential'; //PartnerRecordTypeAccount .Id;
        a.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        a.Dealer_Score_Total__c = 78;
        a.Dealer_Locator_Phone__c = '888-888-8888';
        a.Phone = '888-888-8888';
        a.BillingStreet = '150 Corona St';
        a.BillingCity = 'Denver';
        a.BillingState = 'CO';
        a.BillingCountry = 'United States';
        a.BillingPostalCode = '80218';
        a.website = 'www.sunpowercorp.com';
        a.Oracle_Account_Number__c = '123';
        a.Description = 'None';
        a.Partner_Facts__c = 'None';
        a.Status__c = 'Active';
        a.Dealer_Locator_Opt_Out__c = false;
        a.Lead_Flow_Opt_Out__c = false;
        a.Alliance_Program_Partner__c = true;
        a.Geolocation__Latitude__s = 39.718887;
        a.Geolocation__Longitude__s = -104.974036;
        a.Theater__c = 'North America';
        a.Send_PDF_Notification__c = true;
        insert a;
        
        
        Case cs = new Case(P5_Reminder__c = false, 
                           P5_Acknowledgement__c = false,
                           P1_Notification_Email__c = True,
                           Type ='Customer Complaint',
                           P5_Reminder_Date__c = Date.newInstance(2011,1,1),
                           P5_Maturity_Date__c = Date.newInstance(2015,1,1),
                           CreatedDate = DateTime.now().addDays(-10));
                           
        insert cs;

        SOA2TransactionDetails__c trans = new SOA2TransactionDetails__c(Partner__c = a.Id, Doc_No__c = 'abcdef',Communication_Sent__c = false);
        insert trans;        
    
        Test.startTest();
        //scheduling the test job
        String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new ScheduledReminders());
        System.assertNotEquals(jobId, null);
        //get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                            FROM CronTrigger WHERE id = :jobId LIMIT 1];
        
        //verify expresions are same                    
        System.assertEquals(CRON_EXP, ct.CronExpression);
        
        //check that the job has not run yet
        System.assertEquals(0, ct.TimesTriggered);
        
        //verify the next run time for the test job; if cron expression above has been changed,
        //change this date/time accordingly too
        System.assertEquals('2022-03-15 00:00:00', String.valueOf(ct.NextFireTime));
        
        Test.stopTest();
    }
*/    
    /*static testmethod void testex1() {      
        
        Test.startTest();
        Case cs = new Case();
        cs.P5_Reminder__c = false;
        cs.P5_Acknowledgement__c = false;
        cs.P1_Notification_Email__c = True;
        cs.Type ='Customer Complaint';
        cs.P5_Reminder_Date__c = Date.newInstance(2011,1,1);
        cs.P5_Maturity_Date__c = Date.newInstance(2015,1,1);
        cs.CreatedDate = DateTime.now().addDays(-10);
        insert cs;
                
        List<Account> accList = new List<Account>([select id,name from Account where type like '%Partner%' and Send_PDF_Notification__c = true  limit 1]); 
        if(accList.size() > 0){
            Account acc = accList[0];
            SOA2TransactionDetails__c trans = new SOA2TransactionDetails__c(Partner__c = acc.Id, Doc_No__c = 'abcdef',Communication_Sent__c = false);
            insert trans;
        }
         
        scheduledReminders sr1 = new scheduledReminders();
        sr1.executeFunction();        
        
        cs.P30_Reminder_Date__c = Date.newInstance(2011,1,1);
        cs.P30_Maturity_Date__c = Date.newInstance(2015,1,1);
        cs.P5_Reminder_Date__c = Date.today().addDays(4);
        update cs;
        sr1.executeFunction();
        Test.stopTest();       
    }*/
       //Start - Case # 00180002 - added for new schedulable class, "ScheduleReminders1"
  /*  static testmethod void testscheduledReminders1() {      
         Test.startTest();
        scheduledReminders1 sr = new scheduledReminders1();
        sr.executeFunction();
         Test.stopTest();
    }  */
    
}