//SeeAllData=true just for testing
@isTest
public class TestCreditCheckPageCtrl {
    
    public static Account customerAccount;
    public static Contact customerContact;
    public static creditCheckPageCtrl ccpCtrl;
    public static Loan_Callout_Settings__c lcs;
    public static MosaicJSONUtil.Opportunity opp;
    public static Opportunity customerOpportunity;
    public static Contact con;
    public static MosaicJSONUtil.Address addr;
    
    static{
        CustomerAccount = TestUtils.createAccount( 'CustomerAcct', TestUtils.getResidentialRecordTypeId(), false );
        CustomerAccount.BillingState = 'CA';
        CustomerAccount.BillingCountry= 'United States';
        insert CustomerAccount;
        
        customerContact = TestUtils.createContact('CustomerContact', CustomerAccount.Id, false);
        customerContact.Primary__c = true;
        insert customerContact;
        
        customerOpportunity = TestUtils.createOpportunities(1, customerAccount.id, customerContact.Id, true).get(0);
        
        lcs = new Loan_Callout_Settings__c(Name='Mosaic',SalesRepEmail__c = 'test@mosaic.com', Endpoint_URL__c ='http://www.mosaic.com',Client_ID__c='clientID',Client_Secret__c='clientSecret',Grant_Type__c='grantType');
        insert lcs;
        
        con = [select Id,FirstName,LastName,MailingStreet,MailingCity,MailingState,MailingPostalCode,Phone,Email,AccountId from Contact where Id=:customerContact.Id];
        addr = new MosaicJSONUtil.Address(con.MailingStreet,'',con.MailingCity,con.MailingState,con.MailingPostalCode);
        opp = new MosaicJSONUtil.Opportunity(con.FirstName,con.LastName,con.Phone.replaceAll('\\D',''),con.Email,addr,con.Email,null);
        
    }
    
    public static testMethod void testcreditCheckPageCtrl1(){
          
        opp.Id = 1234;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(customerContact);
        Test.setCurrentPageReference(Page.CreditCheckPage);
        ccpCtrl = new creditCheckPageCtrl(sc);
        Test.startTest();
        
        TestMosaicHttpCalloutMock fakeGetAccessTokenResp = new TestMosaicHttpCalloutMock(200,
                                                         'Complete',
                                                         'dgflk34nefkerk',
                                                         null);
        
        String JSONString = JSON.serialize(opp);
        TestMosaicHttpCalloutMock fakeCreateOpptyResp = new TestMosaicHttpCalloutMock(200,
                                                         'Complete',
                                                         JSONString,
                                                         null);

        TestMosaicHttpCalloutMock fakeSendCreditAppResp = new TestMosaicHttpCalloutMock(200,
                                                  'Complete',
                                                  '[{"LastName": "Test Last Name"}]',
                                                   null);

        Map<String, HttpCalloutMock> endpoint2TestResp =
                                   new Map<String,HttpCalloutMock>();
        
        
        String endpointURL = lcs.Endpoint_URL__c+'/api/v1/access-token?client_id='+lcs.Client_ID__c+'&client_secret='+lcs.Client_Secret__c+'&grant_type='+lcs.Grant_Type__c;
        System.debug('requestEndpoint----->'+endpointURL);
        endpoint2TestResp.put(endpointURL, fakeGetAccessTokenResp);
        
        endpointURL = lcs.Endpoint_URL__c+'/api/v1/opportunities';
        endpoint2TestResp.put(endpointURL,fakeCreateOpptyResp);
        
        endpointURL = lcs.Endpoint_URL__c+'/api/v1/opportunities/'+opp.Id+'/send-credit-application';
        System.debug('requestEndpoint----->'+endpointURL);
        endpoint2TestResp.put(endpointURL,fakeSendCreditAppResp);

        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        for(creditCheckPageCtrl.CreditCheckRow ccr:ccpCtrl.CreditCheckRows){
            ccr.selected=true;
        }
        List<creditCheckPageCtrl.CreditCheckRow> ccRows = new List<creditCheckPageCtrl.CreditCheckRow>();
        ccRows = ccpCtrl.CreditCheckRows;
        System.debug('----->'+ccRows);
        ccpCtrl.submitCreditCheck();
        
        
        Test.stopTest();
    }

    public static testMethod void testcreditCheckPageCtrl2(){
        
        opp.Id = 1234;

        
        List<Credit_Check_Request__c> ccrInsertList = new List<Credit_Check_Request__c>();
        
        ccrInsertList.add(new Credit_Check_Request__c(Account__c = con.AccountId, Application_Type__c = 'LOAN', Application_Id__c = String.valueOf(opp.Id), Contact__c = con.Id, Credit_Beureu__c ='Mosaic', First_Name__c = con.FirstName, Last_Name__c = con.LastName, Status__c ='Submitted',Email__c=con.Email, Credit_Check_Submission_Date__c = Date.today()));
        ccrInsertList.add(new Credit_Check_Request__c(Account__c = con.AccountId, Application_Type__c = 'LEASE', Contact__c = con.Id, Credit_Beureu__c ='LoanPath', First_Name__c = con.FirstName, Last_Name__c = con.LastName, Status__c ='Submitted',Email__c=con.Email, Credit_Check_Submission_Date__c =Date.today()));
        
        insert ccrInsertList;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(customerContact);
        Test.setCurrentPageReference(Page.CreditCheckPage);
        ccpCtrl = new creditCheckPageCtrl(sc);
        Test.startTest();
        
        TestMosaicHttpCalloutMock fakeGetAccessTokenResp = new TestMosaicHttpCalloutMock(200,
                                                         'Complete',
                                                         'dgflk34nefkerk',
                                                         null);
        
        String JSONString = JSON.serialize(opp);
        TestMosaicHttpCalloutMock fakeCreateOpptyResp = new TestMosaicHttpCalloutMock(200,
                                                         'Complete',
                                                         JSONString,
                                                         null);

        TestMosaicHttpCalloutMock fakeSendCreditAppResp = new TestMosaicHttpCalloutMock(200,
                                                  'Complete',
                                                  '[{"LastName": "Test Last Name"}]',
                                                   null);

        Map<String, HttpCalloutMock> endpoint2TestResp =
                                   new Map<String,HttpCalloutMock>();
        
        
        String endpointURL = lcs.Endpoint_URL__c+'/api/v1/access-token?client_id='+lcs.Client_ID__c+'&client_secret='+lcs.Client_Secret__c+'&grant_type='+lcs.Grant_Type__c;
        System.debug('requestEndpoint----->'+endpointURL);
        endpoint2TestResp.put(endpointURL, fakeGetAccessTokenResp);
        
        endpointURL = lcs.Endpoint_URL__c+'/api/v1/opportunities';
        endpoint2TestResp.put(endpointURL,fakeCreateOpptyResp);
        
        endpointURL = lcs.Endpoint_URL__c+'/api/v1/opportunities/'+opp.Id+'/send-credit-application';
        System.debug('requestEndpoint----->'+endpointURL);
        endpoint2TestResp.put(endpointURL,fakeSendCreditAppResp);

        HttpCalloutMock multiCalloutMock = new MultiRequestMock(endpoint2TestResp);

        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
        for(creditCheckPageCtrl.CreditCheckRow ccr:ccpCtrl.CreditCheckRows){
          ccr.selected=true;
        }
        List<creditCheckPageCtrl.CreditCheckRow> ccRows = new List<creditCheckPageCtrl.CreditCheckRow>();
        ccRows = ccpCtrl.CreditCheckRows;
        System.debug('----->'+ccRows);
        ccpCtrl.submitCreditCheck();
        
        
        Test.stopTest();
    }
}