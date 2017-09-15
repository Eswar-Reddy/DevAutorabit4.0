@isTest
public with sharing class TestClassUtilities {
    
    public static User getPartnerPortalUser(Account acct){
        User user = null;
        for(User u:[select id,Name,contactId,Contact.AccountID, Contact.Account.Id,Contact.Account.AccountNumber,Contact.Account.Name,Contact.Account.ShippingStreet,Contact.Account.ShippingState,Contact.Account.ShippingCity,Contact.Account.ShippingCountry,Contact.Account.ShippingPostalCode,Contact.Account.Oracle_Operating_Unit__c, Contact.Account.Oracle_Account_Number__c from User where (Profile.Name = 'Partner Delegated Administrator') and ContactID != null and Contact.Authorized_to_Order__c = true and Contact.Account.Online_Order_Access__c = true and Contact.Account.ShippingCountry != null and Contact.Account.ShippingCity != null and Contact.Account.ShippingStreet != null and Contact.Account.ShippingState != null and Contact.Account.ShippingPostalCode != null and isActive=true LIMIT 1]){
            user =u;
        }
        if(user != null) return user;
        if(acct == null){
            acct =  getPartnerAccount();
        }
        Contact cont = new Contact(AccountID = acct.id,FirstName='testconbyPO2',LastName='testconbyPO2');
        cont.Email ='te@test.com';
        cont.Authorized_to_Order__c = true;
        cont.RecordTypeID =  util.GetRecordTypeIdsByDeveloperName(Contact.SObjectType).get('Partner'); //MAM 19.MAY.2015 Get Contact Partner RecordTypeId
        insert cont;        
        
        String username ='testconbyPO2@world.com';
        user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
        user.ContactId = cont.Id;
        user.Username = username;
        user.Alias = 'yoo';
        user.CommunityNickname = username.subString(0,7);
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.Email = cont.Email;
        user.LocaleSidKey = 'en_US';     
        List<Profile> lstProfile = [select Id from Profile where Name = 'Partner Executive'];
        if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            insert user;
        }
        if(user.Id != null)
            for(User u:[select id,Name,contactId,Contact.AccountID, Contact.Account.AccountNumber,Contact.Account.Name,Contact.Account.ShippingStreet,Contact.Account.ShippingState,Contact.Account.ShippingCity,Contact.Account.ShippingCountry,Contact.Account.ShippingPostalCode,Contact.Account.Oracle_Operating_Unit__c, Contact.Account.Oracle_Account_Number__c from User where id =:user.ID LIMIT 1])
                user = u; 
        return user;      
    }
    
    public static Account getPartnerAccount(){
        String recType ='';
        for(RecordType r:[select id,Name from RecordType where sObjectType ='Account' and name ='Partner' LIMIT 1])
             recType = r.ID;
             
        Account acct = new Account(name='test'+String.valueOf(DateTime.now().getTime()),recordTypeID=recType);
        acct.ShippingCity = 'Jaipur';
        acct.ShippingStreet = 'Durgapura';
        acct.ShippingCountry = 'India';
        acct.ShippingState='Rajasthan';
        acct.ShippingPostalCode ='302018';
        acct.BillingCity = 'Jaipur';
        acct.BillingStreet = 'Durgapura';
        acct.BillingCountry = 'India';
        acct.BillingState='Rajasthan';
        acct.BillingPostalCode ='302018';
        acct.Online_Order_Access__c = true;
        acct.Oracle_Account_Number__c = 'test-12345';
        
        insert acct;
        return acct;                     
    }
    
    public static void createMetricData(){
        Date startDate = date.newinstance(Date.today().year(), 7, 1); 
        Date endDate = date.newinstance(Date.today().year(), 12, 31);
        
        Performance_Metric__c perfMetric = new Performance_Metric__c(channel__c='Commercial', Peformance_Metric_Name__c='USAJuly2010_to_Dec2010_Comm',Country__c='USA',Thea__c='North America',Performance_Period_Start_Date__c= startDate,Performance_period_End_date__c =endDate ,Metric_Setup_Cut_off_Date__c = startdate.adddays(-15),Performance_Evaluation_Cut_off_Date__c = enddate.adddays(15) ); 
        insert perfMetric;
        
        Tier__c tier = new Tier__c();
        tier.Country__c = 'USA';
        insert tier;
        
        List<Metric_Tier_Relation__c> listMetrics = new List<Metric_Tier_Relation__c>();
        Metric_Tier_Relation__c csatMetric1 = new Metric_Tier_Relation__c(Performance_Metric__c = perfMetric.Id);
        csatMetric1.Metric_Label__c = 'Customer Satisfaction Score';
        csatMetric1.Metric_Description__c = 'Customer Satisfaction Score';
        csatMetric1.Category__c = 'Customer Satisfaction';
        csatMetric1.Metric_Min_Value__c = 80;
        csatMetric1.Metric_Input_Type__c = 'Automated';
        csatMetric1.Stay_Tier__c = true;
        listMetrics.add(csatMetric1);
        
        Metric_Tier_Relation__c csatMetric2 = new Metric_Tier_Relation__c(Performance_Metric__c = perfMetric.Id);
        csatMetric2.Metric_Label__c = 'Warranty Card Received';
        csatMetric2.Metric_Description__c = 'Warranty Card Received';
        csatMetric2.Category__c = 'Customer Satisfaction';
        csatMetric2.Metric_Min_Value__c = 80;
        csatMetric2.Metric_Input_Type__c = 'Automated';
        csatMetric2.Stay_Tier__c = true;
        listMetrics.add(csatMetric2);
        
        Metric_Tier_Relation__c csatMetric3 = new Metric_Tier_Relation__c(Performance_Metric__c = perfMetric.Id);
        csatMetric3.Metric_Label__c = 'T5, T10 and PowerGuard installation inspections Passed (90% Score)';
        csatMetric3.Metric_Description__c = 'T5, T10 and PowerGuard installation inspections Passed (90% Score)';
        csatMetric3.Category__c = 'Customer Satisfaction';
        csatMetric3.Metric_Min_Value__c = 90;
        csatMetric3.Metric_Input_Type__c = 'Automated';
        csatMetric3.Stay_Tier__c = true;
        listMetrics.add(csatMetric3);
        
        Metric_Tier_Relation__c csatMetric4 = new Metric_Tier_Relation__c(Performance_Metric__c = perfMetric.Id);
        csatMetric4.Metric_Label__c = 'SunPower Installations Registered at CRM';
        csatMetric4.Metric_Description__c = 'SunPower Installations Registered at CRM';
        csatMetric4.Category__c = 'Customer Satisfaction';
        csatMetric4.Metric_Min_Value__c = 100;
        csatMetric4.Metric_Input_Type__c = 'Automated';
        csatMetric4.Stay_Tier__c = true;
        listMetrics.add(csatMetric4);
        
        Metric_Tier_Relation__c training1 = new Metric_Tier_Relation__c(Performance_Metric__c = perfMetric.Id);
        training1.Metric_Label__c = 'Training:  Attended Fundamentals of Commercial Installation';
        training1.Metric_Description__c = 'Training:  Attended Fundamentals of Commercial Installation';
        training1.Category__c = 'Training';
        training1.Metric_Min_Value__c = 1;
        training1.Metric_Input_Type__c = 'Automated';
        training1.Stay_Tier__c = true;
        listMetrics.add(training1);
        
        Metric_Tier_Relation__c training2 = new Metric_Tier_Relation__c(Performance_Metric__c = perfMetric.Id);
        training2.Metric_Label__c = 'Bonus for Extra Training';
        training2.Metric_Description__c = 'Bonus for Extra Training';
        training2.Category__c = 'Training';
        training2.Incentive_Amount__c = 0.5;
        training2.Part_Of_Composite_Incentive__c = true;    
        training2.Boolean_Metric_Y_N__c = true;
        training2.Metric_Input_Type__c = 'Automated';
        training2.Benefit_Tier__c = true;
        listMetrics.add(training2);
        
        Metric_Tier_Relation__c training3 = new Metric_Tier_Relation__c(Performance_Metric__c = perfMetric.Id);
        training3.Metric_Label__c = 'Training:  Attended Fundamentals of Commercial Sales';
        training3.Metric_Description__c = 'Training:  Attended Fundamentals of Commercial Sales';
        training3.Category__c = 'Training';
        training3.Metric_Min_Value__c = 1;
        training3.Metric_Input_Type__c = 'Automated';
        training3.Stay_Tier__c = true;
        listMetrics.add(training3);
        
        Metric_Tier_Relation__c training4 = new Metric_Tier_Relation__c(Performance_Metric__c = perfMetric.Id);
        training4.Metric_Label__c = 'Training:  Attended Fundamentals of Commercial Design';
        training4.Metric_Description__c = 'Training:  Attended Fundamentals of Commercial Design';
        training4.Category__c = 'Training';
        training4.Metric_Min_Value__c = 1;
        training4.Metric_Input_Type__c = 'Automated';
        training4.Stay_Tier__c = true;
        listMetrics.add(training4);
        
        Metric_Tier_Relation__c training5 = new Metric_Tier_Relation__c(Performance_Metric__c = perfMetric.Id);
        training5.Metric_Label__c = 'Bonus for Extra Training - No. certified with Associate Commercial Sales';
        training5.Metric_Description__c = 'Bonus for Extra Training - No. certified with Associate Commercial Sales';
        training5.Category__c = 'Training';
        training5.Metric_Min_Value__c = 1;
        training5.Benefit_Tier__c = true;
        training5.isRSMView__c = true;
        training5.Metric_Input_Type__c = 'Automated';
        listMetrics.add(training5);
        
        Metric_Tier_Relation__c training6 = new Metric_Tier_Relation__c(Performance_Metric__c = perfMetric.Id);
        training6.Metric_Label__c = 'Bonus for Extra Training - No. certified with Associate Commercial Design';
        training6.Metric_Description__c = 'Bonus for Extra Training - No. certified with Associate Commercial Design';
        training6.Category__c = 'Training';
        training6.Metric_Min_Value__c = 1;
        training6.Benefit_Tier__c = true;
        training6.isRSMView__c = true;
        training6.Metric_Input_Type__c = 'Automated';
        listMetrics.add(training6);
        
        Metric_Tier_Relation__c training7 = new Metric_Tier_Relation__c(Performance_Metric__c = perfMetric.Id);
        training7.Metric_Label__c = 'Bonus for Extra Training - No. certified with Associate Commercial Install';
        training7.Metric_Description__c = 'Bonus for Extra Training - No. certified with Associate Commercial Install';
        training7.Category__c = 'Training';
        training7.Metric_Min_Value__c = 1;
        training7.Benefit_Tier__c = true;
        training7.isRSMView__c = true;
        training7.Metric_Input_Type__c = 'Automated';
        listMetrics.add(training7);
        
        Metric_Tier_Relation__c pbp1 = new Metric_Tier_Relation__c(Performance_Metric__c = perfMetric.Id);
        pbp1.Metric_Label__c = 'Must be an Active Dealer (50 kW or 2 Systems Installed)';
        pbp1.Metric_Description__c = 'Must be an Active Dealer (50 kW or 2 Systems Installed)';
        pbp1.Category__c = 'Performance to Business Plan';
        pbp1.Boolean_Metric_Y_N__c = true;
        pbp1.Stay_Tier__c = true;
        pbp1.Metric_Input_Type__c = 'Automated';
        listMetrics.add(pbp1);
        
        Metric_Tier_Relation__c pbp2 = new Metric_Tier_Relation__c(Performance_Metric__c = perfMetric.Id);
        pbp2.Metric_Label__c = 'Credit Limit Maintained';
        pbp2.Metric_Description__c = 'Credit Limit Maintained';
        pbp2.Category__c = 'Performance to Business Plan';
        pbp2.Boolean_Metric_Y_N__c = true;
        pbp2.Stay_Tier__c = true;
        pbp2.Metric_Input_Type__c = 'Automated';
        listMetrics.add(pbp2);
        
        Metric_Tier_Relation__c pbp3 = new Metric_Tier_Relation__c(Performance_Metric__c = perfMetric.Id);
        pbp3.Metric_Label__c = 'Dealer Bonuses for meeting Business Objectives';
        pbp3.Metric_Description__c = 'Dealer Bonuses for meeting Business Objectives';
        pbp3.Category__c = 'Performance to Business Plan';
        pbp3.Boolean_Metric_Y_N__c = true;
        pbp3.Benefit_Tier__c = true;    
        pbp3.Incentive_Amount__c = 0.5;
        pbp3.Part_Of_Composite_Incentive__c = true;
        pbp3.Metric_Input_Type__c = 'Automated';
        listMetrics.add(pbp3);
        
        Metric_Tier_Relation__c pbp4 = new Metric_Tier_Relation__c(Performance_Metric__c = perfMetric.Id);
        pbp4.Metric_Label__c = 'SunPower Share of Account (PV purchases in kW)';
        pbp4.Metric_Description__c = 'SunPower Share of Account (PV purchases in kW)';
        pbp4.Category__c = 'Performance to Business Plan';
        pbp4.Metric_Min_Value__c = 40;
        pbp4.Incentive_Amount__c = 0.5;
        pbp4.Benefit_Tier__c = true;    
        pbp4.Metric_Input_Type__c = 'Manual';
        listMetrics.add(pbp4);
        
        Metric_Tier_Relation__c pbp5 = new Metric_Tier_Relation__c(Performance_Metric__c = perfMetric.Id);
        pbp5.Metric_Label__c = 'SunPower and Dealer Growth Plan signed and submitted on time';
        pbp5.Metric_Description__c = 'SunPower and Dealer Growth Plan signed and submitted on time';
        pbp5.Category__c = 'Performance to Business Plan';
        pbp5.Boolean_Metric_Y_N__c = true;
        pbp5.Benefit_Tier__c = true;    
        pbp5.Stay_Tier__c = true;
        pbp5.Metric_Input_Type__c = 'Manual';
        pbp5.isRSMView__c = true;
        listMetrics.add(pbp5);
        
        Metric_Tier_Relation__c pbp6 = new Metric_Tier_Relation__c(Performance_Metric__c = perfMetric.Id);
        pbp6.Metric_Label__c = 'RSM Objective3';
        pbp6.Metric_Description__c = 'RSM Objective3';
        pbp6.Category__c = 'Performance to Business Plan';
        pbp6.Metric_Min_Value__c = 10;
        pbp6.Benefit_Tier__c = true;    
        pbp6.Metric_Input_Type__c = 'Manual';
        pbp6.isRSMView__c = true;
        listMetrics.add(pbp6);
        
        Metric_Tier_Relation__c pbp7 = new Metric_Tier_Relation__c(Performance_Metric__c = perfMetric.Id);
        pbp7.Metric_Label__c = 'RSM Objective2';
        pbp7.Metric_Description__c = 'RSM Objective2';
        pbp7.Category__c = 'Performance to Business Plan';
        pbp7.Metric_Min_Value__c = 10;
        pbp7.Benefit_Tier__c = true;    
        pbp7.Metric_Input_Type__c = 'Manual';
        pbp7.isRSMView__c = true;
        listMetrics.add(pbp7);
        
        Metric_Tier_Relation__c pbp8 = new Metric_Tier_Relation__c(Performance_Metric__c = perfMetric.Id);
        pbp8.Metric_Label__c = 'RSM Objective1';
        pbp8.Metric_Description__c = 'RSM Objective1';
        pbp8.Category__c = 'Performance to Business Plan';
        pbp8.Metric_Min_Value__c = 10;
        pbp8.Benefit_Tier__c = true;    
        pbp8.Metric_Input_Type__c = 'Manual';
        pbp8.isRSMView__c = true;
        listMetrics.add(pbp8);
        
        insert listMetrics;
  }
  
     //Create Partner Portal user
     public static User getEUPartnerPortalUser(Account acct){
        User user = null;   
        
        if(acct == null){
            acct =  getPartnerAccount();
        }   
        Contact cont = new Contact(AccountID = acct.id,FirstName='testconbyPO2',LastName='testconbyPO2');
        cont.Email ='teeee1@test.com';
        cont.Authorized_to_Order__c = true;
        cont.RecordTypeID =  util.GetRecordTypeIdsByDeveloperName(Contact.SObjectType).get('Partner'); //MAM 19.MAY.2015 Get Contact Partner RecordTypeId
        insert cont;        
        String username ='testPartnerUser@test1.com';      
        user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
        user.ContactId = cont.Id;
        user.Username = username;
        user.Alias = 'testPU';
        user.Plateau_Id__c = 'testUserID';
        user.CommunityNickname = username.subString(0,7);
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US'; 
        user.Email = cont.Email;
        user.LocaleSidKey = 'en_US';    
        user.Edit_Partner_Users__c = true;
        List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Delegated Administrator'];
        if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            insert user;
        }
        if(user.Id != null)
          for(User u:[select id,Name,contactId,Contact.AccountID, Contact.Account.AccountNumber,Contact.Account.CurrencyIsoCode,Contact.Account.Name,Contact.Account.Country_Domain__c,Contact.Account.Theater__c,Contact.Account.ShippingStreet,Contact.Account.ShippingState,Contact.Account.ShippingCity,Contact.Account.ShippingCountry,Contact.Account.ShippingPostalCode,Contact.Account.Oracle_Operating_Unit__c, Contact.Account.Oracle_Account_Number__c from User where id =:user.ID LIMIT 1])
            user = u; 
        return user;
    }
}