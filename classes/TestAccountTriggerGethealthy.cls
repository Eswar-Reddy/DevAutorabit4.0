@IsTest (SeeAllData=true)
public class TestAccountTriggerGethealthy {
    /*
 static testMethod void testAccountTrigger()
    {   
        Util.isTestnonGethealthyCode = true;
        //Account73%
         test.startTest();
        //String[] setting = new String['Account'];
        Set<String> mySet = new Set<String>();
        mySet.add('Account');
        mySet.add('checkAccountDuplicate');
        
        
        byPassHelper(mySet);
        Account acct = new Account();
        acct.Name = 'Test123456888999';
        acct.Type = 'Elite-Partner-Residential';
        acct.RSM_Discretionary_Adj__c = 5;
        acct.BillingCity = 'DeSoto';
        acct.BillingStreet = 'Main Street';
        acct.BillingState = 'AZ';
        acct.BillingCountry = 'United States';
        acct.BillingPostalCode = '751234';
        acct.Opp_Convert_Rate__c = 70;
        acct.Theater__c='North America';
        acct.RecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.SobjectType).get('Partner');
        insert acct;
        
        acct.BillingCity = 'Irving';
        acct.BillingStreet = 'Main Street';
        acct.BillingState = 'TX';
        acct.BillingCountry = 'United States';
        acct.BillingPostalCode = '75038';
        acct.Geolocation__Latitude__s=12.00;
        acct.Geolocation__Longitude__s =23.00;
        update acct;
        
        test.stopTest();
    }
    
    static testMethod void testUpdateOppOnAcctOwnerChange()
    {   
        Util.isTestnonGethealthyCode = true;
        //75
        //AccountOwnerUpdate.cls 100
        //AccountOwnerUpdate.trigger 71
        //UpdateOppOnAcctOwnerChange.trigger 75
        test.startTest();
        Set<String> mySet = new Set<String>();
        mySet.add('UpdateOppOnAcctOwnerChange');
        mySet.add('accountOwnerUpdate');
        
        byPassHelper(mySet);
        Account acct = new Account();
        acct.Name = 'Test123456888999';
        acct.Type = 'Home Owner';
        acct.RSM_Discretionary_Adj__c = 5;
        acct.BillingCity = 'DeSoto';
        acct.BillingStreet = 'Main Street';
        acct.BillingState = 'AZ';
        acct.BillingCountry = 'United States';
        acct.BillingPostalCode = '751234';
        acct.Opp_Convert_Rate__c = 70;
        acct.Theater__c='North America';
        acct.RecordTypeId = AccountHandlerUtilities.ResidentialRecTypeId;
        
        insert acct;
        User objUser = [Select Id,UserType from User where UserType='PowerPartner' and isActive=True limit 1 ];
        acct.OwnerId =objUser.id;
        update acct;
        test.stopTest();
}*/
    //MAM 19.MAY.2015 from tetsBeforeAccountUpdate1 to testBeforeAccountUpdate1
    static testMethod void testBeforeAccountUpdate1() {
        Util.isTestnonGethealthyCode = true;
        //AccountManagement 10%
        //beforeAccountUpdate.trigger 57%
        test.startTest();
        Set<String> mySet = new Set<String>();
        mySet.add('afterAccountInsert');
        byPassHelper(mySet);
        
        
        //MAM 06.MAY.2015 Modified SOQL to avoid getting INVALID_CROSS_REFERENCE_KEY error start 
        //User objUser = [Select Id,Contact.Account.Theater__c,Contact.Account.Territory__c from User where Profile.Name like 'Partner%' AND isActive=true limit 1];
        //User objUser = [Select Id,Contact.Account.Theater__c,Contact.Account.Territory__c from User where Profile.Name = 'Partners Profile' AND isActive=true limit 1]; 
        //MAM 19.MAY.2015 fix for System.DmlException: Insert failed. First exception on row 0; first error: FIELD_FILTER_VALIDATION_EXCEPTION, Value does not exist or does not match filter criteria.: [OwnerId]
        User objUser = [Select Id, Name, Contact.Account.Theater__c,Contact.Account.Territory__c from User where Profile.Name = 'Partner Executive' AND isActive=true AND Contact.Account.Theater__c = 'North America' And Account_Name__c = '21st Century Power Solutions, LLC' LIMIT 1];
        //MAM 06.MAY.2015 end
        //MAM 19.MAY.2015 end
        
        System.runAs(objUser){
        Account acct = new Account();
        acct.Name = '21st Century Power Solutions, LLC'; //MAM 19.MAY.2015 from Test123456888999 to 21st Century Power Solutions, LLC
        acct.Type = 'Residential';
        acct.RSM_Discretionary_Adj__c = 5;
        acct.BillingCity = 'DeSoto';
        acct.BillingStreet = 'Main Street';
        acct.BillingState = 'AZ';
        acct.BillingCountry = 'United States';
        acct.BillingPostalCode = '751234';
        acct.Opp_Convert_Rate__c = 70;
        acct.Theater__c='North America';
        acct.RecordTypeId = AccountHandlerUtilities.ResidentialRecTypeId; //MAM 19.MAY.2015 from AccountHandlerUtilities.PartnerRecTypeId to AccountHandlerUtilities.ResidentialRecTypeId 
        acct.Status__c = 'nonActive';
        acct.Online_Order_Access__c = true;
        acct.Oracle_Account_Number__c='1234';
        insert acct;
        }
    }
    /*
    static testMethod void tetsBeforeAccountUpdate() {
        Util.isTestnonGethealthyCode = true;
        //AccountManagement 10%
        //beforeAccountUpdate.trigger 57%
        test.startTest();
        Set<String> mySet = new Set<String>();
        mySet.add('beforeAccountInsert');
        mySet.add('afterAccountInsert');
        mySet.add('beforeAccountUpdate');
        mySet.add('afterAccountUpdate');
        byPassHelper(mySet);
        
        User objUser = [Select Id,Contact.Account.Theater__c,Contact.Account.Territory__c from User where Profile.Name like 'Partner%' AND isActive=true limit 1];
        System.runAs(objUser){
        Account acct = new Account();
        acct.Name = 'Test123456888999';
        acct.Type = 'Residential';
        acct.RSM_Discretionary_Adj__c = 5;
        acct.BillingCity = 'DeSoto';
        acct.BillingStreet = 'Main Street';
        acct.BillingState = 'AZ';
        acct.BillingCountry = 'United States';
        acct.BillingPostalCode = '751234';
        acct.Opp_Convert_Rate__c = 70;
        acct.Theater__c='North America';
        acct.RecordTypeId = AccountHandlerUtilities.PartnerRecTypeId;
        acct.Status__c = 'nonActive';
        acct.Online_Order_Access__c = true;
        acct.Oracle_Account_Number__c='1234';
        insert acct;
        
            acct.Status__c ='Active';
            update acct;
        test.stopTest();
                    }
    }
    
    static testMethod void tetsBeforeAccountInsert() {
        Util.isTestnonGethealthyCode = true;
        //beforeAccountInsert.trigger
        //AccountUpdates.cls--91
        //afterInsertUpdateAccSIC.trigger-57
        test.startTest();
        Set<String> mySet = new Set<String>();
        mySet.add('beforeAccountInsert');
        mySet.add('afterAccountInsert');
        mySet.add('beforeAccountUpdate');
        mySet.add('afterAccountUpdate');
        mySet.add('afterInsertUpdateAccSIC');
        
        
        byPassHelper(mySet);
        User objUser = [Select Id,Contact.Account.Theater__c,Contact.Account.Territory__c from User where Profile.Name like 'Partner%' AND isActive=true limit 1];
        System.runAs(objUser){
        Account acct = new Account();
        acct.Name = 'Test123456888999';
        acct.Type = 'Residential';
        acct.RSM_Discretionary_Adj__c = 5;
        acct.BillingCity = 'DeSoto';
        acct.BillingStreet = 'Main Street';
        acct.BillingState = 'AZ';
        acct.BillingCountry = 'United States';
        acct.BillingPostalCode = '751234';
        acct.Opp_Convert_Rate__c = 70;
        acct.Theater__c='North America';
        acct.RecordTypeId = AccountHandlerUtilities.PartnerRecTypeId;
        acct.Status__c = 'nonActive';
        acct.Online_Order_Access__c = true;
        acct.Oracle_Account_Number__c='1234';
        
       Account acct1 = new Account();
        acct1.Name = 'Test123456888999';
        acct1.Type = 'Residential';
        acct1.RSM_Discretionary_Adj__c = 5;
        acct1.BillingCity = 'DeSoto';
        acct1.BillingStreet = 'Main Street';
        acct1.BillingState = 'AZ';
        acct1.BillingCountry = 'United States';
        acct1.BillingPostalCode = '751234';
        acct1.Opp_Convert_Rate__c = 70;
        acct1.Theater__c='North America';
        acct1.RecordTypeId = AccountHandlerUtilities.PartnerRecTypeId;
        acct1.Status__c = 'nonActive';
        acct1.Online_Order_Access__c = true;
        acct1.Oracle_Account_Number__c='1234';
            
        
            
            list<Account> listAccount = new list<Account>();
            listAccount.add(acct);
            listAccount.add(acct1);
            insert listAccount;
            SIC__c test = new SIC__c();
            test.SPWR_Industry_Type__c ='Manufacturing Facility';
            test.First_Level__c ='10 METAL MINING';
            test.Second_Level__c ='104 GOLD AND SILVER ORES';
            test.Third_Level__c  ='1044 SILVER ORES';
            test.SIC_Code__c = acct1.Id;
            insert test;
            
            acct1.Sic = acct1.Id;
            update acct1;
            AccountUpdates.met();
        //insert acct;
        }
        test.stopTest();
    }
   
    static testMethod void tetsAccountCreateShipBillTos() {
        Util.isTestnonGethealthyCode = true;
        //AccountServices 78%
        //AccountCreateShipBillTos.trigger 57%
        //UpdatePrimaryContactDetails.trigger 91%
        test.startTest();
        Set<String> mySet = new Set<String>();
        mySet.add('AccountCreateShipBillTos');
        mySet.add('UpdatePrimaryContactDetails');
        byPassHelper(mySet);
        User objUser = [Select Id,Contact.Account.Theater__c,Contact.Account.Territory__c from User where Profile.id ='00e80000001SqIlAAK' AND isActive=true limit 1];
        System.runAs(objUser){
        Account acct = new Account();
        acct.Name = 'Test123456888999';
        acct.Type = 'Residential';
        acct.RSM_Discretionary_Adj__c = 5;
        acct.BillingCity = 'DeSoto';
        acct.BillingStreet = 'Main Street';
        acct.BillingState = 'AZ';
        acct.BillingCountry = 'United States';
        acct.BillingPostalCode = '751234';
        
            
        acct.ShippingCity = 'DeSoto';
        acct.ShippingStreet = 'Main Street';
        acct.ShippingState = 'AZ';
        acct.ShippingCountry = 'United States';
        acct.ShippingPostalCode = '751234';
        acct.Opp_Convert_Rate__c = 70;
        acct.Theater__c='North America';
        acct.RecordTypeId = AccountHandlerUtilities.ResidentialRecTypeId;
        acct.Status__c = 'nonActive';
        acct.Online_Order_Access__c = true;
        acct.Oracle_Account_Number__c='1234';
        acct.Oracle_Shipping_County__c ='Cumming';
        acct.Oracle_County__c ='Cumming';
        insert acct;
            Contact obj= new Contact();
            obj.Phone='123-456-12345';
            obj.lastName ='test';
            obj.Email='ss@gmail.com';
            obj.MailingCity = 'Irving';
            obj.MailingStreet = 'Main Street';
            obj.MailingState = 'TX';
            obj.MailingCountry = 'United States';
            obj.MailingPostalCode = '75038';
            obj.AccountId = acct.Id;
            obj.primary__c = true;
            insert obj;
       
        acct.BillingCity = 'Irving';
        acct.BillingStreet = 'Main Street';
        acct.BillingState = 'TX';
        acct.BillingCountry = 'United States';
        acct.BillingPostalCode = '75038';
            
        acct.ShippingCity = 'Irving';
        acct.ShippingStreet = 'Main Street';
        acct.ShippingState = 'TX';
        acct.ShippingCountry = 'United States';
        acct.BillingPostalCode = '75038';
        acct.Geolocation__Latitude__s=12.00;
        acct.Geolocation__Longitude__s =23.00;
        acct.Oracle_Shipping_County__c ='Irving';
        update acct;
            test.stopTest();
        }
    }
     static testMethod void testInsertGeo() {
         Util.isTestnonGethealthyCode = true;
         //InsertGeo 83%
        test.startTest();
        Set<String> mySet = new Set<String>();
        mySet.add('InsertGeo');
        byPassHelper(mySet);
         Account objP1 = new Account(Name = 'test22',recordtypeId=AccountHandlerUtilities.PartnerRecTypeId, lat__c=37.349462,log__c=-121.9985126,Geo__Latitude__s=null,BillingStreet='Adriatic Way', BillingCity='Santa Clara', BillingState='CA', BillingPostalCode='95051', BillingCountry='United States',Theater__c ='North America',Phone='1234567895',Type='Elite-Partner-Combo');
         insert objP1;
         test.stopTest();
     }
    */ 
    public static void byPassHelper(set<String> mySet){
        Util.isTestnonGethealthyCode = true;
        list<Trigger_By_Pass__c> listTrigger =new list<Trigger_By_Pass__c>();
         for(Trigger_By_Pass__c custSettingTriggerByPass  : Trigger_By_Pass__c.getAll().values()){
             if(mySet.contains(custSettingTriggerByPass.Name)){
                 custSettingTriggerByPass.Is_Active__c=true;
             }else
                 custSettingTriggerByPass.Is_Active__c=false;
             listTrigger.add(custSettingTriggerByPass);
         }
        System.debug('--------------listTrigger'+listTrigger);
        update listTrigger;
    }
    
}