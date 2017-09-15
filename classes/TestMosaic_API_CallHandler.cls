@isTest
public class TestMosaic_API_CallHandler {
    
    public static Account customerAccount;
    public static Contact customerContact;
    public static Contact con;
    public static MosaicJSONUtil.Address addr;
    public static MosaicJSONUtil.Opportunity opp;
    public static MosaicJSONUtil.SolarSystem slrSys;
    public static Loan_Callout_Settings__c lcs;
    public static Quote qt;
    public static Quote_Summary__c qtsm;
    public static Credit_Check_Request__c cca;
    public static Credit_Product__c cp;
    public static List<Opportunity> oppList = new List<Opportunity>();
    
    static{
        CustomerAccount = TestUtils.createAccount( 'CustomerAcct', TestUtils.getResidentialRecordTypeId(), false );
        CustomerAccount.BillingState = 'CA';
        CustomerAccount.BillingCountry= 'United States';
        insert CustomerAccount;
        
        customerContact = TestUtils.createContact('CustomerContact', CustomerAccount.Id, true);
        con = [select Id,FirstName,LastName,MailingStreet,MailingCity,MailingState,MailingPostalCode,Phone,Email from Contact where Id=:customerContact.Id];
        
        addr = new MosaicJSONUtil.Address(con.MailingStreet,'',con.MailingCity,con.MailingState,con.MailingPostalCode);
        opp = new MosaicJSONUtil.Opportunity(con.FirstName,con.LastName,con.Phone.replaceAll('\\D',''),con.Email,addr,con.Email,null);
        slrSys = new MosaicJSONUtil.SolarSystem(Double.valueOf(311.0),Double.valueOf(213.57583333333332),5253,Double.valueOf(5.232),'SunPower 327W (Model SPR-327NE-WHT-D)','SunPower 3.0 kW (Model SUNNY BOY 3000TL-US-22 - 208v (SPR-3002m))',Double.valueOf(31068.4206368),'2016-03-11',null,'2016-03-11','NONE','PowerSwitch 10.299.L',Double.valueOf(20000.00));
        
        lcs = new Loan_Callout_Settings__c(Name='Mosaic',SalesRepEmail__c = 'test@mosaic.com');
        insert lcs;
        
        oppList = TestUtils.createOpportunities(1, customerAccount.Id, customerContact.Id, true);
        
        List<Quote> qtList = TestUtils.createQuotes(1, 'TestQuote', oppList[0].Id, false);
        qt = qtList[0];
        qt.QuoteType__c='Loan';
        qt.Monthly_Power_Bill_Before_Solar__c = '3110.00';
        qt.Monthly_Power_Bill_After_Solar__c = '213.58';
        qt.System_Production_Year_1__c = 5253;
        qt.System_model__c = '327W (Model SPR-327NE-WHT-D)';
        qt.Inverter_Model__c = '3.0 kW(Model SUNNY BOY 3000TL-US-22 - 208v (SPR-3002m))';
        qt.Financed_Amount__c = 31068.42;
        insert qt;
        
        List<Quote_Summary__c> qtsmList = TestUtils.createQuoteSummaries(1,'QuoteSummary', oppList[0].Id, customerAccount.Id, false);
        qtsm = qtsmList[0];
        qtsm.Module1_AC_rating__c = 2.0;
        qtsm.Module2_AC_rating__c = 3.0;
        qtsm.Module3_AC_rating__c = 0.0;
        qtsm.Module4_AC_rating__c = 0.0;
        insert qtsm;

        System_Production__c sp = new System_Production__c(Quote__c = qt.Id,Monthly_Electric_Bill_Without_PV_year1__c = 100.01);
        insert sp;
        
        cca = TestUtils.createCreditCheckApp(customerAccount.Id, customerContact.Id, true);
       
        cp = TestUtils.createCreditProduct(cca.Id,100000.00,10000.00,true);
    }
    
    public static testmethod void Test_mosaic_Create_Opportunity_Success(){
        test.startTest();
        
        String JSONString = JSON.serialize(opp);
        TestMosaicHttpCalloutMock fakeSuccessResponse = new TestMosaicHttpCalloutMock(200,
                                                                                      'Complete',
                                                                                      JSONString,
                                                                                      null);
        
        Test.setMock(HttpCalloutMock.class, fakeSuccessResponse);
        
        Mosaic_API_CallHandler.mosaic_Create_Opportunity(con);
        //System.assertEquals(/*check for expected results here...*/);
        test.stopTest();
    }
    
    public static testmethod void Test_mosaic_Create_Opportunity_Failure(){
        test.startTest();
        
        TestMosaicHttpCalloutMock fakeFailureResponse = new TestMosaicHttpCalloutMock(400,
                                                                                      'Complete',
                                                                                      'Error',
                                                                                      null);
        Test.setMock(HttpCalloutMock.class, fakeFailureResponse);
        
        Mosaic_API_CallHandler.mosaic_Create_Opportunity(con);
        //System.assertEquals(/*check for expected results here...*/);
        test.stopTest();
    }
    
    
    public static testmethod void Test_mosaic_Update_Opportunity_Success(){
        test.startTest();
        opp.SolarSystem = slrSys;
        String JSONString = JSON.serialize(opp);
        TestMosaicHttpCalloutMock fakeSuccessResponse = new TestMosaicHttpCalloutMock(200,
                                                                                      'Complete',
                                                                                      JSONString,
                                                                                      null);
        
        Test.setMock(HttpCalloutMock.class, fakeSuccessResponse);
        
        Mosaic_API_CallHandler.mosaic_Update_Opportunity(cca,qt,qtsm,cp);
        
        test.stopTest();
    }
    
    public static testmethod void Test_mosaic_Update_Opportunity_Failure(){
        test.startTest();
        opp.SolarSystem = slrSys;
        String JSONString = JSON.serialize(opp);
        TestMosaicHttpCalloutMock fakeFailureResponse = new TestMosaicHttpCalloutMock(240,
                                                                                      'Complete',
                                                                                      JSONString,
                                                                                      null);
        
        Test.setMock(HttpCalloutMock.class, fakeFailureResponse);
        
        Mosaic_API_CallHandler.mosaic_Update_Opportunity(cca,qt,qtsm,cp);
        
        test.stopTest();
    }
    
    public static testmethod void Test_mosaic_Send_Credit_Application_Success(){
        test.startTest();
        
        TestMosaicHttpCalloutMock fakeSuccessResponse = new TestMosaicHttpCalloutMock(200,
                                                                                      'Complete',
                                                                                      '{""}',
                                                                                      null);
        
        Test.setMock(HttpCalloutMock.class, fakeSuccessResponse);
        
        Mosaic_API_CallHandler.mosaic_Send_Credit_Application('4321');
        //System.assertEquals(/*check for expected results here...*/);
        test.stopTest();
    }
    
    public static testmethod void Test_mosaic_Send_Credit_Application_Failure(){
        test.startTest();
        
        TestMosaicHttpCalloutMock fakeFailureResponse = new TestMosaicHttpCalloutMock(404,
                                                                                      'Complete',
                                                                                      '{""}',
                                                                                      null);
        
        Test.setMock(HttpCalloutMock.class, fakeFailureResponse);
        
        Mosaic_API_CallHandler.mosaic_Send_Credit_Application('4321');
        //System.assertEquals(/*check for expected results here...*/);
        test.stopTest();
    }
    
    public static testmethod void Test_mosaic_Send_Loan_Agreement_Success(){
        test.startTest();
        
        TestMosaicHttpCalloutMock fakeSuccessResponse = new TestMosaicHttpCalloutMock(200,
                                                                                      'Complete',
                                                                                      '{""}',
                                                                                      null);
        
        Test.setMock(HttpCalloutMock.class, fakeSuccessResponse);
        
        Mosaic_API_CallHandler.mosaic_Send_Loan_Agreement('4321');
        //System.assertEquals(/*check for expected results here...*/);
        test.stopTest();
    }
    
    public static testmethod void Test_mosaic_Send_Loan_Agreement_Failure(){
        test.startTest();
        
        TestMosaicHttpCalloutMock fakeFailureResponse = new TestMosaicHttpCalloutMock(400,
                                                                                      'Complete',
                                                                                      '{""}',
                                                                                      null);
        
        Test.setMock(HttpCalloutMock.class, fakeFailureResponse);
        
        Mosaic_API_CallHandler.mosaic_Send_Loan_Agreement('4321');
        //System.assertEquals(/*check for expected results here...*/);
        test.stopTest();
    }
    
    public static testmethod void Test_mosaic_Upload_Document_Success(){
        test.startTest();
        
        TestMosaicHttpCalloutMock fakeSuccessResponse = new TestMosaicHttpCalloutMock(200,
                                                                                      'Complete',
                                                                                      '{""}',
                                                                                      null);
        
        Test.setMock(HttpCalloutMock.class, fakeSuccessResponse);
        
        Attachment att = new Attachment();
        att.body = Blob.valueOf(';laksdjflaskdjfa;lskdfj;alskdjf;alksjdflas;jfkd;djklsf92345902345902374592345290-3485,zm.xncvz,mxcnvm,zvnxzc,vn`12312/,/,;ekfljsdf');
        
        Mosaic_API_CallHandler.mosaic_Upload_Document('oppId', 'documentType', att);
        
        test.stopTest();
    }
    
    public static testmethod void Test_mosaic_Upload_Document_Failure(){
        test.startTest();
        
        TestMosaicHttpCalloutMock fakeFailureResponse = new TestMosaicHttpCalloutMock(245,
                                                                                      'Complete',
                                                                                      '{""}',
                                                                                      null);
        
        Test.setMock(HttpCalloutMock.class, fakeFailureResponse);
        
        Attachment att = new Attachment();
        att.body = Blob.valueOf(';laksdjflaskdjfa;lskdfj;alskdjf;alksjdflas;jfkd;djklsf92345902345902374592345290-3485,zm.xncvz,mxcnvm,zvnxzc,vn`12312/,/,;ekfljsdf');
        
        Mosaic_API_CallHandler.mosaic_Upload_Document('oppId', 'documentType', att);
        
        test.stopTest();
    }

    public static testmethod void Test_mosaic_Submit_Photo_Installation(){
        test.startTest();
        String JSONString = JSON.serialize(opp);
        TestMosaicHttpCalloutMock fakeFailureResponse = new TestMosaicHttpCalloutMock(200,
                                                                                      'Complete',
                                                                                      JSONString,
                                                                                      null);
        
        Test.setMock(HttpCalloutMock.class, fakeFailureResponse);
        
        Mosaic_API_CallHandler.mosaic_Submit_Photo_Proof_Installation(String.valueOf(oppList.get(0).Id));
        
        test.stopTest();
    }
}