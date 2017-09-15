/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SeeAlldata=false)
private class TestAgreementRecordSharingnew {
    
    private static String testCompanyID = '88558855';
    
    static testMethod void SahringTestSenario1() {

        TestClassFactory.createAndInsertLeaseAgreementSettings();
        user portalAcctOwnerUser;
        
        User currentUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( currentUser ) {
            
            //Create portal account owner
            UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
            Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
            portalAcctOwnerUser = new User(
                UserRoleId = portalRole.Id,
                ProfileId = profile1.Id,
                Username = String.valueOf(Math.random()) + 'spwrtest1@noemail.123',
                Alias = 'batman',
                Email='bruce.wayne@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago',
                Case_Number__c = '45621',
                Country='USA',
                division ='IT'
            );
        
        Database.insert(portalAcctOwnerUser);
        
        }
        
        System.RunAs(portalAcctOwnerUser)
        {
            test.startTest();
            
            AgreementApexSharing__c objAgreementShare = new AgreementApexSharing__c();
            objAgreementShare.RoleName__c = 'Partner Executive';
            objAgreementShare.name = 'AgreementApexSharing';
            insert objAgreementShare;
            
            // Create Partner Account
            Account testPartnerAccount = createPartnerAccount();
            insert testPartnerAccount;
            
            //Create Home Owner Account
            Account testHomeOwnerAccount = createHomeOwnerAccount(testPartnerAccount.Id);
            insert testHomeOwnerAccount;
        
            echosign_dev1__SIGN_Agreement__c objAgreement = new echosign_dev1__SIGN_Agreement__c();
            objAgreement.Account__c = testHomeOwnerAccount.Id;
            objAgreement.Agreement_Name__c = 'Test Agreement';
            // objAgreement.Status__c = 'Draf';
            insert objAgreement;
            test.stopTest();
        }
    }
    
    public static Account createPartnerAccount(){
        Account testPartnerAccount = TestClassFactory.testAccount('TestPotalUserAccount', TestClassFactory.retrieveRecordTypeID('Account', 'Partner'));
        testPartnerAccount.PartnerAccessID__c = testCompanyID;
        return testPartnerAccount;
    }
    
    public static Account createHomeOwnerAccount(ID partnerAccountId){
        Account testPartnerAccount = TestClassFactory.testAccount('TestPotalTestUserAccount', TestClassFactory.retrieveRecordTypeID('Account', 'Residential Customer'));
        testPartnerAccount.PartnerAccessID__c = testCompanyID;
        testPartnerAccount.Partner_Account__c = partnerAccountId;
        return testPartnerAccount;
    }
    
    public static UserRole createUsesrRole(Account Acc){
        UserRole objRole = new UserRole();
        objRole.Name = Acc.Name;
        insert objRole;
        
        return objRole;
    }
    
    /*public static Group createGroup(UserRole Role){
        Group objGroup = new Group();
        objGroup.Type = 'Role';
        objGroup.RelatedId = Role.Id;
        insert objGroup;
    }*/
}