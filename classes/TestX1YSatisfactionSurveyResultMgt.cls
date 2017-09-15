/*********************************************************************
    Name  : TestX1YSatisfactionSurveyResultMgt
    Date  : June 22,2011
    Related Case: 00066815 
    Description:This is a Test Class For Class "X1YSatisfactionSurveyResultManagement".
*********************************************************************/
@isTest
private class TestX1YSatisfactionSurveyResultMgt {

    // When  X1Y_Satisfaction_Survey_Result__c is inserted
    static testMethod void X1YSSRTest() {
        
        String  HomeOwnerOppRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Home Owner').getRecordTypeId();
        
        Account a = new Account(name='testAcc');
        a.Type = 'Premier-Partner-Combo';
        a.BillingCity = 'hyd';
        a.BillingState = 'hyd';
        a.BillingCountry = 'Italy';
        a.BillingStreet = 'abc';
        a.BillingPostalCode = '1223454';
        
        a.ShippingCity = 'hyd';
        a.ShippingState = 'hyd';
        a.ShippingCountry = 'Italy';
        a.ShippingStreet = 'abc';
        a.ShippingPostalCode = '1223454';    
        
        a.Oracle_County__c = 'Italy';
            
        a.Theater__c = 'Europe';
        insert a;

        User test_user =TestClassUtilities.getEUPartnerPortalUser(a); 
        System.runAs(test_user){
            Test.startTest();
            Account a1 = new Account(name='testAcc1');
            a1.Type = 'Premier-Partner-Combo';
            a1.BillingCity = 'hyd';
            a1.BillingState = 'hyd';
            a1.BillingCountry = 'Italy';
            a1.BillingStreet = 'abc';
            a1.BillingPostalCode = '1223454';
            
            a1.ShippingCity = 'hyd';
            a1.ShippingState = 'hyd';
            a1.ShippingCountry = 'Italy';
            a1.ShippingStreet = 'abc';
            a1.ShippingPostalCode = '1223454'; 
            
            a.Oracle_County__c = 'Italy';                       
            a1.Theater__c = 'Europe';
            insert a1;
            
            Contact contactObj = new Contact();
            contactObj.FirstName = 'test' +String.valueOf(DateTime.Now());
            contactObj.LastName = 'test' + String.valueOf(DateTime.Now());
            contactObj.AccountId = a.Id;
            contactObj.Email = 'test'+ String.valueOf(DateTime.now().second()) + String.valueOf(DateTime.now().millisecond())  + '@test' + String.valueOf(DateTime.now().second()) + String.valueOf(DateTime.now().millisecond()) + '.com';

            insert contactObj;
        
            Opportunity testOpp = new Opportunity();
            testOpp.Name = 'testOpp';
            testOpp.Theater__c = 'Europe';
            testOpp.OwnerId = test_user.Id;
            testOpp.RecordTypeId = HomeOwnerOppRecordTypeID;
            testOpp.stageName = 'Installation Completed';
            //testOpp.Primary_Contact_Email__c='test@test.com';
            testOpp.Primary_Contact__c=contactObj.Id;
            testOpp.Installation_Date__c = Date.today().addYears(1);
            testOpp.Installation_Completed_Date__c= Date.today().addYears(1);
            testOpp.Customer_Satisfaction_Survey_opt_in__c=True;
            testOpp.Lease__c=True;
            testOpp.Lease_Placed_in_Service__c=True;
            testOpp.CloseDate = Date.today(); 
            testOpp.AccountId=a1.Id;
            insert testOpp;
            //System.debug('Check0'+[Select Installation_Completed_Date__c from opportunity where id=:testOpp.id ].Installation_Completed_Date__c );
            X1Y_Satisfaction_Survey_Result__c X1YSSR = new X1Y_Satisfaction_Survey_Result__c();
            X1YSSR.Opportunity__c = testOpp.Id;
            X1YSSR.Contact__c = contactObj.Id;
            X1YSSR.Customer_Account__c = a1.Id;
            insert X1YSSR;
            
            X1Y_Satisfaction_Survey_Result__c X1YSSRInserted = [select id,Survey_Reference_Date__c,Partner_Account__c from X1Y_Satisfaction_Survey_Result__c where id = :X1YSSR.Id];
            
            System.assertEquals(X1YSSRInserted.Survey_Reference_Date__c ,Date.today());
            System.assertEquals(X1YSSRInserted.Partner_Account__c ,a.Id);
            Test.stopTest();
        }   
    }
    
    // When  X1Y_Satisfaction_Survey_Result__c is updated    
    static testMethod void X1YSSRTest1() {
        
        Test.startTest();
        String  CommercialOppRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial').getRecordTypeId();
        
        Account a1 = new Account(name='testAcc1');
        a1.Type = 'Premier-Partner-Combo';
        a1.BillingCity = 'hyd';
        a1.BillingState = 'CA';
        a1.BillingCountry = 'United States';
        a1.BillingStreet = 'abc';
        a1.BillingPostalCode = '1223454';
        
        a1.ShippingCity = 'hyd';
        a1.ShippingState = 'CA';
        a1.ShippingCountry = 'United States';
        a1.ShippingStreet = 'abc';
        a1.ShippingPostalCode = '1223454';

        a1.Oracle_County__c = 'US';                
        a1.Theater__c = 'North America';
        insert a1;
        
        Contact contactObj = new Contact();
        contactObj.FirstName = 'test' +String.valueOf(DateTime.Now());
        contactObj.LastName = 'test' + String.valueOf(DateTime.Now());
        contactObj.AccountId = a1.Id;
        contactObj.Email = 'test'+ String.valueOf(DateTime.now().second()) + String.valueOf(DateTime.now().millisecond())  + '@test' + String.valueOf(DateTime.now().second()) + String.valueOf(DateTime.now().millisecond()) + '.com';

        insert contactObj;
        
        List<Opportunity> testOppList = [select id,PartnerAccountId,Delivery_Date__c from Opportunity where PartnerAccountId != null and Theater__c != 'Europe' and Delivery_Date__c != null and RecordType.Name = 'Commercial' limit 1];
                
        X1Y_Satisfaction_Survey_Result__c X1YSSR = new X1Y_Satisfaction_Survey_Result__c();
        X1YSSR.Contact__c = contactObj.Id;
        X1YSSR.Customer_Account__c = a1.Id;
        insert X1YSSR;

        if(testOppList.size() > 0 ){
            X1YSSR.Opportunity__c = testOppList[0].Id;
            update X1YSSR;
            
            X1Y_Satisfaction_Survey_Result__c X1YSSRUpdated = [select id,Survey_Reference_Date__c,Partner_Account__c from X1Y_Satisfaction_Survey_Result__c where id = :X1YSSR.Id];
            Id oppPartnerAccountId = [select PartnerAccountId,Id from Opportunity where id = :testOppList[0].Id].Id;
            System.assertEquals(X1YSSRUpdated.Survey_Reference_Date__c ,testOppList[0].Delivery_Date__c);
            System.assertEquals(X1YSSRUpdated.Partner_Account__c ,testOppList[0].PartnerAccountId);
        }
        Test.stopTest();
    }
}