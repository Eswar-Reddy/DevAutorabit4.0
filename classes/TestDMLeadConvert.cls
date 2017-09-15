public class TestDMLeadConvert
{
    @isTest
    public static void testDMLeadConvert()
    {
        Lead testLead = new Lead();
        testLead.Company = 'Test Company';
        testLead.LeadSource = 'Test Company';
        testLead.Email = 'meeta.gulati@accenture.com';
        testLead.LastName = 'Gulati';
        testLead.Street = 'btm';
        testLead.City = 'Bangalore';
        testLead.PostalCode = '12345';
        testLead.Country = 'India';
        insert testLead;
        Lead objLead = [Select id from Lead where Email = 'meeta.gulati@accenture.com'];
        
        Account testAcc = new Account();
        testAcc.Name = 'TestTempLead Convert';
        testAcc.BillingCity = 'Glendale';
        testAcc.BillingCountry = 'United States of America';
        testAcc.BillingStreet = 'dsfsf';
        testAcc.BillingPostalCode = '85306';
        insert testAcc;        
        Account getAcc= [Select id,name,billingcity from account where name = 'TestTempLead Convert'];
        
   /*Opportunity Oppty = new Opportunity();
        oppty.accountid = getAcc.Id;
        oppty.Name = 'Lead conversion test oppty';
        oppty.StageName = 'Unqualified';
        oppty.CloseDate = System.today();
        insert oppty;
        Opportunity objOppty = [Select id from Opportunity where name = 'Lead conversion test oppty' limit 1];*/
        
        
        Contact ctc = new Contact();
        ctc.LastName = 'Lead Convert';
        ctc.FirstName = 'Test';
        ctc.Accountid = getAcc.Id;
        insert ctc;
        Contact objCtc = [Select id from Contact where Name = 'Test Lead Convert'];
        
        Lead_Conversion__c leadConv = new Lead_Conversion__C();
        leadConv.Account__c = getAcc.Id;
        leadConv.Lead__C = objLead.Id;
        //leadConv.Opportunity__c = objOppty.Id;
        leadConv.Contact__c = objCtc.Id;
        try{
        	insert leadConv;
        }
        catch(Exception ex){        	
        }
        
    }
}