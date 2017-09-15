@isTest(seeAllData = true)
public class TestPortalAgreementProcessing{
 	//Test Method to cover PortalAgreementProcessing Trigger.
    static testMethod void testPortalAgreementProcessing(){
    	Account newAccount;
        newAccount = [Select ID from Account Where Name='Test Class DO NOT TOUCH'];
        
        //create account
        Account acc = new Account();
        acc.Name = 'Test AccountQuote';
        acc.Type ='Home Owner';
        acc.BillingCity = 'Cassis';
        acc.BillingStreet = 'Cassis';
        acc.BillingPostalCode ='13260';
        acc.BillingCountry = 'France'; 
        acc.Country_Domain__c = 'rvar-fr';
        acc.Credit_check_Passed__c = true;
        insert acc;
        
        //create Contact
        Contact con;
        con = TestUtils.createContact( 'testcon', newAccount.id, false);
        con.Phone = '22 33 44 55 66';
        con.Include_in_Lease_Doc__c = true;
        insert con;
        
         //create Contact
        Contact con1;
        con1 = TestUtils.createContact( 'testcon1', newAccount.id, false);
        con1.Phone = '22 33 44 55 66';
        con1.Include_in_Lease_Doc__c = true;
        con1.Primary__c = true;
        insert con1;
    
        List<echosign_dev1__SIGN_Agreement__c> agreelist = new List<echosign_dev1__SIGN_Agreement__c>();
        //Create Agreement
        echosign_dev1__SIGN_Agreement__c newAgreement = new echosign_dev1__SIGN_Agreement__c();
        newAgreement.Account__c = newAccount.id;
        newAgreement.Created_By_Partner_Poratl_User__c = 'Y';
       	newAgreement.Agreement_Name__c = 'Lien Waiver';
        agreelist.add(newAgreement);
        
        echosign_dev1__SIGN_Agreement__c newAgreement1 = new echosign_dev1__SIGN_Agreement__c();
        newAgreement1.Name = 'Termination Doc';
        newAgreement1.Account__c = newAccount.id;
       	newAgreement1.Agreement_Name__c = 'Termination Doc';
        agreelist.add(newAgreement1);
        
        echosign_dev1__SIGN_Agreement__c newAgreement2 = new echosign_dev1__SIGN_Agreement__c();
        newAgreement2.Name = 'Amendment';
        newAgreement2.Account__c = newAccount.id;
       	newAgreement2.Agreement_Name__c = 'Amendment';
        agreelist.add(newAgreement2);
        
        echosign_dev1__SIGN_Agreement__c newAgreement3 = new echosign_dev1__SIGN_Agreement__c();
        newAgreement3.Name = 'FR Lease Document';
        newAgreement3.Account__c = newAccount.id;
       	newAgreement3.Agreement_Name__c = 'Lease Document';
        agreelist.add(newAgreement3);
        
        echosign_dev1__SIGN_Agreement__c newAgreement4 = new echosign_dev1__SIGN_Agreement__c();
        newAgreement4.Name = 'Lease Document';
        newAgreement4.Account__c = acc.id;
       	newAgreement4.Agreement_Name__c = 'Lease Document';
        agreelist.add(newAgreement4);
        
        echosign_dev1__SIGN_Agreement__c newAgreement5 = new echosign_dev1__SIGN_Agreement__c();
        newAgreement5.Name = 'Lease Document';
        newAgreement5.Account__c = newAccount.id;
       	newAgreement5.Agreement_Name__c = 'Lease Document';
        agreelist.add(newAgreement5);
        
        insert agreelist;
	}
}