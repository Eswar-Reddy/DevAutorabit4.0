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
private class TestSpectrumOutboundREST implements HttpCalloutMock{
 
	 ////override the respond method for HttpCalloutMock
	 public HTTPResponse respond(HTTPRequest req) {
	  //build a fake response
	        HttpResponse res = new HttpResponse();
	        //for parser method...string needs to be nested
	        res.setBody('{"responses":[{"recordId":null,"result":"Created Spectrum Id 28712","accountId":null,"accountName":"SunPower Test LLC"}]}');
	        res.setStatusCode(200);
	        return res;
	 }
	    
	    
  //  static testMethod void testSingleRecord() {
  //  	User u = TestClassFactory.testUser('System Administrator','email@email.com','nickn');
  //  	u.Division = 'Test';
  //  	u.Country = 'United States';
  //  	insert u;
  //  	System.runAs(u){
  //  		insert TestClassFactory.buildSpectrumOppServiceSettings(false);
  //  		SpectrumCredentials__c credential = SpectrumCredentials__c.getOrgDefaults();
  //  		credential.Username__c = 'Nothing';
  //  		credential.Password__c = 'Nothing';
  //  		credential.Endpoint__c = 'https://test.spectrum.sunpower.com';
  //  		insert credential;
  //  	}
  //      Account acc = TestUtils.createAccount('Test Account', true);
  //      Contact con = TestUtils.createContact('Test Testerson', acc.Id, false);
  //      con.Primary__c = true;
  //      insert con;
  //      List<Opportunity> opp = TestUtils.createOpportunities(1, acc.Id, con.Id, false);
  //      opp[0].Alliance_Program_Lead__c = true;
  //      opp[0].Primary_Contact__c = con.Id;
  //      insert opp;
        
  //      Set<Id> oppIds = new Set<Id>{opp[0].Id};
        
        
        
  //      Test.startTest();
  //      Test.setMock(HttpCalloutMock.class, new TestSpectrumOutboundREST());
  //      SpectrumOutboundREST httpService = new SpectrumOutboundREST();
  //      System.debug(httpService.buildQuery());
  //      httpService.sendRecordsToSpectrum(oppIds);
  //      Test.stopTest();
        
  //      String formattedJson = httpService.jsonBuiltString.replaceAll('\\s','');
  //      System.debug('FORMATTEDSTRING: ' + formattedJson);
  //      System.assert(formattedJson.contains('"oppId":"' + opp[0].Id + '"'));
        
  //  }
    
  //  static testMethod void testMultipleRecords() {
  //  	User u = TestClassFactory.testUser('System Administrator','email@email.com','nickn');
  //  	u.Division = 'Test';
  //  	u.Country = 'United States';
  //  	insert u;
  //  	System.runAs(u){
  //  		insert TestClassFactory.buildSpectrumOppServiceSettings(false);
  //  		SpectrumCredentials__c credential = SpectrumCredentials__c.getOrgDefaults();
  //  		credential.Username__c = 'Nothing';
  //  		credential.Password__c = 'Nothing';
  //  		credential.Endpoint__c = 'https://test.spectrum.sunpower.com';
  //  		insert credential;
  //  	}
  //      Account acc = TestUtils.createAccount('Test Account', true);
  //      Account acc1 = TestUtils.createAccount('Test Account 1',true);
  //      Contact con = TestUtils.createContact('Test Testerson', acc.Id, false);
  //      Contact con1 = TestUtils.createContact('Tester Testerson1',acc1.Id,true);
  //      con.Email = '124448ijkcjf@email.com';
  //      con.Primary__c = true;
  //      insert con;
  //      List<Opportunity> opp = TestUtils.createOpportunities(1, acc.Id, con.Id, false);
  //      opp[0].Alliance_Program_Lead__c = true;
  //      opp[0].Primary_Contact__c = con.Id;
  //      insert opp;
  //      List<Opportunity> opp1 = TestUtils.createOpportunities(1, acc1.Id, con1.Id, true);
        
  //      Set<Id> oppIds = new Set<Id>{opp[0].Id,opp1[0].Id};
        
        
        
  //      Test.startTest();
  //      Test.setMock(HttpCalloutMock.class, new TestSpectrumOutboundREST());
  //      SpectrumOutboundREST httpService = new SpectrumOutboundREST();
  //      httpService.sendRecordsToSpectrum(oppIds);
  //      Test.stopTest();
        
  //      String formattedJson = httpService.jsonBuiltString.replaceAll('\\s','');
  //      System.debug('FORMATTEDSTRING: ' + formattedJson);
  //      System.assert(formattedJson.contains('"oppId":"' + opp[0].Id + '"'));
  //      System.assert(formattedJson.contains('"oppId":"' + opp1[0].Id + '"'));
        
  //  }
    
  //  static testMethod void testServices(){
  //  	User u = TestClassFactory.testUser('System Administrator','email@email.com','nickn');
  //  	u.Division = 'Test';
  //  	u.Country = 'United States';
  //  	insert u;
  //  	System.runAs(u){
  //  		insert TestClassFactory.buildSpectrumOppServiceSettings(false);
  //  		SpectrumCredentials__c credential = SpectrumCredentials__c.getOrgDefaults();
  //  		credential.Username__c = 'Nothing';
  //  		credential.Password__c = 'Nothing';
  //  		credential.Endpoint__c = 'https://test.spectrum.sunpower.com';
  //  		insert credential;
  //  	}
  //  	Account acc = TestUtils.createAccount('Test Account', true);
  //      Account acc1 = TestUtils.createAccount('Test Account 1',true);
  //      Contact con = TestUtils.createContact('Test Testerson', acc.Id, false);
  //      Contact con1 = TestUtils.createContact('Tester Testerson1',acc1.Id,true);
  //      con.Email = '124448ijkcjf@email.com';
  //      con.Primary__c = true;
  //      insert con;
  //      List<Opportunity> opp = TestUtils.createOpportunities(1, acc.Id, con.Id, false);
  //      opp[0].Alliance_Program_Lead__c = true;
  //      opp[0].Primary_Contact__c = con.Id;
  //      insert opp;
  //      List<Opportunity> opp1 = TestUtils.createOpportunities(1, acc1.Id, con1.Id, true);
        
  //      SpectrumJSONServices jsonService = new SpectrumJSONServices();
        
  //      Test.startTest();
  //      jsonService.evaluateSpectrumChangedDataOpportunity(opp1[0],opp1[0],true);
  //      Boolean accChanged = jsonService.evaluateSpectrumChangedDataAccount(acc,acc);
  //      Boolean conChanged = jsonService.evaluateSpectrumChangedDataContact(con,con);
  //      Test.stopTest();
        
  //      System.assertEquals(accChanged,false);
  //      System.assertEquals(conChanged,false);
  //  }
    
  //  static testMethod void testServicesTrue(){
  //  	User u = TestClassFactory.testUser('System Administrator','email@email.com','nickn');
  //  	u.Division = 'Test';
  //  	u.Country = 'United States';
  //  	insert u;
  //  	System.runAs(u){
  //  		insert TestClassFactory.buildSpectrumOppServiceSettings(false);
  //  		SpectrumCredentials__c credential = SpectrumCredentials__c.getOrgDefaults();
  //  		credential.Username__c = 'Nothing';
  //  		credential.Password__c = 'Nothing';
  //  		credential.Endpoint__c = 'https://test.spectrum.sunpower.com';
  //  		insert credential;
  //  	}
  //  	Account acc = TestUtils.createAccount('Test Account', true);
  //      Account acc1 = TestUtils.createAccount('Test Account 1',false);
  //      acc1.BillingStreet = '1234 Testing Ln';
  //      insert acc1;
  //      Contact con = TestUtils.createContact('Test Testerson', acc.Id, false);
  //      Contact con1 = TestUtils.createContact('Tester Testerson1',acc1.Id,true);
  //      con.Phone = '1231231234';
  //      con.Email = '124448ijkcjf@email.com';
  //      con.Primary__c = true;
  //      insert con;
  //      List<Opportunity> opp = TestUtils.createOpportunities(1, acc.Id, con.Id, false);
  //      opp[0].Alliance_Program_Lead__c = true;
  //      opp[0].Primary_Contact__c = con.Id;
  //      insert opp;
  //      List<Opportunity> opp1 = TestUtils.createOpportunities(1, acc1.Id, con1.Id, true);
        
  //      SpectrumJSONServices jsonService = new SpectrumJSONServices();
        
  //      Test.startTest();
  //      Boolean accChanged = jsonService.evaluateSpectrumChangedDataAccount(acc,acc1);
  //      Boolean conChanged = jsonService.evaluateSpectrumChangedDataContact(con,con1);
  //      Test.stopTest();
        

  //  }
    
}