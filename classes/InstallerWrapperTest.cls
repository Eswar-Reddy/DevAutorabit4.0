@isTest //removed (SeeAllData = true) as it is not necessary
class InstallerWrapperTest{
    static testMethod void testInstallerWrapper()
    {
        //List<Account> acct = [select id, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode from account where BillingStreet != null and  BillingCity != null and BillingState != null and  BillingCountry != null and BillingPostalCode!= null limit 1];
        
        //created a test account for the purpose of testing the InstallerWrapper 
        Account acct = new Account(Name='Test',
                                   BillingStreet='4632 Danvers Ln',
                                   BillingCity='Granite Bay',
                                   BillingState='CA',
                                   BillingCountry='United States',
                                   BillingPostalCode='95746');
        InstallerWrapper instWrapper;
        
        Test.startTest();
        insert acct;                           
        instWrapper = new InstallerWrapper (acct,true);
        Test.stopTest();
        
        System.assertNotEquals(instWrapper.propBillingAddress,null);
    }
}