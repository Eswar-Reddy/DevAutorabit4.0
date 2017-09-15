/********************************************************************************************
Name   : TestAccountNewController 
Author : Anjali Jain
Date   : Oct 17, 2011
Usage  : Test class for AccountNewController.
********************************************************************************************/

@isTest
public class TestAccountNewController {
    static Account partnerAccount;
    static Contact partnerContact;
    static Contact partnerContact2;
    static Contact partnerContact3;
    static User partnerUser;
    static User partnerUser2;
    static User partnerUser3;
    
    static String Country = 'United States'; 
    static String County = 'San Francisco'; 
    static String Address = '123 Madison Ave'; 
    static String City = 'San Francisco'; 
    static String State = 'CA'; 
    static String Zip = '94105'; 
    static {
        UserManagement.IS_TEST = true;
        partnerAccount = TestUtils.createAccount('TEST_ACCOUNT', TestUtils.getPartnerRecordTypeId(), false);
        insert partnerAccount;
        
        partnerContact = TestUtils.createContact( 'TEST_CONTACT', partnerAccount.Id, true );        
        partnerUser = TestUtils.createPartnerPortalUser( partnerContact, false );
        
        partnerContact2 = TestUtils.createContact( 'TEST_CONTACT', partnerAccount.Id, false );
        partnerContact2.Phone ='123-123-1234';
        partnerContact2.firstName='test';
        insert partnerContact2;
        
        partnerUser2 = TestUtils.createPartnerPortalUser( partnerContact2, false );
        
        partnerUser2.Country_Domain__c ='rvar-au';
        partnerUser2.username ='testconbyPO5@worlds.comp';
        partnerUser2.Alias ='test12';
        partnerUser2.CommunityNickname = partnerUser2.username.subString(0,6);
        insert partnerUser2;
        
        partnerContact3 = TestUtils.createContact( 'TEST_CONTACT', partnerAccount.Id, false );
        partnerContact3.Phone ='323-123-1234';
        partnerContact3.firstName='test3';
        insert partnerContact3;
        
        partnerUser3 = TestUtils.createPartnerPortalUser( partnerContact3, false );
        
        partnerUser3.Country_Domain__c = System.Label.COUNTRYDOMAIN_FR;
        partnerUser3.username ='testpartner3@worlds.comp';
        partnerUser3.Alias ='test13';
        partnerUser3.CommunityNickname = partnerUser3.username.subString(0,6);
        insert partnerUser3;
    }
    
    @isTest
    public static void Test_AccountNewController(){
        // TO DO: implement unit test
        Id residentialCustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Residential Customer').getRecordTypeId();
        Id commercialCustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Commercial Customer').getRecordTypeId();
        Account newAccount = TestUtils.createAccount('NewAcct', residentialCustomerRecordTypeId, false);
        newAccount.BillingStreet = Address;
        newAccount.BillingCity = City;
        newAccount.BillingState = State;
        newAccount.BillingPostalCode = Zip;
        newAccount.BillingCountry = Country;
        newAccount.Oracle_County__c = County;
        
        ApexPages.StandardController control1 = new ApexPages.StandardController(newAccount);
        Test.startTest();
        AccountNewController accNewControl = new AccountNewController(control1);
        accNewControl.newUrl = '/apex/AccountNew?sfdc.override=1';
        accNewControl.redirect();
        System.runAs(partnerUser){
            ApexPages.currentPage().getParameters().put('RecordType',residentialCustomerRecordTypeId);
            accNewControl.redirect();
            ApexPages.currentPage().getParameters().put('RecordType',commercialCustomerRecordTypeId);
            accNewControl.redirect();
        }
         
        Test.stopTest();
    }
     @isTest
    public static void Test_AccountNewController2(){
        // TO DO: implement unit test
        Id residentialCustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Residential Customer').getRecordTypeId();
        Id commercialCustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Commercial Customer').getRecordTypeId();
        Account newAccount = TestUtils.createAccount('NewAcct', residentialCustomerRecordTypeId, false);
        newAccount.BillingStreet = Address;
        newAccount.BillingCity = City;
        newAccount.BillingState = State;
        newAccount.BillingPostalCode = Zip;
        newAccount.BillingCountry = Country;
        newAccount.Oracle_County__c = County;
        
        ApexPages.StandardController control1 = new ApexPages.StandardController(newAccount);
        Test.startTest();
        System.runAs(partnerUser2){
            AccountNewController accNewControl = new AccountNewController(control1);
            accNewControl.newUrl = '/apex/AccountNew?sfdc.override=1';
            ApexPages.currentPage().getParameters().put('RecordType',residentialCustomerRecordTypeId);
            accNewControl.redirect();
            ApexPages.currentPage().getParameters().put('RecordType',commercialCustomerRecordTypeId);
            accNewControl.redirect();
        }
         
        Test.stopTest();
    }
    
    @isTest
    public static void Test_AccountNewController3(){
        // TO DO: implement unit test
        Id residentialCustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Residential Customer').getRecordTypeId();
        Id commercialCustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Commercial Customer').getRecordTypeId();
        Account newAccount = TestUtils.createAccount('NewAcct', residentialCustomerRecordTypeId, false);
        newAccount.BillingStreet = Address;
        newAccount.BillingCity = City;
        newAccount.BillingState = State;
        newAccount.BillingPostalCode = Zip;
        newAccount.BillingCountry = Country;
        newAccount.Oracle_County__c = County;
        
        ApexPages.StandardController control1 = new ApexPages.StandardController(newAccount);
        Test.startTest();
        System.runAs(partnerUser3){
            AccountNewController accNewControl = new AccountNewController(control1);
            accNewControl.newUrl = '/apex/AccountNew?sfdc.override=1';
            ApexPages.currentPage().getParameters().put('RecordType',residentialCustomerRecordTypeId);
            accNewControl.redirect();
            ApexPages.currentPage().getParameters().put('RecordType',commercialCustomerRecordTypeId);
            accNewControl.redirect();
        }
         
        Test.stopTest();
    }
    
    @isTest
    public static void Test_AccountNewController4(){
        // TO DO: implement unit test
        Id residentialCustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Residential Customer').getRecordTypeId();
        Id commercialCustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Commercial Customer').getRecordTypeId();
        Account newAccount = TestUtils.createAccount('NewAcct', residentialCustomerRecordTypeId, false);
        newAccount.BillingStreet = Address;
        newAccount.BillingCity = City;
        newAccount.BillingState = State;
        newAccount.BillingPostalCode = Zip;
        newAccount.BillingCountry = Country;
        newAccount.Oracle_County__c = County;
        
        ApexPages.StandardController control1 = new ApexPages.StandardController(newAccount);
        Test.startTest();
        
            AccountNewController accNewControl = new AccountNewController(control1);
            accNewControl.newUrl = '/apex/AccountNew?sfdc.override=1';
            ApexPages.currentPage().getParameters().put('RecordType',residentialCustomerRecordTypeId);
            accNewControl.redirect();
            ApexPages.currentPage().getParameters().put('RecordType',commercialCustomerRecordTypeId);
            accNewControl.redirect();
        
         
        Test.stopTest();
    }
}