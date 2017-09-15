@isTest(SeeAllData=false)
public class TrgTPSSFDocument_Test {
    static testMethod void BeforeAgreementDeleteTest(){
        SFDCSpecialUtilities.isRunningTest = True;
        TestClassFactory.createAndInsertLeaseAgreementSettings(); 
        
        Account newAccount = TestUtils.createAccount('IAMTEST', TestUtils.getPartnerRecordTypeId(), false);
        newAccount.Oracle_Account_Number__c = 'IAMTEST-12345';
        insert newAccount;
        
        Contact newContact = TestUtils.createContact('IAMALSOTEST', newAccount.Id, false);
        newContact.Email ='myname@test.com';
        insert newContact;
        
        UserManagement.IS_TEST = true;
        User newUser = testUtils.createPartnerPortalUser(newContact, false);
        newUser.Username = 'IAMTESTUSER@test.com';
        newUser.CommunityNickname = 'IAMTESTUSER';
        insert newUser;
        
        Opportunity newOpp = createOpp(newAccount, newUser);
        newOpp.Name = 'TESTOPP';
        insert newOpp;
        
        echosign_dev1__SIGN_Agreement__c agreement = new echosign_dev1__SIGN_Agreement__c();
     	agreement.name = 'Test Lease Document';
     	agreement.echosign_dev1__Status__c = 'Draft';
        //agreement.Status__c = 'Waiting for Counter-Signature';
     	agreement.opportunity__c = newOpp.id;
        
        insert agreement; 
        
        TPSSF__Document__c documnet = new TPSSF__Document__c();
        documnet.TPSSF__Object_Name__c ='Opportunity';
        documnet.Opportunity__c = newOpp.Id;
        documnet.TPSSF__Document_Category__c ='DOCUMENT_CATEGORY_CREDIT_DOCUMENTS';
        documnet.TPSSF__Document_Type__c  ='DOCUMENT_TYPE_ARRAY_LAYOUT';
        documnet.Document_Type__c = 'Array Layout';
        documnet.Name ='Test';
        insert documnet;
        
    }
    private static Opportunity createOpp(Account acct,User u){   
            Opportunity opp = new Opportunity();      
            opp.AccountId = acct.ID;
            opp.Name = 'TestNACommOpp1';
            opp.ownerId = u.Id;
            opp.CloseDate = System.today();
            opp.Reason_Won_Lost__c = 'Best Economics';
            opp.StageName = '12% Qualified Opportunity';
            opp.System_Size_KwP__c = 100;
            opp.Location_of_Installation__c = 'Metal Roof';
            opp.Mounting_System__c = 'PV Only';
            opp.ARRA_Compliance__c = 'Non ARRA';
                         
            return opp;
        }
}