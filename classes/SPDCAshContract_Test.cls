@isTest
private class SPDCAshContract_Test {

    static testMethod void myUnitTest() {
    	UserManagement.IS_TEST = true;
         Account testPartner = TestClassFactory.CreateDealer('dealerName', 'North America');
         Contact partnerContact = TestClassFactory.testContact('lastName', 'testpartnercon@noemail.com', TestClassFactory.retrieveRecordTypeID('Contact', 'Partner'));
        partnerContact.AccountId = testPartner.Id;
        partnerContact.Authorized_To_Order__c = TRUE;
        insert partnerContact;
        
        
        TestUtils.createLeaseCreationCustomSetting();
                    DocGen_Callout_Settings__c oDocGenCalloutSettings = new DocGen_Callout_Settings__c();
        oDocGenCalloutSettings.Name = 'DocGen';
        oDocGenCalloutSettings.EndPoint__c ='https://dcs.dev.sunpower.com/ws/docgen/proposal/proposal';
        oDocGenCalloutSettings.EndPoint_Contract__c = 'https://dcs.dev.sunpower.com/ws/docgen/docx/generatePdf';
        oDocGenCalloutSettings.SPDContract_Key__c = 'DC97-20AF-567E';
        insert oDocGenCalloutSettings;
        system.debug('@developer-->oDocGenCalloutSettings'+oDocGenCalloutSettings);
        
        list<SPD_Cash_Contract__c>lstSPDCashContract = new list<SPD_Cash_Contract__c>();
        SPD_Cash_Contract__c oSPDCashContract;
        oSPDCashContract = new SPD_Cash_Contract__c();
        oSPDCashContract.Name = 'contractNum';
        oSPDCashContract.Field_API_Name__c = 'Consolidated_Lease_Number__c';
        oSPDCashContract.Outbound_Type__c = 'Integer';
        oSPDCashContract.sObject_Name__c ='Quote';
        lstSPDCashContract.add(oSPDCashContract);
        
        oSPDCashContract = new SPD_Cash_Contract__c();
        oSPDCashContract.Name = 'customerCity';
        oSPDCashContract.Field_API_Name__c = 'BillingCity';
        oSPDCashContract.Outbound_Type__c = 'String';
        oSPDCashContract.sObject_Name__c ='Account';
        lstSPDCashContract.add(oSPDCashContract);
        
        oSPDCashContract = new SPD_Cash_Contract__c();
        oSPDCashContract.Name = 'customerEmailAddr';
        oSPDCashContract.Field_API_Name__c = 'email__c';
        oSPDCashContract.Outbound_Type__c = 'String';
        oSPDCashContract.sObject_Name__c ='Account';
        lstSPDCashContract.add(oSPDCashContract);
        
        oSPDCashContract = new SPD_Cash_Contract__c();
        oSPDCashContract.Name = 'customerName';
        oSPDCashContract.Field_API_Name__c = 'Name';
        oSPDCashContract.Outbound_Type__c = 'String';
        oSPDCashContract.sObject_Name__c ='Account';
        lstSPDCashContract.add(oSPDCashContract);
        
        oSPDCashContract = new SPD_Cash_Contract__c();
        oSPDCashContract.Name = 'customerPhoneNum';
        oSPDCashContract.Field_API_Name__c = 'Phone';
        oSPDCashContract.Outbound_Type__c = 'String';
        oSPDCashContract.sObject_Name__c ='Account';
        lstSPDCashContract.add(oSPDCashContract);
        
        oSPDCashContract = new SPD_Cash_Contract__c();
        oSPDCashContract.Name = 'customerPostalCode';
        oSPDCashContract.Field_API_Name__c = 'BillingPostalCode';
        oSPDCashContract.Outbound_Type__c = 'String';
        oSPDCashContract.sObject_Name__c ='Account';
        lstSPDCashContract.add(oSPDCashContract);
        
        oSPDCashContract = new SPD_Cash_Contract__c();
        oSPDCashContract.Name = 'customerState';
        oSPDCashContract.Field_API_Name__c = 'BillingState';
        oSPDCashContract.Outbound_Type__c = 'String';
        oSPDCashContract.sObject_Name__c ='Account';
        lstSPDCashContract.add(oSPDCashContract);
        
        oSPDCashContract = new SPD_Cash_Contract__c();
        oSPDCashContract.Name = 'customerStreetAddress';
        oSPDCashContract.Field_API_Name__c = 'BillingStreet';
        oSPDCashContract.Outbound_Type__c = 'String';
        oSPDCashContract.sObject_Name__c ='Account';
        lstSPDCashContract.add(oSPDCashContract);
        
        oSPDCashContract = new SPD_Cash_Contract__c();
        oSPDCashContract.Name = 'DealType';
        oSPDCashContract.Field_API_Name__c = 'QuoteType__c';
        oSPDCashContract.Outbound_Type__c = 'String';
        oSPDCashContract.sObject_Name__c ='Quote';
        lstSPDCashContract.add(oSPDCashContract);
        
        oSPDCashContract = new SPD_Cash_Contract__c();
        oSPDCashContract.Name = 'inverters';
        oSPDCashContract.Field_API_Name__c = 'Quote_Inverter_Values__c';
        oSPDCashContract.Outbound_Type__c = 'String';
        oSPDCashContract.sObject_Name__c ='Quote';
        lstSPDCashContract.add(oSPDCashContract);

        oSPDCashContract = new SPD_Cash_Contract__c();
        oSPDCashContract.Name = 'SystemPrice';
        oSPDCashContract.Field_API_Name__c = 'System_Cost__c';
        oSPDCashContract.Outbound_Type__c = 'String';
        oSPDCashContract.sObject_Name__c ='Quote';
        lstSPDCashContract.add(oSPDCashContract);

        insert lstSPDCashContract;
        system.debug('@developer-->lstSPDCashContract'+lstSPDCashContract);
            
            RecordType rtAccount = [Select id,Name,developername from recordtype where sObjecttype='Account' and developername='Partner' limit 1 ];
        Account oAccount = new Account();
        oAccount.recordtypeid = rtAccount.id;
        oAccount.Name = 'TestAccount';
        oAccount.CurrencyIsoCode = 'EUR';
       oAccount.BillingCity = 'Cassis';
        oAccount.BillingStreet = 'Cassis';
        oAccount.BillingPostalCode ='13260';
        oAccount.BillingCountry = 'France'; 
        oAccount.Country_Domain__c = 'rvar-fr';
        insert oAccount;
        system.debug('@developer-->oAccount:'+oAccount);
        
        RecordType rtContact = [Select id,Name,developername from recordtype where sObjecttype='Contact' and developername='Partner' limit 1 ];
        Contact oContact = new Contact();
        oContact.recordtypeid = rtContact.id;
        oContact.LastName = 'TestContact';
        oContact.AccountId = testPartner.id;
        oContact.LMS_Job_ID__c = 'Install';
        oContact.Primary__c = true;
        oContact.Include_in_Lease_Doc__c = true;
        insert oContact;
        system.debug('@developer-->oContact'+oContact);
            
        UserRole role = [SELECT Id FROM UserRole WHERE Name LIKE '%Partner Executive' LIMIT 1];
        //UserRole role = [SELECT Id FROM UserRole WHERE Name = 'Sunpower Corporation' LIMIT 1];
//SunpowerCorporation
        Id execProfileId = SFDCSpecialUtilities.getProfileIdByName('Partner Executive');

        User u = new User(alias = 'cashman1', email = partnerContact.Email, 
                          emailencodingkey='UTF-8', lastname='Testing', 
                          languagelocalekey='en_US', localesidkey='en_US', 
                          profileid = execProfileId,  country='United States', 
                          communityNickName = 'cashman1', timezonesidkey='America/Los_Angeles', 
                          username=string.valueOf(math.random())+'u1@testorg.com',
                          contactId=partnerContact.Id, UserRole = role,CounterSignature__c='test',HIS_Registration_Number__c='test');
                          
        system.debug('@developer-->'+ u);
        
        Test.startTest(); 
         System.runAs(u){
                    
								Opportunity opp = new Opportunity();
                opp.accountId = testPartner.Id;
                    opp.name = 'TestOppPSR';  
                    opp.StageName= 'Binding Offer';
                    opp.Closedate = System.today(); 
                    opp.Business_Unit__c = 'UPP Intl';
                    opp.Region1__c ='Australia';
                    opp.country__c='United States';
                    insert opp;
        system.debug('@developer-->opp'+opp);
								
								Quote_Summary__c QS = new Quote_Summary__c();
            QS.opportunity__c = Opp.id;
            QS.Lease_Doc_Signed__c = True;
        Insert Qs;
								
        Quote Q = new Quote();
            Q.Opportunityid = opp.id;
            Q.account__c = testPartner.id;
            Q.Quote_Summary__c = Qs.id;
            Q.Name = 'Test Qte' ; 
           Q.Oracle_Vendor_email_field_value__c = 'test@test.com';
            //Q.TestPSR_Email__c = 'test2@test2.com';
            Q.Primary_PSR_Email_Id__c = 'test3@test3.com';
            Q.Inverter_Brand__c = 'SunPower';
            Q.Inverter_Model__c = 'SPR-5000m (240V)';
            Q.Inverter_Quantity__c = 1;
            Q.Inverter_Brand_2__c = 'SunPower 2';
            Q.Inverter_Model_2__c = 'SPR-5000m (241V)';
            Q.Inverter_Quantity_2__c = 2;
            Q.Trigger_Checkbox__c = false;
            Q.Send_Lien_Waiver_Agreement__c = false;
            Q.Inverter_Brand_3__c = 'SunPower 3';
            Q.Inverter_Model_3__c = 'SPR-5000m (242V)';
            Q.Inverter_Quantity_3__c = 3;
            Q.Inverter_Brand_4__c = 'SunPower 4';
            Q.Inverter_Model_4__c = 'SPR-5000m (243V)';
            Q.Inverter_Quantity_4__c = 4;
            Q.Quote_Inverter_Values__c = 'SunPower-SPR-5000m (240V) 1';
            Q.Temp_Contact_1__c = oContact.id;
            Q.Temp_Contact_2__c = oContact.id; 
            Q.Dealer_Fees__c = 500;
            Q.Is_Locked__c = False;
            Q.Lease_Doc_Signed__c = false;
            Q.Dealer_Fees__c = 300;        
            //Q.Is_Locked__c = True;
            Q.Lease_Doc_Signed__c = True;
            Q.Quote_type__c = 'Residential Lease Quotation';
            Q.Doc_out_for_signature__c = false;    
            Q.System_Cost__c = 75000;
        insert Q;
                    
                    system.debug('@developer-->Q'+Q);
                    
                    system.debug('@developer-->oQuote'+[select id , account__c From quote where id=: Q.Id]);
                    
            SPDCAshContract cSPDCAshContract = new SPDCAshContract();
        cSPDCAshContract.sendDataToDocGen(Q.id);
         }
         Test.stopTest();
        
    }
}