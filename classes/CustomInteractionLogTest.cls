@isTest
private class CustomInteractionLogTest {

     // Methods for testing
   @isTest 
    static void test1() {
      List<Case> lstc = new List<Case>();
        Case c = new Case();
        c.Initial_Response_Timestamp__c = Datetime.newInstance(2012, 10, 1, 1, 50, 0);
        c.Date_Assigned_to_Birlasoft__c = Datetime.newInstance(2012, 10, 18, 22, 10, 0);
        c.Initial_Response_Time_for_Birlasoft__c = String.ValueOf(c.Initial_Response_Timestamp__c.GetTime() - c.Date_Assigned_to_Birlasoft__c.GetTime());
        lstc.add(c);
        Insert lstc;
        /*
        Account accAccount = new Account(Name = 'BiggSun1 SolarCsTest1',
            Phone = '+919411111111',            
            BillingStreet = '77 Rio Roble', 
            BillingCity = 'San Jose',
            BillingState = 'CA', 
            BillingPostalCode = '95134', 
            BillingCountry = 'United States', 
            Type = 'Elite-Partner-Residential', 
            Theater__c = 'North America',            
            Status__c = 'Active',
            Website = 'http://www.biggsun.com',
            Chatter_Group_Name__c = 'Sample CG1');
        insert accAccount;
        
         Contact conContact = new Contact(AccountId = accAccount.Id,
            LastName = 'Sherpas1',
            FirstName = 'Cloud',
            Email = 'cs1@test.com');
        insert conContact;*/
        
        Task ts  = new Task();
        ts.status = 'Not Started';
        ts.subject = 'Test';
        ts.WhatId = c.Id;
        ts.description = 'Test Description';
        //task.whoId = conContact.id;
        insert ts;
        
        ApexPages.Standardcontroller stdCtrl = new ApexPages.Standardcontroller( new Case() );
        CustomInteractionLog cls = new CustomInteractionLog(stdCtrl);
        cls.newCase = false;
        cls.task = ts;
        cls.save();
        cls.saveAndNew();
        cls.setCallAttachedData();
   }

    
}