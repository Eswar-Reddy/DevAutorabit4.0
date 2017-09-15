@IsTest
private class EmailOpportunityHandlerTests {
        
    static testMethod void testFivePercentageDownPayment(){
        Messaging.InboundEmail email  = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
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
        System.assertNotEquals(null, accAccount.Id);
        
        Account accAccount1 = new Account(Name = 'BiggSun1 PartnerAccount',
            Phone = '+919411111111',            
            BillingStreet = '8516 Hedges Pl', 
            BillingCity = 'Los Angeles',
            BillingState = 'CA', 
            BillingPostalCode = '90068', 
            BillingCountry = 'United States', 
            Type = 'Elite-Partner-Residential', 
            Theater__c = 'North America',
            Chatter_Group_Name__c = 'Sample CG1',
            Status__c = 'Active',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId(),
            Website = 'http://www.biggsun.com');
        insert accAccount1;   
        System.assertNotEquals(null, accAccount1.Id);
        
        Contact conContact = new Contact(AccountId = accAccount.Id,
            LastName = 'Sherpas1',
            FirstName = 'Cloud',
            Email = 'cs1@test.com');
        insert conContact;
        System.assertNotEquals(null, conContact.Id);        
        
        Partner p1 = new Partner(IsPrimary = true, AccountFromId = accAccount.Id, 
            AccountToId = accAccount1.Id);
        insert p1;
        System.assertNotEquals(null, p1.Id); 
        
        Test.startTest();
        
        RecordType rType = [SELECT Id, Name FROM RecordType WHERE SObjectType = 'Opportunity' and Name = 'Home Owner'];
        Opportunity opp = new Opportunity();
        opp.Name = 'Test BiggSunOpp';
        opp.AccountId = accAccount.Id;
        opp.Primary_Contact__c = conContact.Id;
        opp.StageName = 'New Opportunity';
        opp.Dealer_Selection__c = accAccount1.Id;
        opp.CloseDate = Date.today();
        opp.RecordTypeId =  rType.Id;
        opp.Partner_Account_Id__c = accAccount1.Id;
        insert opp;
        

        email.plainTextBody ='This should become a note';
        email.fromAddress ='test@test.com';
        String contactEmail = 'jsmith@salesforce.com';
        email.ccAddresses = new String[] {'Jon Smith <' + contactEmail + '>'};
        email.subject = 'test'+opp.id;
        
        FivePercentageDownPayment edr = new FivePercentageDownPayment();
        
        
        Messaging.InboundEmailResult result = edr.handleInboundEmail(email, env);
        Test.stopTest();
     }
     static testMethod void testCVAROrderAcknowledgementEmailService(){
        Messaging.InboundEmail email  = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
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
        System.assertNotEquals(null, accAccount.Id);
        
        Account accAccount1 = new Account(Name = 'BiggSun1 PartnerAccount',
            Phone = '+919411111111',            
            BillingStreet = '8516 Hedges Pl', 
            BillingCity = 'Los Angeles',
            BillingState = 'CA', 
            BillingPostalCode = '90068', 
            BillingCountry = 'United States', 
            Type = 'Elite-Partner-Residential', 
            Theater__c = 'North America',
            Chatter_Group_Name__c = 'Sample CG1',
            Status__c = 'Active',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId(),
            Website = 'http://www.biggsun.com');
        insert accAccount1;   
        System.assertNotEquals(null, accAccount1.Id);
        
        Contact conContact = new Contact(AccountId = accAccount.Id,
            LastName = 'Sherpas1',
            FirstName = 'Cloud',
            Email = 'cs1@test.com');
        insert conContact;
        System.assertNotEquals(null, conContact.Id);        
        
        Partner p1 = new Partner(IsPrimary = true, AccountFromId = accAccount.Id, 
            AccountToId = accAccount1.Id);
        insert p1;
        System.assertNotEquals(null, p1.Id); 
        
        Test.startTest();
        
        RecordType rType = [SELECT Id, Name FROM RecordType WHERE SObjectType = 'Opportunity' and Name = 'Home Owner'];
        Opportunity opp = new Opportunity();
        opp.Name = 'Test BiggSunOpp';
        opp.AccountId = accAccount.Id;
        opp.Primary_Contact__c = conContact.Id;
        opp.StageName = 'New Opportunity';
        opp.Dealer_Selection__c = accAccount1.Id;
        opp.CloseDate = Date.today();
        opp.RecordTypeId =  rType.Id;
        opp.Partner_Account_Id__c = accAccount1.Id;
        insert opp;
        

        email.plainTextBody ='This should become a note';
        email.fromAddress ='test@test.com';
        String contactEmail = 'jsmith@salesforce.com';
        email.ccAddresses = new String[] {'Jon Smith <' + contactEmail + '>'};
        email.subject = 'test'+opp.id;
        
        CVAROrderAcknowledgementEmailService edr = new CVAROrderAcknowledgementEmailService();
        
        
        Messaging.InboundEmailResult result = edr.handleInboundEmail(email, env);
        Test.stopTest();
     }   
        
     
}