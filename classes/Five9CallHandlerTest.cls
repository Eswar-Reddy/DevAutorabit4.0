//Test Class for Five9 Webservice Callout Classes
@isTest(seeAllData=true)                     
private class Five9CallHandlerTest{
    static User spdUser;
    static Account spdAcc;
    
    static{
        Set<String> spdIDSet = new Set<String>();
        spdIDSet.addAll(Label.SPDIds.split(','));
        
        //System.assertNotEquals(spdIDSet,null);
        System.debug('spdIDSet ----- '+spdIDSet);
        
        spdAcc = [select Id,Name from Account where Id in :spdIDSet limit 1];
        
        System.debug('spdAcc ----- '+spdAcc.Name);
        
        spdUser = [select Id,Name from User where AccountId=:spdAcc.Id AND IsActive = true LIMIT 1];
    }
    
    //method to cover Five9WSDL2Apex class
    static testmethod void testfive9callout() {
        
        Five9ComWSDL2Apex.WsAdminPort five9wap = new Five9ComWSDL2Apex.WsAdminPort();
        Five9ComWSDL2Apex.listUpdateSimpleSettings fnlUS = new Five9ComWSDL2Apex.listUpdateSimpleSettings();
        Five9ComWSDL2Apex.recordData fnrD = new Five9ComWSDL2Apex.recordData();
        fnlUS.fieldsMapping = new List<Five9ComWSDL2Apex.fieldEntry>();
        
        Five9ComWSDL2Apex.fieldEntry fE0 = new Five9ComWSDL2Apex.fieldEntry();
        fE0.columnNumber=0;
        fE0.fieldName='number1';
        fE0.key=false;
        fnlUS.fieldsMapping.add(fE0);
            
        Test.startTest();
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new Five9WebServiceMockImpl());
        
        five9wap.addRecordToListSimple('ListName', fnlUS, fnrD);
        // Verify that a fake result is returned
        //System.assertEquals('Mock response', output);
        Test.stopTest();
    }
    
    //method to cover Five9Handler class
    static testmethod void testfive9handler(){
       
        System.debug('spdUser ----- '+spdUser);

        Account acc3 = getPartnerAccount('Test3');
        acc3.Phone = '4081234567';
        update acc3;
        
        Contact conContact = new Contact(AccountId =acc3.Id,
            LastName = 'TestFive9Handler',
            FirstName = 'TestFive9Handler',
            Email = 'testfive9handlercontact1@test.com',
            Phone = acc3.Phone);
        insert conContact;
        
        Opportunity opp3 = new Opportunity( Name = 'Test2 Five9HandlerTest2', 
            StageName = 'New Opportunity',
            Lead_Manufacturer__c = 'SunPower',
            Primary_Contact__c = conContact.Id,
            Dealer_Assignment_Date__c = System.today()+1,
            CloseDate = System.today(),
            OwnerId=spdUser.Id,
            Theater__c='North America',
            Partner_Account_Id__c=spdAcc.Id,
            AccountId =acc3.Id);
            
        test.startTest();        
        insert opp3;
        test.stopTest();
    }
    
    //method to cover Batch_CallFive9 class
    static testmethod void testBatchCallFive9_1(){
        Set<Id> oppIdSet = new Set<Id>();
        Account acc1 = getPartnerAccount('Test1');
        Util.setInContextOfLeadConversion();
        
        //delete [select Primary_Phone__c, Campaign.Name,Opportunity_Number1__c,Not_Sent_To_Five9__c from Opportunity where Id in :oppIdSet or Not_Sent_To_Five9__c =true];
        String query = 'SELECT Count() FROM Opportunity WHERE Not_Sent_To_Five9__c = True';
        Integer batchSize = Database.countQuery(query);
        
        Opportunity opp1 = new Opportunity( Name = 'Test1 Five9HandlerTest1', 
            StageName = 'New Opportunity',
            Lead_Manufacturer__c = 'SunPower',
            //Primary_Contact__c = conContact.Id,
            Dealer_Assignment_Date__c = System.today()+1,
            CloseDate = System.today(),
            OwnerId=spdUser.Id,
            Theater__c='North America',
            Partner_Account_Id__c=spdAcc.Id,
            AccountId =acc1.Id);
            
              
        insert opp1;
        oppIdSet.add(opp1.Id);
        test.startTest(); 
        Batch_CallFive9 five9batch = new Batch_CallFive9();
        five9batch.oppIdSet= oppIdSet;
        //Database.executeBatch(five9batch,1);
        Database.executeBatch(five9batch, (batchSize+1));
        test.stopTest();
    }
    
    //method to create Partner Account
    private static Account getPartnerAccount(String Name){
        Account acct;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs(thisUser){
            String recType ='';
            recType = String.valueOf( GW_RecTypes.GetRecordTypeId('Account','Partner')); 
            acct = new Account(name='Name'+Name+String.valueOf(DateTime.now().getTime()),recordTypeID=recType);
            acct.BillingCity = 'San Jose';
            acct.BillingStreet = 'Morse Ave';
            acct.BillingCountry = 'United States';
            acct.BillingState='CA';
            acct.BillingPostalCode ='94089';
            acct.Online_Order_Access__c = true;
            acct.Oracle_Account_Number__c = 'test_oracle2';
            acct.Theater__c = 'North America';
            acct.CurrencyIsoCode='USD';
            acct.Country_Domain__c = 'combo-it';
            acct.Territory__c = 'Northern California';
            acct.Type = 'Partner';   
            insert acct;
       }
       return acct;
    }
}