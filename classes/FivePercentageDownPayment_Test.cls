/**************************************************
**Created By- Elimar Licos
**Created On- November 15, 2016
**Last Modified- 
**Last Modified On- 
**Desciption- Test class for FivePercentageDownPayment
*****************************************************/
@isTest
public class FivePercentageDownPayment_Test {
    @isTest
    public static void Test_handleInboundEmail(){
        
        Account acct = new Account();       
        acct.Name = 'Test Account FivePercent DP';
        acct.Type = 'Residential Customer';
        acct.RSM_Discretionary_Adj__c = 5;
        acct.BillingCity = 'DeSoto';
        acct.BillingStreet = 'Main Street';
        acct.BillingState = 'AZ';
        acct.BillingCountry = 'United States';
        acct.BillingPostalCode = '751234';
        acct.Opp_Convert_Rate__c = 70;
        acct.Theater__c='North America';
        
        Account acct1 = new Account();
        acct1.Name = 'Test123456888999';
        acct1.Type = 'Elite-Partner-Residential';
        acct1.RSM_Discretionary_Adj__c = 5;
        acct1.BillingCity = 'DeSoto';
        acct1.BillingStreet = 'Main Street';
        acct1.BillingState = 'AZ';
        acct1.BillingCountry = 'United States';
        acct1.BillingPostalCode = '751234';
        acct1.Opp_Convert_Rate__c = 70;
        acct1.Theater__c='North America';
        User objUserPSR = [Select Id,Contact.Account.Theater__c,Contact.Account.Territory__c from User where UserRoleId = '00E800000010ZTJ' AND isActive=true limit 1];
        acct1.Commercial_PSR__c = objUserPSR.Id;
                
        list<Account> listAccount = new list<Account>();        
		listAccount.add(acct1);
        listAccount.add(acct);
        insert listAccount;
                
        Contact objContact= new Contact();
		objContact.Phone='123-456-12345';
		objContact.lastName ='test contact FivePercent DP';
		objContact.Email='ss@sunpowercorp.com';
		objContact.MailingCity = 'Irving';
		objContact.MailingStreet = 'Main Street';
		objContact.MailingState = 'TX';
		objContact.MailingCountry = 'United States';
		objContact.MailingPostalCode = '75038';
		objContact.AccountId = acct.Id;
		objContact.primary__c = true;   
                
        Contact objContact1= new Contact();
		objContact1.Phone='123-664-12345';
		objContact1.lastName ='test finance mgr FivePercent DP';
		objContact1.Email='sss@sunpowercorp.com';
		objContact1.MailingCity = 'Irving';
		objContact1.MailingStreet = 'Main Street';
		objContact1.MailingState = 'TX';
		objContact1.MailingCountry = 'United States';
		objContact1.MailingPostalCode = '75038';
		objContact1.AccountId = acct1.Id;
		objContact1.primary__c = true;

        List<Contact> contactList = new List<Contact>();  
        contactList.add(objContact);
        contactList.add(objContact1);
        insert contactList;
        
        Opportunity oppObj = new Opportunity();
        oppObj.Name = 'Test Opportunity FivePercent DP';
        oppObj.StageName = '25% - Site Audit Completed';
        oppObj.CloseDate = Date.today();
        oppObj.Lead_Manufacturer__c ='SunPower';
        oppObj.Is_Excluded_From_SLA_Score__c = true;
        oppObj.Partner_Account_Id__c =acct1.id;
        oppObj.AccountId =acct.id;
        oppObj.Amount=300;
        oppObj.RecordTypeId = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('Home Owner').RecordTypeId; 
        User objUser = [Select Id,Contact.Account.Theater__c,Contact.Account.Territory__c from User where Profile.id ='00e80000001SqIlAAK' AND isActive=true limit 1];
        oppObj.OwnerId = objUser.id;
        oppObj.Primary_Contact__c = objContact.id;
        oppObj.Customer_Satisfaction_Survey_opt_in__c = true;
        oppObj.CRSM__c = objUserPSR.Id;
        oppObj.Down_Payment_Invoice_Number__c = '12345';
        insert oppObj;
        
        system.debug('----------Test Opportunity '+oppObj);
        
		AccountContactRole acctContRole = new AccountContactRole();
        acctContRole.ContactId = objContact1.Id;
        acctContRole.AccountId = oppObj.Partner_Account_Id__c;
		acctContRole.Role ='Finance Manager';
        insert acctContRole;       
        
        system.debug('----------Test AccountContactRole '+acctContRole);
        
        Attachment att = new Attachment();
        att.ParentId = oppObj.Id;
        att.Name = 'Down Payment Invoice_#'+ oppObj.Down_Payment_Invoice_Number__c +'_' + oppObj.Name;
        String algorithmName = 'HMacSHA1';
        Blob b = Crypto.generateMac(algorithmName, Blob.valueOf('test'), Blob.valueOf('test_key'));        
        att.Body = b;
        insert att;
        
    	// Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();

        email.subject = oppObj.Id;
        email.fromName = 'Tester';
        email.plainTextBody = 'Hello, this a test email body. for testing purposes only.';
        envelope.fromAddress = 'ss@sunpowercorp.com';
            
        // setup controller object
        FivePercentageDownPayment f = new FivePercentageDownPayment();
        Messaging.InboundEmailResult result = f.handleInboundEmail(email, envelope);
        System.assertEquals( result.success  ,true);
    }
}