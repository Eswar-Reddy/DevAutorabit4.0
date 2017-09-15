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
@isTest
private class TestFPOOrderLinesExt {
    
    static testMethod void myUnitTestTPS() {
        
        UserRole internalRole = [select Id from UserRole where PortalType = 'None' Limit 1];
        
        UserManagement.IS_TEST = true;
        
        User U = TestUtils.createUser ('System Administrator',false);
        U.UserRoleId = internalRole.Id;
        
        User U2 = TestUtils.createUser ('System Administrator',false);
        U2.UserRoleId = internalRole.Id;
        
        User uPartnerUser;
        
        
        List<Account> lAcc = new List<account>();
        Contact partnerContact;
        List<LeasePayment__c> lleasePayment = new List<LeasePayment__c>();
        List<FPO_Order_Line__c> lFPO = new List<FPO_Order_Line__c>();
        
        System.runAs(U){
            // Create Account
            lAcc = TestUtils.createAccounts(1,false); 
            lAcc[0].NH_SSE_Type__c = 'TPS'; 
            //lAcc[0].IsPartner = true;
            insert lAcc;
            
            partnerContact = TestUtils.createContact( 'Test Contact', lAcc[0].Id, false );
            insert partnerContact;
            
            lleasePayment = TestUtils.createLeasePayments(2,lAcc[0].Id,false) ;
            lleasePayment[0].End_Customer_Account__c = lAcc[0].Id;
            insert lleasePayment;
            
            lFPO = TestUtils.createFPOOrderLines(2,lleasePayment[0].Id,'TPS',false);
            insert lFPO;
            
        }
        
        Test.startTest();
        
        system.runAs(U2){
            uPartnerUser = TestUtils.CreatePartnerPortalUser(partnerContact,false);
        }
        
        System.runAs(uPartnerUser){
            ApexPages.StandardController stdCtrl = new ApexPages.StandardController(lleasePayment[0]);      
            Test.setCurrentPage (Page.FPOOrderLines);
            FPOOrderLinesExt ctrlExt = new FPOOrderLinesExt (stdCtrl); 
        }
        
        Test.StopTest();
        
    }
    
    static testMethod void myUnitTestPermit() {
        
        UserRole internalRole = [select Id from UserRole where PortalType = 'None' Limit 1];
        
        UserManagement.IS_TEST = true;
        
        User U = TestUtils.createUser ('System Administrator',false);
        U.UserRoleId = internalRole.Id;
        
        User U2 = TestUtils.createUser ('System Administrator',false);
        U2.UserRoleId = internalRole.Id;
        
        User uPartnerUser;
        
        
        List<Account> lAcc = new List<account>();
        Contact partnerContact;
        List<LeasePayment__c> lleasePayment = new List<LeasePayment__c>();
        List<FPO_Order_Line__c> lFPO = new List<FPO_Order_Line__c>();
        
        System.runAs(U){
            // Create Account
            lAcc = TestUtils.createAccounts(1,false); 
            lAcc[0].NH_SSE_Type__c = 'Permit'; 
            //lAcc[0].IsPartner = true;
            insert lAcc;
            
            partnerContact = TestUtils.createContact( 'Test Contact', lAcc[0].Id, false );
            insert partnerContact;
            
            lleasePayment = TestUtils.createLeasePayments(2,lAcc[0].Id,false) ;
            lleasePayment[0].End_Customer_Account__c = lAcc[0].Id;
            insert lleasePayment;
            
            lFPO = TestUtils.createFPOOrderLines(2,lleasePayment[0].Id,'TPS',false);
            insert lFPO;
            
        }
        
        Test.startTest();
        
        system.runAs(U2){
            uPartnerUser = TestUtils.CreatePartnerPortalUser(partnerContact,false);
        }
        
        System.runAs(uPartnerUser){
            ApexPages.StandardController stdCtrl = new ApexPages.StandardController(lleasePayment[0]);      
            Test.setCurrentPage (Page.FPOOrderLines);
            FPOOrderLinesExt ctrlExt = new FPOOrderLinesExt (stdCtrl); 
        }
        
        Test.StopTest();
        
    }
    
    static testMethod void myUnitTestInstall() {
        
        UserRole internalRole = [select Id from UserRole where PortalType = 'None' Limit 1];
        
        UserManagement.IS_TEST = true;
        
        User U = TestUtils.createUser ('System Administrator',false);
        U.UserRoleId = internalRole.Id;
        
        User U2 = TestUtils.createUser ('System Administrator',false);
        U2.UserRoleId = internalRole.Id;
        
        User uPartnerUser;
        
        
        List<Account> lAcc = new List<account>();
        Contact partnerContact;
        List<LeasePayment__c> lleasePayment = new List<LeasePayment__c>();
        List<FPO_Order_Line__c> lFPO = new List<FPO_Order_Line__c>();
        
        System.runAs(U){
            // Create Account
            lAcc = TestUtils.createAccounts(1,false); 
            lAcc[0].NH_SSE_Type__c = 'Install'; 
            //lAcc[0].IsPartner = true;
            insert lAcc;
            
            partnerContact = TestUtils.createContact( 'Test Contact', lAcc[0].Id, false );
            insert partnerContact;
            
            lleasePayment = TestUtils.createLeasePayments(2,lAcc[0].Id,false) ;
            lleasePayment[0].End_Customer_Account__c = lAcc[0].Id;
            insert lleasePayment;
            
            lFPO = TestUtils.createFPOOrderLines(2,lleasePayment[0].Id,'TPS',false);
            insert lFPO;
            
        }
        
        Test.startTest();
        
        system.runAs(U2){
            uPartnerUser = TestUtils.CreatePartnerPortalUser(partnerContact,false);
        }
        
        System.runAs(uPartnerUser){
            ApexPages.StandardController stdCtrl = new ApexPages.StandardController(lleasePayment[0]);      
            Test.setCurrentPage (Page.FPOOrderLines);
            FPOOrderLinesExt ctrlExt = new FPOOrderLinesExt (stdCtrl); 
        }
        
        Test.StopTest();
        
    }
    
}